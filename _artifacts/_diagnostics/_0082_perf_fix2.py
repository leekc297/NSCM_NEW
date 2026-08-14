#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 조회 튜닝 2차 — SQL_ID 39zy6yw60vt62 (INSERT INTO GT_DMF0082_T_LAST_DATA_SETUP_PRICE).

⓪ 실측 (2026-08-15, 사용자 파라미터 재현):
   SP 24.7s 중 **14s(45.2%)** 점유 — ASH 최상위. V$SQL elapsed 88.8s/19회, buffer_gets 19,989,169.
   PLAN LINE 7 `INDEX RANGE SCAN PK_DM_PLN_CFM_SELLING_PRICE` 가 14/14초.

순위별 판정 (hook #129):
  ① SELECT 목록 함수·스칼라 서브쿼리 → **해당 없음** (MAX 집계뿐)
  ② SARGable                      → **이미 충족** (DIVISION_ID 등가 + YYYYMMDD BETWEEN, 인덱스 컬럼)
  ③ 인덱스 추가                    → **불필요** — PK 가 이미 있고 그 인덱스를 타는 중.
                                     문제는 인덱스 부재가 아니라 **행별로 2천만 번 탄 것**(§1.1 GTT 단서)
  ④ 힌트                          → **적용** LEADING(A) USE_HASH(C)

구조: GTT `TEMP_SITE_ITEM` 추정 카디널리티 1(실제 14,879) → NESTED LOOPS 로 대형표
      `DM_PLN_CFM_SELLING_PRICE`(div40 103만행)를 행별 인덱스 조회.
      1차 튜닝(3a8jzvxnc57hz)과 **동일 계보** — 그때 170s→1s 로 해소된 것과 같은 처방.
"""
import io, pathlib, re, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_PERF_20260815")
OUT.mkdir(parents=True, exist_ok=True)

OLD = """    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A"""
NEW = """    SELECT /*+ LEADING(A) USE_HASH(C) */ -- ④ [E20260815-PERF2] 계획 고정 (hook #129 ④)
               -- GTT C(TEMP_SITE_ITEM) 는 세션 데이터라 통계가 없어 추정 1행으로 굳는다(실제 14,879).
               -- 그 결과 NESTED LOOPS 로 대형표 A(div40 103만행)를 **행별 인덱스 조회** 했다
               -- (실측: ASH 14s/45.2% · buffer_gets 19,989,169 · PLAN LINE 7 INDEX RANGE SCAN).
               -- ①함수/스칼라서브쿼리 없음 ②이미 SARGable ③PK 존재(인덱스 부재 아님) ⇒ ④ 적용.
           A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A"""

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())
(OUT / "00_BACKUP2_PKG_DMF0082_BODY.sql").write_text(
    "-- 2차 튜닝 전 백업\nSET DEFINE OFF\nCREATE OR REPLACE " + body.rstrip() + "\n/\n", encoding="utf-8")

n = body.count(OLD)
print(f"[anchor] {n}회")
assert n == 1, f"앵커 {n}회 — 고유하지 않음"
body2 = body.replace(OLD, NEW, 1)

(OUT / "02_PKG_DMF0082_BODY_PERF2_LASTDATA.sql").write_text(
    "SET DEFINE OFF\nCREATE OR REPLACE " + body2.rstrip() + "\n/\nSHOW ERRORS\n", encoding="utf-8")
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 180")
cur.execute("CREATE OR REPLACE " + body2.rstrip())
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'")
print(f"[deploy] errors={cur.fetchone()[0]}")
cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0082' ORDER BY 1""")
for r in cur.fetchall():
    print(f"   {r[0]:<14} {r[1]}")
con.close()
