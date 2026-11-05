import sys; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
name, typ, out = sys.argv[1], sys.argv[2], sys.argv[3]
with connect('tobe') as cx:
    cur=cx.cursor()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE",n=name,t=typ)
    txt=''.join(r[0] for r in cur)
    cur.execute("SELECT LAST_DDL_TIME,STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t",n=name,t=typ)
    print(cur.fetchall())
open(out,'w',encoding='utf-8',newline='').write(txt)
print(len(txt.splitlines()))
