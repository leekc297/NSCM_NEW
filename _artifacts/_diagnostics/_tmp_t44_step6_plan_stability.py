#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""STEP6 — "왜 그때는 52분, 지금은 1초인가" 규명 + NEW 가 그 붕괴를 구조적으로 배제하는지 확인.

핵심 질문 3개
  Q1. 사고 당시 플랜(plan_hash 237589406)이 아직 커서 캐시에 있는가? 몇 개의 child/plan 이 있나?
  Q2. OLD 문장 형태는 지금도 PUSHED PREDICATE 플랜을 만들 수 있는가(= 플랜 불안정)?
  Q3. NEW 문장 형태는 PUSHED PREDICATE 노드를 구조적으로 만들 수 없는가?
"""
import sys, pathlib, re, time
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 300000
cur = con.cursor()

def sec(t):
    print("\n" + "=" * 116); print(t); print("=" * 116)

sec("[Q1] 사고 SQL_ID 5dchxk6z8k7hg 의 커서/플랜 현황 (KILL 이후)")
show(*fetch(cur, """
SELECT sql_id, child_number, plan_hash_value, executions,
       ROUND(elapsed_time/1e6,1) elapsed_s, buffer_gets, rows_processed,
       is_bind_sensitive, is_bind_aware, is_shareable,
       TO_CHAR(last_active_time,'YYYY-MM-DD HH24:MI:SS') last_active
  FROM v$sql WHERE sql_id='5dchxk6z8k7hg' ORDER BY child_number"""))

sec("[Q1-b] AWR 이력 — 이 SQL 의 plan_hash 별 수행 이력 (같은 텍스트가 여러 플랜을 탔는가)")
show(*fetch(cur, """
SELECT plan_hash_value, COUNT(*) snaps, SUM(executions_delta) execs,
       ROUND(SUM(elapsed_time_delta)/1e6,1) elapsed_s,
       TO_CHAR(MIN(s.begin_interval_time),'MM-DD HH24:MI') first_seen,
       TO_CHAR(MAX(s.begin_interval_time),'MM-DD HH24:MI') last_seen
  FROM dba_hist_sqlstat st JOIN dba_hist_snapshot s
    ON s.snap_id=st.snap_id AND s.instance_number=st.instance_number
 WHERE st.sql_id='5dchxk6z8k7hg'
 GROUP BY plan_hash_value ORDER BY elapsed_s DESC"""))

sec("[Q1-c] 사고 플랜(237589406) 이 아직 라이브 캐시에 존재하는가")
show(*fetch(cur, """
SELECT COUNT(*) AS live_cursors_with_bad_plan
  FROM v$sql WHERE sql_id='5dchxk6z8k7hg' AND plan_hash_value=237589406"""))

# ---- Q2/Q3 : EXPLAIN PLAN 으로 두 형태의 플랜을 강제 산출 (실행 없음) ----
OLD_ISV = """SELECT /*+ MATERIALIZE */ DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
               FROM DM_MST_ITEM_SINGLE_V WHERE DIVISION_ID = :d"""
NEW_ISV = """SELECT /*+ MATERIALIZE */ DIVISION_ID, ITEM_ID,
                    MAX(MAX(FORECAST_INFO_BIZ_TYPE))        OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_BIZ_TYPE,
                    MAX(MAX(FORECAST_INFO_CELL_PACK_COUNT)) OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_CELL_PACK_COUNT
               FROM SCM_MST_ITEM_SN WHERE DIVISION_ID = :d GROUP BY DIVISION_ID, ITEM_ID"""

for lbl, isv in (("OLD", OLD_ISV), ("NEW", NEW_ISV)):
    sec(f"[Q2/Q3-{lbl}] ISV 형태의 플랜 (EXPLAIN PLAN — 실행 없음, 바인드 미피킹 = 최악조건)")
    stmt = f"SELECT COUNT(*) FROM ({isv})"
    cur.execute(f"EXPLAIN PLAN SET STATEMENT_ID='T44{lbl}' FOR {stmt}")
    show(*fetch(cur, """SELECT id, LPAD(' ',depth)||operation||' '||NVL(options,'') op,
                               object_name, cardinality est_rows, cost
                          FROM plan_table WHERE statement_id=:s ORDER BY id""", {"s": f"T44{lbl}"}))
    cur.execute("""SELECT COUNT(*) FROM plan_table
                    WHERE statement_id=:s AND options='PUSHED PREDICATE'""", {"s": f"T44{lbl}"})
    npp = cur.fetchone()[0]
    cur.execute("""SELECT NVL(MAX(cardinality),0), NVL(MAX(cost),0) FROM plan_table WHERE statement_id=:s""",
                {"s": f"T44{lbl}"})
    mc, mcost = cur.fetchone()
    print(f"  ★ PUSHED PREDICATE 노드 = {npp}   최대 EST 행 = {int(mc):,}   최대 COST = {int(mcost):,}")
    cur.execute("DELETE FROM plan_table WHERE statement_id=:s", {"s": f"T44{lbl}"})
    con.commit()

con.close()
