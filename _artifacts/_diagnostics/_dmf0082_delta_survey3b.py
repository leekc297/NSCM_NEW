#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""survey3 후반부 재실행 — PROC_M/API_M(컬럼 정정) + BTN + MSG + GTT + DEFAULT_ON_NULL."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

CUT = "2026-08-18"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(title, sql, binds=None):
    print("\n" + "=" * 100)
    print(f"## {title}")
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


q(f"PROC_M 변경 ({CUT}~, DMF0082)", """
  SELECT PROC_NM, COL_NM, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE '%DMF0082%' AND LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD')
  ORDER BY 1,2""", {"c": CUT})

q(f"API_M 변경 ({CUT}~, DMF0082)", """
  SELECT API_ID, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE '%DMF0082%' AND LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD')
  ORDER BY 1""", {"c": CUT})

q(f"BTN 배선/권한 변경 ({CUT}~, DMF0082)", """
  SELECT 'BTN_MPG' SRC, MNU_ID||'/'||SHT_NM||'/'||MNU_BTN_CD ID, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0082' AND LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD')
  UNION ALL
  SELECT 'GR_BTN', USER_GR_ID||'/'||MNU_BTN_CD, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI')
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0082' AND LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD')
  ORDER BY 1,2""", {"c": CUT})

q(f"MSG 변경 ({CUT}~)", """
  SELECT MSG_ID, LANG_CD, SUBSTR(MSG_NM,1,40) NM, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_MGR.SCM_ADM_MSG_M WHERE LAST_UPDATE_DATE >= TO_DATE(:c,'YYYY-MM-DD') ORDER BY MSG_ID, LANG_CD""", {"c": CUT})

q("BODY 참조 GT_/GTT_ 전수 + 존재 여부", """
  WITH REF AS (
    SELECT DISTINCT UPPER(REGEXP_SUBSTR(TEXT, '(GTT?_[A-Z0-9_]+)', 1, 1, 'i', 1)) GNAME
    FROM ALL_SOURCE
    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
      AND REGEXP_LIKE(TEXT, 'GTT?_[A-Z0-9_]+', 'i'))
  SELECT R.GNAME, CASE WHEN T.TABLE_NAME IS NULL THEN 'MISSING' ELSE 'EXISTS/'||T.TEMPORARY END STATUS
  FROM REF R LEFT JOIN ALL_TABLES T ON T.OWNER='SCM_MGR' AND T.TABLE_NAME=R.GNAME
  WHERE R.GNAME IS NOT NULL ORDER BY 2, 1""")

q("DEFAULT_ON_NULL 적용 현황 (이관 DDL 대상 5테이블)", """
  SELECT TABLE_NAME, COUNT(*) CNT FROM ALL_TAB_COLUMNS
  WHERE OWNER='SCM_MGR' AND DEFAULT_ON_NULL='YES'
  AND TABLE_NAME IN ('DM_PLN_CFM_MKT_DEMAND_PLAN','DM_PLN_CFM_MKT_DEMAND_PLAN_H',
                     'DM_PLN_CFM_SELLING_PRICE','SCM_MST_FUTURE_PRICE','GT_PRDM1_T_MAIN')
  GROUP BY TABLE_NAME ORDER BY 1""")

con.close()
