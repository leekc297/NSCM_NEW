import sys,time
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
with connect('tobe') as cx:
    cx.call_timeout=60000
    cur=cx.cursor()
    t=time.time()
    cur.execute("""select log_seq, create_date, created_by, dbms_lob.substr(params,1500,1) from SCM_MGR.SCM_COM_SQL_LOG
       where log_seq > 7043079-300000 and dbms_lob.instr(sql_text,'P_DMF0082_GET_MAIN_DATA')>0 and dbms_lob.instr(params,'"40"')>0
       order by log_seq desc fetch first 3 rows only""")
    for r in cur: print(r)
    print(round(time.time()-t,2),'s')
