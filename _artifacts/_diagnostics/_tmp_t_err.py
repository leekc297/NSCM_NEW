#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_err.py — Transfer 실패 원인 추적 (읽기 전용): SP 로그 테이블 + 커서 상태"""
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

        print("=== 로그 테이블 후보 ===")
        cur.execute("""SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
                        AND (TABLE_NAME LIKE '%SYS_LOG%' OR TABLE_NAME LIKE '%_LOG')
                        ORDER BY 1""")
        tabs = [r[0] for r in cur.fetchall()]
        print(" ", tabs)

        for t in tabs:
            try:
                cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS
                                WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t ORDER BY COLUMN_ID""", {"t": t})
                cols = [r[0] for r in cur.fetchall()]
                datecol = next((c for c in cols if "EVENT_DATE" in c or "CREATION_DATE" in c), None)
                if not datecol:
                    continue
                cur.execute("""SELECT * FROM (SELECT * FROM SCM_MGR.%s
                                 WHERE %s > SYSDATE - 3/24 ORDER BY %s DESC) WHERE ROWNUM <= 12"""
                            % (t, datecol, datecol))
                rows = cur.fetchall()
                if not rows:
                    continue
                names = [c[0] for c in cur.description]
                print("\n----- %s (최근 3시간 %d행) -----" % (t, len(rows)))
                for r in rows:
                    rec = {n: v for n, v in zip(names, r) if v is not None}
                    keep = {k: str(v)[:300] for k, v in rec.items()
                            if k in ("PROGRAM_NAME", "LOG_TYPE", "LOG_MESSAGE", "DESCRIPTION",
                                     "EVENT_DATE", "CREATION_DATE", "SQL_CODE", "SQL_ERRMSG",
                                     "BACKTRACE", "PROC_INPUT")}
                    print("  ", keep)
            except Exception as e:
                print("  (%s 조회 실패: %s)" % (t, str(e)[:80]))

        print("\n=== 커서 6dgspsw017ksa 상태 ===")
        cur.execute("""SELECT SQL_ID, CHILD_NUMBER, PLAN_HASH_VALUE, EXECUTIONS, ROWS_PROCESSED,
                              ROUND(ELAPSED_TIME/1e6,1), BUFFER_GETS, DISK_READS,
                              ROUND(USER_IO_WAIT_TIME/1e6,1) AS IO_S,
                              ROUND(APPLICATION_WAIT_TIME/1e6,1) AS APP_S,
                              ROUND(CONCURRENCY_WAIT_TIME/1e6,1) AS CC_S
                         FROM V$SQL WHERE SQL_ID='6dgspsw017ksa'""")
        for r in cur.fetchall():
            print("  ", r)

        print("\n=== SQL Monitor 종료 상태 ===")
        cur.execute("""SELECT SQL_ID, STATUS, ERROR_NUMBER, ERROR_MESSAGE,
                              ROUND(ELAPSED_TIME/1e6,1), ROUND(QUEUING_TIME/1e6,1)
                         FROM V$SQL_MONITOR WHERE SQL_ID IN ('6dgspsw017ksa','fndp8c35xn8y5')
                        ORDER BY SQL_EXEC_START DESC FETCH FIRST 8 ROWS ONLY""")
        for r in cur.fetchall():
            print("  ", r)

        print("\n=== TEMP 사용 (ORA-01652 여부 단서) ===")
        cur.execute("""SELECT TABLESPACE_NAME, ROUND(BYTES_USED/1024/1024) MB_USED,
                              ROUND(BYTES_FREE/1024/1024) MB_FREE FROM V$TEMP_SPACE_HEADER""")
        for r in cur.fetchall():
            print("  ", r)


if __name__ == "__main__":
    main()
