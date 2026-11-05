import sys; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
with connect('tobe') as cx:
    c=cx.cursor()
    for v in sys.argv[1:]:
        c.execute("SELECT TEXT_VC, TEXT_LENGTH FROM DBA_VIEWS WHERE OWNER='SCM_MGR' AND VIEW_NAME=:v",v=v)
        r=c.fetchone()
        c.execute("SELECT TEXT FROM DBA_VIEWS WHERE OWNER='SCM_MGR' AND VIEW_NAME=:v",v=v)
        t=c.fetchone()[0]
        open(v+'.sql','w',encoding='utf-8').write(t); print(v, r[1], len(t))
