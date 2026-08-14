#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 클라우드 이관 — 기준선(DMF0082_CLOUD_20260812, 사내 2026-08-12) 이후 변경분 전수 서베이."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

CUT = "2026-08-12"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(title, sql, binds=None):
    print("\n" + "=" * 100)
    print(f"## {title}")
    print("-" * 100)
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    if not rows:
        print("   (변경 없음)")
    else:
        print("   " + " | ".join(cols))
        for r in rows:
            print("   " + " | ".join("" if v is None else str(v) for v in r))
    print(f"   ({len(rows)} rows)")
    return rows


q("PKG 객체 DDL 시각", """
  SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') LAST_DDL
  FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' ORDER BY 2""")

q(f"BODY 내 {CUT} 이후 마커", """
  SELECT LINE, TRIM(SUBSTR(TEXT,1,90)) T FROM ALL_SOURCE
  WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
  AND REGEXP_LIKE(TEXT,'E2026081[2-9]|E2026082')
  ORDER BY LINE""")

q(f"LOOKUP 변경 ({CUT} 이후, DMF0082 연관)", """
  SELECT LOOKUP_TYPE, COUNT(*) CNT, TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI') LAST_UPD
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  WHERE LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD')
  AND  (SEGMENT1='DMF0082' OR SEGMENT2='DMF0082'
        OR LOOKUP_TYPE IN ('GET_ADMIN_GROUP_MEASURE','DM_UI_EDITABLE_MEASURE','MKT_FCST_VALIDATION_PRICE'))
  GROUP BY LOOKUP_TYPE ORDER BY 1""", {"c": CUT})

q(f"CMBO 변경 ({CUT} 이후)", """
  SELECT SQL_ID, USE_YN, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD') ORDER BY 4""", {"c": CUT})

q(f"SHEET_COLUMNS 변경 ({CUT} 이후, DMF0082)", """
  SELECT SHEET_NAME, COLUMN_NAME, CELL_COMBO_DATA_TYPE, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
  WHERE PROGRAM_ID='DMF0082' AND LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD') ORDER BY 1,2""", {"c": CUT})

q(f"SHEET_MEASURE 변경 ({CUT} 이후, DMF0082)", """
  SELECT SHEET_NAME, COLUMN_NAME, DIVISION_ID, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
  WHERE PROGRAM_ID='DMF0082' AND LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD') ORDER BY 1,2""", {"c": CUT})

q(f"PROC_M / API_M / BTN 변경 ({CUT} 이후, DMF0082)", """
  SELECT 'PROC_M' SRC, PROC_ID ID, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_ID LIKE '%DMF0082%' AND LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD')
  UNION ALL
  SELECT 'API_M', API_ID, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI')
  FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE '%DMF0082%' AND LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD')
  ORDER BY 1,2""", {"c": CUT})

q(f"MSG/LBL/MNU 변경 ({CUT} 이후)", """
  SELECT MSG_ID, MSG_TP_CD, LANG_CD, SUBSTR(MSG_NM,1,40) NM, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_ADM_MSG_M WHERE LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD') ORDER BY MSG_ID, LANG_CD""", {"c": CUT})

con.close()
