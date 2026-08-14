#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel 기능 인벤토리 + DMF0082 정본 대조 (Excel Form/Upload 표준화 준비)."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(t, sql, b=None):
    print("\n" + "=" * 104); print(f"## {t}"); print("-" * 104)
    cur.execute(sql, b or {})
    cols = [c[0] for c in cur.description]; rows = cur.fetchall()
    print("   " + " | ".join(cols)) if rows else print("   ⛔ 0행")
    for r in rows:
        print("   " + " | ".join("" if v is None else str(v)[:60] for v in r))
    print(f"   ({len(rows)} rows)")
    return rows


q("SCM_ADM_EXCEL_UPLOAD — DMF0014 vs DMF0082", """
  SELECT UPLOAD_ID, PROGRAM_ID, SHEET_NAME, HEADER_CONTENT, SORT_ORDER_NO, VALID_YN
  FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
  WHERE PROGRAM_ID IN ('DMF0014','DMF0082') ORDER BY PROGRAM_ID, SORT_ORDER_NO""")

q("SCM_ADM_EXCEL_COLUMNS — DMF0014 vs DMF0082", """
  SELECT UPLOAD_ID, PROGRAM_ID, SHEET_NAME, VALID_PROC, STORAGE_SQL_ID, VALID_YN
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
  WHERE PROGRAM_ID IN ('DMF0014','DMF0082') ORDER BY PROGRAM_ID""")

q("버튼 배선 — DMF0014 vs DMF0082 (Excel 계열)", """
  SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  WHERE MNU_ID IN ('DMF0014','DMF0082')
  AND (MNU_BTN_CD LIKE '%UPLOAD%' OR MNU_BTN_CD LIKE '%FORM%' OR MNU_BTN_CD LIKE '%EXCEL%')
  ORDER BY MNU_ID, MNU_BTN_CD""")

q("PKG_DMF0014 Excel 관련 프로시저", """
  SELECT DISTINCT OBJECT_NAME FROM ALL_ARGUMENTS
  WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0014' ORDER BY 1""")

q("DMF0082 Excel Form SP 시그니처 (정본)", """
  SELECT POSITION, ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS
  WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0082'
  AND OBJECT_NAME='P_DMF0082_GET_EXCEL_FORM_DATA' ORDER BY POSITION""")

q("DMF0082 EXCEL_UPLOAD SP 시그니처 (정본 5-arg)", """
  SELECT POSITION, ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS
  WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0082'
  AND OBJECT_NAME='P_DMF0082_EXCEL_UPLOAD' ORDER BY POSITION""")

q("DMF0014 업로드 검증 SP 시그니처", """
  SELECT OBJECT_NAME, POSITION, ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS
  WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0014'
  AND OBJECT_NAME LIKE '%EXCEL%' ORDER BY OBJECT_NAME, POSITION""")

q("API_M — DMF0014 vs DMF0082 Excel 계열", """
  SELECT API_ID, API_URL, USE_YN FROM SCM_MGR.SCM_ADM_API_M
  WHERE (API_ID LIKE '%DMF0014%' OR API_ID LIKE '%DMF0082%')
  AND (API_ID LIKE '%UPLOAD%' OR API_ID LIKE '%FORM%' OR API_ID LIKE '%EXCEL%') ORDER BY API_ID""")

con.close()
