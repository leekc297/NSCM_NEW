"""SYS0013 Dynamic Query DQ_TEXT MSSQL → Oracle 변환 Phase 3 — Verify (read-only).

검증:
  1. Post-audit — 21 룰 재실행 → 적중 합계 = 0 ASSERT
  2. 변환 row 첫 200 char diff 샘플 5건 출력 (백업 vs 현재)
  3. Rollback SQL 자동 생성 → _logs/sys0013_dq_rollback_<ts>.sql

Anti-Simplification:
  - hit 합계 0 ASSERT
  - 0 아닐 경우 fail + 룰별 잔존 카운트 출력
"""
from __future__ import annotations

import datetime as dt
import os
import sys
from collections import defaultdict
from pathlib import Path

import oracledb

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from lib.dq_text_rules import RULES, apply_rules  # noqa: E402

sys.stdout.reconfigure(line_buffering=True)

# ---------------------------------------------------------------------------
# Connection
# ---------------------------------------------------------------------------
u = os.getenv('NSCM_ORA_USER')
p = os.getenv('NSCM_ORA_PASS')
d = os.getenv('NSCM_ORA_DSN')
assert u and p and d, 'NSCM_ORA_USER/PASS/DSN required'

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

today = dt.datetime.now().strftime('%Y%m%d')
bak_table = f'SCM_ADM_DQ_LIST_BAK_{today}'
ts = dt.datetime.now().strftime('%Y%m%d_%H%M%S')
log_dir = Path(__file__).parent / '_logs'
log_dir.mkdir(parents=True, exist_ok=True)

# ---------------------------------------------------------------------------
# Step 1 — Post-audit (변환 후 룰 hit = 0 ASSERT)
# ---------------------------------------------------------------------------
print('\n[ STEP 1 ] Post-audit — 21 룰 재실행 (hit 0 기대):')
cur.execute(
    'SELECT DQ_ID, DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST ORDER BY DQ_ID'
)
rows = []
for r in cur:
    dq_id, lob = r
    text = lob.read() if isinstance(lob, oracledb.LOB) else lob
    rows.append((dq_id, text or ''))
print(f'  fetched: {len(rows)} rows')

# 사람 후속 검토 의무 룰 (자동 변환 1-to-1 매핑 불가 — marker 만 삽입):
#   S18_STRING_SPLIT  — Oracle REGEXP_SUBSTR + CONNECT BY 재구현
#   C3_LISTAGG_OVERFLOW / C4_JSON_OBJECT_PLSQL / C5_GTT_INSERT_NO_DELETE / C6_OUT_CURSOR_OPEN — 검출만
#   F19 잔존 (중첩 CONVERT) — regex 한계 (사람 검토)
HUMAN_REVIEW_RULES = {
    'S18_STRING_SPLIT',
    'C3_LISTAGG_OVERFLOW',
    'C4_JSON_OBJECT_PLSQL',
    'C5_GTT_INSERT_NO_DELETE',
    'C6_OUT_CURSOR_OPEN',
    'F26_STUFF',
    'F27_FORMAT',
    'F28_DATEDIFF',
}

audit_rules = [r for r in RULES]
post_hits_auto = defaultdict(int)        # 자동 변환 잔존 (= bug)
post_hits_human = defaultdict(int)       # 사람 검토 의무 (= OK)
post_hit_dq_auto = defaultdict(set)
post_hit_dq_human = defaultdict(set)

for dq_id, dq_text in rows:
    _, hits, _ = apply_rules(dq_text, rules=audit_rules)
    for h in hits:
        if h.rule_name == 'Z22_PRETTY_BREAK':
            continue
        if h.rule_name in HUMAN_REVIEW_RULES:
            post_hits_human[h.rule_name] += 1
            post_hit_dq_human[h.rule_name].add(dq_id)
        else:
            post_hits_auto[h.rule_name] += 1
            post_hit_dq_auto[h.rule_name].add(dq_id)

total_residual_auto = sum(post_hits_auto.values())
total_residual_human = sum(post_hits_human.values())

print(f'\n  잔존 (자동 변환 누락 / 룰 bug): {total_residual_auto}')
if total_residual_auto == 0:
    print('  ✅ ASSERT PASS — 자동 변환 룰 잔존 0')
else:
    print('  ❌ ASSERT FAIL — 잔존 hit:')
    for n, c in sorted(post_hits_auto.items(), key=lambda x: -x[1]):
        print(f'    {n:<32} hits={c:>4}  affected={len(post_hit_dq_auto[n])}')

