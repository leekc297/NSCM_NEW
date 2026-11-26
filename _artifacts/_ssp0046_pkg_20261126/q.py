import oracledb,sys
env=dict(l.strip().split('=',1) for l in open(r'c:\Projects\NSCM\.env.asis',encoding='utf-8') if '=' in l and not l.startswith('#'))
c=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur=c.cursor(); cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
for q in sys.argv[1:]:
    print('>>',q[:150]); cur.execute(q)
    if cur.description:
        print('|'.join(d[0] for d in cur.description))
        for r in cur.fetchall(): print('|'.join('' if v is None else str(v) for v in r))
