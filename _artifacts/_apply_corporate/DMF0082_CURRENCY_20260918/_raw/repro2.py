# -*- coding: utf-8 -*-
"""첨부 케이스 재현 — Unit Price 존재 + RTF CURRENCY 결손 (40 / MCSS22561-C1 / Current)"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

DIV, ITEM = "40", "MCSS22561-C1"
rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
             [DIV, "ALL", "ALL", "ALL", "20260101", "20271231", "ALL", ITEM,
              "Current", "Y", "minyonglee1", "ADMIN", "ALL", "ALL", "ALL", "ALL"] + rc)
print("RESULT:", rc[5].getvalue().fetchall()[:1])

print("\n== MEASURE 별 CURRENCY 결손 ==")
cur.execute("""SELECT MEASURE, COUNT(*) CNT,
                      SUM(CASE WHEN CURRENCY IS NULL THEN 1 ELSE 0 END) NUL,
                      MIN(YYYYMMDD), MAX(YYYYMMDD)
                 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
                GROUP BY MEASURE ORDER BY 3 DESC, 1""")
for r in cur:
    print("   {:22s} {:6d} NULL={:6d}  {} ~ {}{}".format(
        r[0], r[1], r[2], r[3], r[4], "   <== 결손" if r[2] else ""))

print("\n== 결손 키 vs 같은 키의 LOC 보유 여부 (9키 대조) ==")
cur.execute("""
WITH BAD AS (
  SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
         INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MEASURE
    FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE CURRENCY IS NULL
), LOCK AS (
  SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
         INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, COUNT(*) LOC_CNT
    FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE MEASURE='LOC'
   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
            INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
)
SELECT B.MEASURE, B.SCM_SITE_ID, B.CELL_PROD_SITE_ID, B.INCOTERMS, B.FCST_TYPE, B.DOM_EXP,
       NVL(L.LOC_CNT,0) LOC_SAME_KEY
  FROM BAD B LEFT JOIN LOCK L
    ON L.DIVISION_ID=B.DIVISION_ID AND L.PROJECT_CODE=B.PROJECT_CODE
   AND L.SCM_SITE_ID=B.SCM_SITE_ID AND L.PLANT_SITE_ID=B.PLANT_SITE_ID
   AND L.ITEM_ID=B.ITEM_ID AND L.INCOTERMS=B.INCOTERMS AND L.DOM_EXP=B.DOM_EXP
   AND L.FCST_TYPE=B.FCST_TYPE AND L.CELL_PROD_SITE_ID=B.CELL_PROD_SITE_ID
 ORDER BY 7, 1, 2 FETCH FIRST 25 ROWS ONLY""")
print("   {:18s} {:26s} {:12s} {:9s} {:10s} {:6s} {}".format(
    "MEASURE","SCM_SITE","CELL_PROD","INCOTERMS","FCST_TYPE","DOM_EXP","같은키 LOC"))
for r in cur:
    print("   {:18s} {:26s} {:12s} {:9s} {:10s} {:6s} {}".format(*[str(x) for x in r]))
