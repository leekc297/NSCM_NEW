#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0021 재검증 2부 — No.62(컬럼 division 스코프) / No.61-③(Model 룩업) 정밀 확인."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(t, sql, b=None):
    print("\n" + "=" * 100); print(f"## {t}"); print("-" * 100)
    cur.execute(sql, b or {})
    cols = [c[0] for c in cur.description]; rows = cur.fetchall()
    print("   " + " | ".join(cols)) if rows else print("   ⛔ 0행")
    for r in rows:
        print("   " + " | ".join("" if v is None else str(v)[:78] for v in r))
    print(f"   ({len(rows)} rows)")
    return rows


q("[62] DMF0021 전 컬럼 중 Customer/Company/Cell 계열", """
  SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID, VISIBLE_FLAG, VALID_YN
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0021'
  AND (COLUMN_NAME LIKE '%CUSTOMER%' OR COLUMN_NAME LIKE '%COMPANY%' OR COLUMN_NAME LIKE '%CELL%')
  ORDER BY COLUMN_NAME""")

# division 별 노출 컬럼 수 (CSV 토큰 매칭)
for div in ("40", "81", "82"):
    q(f"[62] division={div} 노출 컬럼 수 (VISIBLE=Y·VALID=Y·스코프 매칭)", f"""
      SELECT COUNT(*) CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
      WHERE PROGRAM_ID='DMF0021' AND VALID_YN='Y' AND VISIBLE_FLAG='Y'
      AND (DIVISION_ID IS NULL OR TRIM(DIVISION_ID) IS NULL
           OR ',' || REPLACE(DIVISION_ID,' ','') || ',' LIKE '%,{div},%')""")

q("[62] 40 스코프에서 빠진 컬럼 (81 에는 있는데 40 에 없는 것)", """
  SELECT COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID, VISIBLE_FLAG
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0021' AND VALID_YN='Y'
  AND ',' || REPLACE(DIVISION_ID,' ','') || ',' LIKE '%,81,%'
  AND ',' || REPLACE(DIVISION_ID,' ','') || ',' NOT LIKE '%,40,%'
  ORDER BY COLUMN_NAME""")

q("[61-③] SALES_PLAN_ITEM_ID 룩업 원문 (전 세그먼트)", """
  SELECT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, VALID_YN
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='SALES_PLAN_ITEM_ID'
  ORDER BY SEGMENT1, SEGMENT2""")

cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='SalesPlanItemId'")
row = cur.fetchone()
txt = row[0].read() if hasattr(row[0], "read") else row[0]
print("\n" + "=" * 100); print("## [61-③] CMBO SalesPlanItemId 등재 SQL 원문"); print("-" * 100)
print(txt)

con.close()
