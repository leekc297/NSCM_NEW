# -*- coding: utf-8 -*-
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()
KEYS = ['SITE','PROJECT','MODEL','CUSTOMER','CUST','MAPPING','PRICE','FCST','EDI','STOCK','INVENTORY','VMI']
cur.execute("""SELECT M.MNU_ID, NVL((SELECT S.MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M S
                        WHERE S.MSG_ID=M.MNU_MSG_ID AND S.LANG_CD='KO'), M.MNU_DESC) NM,
                      M.UPPR_MNU_ID, M.USE_YN, M.ROUTE_PATH
                 FROM SCM_MGR.SCM_ADM_MNU_M M
                WHERE M.MNU_ID LIKE 'DMF%' ORDER BY 1""")
rows = cur.fetchall()
print("DM 화면 {}개 중 관련 후보".format(len(rows)))
for r in rows:
    nm = (r[1] or '').upper()
    if any(k in nm for k in KEYS):
        print("  {:9s} {:34s} UPPR={:16s} USE={} {}".format(
            r[0], str(r[1])[:34], str(r[2])[:16], r[3], r[4]))
