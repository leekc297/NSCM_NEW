# -*- coding: utf-8 -*-
"""CELL_PROD_SITE_ID 만 어긋나는 키 특정 + 전 기간 규모"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

Q = """
WITH DEM AS (
  SELECT DISTINCT DIVISION_ID d1, PROJECT_CODE d2, SCM_SITE_ID d3, PLANT_SITE_ID d4, ITEM_ID d5,
         INCOTERMS d6, DOM_EXP d7, FCST_TYPE d8, CELL_PROD_SITE_ID d9
    FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
   WHERE DIVISION_ID='40' AND YYYYMMDD >= '20260101' AND QTY<>0
), PRC AS (
  SELECT DISTINCT DIVISION_ID p1, PROJECT_CODE p2, SCM_SITE_ID p3, PLANT_SITE_ID p4, ITEM_ID p5,
         INCOTERMS p6, DOM_EXP p7, FCST_TYPE p8, CELL_PROD_SITE_ID p9
    FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE
   WHERE DIVISION_ID='40' AND YYYYMMDD >= '20260101' AND MEASURE='LOC'
)
SELECT D.d5 ITEM_ID, D.d3 SCM_SITE, D.d2 PROJECT, D.d9 DEM_CELLPROD, P.p9 PRICE_CELLPROD,
       D.d6 INCOTERMS, D.d7 DOM_EXP, D.d8 FCST_TYPE, D.d4 PLANT_SITE
  FROM DEM D
  JOIN PRC P ON P.p1=D.d1 AND P.p2=D.d2 AND P.p3=D.d3 AND P.p4=D.d4 AND P.p5=D.d5
            AND P.p6=D.d6 AND P.p7=D.d7 AND P.p8=D.d8
 WHERE P.p9 <> D.d9
   AND NOT EXISTS (SELECT 1 FROM PRC P2 WHERE P2.p1=D.d1 AND P2.p2=D.d2 AND P2.p3=D.d3
                     AND P2.p4=D.d4 AND P2.p5=D.d5 AND P2.p6=D.d6 AND P2.p7=D.d7
                     AND P2.p8=D.d8 AND P2.p9=D.d9)
 ORDER BY 1,2"""
cur.execute(Q)
rows = cur.fetchall()
print("DIV 40 · 20260101~ · 8키 일치 + CELL_PROD_SITE_ID 만 불일치 = {}건".format(len(rows)))
print("  {:22s} {:26s} {:16s} {:14s} {:14s} {:9s} {:7s} {:10s}".format(
    "ITEM_ID","SCM_SITE","PROJECT","수요CELLPROD","단가CELLPROD","INCOTERMS","DOM_EXP","FCST_TYPE"))
for r in rows:
    print("  {:22s} {:26s} {:16s} {:14s} {:14s} {:9s} {:7s} {:10s}".format(*[str(x)[:26] for x in r[:8]]))
pathlib.Path("bad_keys.txt").write_text(
    "\n".join("\t".join(str(x) for x in r) for r in rows), encoding="utf-8")
