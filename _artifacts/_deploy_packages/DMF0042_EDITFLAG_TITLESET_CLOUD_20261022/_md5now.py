import sys, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
u, p, d = conn_info(); cur = oracledb.connect(user=u, password=p, dsn=d).cursor()
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0042' AND TYPE='PACKAGE BODY' ORDER BY LINE")
t = "".join(r[0] for r in cur).replace("\r\n", "\n")
print("md5 now =", hashlib.md5(t.encode("utf-8")).hexdigest())
