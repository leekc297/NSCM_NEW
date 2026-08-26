import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding="utf-8",errors="replace")
sys.path.insert(0,r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info
u,p,d=conn_info(); con=oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
cur.execute("""SELECT SID,SERIAL#,STATUS,SQL_ID,EVENT,ROUND(LAST_CALL_ET) ET,PROGRAM
   FROM V$SESSION WHERE USERNAME='SCM_MGR' AND TYPE='USER' ORDER BY LAST_CALL_ET DESC""")
for r in cur.fetchall(): print(" | ".join("" if x is None else str(x) for x in r))
con.close()
