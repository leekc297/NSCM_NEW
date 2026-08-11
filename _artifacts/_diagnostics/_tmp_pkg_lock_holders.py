# -*- coding: utf-8 -*-
"""PKG_DMF0044 를 점유 중인 세션 실측 — KILL 후보 제시 (읽기 전용)"""
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

print("== 1) PKG_DMF0044 실행 중 세션 (V$ACCESS) ==")
cur.execute("""
SELECT s.SID, s.SERIAL#, s.USERNAME, s.PROGRAM, s.STATUS,
       s.LAST_CALL_ET, s.SQL_ID, s.EVENT
  FROM V$ACCESS a JOIN V$SESSION s ON s.SID = a.SID
 WHERE a.OWNER='SCM_MGR' AND a.OBJECT='PKG_DMF0044'
 ORDER BY s.LAST_CALL_ET DESC""")
rows = cur.fetchall()
if not rows:
    print("  (없음 — 잠금 해제됨)")
for r in rows:
    print("  SID=%s,%s  %s  %s  %s  경과=%ss  sql=%s  ev=%s"
          % (r[0], r[1], r[2], (r[3] or "")[:26], r[4], r[5], r[6], (r[7] or "")[:40]))

print("\n== 2) library cache pin/lock 보유자 (V$DB_OBJECT_CACHE 경유) ==")
cur.execute("""
SELECT s.SID, s.SERIAL#, s.PROGRAM, s.STATUS, s.LAST_CALL_ET, s.MODULE
  FROM V$SESSION s
 WHERE s.USERNAME='SCM_MGR' AND s.STATUS='ACTIVE'
   AND s.SID <> SYS_CONTEXT('USERENV','SID')
 ORDER BY s.LAST_CALL_ET DESC""")
for r in cur.fetchall():
    print("  SID=%s,%s  %s  %s  경과=%ss  mod=%s"
          % (r[0], r[1], (r[2] or "")[:26], r[3], r[4], (r[5] or "")[:30]))

print("\n== 3) KILL 문 ==")
cur.execute("""
SELECT DISTINCT 'ALTER SYSTEM KILL SESSION ''' || s.SID || ',' || s.SERIAL# || ''' IMMEDIATE;'
  FROM V$ACCESS a JOIN V$SESSION s ON s.SID = a.SID
 WHERE a.OWNER='SCM_MGR' AND a.OBJECT='PKG_DMF0044'
   AND s.SID <> SYS_CONTEXT('USERENV','SID')""")
for r in cur.fetchall():
    print("  " + r[0])
con.close()
