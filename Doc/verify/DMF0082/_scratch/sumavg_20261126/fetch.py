import sys, time
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn
cx = dbconn.connect('tobe')
cx.call_timeout = 60000
cur = cx.cursor()
out = r'C:/Projects/NSCM/Doc/verify/DMF0082/_scratch/sumavg_20261126/'
for t in ('PACKAGE','PACKAGE BODY'):
    t0=time.time()
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE=:t",t=t)
    print(t, cur.fetchone())
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE=:t ORDER BY LINE",t=t)
    src=''.join(r[0] for r in cur.fetchall())
    open(out+('SPEC' if t=='PACKAGE' else 'BODY')+'.ASIS.sql','w',encoding='utf-8').write(src)
    print(len(src.splitlines()), 'lines', round(time.time()-t0,1),'s')
