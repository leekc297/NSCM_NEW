"""SYS0013 DQ_ID=7 SQL manual fix — STRING_SPLIT/DATEDIFF/CONVERT 사람 검토 row.

배경:
  사용자 보고 (2026-06-21): "7번 Row 실행 시 sql error 발생"
  진단:
    - DQ_ID=7 본문에 자동 변환 불가 marker 3종 잔존:
      1. STRING_SPLIT(B.OWNER, ',') (2회) — UNION ALL 두번째 SELECT 안 INNER JOIN ON 절
      2. DATEDIFF(WEEK, 0, X) (4회) — DATEADD 와 결합된 주의 시작일 계산
      3. CONVERT(VARCHAR, ..., 112) (2회) — VARCHAR 사이즈 없는 + 중첩 paren (regex 한계)

수동 변환:
  1. CONVERT(VARCHAR, DATEADD(WEEK, DATEDIFF(WEEK, 0, SYSDATE-7), 7), 112)
       → TO_CHAR(TRUNC(SYSDATE - 7, 'IW'), 'YYYYMMDD')
     AS-IS 의도: 지난주의 월요일 (ISO Week 시작일) YYYYMMDD 형식
     MSSQL: DATEDIFF(WEEK, 0, X) — 0 = '1900-01-01' Monday. → 주 차이.
            DATEADD(WEEK, N, 7) — 7 = '1900-01-08' Monday → X 가 속한 주의 월요일.
     Oracle TRUNC(dt, 'IW') = ISO Week 의 월요일.

  2. STRING_SPLIT(B.OWNER, ',') 첫 token 만 매칭 → REGEXP_SUBSTR(B.OWNER, '[^,]+', 1, 1)
     AS-IS: SELECT TOP 1 TOKEN FROM STRING_SPLIT(B.OWNER, ',') = 첫 token
     Oracle: REGEXP_SUBSTR(B.OWNER, '[^,]+', 1, 1)

  3. Marker comments 모두 제거 (사람 후속 검토 완료 표시).

Anti-Simplification:
  - 이 row 만 manual fix (다른 row 무영향)
  - 백업 테이블 SCM_ADM_DQ_LIST_BAK_20260621 에 원본 보존 (rollback 가능)
  - SP 직접 호출 검증 의무
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d, 'NSCM_ORA_USER/PASS/DSN required'

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

# 현재 SQL fetch
cur.execute('SELECT DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST WHERE DQ_ID=7')
lob = cur.fetchone()[0]
current = lob.read() if isinstance(lob, oracledb.LOB) else lob
print(f'\n[ PRE ] DQ_ID=7 length: {len(current)}')

# 변환 1 — CONVERT(VARCHAR, DATEADD..., 112) → TO_CHAR(TRUNC(SYSDATE-7, 'IW'), 'YYYYMMDD')
# 원본 marker comment 포함 패턴
old_date = "CONVERT(VARCHAR, DATEADD(WEEK, /*DATEDIFF_NEEDS_UNIT_SPECIFIC_CALC*/DATEDIFF(WEEK, 0, (SYSDATE) + (-1*7) ), 7) , 112)"
new_date = "TO_CHAR(TRUNC(SYSDATE - 7, 'IW'), 'YYYYMMDD')"
n1 = current.count(old_date)
print(f'  CONVERT date pattern hits: {n1} (expected 2)')

# 변환 2 — STRING_SPLIT (SELECT TOP 1 TOKEN FROM ... ) → REGEXP_SUBSTR
old_split = "(SELECT /*+ TOP_CONVERTED_TO_FETCH_FIRST_1_ROWS_ONLY */ TOKEN FROM /*STRING_SPLIT_NEEDS_REGEXP_SUBSTR_CONNECT_BY*/STRING_SPLIT(B.OWNER, ','))"
new_split = "REGEXP_SUBSTR(B.OWNER, '[^,]+', 1, 1)"
n2 = current.count(old_split)
print(f'  STRING_SPLIT pattern hits: {n2} (expected 1)')

if n1 == 0 and n2 == 0:
    print('  이미 fix 적용됨 — skip (멱등)')
    sys.exit(0)

new_sql = current.replace(old_date, new_date).replace(old_split, new_split)
print(f'\n[ NEW ] length: {len(new_sql)}')

# UPDATE
upd = conn.cursor()
upd.setinputsizes(new_text=oracledb.CLOB)
upd.execute(
    "UPDATE SCM_MGR.SCM_ADM_DQ_LIST SET DQ_TEXT=:new_text, "
    "LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE DQ_ID=7",
    new_text=new_sql,
)
print(f'\n[ UPDATE ] rows: {upd.rowcount}')
conn.commit()
print('  COMMIT done')

# SP wrapper 검증
print('\n[ VERIFY ] SP wrapper 호출:')
rc1 = conn.cursor()
result_cursor = conn.cursor()
# parameterValues 없는 경우 시뮬레이션 — :PARAM* → '' 치환 (FE 패턴)
import re
sql_replaced = re.sub(r'[:@]PARAM[A-Z0-9_]*', "''", new_sql, flags=re.IGNORECASE)
try:
    cur.callproc('SCM_MGR.PKG_SYS0013.P_SYS0013_EXECUTE_QUERY', [sql_replaced, rc1, result_cursor])
    cols = [d[0] for d in rc1.description or []]
    print(f'  ✅ SP OK — cols={cols}  rows_sample={len(rc1.fetchmany(2))}')
except Exception as e:
    print(f'  ❌ SP ERROR: {e}')
    sys.exit(1)

conn.close()
print('\n[ done ]')
