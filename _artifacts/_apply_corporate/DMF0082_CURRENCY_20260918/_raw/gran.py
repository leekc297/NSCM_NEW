# -*- coding: utf-8 -*-
"""통화(CURRENCY)가 유일하게 결정되는 최소 축 찾기 — 폴백 단계 설계 근거"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

GRAN = [
 ("9키 (현행 1차)", "DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE,CELL_PROD_SITE_ID"),
 ("8키 (현행 2차 · CELL_PROD 제외)", "DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE"),
 ("DIV+SITE+ITEM+DOM_EXP+FCST_TYPE", "DIVISION_ID,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE"),
 ("DIV+SITE+ITEM", "DIVISION_ID,SCM_SITE_ID,ITEM_ID"),
 ("DIV+SITE  (거래처 단위)", "DIVISION_ID,SCM_SITE_ID"),
]
for tbl, divs in (("DM_PLN_CFM_SELLING_PRICE", ("40",)),
                  ("SCM_MST_FUTURE_PRICE", ("81", "82"))):
    for div in divs:
        print("\n=== {} · DIV {} · MEASURE='LOC' · YYYYMMDD>=20260101 ===".format(tbl, div))
        for name, cols in GRAN:
            cur.execute("""
              SELECT COUNT(*) KEYS, SUM(CASE WHEN K>1 THEN 1 ELSE 0 END) MULTI
                FROM ( SELECT {c}, COUNT(DISTINCT CURRENCY) K
                         FROM SCM_MGR.{t}
                        WHERE DIVISION_ID=:d AND MEASURE='LOC' AND YYYYMMDD>='20260101'
                          AND CURRENCY IS NOT NULL
                        GROUP BY {c} )""".format(c=cols, t=tbl), d=div)
            k, mu = cur.fetchone()
            pct = (mu or 0) / (k or 1) * 100
            print("   {:36s} 키 {:>7,d}  통화2종이상 {:>5,d} ({:4.1f}%)  {}".format(
                name, k or 0, mu or 0, pct, "안전" if not mu else ""))
