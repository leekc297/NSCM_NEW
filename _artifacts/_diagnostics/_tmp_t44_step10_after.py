#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""STEP10 — (a) ROLLBACK 확인  (b) 새 최대 구간(M1 DELETE 6.38초) 의 1·2순위 진단"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

DIV, VER = '40', 'R_S_20260128_V002_C'
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

def sec(t): print("\n" + "=" * 112); print(t); print("=" * 112)

sec("[a] 실측 후 원상복구 확인 — 리포트 3표 + 원장 행수")
show(*fetch(cur, """
SELECT 'DM_MOBILE_REPORT_PRODUCT' t, COUNT(*) rows_ FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT
 WHERE DIVISION_ID=:d AND VERSION_NO=:v
UNION ALL SELECT 'DM_MOBILE_REPORT_DEPT', COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_DEPT
 WHERE DIVISION_ID=:d AND VERSION_NO=:v
UNION ALL SELECT 'DM_MOBILE_REPORT_EXCHANGE_RATE', COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE
 WHERE DIVISION_ID=:d AND VERSION_NO=:v
UNION ALL SELECT 'SALES_PLAN_REPORT_C DATA_TYPE=2', COUNT(*) FROM DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID=:d AND VERSION_NO=:v AND DATA_TYPE='2'
UNION ALL SELECT 'DM_MDF_VERSION.SEND_YN', COUNT(*) FROM DM_MDF_VERSION
 WHERE DIVISION_ID=:d AND VERSION_NO=:v AND SEND_YN='Y'""", {"d": DIV, "v": VER}))

sec("[b-2순위] M1 DELETE 대상표 인덱스 — SARGable 판정 재료")
show(*fetch(cur, """
SELECT i.index_name, i.uniqueness, i.num_rows, c.column_position, c.column_name
  FROM all_indexes i JOIN all_ind_columns c
    ON c.index_owner=i.owner AND c.index_name=i.index_name
 WHERE i.table_owner='SCM_MGR' AND i.table_name='DM_PLN_SALES_PLAN_REPORT_C'
 ORDER BY i.index_name, c.column_position"""))
show(*fetch(cur, """SELECT num_rows, blocks, TO_CHAR(last_analyzed,'YYYY-MM-DD HH24:MI') last_analyzed
                      FROM all_tables WHERE owner='SCM_MGR' AND table_name='DM_PLN_SALES_PLAN_REPORT_C'"""))

sec("[b-선택도] DELETE 조건의 실제 선택도 (DIVISION+VERSION 대비 DATA_TYPE='2')")
show(*fetch(cur, """
SELECT COUNT(*) total_div_ver,
       SUM(CASE WHEN DATA_TYPE='2' THEN 1 ELSE 0 END) dt2,
       COUNT(DISTINCT DATA_TYPE) distinct_dt
  FROM DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v""", {"d": DIV, "v": VER}))

sec("[b-1순위] M1 DELETE 문에 함수/서브쿼리가 있는가 (있으면 1순위 대상)")
print("  DELETE FROM DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID=? AND VERSION_NO=? AND DATA_TYPE='2'")
print("  → 선택목록 없음 / 함수 없음 / 서브쿼리 없음 ⇒ 1순위 대상 아님. 2순위(인덱스)·부수비용(인덱스 유지·undo) 영역")

con.close()
