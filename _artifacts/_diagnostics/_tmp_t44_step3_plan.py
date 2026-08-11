#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""STEP3 — OLD/NEW ISV 서버측 순수 소요(페치 제외) + 실행계획 대조"""
import sys, pathlib, time
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

DIV = '40'
OLD_INNER = "SELECT DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT FROM DM_MST_ITEM_SINGLE_V WHERE DIVISION_ID = :d"
NEW_INNER = """SELECT DIVISION_ID, ITEM_ID,
       MAX(MAX(FORECAST_INFO_BIZ_TYPE))        OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_BIZ_TYPE,
       MAX(MAX(FORECAST_INFO_CELL_PACK_COUNT)) OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_CELL_PACK_COUNT
  FROM SCM_MST_ITEM_SN WHERE DIVISION_ID = :d GROUP BY DIVISION_ID, ITEM_ID"""

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 900000
cur = con.cursor()

for lbl, inner in (("OLD", OLD_INNER), ("NEW", NEW_INNER)):
    sql = f"SELECT /*T44_{lbl}*/ COUNT(*) c, COUNT(FORECAST_INFO_BIZ_TYPE) b, SUM(FORECAST_INFO_CELL_PACK_COUNT) s FROM ({inner})"
    t0 = time.time(); cur.execute(sql, {"d": DIV}); r = cur.fetchone(); el = time.time() - t0
    print(f"[{lbl}] 서버측 {el:7.2f} 초 — 행 {r[0]:,} / BIZ NOT NULL {r[1]:,} / PACK 합 {r[2]}")
    cur.execute("""SELECT sql_id, child_number, plan_hash_value, ROUND(elapsed_time/1e6,2) el,
                          buffer_gets, disk_reads
                     FROM v$sql WHERE sql_text LIKE :t AND sql_text NOT LIKE '%v$sql%'
                     ORDER BY last_active_time DESC FETCH FIRST 1 ROWS ONLY""",
                {"t": f"%T44_{lbl}%"})
    row = cur.fetchone()
    if row:
        sid_, ch, ph, el2, bg, dr = row
        print(f"      sql_id={sid_} plan_hash={ph} elapsed={el2}s buffer_gets={bg:,} disk_reads={dr:,}")
        show(*fetch(cur, """SELECT id, LPAD(' ',depth)||operation||' '||NVL(options,'') AS op,
                                   object_name, cardinality est_rows, cost
                              FROM v$sql_plan WHERE sql_id=:i AND child_number=:c ORDER BY id""",
                    {"i": sid_, "c": ch}))
    print()

con.close()
