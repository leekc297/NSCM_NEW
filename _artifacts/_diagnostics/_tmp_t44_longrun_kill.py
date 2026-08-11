#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0044 관련 장시간 수행 세션 / PKG_DMF0044 라이브러리 락 보유자 조사 (KILL 후보 식별)
   ※ 조회 전용. KILL 은 사용자 승인 후 별도 실행."""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("=" * 110)
print("[1] ACTIVE 세션 중 DMF0044 관련 SQL 수행 (SQL 텍스트 또는 PL/SQL 객체 기준)")
print("=" * 110)
show(*fetch(cur, """
SELECT s.sid, s.serial# AS serialno, s.status, s.username, s.osuser, s.machine, s.program,
       s.sql_id, s.last_call_et AS elapsed_sec,
       TO_CHAR(s.sql_exec_start,'YYYY-MM-DD HH24:MI:SS') AS sql_start,
       s.event, s.blocking_session AS blocker,
       SUBSTR(REPLACE(REPLACE(q.sql_text, CHR(10),' '), CHR(13),' '), 1, 120) AS sql_head,
       o.object_name AS plsql_obj
  FROM v$session s
  LEFT JOIN v$sql q ON q.sql_id = s.sql_id AND q.child_number = s.sql_child_number
  LEFT JOIN all_objects o ON o.object_id = s.plsql_entry_object_id
 WHERE s.type = 'USER'
   AND ( UPPER(q.sql_text) LIKE '%DMF0044%'
      OR UPPER(q.sql_text) LIKE '%MOBILE_REPORT%'
      OR UPPER(q.sql_text) LIKE '%GT_DMF0044%'
      OR o.object_name LIKE '%DMF0044%' )
 ORDER BY s.last_call_et DESC
"""))

print()
print("=" * 110)
print("[2] PKG_DMF0044 (및 DMF0044 관련 객체) 라이브러리 락/핀 보유 세션 — 재배포 차단 원인")
print("=" * 110)
show(*fetch(cur, """
SELECT o.object_name, o.object_type, l.session_id AS sid, s.serial# AS serialno, s.status,
       s.username, s.osuser, s.machine, s.program, s.last_call_et AS elapsed_sec,
       DECODE(l.locked_mode,0,'NONE',1,'NULL',2,'ROW SHARE',3,'ROW EXCL',
                            4,'SHARE',5,'S/ROW EXCL',6,'EXCLUSIVE',TO_CHAR(l.locked_mode)) AS lock_mode
  FROM v$locked_object l
  JOIN all_objects o ON o.object_id = l.object_id
  JOIN v$session  s ON s.sid = l.session_id
 WHERE o.object_name LIKE '%DMF0044%'
 ORDER BY s.last_call_et DESC
"""))

print()
print("=" * 110)
print("[3] DBA_KGLLOCK / X$ 대체 — PKG_DMF0044 를 실행중(핀)인 세션 (v$access)")
print("=" * 110)
show(*fetch(cur, """
SELECT a.sid, s.serial# AS serialno, s.status, s.username, s.osuser, s.machine, s.program,
       s.last_call_et AS elapsed_sec, a.owner, a.object, a.type,
       s.sql_id, s.event, s.blocking_session AS blocker
  FROM v$access a
  JOIN v$session s ON s.sid = a.sid
 WHERE a.object LIKE '%DMF0044%'
   AND s.type = 'USER'
 ORDER BY s.last_call_et DESC
"""))

print()
print("=" * 110)
print("[4] 전체 장시간(>=300초) ACTIVE 세션 (참고 — DMF0044 무관 포함)")
print("=" * 110)
show(*fetch(cur, """
SELECT s.sid, s.serial# AS serialno, s.username, s.osuser, s.machine, s.program,
       s.sql_id, s.last_call_et AS elapsed_sec, s.event, s.blocking_session AS blocker,
       SUBSTR(REPLACE(REPLACE(q.sql_text, CHR(10),' '), CHR(13),' '), 1, 100) AS sql_head
  FROM v$session s
  LEFT JOIN v$sql q ON q.sql_id = s.sql_id AND q.child_number = s.sql_child_number
 WHERE s.type = 'USER' AND s.status = 'ACTIVE' AND s.last_call_et >= 300
 ORDER BY s.last_call_et DESC
"""))

print()
print("=" * 110)
print("[5] INACTIVE 이지만 트랜잭션 미종료(락 보유 가능) 세션 — DMF0044 객체 관련")
print("=" * 110)
show(*fetch(cur, """
SELECT s.sid, s.serial# AS serialno, s.status, s.username, s.osuser, s.machine, s.program,
       s.last_call_et AS idle_sec, t.status AS txn_status, t.used_urec AS undo_recs,
       TO_CHAR(t.start_date,'YYYY-MM-DD HH24:MI:SS') AS txn_start
  FROM v$session s
  JOIN v$transaction t ON t.ses_addr = s.saddr
 WHERE s.type = 'USER'
 ORDER BY t.start_date
"""))

con.close()
