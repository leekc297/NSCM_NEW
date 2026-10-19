# -*- coding: utf-8 -*-
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()
CAND = ["DM_PLN_SALES_PLAN_RESULT", "DM_PLN_MKT_FCST_RESULT",
        "DM_DNM_EDI_CALLOFF_ITEM", "DM_DNM_EDI_CALLOFF_HEAD",
        "DM_MST_CUSTOMER_FCST", "DM_CUST_MODEL_MAPPING_M", "DM_MST_CUSTOMER_MODEL"]
for t in CAND:
    try:
        cur.execute("SELECT COUNT(*) FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=t)
        if not cur.fetchone()[0]:
            print("{:30s} — 없음".format(t)); continue
        cur.execute("SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND COLUMN_NAME='DIVISION_ID'", t=t)
        if cur.fetchone()[0]:
            cur.execute("SELECT DIVISION_ID, COUNT(*) FROM SCM_MGR.{} GROUP BY DIVISION_ID ORDER BY 2 DESC FETCH FIRST 5 ROWS ONLY".format(t))
            print("{:30s} {}".format(t, [(r[0], r[1]) for r in cur]))
        else:
            cur.execute("SELECT COUNT(*) FROM SCM_MGR.{}".format(t))
            print("{:30s} 총 {:,}행 (DIVISION_ID 없음)".format(t, cur.fetchone()[0]))
    except Exception as e:
        print("{:30s} ERR {}".format(t, str(e)[:50]))
print("\n== 재고/VMI 테이블 후보 ==")
cur.execute("""SELECT TABLE_NAME, NUM_ROWS FROM ALL_TABLES WHERE OWNER='SCM_MGR'
   AND (TABLE_NAME LIKE '%VMI%' OR TABLE_NAME LIKE '%INVEN%' OR TABLE_NAME LIKE '%STOCK%')
   AND TABLE_NAME NOT LIKE 'GT_%' AND TABLE_NAME NOT LIKE '%BAK%' AND TABLE_NAME NOT LIKE '%_H'
   ORDER BY NVL(NUM_ROWS,0) DESC FETCH FIRST 8 ROWS ONLY""")
for r in cur: print("   {:40s} {}".format(r[0], r[1]))
