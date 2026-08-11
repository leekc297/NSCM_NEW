#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_diag.py — PKG_DMF0044 문장별 elapsed 실측 (읽기 전용)

V$SQL.PROGRAM_ID = PKG_DMF0044 BODY object_id / PROGRAM_LINE# = SP 소스 라인.
→ 어느 문장이 몇 초를 먹는지 라인 단위로 귀속.
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass


def rows(cur, sql, binds=None):
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    return cols, cur.fetchall()


def show(title, cols, data, maxw=110):
    print("\n=== %s ===" % title)
    if not data:
        print("  (0 rows)")
        return
    print(" | ".join(cols))
    for r in data:
        print(" | ".join(str("" if v is None else v)[:maxw] for v in r))
    print("(%d rows)" % len(data))


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        show("PKG_DMF0044 object_id", *rows(cur, """
            SELECT OBJECT_ID, OBJECT_TYPE, STATUS, LAST_DDL_TIME
              FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 2"""))

        # 1) PKG_DMF0044 에 귀속되는 모든 커서 — elapsed 내림차순
        show("V$SQL — PKG_DMF0044 귀속 문장 (elapsed desc)", *rows(cur, """
            SELECT s.PROGRAM_LINE# AS SRC_LINE
                 , s.SQL_ID
                 , s.EXECUTIONS AS EXEC
                 , ROUND(s.ELAPSED_TIME/1e6,1)                          AS ELAPSED_S
                 , ROUND(s.ELAPSED_TIME/1e6/GREATEST(s.EXECUTIONS,1),2) AS PER_EXEC_S
                 , s.BUFFER_GETS
                 , s.ROWS_PROCESSED AS ROWS_P
                 , TO_CHAR(s.LAST_ACTIVE_TIME,'MM-DD HH24:MI:SS')       AS LAST_ACT
                 , SUBSTR(s.SQL_TEXT,1,80) AS TXT
              FROM V$SQL s
              JOIN ALL_OBJECTS o ON o.OBJECT_ID = s.PROGRAM_ID
             WHERE o.OWNER='SCM_MGR' AND o.OBJECT_NAME='PKG_DMF0044'
             ORDER BY s.ELAPSED_TIME DESC
             FETCH FIRST 30 ROWS ONLY"""))

        # 2) 최근 24h 안에 실행된 것만 (사용자 신고 시점 특정)
        show("V$SQL — 최근 6h 활성 (PKG_DMF0044)", *rows(cur, """
            SELECT s.PROGRAM_LINE# AS SRC_LINE, s.SQL_ID, s.EXECUTIONS AS EXEC
                 , ROUND(s.ELAPSED_TIME/1e6,1) AS ELAPSED_S
                 , ROUND(s.ELAPSED_TIME/1e6/GREATEST(s.EXECUTIONS,1),2) AS PER_EXEC_S
                 , s.BUFFER_GETS, s.ROWS_PROCESSED AS ROWS_P
                 , TO_CHAR(s.LAST_ACTIVE_TIME,'MM-DD HH24:MI:SS') AS LAST_ACT
                 , SUBSTR(s.SQL_TEXT,1,70) AS TXT
              FROM V$SQL s JOIN ALL_OBJECTS o ON o.OBJECT_ID = s.PROGRAM_ID
             WHERE o.OWNER='SCM_MGR' AND o.OBJECT_NAME='PKG_DMF0044'
               AND s.LAST_ACTIVE_TIME > SYSDATE - 6/24
             ORDER BY s.ELAPSED_TIME DESC
             FETCH FIRST 30 ROWS ONLY"""))

        # 3) 활성 세션 (배포 가능 여부)
        show("V$SESSION — JDBC ACTIVE", *rows(cur, """
            SELECT SID, SERIAL#, STATUS, SUBSTR(PROGRAM,1,30) AS PROGRAM
                 , SUBSTR(EVENT,1,40) AS EVENT, SECONDS_IN_WAIT AS WAIT_S, SQL_ID
              FROM V$SESSION
             WHERE PROGRAM LIKE 'JDBC%' AND STATUS='ACTIVE'"""))

        show("V$SESSION — 전체 ACTIVE(비-백그라운드)", *rows(cur, """
            SELECT SID, SERIAL#, USERNAME, SUBSTR(PROGRAM,1,35) AS PROGRAM, STATUS
                 , SUBSTR(EVENT,1,35) AS EVENT, SECONDS_IN_WAIT AS WAIT_S, SQL_ID
              FROM V$SESSION WHERE TYPE='USER' AND STATUS='ACTIVE'"""))


if __name__ == "__main__":
    main()
