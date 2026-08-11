#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_ab.py — Transfer 분기 조인의 A/B 실측 (읽기 전용 SELECT 만)

같은 대상 버전으로 3안을 동일 조건 비교한다:
  (A) 원본 무힌트            — 배포 전 거동 (VIEW PUSHED PREDICATE)
  (B) NO_PUSH_PRED+USE_HASH — 내가 배포한 TUNE-T ①
  (C) WITH MATERIALIZE       — 뷰 1회 산출 후 해시조인 (hook #129 1순위 '선계산 후 JOIN')
행집합 동일성도 COUNT + SUM 으로 대조한다.
"""
import pathlib
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

VER = "R_S_20260128_V002_C"

BODY = """
  FROM DM_PLN_SALES_PLAN_REPORT_C A
  LEFT OUTER JOIN {SRC} B
    ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
 WHERE A.DIVISION_ID = '40'
   AND A.VERSION_NO  = '{V}'
   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')
"""

SEL = ("SELECT COUNT(*) AS CNT, COUNT(B.FORECAST_INFO_BIZ_TYPE) AS BIZ_CNT, "
       "NVL(SUM(NVL(B.FORECAST_INFO_CELL_PACK_COUNT,0)),0) AS PACK_SUM")

CASES = [
    ("A 원본 무힌트(배포 전 거동)",
     SEL.replace("SELECT", "SELECT /*+ NO_MERGE */", 1).replace("/*+ NO_MERGE */", "") +
     BODY.format(SRC="SCM_MGR.DM_MST_ITEM_SINGLE_V", V=VER)),
    ("B TUNE-T ① (NO_PUSH_PRED+USE_HASH)",
     SEL.replace("SELECT", "SELECT /*+ NO_PUSH_PRED(B) USE_HASH(B) */", 1) +
     BODY.format(SRC="SCM_MGR.DM_MST_ITEM_SINGLE_V", V=VER)),
    ("C WITH MATERIALIZE (선계산 후 JOIN)",
     "WITH ISV AS (SELECT /*+ MATERIALIZE */ DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, "
     "FORECAST_INFO_CELL_PACK_COUNT FROM SCM_MGR.DM_MST_ITEM_SINGLE_V) " +
     SEL + BODY.format(SRC="ISV", V=VER)),
]


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.callTimeout = 900000  # 15분 상한 — A안이 폭주하면 잘라낸다
        results = {}
        for label, sql in CASES:
            print("\n### %s" % label)
            t0 = time.time()
            try:
                cur.execute(sql)
                row = cur.fetchone()
                el = time.time() - t0
                results[label] = row
                print("   결과 %s   —  %.1f초" % (row, el))
            except Exception as e:
                el = time.time() - t0
                print("   중단(%.1f초): %s" % (el, str(e)[:120]))
        print("\n=== 행집합 동일성 대조 ===")
        vals = list(results.values())
        if len(vals) > 1:
            same = all(v == vals[0] for v in vals)
            for k, v in results.items():
                print("  %-40s %s" % (k, v))
            print("  → 전부 동일: %s" % ("YES ✅" if same else "NO ⛔"))


if __name__ == "__main__":
    main()
