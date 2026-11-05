import sys, datetime
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
print("FETCHED", datetime.datetime.now().isoformat(timespec='seconds'))
cur.execute(open('dupscan.sql',encoding='utf-8').read())
for r in cur: print(r)
cur.execute("SELECT VERSION_NO, SEND_YN, VERSION_TYPE FROM DM_MDF_VERSION WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20261002_V001_C'"); print(cur.fetchall())
