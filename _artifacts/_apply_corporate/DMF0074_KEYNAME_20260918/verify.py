# -*- coding: utf-8 -*-
"""[E20260918-KEYNAMETOCODE] 검증 — 사용자 실제 배치 재검증 (사내 ZIOUI1)"""
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()

print("== 최근 DMF0074 배치 ==")
cur.execute("""
  SELECT PROGRAM_ID, SHEET_NAME, CREATED_BY,
         TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3') CD,
         COUNT(*) CNT, MIN(ATTRIBUTE1) DIV
    FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
   WHERE PROGRAM_ID LIKE 'DMF0074%'
   GROUP BY PROGRAM_ID, SHEET_NAME, CREATED_BY,
            TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3')
   ORDER BY 4 DESC FETCH FIRST 5 ROWS ONLY""")
batches = cur.fetchall()
for b in batches:
    print("  {} | {} | {} | {}행 DIV={}".format(b[0], b[3], b[2], b[4], b[5]))
if not batches:
    print("  배치 없음 — 중단"); sys.exit(1)

pid, sheet, who, cd, cnt, div = batches[0]
print("\n대상 배치: {} {} {} ({}행)".format(pid, cd, who, cnt))

print("\n== [BEFORE] Key_Ni 원값 분포 ==")
keycol = "ATTRIBUTE12" if str(div) == "40" else "ATTRIBUTE14"
cur.execute("""SELECT {k}, UPLOAD_STATUS_CODE, MESSAGE_TEXT, COUNT(*)
                 FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                WHERE PROGRAM_ID=:1 AND SHEET_NAME=:2 AND CREATED_BY=:3
                  AND TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3')=:4
                GROUP BY {k}, UPLOAD_STATUS_CODE, MESSAGE_TEXT
                ORDER BY 4 DESC""".format(k=keycol), [pid, sheet, who, cd])
for r in cur:
    print("  {}={!r:10s} {:8s} {!r:30s} {}건".format(
        keycol, str(r[0]), str(r[1]), str(r[2]), r[3]))

print("\n== P_MODE=0 재검증 실행 ==")
rc = cur.var(oracledb.CURSOR)
cur.callproc("SCM_MGR.PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD", [0, who, pid, sheet, rc])
c = rc.getvalue()
cols = [d[0] for d in c.description]
for r in c.fetchall():
    print("  결과커서:", dict(zip(cols, r)))
db.commit()

print("\n== [AFTER] Key_Ni 값 + 검증 결과 ==")
cur.execute("""SELECT {k}, UPLOAD_STATUS_CODE, MESSAGE_TEXT, COUNT(*)
                 FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                WHERE PROGRAM_ID=:1 AND SHEET_NAME=:2 AND CREATED_BY=:3
                  AND TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3')=:4
                GROUP BY {k}, UPLOAD_STATUS_CODE, MESSAGE_TEXT
                ORDER BY 4 DESC""".format(k=keycol), [pid, sheet, who, cd])
for r in cur:
    print("  {}={!r:10s} {:8s} {!r:30s} {}건".format(
        keycol, str(r[0]), str(r[1]), str(r[2]), r[3]))

print("\n== 오류 메시지 집계 ==")
cur.execute("""SELECT NVL(MESSAGE_TEXT,'(없음)'), COUNT(*)
                 FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                WHERE PROGRAM_ID=:1 AND SHEET_NAME=:2 AND CREATED_BY=:3
                  AND TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3')=:4
                GROUP BY MESSAGE_TEXT ORDER BY 2 DESC""", [pid, sheet, who, cd])
for r in cur:
    print("  {:40s} {}건".format(str(r[0]), r[1]))
