# -*- coding: utf-8 -*-
"""FRESH-GATE — PKG_DMF0082 최신 원문 수집 (hook #152)"""
import re, pathlib, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()
D = pathlib.Path(__file__).resolve().parent

cur.execute("""SELECT OBJECT_NAME, OBJECT_TYPE, STATUS,
                      TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                 FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082'""")
print("SOURCE-FRESH", datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
for r in cur:
    print("   {} {} STATUS={} LAST_DDL={}".format(*r))

for typ, fn in (("PACKAGE BODY", "PKG_DMF0082_BODY.sql"), ("PACKAGE", "PKG_DMF0082_SPEC.sql")):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
                    AND NAME='PKG_DMF0082' AND TYPE=:t ORDER BY LINE""", t=typ)
    txt = "".join(r[0] for r in cur)
    (D / fn).write_text(txt, encoding="utf-8")
    print("   {:28s} {:6d} lines".format(fn, txt.count(chr(10)) + 1))
