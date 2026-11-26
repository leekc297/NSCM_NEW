import sys,time
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn
cx=dbconn.connect('tobe'); cx.call_timeout=60000; cur=cx.cursor()
t=time.time()
cur.execute("""SELECT LOG_SEQ, SQL_ID, TO_CHAR(CREATE_DATE,'MM-DD HH24:MI:SS'), CREATED_BY, DBMS_LOB.SUBSTR(PARAMS,1200,1) FROM SCM_MGR.SCM_COM_SQL_LOG
 WHERE LOG_SEQ > 7214031-60000 AND DBMS_LOB.INSTR(PARAMS,'VW_CZ_MBV')>0 ORDER BY LOG_SEQ DESC FETCH FIRST 3 ROWS ONLY""")
for r in cur: print(r)
print(round(time.time()-t,1),'s')
