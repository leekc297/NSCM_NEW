# -*- coding: utf-8 -*-
"""KILL 후보 목록 — 실행 중 JDBC(BE) 세션 + 무엇을 돌리는지"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("== ACTIVE JDBC(BE) 세션 = KILL 후보 ==")
cur.execute("""SELECT S.SID, S.SERIAL#, ROUND(S.LAST_CALL_ET/60,1), S.EVENT, S.SQL_ID,
                      TO_CHAR(S.LOGON_TIME,'HH24:MI:SS'), NVL(S.BLOCKING_SESSION,-1)
                 FROM V$SESSION S
                WHERE S.PROGRAM LIKE 'JDBC%' AND S.STATUS='ACTIVE'
                ORDER BY S.LAST_CALL_ET DESC""")
rows = cur.fetchall()
if not rows:
    print("  (없음 — 실행 중 BE 세션 0)")
for sid, ser, mins, ev, sqlid, logon, blk in rows:
    print("  ALTER SYSTEM KILL SESSION '%s,%s' IMMEDIATE;   -- %.1f분  %s  logon=%s blocked_by=%s"
          % (sid, ser, mins, ev, logon, blk if blk != -1 else "-"))
    if sqlid:
        cur.execute("SELECT SUBSTR(SQL_TEXT,1,150) FROM V$SQL WHERE SQL_ID=:s AND ROWNUM<=1", {"s": sqlid})
        r = cur.fetchone()
        print("      sql_id=%s  %s" % (sqlid, (r[0] if r else "(텍스트 없음)")))

print("\n== 대기 중(잠금 대기 포함) 세션 ==")
cur.execute("""SELECT S.SID, S.SERIAL#, S.PROGRAM, S.EVENT, ROUND(S.SECONDS_IN_WAIT)
                 FROM V$SESSION S
                WHERE S.USERNAME IS NOT NULL AND S.EVENT LIKE '%library cache%'
                ORDER BY S.SECONDS_IN_WAIT DESC""")
rows2 = cur.fetchall()
if not rows2:
    print("  (없음)")
for r in rows2:
    print("  SID=%s SERIAL#=%s %s  %s  %ss" % r)
con.close()
