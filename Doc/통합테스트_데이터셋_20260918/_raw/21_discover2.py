# -*- coding: utf-8 -*-
"""통합테스트 데이터 보완 — 메타 실측 2차 (읽기 전용)"""
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


def hd(t):
    print("\n" + "=" * 84)
    print("## " + t)
    print("=" * 84)


def q(sql, args=None, limit=None):
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


hd("J) 'SN' 유사 재고 테이블 전수 (SCM_DNM_STOCK_SN 미존재 확인용)")
q("""SELECT OWNER, TABLE_NAME FROM ALL_TABLES
      WHERE (TABLE_NAME LIKE '%STOCK%' OR TABLE_NAME LIKE '%_SN%')
        AND OWNER IN ('SCM_MGR','INF_MGR') ORDER BY 1,2""", limit=60)

hd("K) SCM_DNM_STOCK 계열 division 분포")
for t in ("SCM_DNM_STOCK", "SCM_DNM_STOCK_VMI", "SCM_DNM_STOCK_SALES"):
    print("\n   -- {} --".format(t))
    q("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
          AND TABLE_NAME=:1 AND COLUMN_NAME LIKE '%DIVISION%'""", [t])
    q("""SELECT DIVISION_ID, COUNT(*) CNT FROM SCM_MGR.{} GROUP BY DIVISION_ID
          ORDER BY 2 DESC""".format(t), limit=10)

hd("L) SCM_MST_SITE 스키마 + VMI_YN 분포")
q("""SELECT COLUMN_NAME, DATA_TYPE, NULLABLE FROM ALL_TAB_COLUMNS
      WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_SITE' ORDER BY COLUMN_ID""", limit=40)
q("""SELECT DIVISION_ID, VMI_YN, COUNT(*) CNT FROM SCM_MGR.SCM_MST_SITE
      GROUP BY DIVISION_ID, VMI_YN ORDER BY 1,2""", limit=40)

hd("M) SCM_MST_SHEET_MEASURE 스키마")
q("""SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS
      WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_SHEET_MEASURE' ORDER BY COLUMN_ID""", limit=40)

hd("N) DMF0082 VMI 메저")
q("""SELECT PROGRAM_ID, SHEET_NAME, DIVISION_ID, MEASURE_ID, MEASURE_LABEL_NAME,
            USER_SELECTABLE_FLAG, DEFAULT_FLAG, VALID_YN, INPUT_TP_CD
       FROM SCM_MGR.SCM_MST_SHEET_MEASURE
      WHERE PROGRAM_ID='DMF0082' AND UPPER(MEASURE_ID) LIKE '%VMI%'
      ORDER BY DIVISION_ID, MEASURE_ID""", limit=40)

hd("O) CRUD 화면별 USER_SELECTABLE_FLAG='N' 컬럼 (division 별 건수)")
q("""SELECT PROGRAM_ID, SHEET_NAME, DIVISION_ID,
            SUM(CASE WHEN USER_SELECTABLE_FLAG='N' THEN 1 ELSE 0 END) N_CNT,
            COUNT(*) TOT
       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
      WHERE VALID_YN='Y'
        AND PROGRAM_ID IN ('DMF0005','DMF0082','DMF0021','DMF0020','DMF0003',
                           'DMF0007','DMF0014','DMF0006')
      GROUP BY PROGRAM_ID, SHEET_NAME, DIVISION_ID
      ORDER BY 1,3,2""", limit=80)

hd("P) DMF0005 Incoterms 콤보 원천 (SHEET_COLUMNS 메타)")
q("""SELECT PROGRAM_ID, SHEET_NAME, DIVISION_ID, COLUMN_NAME, COLUMN_LABEL_NAME,
            CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, USER_SELECTABLE_FLAG, INPUT_TP_CD
       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
      WHERE VALID_YN='Y' AND UPPER(COLUMN_NAME) LIKE '%INCOTERM%'
      ORDER BY 1,3,2""", limit=40)
