# -*- coding: utf-8 -*-
"""현재 상태 스냅샷 — 세션 / PKG 마커 / 환율 원장(40)"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("== ACTIVE JDBC 세션 ==")
cur.execute("""SELECT SID, SERIAL#, ROUND(LAST_CALL_ET/60,1), EVENT, SQL_ID, BLOCKING_SESSION
                 FROM V$SESSION WHERE PROGRAM LIKE 'JDBC%' AND STATUS='ACTIVE'""")
for r in cur.fetchall():
    print("  SID=%s SERIAL#=%s %.1f분 %s sql=%s blocked_by=%s" % r)

print("== 내 python 세션 대기 ==")
cur.execute("""SELECT SID, SERIAL#, ROUND(LAST_CALL_ET/60,1), EVENT, BLOCKING_SESSION
                 FROM V$SESSION WHERE PROGRAM LIKE 'python%' AND STATUS='ACTIVE' AND SID <> SYS_CONTEXT('USERENV','SID')""")
for r in cur.fetchall():
    print("  SID=%s SERIAL#=%s %.1f분 %s blocked_by=%s" % r)

print("== PKG_DMF0044 마커 ==")
for m in ("DYNSAMP 2026-08-10", "DYNSAMP2 2026-08-10", "DYNSAMP3 2026-08-10",
          "SEQGRP 2026-08-10", "ETCDEL 2026-08-10"):
    cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, :m)),0) FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""", {"m": m})
    print("  %-22s %d" % (m, cur.fetchone()[0]))

print("== 환율 원장 (division 40) — 최근 버전 ==")
cur.execute("""SELECT VERSION_NO, COUNT(*) FROM SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
                WHERE DIVISION_ID='40' GROUP BY VERSION_NO ORDER BY 2 DESC FETCH FIRST 5 ROWS ONLY""")
for r in cur.fetchall():
    print("  %-24s %d" % r)

print("== 환율 마스터 원천 (SCM_MST_EXCHANGE_RATE) ==")
try:
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_MST_EXCHANGE_RATE""")
    print("  총 행수 =", cur.fetchone()[0])
    cur.execute("""SELECT DIVISION_ID, COUNT(*) FROM SCM_MGR.SCM_MST_EXCHANGE_RATE
                    GROUP BY DIVISION_ID ORDER BY 1""")
    for r in cur.fetchall():
        print("  DIV %-8s %d" % r)
except Exception as e:  # noqa: BLE001
    print("  (조회 실패)", str(e)[:120])
con.close()
