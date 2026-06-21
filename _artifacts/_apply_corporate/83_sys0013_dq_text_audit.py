"""SYS0013 Dynamic Query DQ_TEXT MSSQL → Oracle 변환 Phase 1 — Audit (read-only).

목적:
  사내 SCM_ADM_DQ_LIST 의 107 row DQ_TEXT 본문에 21 룰 dry-run → 룰별 적중 인벤토리 + CSV/MD 산출.

산출물:
  _logs/sys0013_dq_audit_<YYYYMMDD_HHMMSS>.csv   — (DQ_ID, rule_name, hit_count, before_snippet, after_preview)
  _logs/sys0013_dq_audit_<YYYYMMDD_HHMMSS>.md    — 룰별 총 적중·영향 DQ_ID 갯수 요약

사용자 인계:
  CSV 의 before/after_preview 5건 sample 검토 후 Phase 2 진행 승인.

룰 출처: lib/dq_text_rules.py (21 룰, anti-simplification 의무).
"""
from __future__ import annotations

import csv
import datetime as dt
import os
import sys
from collections import defaultdict
from pathlib import Path

import oracledb

# lib import
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from lib.dq_text_rules import RULES, apply_rules, dry_run, get_rule_catalog  # noqa: E402

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

# ---------------------------------------------------------------------------
# Fetch all 107 DQ rows
# ---------------------------------------------------------------------------
print('\n[ FETCH ] SCM_ADM_DQ_LIST 전수 (107 expected):')
cur.execute(
    'SELECT DQ_ID, DQ_NAME, VALID_YN, DQ_TEXT '
    'FROM SCM_MGR.SCM_ADM_DQ_LIST ORDER BY DQ_ID'
)
rows = []
for r in cur:
    dq_id, dq_name, valid_yn, dq_text_lob = r
    dq_text = dq_text_lob.read() if isinstance(dq_text_lob, oracledb.LOB) else dq_text_lob
    rows.append((dq_id, dq_name, valid_yn, dq_text or ''))
print(f'  fetched: {len(rows)} rows')

# ---------------------------------------------------------------------------
# Dry-run 21 rules per row
# ---------------------------------------------------------------------------
ts = dt.datetime.now().strftime('%Y%m%d_%H%M%S')
log_dir = Path(__file__).parent / '_logs'
log_dir.mkdir(parents=True, exist_ok=True)

csv_path = log_dir / f'sys0013_dq_audit_{ts}.csv'
md_path = log_dir / f'sys0013_dq_audit_{ts}.md'

# 카운터
rule_total_hits: dict = defaultdict(int)  # 룰별 총 적중 횟수
rule_dq_ids: dict = defaultdict(set)  # 룰별 영향 DQ_ID 집합
oneline_dq_ids: list = []  # 1줄 SQL DQ_ID
total_rows_with_hits = 0
total_warnings = 0
warning_log: list = []

with csv_path.open('w', newline='', encoding='utf-8-sig') as f:
    writer = csv.writer(f)
    writer.writerow([
        'DQ_ID', 'DQ_NAME', 'VALID_YN',
        'ROW_HIT_COUNT', 'APPLIED_RULES',
        'BEFORE_PREVIEW_200', 'AFTER_PREVIEW_200',
        'WARNINGS',
    ])

    for dq_id, dq_name, valid_yn, dq_text in rows:
        if dq_text is None:
            continue
        # 1줄 SQL 검출
        if '\n' not in dq_text and len(dq_text) > 120:
            oneline_dq_ids.append(dq_id)

        after_sql, hits, warns = apply_rules(dq_text)
        if not hits and not warns:
            continue

        total_rows_with_hits += 1
        for h in hits:
            rule_total_hits[h.rule_name] += 1
            rule_dq_ids[h.rule_name].add(dq_id)

        if warns:
            total_warnings += len(warns)
            warning_log.extend([(dq_id, w) for w in warns])

        writer.writerow([
            dq_id, dq_name, valid_yn,
            len(hits),
            '|'.join(sorted({h.rule_name for h in hits})),
            (dq_text or '')[:200].replace('\n', '\\n'),
            (after_sql or '')[:200].replace('\n', '\\n'),
            '|'.join(warns),
        ])

