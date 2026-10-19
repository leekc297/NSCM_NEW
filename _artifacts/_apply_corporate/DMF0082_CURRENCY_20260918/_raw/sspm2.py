# -*- coding: utf-8 -*-
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()
cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                AND TABLE_NAME='SCM_MST_SITE_ITEM' ORDER BY COLUMN_ID""")
cols=[r[0] for r in cur]
print("SCM_MST_SITE_ITEM 컬럼", len(cols)); print(" ", cols)
print("\n== DIVISION 별 행수 / 유효 ==")
has_valid = 'ITEM_VALID_YN' in cols
sel = "DIVISION_ID, COUNT(*) TOT" + (", SUM(CASE WHEN ITEM_VALID_YN='Y' THEN 1 ELSE 0 END) VALID_Y" if has_valid else "")
cur.execute("SELECT {} FROM SCM_MGR.SCM_MST_SITE_ITEM GROUP BY DIVISION_ID ORDER BY 1".format(sel))
for r in cur: print("   ", r)
