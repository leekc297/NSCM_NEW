#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_final.py — 최종 상태 스냅샷 (읽기 전용)"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

VER = "R_S_20260128_V002_C"


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        print("=== 진행 중 Transfer 문장 현재 누적 ===")
        cur.execute("""SELECT SQL_ID, PROGRAM_LINE#, EXECUTIONS,
                              ROUND(ELAPSED_TIME/1e6,1) AS ELAPSED_S, BUFFER_GETS, ROWS_PROCESSED
                         FROM V$SQL WHERE SQL_ID IN ('6dgspsw017ksa','761qq1a2shbyp','fndp8c35xn8y5')""")
        for r in cur.fetchall():
            print("  ", r)

        print("\n=== SQL Monitor 진행률 (6dgspsw017ksa) ===")
        cur.execute("""SELECT STATUS, ROUND((SYSDATE-SQL_EXEC_START)*86400) AS RUN_S,
                              ELAPSED_TIME/1e6, BUFFER_GETS, DISK_READS
                         FROM V$SQL_MONITOR WHERE SQL_ID='6dgspsw017ksa'
                        ORDER BY SQL_EXEC_START DESC FETCH FIRST 3 ROWS ONLY""")
        for r in cur.fetchall():
            print("  ", r)

        print("\n=== 원장 현재 상태 (%s) — 트랜잭션 미커밋이라 타 세션에는 변화 없어야 정상 ===" % VER)
        for lbl, sql in [
            ("DM_MDF_VERSION.SEND_YN",
             "SELECT MAX(SEND_YN) FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID='40' AND VERSION_NO=:v"),
            ("PLAN_REPORT_C DATA_TYPE=2",
             "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID='40' AND VERSION_NO=:v AND DATA_TYPE='2'"),
            ("PLAN_REPORT_C 전체",
             "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID='40' AND VERSION_NO=:v"),
            ("DM_MOBILE_REPORT_PRODUCT",
             "SELECT COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT WHERE DIVISION_ID='40' AND VERSION_NO=:v"),
            ("DM_MOBILE_REPORT_DEPT",
             "SELECT COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_DEPT WHERE DIVISION_ID='40' AND VERSION_NO=:v"),
        ]:
            cur.execute(sql, {"v": VER})
            print("  %-28s %s" % (lbl, cur.fetchone()[0]))

        print("\n=== 세션 ===")
        cur.execute("""SELECT SID, SUBSTR(PROGRAM,1,24), SUBSTR(EVENT,1,30), SECONDS_IN_WAIT, SQL_ID, BLOCKING_SESSION
                         FROM V$SESSION WHERE TYPE='USER' AND STATUS='ACTIVE'""")
        for r in cur.fetchall():
            print("  ", r)


if __name__ == "__main__":
    main()
