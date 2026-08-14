#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0021 단위테스트 보완 5건(하위 12항목) — DB 축 독립 재검증 (문서 판정 불신 원칙)."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(title, sql, binds=None, expect=None):
    print("\n" + "=" * 100)
    print(f"## {title}")
    if expect:
        print(f"   기대: {expect}")
    print("-" * 100)
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    if not rows:
        print("   ⛔ 0행")
    else:
        print("   " + " | ".join(cols))
        for r in rows:
            print("   " + " | ".join("" if v is None else str(v)[:70] for v in r))
    print(f"   ({len(rows)} rows)")
    return rows


q("[58] PKG_DMF0021 상태", """
  SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') LAST_DDL
  FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0021' ORDER BY 1""",
  expect="SPEC/BODY VALID")

q("[58] BODY 내 RTFGATE / PERFHINT 마커", """
  SELECT LINE, TRIM(SUBSTR(TEXT,1,80)) T FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021' AND TYPE='PACKAGE BODY'
  AND (INSTR(TEXT,'RTFGATE')>0 OR INSTR(TEXT,'PERFHINT')>0 OR INSTR(TEXT,'MSG00704')>0)
  ORDER BY LINE""", expect="RTFGATE(GET+SAVE) · MSG00704 · PERFHINT 존재")

q("[58] GET_ADMIN_GROUP_MEASURE / DMF0021 RTF_SYS_RP 룩업 (요일·시각)", """
  SELECT SEGMENT1 GRP, SEGMENT3 DIV, SEGMENT4 MEASURE,
         ATTRIBUTE1 DAYS, ATTRIBUTE2 FR, ATTRIBUTE3 TO_, VALID_YN
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2='DMF0021'
  ORDER BY SEGMENT3, SEGMENT4, SEGMENT1""", expect="40=MON / 81=SAT 계열 요일·시각 보유")

q("[58] MSG00704 3언어", """
  SELECT MSG_ID, LANG_CD, SUBSTR(MSG_NM,1,60) NM, USE_YN FROM SCM_MGR.SCM_ADM_MSG_M
  WHERE MSG_ID='MSG00704' ORDER BY LANG_CD""", expect="KO/EN/CN 3행")

q("[61-③] CMBO SalesPlanItemId 등재", """
  SELECT SQL_ID, SQL_NM, USE_YN, LENGTH(SQL_DTL_CTN) LEN,
         TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='SalesPlanItemId'""", expect="1행 USE_YN=Y")

q("[61-③] SALES_PLAN_ITEM_ID 룩업 division 분포", """
  SELECT SEGMENT1 DIV, COUNT(*) CNT FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE LOOKUP_TYPE='SALES_PLAN_ITEM_ID' AND VALID_YN='Y' GROUP BY SEGMENT1 ORDER BY 1""",
  expect="40=11 / 81_UC=5 / 82=4 (대조문서 주장)")

q("[62] SHEET_COLUMNS division 스코프 — 40 전용 3컬럼", """
  SELECT COLUMN_NAME, DIVISION_ID, VISIBLE_FLAG, VALID_YN
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
  WHERE PROGRAM_ID='DMF0021'
  AND COLUMN_NAME IN ('END_CUSTOMER','COMPANY_ID','CELL_PROD_SITE_ID','CELL_PROD_SITE')
  ORDER BY COLUMN_NAME""", expect="40 포함 / 81 미포함")

con.close()
