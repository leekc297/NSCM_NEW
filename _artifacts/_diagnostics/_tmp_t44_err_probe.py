#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Transfer SQL ERROR 원인 추적 — SP 로그 테이블 최근 ERROR + 최근 실패 SQL"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 180000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[0] 로그 테이블 후보")
show(*fetch(cur, """SELECT owner, table_name FROM all_tables
                     WHERE table_name LIKE '%SYS_LOG%' AND owner IN ('SCM_MGR')
                     ORDER BY table_name"""))

for tbl in ('SCM_SYS_LOG', 'DM_SYS_LOG'):
    try:
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{tbl}")
        sec(f"[1] {tbl} — 최근 30분 DMF0044 로그")
        show(*fetch(cur, f"""
            SELECT * FROM (
              SELECT TO_CHAR(EVENT_DATE,'HH24:MI:SS') t, PROGRAM_NAME, LOG_TYPE,
                     SUBSTR(LOG_MESSAGE,1,200) msg, SUBSTR(DESCRIPTION,1,150) descr
                FROM SCM_MGR.{tbl}
               WHERE EVENT_DATE > SYSDATE - 30/1440
                 AND (UPPER(PROGRAM_NAME) LIKE '%DMF0044%' OR UPPER(LOG_TYPE)='ERROR')
               ORDER BY EVENT_DATE DESC )
             WHERE ROWNUM <= 25"""))
    except Exception as e:
        print(f"  ({tbl}: {str(e)[:100]})")

sec("[2] 로그 테이블 컬럼 (구조 확인 — 위 조회가 실패했을 때용)")
show(*fetch(cur, """SELECT table_name, column_name, data_type FROM all_tab_columns
                     WHERE owner='SCM_MGR' AND table_name IN ('SCM_SYS_LOG','DM_SYS_LOG')
                     ORDER BY table_name, column_id"""))

sec("[3] 최근 수행된 DMF0044 관련 SQL (오류 여부 무관)")
show(*fetch(cur, """
SELECT sql_id, plan_hash_value, executions, ROUND(elapsed_time/1e6,2) el, rows_processed,
       TO_CHAR(last_active_time,'HH24:MI:SS') last_active,
       SUBSTR(REPLACE(sql_text,CHR(10),' '),1,90) head
  FROM v$sql
 WHERE last_active_time > SYSDATE - 30/1440
   AND (UPPER(sql_text) LIKE '%MOBILE_REPORT%' OR UPPER(sql_text) LIKE '%GT_DMF0044%'
        OR UPPER(sql_text) LIKE '%DMF0044%')
 ORDER BY last_active_time DESC FETCH FIRST 25 ROWS ONLY"""))

sec("[4] PKG_DMF0044 상태 재확인")
show(*fetch(cur, """SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') ddl
                      FROM all_objects WHERE owner='SCM_MGR' AND object_name='PKG_DMF0044'"""))
show(*fetch(cur, """SELECT line, position, text FROM all_errors
                      WHERE owner='SCM_MGR' AND name='PKG_DMF0044' ORDER BY sequence"""))

con.close()
