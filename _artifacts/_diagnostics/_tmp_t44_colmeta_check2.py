#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ETC 조회 원천 변경 시 영향 컬럼이 화면에 실제 표시되는가 — SCM_MST_SHEET_COLUMNS 기준"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[1] DMF0044 시트 목록")
show(*fetch(cur, """SELECT SHEET_NAME, COUNT(*) cols,
                           SUM(CASE WHEN VISIBLE_FLAG='Y' THEN 1 ELSE 0 END) visible_y
                      FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                     WHERE PROGRAM_ID='DMF0044' AND NVL(VALID_YN,'Y')='Y'
                     GROUP BY SHEET_NAME ORDER BY SHEET_NAME"""))

sec("[2] 원천 변경 시 값이 바뀌거나 사라지는 컬럼 — 화면 표시 여부")
show(*fetch(cur, """
SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, VISIBLE_FLAG, DEFAULT_FLAG,
       USER_SELECTABLE_FLAG, DIVISION_ID, SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0044' AND NVL(VALID_YN,'Y')='Y'
   AND COLUMN_NAME IN ('END_CUSTOMER','SOLDTO_CODE','SOLDTO_COUNTRY','SHIPTO_COUNTRY',
                       'ITEM_USE','PROJECT_NAME','COUNTRY_CODE','CELL_MODEL_INFO',
                       'CELL_MODEL','BIZ_TYPE','BIZ_TYPE_NAME40','PRODUCT_DETAILS')
 ORDER BY SHEET_NAME, SORT_ORDER_NO"""))

sec("[3] 판정 요약")
cur.execute("""
SELECT COLUMN_NAME,
       MAX(CASE WHEN VISIBLE_FLAG='Y' THEN 'Y' ELSE 'N' END) any_visible,
       MAX(CASE WHEN DEFAULT_FLAG='Y' THEN 'Y' ELSE 'N' END) any_default
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0044' AND NVL(VALID_YN,'Y')='Y'
   AND COLUMN_NAME IN ('END_CUSTOMER','SOLDTO_CODE','SOLDTO_COUNTRY','SHIPTO_COUNTRY',
                       'ITEM_USE','PROJECT_NAME','COUNTRY_CODE','CELL_MODEL_INFO',
                       'CELL_MODEL','BIZ_TYPE','BIZ_TYPE_NAME40','PRODUCT_DETAILS')
 GROUP BY COLUMN_NAME ORDER BY COLUMN_NAME""")
rows = cur.fetchall()
for nm, vis, dft in rows:
    risk = "⛔ 화면 표시 — NULL 매핑 불가" if vis == 'Y' else "✅ 미표시 — NULL 매핑 무해"
    print(f"    {nm:<20} visible={vis} default={dft}   {risk}")
names = {r[0] for r in rows}
for miss in ('END_CUSTOMER','SOLDTO_CODE','SOLDTO_COUNTRY','SHIPTO_COUNTRY','ITEM_USE','PROJECT_NAME'):
    if miss not in names:
        print(f"    {miss:<20} (메타 없음)                  ✅ 화면 컬럼 아님 — NULL 매핑 무해")

con.close()
