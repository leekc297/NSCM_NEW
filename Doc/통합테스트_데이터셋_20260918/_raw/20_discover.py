# -*- coding: utf-8 -*-
"""통합테스트 데이터 보완 — 메타 실측 (읽기 전용)"""
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
        names = [d[0] for d in cur.description]
        print("   " + " | ".join(names))
        for r in (rows if limit is None else rows[:limit]):
            print("   " + " | ".join("" if v is None else str(v) for v in r))
        print("   ({}행{})".format(len(rows),
              "" if limit is None or len(rows) <= limit else " — {} 표시".format(limit)))
        return rows
    except Exception as e:
        print("   !! {}".format(str(e).split("\n")[0]))
        return []


hd("A) SCM_MST_SHEET_COLUMNS 스키마")
q("""SELECT COLUMN_NAME, DATA_TYPE, NULLABLE FROM ALL_TAB_COLUMNS
      WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_SHEET_COLUMNS' ORDER BY COLUMN_ID""")

hd("B) INCOTERMS 컬럼을 가진 테이블")
q("""SELECT OWNER, TABLE_NAME FROM ALL_TAB_COLUMNS
      WHERE COLUMN_NAME='INCOTERMS' AND OWNER IN ('SCM_MGR','INF_MGR')
      ORDER BY 1,2""", limit=40)

hd("C) DM_PLN_MKT_FCST INCOTERMS 실사용 (DIV 40)")
q("""SELECT INCOTERMS, COUNT(*) CNT FROM SCM_MGR.DM_PLN_MKT_FCST
      WHERE DIVISION_ID='40' GROUP BY INCOTERMS ORDER BY 2 DESC""")

hd("D) INCOTERMS 룩업 마스터")
q("""SELECT LOOKUP_TYPE, COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
      WHERE UPPER(LOOKUP_TYPE) LIKE '%INCOTERM%' GROUP BY LOOKUP_TYPE""")
q("""SELECT LOOKUP_TYPE,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,VALID_YN
       FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
      WHERE UPPER(LOOKUP_TYPE) LIKE '%INCOTERM%' ORDER BY 1,2,3""", limit=60)

hd("E) PLANT_SITE_ID 보유 테이블 + 40/82 실값")
q("""SELECT TABLE_NAME, NULLABLE FROM ALL_TAB_COLUMNS
      WHERE OWNER='SCM_MGR' AND COLUMN_NAME='PLANT_SITE_ID'
        AND TABLE_NAME IN ('SCM_MST_SITE_ITEM','DM_PLN_MKT_FCST')""")
q("""SELECT DIVISION_ID, PLANT_SITE_ID, COUNT(*) CNT FROM SCM_MGR.DM_PLN_MKT_FCST
      WHERE DIVISION_ID IN ('40','82') GROUP BY DIVISION_ID, PLANT_SITE_ID
      ORDER BY 1, 3 DESC""", limit=30)

hd("F) SCM_MST_SITE_ITEM 스키마 (부속키 확인)")
q("""SELECT COLUMN_NAME, DATA_TYPE, NULLABLE FROM ALL_TAB_COLUMNS
      WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_SITE_ITEM' ORDER BY COLUMN_ID""", limit=60)

hd("G) INF_MGR XIF_* IF 테이블")
q("""SELECT OWNER, TABLE_NAME FROM ALL_TABLES
      WHERE TABLE_NAME IN ('XIF_ERP_EDI_CALLOFF_HEAD_R','XIF_ERP_EDI_CALLOFF_ITEM_R',
                           'XIF_ERP_EDI_CALLOFF_PARTNER_R','XIF_CUST_DEMAND_MAPPING_MST_R')
      ORDER BY 2""")

hd("H) SCM_DNM_STOCK* 테이블")
q("""SELECT OWNER, TABLE_NAME FROM ALL_TABLES WHERE TABLE_NAME LIKE 'SCM_DNM_STOCK%' ORDER BY 2""")

hd("I) VMI 관련 — 메저/컬럼/테이블")
q("""SELECT DISTINCT MEASURE_ID, MEASURE_NAME FROM SCM_MGR.SCM_MST_SHEET_MEASURE
      WHERE UPPER(MEASURE_ID) LIKE '%VMI%' OR UPPER(MEASURE_NAME) LIKE '%VMI%'""", limit=40)
q("""SELECT OWNER, TABLE_NAME, COLUMN_NAME FROM ALL_TAB_COLUMNS
      WHERE COLUMN_NAME LIKE '%VMI%' AND OWNER IN ('SCM_MGR','INF_MGR') ORDER BY 1,2""", limit=40)
