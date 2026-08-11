#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_fncost2.py — 잔여 실측 (읽기 전용): FBI 식 / FN_SCM_SPLIT / COUNTRY 함수비용 / 진행중 Transfer"""
import pathlib
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass


def t(cur, label, sql):
    t0 = time.time()
    cur.execute(sql)
    r = cur.fetchall()
    el = time.time() - t0
    print("  %-56s %-24s %7.2f초" % (label, str(r[0] if len(r) == 1 else len(r))[:24], el))
    return el


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        print("=== [2순위] SCM_MST_SSO_USER_INFO 함수기반인덱스 식 ===")
        cur.execute("""SELECT INDEX_NAME, COLUMN_EXPRESSION FROM ALL_IND_EXPRESSIONS
                        WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_SSO_USER_INFO'""")
        for r in cur.fetchall():
            print("  %-38s %s" % r)

        print("\n=== [1순위] FN_SCM_SPLIT 원본 (SQL 포함 여부 판정) ===")
        cur.execute("""SELECT RTRIM(TEXT) FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
                        AND NAME='FN_SCM_SPLIT' ORDER BY LINE""")
        body = [r[0] for r in cur.fetchall()]
        print("\n".join(l for l in body if l.strip()))
        joined = " ".join(body).upper()
        print("  → 본문 내 SELECT 포함 = %s" % ("YES(테이블 접근)" if "SELECT" in joined else "NO(순수 문자열 계산)"))

        print("\n=== [1순위] FN_GET_COUNTRY_KR_NAME 실호출 비용 (ETC 대상버전 규모) ===")
        t(cur, "ETC 대상버전 행마다 호출 (10,650행 규모)",
          """SELECT COUNT(SCM_MGR.FN_GET_COUNTRY_KR_NAME(COUNTRY_CODE))
               FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C
              WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260128_V002_C'""")
        t(cur, "  (비교) 함수 없이 같은 행 스캔",
          """SELECT COUNT(COUNTRY_CODE) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C
              WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260128_V002_C'""")
        t(cur, "  COUNTRY_CODE NULL 건수",
          """SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C
              WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260128_V002_C' AND COUNTRY_CODE IS NULL""")

        print("\n=== 진행 중/직후 Transfer 문장 실측 (배포 후) ===")
        cur.execute("""SELECT s.PROGRAM_LINE#, s.SQL_ID, s.EXECUTIONS,
                              ROUND(s.ELAPSED_TIME/1e6,1),
                              ROUND(s.ELAPSED_TIME/1e6/GREATEST(s.EXECUTIONS,1),2),
                              s.BUFFER_GETS, s.ROWS_PROCESSED,
                              TO_CHAR(s.LAST_ACTIVE_TIME,'HH24:MI:SS')
                         FROM V$SQL s JOIN ALL_OBJECTS o ON o.OBJECT_ID=s.PROGRAM_ID
                        WHERE o.OWNER='SCM_MGR' AND o.OBJECT_NAME='PKG_DMF0044'
                          AND s.LAST_ACTIVE_TIME > SYSDATE - 30/1440
                        ORDER BY s.ELAPSED_TIME DESC FETCH FIRST 12 ROWS ONLY""")
        print("  SRC_LINE | SQL_ID        | EXEC | ELAPSED_S | PER_EXEC | BUFFER_GETS | ROWS | LAST")
        for r in cur.fetchall():
            print("  %8s | %-13s | %4s | %9s | %8s | %11s | %8s | %s" % r)

        print("\n=== VIEW PUSHED PREDICATE 잔존 (배포 후 30분) ===")
        cur.execute("""SELECT DISTINCT s.SQL_ID, s.PROGRAM_LINE#, p.OBJECT_NAME
                         FROM V$SQL_PLAN p JOIN V$SQL s
                           ON s.SQL_ID=p.SQL_ID AND s.CHILD_NUMBER=p.CHILD_NUMBER
                         JOIN ALL_OBJECTS o ON o.OBJECT_ID=s.PROGRAM_ID
                        WHERE o.OWNER='SCM_MGR' AND o.OBJECT_NAME='PKG_DMF0044'
                          AND p.OPTIONS='PUSHED PREDICATE'
                          AND s.LAST_ACTIVE_TIME > SYSDATE - 30/1440""")
        rows = cur.fetchall()
        print("  없음 ✅" if not rows else "\n".join("  %s" % (r,) for r in rows))

        print("\n=== 현재 ACTIVE 세션 ===")
        cur.execute("""SELECT SID, SUBSTR(PROGRAM,1,22), SUBSTR(EVENT,1,30), SECONDS_IN_WAIT, SQL_ID
                         FROM V$SESSION WHERE TYPE='USER' AND STATUS='ACTIVE' ORDER BY SID""")
        for r in cur.fetchall():
            print("  ", r)


if __name__ == "__main__":
    main()
