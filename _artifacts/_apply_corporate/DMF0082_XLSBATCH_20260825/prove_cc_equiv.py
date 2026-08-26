# -*- coding: utf-8 -*-
"""CC 재작성 등가성 증명 — 구(집계+재조인) vs 신(KEEP LAST 단일 스캔) 결과 집합 완전 대조"""
import io, sys, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 280000
cur = con.cursor()
DIV, FRM = "81", "20260824"

KEY = "DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS"

old_sql = """SELECT /*+ NO_MERGE */ A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,
       A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE, A.YYYYMMDD
FROM SCM_MGR.SCM_MST_FUTURE_PRICE A
JOIN (SELECT {key}, MAX(YYYYMMDD) AS YMD
        FROM SCM_MGR.SCM_MST_FUTURE_PRICE
       WHERE DIVISION_ID = :div AND MEASURE = 'LOC' AND YYYYMMDD < :frm
       GROUP BY {key}) B
  ON  A.DIVISION_ID=B.DIVISION_ID AND A.PROJECT_CODE=B.PROJECT_CODE AND A.SCM_SITE_ID=B.SCM_SITE_ID
  AND A.PLANT_SITE_ID=B.PLANT_SITE_ID AND A.ITEM_ID=B.ITEM_ID AND A.CURRENCY=B.CURRENCY
  AND A.MEASURE=B.MEASURE AND A.DOM_EXP=B.DOM_EXP AND A.FCST_TYPE=B.FCST_TYPE AND A.INCOTERMS=B.INCOTERMS
  AND A.YYYYMMDD=B.YMD""".format(key=KEY)

new_sql = """SELECT {key},
       MAX(PRICE) KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS PRICE,
       MAX(YYYYMMDD) AS YYYYMMDD
FROM SCM_MGR.SCM_MST_FUTURE_PRICE
WHERE DIVISION_ID = :div AND MEASURE = 'LOC' AND YYYYMMDD < :frm
GROUP BY {key}""".format(key=KEY)

wrap = """SELECT COUNT(*), NVL(SUM(ORA_HASH(DIVISION_ID||'|'||PROJECT_CODE||'|'||SCM_SITE_ID||'|'||PLANT_SITE_ID||'|'||ITEM_ID
    ||'|'||CURRENCY||'|'||MEASURE||'|'||DOM_EXP||'|'||FCST_TYPE||'|'||INCOTERMS||'|'||YYYYMMDD||'|'||TO_CHAR(PRICE))),0)
FROM ({q})"""

for name, q in [("구(집계+재조인)", old_sql), ("신(KEEP LAST)", new_sql)]:
    t0 = time.time()
    cur.execute(wrap.format(q=q), div=DIV, frm=FRM)
    n, h = cur.fetchone()
    print("%-14s: %d행 / 해시 %d / %.1fs" % (name, n, h, time.time() - t0), flush=True)
con.close()
