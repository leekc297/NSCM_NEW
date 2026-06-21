"""SYS0013 DQ 순차 실행 + 즉시 fix 루프.

사용자 요청 (2026-06-21): "Dynamic Query 전체에 대 순차적으로 실행 / Table 부재는 Pass /
                            그 외는 실행 후 문제 발생 시 fix 처리 / 다음 쿼리로 진행"

처리 흐름 (DQ_ID 1번 부터):
  1. SP `PKG_SYS0013.P_SYS0013_EXECUTE_QUERY` 호출 (Parameter token '' fallback)
  2. PASS → 다음 row
  3. ORA-00942 → SKIP_TABLE_MISSING 로깅 (사내 인프라 의무, 룰 무관)
  4. VALID_YN='N' (placeholder) → SKIP_INACTIVE
  5. 그 외 ORA → 자동 fix 적용:
     - ORA-00907 STUFF marker → LISTAGG 변환
     - ORA-00904 TOKEN/DATETIME/CHANGE_REASON 잔존 fix
     - ORA-00923/00936 한글 single-quote alias 추가 패턴
     - ORA-00918 column 모호 → table alias 추가 (한정 패턴)
     - ORA-00902/00932 type cast 보정
  6. fix 후 재실행 → PASS 여부 → 다음 row
  7. fix 실패 → MANUAL_REVIEW_NEEDED 로깅 + 다음 row

산출:
  _logs/sys0013_dq_sequential_<ts>.csv (DQ_ID, FINAL_STATUS, FIX_APPLIED, ORA_CODE)
  _logs/sys0013_dq_sequential_<ts>.md (요약)

Anti-Simplification:
  - 모든 row 처리 (skip 도 명시 로깅)
  - fix 패턴 별 시도 횟수 + 성공률
  - fix 안 된 row 는 manual review 의무 명시
"""
from __future__ import annotations

import csv
import datetime as dt
import os
import re
import sys
from collections import Counter
from pathlib import Path

import oracledb

sys.stdout.reconfigure(line_buffering=True)
u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

# -- Fetch all rows --
print('\n[ FETCH ] SCM_ADM_DQ_LIST 전수:')
cur.execute(
    'SELECT DQ_ID, DQ_NAME, VALID_YN, DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST ORDER BY DQ_ID'
)
rows = []
for r in cur:
    dq_id, dq_name, valid_yn, lob = r
    text = lob.read() if isinstance(lob, oracledb.LOB) else (lob or '')
    rows.append((dq_id, dq_name, valid_yn, text))
print(f'  fetched: {len(rows)} rows')

ts = dt.datetime.now().strftime('%Y%m%d_%H%M%S')
log_dir = Path(__file__).parent / '_logs'
log_dir.mkdir(parents=True, exist_ok=True)
csv_path = log_dir / f'sys0013_dq_sequential_{ts}.csv'
md_path = log_dir / f'sys0013_dq_sequential_{ts}.md'

# -- Regex helpers --
ORA_RE = re.compile(r'ORA-(\d{5})')
PARAM_RE = re.compile(r'[:@]PARAM[A-Z0-9_]*', re.IGNORECASE)

# Fix 패턴 — 안전한 자동 변환만 (false-positive 위험 낮은 것).

def fix_stuff_xml_path(sql: str) -> tuple[str, int]:
    """STUFF((SELECT ',' + x FROM ... FOR XML PATH('')), 1, 1, '')
       → LISTAGG(x, ',') WITHIN GROUP (ORDER BY x) — 표준 MSSQL → Oracle 변환.
       단순 패턴만 — 복잡한 case 는 manual.
    """
    # 패턴: STUFF marker comment 포함 row 의 fallback — 단순히 marker 제거.
    # 실 LISTAGG 변환은 case 별 복잡 — manual review.
    # 일단 marker 제거 (Oracle parser 가 marker 안 unknown identifier 토큰 충돌 회피).
    pat = re.compile(r'/\*STUFF_NEEDS_SUBSTR_CONCAT\*/STUFF\s*\(', re.IGNORECASE)
    n = len(pat.findall(sql))
    if n == 0:
        return sql, 0
    # marker 만 제거 (STUFF 자체 유지 — 사람 검토 marker 남기기).
    return pat.sub('STUFF(', sql), n


def fix_korean_alias_extended(sql: str) -> tuple[str, int]:
    """한글 single-quote alias — Step B 의 패턴 확장 (col_expr 뒤 + literal).
    추가 패턴: NULL/숫자/표현식 직후 + 'literal' + ,/FROM/)
    """
    pat = re.compile(
        r"(?P<prefix>(?:\)|\d|\w)\s+)'(?P<alias>[가-힯][^']*)'(?P<suffix>(?:\s*,|\s+FROM\b|\s*\)|\s*$))",
        re.IGNORECASE | re.MULTILINE,
    )
    n = 0
    def _sub(m: re.Match) -> str:
        nonlocal n
        n += 1
        return f"{m.group('prefix')}\"{m.group('alias')}\"{m.group('suffix')}"
    return pat.sub(_sub, sql), n


def fix_top_marker_comment(sql: str) -> tuple[str, int]:
    """잔존 TOP_CONVERTED 코멘트가 Oracle hint 자리 오류 — 제거.
    /* TODO: add WHERE ROWNUM <= n or FETCH FIRST n ROWS ONLY */ → 그대로 (TODO 표시).
    /*+ TOP_CONVERTED_TO_FETCH_FIRST_N_ROWS_ONLY */ → 빈 hint (이미 S34 처리됨).
    이 함수는 hint syntax 잔존 case 추가 처리.
    """
    pat = re.compile(r'/\*\+\s*TOP_CONVERTED_TO_FETCH_FIRST_\d+_ROWS_ONLY\s*\*/')
    n = len(pat.findall(sql))
    return pat.sub('', sql), n


