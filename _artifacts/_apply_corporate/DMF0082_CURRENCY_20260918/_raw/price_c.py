# -*- coding: utf-8 -*-
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

VER, DIV, ITEM = "MF_W_20260825_V001", "81", "ACEN1063I-D1"
cur.execute("SELECT YYYYMMDD, VERSION_TYPE FROM SCM_MGR.DM_MST_VERSION WHERE VERSION_NO=:v AND DIVISION_ID=:d", v=VER, d=DIV)
print("버전 기준일:", cur.fetchall())

print("\n== SCM_MST_FUTURE_PRICE_C — DIV 81 CUTOFF 별 (ITEM 무관) ==")
cur.execute("""SELECT CUTOFF_YYYYMMDD, COUNT(*) FROM SCM_MGR.SCM_MST_FUTURE_PRICE_C
                WHERE DIVISION_ID='81' GROUP BY CUTOFF_YYYYMMDD
                ORDER BY 1 DESC FETCH FIRST 8 ROWS ONLY""")
for r in cur: print("   {} {:>10,d}".format(r[0], r[1]))

print("\n== SCM_MST_FUTURE_PRICE_C — 해당 ITEM ==")
cur.execute("""SELECT CUTOFF_YYYYMMDD, COUNT(*) FROM SCM_MGR.SCM_MST_FUTURE_PRICE_C
                WHERE DIVISION_ID='81' AND ITEM_ID=:i GROUP BY CUTOFF_YYYYMMDD
                ORDER BY 1 DESC FETCH FIRST 8 ROWS ONLY""", i=ITEM)
rows = cur.fetchall()
print("   " + (str(rows) if rows else "*** 0건 ***"))

print("\n== 전 division CUTOFF 최신 (SCM_MST_FUTURE_PRICE_C) ==")
cur.execute("""SELECT DIVISION_ID, MAX(CUTOFF_YYYYMMDD), COUNT(*) FROM SCM_MGR.SCM_MST_FUTURE_PRICE_C
                GROUP BY DIVISION_ID ORDER BY 1""")
for r in cur: print("   {:8s} max_cutoff={} {:>12,d}".format(str(r[0]), r[1], r[2]))

print("\n== DM_PLN_CFM_SELLING_PRICE_C (40 축) ==")
cur.execute("""SELECT DIVISION_ID, MAX(CUTOFF_YYYYMMDD), COUNT(*) FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C
                GROUP BY DIVISION_ID ORDER BY 1""")
for r in cur: print("   {:8s} max_cutoff={} {:>12,d}".format(str(r[0]), r[1], r[2]))
