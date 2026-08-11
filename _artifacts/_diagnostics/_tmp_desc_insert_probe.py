# -*- coding: utf-8 -*-
"""CREATE / COPY 의 DM_MDF_VERSION INSERT 에서 VERSION_DESCRIPTION 이 들어가는 자리 확인"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
for a, b, lbl in ((7248, 7262, "CR INSERT"), (7300, 7316, "CP INSERT")):
    print("== %s (%d~%d) ==" % (lbl, a, b))
    cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                    AND TYPE='PACKAGE BODY' AND LINE BETWEEN :a AND :b ORDER BY LINE""", {"a": a, "b": b})
    for ln, t in cur.fetchall():
        s = t.rstrip()
        if s.strip():
            print("%6d| %r" % (ln, t))
    print()
con.close()
