#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""No.49 — PKG_DMF0082 BODY 재배포 ([E20260814-FCSTNAME]) + 컴파일/마커 검증."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

SRC = pathlib.Path(
    r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_TEST4142_20260814\05_PKG_DMF0082_BODY_fcsttypename.sql"
)
body = SRC.read_text(encoding="utf-8").replace("\r", "").rstrip()
while body.endswith("/"):
    body = body[:-1].rstrip()

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
print(f"[src] {SRC.name} — {len(body)} chars")
try:
    cur.execute(body)
    print("[deploy] CREATE OR REPLACE OK")
except Exception as e:
    print(f"[deploy] FAIL {e}")
    sys.exit(1)

cur.execute(
    """SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
       FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' ORDER BY 1"""
)
for r in cur.fetchall():
    print("   " + " | ".join(str(x) for x in r))

cur.execute(
    """SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
       WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' ORDER BY SEQUENCE"""
)
errs = cur.fetchall()
print(f"[errors] {len(errs)}건")
for r in errs[:15]:
    print("   " + " | ".join(str(x) for x in r))

for marker in ("E20260814-FCSTNAME", "E20260814-CURMEASURE"):
    cur.execute(
        """SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
           AND TYPE='PACKAGE BODY' AND INSTR(TEXT, :m) > 0""",
        {"m": marker},
    )
    print(f"[marker] {marker} = {cur.fetchone()[0]}행")

con.close()
