import sys, re, glob, datetime
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
for f in sorted(glob.glob('A_DB/*.sql')):
    t=open(f,encoding='utf-8').read()
    body=re.sub(r'--[^\n]*','',t)
    issues=[]
    if '\t' in t: issues.append('TAB')
    if '&' in body: issues.append('AMP')
    if re.search(r"(?<![:'\w]):[A-Za-z_]\w*", re.sub(r"'[^']*'","",body)): issues.append('BIND?')
    print(f, 'OK' if not issues else issues)
from ora import conn_info
import oracledb
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
print("CHECKED", datetime.datetime.now().isoformat(timespec='seconds'))
cur.execute("SELECT DATA_SEQ, MEASURE, COUNT(*), SUM(QTY) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO='R_S_20261002_V001_C' AND DIVISION_ID='40' AND DATA_SEQ IN (174,342) GROUP BY DATA_SEQ, MEASURE ORDER BY 1,2")
for r in cur: print(' ledger', r)
cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C"); print(' ledger total', cur.fetchone()[0], '(before 863,497 → expected 863,494)')
cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE ATTRIBUTE10='DUPRB_TEST'"); print(' test residue', cur.fetchone()[0])
cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS<>'VALID' AND OBJECT_NAME LIKE '%DMF004%'"); print(' invalid DMF004x', cur.fetchall())
