#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_blocker.py — 대기 중인 선행 배포 세션의 정체 확인 (읽기 전용)"""
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
        print("=== 대기 중 DDL 세션의 SQL 전문(앞 600자) ===")
        cur.execute("""SELECT SQL_ID, SUBSTR(SQL_FULLTEXT,1,600) FROM V$SQL
                        WHERE SQL_ID IN ('1m2zwcj75m00y','b44s5uq9z9vb4','3w4054wd4krqg','gvst5r18ds1yz')""")
        for r in cur.fetchall():
            print("\n-- %s --\n%s" % (r[0], r[1]))

        print("\n=== DESCNULL 마커가 대기 배포본에 있는가 (SQL 전문 내 검색) ===")
        cur.execute("""SELECT SQL_ID,
                              CASE WHEN INSTR(SQL_FULLTEXT,'DESCNULL 2026-08-10')>0 THEN 'YES' ELSE 'no' END,
                              CASE WHEN INSTR(SQL_FULLTEXT,'TUNE-T 2026-08-10')>0 THEN 'YES' ELSE 'no' END,
                              LENGTH(SQL_FULLTEXT)
                         FROM V$SQL WHERE SQL_ID='1m2zwcj75m00y'""")
        for r in cur.fetchall():
            print("  %s  DESCNULL=%s  TUNE-T=%s  len=%s" % r)

        print("\n=== 최근 1h PKG_DMF0044 호출 빈도 (어떤 화면 동작이 계속 도는지) ===")
        cur.execute("""SELECT s.PROGRAM_LINE# AS SRC_LINE, s.SQL_ID, s.EXECUTIONS,
                              ROUND(s.ELAPSED_TIME/1e6,1) AS ELAPSED_S,
                              TO_CHAR(s.FIRST_LOAD_TIME) AS LOADED,
                              TO_CHAR(s.LAST_ACTIVE_TIME,'HH24:MI:SS') AS LAST_ACT
                         FROM V$SQL s JOIN ALL_OBJECTS o ON o.OBJECT_ID=s.PROGRAM_ID
                        WHERE o.OWNER='SCM_MGR' AND o.OBJECT_NAME='PKG_DMF0044'
                          AND s.LAST_ACTIVE_TIME > SYSDATE - 1/24
                        ORDER BY s.ELAPSED_TIME DESC FETCH FIRST 12 ROWS ONLY""")
        for r in cur.fetchall():
            print("  ", r)


if __name__ == "__main__":
    main()
