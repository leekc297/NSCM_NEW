# -*- coding: utf-8 -*-
"""DMF0082 조회 재현 — GTT 의 MEASURE 별 CURRENCY 결손 실측 (읽기 전용 GET proc)"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()

DIV, ITEM = "81", "ACEN1063I-D1"
VER = "MF_W_20260825_V001"
FROM_YMD, TO_YMD = "20260101", "20271231"
rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
             [DIV, "ALL", "ALL", "ALL", FROM_YMD, TO_YMD, "ALL", ITEM,
              VER, "Y", "minyonglee1", "ADMIN", "ALL", "ALL", "ALL", "ALL"] + rc)
res = rc[5].getvalue().fetchall()
print("VER:", VER); print("RESULT:", res[:2])

print("\n== GT_DMF0082_TEMP_FCST_N_PRICE — MEASURE 별 CURRENCY 결손 ==")
cur.execute("""
  SELECT MEASURE || ' @' || CELL_PROD_SITE_ID,
         COUNT(*) CNT,
         SUM(CASE WHEN CURRENCY IS NULL THEN 1 ELSE 0 END) NULL_CNT,
         MIN(YYYYMMDD) MN, MAX(YYYYMMDD) MX,
         COUNT(DISTINCT CURRENCY) CUR_KINDS
    FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
   GROUP BY MEASURE, CELL_PROD_SITE_ID ORDER BY 3 DESC, 1""")
print("  {:34s} {:>7s} {:>8s} {:>9s} {:>9s} {:>4s}".format("MEASURE","CNT","NULL","MIN","MAX","KIND"))
for r in cur:
    flag = "  <== 결손" if r[2] else ""
    print("  {:34s} {:7d} {:8d} {:>9s} {:>9s} {:4d}{}".format(
        r[0], r[1], r[2], str(r[3]), str(r[4]), r[5], flag))
