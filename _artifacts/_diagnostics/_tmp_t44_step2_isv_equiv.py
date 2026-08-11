#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0044 TRANSFER 튜닝 STEP2 — 병목(ISV) 1순위 구조치환 등가 증명 + 실측
   OLD: DM_MST_ITEM_SINGLE_V (SUBSTR 셀프조인 → VIEW PUSHED PREDICATE 로 붕괴)
   NEW: SCM_MST_ITEM_SN 단일 패스 + 분석함수 (SUBSTR 셀프조인 제거)
   ※ 조회 전용. 바인드로 실행(운영과 동일 조건)."""
import sys, pathlib, time
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

DIV = '40'

OLD = """
SELECT DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
  FROM DM_MST_ITEM_SINGLE_V
 WHERE DIVISION_ID = :d
"""

# 등가 근거: 뷰의 T2 는 같은 테이블을 (DIVISION_ID, SUBSTR(ITEM_ID,1,12)) 로 집계한 것이고
#   조인조건이 T1 의 자기 그룹과 정확히 일치하므로 inner join 이 행을 떨구지 않는다.
#   따라서 "T1 그룹(DIVISION_ID,ITEM_ID)별 MAX(T2.col)" = "SUBSTR12 파티션 전체의 MAX(col)".
NEW = """
SELECT DIVISION_ID, ITEM_ID,
       MAX(MAX(FORECAST_INFO_BIZ_TYPE))
           OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_BIZ_TYPE,
       MAX(MAX(FORECAST_INFO_CELL_PACK_COUNT))
           OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_CELL_PACK_COUNT
  FROM SCM_MST_ITEM_SN
 WHERE DIVISION_ID = :d
 GROUP BY DIVISION_ID, ITEM_ID
"""

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 900000   # 15분 — OLD 가 느릴 수 있음
cur = con.cursor()

def sec(t):
    print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[0] SCM_ITEM_M 컬럼 중 ITEM_ID / ITEM_ID_12 계열 존재 여부 (2순위 SARGable 재료)")
show(*fetch(cur, """
SELECT owner, table_name, column_name, data_type, data_default, virtual_column
  FROM all_tab_cols
 WHERE owner='FP_MGR' AND table_name='SCM_ITEM_M' AND column_name LIKE 'ITEM_ID%'
 ORDER BY column_id"""))
show(*fetch(cur, """
SELECT owner, index_name, table_owner, table_name, status, num_rows
  FROM all_indexes WHERE index_name IN ('IX_ITEM_SN_DA_ITEM','IX_ITEM_SN_DA_ITEM_1')"""))

def timed(label, sql, binds):
    t0 = time.time()
    cur.execute(sql, binds)
    rows = cur.fetchall()
    el = time.time() - t0
    # 결과 지문: 행수 + 키/값 체크섬
    n = len(rows)
    nn_biz = sum(1 for r in rows if r[2] is not None)
    s_pack = sum(float(r[3]) for r in rows if r[3] is not None)
    print(f"  {label:6s} : {el:8.2f} 초 / {n:,} 행 / BIZ_TYPE NOT NULL {nn_biz:,} / PACK_COUNT 합 {s_pack:,.3f}")
    return el, n, rows

sec(f"[1] 실측 — DIVISION_ID = {DIV} (바인드 사용, 운영과 동일 조건)")
print("  ※ OLD 는 붕괴 플랜이면 매우 오래 걸릴 수 있음 (call_timeout 900초)")
try:
    old_el, old_n, old_rows = timed("OLD", OLD, {"d": DIV})
except Exception as e:
    print(f"  OLD    : 실패/타임아웃 — {e}")
    old_el, old_n, old_rows = None, None, None
new_el, new_n, new_rows = timed("NEW", NEW, {"d": DIV})

sec("[2] 등가 증명 — MINUS 양방향 0행 (NULL 안전 비교)")
MINUS_SQL = f"""
SELECT COUNT(*) FROM (
  ( SELECT DIVISION_ID, ITEM_ID,
           NVL(FORECAST_INFO_BIZ_TYPE,'<<N>>') AS BT,
           NVL(TO_CHAR(FORECAST_INFO_CELL_PACK_COUNT),'<<N>>') AS PC
      FROM ({OLD.replace(':d', "'" + DIV + "'")}) )
  MINUS
  ( SELECT DIVISION_ID, ITEM_ID,
           NVL(FORECAST_INFO_BIZ_TYPE,'<<N>>'),
           NVL(TO_CHAR(FORECAST_INFO_CELL_PACK_COUNT),'<<N>>')
      FROM ({NEW.replace(':d', "'" + DIV + "'")}) )
)"""
MINUS_SQL_REV = f"""
SELECT COUNT(*) FROM (
  ( SELECT DIVISION_ID, ITEM_ID,
           NVL(FORECAST_INFO_BIZ_TYPE,'<<N>>') AS BT,
           NVL(TO_CHAR(FORECAST_INFO_CELL_PACK_COUNT),'<<N>>') AS PC
      FROM ({NEW.replace(':d', "'" + DIV + "'")}) )
  MINUS
  ( SELECT DIVISION_ID, ITEM_ID,
           NVL(FORECAST_INFO_BIZ_TYPE,'<<N>>'),
           NVL(TO_CHAR(FORECAST_INFO_CELL_PACK_COUNT),'<<N>>')
      FROM ({OLD.replace(':d', "'" + DIV + "'")}) )
)"""
for lbl, s in (("OLD MINUS NEW", MINUS_SQL), ("NEW MINUS OLD", MINUS_SQL_REV)):
    t0 = time.time(); cur.execute(s); v = cur.fetchone()[0]
    print(f"  {lbl} = {v} 행   ({time.time()-t0:.1f} 초)   {'PASS' if v == 0 else '*** FAIL ***'}")

con.close()
