import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding="utf-8",errors="replace")
sys.path.insert(0,r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info
u,p,d=conn_info(); con=oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
cur.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
cur.execute("DELETE FROM SCM_MGR.GT_DM22_SELECT_MEASURE")
cur.execute("""INSERT INTO SCM_MGR.GT_DM22_SELECT_MEASURE (MEASURE, SORT_ORDER_NO)
   SELECT COLUMN_NAME, SORT_ORDER_NO FROM SCM_MGR.SCM_MST_SHEET_MEASURE
    WHERE PROGRAM_ID='DMF0051' AND SHEET_NAME='Biz Plan Waterfall' AND VALID_YN='Y'""")
CAL="""INNER JOIN (SELECT CALENDAR_YYYY,CALENDAR_YYYYQQ,BASIS_YYYYMM FROM SCM_MGR.SCM_SYS_CALENDAR_M
  WHERE (BASIS_YYYYMM>='202608' AND BASIS_YYYYMM<='202702') GROUP BY CALENDAR_YYYY,CALENDAR_YYYYQQ,BASIS_YYYYMM) CAL
  ON CAL.BASIS_YYYYMM=A.YYYYMM"""
for nm,sql in {
 "후보3 단일버전 등치(리터럴)": f"""SELECT COUNT(*) FROM SCM_MGR.DM_PLN_BP_FCST_C A
   JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE=B.MEASURE {CAL}
   WHERE A.YYYYMM>='202608' AND A.YYYYMM<='202702' AND A.DIVISION_ID='40'
     AND A.VERSION_NO='BP_M_20260810_V001'""",
 "후보4 단일버전 등치(바인드)": f"""SELECT COUNT(*) FROM SCM_MGR.DM_PLN_BP_FCST_C A
   JOIN SCM_MGR.GT_DM22_SELECT_MEASURE B ON A.MEASURE=B.MEASURE {CAL}
   WHERE A.YYYYMM>=:a AND A.YYYYMM<=:b AND A.DIVISION_ID=:c AND A.VERSION_NO=:e""",
}.items():
    print("\n"+"="*95); print(nm)
    cur.execute("EXPLAIN PLAN SET STATEMENT_ID='Y' FOR "+sql)
    cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE','Y','BASIC +ROWS +COST'))")
    for (l,) in cur.fetchall(): print(l)
    cur.execute("DELETE FROM PLAN_TABLE WHERE STATEMENT_ID='Y'")
print("\n[PK 클러스터링 팩터]")
cur.execute("""SELECT INDEX_NAME,CLUSTERING_FACTOR,BLEVEL,LEAF_BLOCKS,NUM_ROWS FROM ALL_INDEXES
   WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME='DM_PLN_BP_FCST_C'""")
for r in cur.fetchall(): print(" ",r)
con.rollback(); con.close()
