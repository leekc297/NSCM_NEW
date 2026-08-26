import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding="utf-8",errors="replace")
sys.path.insert(0,r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info
u,p,d=conn_info(); con=oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
cur.execute("""SELECT SQL_ID, EXECUTIONS, ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),3) S_PER_EXEC,
   ROUND(BUFFER_GETS/GREATEST(EXECUTIONS,1)) BG_PER_EXEC, ROUND(DISK_READS/GREATEST(EXECUTIONS,1)) DISK_PER_EXEC,
   ROUND(ROWS_PROCESSED/GREATEST(EXECUTIONS,1)) ROWS_PER_EXEC,
   TO_CHAR(LAST_ACTIVE_TIME,'HH24:MI:SS') LAST
 FROM V$SQL WHERE PARSING_SCHEMA_NAME='SCM_MGR' AND SQL_TEXT LIKE '%T_DM51_WF%' AND SQL_TEXT NOT LIKE '%V$SQL%'
 ORDER BY LAST_ACTIVE_TIME""")
print("최종 동적 SQL (WITH T_DM51_WF) 커서별 — 이전=INNER JOIN F / 이후=EXISTS")
print(" | ".join(c[0] for c in cur.description))
for r in cur.fetchall(): print(" | ".join(str(x) for x in r))
con.close()
