"""SYS0013 SAVE meta 등록 — API_M URL 정정 + PROC_M signature 3 SP 등록 (Stage 4).

배경:
  - 직전 작업: SP 3 종 작성 완료 (SAVE_QUERY_LIST / SAVE_COLUMNS / SAVE_PARAMETERS)
  - 그러나 API_M.API_URL 이 'SYS0013_SAVE_QUERY' 등 부재 SP 가리킴 → BE callProc 실패
  - PROC_M 미등록 → BE IN param 매핑 실패

변경:
  A. API_M UPDATE (3 row):
     - API_SCM0005_SAVE_QUERY      → 'PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST'
     - API_SCM0005_SAVE_COLUMNS    → 'PKG_SYS0013.P_SYS0013_SAVE_COLUMNS'
     - API_SCM0005_SAVE_PARAMETERS → 'PKG_SYS0013.P_SYS0013_SAVE_PARAMETERS'
  B. PROC_M MERGE (3 SP × 4 col = 12 row):
     - SAVE_QUERY_LIST: pData(CLOB,IN,1) / pUserId(VARCHAR,IN,2) / o_rc1(CURSOR,OUT,3) / O_RESULT_CURSOR(PROC_RESULT,OUT,4)
     - SAVE_COLUMNS:    동일
     - SAVE_PARAMETERS: 동일
  C. BTN_MPG_M + USER_GR_BTN 이미 등록 (이전 작업) — 확인만

멱등: UPDATE WHERE / MERGE WHEN NOT MATCHED.
"""
import os, sys, oracledb

sys.stdout.reconfigure(line_buffering=True)
u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

# -- A. API_M URL UPDATE --
print('\n[ STEP A ] API_M URL 정정 (3 row):')
api_urls = [
    ('API_SCM0005_SAVE_QUERY',      'PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST'),
    ('API_SCM0005_SAVE_COLUMNS',    'PKG_SYS0013.P_SYS0013_SAVE_COLUMNS'),
    ('API_SCM0005_SAVE_PARAMETERS', 'PKG_SYS0013.P_SYS0013_SAVE_PARAMETERS'),
]
for api_id, url in api_urls:
    cur.execute(
        "UPDATE SCM_MGR.SCM_ADM_API_M "
        "   SET API_URL=:url, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE "
        " WHERE API_ID=:api_id AND API_URL <> :url",
        url=url, api_id=api_id,
    )
    print(f'  {api_id:<32} → {url} (affected={cur.rowcount})')
conn.commit()

# POST-A
print('\n  POST audit:')
cur.execute("SELECT API_ID, API_URL FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'API_SCM0005_SAVE%' ORDER BY API_ID")
for r in cur.fetchall(): print(f'    {r}')

# -- B. PROC_M MERGE --
print('\n[ STEP B ] PROC_M signature 등록 (3 SP × 4 col):')
proc_sigs = [
    ('PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST', 'pData',          'CLOB',        'IN',  1),
    ('PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST', 'pUserId',        'VARCHAR',     'IN',  2),
    ('PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST', 'o_rc1',          'CURSOR',      'OUT', 3),
    ('PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST', 'O_RESULT_CURSOR','PROC_RESULT', 'OUT', 4),
    ('PKG_SYS0013.P_SYS0013_SAVE_COLUMNS',    'pData',          'CLOB',        'IN',  1),
    ('PKG_SYS0013.P_SYS0013_SAVE_COLUMNS',    'pUserId',        'VARCHAR',     'IN',  2),
    ('PKG_SYS0013.P_SYS0013_SAVE_COLUMNS',    'o_rc1',          'CURSOR',      'OUT', 3),
    ('PKG_SYS0013.P_SYS0013_SAVE_COLUMNS',    'O_RESULT_CURSOR','PROC_RESULT', 'OUT', 4),
    ('PKG_SYS0013.P_SYS0013_SAVE_PARAMETERS', 'pData',          'CLOB',        'IN',  1),
    ('PKG_SYS0013.P_SYS0013_SAVE_PARAMETERS', 'pUserId',        'VARCHAR',     'IN',  2),
    ('PKG_SYS0013.P_SYS0013_SAVE_PARAMETERS', 'o_rc1',          'CURSOR',      'OUT', 3),
    ('PKG_SYS0013.P_SYS0013_SAVE_PARAMETERS', 'O_RESULT_CURSOR','PROC_RESULT', 'OUT', 4),
]
total_ins = 0
for proc_nm, col_nm, data_tp, col_tp, sort_ord in proc_sigs:
    cur.execute(
        """
        MERGE INTO SCM_MGR.SCM_ADM_PROC_M tgt
        USING (SELECT :proc_nm AS PROC_NM, :col_nm AS COL_NM,
                      :data_tp AS DATA_TP_CD, :col_tp AS COL_TP_CD, :sort_ord AS SORT_ORD FROM DUAL) src
           ON (tgt.PROC_NM = src.PROC_NM AND tgt.COL_NM = src.COL_NM)
        WHEN NOT MATCHED THEN
          INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
                  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
          VALUES (src.PROC_NM, src.COL_NM, src.DATA_TP_CD, src.COL_TP_CD, src.SORT_ORD,
                  'admin', SYSDATE, 'admin', SYSDATE)
        """,
        proc_nm=proc_nm, col_nm=col_nm, data_tp=data_tp, col_tp=col_tp, sort_ord=sort_ord,
    )
    total_ins += cur.rowcount
conn.commit()
print(f'  total inserted: {total_ins} / 12')

# POST-B
print('\n  POST audit:')
cur.execute(
    "SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD "
    "FROM SCM_MGR.SCM_ADM_PROC_M "
    "WHERE PROC_NM LIKE 'PKG_SYS0013.P_SYS0013_SAVE%' ORDER BY PROC_NM, SORT_ORD"
)
for r in cur.fetchall(): print(f'    {r}')

# -- C. BTN_MPG_M / USER_GR_BTN 확인 --
print('\n[ STEP C ] BTN_MPG_M (main/columns/parameters SAVE):')
cur.execute(
    "SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0013' AND MNU_BTN_CD='SAVE' ORDER BY SHT_NM"
)
for r in cur.fetchall(): print(f'  {r}')

print('\n[ STEP C2 ] USER_GR_BTN (minyonglee1 SAVE 권한):')
cur.execute(
    "SELECT B.SHT_NM, B.MNU_BTN_CD, B.USE_YN "
    "FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M B "
    "JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M U ON U.USER_GR_ID=B.USER_GR_ID "
    "WHERE U.USER_ID='minyonglee1' AND B.MNU_ID='SYS0013' AND B.MNU_BTN_CD IN ('SAVE','INSERT','DELETE') "
    "ORDER BY B.SHT_NM, B.MNU_BTN_CD"
)
for r in cur.fetchall(): print(f'  {r}')

conn.close()
print('\n[ done ] Stage 4 meta 등록 완료.')
