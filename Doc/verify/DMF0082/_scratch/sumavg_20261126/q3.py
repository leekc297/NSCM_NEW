import sys,time
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn
cx=dbconn.connect('tobe'); cx.call_timeout=60000; cur=cx.cursor()
t=time.time()
cur.execute("SELECT MAX(LOG_SEQ) FROM SCM_MGR.SCM_COM_SQL_LOG"); mx=cur.fetchone()[0]; print('max',mx, round(time.time()-t,1))
cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_COM_SQL_LOG' ORDER BY COLUMN_ID"); print([r[0] for r in cur])
