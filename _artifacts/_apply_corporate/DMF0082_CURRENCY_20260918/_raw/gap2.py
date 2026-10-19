# -*- coding: utf-8 -*-
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()
print("ITEM 단위 — SSPM 유효 ITEM 중 MKT_FCST 가 '한 건도 없는' ITEM")
for div in ('40','81','82'):
    cur.execute("""
      SELECT COUNT(*), SUM(CASE WHEN F.C IS NULL THEN 1 ELSE 0 END)
        FROM (SELECT DISTINCT ITEM_ID FROM SCM_MGR.SCM_MST_SITE_ITEM
               WHERE DIVISION_ID=:d AND VALID_YN='Y') S
        LEFT JOIN (SELECT DISTINCT ITEM_ID, 1 C FROM SCM_MGR.DM_PLN_MKT_FCST
                    WHERE DIVISION_ID=:d AND MEASURE='MKT_FCST' AND QTY<>0) F
          ON F.ITEM_ID = S.ITEM_ID""", d=div)
    t, g = cur.fetchone()
    print("   DIV {:3s}  SSPM ITEM {:>6,d}   MKT_FCST 전무 {:>6,d}  ({:4.1f}%)".format(
        div, t, g or 0, (g or 0)/(t or 1)*100))
print("\nDIV 40 — MKT_FCST 전무 ITEM 중 SSPM 키가 많은 순 (신규생성 후보)")
cur.execute("""
  SELECT S.ITEM_ID, COUNT(*) SSPM키수, COUNT(DISTINCT S.SCM_SITE_ID) 사이트수
    FROM (SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
            FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE DIVISION_ID='40' AND VALID_YN='Y') S
   WHERE S.ITEM_ID NOT IN (SELECT DISTINCT ITEM_ID FROM SCM_MGR.DM_PLN_MKT_FCST
                            WHERE DIVISION_ID='40' AND MEASURE='MKT_FCST' AND QTY<>0)
   GROUP BY S.ITEM_ID ORDER BY 2 DESC FETCH FIRST 8 ROWS ONLY""")
for r in cur: print("   {:24s} {:5d}키 / {:3d}사이트".format(str(r[0]), r[1], r[2]))
