#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_isv.py — ISV CTE 실제 산출 비용 (읽기 전용)

⚠ 앞선 0.94초 측정은 `SELECT COUNT(*) FROM DM_MST_ITEM_SINGLE_V` 였다.
   COUNT(*) 는 T2(상관 서브쿼리) 컬럼을 **컬럼 프루닝으로 제거**하므로 비싼 부분이 빠진다.
   여기서는 실제로 쓰는 컬럼을 투영해 정직하게 잰다.
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

CASES = [
    ("COUNT(*) 만 (앞서 쓴 잘못된 척도)",
     "SELECT COUNT(*) FROM SCM_MGR.DM_MST_ITEM_SINGLE_V"),
    ("실제 투영 · 필터 없음 (현재 배포된 ISV)",
     """SELECT COUNT(*) FROM (SELECT DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE,
              FORECAST_INFO_CELL_PACK_COUNT FROM SCM_MGR.DM_MST_ITEM_SINGLE_V)"""),
    ("실제 투영 · DIVISION_ID='40' 사전필터 (제안)",
     """SELECT COUNT(*) FROM (SELECT DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE,
              FORECAST_INFO_CELL_PACK_COUNT FROM SCM_MGR.DM_MST_ITEM_SINGLE_V
              WHERE DIVISION_ID = '40')"""),
]


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.callTimeout = 900000
        for label, sql in CASES:
            t0 = time.time()
            try:
                cur.execute(sql)
                n = cur.fetchone()[0]
                print("  %-46s = %-9s %8.1f초" % (label, n, time.time() - t0), flush=True)
            except Exception as e:
                print("  %-46s 중단(%.1f초) %s" % (label, time.time() - t0, str(e)[:80]), flush=True)

        print("\n  -- 사전필터 결과 동일성: 조인 키가 DIVISION_ID 포함이므로 타 division 행은 조인 불가 --")
        cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        WHERE VERSION_NO='R_S_20260128_V002_C' AND DIVISION_ID <> '40'""")
        print("  대상 버전 중 DIVISION_ID<>'40' 행수 = %s (0 이면 사전필터 무해)" % cur.fetchone()[0])
        cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C
                        WHERE VERSION_NO='R_S_20260128_V002_C' AND DIVISION_ID <> '40'""")
        print("  ETC 동일 = %s" % cur.fetchone()[0])


if __name__ == "__main__":
    main()
