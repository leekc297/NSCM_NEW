import sys, pathlib
kv={}
for l in pathlib.Path(r'C:\Projects\NSCM\.env.asis').read_text(encoding='utf-8',errors='ignore').splitlines():
    if '=' in l and not l.strip().startswith('#'):
        k,v=l.split('=',1); kv[k.strip()]=v.strip()
import pyodbc
con=pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=%s,%s;DATABASE=%s;UID=%s;PWD=%s'%(kv['ASIS_DB_HOST'],kv['ASIS_DB_PORT'],kv['ASIS_DB_NAME'],kv['ASIS_DB_USER'],kv['ASIS_DB_PASS']),timeout=15)
cur=con.cursor(); cur.execute(open(sys.argv[1],encoding='utf-8').read())
cols=[c[0] for c in cur.description]; print(' | '.join(cols))
for r in cur.fetchall(): print(' | '.join('' if v is None else str(v) for v in r))
