import time,oracledb,re
env={}
for l in open('.env.asis',encoding='utf-8'):
    l=l.strip()
    if '=' in l and not l.startswith('#'):
        k,v=l.split('=',1); env[k]=v.strip().strip('"')
cx=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cx.call_timeout=60000
c=cx.cursor(); c.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
src=open('_artifacts/_diagnostics/SSP0003_DUP_20261125/SSP0003_DUP_CHECK_CLOUD.sql',encoding='utf-8').read()
src=src.replace('R20261125542412','R20261120555032')
body='\n'.join(l for l in src.splitlines() if not l.strip().startswith('--'))
stmts=[s.strip() for s in body.split(';') if s.strip()]
print('stmts',len(stmts))
for i,s in enumerate(stmts,1):
    t=time.time(); c.execute(s); rows=c.fetchall()
    print(f'[{i}] {round(time.time()-t,2)}s rows={len(rows)} cols={[d[0] for d in c.description]}')
    for r in rows[:8]: print('   ',r)
