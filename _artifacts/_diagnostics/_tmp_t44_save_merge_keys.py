#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""TO-BE P_DMF0044_SAVE_SALES_PLAN_REPORT_C 의 구조 — MERGE ON 키 / GTT / 흐름 (조회 전용)
   ETC_REPORT_C 추가 반영 시 재사용할 '화면이 실제로 주는 키' 확보 목적"""
import sys, pathlib, re
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN 3753 AND 4440 ORDER BY LINE""")
rows = cur.fetchall()
body = {ln: tx.rstrip() for ln, tx in rows}

def sec(t): print("\n" + "=" * 116); print(t); print("=" * 116)

sec("[1] 프로시저 시그니처 (화면이 주는 파라미터 = 사용 가능한 키)")
for ln in sorted(body):
    if ln < 3790:
        print(f"  {ln:5d} | {body[ln][:150]}")

sec("[2] 흐름 골격 (DML / GTT)")
for ln in sorted(body):
    s = body[ln].strip()
    if s.startswith('--'):
        continue
    if re.search(r'\b(MERGE\s+INTO|INSERT\s+INTO|UPDATE\s+|DELETE\s+FROM|COMMIT|ROLLBACK)\b', s, re.I):
        print(f"  {ln:5d} | {s[:150]}")

sec("[3] MERGE ON 키 (L4027 블록)")
start = None
for ln in sorted(body):
    if 'MERGE INTO' in body[ln] and ln >= 4020:
        start = ln
        break
if start:
    for ln in range(start, min(start + 60, max(body) + 1)):
        if ln in body:
            print(f"  {ln:5d} | {body[ln][:160]}")
            if re.search(r'\bWHEN\s+MATCHED\b', body[ln], re.I):
                break

con.close()
