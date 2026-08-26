import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding="utf-8",errors="replace")
sys.path.insert(0,r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info
u,p,d=conn_info(); con=oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='FN_GET_DM_MKT_OWNER_NAME' ORDER BY LINE")
print("".join(r[0] for r in cur.fetchall()))
print("=== 배분도 ===")
cur.execute("""SELECT COUNT(*) ROWS_DIV40, COUNT(DISTINCT OWNER) DISTINCT_OWNER
               FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE DIVISION_ID='40'""")
print(cur.fetchone())
cur.execute("""SELECT DIVISION_ID, COUNT(*) C, COUNT(DISTINCT OWNER) DO
               FROM SCM_MGR.SCM_MST_SITE_ITEM GROUP BY DIVISION_ID ORDER BY 2 DESC""")
for r in cur.fetchall(): print(r)
con.close()
