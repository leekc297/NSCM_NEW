# -*- coding: utf-8 -*-
"""DIV 전체 1회 조회 후 GTT 전수 스윕 — '같은 9키에 LOC 가 있는데 CURRENCY 가 NULL' 인 행 탐색"""
import re, pathlib, sys, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

DIV = sys.argv[1] if len(sys.argv) > 1 else "40"
FR, TO = "20260601", "20271231"
t0 = time.time()
rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
             [DIV, "ALL", "ALL", "ALL", FR, TO, "ALL", "ALL",
              "Current", "Y", "minyonglee1", "ADMIN", "ALL", "ALL", "ALL", "ALL"] + rc)
print("DIV {} Current {}~{}  RESULT={}  {:.0f}s".format(
    DIV, FR, TO, rc[5].getvalue().fetchall()[:1], time.time() - t0))

cur.execute("""SELECT COUNT(*), SUM(CASE WHEN CURRENCY IS NULL THEN 1 ELSE 0 END)
                 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE""")
tot, nul = cur.fetchone()
print("GTT {:,}행 / CURRENCY NULL {:,}행".format(tot, nul or 0))

print("\n== MEASURE 별 결손 ==")
cur.execute("""SELECT MEASURE, COUNT(*), SUM(CASE WHEN CURRENCY IS NULL THEN 1 ELSE 0 END)
                 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE GROUP BY MEASURE ORDER BY 3 DESC, 1""")
for r in cur:
    print("   {:24s} {:8,d} NULL={:8,d}{}".format(r[0], r[1], r[2], "  <==" if r[2] else ""))

print("\n== 핵심: 같은 9키에 LOC(계획구간) 가 있는데 CURRENCY 가 NULL 인 행 ==")
cur.execute("""
WITH LOC_KEY AS (
  SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
         INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) CUR
    FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE MEASURE='LOC'
   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
            INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID)
SELECT A.MEASURE, COUNT(*) NULL_CNT,
       SUM(CASE WHEN L.CUR IS NOT NULL THEN 1 ELSE 0 END) SAME_KEY_LOC,
       SUM(CASE WHEN L.CUR IS NULL THEN 1 ELSE 0 END) NO_SAME_KEY_LOC
  FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
  LEFT JOIN LOC_KEY L
    ON L.DIVISION_ID=A.DIVISION_ID AND L.PROJECT_CODE=A.PROJECT_CODE
   AND L.SCM_SITE_ID=A.SCM_SITE_ID AND L.PLANT_SITE_ID=A.PLANT_SITE_ID
   AND L.ITEM_ID=A.ITEM_ID AND L.INCOTERMS=A.INCOTERMS AND L.DOM_EXP=A.DOM_EXP
   AND L.FCST_TYPE=A.FCST_TYPE AND L.CELL_PROD_SITE_ID=A.CELL_PROD_SITE_ID
 WHERE A.CURRENCY IS NULL
 GROUP BY A.MEASURE ORDER BY 2 DESC""")
print("   {:24s} {:>10s} {:>14s} {:>16s}".format("MEASURE","NULL행","같은키 LOC 有","같은키 LOC 無"))
for r in cur:
    print("   {:24s} {:10,d} {:14,d} {:16,d}".format(r[0], r[1], r[2], r[3]))

print("\n== ITEM 축을 느슨하게: 같은 ITEM+SITE 에 LOC 가 있는데 NULL 인 행 (키 불일치 후보) ==")
cur.execute("""
WITH LOC_I AS (
  SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, ITEM_ID FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
   WHERE MEASURE='LOC')
SELECT A.MEASURE, COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
  JOIN LOC_I L ON L.DIVISION_ID=A.DIVISION_ID AND L.SCM_SITE_ID=A.SCM_SITE_ID AND L.ITEM_ID=A.ITEM_ID
 WHERE A.CURRENCY IS NULL GROUP BY A.MEASURE ORDER BY 2 DESC""")
rows = cur.fetchall()
for r in rows:
    print("   {:24s} {:10,d}".format(r[0], r[1]))
if not rows:
    print("   (없음)")
