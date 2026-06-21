"""SYS0013 Dynamic Query 107 row 전수 실행 audit (Phase A — read-only).

목적:
  사용자 요청 (2026-06-21): "1번부터 순차적으로 직접 실행해서 오류여부 확인 후 보완"
  사내 SP `PKG_SYS0013.P_SYS0013_EXECUTE_QUERY` 직접 호출로 107 row 전수 실행 → PASS/FAIL 분류.

처리:
  1. 107 row 전수 fetch (DQ_ID, DQ_NAME, DQ_TEXT).
  2. FE 정합 변환: re.sub(r'[:@]PARAM[A-Z0-9_]*', "''", sql)
     — 화면 handleExecute 의 Parameter 미입력 fallback 패턴.
  3. cur.callproc('PKG_SYS0013.P_SYS0013_EXECUTE_QUERY', [sql, rc1, result_cursor]).
     - 성공: cols = description, rows_sample = fetchmany(2).
     - 실패: SP 가 ORA-20001 으로 wrap → 메시지에서 실 ORA-xxxx + SQLERRM 추출.

산출:
  _logs/sys0013_dq_execute_audit_<YYYYMMDD_HHMMSS>.csv (전수 인벤토리)
  _logs/sys0013_dq_execute_audit_<YYYYMMDD_HHMMSS>.md (요약 + ORA_CODE 별 분포)

Anti-Simplification:
  - 107 row 전수 — 선택 누락 0.
  - ORA_CODE 별 분류 (단일 묶음 처리 금지).
  - PASS row 도 cols 인벤토리 (자동 변환 결과 검증).
"""
from __future__ import annotations

import csv
import datetime as dt
import os
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d, 'NSCM_ORA_USER/PASS/DSN required'

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

# -- Fetch all rows --
print('\n[ FETCH ] SCM_ADM_DQ_LIST 전수:')
cur.execute(
    'SELECT DQ_ID, DQ_NAME, DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST ORDER BY DQ_ID'
)
rows = []
for r in cur:
    dq_id, dq_name, lob = r
    text = lob.read() if isinstance(lob, oracledb.LOB) else (lob or '')
    rows.append((dq_id, dq_name, text))
print(f'  fetched: {len(rows)} rows')

# -- Setup logs --
ts = dt.datetime.now().strftime('%Y%m%d_%H%M%S')
log_dir = Path(__file__).parent / '_logs'
log_dir.mkdir(parents=True, exist_ok=True)
csv_path = log_dir / f'sys0013_dq_execute_audit_{ts}.csv'
md_path = log_dir / f'sys0013_dq_execute_audit_{ts}.md'

# -- ORA-xxxx extract regex --
ORA_CODE_RE = re.compile(r'ORA-(\d{5})')
SQLERRM_RE = re.compile(r'SQLERRM=([^/]+?)\s*/\s*BACKTRACE', re.DOTALL)

# -- Loop + callproc --
print(f'\n[ EXECUTE ] 107 row 직접 호출 (Parameter token → \'\' fallback):')
pass_count = 0
fail_count = 0
ora_code_dist: Counter = Counter()
ora_examples: dict = defaultdict(list)  # ORA_CODE → DQ_ID list (top 5)

