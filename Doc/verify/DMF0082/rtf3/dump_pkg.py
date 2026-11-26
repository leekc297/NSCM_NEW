import sys,time
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
with connect('tobe') as cx:
    cx.call_timeout=60000
    cur=cx.cursor()
    t=time.time()
    cur.execute("select line,text from all_source where owner='SCM_MGR' and name='PKG_DMF0082' and type='PACKAGE BODY' order by line")
    rows=cur.fetchall()
    open('Doc/verify/DMF0082/rtf3/PKG_DMF0082_body.sql','w',encoding='utf-8').write(''.join(r[1] for r in rows))
    print('lines',len(rows),round(time.time()-t,1),'s')
    cur.execute("select last_ddl_time,status from all_objects where owner='SCM_MGR' and object_name='PKG_DMF0082' and object_type='PACKAGE BODY'")
    print(cur.fetchall())
