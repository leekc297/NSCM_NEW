#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_equiv2.py — (a) 의미 동일성 MINUS 양방향 증명 (읽기 전용)

치환안 = DM_MST_ITEM_SINGLE_V 의 **자기 정의를 그대로 인라인** + DIVISION 사전필터.
뷰 정의(실측):
    FROM SCM_MST_ITEM_SN T1
       , ( SELECT DIVISION_ID, SUBSTR(ITEM_ID,1,12) AS ITEM_ID
                , MAX(FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
                , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                , ...
             FROM SCM_MST_ITEM_SN T2
            GROUP BY DIVISION_ID, SUBSTR(ITEM_ID,1,12) ) T2
     WHERE T1.DIVISION_ID = T2.DIVISION_ID AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
     GROUP BY T1.DIVISION_ID, T1.ITEM_ID

⇒ L1280 손수 작성본(ITEM_A/ITEM_B)과 같은 구조다. 다만 GTT 는 CELL_PACK_COUNT 를
   저장하지 않을 뿐이고, T2 는 이미 그 값을 계산한다 ⇒ 두 컬럼 모두 확장 가능.
사전필터(DIVISION_ID)는 조인이 DIVISION_ID 등가라 양변에 안전하게 내릴 수 있다.
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

DIV = sys.argv[1] if len(sys.argv) > 1 else "40"

NEW_CTE = """
    SELECT T1.DIVISION_ID, T1.ITEM_ID
         , MAX(T2.FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
         , MAX(T2.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
      FROM SCM_MGR.SCM_MST_ITEM_SN T1
      JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
                  , MAX(FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
                  , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
               FROM SCM_MGR.SCM_MST_ITEM_SN
              WHERE DIVISION_ID = '{D}'
              GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) ) T2
        ON T1.DIVISION_ID = T2.DIVISION_ID
       AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
     WHERE T1.DIVISION_ID = '{D}'
     GROUP BY T1.DIVISION_ID, T1.ITEM_ID
"""

OLD_VIEW = """
    SELECT DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
      FROM SCM_MGR.DM_MST_ITEM_SINGLE_V
     WHERE DIVISION_ID = '{D}'
"""


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.callTimeout = 900000
        new = NEW_CTE.format(D=DIV)
        old = OLD_VIEW.format(D=DIV)

        print("=== division %s ===" % DIV)

        t0 = time.time()
        cur.execute("SELECT COUNT(*) FROM (%s)" % old)
        n_old = cur.fetchone()[0]
        el_old = time.time() - t0
        print("  뷰(DM_MST_ITEM_SINGLE_V) 행수 = %-8s %6.2f초" % (n_old, el_old))

        t0 = time.time()
        cur.execute("SELECT COUNT(*) FROM (%s)" % new)
        n_new = cur.fetchone()[0]
        el_new = time.time() - t0
        print("  치환안(인라인) 행수         = %-8s %6.2f초" % (n_new, el_new))

        print("\n=== MINUS 양방향 (키 + 사용 컬럼 2종 전부) ===")
        t0 = time.time()
        cur.execute("""SELECT
              (SELECT COUNT(*) FROM ( (%s) MINUS (%s) )) AS VIEW_MINUS_NEW,
              (SELECT COUNT(*) FROM ( (%s) MINUS (%s) )) AS NEW_MINUS_VIEW
            FROM DUAL""" % (old, new, new, old))
        a, b = cur.fetchone()
        print("  뷰 MINUS 치환안 = %s" % a)
        print("  치환안 MINUS 뷰 = %s" % b)
        print("  (%.1f초)" % (time.time() - t0))

        ok = (n_old == n_new and a == 0 and b == 0)
        print("\n  → 판정: %s" % ("동일 ✅ 치환 가능" if ok else "⛔ 불일치 — 중단"))
        if not ok:
            cur.execute("SELECT * FROM ( (%s) MINUS (%s) ) WHERE ROWNUM<=5" % (old, new))
            print("  뷰에만 있는 샘플:", cur.fetchall())
            cur.execute("SELECT * FROM ( (%s) MINUS (%s) ) WHERE ROWNUM<=5" % (new, old))
            print("  치환안에만 있는 샘플:", cur.fetchall())
        return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
