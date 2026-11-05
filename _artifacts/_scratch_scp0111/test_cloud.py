import sys, re
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
txt = open(r'C:\Projects\NSCM\_artifacts\_deploy_packages\SCP0111_META_CLOUD_20261029\01_SCP0111_META_CLOUD.sql', encoding='utf-8').read()
plsql, rest = txt.split('\n/\n', 1)
plsql = plsql[plsql.index('DECLARE'):]
c = dbconn.connect('tobe', write=True); cur = c.cursor()
cur.execute(plsql); print('PRECHECK OK')
body = '\n'.join(l for l in rest.splitlines() if not l.lstrip().startswith('--'))
for s in [x.strip() for x in body.split(';') if x.strip()]:
    if s.upper() == 'COMMIT': print('COMMIT skipped (test)'); continue
    cur.execute(s)
    if s.upper().startswith('SELECT'): print(cur.fetchall())
    else: print('rows', cur.rowcount, re.sub(r'\s+',' ',s)[:60])
c.rollback(); print('ROLLBACK')
