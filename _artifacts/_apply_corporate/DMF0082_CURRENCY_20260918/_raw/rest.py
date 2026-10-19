# -*- coding: utf-8 -*-
"""잔존 10행 원인 — 해당 8키에 LOC/통화가 존재하는가"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()
rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
             ["40","ALL","ALL","ALL","20260101","20271231","ALL","MIF489266C11",
              "Current","Y","minyonglee1","ADMIN","ALL","ALL","ALL","ALL"] + rc)
print("RESULT:", rc[5].getvalue().fetchall()[:1])
print("\n== MIF489266C11 GTT 전체 ==")
cur.execute("""SELECT MEASURE, CELL_PROD_SITE_ID, SCM_SITE_ID, COUNT(*),
                      SUM(CASE WHEN CURRENCY IS NULL THEN 1 ELSE 0 END) NUL, MAX(CURRENCY)
                 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
                GROUP BY MEASURE, CELL_PROD_SITE_ID, SCM_SITE_ID ORDER BY 3,1""")
for r in cur:
    print("   {:14s} cell={:8s} {:22s} {:5d}행 NULL={:4d} CUR={}".format(
        r[0], str(r[1]), str(r[2])[:22], r[3], r[4], r[5]))
print("\n== 원장 DM_PLN_CFM_SELLING_PRICE — 이 ITEM 의 LOC 통화 ==")
cur.execute("""SELECT SCM_SITE_ID, CELL_PROD_SITE_ID, MEASURE, COUNT(*), MAX(CURRENCY),
                      MIN(YYYYMMDD), MAX(YYYYMMDD)
                 FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE
                WHERE DIVISION_ID='40' AND ITEM_ID='MIF489266C11' AND YYYYMMDD>='20260101'
                GROUP BY SCM_SITE_ID, CELL_PROD_SITE_ID, MEASURE ORDER BY 1,3""")
rows = cur.fetchall()
print("   " + ("\n   ".join(str(r) for r in rows) if rows else "*** 0건 ***"))
