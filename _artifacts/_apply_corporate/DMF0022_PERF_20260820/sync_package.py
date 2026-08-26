# -*- coding: utf-8 -*-
"""사내 라이브 PKG_DMF0022 BODY → 클라우드 패키지 15_PKG_DMF0022_BODY.sql 재생성.

⚠ 파일 형식(실사고 재발 방지 — 2026-08-20 헤더주석 절단 사고):
   헤더주석 → SET DEFINE OFF → SET SQLBLANKLINES ON → CREATE OR REPLACE PACKAGE BODY → / → SHOW ERRORS
   "PACKAGE BODY" 문자열로 자르지 않고 **새로 조립**한다.
자기검증: 주석·SET 제외 첫 실행 라인이 CREATE OR REPLACE PACKAGE BODY 인지 assert.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

DIR = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB"
FNAME = "15_PKG_DMF0022_BODY.sql"
PKG = "PKG_DMF0022"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
               AND TYPE='PACKAGE BODY' ORDER BY LINE""", {"n": PKG})
body = "\n".join(r[0].rstrip("\n") for r in cur.fetchall()).strip()
assert body.upper().startswith("PACKAGE BODY"), body[:80]
# 마커 보존 확인 (구세대 덮어쓰기 탐지축 포함)
MK = {"E20260820-DS2": 1, "v_measure_sheet": 6,
      "E20260820-D22PREREDUCE": 2, "E20260820-D22VERPUSH": 2}
for k, v in MK.items():
    assert body.count(k) == v, f"{k}: {body.count(k)} (기대 {v})"

text = (
    f"-- DMF0035_CLOUD_20260820 / {FNAME}\n"
    f"-- {PKG} PACKAGE BODY — Sales Plan Waterfall (사내 라이브 재덤프 2026-08-21)\n"
    f"--   [E20260820-DS2]            클라우드 optimizer_dynamic_sampling=0 방어 1줄\n"
    f"--   [E20260820-D22PREREDUCE] x2 hook #129 ④ 선행축소 (ITEM_SN→ORI_V prefix / SCM_MST_SITE)\n"
    f"--   [E20260820-D22VERPUSH]   x2 hook #129 ② access 술어 승격 (DM_PLN_SALES_PLAN_C division+version)\n"
    f"--   실행: SQL*Plus 에서 이 파일을 그대로 @실행 (말미 '/' 로 컴파일)\n"
    f"SET DEFINE OFF\n"
    f"SET SQLBLANKLINES ON\n"
    f"CREATE OR REPLACE {body}\n/\n"
    f"SHOW ERRORS\n"
)
open(f"{DIR}\\{FNAME}", "w", encoding="utf-8").write(text)

first = next(l for l in text.splitlines()
             if l.strip() and not l.strip().startswith("--") and not l.upper().startswith("SET "))
assert re.match(r"CREATE OR REPLACE\s+PACKAGE BODY", first, re.I), first[:80]
assert text.rstrip().endswith("SHOW ERRORS")
print(f"[gen] {FNAME}: {len(text.splitlines())} lines / 첫 실행 라인 OK")
print("  markers:", {k: body.count(k) for k in MK})
con.close()
