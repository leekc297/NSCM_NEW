import sys,time
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
with connect('tobe') as cx:
    cx.call_timeout=60000
    cur=cx.cursor()
    t=time.time(); cur.execute("select column_name from all_tab_columns where owner='SCM_MGR' and table_name='SCM_COM_SQL_LOG' order by column_id"); print([r[0] for r in cur], round(time.time()-t,2))
    t=time.time(); cur.execute("select max(log_seq) from SCM_MGR.SCM_COM_SQL_LOG"); mx=cur.fetchone()[0]; print(mx, round(time.time()-t,2))
