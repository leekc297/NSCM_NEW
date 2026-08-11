#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""2배 표시 원인 사냥 — 조회 SP 의 GTT 적재부 + 남은 조인 후보 유일성 (조회 전용)
   남은 후보: GT_F044_DM_MST_ITEM_SINGLE_V(SINGLE) / GT_F044_PJT(PJT) / LU / LK3 / LK4
   + GT_F044_T 초기화 여부(호출 누적 가능성)
"""
import sys, pathlib, re
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN 1063 AND 1720 ORDER BY LINE""")
src = cur.fetchall()
body = {ln: tx.rstrip() for ln, tx in src}

sec("[A] GTT 초기화 / 적재 문장 위치 (누적 가능성 + DISTINCT 유무)")
for ln in sorted(body):
    t = body[ln]
    if re.search(r'(DELETE\s+FROM|INSERT\s+INTO|TRUNCATE)\s+\S*GT_F044', t, re.I):
        print(f"  L{ln:5d} | {t.strip()[:140]}")

sec("[B] GT_F044_PJT 적재문 전문 — (DIVISION_ID, PROJECT_CODE) 유일성이 보장되나")
start = None
for ln in sorted(body):
    if re.search(r'INSERT\s+INTO\s+\S*GT_F044_PJT', body[ln], re.I):
        start = ln
        break
if start:
    for ln in range(start, min(start + 45, max(body) + 1)):
        if ln in body:
            print(f"  L{ln:5d} | {body[ln][:150]}")
            if body[ln].rstrip().endswith(';'):
                break
else:
    print("  (GT_F044_PJT 적재문 미발견)")

sec("[C] GT_F044_DM_MST_ITEM_SINGLE_V 적재문 전문")
start = None
for ln in sorted(body):
    if re.search(r'INSERT\s+INTO\s+\S*GT_F044_DM_MST_ITEM_SINGLE_V', body[ln], re.I):
        start = ln
        break
if start:
    for ln in range(start, min(start + 30, max(body) + 1)):
        if ln in body:
            print(f"  L{ln:5d} | {body[ln][:150]}")
            if body[ln].rstrip().endswith(';'):
                break
else:
    print("  (적재문 미발견)")

sec("[D] Cutoff 분기 조인 대상 원본표 유일성 실측 (대상 행의 키로)")
show(*fetch(cur, """
WITH R AS (
  SELECT * FROM DM_PLN_SALES_PLAN_REPORT_C
   WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260810_V010_C'
     AND ITEM_ID='ETC' AND CUST_REPORT='IM' AND MEASURE='SalesAmt_KRW'
     AND SUBSTR(YYYYMMDD,1,6)='202603' )
SELECT R.PROJECT_CODE, R.SCM_SITE_ID, R.ITEM_ID, R.CELL_PROD_SITE,
       (SELECT COUNT(*) FROM SCM_MST_SITE_PROJECT_ITEM_MAPPING M
         WHERE M.DIVISION_ID=R.DIVISION_ID AND M.PROJECT_CODE=R.PROJECT_CODE) pjt_src_hits,
       (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.SEGMENT1=R.PROJECT_CODE AND L.LOOKUP_TYPE='DM_ITEM_USE_EX') lk3_hits,
       (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.SEGMENT1=R.CELL_PROD_SITE AND L.LOOKUP_TYPE='SP_CELL_PROD_SITE') lk4_hits,
       (SELECT COUNT(*) FROM (SELECT DISTINCT SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,ATTRIBUTE1,ATTRIBUTE4
                                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE LOOKUP_TYPE='SALES_SITE_REPORT_GROUP') X
         WHERE X.SEGMENT1=R.DIVISION_ID AND X.SEGMENT2=R.PROJECT_CODE
           AND X.SEGMENT3=R.SCM_SITE_ID AND X.SEGMENT4=R.ITEM_ID) lu_hits,
       (SELECT COUNT(*) FROM DM_MST_ITEM_SINGLE_V V
         WHERE V.DIVISION_ID=R.DIVISION_ID AND V.ITEM_ID=R.ITEM_ID) single_src_hits
  FROM R"""))

sec("[E] 같은 그룹에 원장 행이 정말 1건뿐인가 — GROUP BY 키 전부로 재확인")
show(*fetch(cur, """
SELECT COUNT(*) rows_, SUM(QTY) qty_sum,
       COUNT(DISTINCT DATA_TYPE) dt, COUNT(DISTINCT CUTOFF_TYPE) ct,
       COUNT(DISTINCT DEPARTMENT_ID) dep, COUNT(DISTINCT DEPT_ID) tm,
       COUNT(DISTINCT PROJECT_CODE) pj, COUNT(DISTINCT SCM_SITE_ID) st,
       COUNT(DISTINCT PLANT_SITE_ID) pl, COUNT(DISTINCT COMPANY_ID) co,
       COUNT(DISTINCT CURRENCY) cu, COUNT(DISTINCT FCST_TYPE) ft,
       COUNT(DISTINCT INCOTERMS) ic, COUNT(DISTINCT YYYYMMDD) ymd
  FROM DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260810_V010_C'
   AND ITEM_ID='ETC' AND CUST_REPORT='IM' AND MEASURE='SalesAmt_KRW'
   AND SUBSTR(YYYYMMDD,1,6)='202603'"""))

con.close()
