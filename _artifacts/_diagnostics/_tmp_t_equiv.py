#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_equiv.py — (a) 의미 동일성 대조 (읽기 전용)

치환 후보: L1280 `WITH ITEM_A/ITEM_B/ITEM_JOINED` 손수 작성본
원본     : DM_MST_ITEM_SINGLE_V

ISV CTE 가 실제로 쓰는 컬럼은 2개뿐: FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
⇒ 이 2개(+키)가 완전히 같아야 치환 가능. MINUS 양방향 0행으로 증명한다.
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

DIV = "40"

# L1280 손수 작성본과 동일한 구조 (P_DIVISION_ID → 리터럴)
HANDWRITTEN = """
WITH ITEM_A AS (
    SELECT T1.DIVISION_ID, T1.ITEM_ID
      FROM SCM_MGR.SCM_MST_ITEM_SN T1
     WHERE T1.DIVISION_ID = '{D}'
     GROUP BY T1.DIVISION_ID, T1.ITEM_ID
), ITEM_B AS (
    SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
      FROM SCM_MGR.SCM_MST_ITEM_SN
     WHERE DIVISION_ID = '{D}'
     GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
)
SELECT A.DIVISION_ID, A.ITEM_ID, B.FORECAST_INFO_BIZ_TYPE
  FROM ITEM_A A
  INNER JOIN ITEM_B B
    ON A.DIVISION_ID = B.DIVISION_ID AND SUBSTR(A.ITEM_ID, 1, 12) = B.ITEM_ID
""".format(D=DIV)

VIEW_SIDE = """
SELECT DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE
  FROM SCM_MGR.DM_MST_ITEM_SINGLE_V
 WHERE DIVISION_ID = '{D}'
""".format(D=DIV)


def t(cur, label, sql):
    t0 = time.time()
    cur.execute(sql)
    r = cur.fetchone()
    print("  %-56s %-12s %6.1f초" % (label, str(r[0]), time.time() - t0), flush=True)
    return r[0]


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.callTimeout = 600000

        print("=== 0) 뷰 정의 전문 (T2 부분 확인) ===")
        cur.execute("""SELECT TEXT FROM ALL_VIEWS
                        WHERE OWNER='SCM_MGR' AND VIEW_NAME='DM_MST_ITEM_SINGLE_V'""")
        txt = cur.fetchone()[0]
        # FROM 절 이후만 (앞 SELECT 목록은 이미 확인)
        idx = txt.upper().find("FROM SCM_MST_ITEM_SN")
        print(txt[idx:idx + 2200] if idx >= 0 else txt[-2200:])

        print("\n=== 1) FORECAST_INFO_CELL_PACK_COUNT 가 손수작성본에 있는가 ===")
        cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS
                        WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_F044_DM_MST_ITEM_SINGLE_V'
                        ORDER BY COLUMN_ID""")
        cols = [r[0] for r in cur.fetchall()]
        print("  GT_F044_DM_MST_ITEM_SINGLE_V 컬럼 =", cols)
        print("  FORECAST_INFO_CELL_PACK_COUNT 포함? →",
              "YES" if "FORECAST_INFO_CELL_PACK_COUNT" in cols else "**NO — 치환 불가 신호**")

        print("\n=== 2) 행수 대조 (키 집합) ===")
        n_view = t(cur, "뷰 측 행수", "SELECT COUNT(*) FROM (%s)" % VIEW_SIDE)
        n_hand = t(cur, "손수작성본 행수", "SELECT COUNT(*) FROM (%s)" % HANDWRITTEN)

        print("\n=== 3) MINUS 양방향 (DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE) ===")
        a = t(cur, "뷰 MINUS 손수작성본", "SELECT COUNT(*) FROM ((%s) MINUS (%s))" % (VIEW_SIDE, HANDWRITTEN))
        b = t(cur, "손수작성본 MINUS 뷰", "SELECT COUNT(*) FROM ((%s) MINUS (%s))" % (HANDWRITTEN, VIEW_SIDE))

        print("\n=== 판정 ===")
        print("  행수 %s vs %s / MINUS %s·%s" % (n_view, n_hand, a, b))
        ok = (n_view == n_hand and a == 0 and b == 0
              and "FORECAST_INFO_CELL_PACK_COUNT" in cols)
        print("  → 치환 가능: %s" % ("YES ✅" if ok else "NO ⛔ — 중단하고 보고"))

        if a or b:
            print("\n  -- 불일치 샘플 5건 (뷰 측 기준) --")
            cur.execute("SELECT * FROM ((%s) MINUS (%s)) WHERE ROWNUM<=5" % (VIEW_SIDE, HANDWRITTEN))
            for r in cur.fetchall():
                print("   ", r)


if __name__ == "__main__":
    main()
