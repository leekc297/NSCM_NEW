#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Cutoff 조회에서 저장값이 2배로 보이는 원인 규명 (조회 전용)
   후보 ① 원장에 같은 그룹 행이 2건 (DATA_TYPE 1/2 등)
   후보 ② 조회문의 LOOKUP 조인(LK1 MDF_DEPARTMENT / LK2 DMF0044_DEPARTMENT_TEAM2 등)이
          집계 이전에 행을 2배로 불림 — B-1 과 동일 계열"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

VER = 'R_S_20260810_V010_C'
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[후보①] 원장 실제 행 — ITEM_ID='ETC' / CUST_REPORT='IM' / SalesAmt_KRW / 2026-03~06")
show(*fetch(cur, """
SELECT DATA_TYPE, MEASURE, YYYYMMDD, QTY, DEPARTMENT_ID, DEPT_ID, CURRENCY, COMPANY_ID,
       TO_CHAR(LAST_UPDATE_DATE,'HH24:MI:SS') upd
  FROM DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID='40' AND VERSION_NO=:v AND ITEM_ID='ETC' AND CUST_REPORT='IM'
   AND MEASURE='SalesAmt_KRW' AND SUBSTR(YYYYMMDD,1,6) IN ('202603','202604','202605','202606')
 ORDER BY YYYYMMDD, DATA_TYPE""", {"v": VER}))
cur.execute("""SELECT COUNT(*), SUM(QTY) FROM DM_PLN_SALES_PLAN_REPORT_C
                WHERE DIVISION_ID='40' AND VERSION_NO=:v AND ITEM_ID='ETC' AND CUST_REPORT='IM'
                  AND MEASURE='SalesAmt_KRW' AND SUBSTR(YYYYMMDD,1,6)='202603'""", {"v": VER})
n, s = cur.fetchone()
print(f"\n  → 202603 원장 행수 {n} / QTY 합 {s}   (화면 표시 2 / 저장 1)")

sec("[후보②] 조회문 LOOKUP 조인의 키 유일성 — 집계 이전 행 증식 여부")
show(*fetch(cur, """
SELECT LOOKUP_TYPE, COUNT(*) rows_, COUNT(DISTINCT SEGMENT1) keys_,
       COUNT(*) - COUNT(DISTINCT SEGMENT1) surplus,
       CASE WHEN COUNT(*) = COUNT(DISTINCT SEGMENT1) THEN 'OK (1:1)' ELSE '⛔ 중복 — 행 증식' END verdict
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE IN ('MDF_DEPARTMENT','MDF_DEPARTMENT40','MDF_DEPARTMENT81','MDF_DEPARTMENT82',
                       'DMF0044_DEPARTMENT_TEAM2','DMF0044_DEPARTMENT_TEAM240',
                       'DM_ITEM_USE_EX','SP_CELL_PROD_SITE','SALES_SITE_REPORT_GROUP')
 GROUP BY LOOKUP_TYPE ORDER BY surplus DESC, LOOKUP_TYPE"""))

sec("[후보②-b] 이 행의 DEPARTMENT_ID / DEPT_ID 가 실제로 몇 건 매칭되나")
show(*fetch(cur, """
SELECT R.DEPARTMENT_ID, R.DEPT_ID,
       (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.SEGMENT1=R.DEPARTMENT_ID AND L.LOOKUP_TYPE='MDF_DEPARTMENT') lk1_hits,
       (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.SEGMENT1=R.DEPT_ID AND L.LOOKUP_TYPE='DMF0044_DEPARTMENT_TEAM2') lk2_hits,
       (SELECT COUNT(*) FROM SCM_MST_SITE ST
         WHERE ST.SCM_SITE_ID=R.SCM_SITE_ID AND ST.DIVISION_ID=R.DIVISION_ID) site_hits,
       (SELECT COUNT(*) FROM SCM_MST_SITE_CUSTOMER CS
         WHERE CS.DIVISION_ID=R.DIVISION_ID AND CS.SCM_SITE_ID=R.SCM_SITE_ID
           AND CS.REP_YN='Y') cust_hits,
       (SELECT COUNT(*) FROM SCM_MST_SITE_ITEM SI
         WHERE SI.PROJECT_CODE=R.PROJECT_CODE AND SI.SCM_SITE_ID=R.SCM_SITE_ID
           AND SI.ITEM_ID=R.ITEM_ID) item_hits
  FROM DM_PLN_SALES_PLAN_REPORT_C R
 WHERE R.DIVISION_ID='40' AND R.VERSION_NO=:v AND R.ITEM_ID='ETC' AND R.CUST_REPORT='IM'
   AND R.MEASURE='SalesAmt_KRW' AND SUBSTR(R.YYYYMMDD,1,6)='202603'""", {"v": VER}))

con.close()
