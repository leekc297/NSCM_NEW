# -*- coding: utf-8 -*-
"""처방 등가성 전제(불변식) 실측 검증 — 추정 금지."""
import io
import re
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
    for r in cur.fetchall():
        print("   ", " | ".join(str(x) for x in r))


q("I1. DM_PLN_SALES_PLAN_C 에 VERSION_NO='CURRENT' 존재?", """
  SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_C WHERE VERSION_NO = 'CURRENT'""")

q("I2. DM_PLN_CFM_SELLING_PRICE / SCM_MST_FUTURE_PRICE 전체 행수/블록", """
  SELECT TABLE_NAME, NUM_ROWS, BLOCKS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD') LA
    FROM ALL_TABLES WHERE OWNER='SCM_MGR'
     AND TABLE_NAME IN ('DM_PLN_CFM_SELLING_PRICE','SCM_MST_FUTURE_PRICE','DM_PLN_SALES_PLAN_C',
                        'SCM_ITEM_M','SCM_MST_SITE_ITEM','SCM_MST_SITE','DM_PLN_CFM_SELLING_PRICE_C')
   ORDER BY 1""")

q("I3. SCM_MST_ITEM_SN 시노님 실체", """
  SELECT SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM ALL_SYNONYMS
   WHERE OWNER IN ('SCM_MGR','PUBLIC') AND SYNONYM_NAME IN ('SCM_MST_ITEM_SN','SCM_ITEM_M')""")

q("I4. SCM_ITEM_M 인덱스", """
  SELECT i.INDEX_NAME, i.UNIQUENESS,
         LISTAGG(c.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY c.COLUMN_POSITION)
    FROM ALL_INDEXES i JOIN ALL_IND_COLUMNS c
      ON c.INDEX_OWNER=i.OWNER AND c.INDEX_NAME=i.INDEX_NAME
   WHERE i.TABLE_OWNER='SCM_MGR' AND i.TABLE_NAME='SCM_ITEM_M'
   GROUP BY i.INDEX_NAME, i.UNIQUENESS""")

q("I5. SCM_SYS_CALENDAR_M — 20260817 의 BASIS_START_DATE / 범위 MIN", """
  SELECT (SELECT MIN(BASIS_START_DATE) FROM SCM_MGR.SCM_SYS_CALENDAR_M
           WHERE BASIS_YYYYMMDD >= '20260817' AND BASIS_YYYYMMDD <= '20270228') MIN_BSD,
         (SELECT MAX(BASIS_START_DATE) FROM SCM_MGR.SCM_SYS_CALENDAR_M
           WHERE BASIS_YYYYMMDD >= '20260817' AND BASIS_YYYYMMDD <= '20270228') MAX_BSD,
         (SELECT MIN(BASIS_START_DATE) FROM SCM_MGR.SCM_SYS_CALENDAR_M
           WHERE BASIS_YYYYMMDD >= '20260801' AND BASIS_YYYYMMDD <= '20270228') MIN_BSD_FROM
    FROM DUAL""")

q("I6. CFM_SELLING_PRICE div40 x YYYYMMDD 하한 적용 시 잔존율", """
  SELECT COUNT(*) TOTAL,
         SUM(CASE WHEN DIVISION_ID='40' THEN 1 ELSE 0 END) DIV40,
         SUM(CASE WHEN DIVISION_ID='40' AND YYYYMMDD BETWEEN '20260801' AND '20270228' THEN 1 ELSE 0 END) DIV40_RANGE
    FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE""")

q("I7. FUTURE_PRICE div81 x 범위 잔존율", """
  SELECT COUNT(*) TOTAL,
         SUM(CASE WHEN DIVISION_ID='81' THEN 1 ELSE 0 END) DIV81,
         SUM(CASE WHEN DIVISION_ID='81' AND YYYYMMDD BETWEEN '20260801' AND '20270228' THEN 1 ELSE 0 END) DIV81_RANGE
    FROM SCM_MGR.SCM_MST_FUTURE_PRICE""")

q("I8. SCM_ITEM_M div40 — 12자리 prefix 분포 (선행축소 효과 상한 추정)", """
  SELECT COUNT(*) ROWS_DIV40, COUNT(DISTINCT SUBSTR(ITEM_ID,1,12)) PREFIXES
    FROM SCM_MGR.SCM_MST_ITEM_SN WHERE DIVISION_ID='40'""")

# 라이브 코드 정적 검사: GT_DM22_RAW_DATA INSERT 의 division 제약
print("\n=== I9. GT_DM22_RAW_DATA 적재문 division 불변식 (LIVE 코드 정적)")
live = open(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_PERF_20260820\_live_nocomment.sql",
            encoding="utf-8").read().splitlines()
for i, l in enumerate(live):
    if re.search(r"INSERT[^;]*INTO\s+(SCM_MGR\.)?GT_DM22_RAW_DATA\b", l, re.I):
        seg = "\n".join(live[i:i + 90])
        seg = seg.split(";")[0]
        has = bool(re.search(r"DIVISION_ID\s*=\s*P_DIVISION_ID", seg, re.I))
        src = re.findall(r"FROM\s+(?:SCM_MGR\.)?([A-Z0-9_]+)", seg, re.I)
        print(f"   L{i+1:5d} div제약={'Y' if has else 'N'}  FROM={src[:4]}")
con.close()
