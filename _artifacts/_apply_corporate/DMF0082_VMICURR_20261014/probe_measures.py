"""조회 SP 결과의 메저별 CURRENCY 분포 (읽기 전용 — 조회 프로시저 호출 후 rollback)
  python probe_measures.py <PROC> <DIV> <FROM> <TO> <SITE> <USER>
"""
import sys
from collections import Counter, defaultdict
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

proc, div, f, t, site, user = sys.argv[1:7]
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
args = [div, "ALL", "ALL", "ALL", f, t, site, "", "Current", "N", user, "ADMIN", "ALL", "ALL", "ALL", "ALL"]
outs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
cur.callproc("SCM_MGR.PKG_DMF0082." + proc, args + outs)
c = outs[0].getvalue()
cols = [x[0] for x in c.description]
rows = c.fetchall()
con.rollback()
mi, ci = cols.index("MEASURE"), cols.index("CURRENCY")
dist = defaultdict(Counter)
for r in rows:
    dist[r[mi]][repr(r[ci])] += 1
for m in sorted(dist):
    print(f"{m:14s} {dict(dist[m])}")
