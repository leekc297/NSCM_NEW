/* =====================================================================================================
 * 04 — 클라우드 실행용: 09-30 15:39~16:31 (51.9분) 수동 BALANCE 실행을 재실행 없이 AWR 로 분해
 *      SQL Developer 스크립트 창에 전체 붙여넣기 → F5. 조회 전용 · DB 변경 없음.
 *      권한: DBA_HIST_ACTIVE_SESS_HISTORY / DBA_HIST_SQLTEXT / DBA_OBJECTS (P1 이 돌았으니 있음) + SCM_SYS_LOG_BATCH.
 *      R1 = 09-30 15:39:17~16:31:13 (SCM_MGR, 51.9분) · R2 = 10-01 14:38:21~15:18:07 (SYSTEM, 39.8분) — 둘을 같이 뽑아 재현성을 본다.
 *      AWR 샘플 10초 → approx_sec = 샘플수 × 10. DBID = CON_DBID 로 PDB 1벌만.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

/* ---------- A1. 세션 식별 — 그 창에서 BALANCE 체인 SP 를 돌린 세션 (SID,SERIAL# · 계정 · 접속 프로그램 · 활동 초) ---------- */
WITH runs AS (
    SELECT 'R1_0930' AS run_id, TO_DATE('2026-09-30 15:39:00', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_DATE('2026-09-30 16:32:00', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual UNION ALL
    SELECT 'R2_1001',           TO_DATE('2026-10-01 14:38:00', 'YYYY-MM-DD HH24:MI:SS'),      TO_DATE('2026-10-01 15:19:00', 'YYYY-MM-DD HH24:MI:SS')      FROM dual)
, chain AS (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
             AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                               , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
                               , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF'))
, g AS (
    SELECT r.run_id, h.session_id, h.session_serial#, MAX(h.user_id) AS user_id
         , MAX(h.module) AS module, MAX(h.program) AS program, MAX(h.machine) AS machine
         , MIN(h.sample_time) AS first_seen, MAX(h.sample_time) AS last_seen, COUNT(*) * 10 AS active_sec
      FROM dba_hist_active_sess_history h JOIN runs r ON h.sample_time >= r.f AND h.sample_time < r.t
     WHERE h.dbid = h.con_dbid
       AND (h.plsql_entry_object_id IN (SELECT object_id FROM chain) OR h.plsql_object_id IN (SELECT object_id FROM chain))
     GROUP BY r.run_id, h.session_id, h.session_serial#
)
SELECT g.run_id, g.session_id || ',' || g.session_serial# AS sid_serial
     , (SELECT username FROM all_users u WHERE u.user_id = g.user_id) AS db_user
     , SUBSTR(g.module, 1, 40) AS module, SUBSTR(g.program, 1, 40) AS program, SUBSTR(g.machine, 1, 30) AS machine
     , TO_CHAR(g.first_seen, 'HH24:MI:SS') AS first_seen, TO_CHAR(g.last_seen, 'HH24:MI:SS') AS last_seen
     , g.active_sec
  FROM g
 ORDER BY g.run_id, g.active_sec DESC;


/* ---------- A2. SP 단위 분해 — 51.9분이 어느 SP 안에서 갔나 (현재 실행 중 SP 기준, 루트 SP 자체 코드는 '(루트 …)') ---------- */
WITH runs AS (
    SELECT 'R1_0930' AS run_id, TO_DATE('2026-09-30 15:39:00', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_DATE('2026-09-30 16:32:00', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual UNION ALL
    SELECT 'R2_1001',           TO_DATE('2026-10-01 14:38:00', 'YYYY-MM-DD HH24:MI:SS'),      TO_DATE('2026-10-01 15:19:00', 'YYYY-MM-DD HH24:MI:SS')      FROM dual)
, chain AS (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
             AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                               , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
                               , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF'))
SELECT r.run_id
     , NVL((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id), '(루트 ' || (SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_entry_object_id) || ')') AS in_sp
     , COUNT(*) * 10 AS approx_sec
     , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER (PARTITION BY r.run_id) * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
  FROM dba_hist_active_sess_history h JOIN runs r ON h.sample_time >= r.f AND h.sample_time < r.t
 WHERE h.dbid = h.con_dbid
   AND (h.plsql_entry_object_id IN (SELECT object_id FROM chain) OR h.plsql_object_id IN (SELECT object_id FROM chain))
 GROUP BY r.run_id, h.plsql_object_id, h.plsql_entry_object_id
 ORDER BY r.run_id, approx_sec DESC;


/* ---------- A3. SQL × 플랜 라인 × 대기이벤트 상위 — 병목 1문장 (hook #129 0-b). 상위 sql_id / phv 는 A4 로 플랜을 푼다 ---------- */
WITH runs AS (
    SELECT 'R1_0930' AS run_id, TO_DATE('2026-09-30 15:39:00', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_DATE('2026-09-30 16:32:00', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual UNION ALL
    SELECT 'R2_1001',           TO_DATE('2026-10-01 14:38:00', 'YYYY-MM-DD HH24:MI:SS'),      TO_DATE('2026-10-01 15:19:00', 'YYYY-MM-DD HH24:MI:SS')      FROM dual)
, chain AS (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
             AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                               , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
                               , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF'))
SELECT r.run_id, h.sql_id, h.sql_plan_hash_value AS phv, h.sql_plan_line_id AS line_id
     , SUBSTR(h.sql_plan_operation || ' ' || h.sql_plan_options, 1, 30) AS plan_op
     , SUBSTR(NVL(h.event, 'ON CPU'), 1, 30) AS event
     , SUBSTR((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id), 1, 42) AS in_sp
     , COUNT(*) * 10 AS approx_sec
     , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER (PARTITION BY r.run_id) * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
     , (SELECT SUBSTR(REPLACE(REPLACE(DBMS_LOB.SUBSTR(x.sql_text, 100, 1), CHR(10), ' '), CHR(13), ' '), 1, 100) FROM dba_hist_sqltext x WHERE x.sql_id = h.sql_id AND x.dbid = x.con_dbid AND ROWNUM = 1) AS sql_text
  FROM dba_hist_active_sess_history h JOIN runs r ON h.sample_time >= r.f AND h.sample_time < r.t
 WHERE h.dbid = h.con_dbid
   AND (h.plsql_entry_object_id IN (SELECT object_id FROM chain) OR h.plsql_object_id IN (SELECT object_id FROM chain))
 GROUP BY r.run_id, h.sql_id, h.sql_plan_hash_value, h.sql_plan_line_id, h.sql_plan_operation || ' ' || h.sql_plan_options, NVL(h.event, 'ON CPU'), h.plsql_object_id
 ORDER BY r.run_id, approx_sec DESC
 FETCH FIRST 60 ROWS ONLY;


/* ---------- A3-b. SQL 단위 합계 (플랜 라인·이벤트 합산) — A3 보다 짧은 요약 ---------- */
WITH runs AS (
    SELECT 'R1_0930' AS run_id, TO_DATE('2026-09-30 15:39:00', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_DATE('2026-09-30 16:32:00', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual UNION ALL
    SELECT 'R2_1001',           TO_DATE('2026-10-01 14:38:00', 'YYYY-MM-DD HH24:MI:SS'),      TO_DATE('2026-10-01 15:19:00', 'YYYY-MM-DD HH24:MI:SS')      FROM dual)
, chain AS (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
             AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                               , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
                               , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF'))
SELECT r.run_id, h.sql_id, MAX(h.sql_plan_hash_value) AS phv
     , SUBSTR(MAX((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id)), 1, 42) AS in_sp
     , COUNT(*) * 10 AS approx_sec
     , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER (PARTITION BY r.run_id) * 100, 1) AS pct
     , SUM(CASE WHEN h.event IS NULL THEN 1 ELSE 0 END) * 10 AS cpu_sec
     , SUM(CASE WHEN h.event IS NOT NULL THEN 1 ELSE 0 END) * 10 AS wait_sec
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
     , (SELECT SUBSTR(REPLACE(REPLACE(DBMS_LOB.SUBSTR(x.sql_text, 100, 1), CHR(10), ' '), CHR(13), ' '), 1, 100) FROM dba_hist_sqltext x WHERE x.sql_id = h.sql_id AND x.dbid = x.con_dbid AND ROWNUM = 1) AS sql_text
  FROM dba_hist_active_sess_history h JOIN runs r ON h.sample_time >= r.f AND h.sample_time < r.t
 WHERE h.dbid = h.con_dbid
   AND (h.plsql_entry_object_id IN (SELECT object_id FROM chain) OR h.plsql_object_id IN (SELECT object_id FROM chain))
 GROUP BY r.run_id, h.sql_id
 ORDER BY r.run_id, approx_sec DESC
 FETCH FIRST 30 ROWS ONLY;


/* ---------- A5. 09-30 실행의 step 로그 타임라인 — A2/A3 의 시각과 맞춰 "어느 step 구간 = 어느 SQL" 을 잇는다 ---------- */
SELECT TO_CHAR(x.event_date, 'HH24:MI:SS') AS at_time
     , ROUND((x.event_date - LAG(x.event_date) OVER (ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date)) * 86400) AS gap_sec
     , ROUND((x.event_date - TO_DATE('2026-09-30 15:39:17', 'YYYY-MM-DD HH24:MI:SS')) * 1440, 1) AS min_from_start
     , SUBSTR(x.program_name, 1, 42) AS program_name, x.log_type, x.created_by
     , SUBSTR(x.log_message, 1, 40) AS log_message, SUBSTR(x.description, 1, 60) AS description
  FROM SCM_MGR.SCM_SYS_LOG_BATCH x
 WHERE x.event_date BETWEEN TO_DATE('2026-09-30 15:39:17', 'YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2026-09-30 16:31:13', 'YYYY-MM-DD HH24:MI:SS')
   AND (x.created_by = 'SCM_MGR' OR x.created_by IN ('scm_batch', 'SYSTEM'))
   AND REGEXP_LIKE(x.program_name, 'BALANCE|WS_RTF|LOCAL_KRW|CUTOFF|VERSION_CREATE|MAIL_SEND')
   AND x.log_type IN ('START', 'END', 'ERROR', 'ING', 'INVALID')
 ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date;


/* ---------- A5-b. 10-01 14:38 실행(R2)의 step 타임라인 — R1 과 구간별 비교용 ---------- */
SELECT TO_CHAR(x.event_date, 'HH24:MI:SS') AS at_time
     , ROUND((x.event_date - LAG(x.event_date) OVER (ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date)) * 86400) AS gap_sec
     , ROUND((x.event_date - TO_DATE('2026-10-01 14:38:21', 'YYYY-MM-DD HH24:MI:SS')) * 1440, 1) AS min_from_start
     , SUBSTR(x.program_name, 1, 42) AS program_name, x.log_type, x.created_by
     , SUBSTR(x.log_message, 1, 40) AS log_message, SUBSTR(x.description, 1, 60) AS description
  FROM SCM_MGR.SCM_SYS_LOG_BATCH x
 WHERE x.event_date BETWEEN TO_DATE('2026-10-01 14:38:21', 'YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2026-10-01 15:18:07', 'YYYY-MM-DD HH24:MI:SS')
   AND (x.created_by = 'SYSTEM' OR x.created_by IN ('scm_batch'))
   AND REGEXP_LIKE(x.program_name, 'BALANCE|WS_RTF|LOCAL_KRW|CUTOFF|VERSION_CREATE|MAIL_SEND')
   AND x.log_type IN ('START', 'END', 'ERROR', 'ING', 'INVALID')
 ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date;


/* ---------- A4. 상위 SQL 의 실행계획 — A3/A3-b 의 sql_id 와 phv 를 넣고 주석을 풀어 실행 (상위 3개 정도) ----------
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('<sql_id>', <phv>, NULL, 'ALLSTATS LAST +PEEKED_BINDS'));
*/
