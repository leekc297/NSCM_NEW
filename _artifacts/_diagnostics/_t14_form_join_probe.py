#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form 재설계 — DMF0007 기준 × DMF0014 키 결합 카디널리티 실측.

가설: 업로드 양식 1행 = [DMF0014 키 조합(Plant/CustProject/CustModel/Incoterms/FcstType/DomExp/Project/Model)]
                      × [DMF0007 기준 measure(DM_MST_CUSTOMER_FCST — division+site 스코프, UPLOAD_BUCKET_TYPE)]
  → 실적이 없는 measure 도 양식에 나온다 = "MAIN GRID 와 항상 일치하지 않는다"(사용자 원문)의 구조적 이유.
"""
import io, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(t, sql, b=None):
    print("\n" + "=" * 100); print(f"## {t}"); print("-" * 100)
    cur.execute(sql, b or {})
    cols = [c[0] for c in cur.description]; rows = cur.fetchall()
    print("   " + " | ".join(cols)) if rows else print("   0행")
    for r in rows[:12]:
        print("   " + " | ".join("" if v is None else str(v)[:40] for v in r))
    print(f"   ({len(rows)} rows)")


q("① DMF0007 기준 measure 수 (division × bucket)", """
  SELECT DIVISION_ID, UPLOAD_BUCKET_TYPE, COUNT(DISTINCT MEASURE) MEASURES,
         COUNT(DISTINCT SCM_SITE_ID) SITES, COUNT(*) ROWS_
  FROM SCM_MGR.DM_MST_CUSTOMER_FCST WHERE VALID_YN='Y'
  GROUP BY DIVISION_ID, UPLOAD_BUCKET_TYPE ORDER BY 1,2""")

q("② DMF0007 기준 — division+site 별 measure 종수 (샘플)", """
  SELECT DIVISION_ID, SCM_SITE_ID, UPLOAD_BUCKET_TYPE,
         COUNT(DISTINCT MEASURE) MEASURES, COUNT(DISTINCT UPLOAD_UOM) UOMS
  FROM SCM_MGR.DM_MST_CUSTOMER_FCST WHERE VALID_YN='Y'
  GROUP BY DIVISION_ID, SCM_SITE_ID, UPLOAD_BUCKET_TYPE
  ORDER BY 1,2 FETCH FIRST 10 ROWS ONLY""")

q("③ DMF0014 키 조합 수 (PSI DISTINCT — measure 제외)", """
  SELECT DIVISION_ID, COUNT(*) KEY_COMBOS FROM (
    SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, CUSTOMER_PROJECT_CODE,
           CUSTOMER_MODEL, INCOTERMS, FCST_TYPE, DOM_EXP, PROJECT_CODE, ITEM_ID
    FROM SCM_MGR.DM_PLN_CUSTOMER_PSI WHERE MEASURE_GROUP='CUST_FCST')
  GROUP BY DIVISION_ID ORDER BY 1""")

q("④ 결합 카디널리티 (키 조합 × 기준 measure) — division 별", """
  SELECT K.DIVISION_ID, COUNT(*) FORM_ROWS FROM (
    SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, CUSTOMER_PROJECT_CODE,
           CUSTOMER_MODEL, INCOTERMS, FCST_TYPE, DOM_EXP, PROJECT_CODE, ITEM_ID
    FROM SCM_MGR.DM_PLN_CUSTOMER_PSI WHERE MEASURE_GROUP='CUST_FCST') K
  JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, MEASURE_GROUP, MEASURE, UPLOAD_UOM
        FROM SCM_MGR.DM_MST_CUSTOMER_FCST
        WHERE VALID_YN='Y' AND UPLOAD_BUCKET_TYPE='WEEKLY') M
    ON K.DIVISION_ID = M.DIVISION_ID AND K.SCM_SITE_ID = M.SCM_SITE_ID
  GROUP BY K.DIVISION_ID ORDER BY 1""")

q("⑤ 대조 — 현행(원장 기반) 양식 행수 vs 신설(기준 결합) 행수 : div 81 WEEKLY", """
  SELECT
    (SELECT COUNT(*) FROM (
       SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, CUSTOMER_PROJECT_CODE, CUSTOMER_MODEL,
              INCOTERMS, FCST_TYPE, DOM_EXP, MEASURE_GROUP, MEASURE, UPLOAD_UOM, PROJECT_CODE, ITEM_ID
       FROM SCM_MGR.DM_PLN_CUSTOMER_PSI WHERE MEASURE_GROUP='CUST_FCST' AND DIVISION_ID='81')) AS 현행_원장기반,
    (SELECT COUNT(*) FROM (
       SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, CUSTOMER_PROJECT_CODE,
              CUSTOMER_MODEL, INCOTERMS, FCST_TYPE, DOM_EXP, PROJECT_CODE, ITEM_ID
       FROM SCM_MGR.DM_PLN_CUSTOMER_PSI WHERE MEASURE_GROUP='CUST_FCST' AND DIVISION_ID='81') K
     JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, MEASURE_GROUP, MEASURE, UPLOAD_UOM
           FROM SCM_MGR.DM_MST_CUSTOMER_FCST WHERE VALID_YN='Y' AND UPLOAD_BUCKET_TYPE='WEEKLY') M
       ON K.DIVISION_ID=M.DIVISION_ID AND K.SCM_SITE_ID=M.SCM_SITE_ID) AS 신설_기준결합
  FROM DUAL""")

con.close()
