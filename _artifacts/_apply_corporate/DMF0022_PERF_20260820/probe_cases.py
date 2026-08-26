# -*- coding: utf-8 -*-
"""값 동등성 검증 케이스 선정을 위한 실데이터 실측 (추정 금지)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(t, sql):
    print(f"\n=== {t}")
    cur.execute(sql)
    cols = [c[0] for c in cur.description]
    print(" | ".join(cols))
    for r in cur.fetchall():
        print(" | ".join(str(x) for x in r))


q("DM_PLN_SALES_PLAN division x 최근 (20260801~20270228)", """
  SELECT DIVISION_ID, COUNT(*) CNT, COUNT(DISTINCT ITEM_ID) ITEMS
    FROM SCM_MGR.DM_PLN_SALES_PLAN
   WHERE YYYYMMDD BETWEEN '20260801' AND '20270228' AND QTY <> 0
   GROUP BY DIVISION_ID ORDER BY 1""")

q("DM_PLN_SALES_PLAN_C 버전 (division x version, 상위)", """
  SELECT * FROM (
    SELECT DIVISION_ID, VERSION_NO, COUNT(*) CNT
      FROM SCM_MGR.DM_PLN_SALES_PLAN_C
     WHERE YYYYMMDD BETWEEN '20260801' AND '20270228' AND QTY <> 0
     GROUP BY DIVISION_ID, VERSION_NO ORDER BY DIVISION_ID, VERSION_NO DESC)
   WHERE ROWNUM <= 40""")

q("SCM_ITEM_M(SCM_MST_ITEM_SN) division 별 행수", """
  SELECT DIVISION_ID, COUNT(*) CNT FROM SCM_MGR.SCM_MST_ITEM_SN GROUP BY DIVISION_ID ORDER BY 2 DESC""")

q("SCM_MST_SITE_ITEM division 별 행수", """
  SELECT DIVISION_ID, COUNT(*) CNT FROM SCM_MGR.SCM_MST_SITE_ITEM GROUP BY DIVISION_ID ORDER BY 2 DESC""")

q("DM_PLN_CFM_SELLING_PRICE division x YYYYMMDD 범위", """
  SELECT DIVISION_ID, COUNT(*) CNT, MIN(YYYYMMDD) MN, MAX(YYYYMMDD) MX
    FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE GROUP BY DIVISION_ID ORDER BY 2 DESC""")

q("인덱스 — 주요 표", """
  SELECT i.TABLE_NAME, i.INDEX_NAME, i.UNIQUENESS,
         LISTAGG(c.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY c.COLUMN_POSITION) COLS
    FROM ALL_INDEXES i JOIN ALL_IND_COLUMNS c
      ON c.INDEX_OWNER=i.OWNER AND c.INDEX_NAME=i.INDEX_NAME
   WHERE i.TABLE_OWNER='SCM_MGR'
     AND i.TABLE_NAME IN ('SCM_ITEM_M','DM_PLN_CFM_SELLING_PRICE','DM_PLN_SALES_PLAN',
                          'SCM_MST_SITE_ITEM','SCM_MST_SITE','SCM_MST_FUTURE_PRICE',
                          'DM_PLN_SALES_PLAN_C','DM_PLN_SALES_PLAN_RESULT')
   GROUP BY i.TABLE_NAME, i.INDEX_NAME, i.UNIQUENESS ORDER BY 1,2""")

q("SCM_MST_ITEM_SN 객체 타입", """
  SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS
   WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('SCM_MST_ITEM_SN','SCM_ITEM_M')""")
con.close()
