# -*- coding: utf-8 -*-
"""PKG_DMF0051 BODY 라이브 원문 덤프 (읽기 전용) + 마커/구조 인벤토리."""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0051' AND TYPE='PACKAGE BODY'
               ORDER BY LINE""")
rows = cur.fetchall()
out = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0051_PERF_20260820\PKG_DMF0051_BODY_LIVE.sql"
with open(out, "w", encoding="utf-8") as f:
    for _, t in rows:
        f.write(t if t.endswith("\n") else t + "\n")
print(f"[saved] {out} ({len(rows)} lines)")

print("\n[PROCEDURE/FUNCTION 경계]")
for ln, t in rows:
    m = re.match(r"\s*(PROCEDURE|FUNCTION)\s+(\w+)", t, re.I)
    if m:
        print(f"  L{ln}: {m.group(1)} {m.group(2)}")

print("\n[마커 E2026*]")
for ln, t in rows:
    for m in re.finditer(r"E20\d{6}-[A-Z0-9]+", t):
        print(f"  L{ln}: {m.group(0)} | {t.strip()[:100]}")

print("\n[STATUS]")
cur.execute("SELECT OBJECT_TYPE,STATUS,LAST_DDL_TIME FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0051'")
for r in cur.fetchall():
    print("  ", r)
con.close()
