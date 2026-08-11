#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_optenv.py — BE(JDBC) 세션 vs 내 세션 옵티마이저 환경 차이 (읽기 전용)

같은 SQL 이 내 세션에선 0.3~0.7초, SP 안에선 600초+ 인 이유를 가른다.
V$SES_OPTIMIZER_ENV 로 두 세션의 옵티마이저 파라미터를 전수 대조한다.
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        cur.execute("""SELECT SID FROM V$SESSION
                        WHERE TYPE='USER' AND PROGRAM LIKE 'JDBC%' AND STATUS='ACTIVE'
                        ORDER BY LOGON_TIME DESC FETCH FIRST 1 ROWS ONLY""")
        r = cur.fetchone()
        if not r:
            print("(활성 JDBC 세션 없음 — 대조 불가)")
            return
        jdbc = r[0]
        cur.execute("SELECT SYS_CONTEXT('USERENV','SID') FROM DUAL")
        mine = int(cur.fetchone()[0])
        print("JDBC SID=%s  /  내 SID=%s\n" % (jdbc, mine))

        print("=== 옵티마이저 파라미터 차이 (기본값과 다른 항목 전수) ===")
        cur.execute("""SELECT NAME,
                              MAX(CASE WHEN SID=:j THEN VALUE END) AS JDBC_VAL,
                              MAX(CASE WHEN SID=:m THEN VALUE END) AS MY_VAL
                         FROM V$SES_OPTIMIZER_ENV WHERE SID IN (:j,:m)
                        GROUP BY NAME
                       HAVING MAX(CASE WHEN SID=:j THEN VALUE END)
                              <> MAX(CASE WHEN SID=:m THEN VALUE END)
                        ORDER BY NAME""", {"j": jdbc, "m": mine})
        rows = cur.fetchall()
        if not rows:
            print("  차이 없음")
        for r in rows:
            print("  %-42s JDBC=%-16s 내=%s" % r)

        print("\n=== 핵심 파라미터 값 (양 세션) ===")
        cur.execute("""SELECT SID, NAME, VALUE FROM V$SES_OPTIMIZER_ENV
                        WHERE SID IN (:j,:m)
                          AND NAME IN ('optimizer_dynamic_sampling','optimizer_adaptive_plans',
                                       'optimizer_index_cost_adj','optimizer_mode',
                                       'optimizer_features_enable','_optimizer_adaptive_statistics',
                                       '_optimizer_push_pred_cost_based','_push_join_predicate',
                                       'star_transformation_enabled','parallel_degree_policy',
                                       'hash_area_size','_optimizer_use_feedback')
                        ORDER BY NAME, SID""", {"j": jdbc, "m": mine})
        for r in cur.fetchall():
            print("  SID %-5s %-40s %s" % r)

        print("\n=== 인스턴스 기본값 ===")
        cur.execute("""SELECT NAME, VALUE, ISDEFAULT FROM V$PARAMETER
                        WHERE NAME IN ('optimizer_dynamic_sampling','optimizer_adaptive_plans',
                                       'optimizer_index_cost_adj','optimizer_mode','optimizer_features_enable')
                        ORDER BY NAME""")
        for r in cur.fetchall():
            print("  %-34s %-14s default=%s" % r)


if __name__ == "__main__":
    main()
