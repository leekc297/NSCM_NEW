# -*- coding: utf-8 -*-
"""DMF0074 Excel Upload 조사 — 메타·SP 원문 (읽기 전용)"""
import re
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()

print("== SCM_ADM_EXCEL_COLUMNS / DMF0074 ==")
cur.execute("""SELECT SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT,
                      OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN, XLS_COLUMN_CODE_MATCH
                 FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0074'""")
for r in cur:
    h = r[2]
    h = h.read() if hasattr(h, "read") else h
    print("  SHEET={} SQL_ID={} VALID={} MATCH={}".format(r[0], r[1], r[4], r[5]))
    print("  OPTION_ATTR_COL_NO={}".format(r[3]))
    print("  HEADER_CONTENT:")
    print("   ", (h or "")[:1500])

print("\n== PKG_DMF0074 객체 ==")
cur.execute("""SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                 FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0074'""")
for r in cur:
    print("  ", r)

cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074'
                AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur)
out = pathlib.Path(__file__).resolve().parent / "x_PKG_DMF0074_BODY.sql"
out.write_text(body, encoding="utf-8")
print("  BODY {} lines → {}".format(body.count(chr(10)) + 1, out.name))
print("  PROCEDURE:", re.findall(r"PROCEDURE\s+(P_DMF0074_\w+)", body))

print("\n== UPLOAD 관련 지점 ==")
for i, ln in enumerate(body.split("\n"), 1):
    if re.search(r"UPLOAD|EXCEL|ATTRIBUTE\d+\s*(?:,|\))|COL\d+", ln, re.I):
        if re.search(r"PROCEDURE|SCM_ADM_EXCEL_UPLOAD|p_col|COL\d{1,2}", ln, re.I):
            print("  L{:<5d} {}".format(i, ln.strip()[:150]))
