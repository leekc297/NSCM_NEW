#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""회귀 원인 확인 — PLAN_REPORT_C 의 DATA_TYPE='2' 행이 화면 조회 조건과 맞는가 (조회 전용)"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

DIV, VER = '40', 'R_S_20260810_V010_C'
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[1] PLAN_REPORT_C DATA_TYPE='2' 의 CUTOFF_TYPE 분포 (화면은 P_MDF_TYPE='REPORT_SP_W' 로 조회)")
show(*fetch(cur, """
SELECT DATA_TYPE, CUTOFF_TYPE, SUBSTR(YYYYMMDD,1,4) yyyy, COUNT(*) rows_
  FROM DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID=:d AND VERSION_NO=:v
 GROUP BY DATA_TYPE, CUTOFF_TYPE, SUBSTR(YYYYMMDD,1,4)
 ORDER BY DATA_TYPE, CUTOFF_TYPE, yyyy""", {"d": DIV, "v": VER}))

sec("[2] ETC_REPORT_C 의 CUTOFF_TYPE 분포 (변경 전 원천)")
show(*fetch(cur, """
SELECT CUTOFF_TYPE, SUBSTR(YYYYMMDD,1,4) yyyy, COUNT(*) rows_
  FROM DM_PLN_SALES_ETC_REPORT_C
 WHERE DIVISION_ID=:d AND VERSION_NO=:v
 GROUP BY CUTOFF_TYPE, SUBSTR(YYYYMMDD,1,4)
 ORDER BY CUTOFF_TYPE, yyyy""", {"d": DIV, "v": VER}))

sec("[3] 판정")
cur.execute("""SELECT COUNT(*) FROM DM_PLN_SALES_PLAN_REPORT_C
                WHERE DIVISION_ID=:d AND VERSION_NO=:v AND DATA_TYPE='2'
                  AND CUTOFF_TYPE='REPORT_SP_W' AND SUBSTR(YYYYMMDD,1,4)='2026'""",
            {"d": DIV, "v": VER})
a = cur.fetchone()[0]
cur.execute("""SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C
                WHERE DIVISION_ID=:d AND VERSION_NO=:v
                  AND CUTOFF_TYPE='REPORT_SP_W' AND SUBSTR(YYYYMMDD,1,4)='2026'""",
            {"d": DIV, "v": VER})
b = cur.fetchone()[0]
print(f"  화면 조회조건(CUTOFF_TYPE='REPORT_SP_W', YYYY=2026) 충족 행수")
print(f"    PLAN_REPORT_C DATA_TYPE='2' : {a:,}   ← 변경 후 원천")
print(f"    ETC_REPORT_C                : {b:,}   ← 변경 전 원천")
print(f"  ⇒ {'⛔ 회귀 — 변경 후 원천에 데이터가 없다' if a < b else 'OK'}")

con.close()
