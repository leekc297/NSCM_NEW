# -*- coding: utf-8 -*-
"""E2E 확정 — CELL_PROD_SITE_ID 만 어긋난 키에서 CURRENCY 가 비는지"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

ITEMS = "MIF489266C11,MCCM131012A1,MCCH350040A1T001"
rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
             ["40", "ALL", "ALL", "ALL", "20260101", "20271231", "ALL", ITEMS,
              "Current", "Y", "minyonglee1", "ADMIN", "ALL", "ALL", "ALL", "ALL"] + rc)
print("RESULT:", rc[5].getvalue().fetchall()[:1])

print("\n== 키 × MEASURE × CURRENCY (결손 키만) ==")
cur.execute("""
SELECT ITEM_ID, SCM_SITE_ID, CELL_PROD_SITE_ID, MEASURE,
       COUNT(*) CNT, SUM(CASE WHEN CURRENCY IS NULL THEN 1 ELSE 0 END) NUL,
       MAX(CURRENCY) CUR
  FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
 WHERE ITEM_ID IN ('MIF489266C11','MCCM131012A1','MCCH350040A1T001')
 GROUP BY ITEM_ID, SCM_SITE_ID, CELL_PROD_SITE_ID, MEASURE
 ORDER BY 1,2,3,4""")
print("  {:18s} {:24s} {:10s} {:14s} {:>6s} {:>6s} {}".format(
    "ITEM","SCM_SITE","CELLPROD","MEASURE","CNT","NULL","CUR"))
for r in cur:
    flag = "   <== 결손" if r[5] else ""
    print("  {:18s} {:24s} {:10s} {:14s} {:6d} {:6d} {}{}".format(
        r[0], str(r[1])[:24], str(r[2]), r[3], r[4], r[5], str(r[6]), flag))
