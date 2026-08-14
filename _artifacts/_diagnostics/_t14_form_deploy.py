#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form SP 배포 + 컴파일 검증 + 실행 스모크."""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

PKG = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_EXCELFORM_20260814")
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")

for f in ("01_PKG_DMF0014_SPEC.sql", "02_PKG_DMF0014_BODY.sql"):
    txt = (PKG / f).read_text(encoding="utf-8").replace("\r", "")
    txt = txt.replace("SET DEFINE OFF\n", "", 1).rstrip()
    while txt.endswith("/"):
        txt = txt[:-1].rstrip()
    try:
        cur.execute(txt)
        print(f"[deploy] {f} OK")
    except Exception as e:
        print(f"[deploy] {f} FAIL {e}")

cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
               WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0014' ORDER BY 1""")
for r in cur.fetchall():
    print("   " + " | ".join(str(x) for x in r))

cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' ORDER BY SEQUENCE""")
errs = cur.fetchall()
print(f"[errors] {len(errs)}건")
for r in errs[:12]:
    print("   " + " | ".join(str(x)[:100] for x in r))
if errs:
    con.close(); sys.exit(1)

cur.execute("""SELECT COUNT(*) FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR'
               AND PACKAGE_NAME='PKG_DMF0014' AND OBJECT_NAME='P_DMF0014_GET_EXCEL_FORM_DATA'""")
print(f"[args] P_DMF0014_GET_EXCEL_FORM_DATA 인자 {cur.fetchone()[0]}개 (기대 17)")

# 실행 스모크 — 전 division ALL, 최근 구간
print("\n[smoke] 실행 (division=ALL / 최근 90일 / WEEKLY)")
o1, o2 = con.cursor(), con.cursor()
cur.execute("SELECT TO_CHAR(SYSDATE-90,'YYYYMMDD'), TO_CHAR(SYSDATE+90,'YYYYMMDD') FROM DUAL")
fr, to = cur.fetchone()
try:
    cur.callproc("SCM_MGR.PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA",
                 ["ALL", "ALL", "ALL", "ALL", "ALL", "ALL", "ALL", fr, to, "WEEKLY", "ALL",
                  "minyonglee1", "ADMIN", "minyonglee1", "DMF0014", o1, o2])
    cols = [c[0] for c in o1.description]
    rows = o1.fetchmany(3)
    print(f"   O_RC1 컬럼({len(cols)}) = {cols}")
    print(f"   샘플 {len(rows)}행:")
    for r in rows:
        print("     " + " | ".join("" if v is None else str(v)[:18] for v in r))
    rc = o2.fetchall()
    print(f"   O_RESULT_CURSOR = {rc}")
except Exception as e:
    print(f"   ⛔ 실행 실패: {str(e)[:400]}")

con.close()
