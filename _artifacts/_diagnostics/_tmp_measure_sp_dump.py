# -*- coding: utf-8 -*-
"""P_DMF0044_GET_MEASURE 본문 덤프 + 중복 8배 원인 추적"""
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
cur.execute("""SELECT MIN(LINE), MAX(LINE) FROM (
                 SELECT LINE FROM ALL_SOURCE
                  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                    AND LINE >= (SELECT MIN(LINE) FROM ALL_SOURCE
                                  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                                    AND INSTR(TEXT,'P_DMF0044_GET_MEASURE')>0)
                    AND ROWNUM <= 130)""")
lo, hi = cur.fetchone()
print("== P_DMF0044_GET_MEASURE (L%s~%s) ==" % (lo, hi))
cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN :a AND :b ORDER BY LINE""", {"a": lo, "b": hi})
for ln, t in cur.fetchall():
    s = (t or "").rstrip()
    if s.strip():
        print("%6d| %s" % (ln, s[:150]))
con.close()
