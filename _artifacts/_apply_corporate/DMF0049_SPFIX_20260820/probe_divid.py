# -*- coding: utf-8 -*-
"""PKG_DMF0049 SAVE 프로시저의 p_division_id 스칼라 비교 지점 실측 (읽기 전용)."""
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
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
               AND NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
rows = cur.fetchall()
out = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0049_SPFIX_20260820\PKG_DMF0049_BODY_LIVE.sql"
with open(out, "w", encoding="utf-8") as f:
    for _, t in rows:
        f.write(t if t.endswith("\n") else t + "\n")
print(f"[saved] {out} ({len(rows)} lines)")

proc = None
for ln, t in rows:
    m = re.match(r"\s*(PROCEDURE|FUNCTION)\s+(\w+)", t, re.I)
    if m:
        proc = m.group(2)
    if re.search(r"\bp_division_id\b", t, re.I):
        print(f"L{ln} [{proc}] {t.rstrip()[:120]}")
print("\n== v_division_id 대입부 ==")
for ln, t in rows:
    if re.search(r"v_division_id\s*:=", t, re.I):
        print(f"L{ln}: {t.strip()[:120]}")
con.close()
