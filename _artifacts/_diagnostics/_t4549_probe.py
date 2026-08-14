#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""No.45/49 — 저장 검증 경로 실측.
 (1) GET_SPREAD_TITLE 이 버킷과 무관하게 D_ 컬럼을 주는가 (FE editableDayColumns 원천)
 (2) 요구 원문 데이터셋의 SITE_ITEM / 판가 원장 실존 여부 (52주 게이트 INNER JOIN 통과 조건)
"""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("## (1) P_DMF0082_GET_SPREAD_TITLE — 컬럼 prefix 분포")
out = con.cursor()
cur.callproc(
    "SCM_MGR.PKG_DMF0082.P_DMF0082_GET_SPREAD_TITLE",
    ["20260801", "20261031", "minyonglee1", "40", out],
)
cols = [c[0] for c in out.description]
rows = out.fetchall()
idx = cols.index("COLUMN_NAME") if "COLUMN_NAME" in cols else 0
from collections import Counter
cnt = Counter(str(r[idx])[:2] for r in rows)
print(f"   컬럼 = {cols}")
print(f"   총 {len(rows)}행 / prefix 분포 = {dict(cnt)}")
print(f"   D_ 예시 = {[str(r[idx]) for r in rows if str(r[idx]).startswith('D_')][:5]}")

print("\n## (2) No.45 요구 데이터셋 — SITE_ITEM 실존 (52주 게이트 INNER JOIN 조건)")
cur.execute(
    """SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, VALID_YN, SALES_PLAN_ADJUST_YN
       FROM   SCM_MGR.SCM_MST_SITE_ITEM
       WHERE  DIVISION_ID='40' AND ITEM_ID='MPCKRMVLTA16'"""
)
r = cur.fetchall()
print(f"   MPCKRMVLTA16 (No.45) → SITE_ITEM {len(r)}행")
for x in r[:8]:
    print("     " + " | ".join(str(v) for v in x))

cur.execute(
    """SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, VALID_YN, SALES_PLAN_ADJUST_YN
       FROM   SCM_MGR.SCM_MST_SITE_ITEM
       WHERE  DIVISION_ID='40' AND ITEM_ID='MCSS22561-C1'"""
)
r = cur.fetchall()
print(f"   MCSS22561-C1 (No.49) → SITE_ITEM {len(r)}행")
for x in r[:8]:
    print("     " + " | ".join(str(v) for v in x))

print("\n## (3) MKT_FCST_VALIDATION_PRICE 제외/대상 목록 (52주 게이트 조건)")
cur.execute(
    """SELECT SEGMENT1, LISTAGG(SEGMENT2, ',') WITHIN GROUP (ORDER BY SEGMENT2)
       FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
       WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND VALID_YN='Y'
       GROUP BY SEGMENT1"""
)
for x in cur.fetchall():
    print(f"   {x[0]:<10} = {x[1]}")

con.close()
