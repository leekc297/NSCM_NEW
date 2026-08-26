# -*- coding: utf-8 -*-
"""라이브 PKG_DMF0035 BODY 전문 백업 (읽기 전용) + GT_DM35_T_LAST_SETUP_C INSERT 위치 탐색."""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_VERPUSH_20260820"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035' AND TYPE='PACKAGE BODY'
               ORDER BY LINE""")
rows = cur.fetchall()
assert rows, "ALL_SOURCE 0행 — 중단"
with open(BASE + r"\00_BACKUP_PKG_DMF0035_BODY.sql", "w", encoding="utf-8") as f:
    for _, t in rows:
        f.write(t if t.endswith("\n") else t + "\n")
print(f"[backup] {len(rows)} lines -> 00_BACKUP_PKG_DMF0035_BODY.sql")

proc = None
for ln, t in rows:
    m = re.match(r"\s*(PROCEDURE|FUNCTION)\s+(\w+)", t, re.I)
    if m:
        proc = (ln, m.group(2))
    u_ = t.upper()
    if "GT_DM35_T_LAST_SETUP_C" in u_ or "GT_DM35_VERSION" in u_:
        print(f"L{ln}: [{proc}] {t.rstrip()[:130]}")
con.close()
