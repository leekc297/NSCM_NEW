#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_now.py — 현재 실행 중/직후 문장 식별 (읽기 전용)"""
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
        print("=== 최근 20분 PKG_DMF0044 귀속 문장 ===")
        cur.execute("""SELECT s.PROGRAM_LINE#, s.SQL_ID, s.EXECUTIONS,
                              ROUND(s.ELAPSED_TIME/1e6,1),
                              ROUND(s.ELAPSED_TIME/1e6/GREATEST(s.EXECUTIONS,1),2),
                              s.BUFFER_GETS, s.ROWS_PROCESSED,
                              TO_CHAR(s.LAST_ACTIVE_TIME,'HH24:MI:SS'),
                              SUBSTR(s.SQL_TEXT,1,60)
                         FROM V$SQL s JOIN ALL_OBJECTS o ON o.OBJECT_ID=s.PROGRAM_ID
                        WHERE o.OWNER='SCM_MGR' AND o.OBJECT_NAME='PKG_DMF0044'
                          AND s.LAST_ACTIVE_TIME > SYSDATE - 20/1440
                        ORDER BY s.ELAPSED_TIME DESC FETCH FIRST 12 ROWS ONLY""")
        print("  LINE | SQL_ID | EXEC | ELAPSED | /회 | BGETS | ROWS | LAST | TEXT")
        for r in cur.fetchall():
            print("  %s | %s | %s | %s | %s | %s | %s | %s | %s" % r)

        print("\n=== 현재 실행 중 SQL 전문 ===")
        cur.execute("""SELECT s.SID, q.SQL_ID, SUBSTR(q.SQL_FULLTEXT,1,300)
                         FROM V$SESSION s JOIN V$SQL q ON q.SQL_ID=s.SQL_ID
                        WHERE s.TYPE='USER' AND s.STATUS='ACTIVE' AND s.PROGRAM LIKE 'JDBC%'""")
        for r in cur.fetchall():
            print("  SID %s / %s\n    %s" % r)

        print("\n=== SQL Monitor 실행 중 ===")
        cur.execute("""SELECT SQL_ID, STATUS, ROUND(ELAPSED_TIME/1e6,1),
                              ROUND((SYSDATE-SQL_EXEC_START)*86400) AS RUN_S, BUFFER_GETS
                         FROM V$SQL_MONITOR WHERE STATUS='EXECUTING'
                        ORDER BY SQL_EXEC_START DESC FETCH FIRST 6 ROWS ONLY""")
        for r in cur.fetchall():
            print("  ", r)


if __name__ == "__main__":
    main()
