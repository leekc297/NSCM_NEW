# -*- coding: utf-8 -*-
"""원장별 CELL_PROD_SITE_ID / CURRENCY 실태 — 채움 MERGE 조인키 비대칭 검증"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()

T = [("SCM_MST_FUTURE_PRICE", "단가 원장(81/82) — LOC arm L1599 은 '-' 로 고정삽입"),
     ("DM_PLN_CFM_SELLING_PRICE", "단가 원장(40) — LOC arm L1701 은 A.CELL_PROD_SITE_ID"),
     ("DM_PLN_SALES_PLAN_RESULT", "실적 원장 — arm L1815 는 A.CELL_PROD_SITE_ID"),
     ("DM_PLN_MKT_FCST", "FCST 원장 — arm L1390 은 '-' 로 고정삽입"),
     ("DM_PLN_CFM_MKT_DEMAND_PLAN", "확정 원장 — arm L1493 은 A.CELL_PROD_SITE_ID")]

for t, note in T:
    cur.execute("SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND COLUMN_NAME='CELL_PROD_SITE_ID'", t=t)
    if not cur.fetchone()[0]:
        print("\n{}  — CELL_PROD_SITE_ID 컬럼 없음\n  {}".format(t, note)); continue
    print("\n{}\n  {}".format(t, note))
    cur.execute("""SELECT DIVISION_ID,
                          SUM(CASE WHEN CELL_PROD_SITE_ID='-' THEN 1 ELSE 0 END) DASH,
                          SUM(CASE WHEN CELL_PROD_SITE_ID IS NULL THEN 1 ELSE 0 END) NUL,
                          SUM(CASE WHEN CELL_PROD_SITE_ID IS NOT NULL AND CELL_PROD_SITE_ID<>'-' THEN 1 ELSE 0 END) REAL_V,
                          COUNT(*) TOT
                     FROM SCM_MGR.{} WHERE DIVISION_ID IN ('40','81','82','81_UC','81_HG')
                    GROUP BY DIVISION_ID ORDER BY 1""".format(t))
    print("    {:8s} {:>12s} {:>10s} {:>12s} {:>12s}".format("DIV","'-'","NULL","실제값","합계"))
    for r in cur:
        print("    {:8s} {:12,d} {:10,d} {:12,d} {:12,d}".format(r[0], r[1], r[2], r[3], r[4]))
