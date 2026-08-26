# -*- coding: utf-8 -*-
"""빠른 진단 쿼리 후보의 사내 실소요 측정 (읽기 전용) — 느린 진단 SQL 재발 방지(#129 계열)."""
import io
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

Q = [
    ("F1 BIZ 선택버전 존재(EXISTS/PK)",
     "SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.DM_PLN_BP_FCST_C "
     "WHERE DIVISION_ID='40' AND VERSION_NO='BP_M_20260810_V001' AND ROWNUM=1)"),
    ("F2 BIZ 버전 목록(DISTINCT/PK 선두)",
     "SELECT COUNT(*) FROM (SELECT DISTINCT VERSION_NO FROM SCM_MGR.DM_PLN_BP_FCST_C WHERE DIVISION_ID='40')"),
    ("F3 BIZ measure 1건 EXISTS",
     "SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.DM_PLN_BP_FCST_C WHERE DIVISION_ID='40' "
     "AND VERSION_NO='BP_M_20260810_V001' AND MEASURE='Business_Plan' AND ROWNUM=1)"),
    ("F4 MKT 존재(EXISTS/IDX_N1)",
     "SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST WHERE DIVISION_ID='40' "
     "AND YYYYMMDD BETWEEN '20260801' AND '20270228' AND ROWNUM=1)"),
    ("F5 SALES 존재(EXISTS/IDX_N1)",
     "SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE DIVISION_ID='40' "
     "AND YYYYMMDD BETWEEN '20260801' AND '20270228' AND ROWNUM=1)"),
    ("X5 (구) SALES COUNT(*) 전체 — 대조군",
     "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE DIVISION_ID='40' "
     "AND YYYYMMDD BETWEEN '20260801' AND '20270228'"),
    ("F6 통계 기반 규모(즉시)",
     "SELECT NUM_ROWS FROM ALL_TAB_STATISTICS WHERE OWNER='SCM_MGR' "
     "AND TABLE_NAME='DM_PLN_SALES_PLAN' AND PARTITION_NAME IS NULL"),
]
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
for label, sql in Q:
    t0 = time.time()
    try:
        cur.execute(sql)
        v = cur.fetchone()
        print(f"{time.time()-t0:7.2f}s  {label:38} → {v[0]}")
    except Exception as e:
        print(f"{time.time()-t0:7.2f}s  {label:38} → ERR {str(e)[:70]}")
con.close()
