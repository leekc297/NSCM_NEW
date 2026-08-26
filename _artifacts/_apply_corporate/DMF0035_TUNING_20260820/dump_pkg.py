# -*- coding: utf-8 -*-
"""PKG_DMF0035 BODY 라이브 원문 덤프 + GT_DM35_SCP_ITEM_INFO 적재 위치 탐색 (읽기 전용)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035' AND TYPE='PACKAGE BODY'
               ORDER BY LINE""")
rows = cur.fetchall()
out = rf"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_TUNING_20260820\PKG_DMF0035_BODY_LIVE.sql"
with open(out, "w", encoding="utf-8") as f:
    for _, t in rows:
        f.write(t if t.endswith("\n") else t + "\n")
print(f"[saved] {out} ({len(rows)} lines)")
# 적재 문장·프로시저 경계 탐색
import re
proc = None
for ln, t in rows:
    m = re.match(r"\s*(PROCEDURE|FUNCTION)\s+(\w+)", t, re.I)
    if m:
        proc = (ln, m.group(2))
    if "GT_DM35_SCP_ITEM_INFO" in t.upper():
        print(f"L{ln}: [{proc}] {t.strip()[:110]}")
con.close()
