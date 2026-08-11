# -*- coding: utf-8 -*-
"""PKG_DMF0044 마커 현황 + 상태"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

MARKS = ["TUNE-M 2026-08-10", "TUNE-M2 2026-08-10", "TUNE-T 2026-08-10", "TUNE-T2 2026-08-10",
         "DESCNULL 2026-08-10", "DESCDEF 2026-08-10", "DYNSAMP 2026-08-10", "DYNSAMP2 2026-08-10",
         "DYNSAMP3 2026-08-10", "NODATAGUARD 2026-08-10", "SEQGRP 2026-08-10", "ETCDEL 2026-08-10",
         "RPTGRP-STUB 2026-08-10", "AUTHUNION 2026-08-09"]
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
print("== PKG_DMF0044 마커 ==")
for m in MARKS:
    cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, :m)),0) FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""", {"m": m})
    print("  %-26s %d" % (m, cur.fetchone()[0]))
cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1""")
print("== 상태 ==")
for r in cur.fetchall():
    print("  %-14s %s" % r)
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'")
print("  errors =", cur.fetchone()[0])
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
print("  BODY 행수 =", cur.fetchone()[0])
con.close()
