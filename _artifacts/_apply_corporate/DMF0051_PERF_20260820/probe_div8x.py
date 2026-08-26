import io,re,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding="utf-8",errors="replace")
sys.path.insert(0,r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info
u,p,d=conn_info(); con=oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
for div in ("81","82"):
    ARGS=[div,"ALL","ALL","ALL","","","ALL","20260801","20260817","20270228","minyonglee1","ALL","ALL","","CURRENT","N","N","minyonglee1","DMF0035"]
    out=[con.cursor() for _ in range(3)]
    cur.callproc("SCM_MGR.PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL",ARGS+out)
    n=len(out[0].fetchall()) if out[0].description else 0
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DM51_SCM_CITY"); gtot=cur.fetchone()[0]
    cur.execute("""WITH BASE AS (SELECT A.DIVISION_ID,A.SCM_SITE_ID,A.PROJECT_CODE,A.END_CUSTOMER,C.DEPT_ID CDEPT
      FROM SCM_MGR.GT_DM51_RAW_DATA A LEFT JOIN SCM_MGR.GT_DM51_SCM_MST_SITE_ITEM C
      ON A.DIVISION_ID=C.DIVISION_ID AND A.SCM_SITE_ID=C.SCM_SITE_ID AND A.PROJECT_CODE=C.PROJECT_CODE AND A.ITEM_ID=C.ITEM_ID),
      GK AS (SELECT DIVISION_ID,SCM_SITE_ID,END_CUSTOMER,DEPT_ID,COUNT(*) CNT FROM SCM_MGR.GT_DM51_SCM_CITY GROUP BY DIVISION_ID,SCM_SITE_ID,END_CUSTOMER,DEPT_ID)
      SELECT COUNT(*) BASE_ROWS,SUM(CASE WHEN G.CNT IS NULL THEN 0 ELSE 1 END) MATCHED,NVL(MAX(G.CNT),0) MAXDUP,SUM(NVL(G.CNT,1)) AFTER_G
      FROM BASE B LEFT JOIN GK G ON G.DIVISION_ID=B.DIVISION_ID AND G.SCM_SITE_ID=B.SCM_SITE_ID
      AND G.END_CUSTOMER=CASE WHEN B.DIVISION_ID='40' THEN B.PROJECT_CODE ELSE B.END_CUSTOMER END AND G.DEPT_ID=B.CDEPT""")
    print(f"div={div} rc1={n} G_TOT={gtot} :: "+" | ".join(f"{c[0]}={v}" for c,v in zip(cur.description,cur.fetchone())))
con.close()
