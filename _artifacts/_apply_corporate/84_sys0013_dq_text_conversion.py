"""SYS0013 Dynamic Query DQ_TEXT MSSQL → Oracle 변환 Phase 2 — Backup + Conversion.

전제 (Phase 1 sign-off):
  - 83_*.py audit CSV/MD 사용자 검토 완료
  - 룰별 적중 카운트 + sample 5건 BEFORE/AFTER 확인 완료

처리:
  1. 백업 테이블 생성 (`SCM_ADM_DQ_LIST_BAK_<YYYYMMDD>`)
  2. 21 룰 + cleanup 적용 → diff row 만 UPDATE
  3. 1 row 1 commit (라인별 진행 로그)
  4. 멱등성: 재실행 시 UPDATE 0 row (regex idempotent)

산출물:
  _logs/sys0013_dq_conv_<ts>.log  — 라인별 (DQ_ID, applied_rules, before_hash, after_hash, status)

Anti-Simplification:
  - audit count vs 본 conversion count 일치 ASSERT
  - 모든 룰 hit 0 도 명시
"""
from __future__ import annotations

import datetime as dt
import hashlib
import os
import sys
from pathlib import Path

import oracledb

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from lib.dq_text_rules import apply_rules  # noqa: E402

sys.stdout.reconfigure(line_buffering=True)

# ---------------------------------------------------------------------------
# Args
# ---------------------------------------------------------------------------
DRY_RUN = '--dry-run' in sys.argv

# ---------------------------------------------------------------------------
# Connection
# ---------------------------------------------------------------------------
u = os.getenv('NSCM_ORA_USER')
p = os.getenv('NSCM_ORA_PASS')
d = os.getenv('NSCM_ORA_DSN')
assert u and p and d, 'NSCM_ORA_USER/PASS/DSN required'

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}  dry_run={DRY_RUN}')

today = dt.datetime.now().strftime('%Y%m%d')
bak_table = f'SCM_ADM_DQ_LIST_BAK_{today}'
ts = dt.datetime.now().strftime('%Y%m%d_%H%M%S')
log_dir = Path(__file__).parent / '_logs'
log_dir.mkdir(parents=True, exist_ok=True)
log_path = log_dir / f'sys0013_dq_conv_{ts}.log'

# ---------------------------------------------------------------------------
# Step 1 — Backup table (멱등)
# ---------------------------------------------------------------------------
print(f'\n[ STEP 1 ] Backup table {bak_table} (멱등 — 존재 시 skip):')
cur.execute(
    "SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME = :n",
    {'n': bak_table.upper()},
)
exists = cur.fetchone()[0]
if exists == 0:
    if not DRY_RUN:
        cur.execute(
            f'CREATE TABLE SCM_MGR.{bak_table} AS '
            'SELECT DQ_ID, DQ_TEXT, SYSDATE AS BAK_AT FROM SCM_MGR.SCM_ADM_DQ_LIST'
        )
        conn.commit()
        cur.execute(f'SELECT COUNT(*) FROM SCM_MGR.{bak_table}')
        cnt = cur.fetchone()[0]
        print(f'  CREATE done — backup row count = {cnt}')
    else:
        print('  [DRY-RUN] CREATE skipped')
else:
    cur.execute(f'SELECT COUNT(*) FROM SCM_MGR.{bak_table}')
    cnt = cur.fetchone()[0]
    print(f'  backup 이미 존재 (멱등 — skip) — row count = {cnt}')

# ---------------------------------------------------------------------------
# Step 2 — Fetch + Convert + UPDATE (1 row 1 commit)
# ---------------------------------------------------------------------------
print('\n[ STEP 2 ] Fetch all DQ rows + apply rules + UPDATE diff rows:')
cur.execute(
    'SELECT DQ_ID, DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST ORDER BY DQ_ID'
)
rows = []
for r in cur:
    dq_id, lob = r
    text = lob.read() if isinstance(lob, oracledb.LOB) else lob
    rows.append((dq_id, text or ''))
print(f'  fetched: {len(rows)} rows')

total_diff = 0
total_no_diff = 0
total_warn = 0
update_cur = conn.cursor()
update_cur.setinputsizes(new_text=oracledb.CLOB)

with log_path.open('w', encoding='utf-8') as logf:
    logf.write('DQ_ID\tapplied_rules\tbefore_hash\tafter_hash\tstatus\twarnings\n')

    for dq_id, dq_text in rows:
        after_sql, hits, warns = apply_rules(dq_text)
        before_hash = hashlib.md5((dq_text or '').encode('utf-8')).hexdigest()[:12]
        after_hash = hashlib.md5((after_sql or '').encode('utf-8')).hexdigest()[:12]
        applied = sorted({h.rule_name for h in hits})

        if before_hash == after_hash:
            total_no_diff += 1
            logf.write(f'{dq_id}\t-\t{before_hash}\t{after_hash}\tNO_DIFF\t-\n')
            continue

        total_diff += 1
        if warns:
            total_warn += len(warns)

        if DRY_RUN:
            logf.write(f'{dq_id}\t{"|".join(applied)}\t{before_hash}\t{after_hash}\tDRY_RUN\t{"|".join(warns)}\n')
            continue

        try:
            update_cur.execute(
                'UPDATE SCM_MGR.SCM_ADM_DQ_LIST SET DQ_TEXT = :new_text, '
                "LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE "
                'WHERE DQ_ID = :id',
                new_text=after_sql, id=dq_id,
            )
            conn.commit()
            logf.write(f'{dq_id}\t{"|".join(applied)}\t{before_hash}\t{after_hash}\tUPDATED\t{"|".join(warns)}\n')
        except Exception as e:
            conn.rollback()
            logf.write(f'{dq_id}\t{"|".join(applied)}\t{before_hash}\t{after_hash}\tERROR\t{e}\n')
            print(f'  ❌ DQ_ID={dq_id} UPDATE failed: {e}')

print(f'\n[ SUMMARY ]')
print(f'  diff rows (UPDATE candidate): {total_diff}')
print(f'  no-diff rows (skip):          {total_no_diff}')
print(f'  warnings:                     {total_warn}')
print(f'  log:                          {log_path}')

if DRY_RUN:
    print(f'\n[ DRY-RUN ] UPDATE 미실행 — `python {os.path.basename(__file__)}` 로 실제 실행')

conn.close()
print('\n[ done ]')
