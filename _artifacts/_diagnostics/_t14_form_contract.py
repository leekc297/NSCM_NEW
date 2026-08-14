#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form 구현 계약 확정 — 메인 GET 시그니처 / 컬럼 메타 / 업로드 토큰 ↔ 컬럼 매핑."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(t, sql):
    print("\n" + "=" * 96); print(f"## {t}"); print("-" * 96)
    cur.execute(sql)
    cols = [c[0] for c in cur.description]; rows = cur.fetchall()
    print("   " + " | ".join(cols)) if rows else print("   0행")
    for r in rows:
        print("   " + " | ".join("" if v is None else str(v)[:56] for v in r))
    print(f"   ({len(rows)} rows)")


q("① DMF0014 메인 GET 시그니처 (Excel Form IN 축의 원천)", """
  SELECT POSITION, ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS
  WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0014'
  AND OBJECT_NAME='P_DMF0014_GET_CUST_FCST_UPLOAD_DATA' ORDER BY POSITION""")

q("② DMF0014 SHEET_COLUMNS (양식 컬럼 원천)", """
  SELECT COLUMN_NAME, COLUMN_LABEL_NAME, DIVISION_ID, VISIBLE_FLAG, SORT_ORDER_NO, INPUT_TP_CD
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0014' AND VALID_YN='Y'
  ORDER BY SHEET_NAME, SORT_ORDER_NO""")

q("③ DMF0014 SHEET 목록", """
  SELECT SHEET_NAME, COUNT(*) CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
  WHERE PROGRAM_ID='DMF0014' GROUP BY SHEET_NAME""")

q("④ DMF0014 API_M / PROC_M 현황", """
  SELECT 'API' SRC, API_ID ID, API_URL URL FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE '%DMF0014%'
  UNION ALL
  SELECT 'PROC', PROC_NM, COUNT(*)||' cols' FROM SCM_MGR.SCM_ADM_PROC_M
  WHERE PROC_NM LIKE '%DMF0014%' GROUP BY PROC_NM ORDER BY 1,2""")

q("⑤ 업로드 검증 SP 가 읽는 원장 (P_DMF0014_CUST_FCST_EXCEL_UPLOAD 내 대상 테이블)", """
  SELECT LINE, TRIM(TEXT) T FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY'
  AND (INSTR(UPPER(TEXT),'DM_PLN')>0 OR INSTR(UPPER(TEXT),'MERGE INTO')>0)
  ORDER BY LINE FETCH FIRST 18 ROWS ONLY""")

con.close()
