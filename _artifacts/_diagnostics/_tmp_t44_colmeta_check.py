#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ETC 조회를 PLAN_REPORT_C 로 바꿀 때 영향받는 컬럼이 실제로 화면에 표시되는가 (조회 전용)
   → SHEET_COLUMNS 메타 기준. 표시 안 되면 NULL 매핑이 무해하다."""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[0] SHEET_COLUMNS 계열 테이블 탐색")
show(*fetch(cur, """SELECT owner, table_name FROM all_tables
                     WHERE table_name LIKE '%SHEET_COLUMN%' AND owner='SCM_MGR'"""))

TARGET = ('END_CUSTOMER', 'SOLDTO_CODE', 'SOLDTO_COUNTRY', 'SHIPTO_COUNTRY',
          'ITEM_USE', 'PROJECT_NAME', 'COUNTRY_CODE', 'CELL_MODEL_INFO',
          'CELL_MODEL', 'BIZ_TYPE', 'PRODUCT_DETAILS')

sec("[1] DMF0044 MAIN 시트 컬럼 메타 — 대상 컬럼의 표시 여부")
try:
    show(*fetch(cur, """
    SELECT SHT_NM, COL_ID, COL_NM, VISIBLE, DISPLAY_SEQ, INPUT_TP_CD
      FROM SCM_MGR.SCM_ADM_SHEET_COLUMNS
     WHERE MNU_ID='DMF0044'
       AND COL_ID IN ('END_CUSTOMER','SOLDTO_CODE','SOLDTO_COUNTRY','SHIPTO_COUNTRY',
                      'ITEM_USE','PROJECT_NAME','COUNTRY_CODE','CELL_MODEL_INFO',
                      'CELL_MODEL','BIZ_TYPE','PRODUCT_DETAILS')
     ORDER BY SHT_NM, DISPLAY_SEQ"""))
except Exception as e:
    print("  ", str(e)[:250])
    sec("[1-b] 컬럼 구조 확인 후 재시도")
    show(*fetch(cur, """SELECT column_name, data_type FROM all_tab_columns
                         WHERE owner='SCM_MGR' AND table_name LIKE '%SHEET_COLUMN%'
                         ORDER BY table_name, column_id"""))

sec("[2] DMF0044 전체 시트/컬럼 수 (참고)")
try:
    show(*fetch(cur, """SELECT SHT_NM, COUNT(*) cols,
                               SUM(CASE WHEN VISIBLE='Y' THEN 1 ELSE 0 END) visible_y
                          FROM SCM_MGR.SCM_ADM_SHEET_COLUMNS WHERE MNU_ID='DMF0044'
                         GROUP BY SHT_NM ORDER BY SHT_NM"""))
except Exception as e:
    print("  ", str(e)[:200])

con.close()