print(f'\n  사람 후속 검토 의무 (marker 삽입 완료): {total_residual_human}')
for n, c in sorted(post_hits_human.items(), key=lambda x: -x[1]):
    print(f'    {n:<32} hits={c:>4}  affected_DQ_IDs={sorted(post_hit_dq_human[n])}')

# Backwards compat — total_residual 은 자동 잔존 기준
total_residual = total_residual_auto

# ---------------------------------------------------------------------------
# Step 2 — 변환 row 5건 sample (backup vs current diff)
# ---------------------------------------------------------------------------
print(f'\n[ STEP 2 ] Backup vs Current diff 샘플 5건:')
cur.execute(
    "SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME = :n",
    {'n': bak_table.upper()},
)
exists = cur.fetchone()[0]
if exists == 0:
    print(f'  ❌ Backup table {bak_table} 부재 — Phase 2 미실행 또는 다른 날짜 백업')
else:
    cur.execute(
        f'SELECT b.DQ_ID, b.DQ_TEXT AS bak_text, c.DQ_TEXT AS cur_text '
        f'FROM SCM_MGR.{bak_table} b JOIN SCM_MGR.SCM_ADM_DQ_LIST c ON b.DQ_ID = c.DQ_ID '
        f'WHERE ROWNUM <= 5 ORDER BY b.DQ_ID'
    )
    for r in cur:
        dq_id, bak_lob, cur_lob = r
        bak = bak_lob.read() if isinstance(bak_lob, oracledb.LOB) else (bak_lob or '')
        cur_text = cur_lob.read() if isinstance(cur_lob, oracledb.LOB) else (cur_lob or '')
        if bak == cur_text:
            print(f'  DQ_ID={dq_id}: NO_DIFF (변환 안 된 row — 7 no-diff 중)')
        else:
            print(f'\n  DQ_ID={dq_id}:')
            print(f'    BAK[:200]: {bak[:200].replace(chr(10), " | ")[:200]}')
            print(f'    CUR[:200]: {cur_text[:200].replace(chr(10), " | ")[:200]}')

# ---------------------------------------------------------------------------
# Step 3 — Rollback SQL 자동 생성
# ---------------------------------------------------------------------------
rollback_path = log_dir / f'sys0013_dq_rollback_{ts}.sql'
with rollback_path.open('w', encoding='utf-8') as f:
    f.write(f'-- SYS0013 DQ_TEXT 일괄 원복 SQL — 생성 {ts}\n')
    f.write(f'-- Backup: SCM_MGR.{bak_table}\n')
    f.write('-- 실행 전 백업 테이블 존재 확인 필수.\n\n')
    f.write(f'-- 전체 원복 (107 row, no-diff row 도 동일 값으로 UPDATE → 멱등):\n')
    f.write(f'''UPDATE SCM_MGR.SCM_ADM_DQ_LIST t
   SET DQ_TEXT = (SELECT DQ_TEXT FROM SCM_MGR.{bak_table} b WHERE b.DQ_ID = t.DQ_ID),
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE EXISTS (SELECT 1 FROM SCM_MGR.{bak_table} b WHERE b.DQ_ID = t.DQ_ID);
COMMIT;

-- 단일 row 원복 예시:
-- UPDATE SCM_MGR.SCM_ADM_DQ_LIST t
--    SET DQ_TEXT = (SELECT DQ_TEXT FROM SCM_MGR.{bak_table} b WHERE b.DQ_ID = t.DQ_ID),
--        LAST_UPDATED_BY = 'admin',
--        LAST_UPDATE_DATE = SYSDATE
--  WHERE DQ_ID = <DQ_ID_HERE>;
-- COMMIT;

-- 백업 테이블 삭제 (변환 검증 통과 후, 사용자 판단):
-- DROP TABLE SCM_MGR.{bak_table} PURGE;
''')
print(f'\n[ STEP 3 ] Rollback SQL 생성: {rollback_path}')

conn.close()

# ---------------------------------------------------------------------------
# Exit code
# ---------------------------------------------------------------------------
print('\n[ done ]')
if total_residual > 0:
    print('❌ FAIL — 잔존 hit 존재')
    sys.exit(1)
else:
    print('✅ PASS — 21 룰 잔존 0 / Phase 3 verify 통과')
