import pyodbc,sys
env=dict(l.strip().split('=',1) for l in open(r'c:\Projects\NSCM\.env.asis',encoding='utf-8') if '=' in l and not l.startswith('#'))
c=pyodbc.connect(f"DRIVER={{{env.get('ASIS_DB_DRIVER','ODBC Driver 17 for SQL Server')}}};SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};DATABASE={env['ASIS_DB_NAME']};UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes",timeout=30)
cur=c.cursor()
for q in sys.argv[1:]:
    print('>>',q[:160]); cur.execute(q)
    while cur.description is None and cur.nextset(): pass
    if cur.description:
        print('|'.join(d[0] for d in cur.description))
        for r in cur.fetchall(): print('|'.join(repr(v) for v in r))
