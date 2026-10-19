/* =====================================================================================================
 * 18 — 클라우드 실행용 (조회만): 03b 를 돌리기 **직전** 에 DB 가 조용한지 확인. 최근 5분 ASH 를 세션별로 본다.
 *      기준: OTHERS 합계가 5분(300초) 동안 150 ASH 초 이하(= 평균 0.5 세션 미만) 이면 공정 측정 가능. 14:04 실행 때 다른 세션은 8분 동안 111초였다.
 *      16:35 / 17:10 실행 때는 DBeaver 스크립트(세션 8150, 멀티블록 읽기 1,293초)·repctl 락 대기 603초가 겹쳐 I/O 가 3배 이상 늘었다.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 200
SET LINESIZE 300

-- L1. 최근 5분 세션별 활동 (5초 이상만)
SELECT h.session_id, h.user_id, NVL(SUBSTR(h.module, 1, 40), '(null)') AS module, SUBSTR(h.program, 1, 30) AS program
     , COUNT(*) AS ash_sec_5min, SUM(CASE WHEN h.event IS NULL THEN 1 ELSE 0 END) AS cpu_sec
     , SUM(CASE WHEN h.wait_class = 'User I/O' THEN 1 ELSE 0 END) AS io_sec
     , SUBSTR(STATS_MODE(h.event), 1, 30) AS top_event, STATS_MODE(h.sql_id) AS top_sql
  FROM v$active_session_history h
 WHERE h.sample_time >= SYSTIMESTAMP - INTERVAL '5' MINUTE
 GROUP BY h.session_id, h.user_id, NVL(SUBSTR(h.module, 1, 40), '(null)'), SUBSTR(h.program, 1, 30)
HAVING COUNT(*) >= 5
 ORDER BY ash_sec_5min DESC;

-- L2. 합계 판정 — others_ash_5min 이 150 이하이면 GO
SELECT COUNT(*) AS others_ash_5min, COUNT(DISTINCT h.session_id) AS sessions
     , SUM(CASE WHEN h.wait_class = 'User I/O' THEN 1 ELSE 0 END) AS io_sec
     , CASE WHEN COUNT(*) <= 150 THEN 'GO (조용함)' ELSE 'WAIT (다른 작업 중 — 측정값이 부풀려짐)' END AS verdict
  FROM v$active_session_history h
 WHERE h.sample_time >= SYSTIMESTAMP - INTERVAL '5' MINUTE
   AND h.session_id <> SYS_CONTEXT('USERENV', 'SID');

-- L3. 지금 돌고 있는 긴 문장 (60초 이상 활성) — 끝나길 기다릴지 판단
SELECT s.sid, s.username, SUBSTR(s.module, 1, 40) AS module, s.status, s.last_call_et AS active_sec, s.sql_id, SUBSTR(s.event, 1, 30) AS event
  FROM v$session s
 WHERE s.type = 'USER' AND s.status = 'ACTIVE' AND s.last_call_et >= 60 AND s.sid <> SYS_CONTEXT('USERENV', 'SID')
 ORDER BY s.last_call_et DESC;

-- L4. BALANCE 4 테이블에 대한 락 대기 실태 (최근 7일, AWR 10초 샘플) — 우리 배치가 남에게 막혔는지 / 남이 우리에게 막혔는지. 기대: enq: TX 가 없으면 락은 원인이 아님
SELECT NVL(h.event, 'ON CPU') AS event, h.blocking_session, SUBSTR(h.module, 1, 30) AS waiter_module
     , (SELECT SUBSTR(MAX(b.module), 1, 30) FROM dba_hist_active_sess_history b WHERE b.dbid = b.con_dbid AND b.session_id = h.blocking_session AND b.sample_time BETWEEN h.sample_time - INTERVAL '1' MINUTE AND h.sample_time) AS blocker_module
     , o.object_name, COUNT(*) * 10 AS wait_sec, MIN(TO_CHAR(h.sample_time, 'MM-DD HH24:MI')) AS first_, MAX(TO_CHAR(h.sample_time, 'MM-DD HH24:MI')) AS last_
  FROM dba_hist_active_sess_history h JOIN dba_objects o ON o.object_id = h.current_obj#
 WHERE h.dbid = h.con_dbid AND h.sample_time >= SYSDATE - 7 AND h.wait_class = 'Application'
   AND o.owner = 'SCM_MGR' AND o.object_name IN ('DM_PLN_MKT_FCST_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', 'DM_PLN_MKT_FCST', 'DM_PLN_CFM_MKT_DEMAND_PLAN', 'DM_PLN_SALES_PLAN')
 GROUP BY NVL(h.event, 'ON CPU'), h.blocking_session, SUBSTR(h.module, 1, 30), h.sample_time, o.object_name
 ORDER BY wait_sec DESC
 FETCH FIRST 30 ROWS ONLY;

-- L5. 지금 이 순간 BALANCE 테이블 행 락을 쥔 세션 (실행 직전 확인) — 있으면 그 세션이 끝난 뒤 실행
SELECT l.session_id AS sid, s.username, SUBSTR(s.module, 1, 40) AS module, s.status, s.last_call_et, o.object_name, l.locked_mode
  FROM v$locked_object l JOIN dba_objects o ON o.object_id = l.object_id JOIN v$session s ON s.sid = l.session_id
 WHERE o.owner = 'SCM_MGR' AND o.object_name IN ('DM_PLN_MKT_FCST_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', 'DM_PLN_MKT_FCST', 'DM_PLN_CFM_MKT_DEMAND_PLAN', 'DM_PLN_SALES_PLAN')
 ORDER BY s.last_call_et DESC;
