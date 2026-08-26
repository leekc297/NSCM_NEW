"""PKG_DMF0082 BODY 적용 — 04_PKG_DMF0082_BODY_sentinelddl.sql (마커 검증 후 단일 실행)."""
import os
import sys

import oracledb

BASE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(BASE, "04_PKG_DMF0082_BODY_sentinelddl.sql")
ENV_PATH = r"C:\Projects\NSCM\.env.asis"

with open(SRC, encoding="utf-8") as f:
    body = f.read()

for marker, expect in (("[E20260820-XLSSAVEPERF]", 1), ("[E20260820-SENTINELDDL]", 11)):
    n = body.count(marker)
    if n < expect:
        sys.exit(f"ABORT: marker {marker} count {n} < {expect}")
if not body.startswith("PACKAGE BODY"):
    sys.exit("ABORT: unexpected body header")

vals = {}
with open(ENV_PATH, encoding="utf-8") as f:
    for ln in f:
        ln = ln.strip()
        if "=" in ln and not ln.startswith("#"):
            k, v = ln.split("=", 1)
            vals[k] = v

conn = oracledb.connect(
    user="SCM_MGR",
    password=vals["TOBE_DB_PASS"],
    dsn=f"{vals['TOBE_DB_HOST']}:{vals['TOBE_DB_PORT']}/{vals['TOBE_DB_PDB']}",
)
cur = conn.cursor()
cur.execute("CREATE OR REPLACE " + body)

cur.execute(
    "SELECT LINE, POSITION, TEXT FROM USER_ERRORS "
    "WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE"
)
errs = cur.fetchall()
if errs:
    for e in errs[:20]:
        print("ERR", e)
    sys.exit("compile errors")

cur.execute(
    "SELECT OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082'"
)
for r in cur.fetchall():
    print("STATUS:", r)
print("PKG apply DONE")
