# -*- coding: utf-8 -*-
"""PKG_DMF0022 08-06 최종본 재적용 — 08-10 구세대 덮어쓰기 회귀 정정 (DMF0035 SALES PLAN 0행).

원인: LIVE BODY 가 2026-08-10 20:46 구세대로 원복되어 v_measure_sheet(sheet_name 이중변수) 소실
      → SHEET_MEASURE 조인 'salesPlanWaterfall'≠'Sales Plan Waterfall' → 0행.
정본: _artifacts/_apply_corporate/DMF0022_PKG_TITLE_EDY_FIX_20260806_BODY.sql (08-06 3차 누적본).
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# 1) 현행 LIVE 백업
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "".join(t if t.endswith("\n") else t + "\n" for (t,) in cur.fetchall())
bak = BASE + r"\DMF0022_REAPPLY_20260820\PKG_DMF0022_BODY_BACKUP_BEFORE_20260820.sql"
open(bak, "w", encoding="utf-8").write(live)
print(f"[backup] {bak} ({live.count(chr(10))} lines)")
assert "V_MEASURE_SHEET" not in live.upper(), "LIVE 에 이미 v_measure_sheet 존재 — 전제 불일치, 중단"

# 2) 08-06 정본 재적용
src = open(BASE + r"\DMF0022_PKG_TITLE_EDY_FIX_20260806_BODY.sql", encoding="utf-8").read()
stmt = re.sub(r"\n/\s*$", "\n", src.replace("\r", "")).strip()
low = stmt.upper()
assert re.search(r"CREATE OR REPLACE\s+(EDITIONABLE\s+)?PACKAGE BODY", low[:500]), low[:200]
assert "V_MEASURE_SHEET" in low, "정본에 v_measure_sheet 부재 — 파일 오선택, 중단"
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 30")
cur.execute(stmt)
print("[apply] CREATE OR REPLACE PACKAGE BODY PKG_DMF0022")

# 3) 검증 (hook #136 — 대상 객체 실측)
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'
               AND TYPE='PACKAGE BODY' AND UPPER(TEXT) LIKE '%V_MEASURE_SHEET%'""")
n = cur.fetchone()[0]
print(f"[verify] v_measure_sheet 출현 라인 {n} (기대 >= 3)")
assert n >= 3
cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0022'")
sts = cur.fetchall()
print("[verify] STATUS:", sts)
assert all(s == "VALID" for _, s in sts), "INVALID — ALL_ERRORS 확인 필요"
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'")
assert cur.fetchone()[0] == 0, "컴파일 에러 존재"
con.close()
print("[OK] 재적용 완료 — 스모크는 measure_get.py sales 로 확인")
