# -*- coding: utf-8 -*-
"""원장 대조(프로시저 무관) — 수요 원장 키가 단가 원장에서 CELL_PROD_SITE_ID 때문에 안 맞는 비율"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

SQL = """
WITH DEM AS (   -- 40 Current 계획구간 수요 arm 원천
  SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
         INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
   WHERE DIVISION_ID='40' AND YYYYMMDD BETWEEN '20260601' AND '20271231' AND QTY<>0
), PRC AS (     -- 40 단가 arm 원천 (LOC)
  SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
         INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE
   WHERE DIVISION_ID='40' AND YYYYMMDD BETWEEN '20260601' AND '20271231' AND MEASURE='LOC'
)
SELECT
  COUNT(*)                                                                AS DEM_KEYS,
  SUM(CASE WHEN P9.C IS NOT NULL THEN 1 ELSE 0 END)                       AS MATCH9,
  SUM(CASE WHEN P9.C IS NULL AND P8.C IS NOT NULL THEN 1 ELSE 0 END)      AS CELLPROD_ONLY_DIFF,
  SUM(CASE WHEN P9.C IS NULL AND P8.C IS NULL THEN 1 ELSE 0 END)          AS NO_PRICE_KEY
FROM DEM D
LEFT JOIN (SELECT DIVISION_ID a1,PROJECT_CODE a2,SCM_SITE_ID a3,PLANT_SITE_ID a4,ITEM_ID a5,
                  INCOTERMS a6,DOM_EXP a7,FCST_TYPE a8,CELL_PROD_SITE_ID a9, 1 C FROM PRC) P9
  ON P9.a1=D.DIVISION_ID AND P9.a2=D.PROJECT_CODE AND P9.a3=D.SCM_SITE_ID AND P9.a4=D.PLANT_SITE_ID
 AND P9.a5=D.ITEM_ID AND P9.a6=D.INCOTERMS AND P9.a7=D.DOM_EXP AND P9.a8=D.FCST_TYPE
 AND P9.a9=D.CELL_PROD_SITE_ID
LEFT JOIN (SELECT DISTINCT DIVISION_ID b1,PROJECT_CODE b2,SCM_SITE_ID b3,PLANT_SITE_ID b4,ITEM_ID b5,
                  INCOTERMS b6,DOM_EXP b7,FCST_TYPE b8, 1 C FROM PRC) P8
  ON P8.b1=D.DIVISION_ID AND P8.b2=D.PROJECT_CODE AND P8.b3=D.SCM_SITE_ID AND P8.b4=D.PLANT_SITE_ID
 AND P8.b5=D.ITEM_ID AND P8.b6=D.INCOTERMS AND P8.b7=D.DOM_EXP AND P8.b8=D.FCST_TYPE
"""
cur.execute(SQL)
c = [d[0] for d in cur.description]; r = cur.fetchone()
print("DIV 40 · 20260601~20271231 · 수요(DM_PLN_CFM_MKT_DEMAND_PLAN) vs 단가(DM_PLN_CFM_SELLING_PRICE LOC)")
for k, v in zip(c, r):
    print("   {:20s} {:>10,d}".format(k, v))
print()
print("→ 'CELLPROD만불일치' = 8키는 맞는데 CELL_PROD_SITE_ID 만 달라 CURRENCY 채움 MERGE 가 실패하는 키")
