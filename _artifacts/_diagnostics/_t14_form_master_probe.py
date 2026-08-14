#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form 재설계 — DMF0007 기준데이터 축 규명.

요구(사용자 2026-08-14): "Excel Form 으로 조회해야 할 데이터는 **EXCEL UPLOAD 를 위한 실제 데이터**.
  MAIN GRID 데이터와 항상 일치하지 않는다. DMF0007 에서 관리하는 기준데이터와 DMF0014 조회 시
  사용할 데이터를 연결해서 **업로드해야 할 양식**을 조회 QUERY 로 생성."
⇒ 현행 SP 는 DM_PLN_CUSTOMER_PSI(=이미 업로드된 원장)를 읽어 설계가 틀렸다. 기준(마스터) 축을 찾는다.
"""
import io, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(t, sql):
    print("\n" + "=" * 100); print(f"## {t}"); print("-" * 100)
    cur.execute(sql)
    cols = [c[0] for c in cur.description]; rows = cur.fetchall()
    print("   " + " | ".join(cols)) if rows else print("   0행")
    for r in rows:
        print("   " + " | ".join("" if v is None else str(v)[:46] for v in r))
    print(f"   ({len(rows)} rows)")


q("① DMF0007 메뉴/화면 식별", """
  SELECT MNU_ID, MNU_URL, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0007'""")

q("② DMF0007 PKG 프로시저", """
  SELECT DISTINCT OBJECT_NAME FROM ALL_ARGUMENTS
  WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0007' ORDER BY 1""")

q("③ DMF0007 API_M (원장 추적)", """
  SELECT API_ID, API_URL FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE '%DMF0007%' ORDER BY 1""")

q("④ DMF0007 SHEET_COLUMNS (기준데이터 컬럼)", """
  SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, VISIBLE_FLAG, SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0007' AND VALID_YN='Y'
  ORDER BY SHEET_NAME, SORT_ORDER_NO""")

q("⑤ DM_MST_CUSTOMER_FCST 컬럼 구조 (기준 마스터 후보)", """
  SELECT COLUMN_NAME, DATA_TYPE, NULLABLE FROM ALL_TAB_COLUMNS
  WHERE OWNER='SCM_MGR' AND TABLE_NAME='DM_MST_CUSTOMER_FCST' ORDER BY COLUMN_ID""")

q("⑥ DM_MST_CUSTOMER_FCST 샘플 (div 40 WEEKLY)", """
  SELECT * FROM SCM_MGR.DM_MST_CUSTOMER_FCST
  WHERE DIVISION_ID='40' AND UPLOAD_BUCKET_TYPE='WEEKLY' AND VALID_YN='Y'
  FETCH FIRST 3 ROWS ONLY""")

con.close()
