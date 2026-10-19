# -*- coding: utf-8 -*-
"""3 ITEM 동시 조회 시 잔존하는 결손 행의 9키 전체를 덤프하고, 같은 8키의 LOC 존재 여부를 본다"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
             ["40","ALL","ALL","ALL","20260101","20271231","ALL",
              "MIF489266C11,MCCM131012A1,MCCH350040A1T001",
              "Current","Y","minyonglee1","ADMIN","ALL","ALL","ALL","ALL"] + rc)
print("RESULT:", rc[5].getvalue().fetchall()[:1])

print("\n== 잔존 결손 행의 9키 ==")
cur.execute("""SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                      INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MEASURE, COUNT(*)
                 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
                WHERE CURRENCY IS NULL AND MEASURE NOT LIKE 'VMI%'
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                         INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MEASURE
                ORDER BY 5,3,10""")
bad = cur.fetchall()
for r in bad:
    print("   " + " | ".join(str(x) for x in r))

if bad:
    b = bad[0]
    print("\n== 같은 ITEM+SITE 의 GTT LOC 행 (9키 전체) ==")
    cur.execute("""SELECT PROJECT_CODE, PLANT_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE,
                          CELL_PROD_SITE_ID, COUNT(*), MIN(YYYYMMDD), MAX(YYYYMMDD), MAX(CURRENCY)
                     FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
                    WHERE ITEM_ID=:i AND SCM_SITE_ID=:s AND MEASURE='LOC'
                    GROUP BY PROJECT_CODE, PLANT_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE,
                             CELL_PROD_SITE_ID""", i=b[4], s=b[2])
    rows = cur.fetchall()
    print("   " + ("\n   ".join(" | ".join(str(x) for x in r) for r in rows) if rows else "*** GTT 에 LOC 0건 ***"))

    print("\n== 원장 단가의 9키 (같은 ITEM+SITE) ==")
    cur.execute("""SELECT PROJECT_CODE, PLANT_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE,
                          CELL_PROD_SITE_ID, MEASURE, COUNT(*), MIN(YYYYMMDD), MAX(YYYYMMDD), MAX(CURRENCY)
                     FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE
                    WHERE DIVISION_ID='40' AND ITEM_ID=:i AND SCM_SITE_ID=:s AND MEASURE='LOC'
                      AND YYYYMMDD>='20260101'
                    GROUP BY PROJECT_CODE, PLANT_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE,
                             CELL_PROD_SITE_ID, MEASURE""", i=b[4], s=b[2])
    for r in cur:
        print("   " + " | ".join(str(x) for x in r))
