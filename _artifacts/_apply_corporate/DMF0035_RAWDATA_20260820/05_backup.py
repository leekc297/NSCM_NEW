# -*- coding: utf-8 -*-
"""적용 전 라이브 BODY 전문 백업 (룰 30 / 이관패키지 규약)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
lines = [r[0].rstrip("\n") for r in cur.fetchall()]
assert lines and lines[0].upper().lstrip().startswith("PACKAGE BODY"), lines[0][:80]
open(BASE + r"\00_BACKUP_PKG_DMF0035_BODY.sql", "w", encoding="utf-8").write("\n".join(lines) + "\n")
print(f"[backup] 00_BACKUP_PKG_DMF0035_BODY.sql — {len(lines)} lines")
# 기존 마커 보존 기준값
for mk in ("E20260820-DS2", "E20260820-WFITEMPERF", "E20260820-VERPUSH"):
    print(f"  {mk}: {sum(1 for l in lines if mk in l)}")
con.close()
