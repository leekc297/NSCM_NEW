# -*- coding: utf-8 -*-
"""잔존 결손 60행 분류 — 설계상 제외(다중통화) vs LOC 부재 vs 미규명"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()
ITEMS = ("MCCM134010A1,MCCM131012A1,MCCM348014A3,MCCM356015A2,MCCM350415B1,"
         "MIF489266C11,MCCH350040A1T001,MCSS22561-C1,MCCM349215A1-111,MCCM348018A3")
rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
             ["40","ALL","ALL","ALL","20260101","20271231","ALL",ITEMS,
              "Current","Y","minyonglee1","ADMIN","ALL","ALL","ALL","ALL"] + rc)
print("RESULT:", rc[5].getvalue().fetchall()[:1])
cur.execute("""
WITH L AS (SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                  COUNT(DISTINCT CURRENCY) KINDS
             FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
            WHERE MEASURE='LOC' AND CURRENCY IS NOT NULL
              GROUP BY DIVISION_ID, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE)
SELECT CASE WHEN L.KINDS IS NULL THEN '단가(LOC) 자체 없음 — 보완대상 아님'
            WHEN L.KINDS > 1   THEN '통화 2종 이상 — 설계상 제외(오배정 방지)'
            ELSE '⚠ 미규명' END AS 분류,
       A.MEASURE, COUNT(*) AS 행수,
       MIN(A.ITEM_ID) AS ITEM_예시, MIN(A.SCM_SITE_ID) AS SITE_예시
  FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
  LEFT JOIN L ON L.DIVISION_ID=A.DIVISION_ID AND L.SCM_SITE_ID=A.SCM_SITE_ID
             AND L.ITEM_ID=A.ITEM_ID AND L.DOM_EXP=A.DOM_EXP AND L.FCST_TYPE=A.FCST_TYPE
 WHERE A.CURRENCY IS NULL AND A.MEASURE NOT LIKE 'VMI%'
 GROUP BY CASE WHEN L.KINDS IS NULL THEN '단가(LOC) 자체 없음 — 보완대상 아님'
               WHEN L.KINDS > 1   THEN '통화 2종 이상 — 설계상 제외(오배정 방지)'
               ELSE '⚠ 미규명' END, A.MEASURE
 ORDER BY 1, 2""")
for r in cur:
    print("   {:44s} {:14s} {:4d}행   예: {} / {}".format(*[str(x) for x in r[:2]] + [r[2], r[3], r[4]]))
