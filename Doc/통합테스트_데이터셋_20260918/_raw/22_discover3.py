# -*- coding: utf-8 -*-
"""통합테스트 데이터 보완 — 메타 실측 3차 (읽기 전용)
 Q) SCM_DNM_STOCK_SN 전 소유자 탐색 (테이블/뷰/시노님)
 R) Incoterms 콤보 원천 — division 40 선택가능 값
 S) CELL_PROD_SITE_ID 콤보 원천 — division 40 선택가능 값
 T) DMF0082 VMI 메저 + VMI 가능 SITE
 U) CRUD 화면별 USER_SELECTABLE_FLAG='N' 컬럼 전체
"""
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()


def q(t, sql, args=None, limit=None):
    print("\n" + "=" * 84)
    print("## " + t)
    print("=" * 84)
    try:
        cur.execute(sql, args or [])
        rows = cur.fetchall()
        print("   " + " | ".join(d[0] for d in cur.description))
        for r in (rows if limit is None else rows[:limit]):
            print("   " + " | ".join("" if v is None else str(v) for v in r))
        print("   ({}행{})".format(len(rows),
              "" if limit is None or len(rows) <= limit else " — {} 표시".format(limit)))
        return rows
    except Exception as e:
        print("   !! {}".format(str(e).split("\n")[0]))
        return []


q("Q) SCM_DNM_STOCK_SN 전 소유자 탐색",
  """SELECT OWNER, OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS
      WHERE OBJECT_NAME LIKE '%STOCK_SN%' OR OBJECT_NAME LIKE '%STOCK%SN%'
      ORDER BY 1,2""", limit=40)

q("R) Incoterms 콤보 — 콤보 레지스트리 정의",
  """SELECT COMBO_ID, COMBO_NAME, SQL_ID, VALID_YN FROM SCM_MGR.SCM_ADM_COMBO_MASTER
      WHERE UPPER(COMBO_ID) LIKE '%INCOTERM%' ORDER BY 1""", limit=20)

q("R2) DM_LOOKUP_DIV / Incoterms 룩업 — 40 유효값",
  """SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, VALID_YN
       FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
      WHERE LOOKUP_TYPE='INCOTERMS' ORDER BY SEGMENT1""", limit=30)

q("S) CELL_PROD_SITE 콤보 레지스트리",
  """SELECT COMBO_ID, COMBO_NAME, SQL_ID, VALID_YN FROM SCM_MGR.SCM_ADM_COMBO_MASTER
      WHERE UPPER(COMBO_ID) LIKE '%CELL%' OR UPPER(COMBO_ID) LIKE '%PROD_SITE%'
      ORDER BY 1""", limit=20)

q("S2) DM_PLN_SALES_PLAN 40 CELL_PROD_SITE_ID 실값 분포",
  """SELECT CELL_PROD_SITE_ID, COUNT(*) CNT FROM SCM_MGR.DM_PLN_SALES_PLAN
      WHERE DIVISION_ID='40' GROUP BY CELL_PROD_SITE_ID ORDER BY 2 DESC""", limit=30)

q("T) DMF0082 VMI 메저",
  """SELECT PROGRAM_ID, SHEET_NAME, DIVISION_ID, COLUMN_NAME, COLUMN_LABEL_NAME,
            USER_SELECTABLE_FLAG, DEFAULT_FLAG, VALID_YN
       FROM SCM_MGR.SCM_MST_SHEET_MEASURE
      WHERE PROGRAM_ID='DMF0082' AND (UPPER(COLUMN_NAME) LIKE '%VMI%'
                                      OR UPPER(COLUMN_LABEL_NAME) LIKE '%VMI%')
      ORDER BY DIVISION_ID, COLUMN_NAME""", limit=40)

q("T2) SCM_MST_SITE VMI_YN 분포",
  """SELECT DIVISION_ID, VMI_YN, COUNT(*) CNT FROM SCM_MGR.SCM_MST_SITE
      GROUP BY DIVISION_ID, VMI_YN ORDER BY 1,2""", limit=40)

q("U) CRUD 화면별 USER_SELECTABLE_FLAG='N' 컬럼 건수",
  """SELECT PROGRAM_ID, SHEET_NAME, DIVISION_ID,
            SUM(CASE WHEN USER_SELECTABLE_FLAG='N' THEN 1 ELSE 0 END) N_CNT, COUNT(*) TOT
       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
      WHERE VALID_YN='Y'
        AND PROGRAM_ID IN ('DMF0005','DMF0082','DMF0021','DMF0020','DMF0003',
                           'DMF0007','DMF0014','DMF0006','DMF0072')
      GROUP BY PROGRAM_ID, SHEET_NAME, DIVISION_ID ORDER BY 1,3,2""", limit=80)
