# -*- coding: utf-8 -*-
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()
print("== SSPM 후보 테이블 (SITE/PROJECT/MODEL) ==")
cur.execute("""SELECT TABLE_NAME, NUM_ROWS FROM ALL_TABLES WHERE OWNER='SCM_MGR'
   AND (TABLE_NAME LIKE '%SITE_ITEM%' OR TABLE_NAME LIKE '%SSPM%'
        OR TABLE_NAME LIKE 'SCM_MST_SALES%' OR TABLE_NAME LIKE '%PROJECT_MODEL%')
   AND TABLE_NAME NOT LIKE '%BAK%' AND TABLE_NAME NOT LIKE 'GT_%' ORDER BY 1""")
for r in cur: print("   {:44s} {}".format(r[0], r[1]))
print("\n== Customer FCST / EDI Master 후보 ==")
cur.execute("""SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
   AND (TABLE_NAME LIKE 'DM_MST_CUSTOMER%' OR TABLE_NAME LIKE '%CUST_MAT%'
        OR TABLE_NAME LIKE '%N_N%' OR TABLE_NAME LIKE '%MODEL_MAP%')
   AND TABLE_NAME NOT LIKE '%BAK%' AND TABLE_NAME NOT LIKE 'GT_%' ORDER BY 1""")
for r in cur: print("   ", r[0])
