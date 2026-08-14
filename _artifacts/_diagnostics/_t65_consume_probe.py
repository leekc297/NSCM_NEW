#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""No.65 — 메타 실소비 확인(hook #130): 81 조회 커서가 PROJECT_CODE / Cust FCST measure 를 실제로 내려주는가."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

outs = [con.cursor() for _ in range(6)]
cur.callproc(
    "SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT",
    ["81", "", "", "", "20260801", "20260831", "", "", "Current", "Y",
     "minyonglee1", "minyonglee1", "", "", "", ""] + outs,
)
rc1 = outs[0]
cols = [c[0] for c in rc1.description]
rows = rc1.fetchall()
static = [c for c in cols if not c.startswith(("M_", "W_", "D_"))]
print(f"# div=81 GET(CURRENT) O_RC1 — 총 {len(cols)}컬럼 / 정적 {len(static)}컬럼 / {len(rows)}행")
print(f"  정적 컬럼 = {static}\n")
for key in ("PROJECT_CODE", "END_CUSTOMER", "PROJECT_NAME", "PROJECT_OWNER"):
    print(f"  [{key}] 커서 포함 = {key in cols}")

if "MEASURE" in cols:
    mi = cols.index("MEASURE")
    from collections import Counter
    c = Counter(str(r[mi]) for r in rows)
    print(f"\n# measure 분포({len(c)}종) = {dict(c)}")
    print(f"  [CUST_FCST] 실산출 = {c.get('CUST_FCST', 0)}행")

con.close()
