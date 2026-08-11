# -*- coding: utf-8 -*-
"""버전 팝업 목록 SP 의 기간 필터가 어느 컬럼을 보는지 실측"""
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

cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN (SELECT MIN(LINE) FROM ALL_SOURCE
                                     WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                                       AND INSTR(TEXT,'P_DMF0044_GET_SALES_VERSION_POPUP')>0)
                              AND (SELECT MIN(LINE)+130 FROM ALL_SOURCE
                                     WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                                       AND INSTR(TEXT,'P_DMF0044_GET_SALES_VERSION_POPUP')>0)
                ORDER BY LINE""")
for ln, t in cur.fetchall():
    s = t.strip()
    if s and not s.startswith("--"):
        print("%6d| %s" % (ln, t[:150]))
con.close()
