"""생성된 S3 동적 SQL 덤프 — python _dumpsql.py <user> <div> → _s3_<user>_<div>.sql (호출은 1104, ROLLBACK)"""
import sys, datetime
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb
user, div = sys.argv[1], sys.argv[2]
today = datetime.date.today(); frm = today.replace(day=1); m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor()
c.callproc("DBMS_APPLICATION_INFO.SET_CLIENT_INFO", ["ONEQ_DEBUG"])
c.callproc("DBMS_OUTPUT.ENABLE", [None])
outs = [c.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
args = [div, "ALL", "ALL", "ALL", frm.strftime("%Y%m%d"), to.strftime("%Y%m%d"), "ALL", None, "Current", "N", user, "ADMIN", "ALL", "ALL", "ALL", "ALL"]
err = None
try:
    c.callproc("SCM_MGR.PKG_DMF0082_1104.P_DMF0082_GET_MAIN_DATA", args + outs)
except Exception as e:
    err = str(e)[:400]
chunks = []
line = c.var(str); status = c.var(int)
while True:
    c.callproc("DBMS_OUTPUT.GET_LINE", (line, status))
    if status.getvalue() != 0: break
    chunks.append(line.getvalue() or '')
sql = ''.join(chunks)
open(f"_s3_{user}_{div}.sql", 'w', encoding='utf-8').write(sql)
print('err:', err); print('sql chars', len(sql))
cx.rollback()
