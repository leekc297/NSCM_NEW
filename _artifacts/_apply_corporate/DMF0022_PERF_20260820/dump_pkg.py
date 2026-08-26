# -*- coding: utf-8 -*-
"""PKG_DMF0022 라이브 BODY 전문 덤프 (백업 정본)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_PERF_20260820"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
rows = cur.fetchall()
body = "\n".join(r[0].rstrip("\n") for r in rows)
# ⚠ 가드 — 재실행으로 백업이 패치본에 덮어써지는 사고 방지 (2026-08-21 실사고)
import os
BK = BASE + r"\00_BACKUP_PKG_DMF0022_BODY.sql"
if os.path.exists(BK):
    print(f"[skip] 백업 파일 이미 존재 — 덮어쓰지 않음: {BK}")
    open(BASE + r"\_LIVE_PKG_DMF0022_BODY.sql", "w", encoding="utf-8").write(body + "\n")
else:
    open(BK, "w", encoding="utf-8").write(body + "\n")
print(f"[dump] BODY {len(rows)} lines")

# 마커 카운트 (보존 검증 기준선)
for mk in ["E20260812-DS2", "E20260820-DS2", "v_measure_sheet", "E20260820-"]:
    print(f"  marker {mk}: {body.count(mk)}")

cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
               WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0022'""")
print("  status:", cur.fetchall())
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'")
print("  ALL_ERRORS:", cur.fetchone()[0])
con.close()
