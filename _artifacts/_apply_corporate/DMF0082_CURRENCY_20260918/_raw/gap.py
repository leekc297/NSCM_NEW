# -*- coding: utf-8 -*-
"""SSPM 에는 있는데 MKT_FCST 가 없는 ITEM 규모 실측 (읽기 전용)"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

for div in ('40','81','82'):
    cur.execute("""
      SELECT COUNT(*) AS SSPM_VALID_KEYS,
             SUM(CASE WHEN F.C IS NULL THEN 1 ELSE 0 END) AS NO_MKT_FCST
        FROM ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                 FROM SCM_MGR.SCM_MST_SITE_ITEM
                WHERE DIVISION_ID = :d AND VALID_YN = 'Y' ) S
        LEFT JOIN ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, 1 C
                      FROM SCM_MGR.DM_PLN_MKT_FCST
                     WHERE DIVISION_ID = :d AND MEASURE = 'MKT_FCST' AND QTY <> 0 ) F
          ON F.DIVISION_ID=S.DIVISION_ID AND F.PROJECT_CODE=S.PROJECT_CODE
         AND F.SCM_SITE_ID=S.SCM_SITE_ID AND F.ITEM_ID=S.ITEM_ID""", d=div)
    tot, gap = cur.fetchone()
    print("DIV {:3s}  SSPM 유효키 {:>8,d}   MKT_FCST 없음 {:>8,d}  ({:4.1f}%)".format(
        div, tot, gap or 0, (gap or 0)/(tot or 1)*100))

print("\n== DIV 40 — MKT_FCST 없는 SSPM 키 예시 (ITEM 단위 상위) ==")
cur.execute("""
  SELECT S.ITEM_ID, COUNT(*) 키수, MIN(S.SCM_SITE_ID), MIN(S.PROJECT_CODE)
    FROM ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
             FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE DIVISION_ID='40' AND VALID_YN='Y' ) S
    LEFT JOIN ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, 1 C
                  FROM SCM_MGR.DM_PLN_MKT_FCST
                 WHERE DIVISION_ID='40' AND MEASURE='MKT_FCST' AND QTY<>0 ) F
      ON F.DIVISION_ID=S.DIVISION_ID AND F.PROJECT_CODE=S.PROJECT_CODE
     AND F.SCM_SITE_ID=S.SCM_SITE_ID AND F.ITEM_ID=S.ITEM_ID
   WHERE F.C IS NULL
   GROUP BY S.ITEM_ID ORDER BY 2 DESC FETCH FIRST 8 ROWS ONLY""")
for r in cur: print("   {:24s} {:5d}키  예: {} / {}".format(str(r[0]), r[1], r[2], r[3]))
