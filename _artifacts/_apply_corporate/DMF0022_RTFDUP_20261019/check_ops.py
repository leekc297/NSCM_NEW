import sys, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import ora, oracledb
from ops import apply_ops, rollback_ops, HEAD, TAIL
pre = (HERE / "PKG_DMF0022_BODY.ASIS.sql").read_text(encoding="utf-8").replace("\r\n", "\n")
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("SELECT VALUE FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER IN ('NLS_CHARACTERSET','NLS_NCHAR_CHARACTERSET') ORDER BY 1")
    print("charset", cur.fetchall())
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    applied = "".join(r[0] for r in cur).replace("\r\n", "\n")
print("apply(pre)==applied", apply_ops(pre) == applied)
print("rollback(applied)==pre", rollback_ops(applied) == pre)
s = pre.index(HEAD); e = pre.index(TAIL) + len(TAIL)
print("block chars", e - s, "HEAD/TAIL count", pre.count(HEAD), pre.count(TAIL))
