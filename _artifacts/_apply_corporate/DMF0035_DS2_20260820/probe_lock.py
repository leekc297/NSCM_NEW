# -*- coding: utf-8 -*-
"""97_REDEPLOY_LOCKED.sql 의 R1/R2 쿼리 문법·동작 사내 검증 (읽기 전용)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

R1 = """
SELECT S.SID, S.SERIAL#, S.USERNAME, S.STATUS, S.LAST_CALL_ET RUNNING_SEC,
       S.EVENT, S.SQL_ID, O.OBJECT_NAME AS PLSQL_ENTRY
  FROM V$SESSION S
  LEFT JOIN ALL_OBJECTS O ON O.OBJECT_ID = S.PLSQL_ENTRY_OBJECT_ID
 WHERE S.USERNAME IS NOT NULL
   AND ( O.OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')
      OR S.SID IN (SELECT SID FROM V$ACCESS
                    WHERE OWNER='SCM_MGR'
                      AND OBJECT IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')) )
 ORDER BY S.LAST_CALL_ET DESC
"""
R2 = """
SELECT 'ALTER SYSTEM KILL SESSION ''' || S.SID || ',' || S.SERIAL# || ''' IMMEDIATE;' AS KILL_STMT
  FROM V$SESSION S
  LEFT JOIN ALL_OBJECTS O ON O.OBJECT_ID = S.PLSQL_ENTRY_OBJECT_ID
 WHERE S.USERNAME IS NOT NULL
   AND O.OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')
"""
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
for name, sql in (("R1", R1), ("R2", R2)):
    try:
        cur.execute(sql)
        rows = cur.fetchall()
        print(f"[{name}] 실행 OK — {len(rows)}행")
        for r in rows[:5]:
            print("   ", r)
    except Exception as e:
        print(f"[{name}] ⛔ {str(e)[:120]}")
con.close()
