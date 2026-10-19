# -*- coding: utf-8 -*-
"""실적 arm(DM_PLN_SALES_PLAN_RESULT) vs 계획 arm(DM_PLN_CFM_MKT_DEMAND_PLAN) 키 값 불일치 실태
   — 그리드 행이 2행으로 갈리는 원인 컬럼 특정"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

# 업무 키 = 그리드가 같은 행으로 봐야 하는 축 (PLANT/CELL_PROD 제외)
BIZ = "DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE"
Q = """
WITH R AS (  -- 실적 arm 원천
  SELECT {b}, NVL(PLANT_SITE_ID,'(NULL)') PS, NVL(CELL_PROD_SITE_ID,'(NULL)') CP
    FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT
   WHERE DIVISION_ID='40' AND YYYYMMDD>='20260101' AND QTY<>0
   GROUP BY {b}, NVL(PLANT_SITE_ID,'(NULL)'), NVL(CELL_PROD_SITE_ID,'(NULL)')
), P AS (    -- 계획 arm 원천
  SELECT {b}, NVL(PLANT_SITE_ID,'(NULL)') PS, NVL(CELL_PROD_SITE_ID,'(NULL)') CP
    FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
   WHERE DIVISION_ID='40' AND YYYYMMDD>='20260101' AND QTY<>0
   GROUP BY {b}, NVL(PLANT_SITE_ID,'(NULL)'), NVL(CELL_PROD_SITE_ID,'(NULL)')
)
SELECT COUNT(*) AS 공통업무키,
       SUM(CASE WHEN R.PS <> P.PS THEN 1 ELSE 0 END) AS PLANT_SITE_불일치,
       SUM(CASE WHEN R.CP <> P.CP THEN 1 ELSE 0 END) AS CELL_PROD_불일치,
       SUM(CASE WHEN R.PS <> P.PS OR R.CP <> P.CP THEN 1 ELSE 0 END) AS 행분리_발생
  FROM R JOIN P ON {j}
""".format(b=BIZ, j=" AND ".join("R.{0}=P.{0}".format(c.strip()) for c in BIZ.split(",")))
cur.execute(Q)
c = [d[0] for d in cur.description]; r = cur.fetchone()
print("DIV 40 · 2026~ · 실적 arm vs 계획 arm")
for k, v in zip(c, r):
    print("   {:22s} {:>8,d}".format(k, v))

print("\n== 불일치 예시 ==")
cur.execute(Q.replace(
  """SELECT COUNT(*) AS 공통업무키,
       SUM(CASE WHEN R.PS <> P.PS THEN 1 ELSE 0 END) AS PLANT_SITE_불일치,
       SUM(CASE WHEN R.CP <> P.CP THEN 1 ELSE 0 END) AS CELL_PROD_불일치,
       SUM(CASE WHEN R.PS <> P.PS OR R.CP <> P.CP THEN 1 ELSE 0 END) AS 행분리_발생
  FROM R JOIN P ON""",
  """SELECT R.ITEM_ID, R.SCM_SITE_ID, R.PROJECT_CODE, R.PS AS 실적_PLANT, P.PS AS 계획_PLANT,
       R.CP AS 실적_CELLPROD, P.CP AS 계획_CELLPROD
  FROM R JOIN P ON""") + " WHERE R.PS <> P.PS OR R.CP <> P.CP FETCH FIRST 10 ROWS ONLY")
rows = cur.fetchall()
for r in rows:
    print("   " + " | ".join(str(x) for x in r))
if not rows:
    print("   (없음)")
