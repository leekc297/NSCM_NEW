#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""최종 관문 — ETC 화면의 한 셀 ↔ ETC_REPORT_C 행이 1:1 인가 (UPDATE 대상 모호성 판정, 조회 전용)

조회 SP 의 ETC 분기는 SUM(R.QTY) 로 집계하고 GROUP BY 에 DATA_SEQ 가 없다.
따라서 여러 DATA_SEQ 행이 한 셀로 합쳐지면 "그 셀을 UPDATE" 가 성립하지 않는다.
"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

DIV, VER = '40', 'R_S_20260810_V010_C'
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 600000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

# ETC 분기 GROUP BY 키 (L1553~1560 실측) + 월
GKEY = """R.DIVISION_ID, R.VERSION_NO, R.CUTOFF_TYPE, R.CUTOFF_YYYYMMDD,
          R.DEPARTMENT_ID, R.DEPT_ID, R.END_CUST_REPORT, R.CUST_REPORT,
          R.PROJECT_CODE, R.SCM_SITE_ID, R.ITEM_ID, R.FCST_TYPE, R.INCOTERMS,
          R.MEASURE, R.PLANT_SITE_ID, R.COMPANY_ID, SUBSTR(R.YYYYMMDD,1,6), R.CURRENCY"""

sec(f"[1] 그리드 셀 1개당 ETC_REPORT_C 행 수 분포 — {VER}")
show(*fetch(cur, f"""
SELECT rows_per_cell, COUNT(*) cells, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER ()*100,1) pct
  FROM ( SELECT COUNT(*) rows_per_cell
           FROM DM_PLN_SALES_ETC_REPORT_C R
          WHERE R.DIVISION_ID=:d AND R.VERSION_NO=:v
          GROUP BY {GKEY} )
 GROUP BY rows_per_cell ORDER BY rows_per_cell""", {"d": DIV, "v": VER}))

sec("[2] 1행 초과 셀의 실물 (있다면 UPDATE 대상이 모호해지는 구간)")
show(*fetch(cur, f"""
SELECT * FROM (
  SELECT R.MEASURE, SUBSTR(R.YYYYMMDD,1,6) ym, R.ITEM_ID, R.CUST_REPORT,
         COUNT(*) rows_, COUNT(DISTINCT R.DATA_SEQ) seqs, SUM(R.QTY) qty_sum
    FROM DM_PLN_SALES_ETC_REPORT_C R
   WHERE R.DIVISION_ID=:d AND R.VERSION_NO=:v
   GROUP BY {GKEY}, R.MEASURE, R.ITEM_ID, R.CUST_REPORT
  HAVING COUNT(*) > 1 )
 ORDER BY rows_ DESC FETCH FIRST 10 ROWS ONLY""", {"d": DIV, "v": VER}))

sec("[3] 사용자가 저장한 그 셀 — ETC_REPORT_C 에 대응 행이 존재하는가")
show(*fetch(cur, """
SELECT DATA_SEQ, MEASURE, YYYYMMDD, QTY, CURRENCY, COMPANY_ID,
       TO_CHAR(LAST_UPDATE_DATE,'MM-DD HH24:MI') upd
  FROM DM_PLN_SALES_ETC_REPORT_C
 WHERE DIVISION_ID=:d AND VERSION_NO=:v AND ITEM_ID='ETC' AND CUST_REPORT='IM'
   AND MEASURE IN ('SalesAmt_KRW','SalesAmt_LOC')
   AND SUBSTR(YYYYMMDD,1,6) IN ('202603','202604','202605','202606')
 ORDER BY MEASURE, YYYYMMDD""", {"d": DIV, "v": VER}))

sec("[4] ETC_REPORT_C 의 YYYYMMDD 표기 vs PLAN 저장 표기 (매칭 가능성)")
show(*fetch(cur, """
SELECT 'ETC_REPORT_C' src, SUBSTR(YYYYMMDD,1,6) ym,
       LISTAGG(DISTINCT SUBSTR(YYYYMMDD,7,2), ',') WITHIN GROUP (ORDER BY SUBSTR(YYYYMMDD,7,2)) days
  FROM DM_PLN_SALES_ETC_REPORT_C
 WHERE DIVISION_ID=:d AND VERSION_NO=:v AND SUBSTR(YYYYMMDD,1,6) IN ('202603','202604')
 GROUP BY SUBSTR(YYYYMMDD,1,6)
UNION ALL
SELECT 'PLAN(DATA_TYPE=2)', SUBSTR(YYYYMMDD,1,6),
       LISTAGG(DISTINCT SUBSTR(YYYYMMDD,7,2), ',') WITHIN GROUP (ORDER BY SUBSTR(YYYYMMDD,7,2))
  FROM DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID=:d AND VERSION_NO=:v AND DATA_TYPE='2'
   AND SUBSTR(YYYYMMDD,1,6) IN ('202603','202604')
 GROUP BY SUBSTR(YYYYMMDD,1,6)
 ORDER BY 1,2""", {"d": DIV, "v": VER}))

con.close()
