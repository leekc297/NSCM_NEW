#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_bind.py — 리터럴 vs 바인드 변수 차이 실측 (읽기 전용)

내 세션 0.3초 / SP 안 600초+ 의 원인 후보 마지막: 바인드 변수.
옵티마이저 환경은 동일함을 이미 확인했다(V$SES_OPTIMIZER_ENV 차이 0).
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

BASE = """SELECT COUNT(*) FROM (
    SELECT /*+ MATERIALIZE */ DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
      FROM SCM_MGR.DM_MST_ITEM_SINGLE_V
     WHERE DIVISION_ID = %s )"""


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.callTimeout = 300000  # 5분 상한

        for label, sql, binds in [
            ("리터럴 '40'", BASE % "'40'", None),
            ("바인드 :d", BASE % ":d", {"d": "40"}),
        ]:
            t0 = time.time()
            try:
                cur.execute(sql, binds or {})
                n = cur.fetchone()[0]
                print("  %-16s = %-9s %8.1f초" % (label, n, time.time() - t0), flush=True)
            except Exception as e:
                print("  %-16s 중단(%.1f초) %s" % (label, time.time() - t0, str(e)[:90]), flush=True)

        print("\n=== 위 두 커서의 플랜 요약 ===")
        cur.execute("""SELECT s.SQL_ID, s.IS_BIND_SENSITIVE, s.PLAN_HASH_VALUE,
                              ROUND(s.ELAPSED_TIME/1e6,1), s.BUFFER_GETS
                         FROM V$SQL s
                        WHERE s.SQL_TEXT LIKE '%DM_MST_ITEM_SINGLE_V%'
                          AND s.SQL_TEXT LIKE '%MATERIALIZE%'
                          AND s.PARSING_SCHEMA_NAME='SCM_MGR'
                        ORDER BY s.LAST_ACTIVE_TIME DESC FETCH FIRST 4 ROWS ONLY""")
        for r in cur.fetchall():
            print("  ", r)
            cur2 = con.cursor()
            cur2.execute("""SELECT ID, LPAD(' ',DEPTH)||OPERATION||' '||NVL(OPTIONS,''), OBJECT_NAME, CARDINALITY
                              FROM V$SQL_PLAN WHERE SQL_ID=:s AND CHILD_NUMBER=0 ORDER BY ID""", {"s": r[0]})
            for p2 in cur2.fetchall():
                print("      %s" % (p2,))


if __name__ == "__main__":
    main()