print(f'\n[ CSV ] {csv_path} ({total_rows_with_hits} affected rows)')

# ---------------------------------------------------------------------------
# Markdown summary
# ---------------------------------------------------------------------------
with md_path.open('w', encoding='utf-8') as f:
    f.write(f'# SYS0013 DQ_TEXT Audit — {ts}\n\n')
    f.write(f'- 사내 connection: `{d}`\n')
    f.write(f'- 전수 fetch row: **{len(rows)}** (기대 107)\n')
    f.write(f'- 적용 룰 후 변경되는 row: **{total_rows_with_hits}** / {len(rows)}\n')
    f.write(f'- 1줄 SQL (>120 char, no \\n) row: **{len(oneline_dq_ids)}** → pretty_break 대상\n')
    f.write(f'- 경고: **{total_warnings}** (룰 cross-check 불일치)\n\n')

    f.write('## 1. 룰별 적중 인벤토리\n\n')
    f.write('| # | rule_name | category | total_hits | affected_DQ_IDs | description |\n')
    f.write('|---|---|---|---:|---:|---|\n')
    catalog = {r['name']: r for r in get_rule_catalog()}
    for i, r in enumerate(RULES, start=1):
        n = r.name
        f.write(f'| {i} | {n} | {r.category} | {rule_total_hits[n]} | {len(rule_dq_ids[n])} | {r.description} |\n')
    # Cleanup (pretty_break) 추가 row
    f.write(f'| 22 | Z22_PRETTY_BREAK | cleanup | {len(oneline_dq_ids)} | {len(oneline_dq_ids)} | 1줄 SQL (>120 char) → SQL 키워드 앞 \\n 삽입 |\n')

    f.write('\n## 2. Anti-Simplification 자가 점검\n\n')
    f.write('- 21 룰 + 1 cleanup = **22 룰 전수 적용** (선택 누락 0)\n')
    f.write(f'- 룰 self cross-check 경고: {total_warnings} 건\n')
    if warning_log:
        f.write('\n경고 상세 (상위 20):\n\n')
        for dq_id, w in warning_log[:20]:
            f.write(f'- DQ_ID={dq_id}: {w}\n')

    f.write('\n## 3. 1줄 SQL DQ_ID 인벤토리 (pretty_break 대상)\n\n')
    if oneline_dq_ids:
        ids_str = [str(x) for x in oneline_dq_ids]
        chunks = [ids_str[i:i + 10] for i in range(0, len(ids_str), 10)]
        for c in chunks:
            f.write('- ' + ', '.join(c) + '\n')
    else:
        f.write('(없음 — 모든 SQL 이 이미 multi-line)\n')

    f.write('\n## 4. Phase 2 진행 게이트 (사용자 sign-off)\n\n')
    f.write('1. CSV 의 BEFORE_PREVIEW vs AFTER_PREVIEW 임의 5건 sample 검토\n')
    f.write('2. 잘못된 변환 발견 시 룰 disable 또는 guard 보강 후 audit 재실행\n')
    f.write('3. sign-off 후 `84_sys0013_dq_text_conversion.py` 실행 (백업 + UPDATE)\n')
    f.write('4. 변환 적용 row 수 = 본 audit 의 affected row count 와 정확히 일치해야 함 (cross-check)\n')

print(f'[ MD  ] {md_path}')

# ---------------------------------------------------------------------------
# Console summary
# ---------------------------------------------------------------------------
print('\n[ SUMMARY ] 룰별 hit (descending):')
sorted_rules = sorted(rule_total_hits.items(), key=lambda x: -x[1])
for n, c in sorted_rules:
    print(f'  {n:<32} hits={c:>4}  affected_DQ_IDs={len(rule_dq_ids[n])}')
if not sorted_rules:
    print('  (모든 룰 hit=0 — 변환 불필요 / 사용자 검토 의무)')

print(f'\n[ done ] Audit 완료. 사용자 sign-off 후 Phase 2 진행.')
conn.close()
