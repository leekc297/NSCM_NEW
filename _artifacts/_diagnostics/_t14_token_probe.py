#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 업로드 헤더 토큰 ↔ ATTRIBUTE 매핑 + 주차 토큰 소비 지점 확인."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("SELECT HEADER_CONTENT FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0014'")
h = cur.fetchone()[0]
toks = str(h).split("|")
print(f"# DMF0014 HEADER_CONTENT — {len(toks)} 토큰 (ATTRIBUTE1~{len(toks)})")
for i, t in enumerate(toks, 1):
    print(f"   ATTRIBUTE{i:<3} = {t}")

print("\n# 주차 토큰(W27~W31) 소비 지점 — PKG_DMF0014 BODY")
cur.execute("""SELECT LINE, TRIM(TEXT) FROM ALL_SOURCE
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY'
               AND (INSTR(TEXT,'ATTRIBUTE14')>0 OR INSTR(TEXT,'W27')>0)
               ORDER BY LINE FETCH FIRST 20 ROWS ONLY""")
rows = cur.fetchall()
if not rows:
    print("   (ATTRIBUTE14/W27 직접 참조 없음 — 동적 처리 추정)")
for r in rows:
    print(f"   {r[0]:6} {r[1][:110]}")

print("\n# 업로드 SP 가 스테이징에서 주차를 어떻게 푸는가 (UNPIVOT/LOOP 탐색)")
cur.execute("""SELECT LINE, TRIM(TEXT) FROM ALL_SOURCE
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY'
               AND (INSTR(UPPER(TEXT),'UNPIVOT')>0 OR INSTR(UPPER(TEXT),'SCM_ADM_EXCEL_UPLOAD')>0)
               ORDER BY LINE FETCH FIRST 15 ROWS ONLY""")
for r in cur.fetchall():
    print(f"   {r[0]:6} {r[1][:110]}")

print("\n# DMF0014 메인 GET SP 시그니처 (Excel Form IN 축의 원천)")
cur.execute("""SELECT POSITION, ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS
               WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0014'
               AND OBJECT_NAME='P_DMF0014_GET_CUST_FCST_UPLOAD_DATA' ORDER BY POSITION""")
for r in cur.fetchall():
    print(f"   {r[0]:>3} {r[1]:<24} {r[2]:<12} {r[3]}")

con.close()
