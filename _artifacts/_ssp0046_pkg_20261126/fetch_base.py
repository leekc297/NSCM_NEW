# DB 원문 재조회 (hook #152) - ALL_SOURCE 기준본 저장
import oracledb,sys,datetime
env=dict(l.strip().split('=',1) for l in open(r'c:\Projects\NSCM\.env.asis',encoding='utf-8') if '=' in l and not l.startswith('#'))
c=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur=c.cursor(); out=sys.argv[1]
for name in sys.argv[2:]:
  for t in ('PACKAGE','PACKAGE BODY'):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'),STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t",n=name,t=t)
    meta=cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE",n=name,t=t)
    txt=''.join(r[0] for r in cur)
    print(name,t,meta,txt.count('\n'))
    if txt: open(f"{out}/{name}.{t.replace(' ','_')}.sql",'w',encoding='utf-8',newline='').write(txt)
print('FETCHED',datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
