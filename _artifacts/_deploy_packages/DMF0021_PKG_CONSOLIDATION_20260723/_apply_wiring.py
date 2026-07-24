# -*- coding: utf-8 -*-
"""DMF0021 배선 전환: API_M.API_URL standalone->PKG한정명 + PROC_M PKG한정 등록(standalone 행 복제)."""
import os, io, oracledb
BASE = os.path.dirname(os.path.abspath(__file__))
conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()

MAP = {  # standalone -> PKG한정명
 "DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX":"PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX",
 "DMF0021_GET_SPREAD_TITLE":"PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE",
 "DMF0021_GET_SALES_PLAN_MEASUREINFO":"PKG_DMF0021.P_DMF0021_GET_SALES_PLAN_MEASUREINFO",
 "DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL":"PKG_DMF0021.P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL",
}

sqls=[]
for sa, pk in MAP.items():
    # 1) API_M
    cur.execute("""SELECT API_ID FROM SCM_ADM_API_M WHERE UPPER(API_URL)=:s""", s=sa)
    aids=[r[0] for r in cur.fetchall()]
    cur.execute("""UPDATE SCM_ADM_API_M SET API_URL=:p, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
       WHERE UPPER(API_URL)=:s""", p=pk, s=sa)
    print(f"API_M {sa} -> {pk}: {cur.rowcount} rows (API_IDs={aids})")
    # 2) PROC_M clone (standalone -> PKG한정)
    cur.execute("""MERGE INTO SCM_ADM_PROC_M t USING (
        SELECT :pk AS PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD
          FROM SCM_ADM_PROC_M WHERE PROC_NM=:sa ) s
      ON (t.PROC_NM=s.PROC_NM AND t.COL_NM=s.COL_NM AND t.COL_TP_CD=s.COL_TP_CD)
      WHEN MATCHED THEN UPDATE SET t.DATA_TP_CD=s.DATA_TP_CD, t.SORT_ORD=s.SORT_ORD,
        t.LAST_UPDATED_BY='admin', t.LAST_UPDATE_DATE=SYSDATE
      WHEN NOT MATCHED THEN INSERT (PROC_NM,COL_NM,DATA_TP_CD,COL_TP_CD,SORT_ORD,
        CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
      VALUES (s.PROC_NM,s.COL_NM,s.DATA_TP_CD,s.COL_TP_CD,s.SORT_ORD,'admin',SYSDATE,'admin',SYSDATE)""",
      pk=pk, sa=sa)
    print(f"PROC_M clone {pk}: {cur.rowcount} rows")
conn.commit()

# 검증: PROC_M PKG한정 카운트 = ALL_ARGUMENTS(멤버) 카운트
print("\n== 검증: PROC_M PKG한정 vs ALL_ARGUMENTS ==")
for sa,pk in MAP.items():
    mem = "P_"+sa
    cur.execute("SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM=:p", p=pk)
    pm=cur.fetchone()[0]
    cur.execute("""SELECT COUNT(*) FROM all_arguments WHERE owner='SCM_MGR' AND package_name='PKG_DMF0021'
       AND object_name=:m AND argument_name IS NOT NULL""", m=mem)
    aa=cur.fetchone()[0]
    print(f"  {pk}: PROC_M={pm} ALL_ARGS={aa} {'OK' if pm==aa else 'MISMATCH'}")

# 잔존 standalone 배선 참조 0 확인
print("\n== 잔존 standalone API_M 참조 ==")
cur.execute("""SELECT API_URL, COUNT(*) FROM SCM_ADM_API_M WHERE UPPER(API_URL) IN (
   'DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX','DMF0021_GET_SPREAD_TITLE',
   'DMF0021_GET_SALES_PLAN_MEASUREINFO','DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL') GROUP BY API_URL""")
rows=cur.fetchall(); print("  ", rows if rows else "없음(전환 완료)")
