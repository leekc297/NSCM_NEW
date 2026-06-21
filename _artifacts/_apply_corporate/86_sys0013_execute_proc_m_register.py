"""SYS0013 Dynamic Query EXECUTE_QUERY SP signature 등록 (PROC_M).

배경:
  사용자 보고 (2026-06-21): "1 row 실행 시 동일 오류 발생 — code -9994"
  진단: PKG_SYS0013.P_SYS0013_EXECUTE_QUERY 가 SCM_ADM_PROC_M 에 미등록.
  → BE callProc 인프라가 JSON body {sqlText} → SP IN param 매핑 못함 → -9994.

기준 reference (`PKG_SYS0013.P_SYS0013_GET_QUERY_LIST` 동일 패턴):
  (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD)
  ('PKG_SYS0013.P_SYS0013_EXECUTE_QUERY', 'sqlText',           'VARCHAR',     'IN',  1)
  ('PKG_SYS0013.P_SYS0013_EXECUTE_QUERY', 'o_rc1',             'CURSOR',      'OUT', 2)
  ('PKG_SYS0013.P_SYS0013_EXECUTE_QUERY', 'O_RESULT_CURSOR',   'PROC_RESULT', 'OUT', 3)

SP body signature (PKG_SYS0013 BODY L4-9):
  PROCEDURE P_SYS0013_EXECUTE_QUERY
  (P_SQL_TEXT IN VARCHAR2, O_RC1 OUT SYS_REFCURSOR, O_RESULT_CURSOR OUT SYS_REFCURSOR)

JSON body key 'sqlText' → BE 자동 P_ prefix + UPPER_SNAKE = 'P_SQL_TEXT' 매핑.

DDL NOT NULL: PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD (DEFAULT 없음).

멱등: MERGE WHEN NOT MATCHED (재실행 시 추가 변경 0).
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d, 'NSCM_ORA_USER/PASS/DSN required'

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

# PRE
print('\n[ PRE-AUDIT ] PKG_SYS0013.P_SYS0013_EXECUTE_QUERY signature:')
cur.execute(
    "SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD "
    "FROM SCM_MGR.SCM_ADM_PROC_M "
    "WHERE PROC_NM='PKG_SYS0013.P_SYS0013_EXECUTE_QUERY' ORDER BY SORT_ORD"
)
pre = cur.fetchall()
if not pre:
    print('  (없음 — 신규 등록)')
else:
    for r in pre:
        print(f'  {r}')

# MERGE 3 rows
rows = [
    ('sqlText',         'VARCHAR',     'IN',  1),
    ('o_rc1',           'CURSOR',      'OUT', 2),
    ('O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 3),
]

print('\n[ MERGE ] 3 row 등록:')
inserted_total = 0
for col_nm, data_tp, col_tp, sort_ord in rows:
    cur.execute(
        """
        MERGE INTO SCM_MGR.SCM_ADM_PROC_M tgt
        USING (SELECT 'PKG_SYS0013.P_SYS0013_EXECUTE_QUERY' AS PROC_NM,
                      :col_nm AS COL_NM,
                      :data_tp AS DATA_TP_CD,
                      :col_tp AS COL_TP_CD,
                      :sort_ord AS SORT_ORD FROM DUAL) src
           ON (tgt.PROC_NM = src.PROC_NM AND tgt.COL_NM = src.COL_NM)
        WHEN NOT MATCHED THEN
          INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
          VALUES (src.PROC_NM, src.COL_NM, src.DATA_TP_CD, src.COL_TP_CD, src.SORT_ORD,
                  'admin', SYSDATE, 'admin', SYSDATE)
        """,
        col_nm=col_nm, data_tp=data_tp, col_tp=col_tp, sort_ord=sort_ord,
    )
    inserted_total += cur.rowcount
    print(f'  {col_nm:<20} {data_tp:<12} {col_tp:<4} sort={sort_ord}  inserted={cur.rowcount}')

conn.commit()
print(f'\n  COMMIT done — 총 {inserted_total} row inserted')

# POST
print('\n[ POST-AUDIT ] 등록 결과:')
cur.execute(
    "SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD "
    "FROM SCM_MGR.SCM_ADM_PROC_M "
    "WHERE PROC_NM='PKG_SYS0013.P_SYS0013_EXECUTE_QUERY' ORDER BY SORT_ORD"
)
for r in cur.fetchall():
    print(f'  {r}')

conn.close()
print('\n[ done ] PROC_M EXECUTE_QUERY signature 등록 완료.')
