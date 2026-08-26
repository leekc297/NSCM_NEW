import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding="utf-8",errors="replace")
sys.path.insert(0,r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info
u,p,d=conn_info(); con=oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
sql="""SELECT SMSI.DIVISION_ID, SMSI.OWNER, OW.OWNER_NAME, OW.OWNER_NAME_KO, OW.DEPT_ID
 FROM SCM_MGR.SCM_MST_SITE_ITEM SMSI
 LEFT JOIN ( SELECT O.OWNER AS OWNER
      , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(O.OWNER, ',', 'EN') AS OWNER_NAME
      , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(O.OWNER, ',', 'KO') AS OWNER_NAME_KO
      , ( SELECT SU.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU
           WHERE SU.USER_ID = (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(O.OWNER, ',')) P WHERE ROWNUM = 1)) AS DEPT_ID
     FROM (SELECT DISTINCT OWNER FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE DIVISION_ID = '40') O ) OW
   ON OW.OWNER = SMSI.OWNER
 WHERE SMSI.DIVISION_ID = '40'"""
cur.execute("EXPLAIN PLAN SET STATEMENT_ID='P1' FOR "+sql)
cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE','P1','BASIC +ROWS +COST'))")
for (l,) in cur.fetchall(): print(l)
cur.execute("DELETE FROM PLAN_TABLE WHERE STATEMENT_ID='P1'"); con.commit(); con.close()
