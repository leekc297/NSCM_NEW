# -*- coding: utf-8 -*-
"""DMF0074 Excel Upload — 실제 스테이징/검증 메시지 조회 (읽기 전용)"""
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

print("== SCM_ADM_EXCEL_UPLOAD — DMF0074 계열 최근 배치 ==")
cur.execute("""
  SELECT PROGRAM_ID, CREATED_BY,
         TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') CD,
         UPLOAD_STATUS_CODE, COUNT(*) CNT,
         MIN(ATTRIBUTE1) DIV
    FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
   WHERE PROGRAM_ID LIKE 'DMF0074%'
   GROUP BY PROGRAM_ID, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS'),
            UPLOAD_STATUS_CODE
   ORDER BY 3 DESC FETCH FIRST 20 ROWS ONLY""")
for r in cur:
    print("  {:12s} {:14s} {} {:10s} {:5d}행 DIV={}".format(
        str(r[0]), str(r[1]), r[2], str(r[3]), r[4], r[5]))

print("\n== 오류 메시지 분포 (DMF0074 계열) ==")
cur.execute("""
  SELECT PROGRAM_ID, MIN(ATTRIBUTE1) DIV, MESSAGE_TEXT, COUNT(*) CNT,
         MAX(TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI')) LAST_AT
    FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
   WHERE PROGRAM_ID LIKE 'DMF0074%' AND MESSAGE_TEXT IS NOT NULL
   GROUP BY PROGRAM_ID, MESSAGE_TEXT
   ORDER BY 5 DESC, 4 DESC FETCH FIRST 25 ROWS ONLY""")
for r in cur:
    print("  {:12s} DIV={:4s} {:5d}건 {} | {}".format(
        str(r[0]), str(r[1]), r[3], r[4], str(r[2])[:90]))

print("\n== 최근 DMF0074 업로드의 ATTRIBUTE 실값 (앞 13칸) ==")
cur.execute("""
  SELECT PROGRAM_ID, UPLOAD_STATUS_CODE, MESSAGE_TEXT,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6,
         ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11
    FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
   WHERE PROGRAM_ID LIKE 'DMF0074%'
   ORDER BY CREATION_DATE DESC FETCH FIRST 6 ROWS ONLY""")
for r in cur:
    print("  {:12s} {:8s} {}".format(str(r[0]), str(r[1]), str(r[2])[:40]))
    print("      ATTR1~11:", [str(x)[:18] if x is not None else "" for x in r[3:]])