with csv_path.open('w', newline='', encoding='utf-8-sig') as f:
    writer = csv.writer(f)
    writer.writerow([
        'DQ_ID', 'DQ_NAME', 'STATUS',
        'ORA_CODE', 'ORA_SQLERRM_HEAD200',
        'COL_COUNT', 'COL_NAMES_HEAD8', 'ROWS_SAMPLE',
    ])

    for dq_id, dq_name, dq_text in rows:
        # FE handleExecute 정합 — Parameter token 빈 문자열 fallback.
        sql = re.sub(r'[:@]PARAM[A-Z0-9_]*', "''", dq_text or '', flags=re.IGNORECASE)
        rc1 = conn.cursor()
        result_cursor = conn.cursor()
        try:
            cur.callproc('SCM_MGR.PKG_SYS0013.P_SYS0013_EXECUTE_QUERY', [sql, rc1, result_cursor])
            cols = [c[0] for c in (rc1.description or [])]
            sample = rc1.fetchmany(2)
            writer.writerow([
                dq_id, dq_name, 'PASS',
                '', '',
                len(cols), '|'.join(cols[:8]), len(sample),
            ])
            pass_count += 1
        except Exception as e:
            msg = str(e)
            # ORA-xxxx 추출 — SP wrap 의 -20001 안 실 ORA-xxxx 또는 직접 ORA-xxxx.
            codes = ORA_CODE_RE.findall(msg)
            real_code = ''
            for c in codes:
                if c != '20001':
                    real_code = f'ORA-{c}'
                    break
            if not real_code and codes:
                real_code = f'ORA-{codes[0]}'
            sqlerrm_m = SQLERRM_RE.search(msg)
            sqlerrm = sqlerrm_m.group(1).strip() if sqlerrm_m else msg.split('\n', 1)[0]
            writer.writerow([
                dq_id, dq_name, 'FAIL',
                real_code, sqlerrm[:200].replace('\n', '\\n'),
                '', '', '',
            ])
            fail_count += 1
            ora_code_dist[real_code] += 1
            if len(ora_examples[real_code]) < 5:
                ora_examples[real_code].append(dq_id)
        finally:
            try:
                rc1.close()
                result_cursor.close()
            except Exception:
                pass

print(f'\n  PASS: {pass_count}  FAIL: {fail_count}  total: {len(rows)}')

# -- Markdown summary --
with md_path.open('w', encoding='utf-8') as f:
    f.write(f'# SYS0013 DQ 전수 실행 Audit — {ts}\n\n')
    f.write(f'- 사내 connection: `{d}`\n')
    f.write(f'- 전수 fetch row: **{len(rows)}** (기대 107)\n')
    f.write(f'- **PASS**: {pass_count}\n')
    f.write(f'- **FAIL**: {fail_count}\n\n')

    f.write('## 1. ORA_CODE 별 분포 (FAIL row)\n\n')
    if ora_code_dist:
        f.write('| ORA_CODE | count | 영향 DQ_ID sample (top 5) |\n')
        f.write('|---|---:|---|\n')
        for code, n in ora_code_dist.most_common():
            sample = ', '.join(str(x) for x in ora_examples[code][:5])
            f.write(f'| {code or "(없음)"} | {n} | {sample} |\n')
    else:
        f.write('(전체 PASS — FAIL 없음)\n')

    f.write('\n## 2. Anti-Simplification 자가 점검\n\n')
    f.write('- 107 row 전수 callproc — 선택 누락 0\n')
    f.write('- Parameter token (`:PARAM*` / `@PARAM*`) → `\'\'` fallback (FE handleExecute 정합)\n')
    f.write('- ORA-20001 wrap 안 실 ORA-xxxx 추출 + SQLERRM head 200 char 보존\n')

    f.write('\n## 3. 다음 단계 (사용자 sign-off)\n\n')
    f.write('1. CSV 의 FAIL row sample 5건 검토 (ORA_SQLERRM_HEAD200)\n')
    f.write('2. 자동 룰 보강 가능 패턴 (5+ row 공통 ORA_CODE) 식별\n')
    f.write('3. manual fix 의무 row 식별 (단일 또는 2~3 row 특이 syntax)\n')
    f.write('4. 사내 인프라 부재 row 식별 (ORA-00942 등)\n')

print(f'\n[ CSV ] {csv_path}')
print(f'[ MD  ] {md_path}')

# -- Console preview --
print('\n[ TOP FAIL ORA_CODE ]')
for code, n in ora_code_dist.most_common(10):
    sample = ', '.join(str(x) for x in ora_examples[code][:5])
    print(f'  {code or "(없음)":<12} count={n:>3}  sample DQ_ID: {sample}')

conn.close()
print('\n[ done ]')
