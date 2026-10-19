# -*- coding: utf-8 -*-
"""결손 후보 키 탐색 — CELL_PROD_SITE_ID 가 실제값인 FCST/실적 행 보유 ITEM"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()

for div in ("81", "40", "82"):
    print("\n== DIV {} — DM_PLN_CFM_MKT_DEMAND_PLAN 에 실제 CELL_PROD_SITE_ID 보유 ITEM 상위 ==".format(div))
    cur.execute("""SELECT ITEM_ID, SCM_SITE_ID, CELL_PROD_SITE_ID, COUNT(*) CNT,
                          MIN(YYYYMMDD), MAX(YYYYMMDD)
                     FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
                    WHERE DIVISION_ID=:d AND CELL_PROD_SITE_ID IS NOT NULL
                      AND CELL_PROD_SITE_ID<>'-' AND YYYYMMDD>='20260101'
                    GROUP BY ITEM_ID, SCM_SITE_ID, CELL_PROD_SITE_ID
                    ORDER BY CNT DESC FETCH FIRST 5 ROWS ONLY""", d=div)
    for r in cur:
        print("   {:22s} site={:22s} cell={:14s} {:>6s}행  {} ~ {}".format(*[str(x) for x in r]))
    print("   -- 단가(LOC) 원장 보유 여부")
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE WHERE DIVISION_ID=:d""", d=div)
    print("      DM_PLN_CFM_SELLING_PRICE : {:,}행".format(cur.fetchone()[0]))
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_FUTURE_PRICE WHERE DIVISION_ID=:d""", d=div)
    print("      SCM_MST_FUTURE_PRICE     : {:,}행".format(cur.fetchone()[0]))