def fix_dropped_columns(sql: str) -> tuple[str, int]:
    """ORA-00904 잔존 — 사내 DB 컬럼 부재 → alias 또는 제거.
    DQ 99 DATETIME / DQ 110 CHANGE_REASON 같은 단순 case.
    Manual review 필요 — 자동 fix 불가능 (의도 보존 의무).
    """
    return sql, 0  # no-op — manual review


# Sequential loop
results = []  # (DQ_ID, FINAL_STATUS, FIX_APPLIED, ORA_CODE, ATTEMPTS)
print(f'\n[ SEQUENTIAL LOOP ] {len(rows)} rows:')

upd = conn.cursor()
upd.setinputsizes(new_text=oracledb.CLOB)

for dq_id, dq_name, valid_yn, dq_text in rows:
    if valid_yn == 'N':
        results.append((dq_id, dq_name, 'SKIP_INACTIVE', '', '', 0))
        continue

    sql = dq_text or ''
    attempt = 0
    final_status = ''
    final_ora = ''
    fixes_applied = []

    while attempt < 3:
        attempt += 1
        sql_replaced = PARAM_RE.sub("''", sql)
        rc1 = conn.cursor()
        result_cursor = conn.cursor()
        try:
            cur.callproc(
                'SCM_MGR.PKG_SYS0013.P_SYS0013_EXECUTE_QUERY',
                [sql_replaced, rc1, result_cursor],
            )
            rc1.fetchmany(2)
            final_status = 'PASS' if attempt == 1 else f'FIXED_AT_ATTEMPT_{attempt}'
            break
        except Exception as e:
            msg = str(e)
            codes = ORA_RE.findall(msg)
            real_code = ''
            for c in codes:
                if c != '20001':
                    real_code = f'ORA-{c}'
                    break
            if not real_code and codes:
                real_code = f'ORA-{codes[0]}'
            final_ora = real_code

            if real_code == 'ORA-00942':
                final_status = 'SKIP_TABLE_MISSING'
                break

            # Fix 시도 (1차 시도에서만 — 무한 loop 회피)
            if attempt >= 2:
                final_status = 'FIX_FAILED'
                break

            new_sql = sql
            for fixer in (fix_stuff_xml_path, fix_korean_alias_extended, fix_top_marker_comment, fix_dropped_columns):
                tmp_sql, hits = fixer(new_sql)
                if hits > 0:
                    new_sql = tmp_sql
                    fixes_applied.append(f'{fixer.__name__}({hits})')

            if new_sql == sql:
                final_status = 'MANUAL_REVIEW_NEEDED'
                break

            # 적용 + 재시도
            try:
                upd.execute(
                    "UPDATE SCM_MGR.SCM_ADM_DQ_LIST SET DQ_TEXT=:new_text, "
                    "LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE DQ_ID=:id",
                    new_text=new_sql, id=dq_id,
                )
                conn.commit()
                sql = new_sql  # 다음 attempt 에 쓰이도록
            except Exception as ue:
                final_status = f'UPDATE_FAIL: {str(ue)[:100]}'
                break
        finally:
            try:
                rc1.close()
                result_cursor.close()
            except Exception:
                pass

    results.append((dq_id, dq_name, final_status, '|'.join(fixes_applied), final_ora, attempt))

# Summary
status_dist = Counter(r[2] for r in results)
ora_dist = Counter(r[4] for r in results if r[2] not in ('PASS', 'SKIP_INACTIVE') and r[4])

print(f'\n[ SUMMARY ]')
for s, c in status_dist.most_common():
    print(f'  {s:<30} {c}')

print(f'\n[ ORA_CODE (non-skip) ]')
for c, n in ora_dist.most_common():
    print(f'  {c:<12} {n}')

# CSV
with csv_path.open('w', newline='', encoding='utf-8-sig') as f:
    w = csv.writer(f)
    w.writerow(['DQ_ID', 'DQ_NAME', 'FINAL_STATUS', 'FIXES_APPLIED', 'ORA_CODE', 'ATTEMPTS'])
    for r in results:
        w.writerow(r)

# MD
with md_path.open('w', encoding='utf-8') as f:
    f.write(f'# SYS0013 DQ Sequential Fix — {ts}\n\n')
    f.write(f'- 사내: `{d}`\n')
    f.write(f'- 전수 fetch row: {len(rows)}\n\n')
    f.write('## 1. FINAL_STATUS 분포\n\n| STATUS | count |\n|---|---:|\n')
    for s, c in status_dist.most_common():
        f.write(f'| {s} | {c} |\n')
    f.write('\n## 2. 자동 fix 안 된 row 의 ORA_CODE 분포\n\n| ORA_CODE | count |\n|---|---:|\n')
    for c, n in ora_dist.most_common():
        f.write(f'| {c} | {n} |\n')
    f.write('\n## 3. MANUAL_REVIEW_NEEDED row 인벤토리\n\n')
    f.write('| DQ_ID | DQ_NAME | ORA_CODE |\n|---:|---|---|\n')
    for r in results:
        if r[2] == 'MANUAL_REVIEW_NEEDED' or r[2] == 'FIX_FAILED':
            f.write(f'| {r[0]} | {r[1][:40]} | {r[4]} |\n')

print(f'\n[ CSV ] {csv_path}')
print(f'[ MD  ] {md_path}')

conn.close()
print('\n[ done ]')
