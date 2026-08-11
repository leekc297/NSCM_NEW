#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SID 512 (SQL_ID 5dchxk6z8k7hg) 상세 — TRANSFER 병목 구간 실측 근거 확보"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

SQLID = '5dchxk6z8k7hg'

print("=" * 120)
print("[A] V$SQL 통계 (해당 SQL_ID) — 실행/경과/버퍼/디스크")
print("=" * 120)
show(*fetch(cur, """
SELECT sql_id, child_number, plan_hash_value, executions,
       ROUND(elapsed_time/1e6,1) AS elapsed_s, ROUND(cpu_time/1e6,1) AS cpu_s,
       buffer_gets, disk_reads, rows_processed,
       TO_CHAR(last_active_time,'YYYY-MM-DD HH24:MI:SS') AS last_active
  FROM v$sql WHERE sql_id = :i ORDER BY child_number""", {"i": SQLID}))

print()
print("=" * 120)
print("[B] 현재 세션 SQL MONITOR — 플랜 라인별 실제 소요 (병목 라인 식별)")
print("=" * 120)
show(*fetch(cur, """
SELECT plan_line_id, plan_operation || ' ' || plan_options AS operation,
       plan_object_name AS obj, plan_cardinality AS est_rows,
       output_rows, starts, workarea_mem, workarea_tempseg,
       ROUND(NVL(physical_read_bytes,0)/1024/1024,1) AS phy_rd_mb
  FROM v$sql_plan_monitor
 WHERE sid = 512 AND sql_id = :i
 ORDER BY plan_line_id""", {"i": SQLID}))

print()
print("=" * 120)
print("[C] ASH — SID 512 의 시간 소비 분포 (플랜 라인 / 이벤트별)")
print("=" * 120)
show(*fetch(cur, """
SELECT sql_plan_line_id, NVL(event,'ON CPU') AS event, COUNT(*) AS samples,
       ROUND(COUNT(*)/SUM(COUNT(*)) OVER () * 100, 1) AS pct
  FROM v$active_session_history
 WHERE session_id = 512 AND session_serial# = 2298 AND sql_id = :i
 GROUP BY sql_plan_line_id, event
 ORDER BY samples DESC""", {"i": SQLID}))

print()
print("=" * 120)
print("[D] 실행 계획 (DBMS_XPLAN 대신 V$SQL_PLAN 요약)")
print("=" * 120)
show(*fetch(cur, """
SELECT id, LPAD(' ', depth) || operation || ' ' || NVL(options,'') AS operation,
       object_name, cardinality AS est_rows, bytes, cost, access_predicates, filter_predicates
  FROM v$sql_plan
 WHERE sql_id = :i AND child_number = (SELECT MIN(child_number) FROM v$sql WHERE sql_id = :i)
 ORDER BY id""", {"i": SQLID}))

print()
print("=" * 120)
print("[E] SQL 전문")
print("=" * 120)
cur.execute("SELECT sql_fulltext FROM v$sql WHERE sql_id = :i AND ROWNUM = 1", {"i": SQLID})
r = cur.fetchone()
txt = r[0].read() if hasattr(r[0], 'read') else r[0]
pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\_tmp_SID512_SQL.sql").write_text(txt, encoding="utf-8")
print(txt[:4000])
print(f"... (총 {len(txt)} bytes — 전문은 _tmp_SID512_SQL.sql)")

con.close()
