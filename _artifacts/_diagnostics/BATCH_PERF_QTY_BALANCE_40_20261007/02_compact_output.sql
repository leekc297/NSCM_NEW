/* =====================================================================================================
 * 02_compact_output.sql — 01 의 핵심 쿼리를 "행당 한 줄 문자열" 로 압축 출력 (붙여넣기 50,000자 제한 회피용)
 * 내용·필터는 01 과 동일. 결과 열이 1개(LINE)라 SQL*Plus 에서도 줄바꿈 없이 나온다.
 * 조회 전용. 클라우드 SCM_MGR 로 실행. 가능하면 아래 SPOOL 로 파일에 받아 공유.
 * ===================================================================================================== */
SET PAGESIZE 0 LINESIZE 400 TRIMSPOOL ON TRIMOUT ON FEEDBACK OFF HEADING OFF VERIFY OFF LONG 4000
-- SPOOL qty_balance_40_diag.txt

/* ---------- C1. 실행 목록 (Q1 압축) ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, l AS (
    SELECT l.log_type, l.log_message, l.description, l.event_date, l.created_by, l.sql_err_code
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
SELECT 'C1 | run=' || run_no
    || ' | ' || TO_CHAR(MIN(CASE WHEN log_type = 'START' THEN event_date END), 'MM-DD HH24:MI:SS')
    || ' ~ ' || TO_CHAR(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END), 'HH24:MI:SS')
    || ' | ' || ROUND((MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END) - MIN(CASE WHEN log_type = 'START' THEN event_date END)) * 1440, 1) || 'min'
    || ' | ' || CASE WHEN MAX(CASE WHEN log_type = 'ERROR' THEN 1 ELSE 0 END) = 1 THEN 'ERROR'
                     WHEN MAX(CASE WHEN log_type = 'INVALID' THEN 1 ELSE 0 END) = 1 THEN 'INVALID'
                     WHEN MAX(CASE WHEN log_type = 'END' THEN 1 ELSE 0 END) = 1 THEN 'END' ELSE 'OPEN' END
    || ' | ' || LISTAGG(CASE WHEN log_type = 'ING' THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), 'ING') END, ',') WITHIN GROUP (ORDER BY event_date, ord, log_message)
    || ' | ' || NVL(MAX(CASE WHEN log_type = 'ERROR' THEN sql_err_code || ' ' || SUBSTR(log_message, 1, 90) || ' @' || REGEXP_SUBSTR(description, 'line [0-9]+') END), '-') AS line
  FROM s WHERE run_no > 0
 GROUP BY run_no, created_by ORDER BY 1;


/* ---------- C3. 구간별 집계 (Q3 압축) ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, l AS (
    SELECT l.program_name, l.log_type, l.log_message, l.description, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, run AS (
    SELECT run_no, created_by, MIN(CASE WHEN log_type = 'START' THEN event_date END) AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END)
             , NVL(LEAD(MIN(CASE WHEN log_type = 'START' THEN event_date END)) OVER (PARTITION BY created_by ORDER BY run_no) - 1 / 86400
                 , MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1)) AS run_end
      FROM s WHERE run_no > 0 GROUP BY run_no, created_by
)
, t AS (
    SELECT run_no, program_name, log_type, log_message, event_date, ord FROM s WHERE run_no > 0
    UNION ALL
    SELECT run.run_no, c.program_name, c.log_type, c.log_message, c.event_date, CASE c.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END
      FROM run JOIN SCM_MGR.SCM_SYS_LOG_BATCH c
        ON c.event_date BETWEEN run.run_start AND run.run_end
       AND c.program_name IN ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE')
       AND c.log_type IN ('START', 'END', 'ERROR')
       AND REGEXP_LIKE(c.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i')
       AND (c.program_name <> 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' OR c.description LIKE '%@v_created_by : SYSTEM%')   -- 환율 배치 등 다른 호출자의 KRW(40) 로그 제외 (클라우드 1차: 00:04 환율 KRW END 가 섞임)
)
, x AS (
    SELECT t.*, CASE WHEN program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), log_type)
                     ELSE REPLACE(REPLACE(program_name, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'KRW'), 'PR_DM_DNM_CREATE_WS_RTF', 'WS_RTF') || ':' || log_type END AS marker
      FROM t
)
, g AS (
    SELECT run_no, marker, LAG(marker) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message) AS prev_marker
         , (event_date - LAG(event_date) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message)) * 86400 AS gap_sec
      FROM x
)
SELECT 'C3 | ' || RPAD(prev_marker || '->' || marker, 24) || ' | runs=' || COUNT(*) || ' | total=' || ROUND(SUM(gap_sec)) || 's | avg=' || ROUND(AVG(gap_sec)) || 's | max=' || ROUND(MAX(gap_sec)) || 's | min=' || ROUND(MIN(gap_sec)) || 's | ' || ROUND(RATIO_TO_REPORT(SUM(gap_sec)) OVER () * 100, 1) || '%'
     || ' | per_run=' || LISTAGG(ROUND(gap_sec), ',') WITHIN GROUP (ORDER BY run_no) AS line
  FROM g WHERE prev_marker IS NOT NULL
 GROUP BY prev_marker || '->' || marker
 ORDER BY SUM(gap_sec) DESC;


/* ---------- C2. 실행별 타임라인 — 간격 5초 이상 행만 (Q2 압축) ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, l AS (
    SELECT l.program_name, l.log_type, l.log_message, l.description, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, run AS (
    SELECT run_no, created_by, MIN(CASE WHEN log_type = 'START' THEN event_date END) AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END)
             , NVL(LEAD(MIN(CASE WHEN log_type = 'START' THEN event_date END)) OVER (PARTITION BY created_by ORDER BY run_no) - 1 / 86400
                 , MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1)) AS run_end
      FROM s WHERE run_no > 0 GROUP BY run_no, created_by
)
, t AS (
    SELECT run_no, program_name, log_type, log_message, description, event_date, ord FROM s WHERE run_no > 0
    UNION ALL
    SELECT run.run_no, c.program_name, c.log_type, c.log_message, c.description, c.event_date, CASE c.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END
      FROM run JOIN SCM_MGR.SCM_SYS_LOG_BATCH c
        ON c.event_date BETWEEN run.run_start AND run.run_end
       AND c.program_name IN ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE')
       AND REGEXP_LIKE(c.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i')
       AND (c.program_name <> 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' OR c.description LIKE '%@v_created_by : SYSTEM%')   -- 환율 배치 등 다른 호출자의 KRW(40) 로그 제외 (클라우드 1차: 00:04 환율 KRW END 가 섞임)
)
, x AS (
    SELECT t.*, CASE WHEN program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), log_type)
                     ELSE REPLACE(REPLACE(program_name, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'KRW'), 'PR_DM_DNM_CREATE_WS_RTF', 'WS_RTF') || ':' || log_type END AS marker
         , ROUND((event_date - LAG(event_date) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message)) * 86400) AS gap_sec
         , LAG(CASE WHEN program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), log_type)
                    ELSE REPLACE(REPLACE(program_name, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'KRW'), 'PR_DM_DNM_CREATE_WS_RTF', 'WS_RTF') || ':' || log_type END)
               OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message) AS prev_marker
      FROM t
)
SELECT 'C2 | run=' || run_no || ' | ' || TO_CHAR(event_date, 'MM-DD HH24:MI:SS') || ' | ' || RPAD(NVL(prev_marker, '-') || '->' || marker, 24) || ' | gap=' || gap_sec || 's'
     || CASE WHEN log_type IN ('ERROR', 'INVALID') THEN ' | ' || SUBSTR(log_message, 1, 100) || ' @' || REGEXP_SUBSTR(description, 'line [0-9]+')
             WHEN marker = 'ING' THEN ' | ' || SUBSTR(log_message, 1, 60) || ' / ' || SUBSTR(description, 1, 60) ELSE '' END AS line
  FROM x
 WHERE gap_sec >= 5 OR log_type IN ('ERROR', 'INVALID', 'START')
 ORDER BY run_no, event_date, ord, log_message;


/* ---------- C5. 8주 추이 (Q5 압축) ---------- */
WITH l AS (
    SELECT l.log_type, l.log_message, l.event_date, l.created_by, CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= TRUNC(SYSDATE, 'IW') - 56
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, r AS (
    SELECT run_no, created_by, MIN(CASE WHEN log_type = 'START' THEN event_date END) AS run_start, MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END) AS run_end
         , MAX(CASE WHEN log_type = 'ERROR' THEN 1 ELSE 0 END) AS is_err, MAX(CASE WHEN log_type = 'INVALID' THEN 1 ELSE 0 END) AS is_invalid
      FROM s WHERE run_no > 0 GROUP BY run_no, created_by
)
SELECT 'C5 | week=' || TO_CHAR(TRUNC(run_start, 'IW'), 'MM-DD') || ' | runs=' || COUNT(*) || ' | max=' || ROUND(MAX((run_end - run_start) * 1440), 1) || 'min | avg=' || ROUND(AVG((run_end - run_start) * 1440), 1)
    || 'min | err=' || SUM(is_err) || ' | invalid=' || SUM(is_invalid) || ' | open=' || SUM(CASE WHEN run_end IS NULL THEN 1 ELSE 0 END)
    || ' | ' || LISTAGG(TO_CHAR(run_start, 'Dy HH24:MI') || '(' || ROUND((run_end - run_start) * 1440, 1) || ')', ' ') WITHIN GROUP (ORDER BY run_start) AS line
  FROM r GROUP BY TRUNC(run_start, 'IW') ORDER BY 1;


/* ---------- C6. 스케줄러 잡 (Q6 압축) ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
SELECT 'C6 | ' || TO_CHAR(d.actual_start_date, 'MM-DD HH24:MI:SS') || ' | ' || d.status || ' | dur=' || d.run_duration || ' | cpu=' || d.cpu_used || ' | err=' || d.error# || ' | sess=' || d.session_id || ' | ' || SUBSTR(d.additional_info, 1, 150) AS line
  FROM all_scheduler_job_run_details d, w
 WHERE d.owner = 'SCM_MGR' AND d.job_name = 'JOB_SCMPROD_PLAN_FINAL_40_CREATION' AND d.actual_start_date >= w.from_dt AND d.actual_start_date < w.to_dt
 ORDER BY d.actual_start_date;

SELECT 'C6-def | ' || j.job_name || ' | enabled=' || j.enabled || ' | ' || j.state || ' | runs=' || j.run_count || ' | fails=' || j.failure_count || ' | last=' || TO_CHAR(j.last_start_date, 'MM-DD HH24:MI') || ' | next=' || TO_CHAR(j.next_run_date, 'MM-DD HH24:MI')
    || ' | sched=' || NVL(j.schedule_name, j.repeat_interval) || ' | log=' || j.logging_level AS line
  FROM all_scheduler_jobs j WHERE j.owner = 'SCM_MGR' AND j.job_name = 'JOB_SCMPROD_PLAN_FINAL_40_CREATION';

SELECT 'C6-sch | ' || s.schedule_name || ' | ' || s.repeat_interval AS line
  FROM all_scheduler_schedules s WHERE s.owner = 'SCM_MGR' AND s.schedule_name LIKE 'SCH_JOB_SCMPROD_PLAN_FINAL_40_CREATION%';


/* ---------- C7. AWR ASH — SQL×플랜라인×대기 상위 25 (Q7-b 압축, AWR 권한 필요) ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
SELECT 'C7 | ' || h.sql_id || ' | phv=' || h.sql_plan_hash_value || ' | line=' || h.sql_plan_line_id || ' ' || RPAD(NVL(h.sql_plan_operation || ' ' || h.sql_plan_options, '-'), 28)
    || ' | ' || RPAD(NVL(h.event, 'ON CPU'), 26) || ' | ' || LPAD(COUNT(*) * 10, 5) || 's ' || LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1), 5) || '%'
    || ' | ' || MIN(TO_CHAR(h.sample_time, 'MM-DD HH24:MI:SS')) || '~' || MAX(TO_CHAR(h.sample_time, 'HH24:MI:SS'))
    || ' | sess=' || LISTAGG(DISTINCT h.session_id || ',' || h.session_serial#, ' ') WITHIN GROUP (ORDER BY h.session_id)
    || ' | ' || SUBSTR(MAX(h.module), 1, 20) || '/' || SUBSTR(MAX(h.action), 1, 40) AS line
  FROM dba_hist_active_sess_history h, w
 WHERE h.sample_time >= w.from_dt AND h.sample_time < w.to_dt
   AND h.dbid = h.con_dbid
   AND (h.plsql_entry_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE') OR h.plsql_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE'))
 GROUP BY h.sql_id, h.sql_plan_hash_value, h.sql_plan_line_id, h.sql_plan_operation || ' ' || h.sql_plan_options, NVL(h.event, 'ON CPU')
 ORDER BY COUNT(*) DESC
 FETCH FIRST 25 ROWS ONLY;

-- C7-txt. 위 상위 sql_id 의 원문 앞부분 (AWR 에 저장된 것만)
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, top AS (
    SELECT h.sql_id, COUNT(*) AS cnt
      FROM dba_hist_active_sess_history h, w
     WHERE h.sample_time >= w.from_dt AND h.sample_time < w.to_dt AND h.dbid = h.con_dbid
       AND (h.plsql_entry_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE') OR h.plsql_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE'))
     GROUP BY h.sql_id ORDER BY COUNT(*) DESC FETCH FIRST 8 ROWS ONLY
)
SELECT 'C7-txt | ' || t.sql_id || ' | ' || t.cnt * 10 || 's | ' || REPLACE(REPLACE(SUBSTR(DBMS_LOB.SUBSTR(x.sql_text, 300, 1), 1, 300), CHR(10), ' '), CHR(13), ' ') AS line
  FROM top t LEFT JOIN dba_hist_sqltext x ON x.sql_id = t.sql_id AND x.dbid = x.con_dbid
 ORDER BY t.cnt DESC;


/* ---------- C8. 판본 대조 (Q8-a/c/d 압축) ---------- */
SELECT 'C8-ver | ' || o.object_name || ' | ' || o.status || ' | ddl=' || TO_CHAR(o.last_ddl_time, 'YYYY-MM-DD HH24:MI:SS')
    || ' | lines=' || (SELECT MAX(line) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type)
    || ' | ajs1001=' || (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%2026.10.01 AJS%')
    || ' | asisdelta1006=' || (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%E20261006-ASISDELTA%')
    || ' | steps=' || (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND UPPER(s.text) LIKE '%STEP - A0%') AS line
  FROM all_objects o
 WHERE o.owner = 'SCM_MGR' AND o.object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW') AND o.object_type = 'PROCEDURE';

SELECT 'C8-mark | L' || line || ' | ' || SUBSTR(REPLACE(REPLACE(TRIM(text), CHR(10), ''), CHR(13), ''), 1, 110) AS line
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND (UPPER(text) LIKE '%STEP - A0%' OR text LIKE '%PR_DM_DNM_CREATE_WS_RTF(%' OR text LIKE '%PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(%'
        OR text LIKE '%INSERT INTO GT_PRDM2_FP_STOCK_QTY%' OR text LIKE '%INSERT INTO GT_PRDM2_VMI_MST_MAIN%' OR text LIKE '%VMI_DIO INSERT%' OR text LIKE '%2026.10.01 AJS%')
 ORDER BY line;

SELECT 'C8-gtt | ' || c.table_name || '.' || c.column_name || ' ' || c.data_type || '(' || c.data_length || ') null=' || c.nullable AS line
  FROM all_tab_columns c WHERE c.owner = 'SCM_MGR' AND c.table_name = 'GT_PRDM2_FP_STOCK_QTY' ORDER BY c.column_id;

SELECT 'C8-nullsite | STOCK_SN(40, 2wk)=' || (SELECT COUNT(*) FROM SCM_DNM_STOCK_SN S JOIN SCM_MST_LOCATION L ON L.DIVISION_ID = S.DIVISION_ID AND L.STORAGE_ID = S.STORAGE_ID
                                               WHERE S.DIVISION_ID = '40' AND L.SCM_SITE_ID IS NULL AND S.CUTOFF_DATE >= TRUNC(SYSDATE, 'IW') - 14)
    || ' | LOCATION(40)=' || (SELECT COUNT(*) FROM SCM_MST_LOCATION L WHERE L.DIVISION_ID = '40' AND L.SCM_SITE_ID IS NULL) AS line
  FROM dual;

/* ---------- C1W. 이번 주 실행 목록 (월요일 ~ 지금) — 10-06 16:16 신판 배포 후 실행 상태 확인용 ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') AS from_dt, SYSDATE + 1 AS to_dt FROM dual)
, l AS (
    SELECT l.log_type, l.log_message, l.description, l.event_date, l.created_by, l.sql_err_code
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
SELECT 'C1W | run=' || run_no
    || ' | ' || TO_CHAR(MIN(CASE WHEN log_type = 'START' THEN event_date END), 'MM-DD HH24:MI:SS')
    || ' ~ ' || TO_CHAR(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END), 'HH24:MI:SS')
    || ' | ' || ROUND((MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END) - MIN(CASE WHEN log_type = 'START' THEN event_date END)) * 1440, 1) || 'min'
    || ' | ' || CASE WHEN MAX(CASE WHEN log_type = 'ERROR' THEN 1 ELSE 0 END) = 1 THEN 'ERROR'
                     WHEN MAX(CASE WHEN log_type = 'INVALID' THEN 1 ELSE 0 END) = 1 THEN 'INVALID'
                     WHEN MAX(CASE WHEN log_type = 'END' THEN 1 ELSE 0 END) = 1 THEN 'END' ELSE 'OPEN' END
    || ' | ' || LISTAGG(CASE WHEN log_type = 'ING' THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), 'ING') END, ',') WITHIN GROUP (ORDER BY event_date, ord, log_message)
    || ' | ' || NVL(MAX(CASE WHEN log_type = 'ERROR' THEN sql_err_code || ' ' || SUBSTR(log_message, 1, 90) || ' @' || REGEXP_SUBSTR(description, 'line [0-9]+') END), '-') AS line
  FROM s WHERE run_no > 0
 GROUP BY run_no, created_by ORDER BY 1;


/* ---------- C7-run. AWR ASH — 이 호출(40/NULL)의 실행 구간 안에서만 (최근 8일 = AWR 보존 범위) ----------
 * C7 은 같은 SP 를 DBeaver 등으로 수동 실행한 세션까지 섞인다(클라우드 1차: 09-30 15~20시 수동 실행이 상위 독식).
 * 여기서는 로그에서 뽑은 실행 구간(START~END/ERROR) 안의 샘플만 집계해 "이 잡" 의 SQL 을 특정한다.                 */
WITH l AS (
    SELECT l.log_type, l.log_message, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= SYSDATE - 8
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, run AS (
    SELECT run_no, MIN(CASE WHEN log_type = 'START' THEN event_date END) AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END), MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1 / 24) AS run_end
      FROM s WHERE run_no > 0 GROUP BY run_no
)
, a AS (
    SELECT run.run_no, run.run_start, h.sql_id, h.sql_plan_hash_value, h.sql_plan_line_id, h.sql_plan_operation, h.sql_plan_options, h.event
         , h.session_id, h.session_serial#, h.sample_time, h.module, h.action
      FROM run JOIN dba_hist_active_sess_history h
        ON h.sample_time >= run.run_start AND h.sample_time <= run.run_end + 2 / 86400
       AND h.dbid = h.con_dbid
       AND ((h.module = 'DBMS_SCHEDULER' AND h.action LIKE 'JOB_PR_DM_PLN_MKT_FCST%')   -- 클라우드 2차 실측: 매일 00시 실행 = JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TOTAL_MOBILE 등의 step(WEEKLY_ROLLING 40 MF_D) 안에서 호출 → entry 는 WEEKLY_ROLLING
            OR h.plsql_entry_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE') OR h.plsql_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE'))
)
SELECT 'C7-run | ' || a.sql_id || ' | phv=' || a.sql_plan_hash_value || ' | line=' || a.sql_plan_line_id || ' ' || RPAD(NVL(a.sql_plan_operation || ' ' || a.sql_plan_options, '-'), 28)
    || ' | ' || RPAD(NVL(a.event, 'ON CPU'), 26) || ' | ' || LPAD(COUNT(*) * 10, 5) || 's ' || LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1), 5) || '%'
    || ' | runs=' || LISTAGG(DISTINCT TO_CHAR(a.run_start, 'MM-DD HH24:MI'), ' ') WITHIN GROUP (ORDER BY TO_CHAR(a.run_start, 'MM-DD HH24:MI'))
    || ' | sess=' || LISTAGG(DISTINCT a.session_id || ',' || a.session_serial#, ' ') WITHIN GROUP (ORDER BY a.session_id)
    || ' | ' || SUBSTR(MAX(a.module), 1, 20) || '/' || SUBSTR(MAX(a.action), 1, 40) AS line
  FROM a
 GROUP BY a.sql_id, a.sql_plan_hash_value, a.sql_plan_line_id, a.sql_plan_operation || ' ' || a.sql_plan_options, NVL(a.event, 'ON CPU')
 ORDER BY COUNT(*) DESC
 FETCH FIRST 30 ROWS ONLY;

-- C7-run-txt. 위 sql_id 원문 앞부분 (실행 구간 안 샘플 수 순)
WITH l AS (
    SELECT l.log_type, l.log_message, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= SYSDATE - 8
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, run AS (
    SELECT run_no, MIN(CASE WHEN log_type = 'START' THEN event_date END) AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END), MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1 / 24) AS run_end
      FROM s WHERE run_no > 0 GROUP BY run_no
)
, top AS (
    SELECT h.sql_id, COUNT(*) AS cnt
      FROM run JOIN dba_hist_active_sess_history h
        ON h.sample_time >= run.run_start AND h.sample_time <= run.run_end + 2 / 86400 AND h.dbid = h.con_dbid
       AND ((h.module = 'DBMS_SCHEDULER' AND h.action LIKE 'JOB_PR_DM_PLN_MKT_FCST%') OR h.plsql_entry_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE') OR h.plsql_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE'))
     GROUP BY h.sql_id ORDER BY COUNT(*) DESC FETCH FIRST 12 ROWS ONLY
)
SELECT 'C7-run-txt | ' || t.sql_id || ' | ' || t.cnt * 10 || 's | ' || REPLACE(REPLACE(SUBSTR(DBMS_LOB.SUBSTR(x.sql_text, 400, 1), 1, 400), CHR(10), ' '), CHR(13), ' ') AS line
  FROM top t LEFT JOIN dba_hist_sqltext x ON x.sql_id = t.sql_id AND x.dbid = x.con_dbid
 ORDER BY t.cnt DESC;

-- C7-plan. 상위 SQL 의 AWR 실행계획 (sql_id / plan_hash 를 C7-run 결과로 바꿔 실행. 1차 결과 기준 기본값 = GT_PRDM2_VMI_MST_MAIN INSERT)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('3g9x8t27cmu5k', 1073052721, NULL, 'TYPICAL +PREDICATE'));


/* ---------- C3W. 구간별 집계 — 이번 주 (10-06 16:16 신판 기준) ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') AS from_dt, SYSDATE + 1 AS to_dt FROM dual)
, l AS (
    SELECT l.program_name, l.log_type, l.log_message, l.description, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, run AS (
    SELECT run_no, created_by, MIN(CASE WHEN log_type = 'START' THEN event_date END) AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END)
             , NVL(LEAD(MIN(CASE WHEN log_type = 'START' THEN event_date END)) OVER (PARTITION BY created_by ORDER BY run_no) - 1 / 86400
                 , MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1)) AS run_end
      FROM s WHERE run_no > 0 GROUP BY run_no, created_by
)
, t AS (
    SELECT run_no, program_name, log_type, log_message, event_date, ord FROM s WHERE run_no > 0
    UNION ALL
    SELECT run.run_no, c.program_name, c.log_type, c.log_message, c.event_date, CASE c.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END
      FROM run JOIN SCM_MGR.SCM_SYS_LOG_BATCH c
        ON c.event_date BETWEEN run.run_start AND run.run_end
       AND c.program_name IN ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE')
       AND c.log_type IN ('START', 'END', 'ERROR')
       AND REGEXP_LIKE(c.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i')
       AND (c.program_name <> 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' OR c.description LIKE '%@v_created_by : SYSTEM%')   -- 환율 배치 등 다른 호출자의 KRW(40) 로그 제외 (클라우드 1차: 00:04 환율 KRW END 가 섞임)
)
, x AS (
    SELECT t.*, CASE WHEN program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), log_type)
                     ELSE REPLACE(REPLACE(program_name, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'KRW'), 'PR_DM_DNM_CREATE_WS_RTF', 'WS_RTF') || ':' || log_type END AS marker
      FROM t
)
, g AS (
    SELECT run_no, marker, LAG(marker) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message) AS prev_marker
         , (event_date - LAG(event_date) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message)) * 86400 AS gap_sec
      FROM x
)
SELECT 'C3W | ' || RPAD(prev_marker || '->' || marker, 24) || ' | runs=' || COUNT(*) || ' | total=' || ROUND(SUM(gap_sec)) || 's | avg=' || ROUND(AVG(gap_sec)) || 's | max=' || ROUND(MAX(gap_sec)) || 's | min=' || ROUND(MIN(gap_sec)) || 's | ' || ROUND(RATIO_TO_REPORT(SUM(gap_sec)) OVER () * 100, 1) || '%'
     || ' | per_run=' || LISTAGG(ROUND(gap_sec), ',') WITHIN GROUP (ORDER BY run_no) AS line
  FROM g WHERE prev_marker IS NOT NULL
 GROUP BY prev_marker || '->' || marker
 ORDER BY SUM(gap_sec) DESC;


/* ---------- C2W. 실행별 타임라인 — 이번 주, 간격 5초 이상 행만 ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') AS from_dt, SYSDATE + 1 AS to_dt FROM dual)
, l AS (
    SELECT l.program_name, l.log_type, l.log_message, l.description, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, run AS (
    SELECT run_no, created_by, MIN(CASE WHEN log_type = 'START' THEN event_date END) AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END)
             , NVL(LEAD(MIN(CASE WHEN log_type = 'START' THEN event_date END)) OVER (PARTITION BY created_by ORDER BY run_no) - 1 / 86400
                 , MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1)) AS run_end
      FROM s WHERE run_no > 0 GROUP BY run_no, created_by
)
, t AS (
    SELECT run_no, program_name, log_type, log_message, description, event_date, ord FROM s WHERE run_no > 0
    UNION ALL
    SELECT run.run_no, c.program_name, c.log_type, c.log_message, c.description, c.event_date, CASE c.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END
      FROM run JOIN SCM_MGR.SCM_SYS_LOG_BATCH c
        ON c.event_date BETWEEN run.run_start AND run.run_end
       AND c.program_name IN ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE')
       AND REGEXP_LIKE(c.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i')
       AND (c.program_name <> 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' OR c.description LIKE '%@v_created_by : SYSTEM%')   -- 환율 배치 등 다른 호출자의 KRW(40) 로그 제외 (클라우드 1차: 00:04 환율 KRW END 가 섞임)
)
, x AS (
    SELECT t.*, CASE WHEN program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), log_type)
                     ELSE REPLACE(REPLACE(program_name, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'KRW'), 'PR_DM_DNM_CREATE_WS_RTF', 'WS_RTF') || ':' || log_type END AS marker
         , ROUND((event_date - LAG(event_date) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message)) * 86400) AS gap_sec
         , LAG(CASE WHEN program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), log_type)
                    ELSE REPLACE(REPLACE(program_name, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'KRW'), 'PR_DM_DNM_CREATE_WS_RTF', 'WS_RTF') || ':' || log_type END)
               OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message) AS prev_marker
      FROM t
)
SELECT 'C2W | run=' || run_no || ' | ' || TO_CHAR(event_date, 'MM-DD HH24:MI:SS') || ' | ' || RPAD(NVL(prev_marker, '-') || '->' || marker, 24) || ' | gap=' || gap_sec || 's'
     || CASE WHEN log_type IN ('ERROR', 'INVALID') THEN ' | ' || SUBSTR(log_message, 1, 100) || ' @' || REGEXP_SUBSTR(description, 'line [0-9]+')
             WHEN marker = 'ING' THEN ' | ' || SUBSTR(log_message, 1, 60) || ' / ' || SUBSTR(description, 1, 60) ELSE '' END AS line
  FROM x
 WHERE gap_sec >= 5 OR log_type IN ('ERROR', 'INVALID', 'START')
 ORDER BY run_no, event_date, ord, log_message;

/* ---------- C9. 결과 정합 점검 — "빨라진 만큼 일을 덜 한 것인가" 확인 (조회 전용) ----------
 * C9-a : AJS 10-01 보정(VMI_MST_MAIN INSERT 조인에 END_CUSTOMER 추가)이 결과를 바꿀 수 있는 유일한 경우 = 40 CFM 행에 END_CUSTOMER <> PROJECT_CODE 가 존재할 때.
 *        0 이면 추가 조건은 중복 조건이라 결과 동일 → 단축은 순수 실행계획 개선. (사내 ZIOUI1: 40 전행 284,147 중 0)
 * C9-b : 40 사업부, 당주 월요일 이후, 본 SP 가 다시 쓰는 메저들의 행수·수량합을 LAST_UPDATE_DATE 날짜별로 — 마지막 실행일에 전부 다시 써졌는지(= 삭제·재생성 수행 여부)
 * C9-c : 마지막 2회 정상 실행(END) 시각 — C9-b 의 날짜와 대조                                                                           */
SELECT 'C9-a | CFM 40 END_CUSTOMER<>PROJECT_CODE = ' || SUM(CASE WHEN END_CUSTOMER <> PROJECT_CODE THEN 1 ELSE 0 END) || ' / ' || COUNT(*) || ' rows' AS line
  FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID = '40';

SELECT 'C9-b | ' || tbl || ' | ' || RPAD(measure, 12) || ' | upd=' || TO_CHAR(upd_day, 'MM-DD') || ' | rows=' || LPAD(cnt, 8) || ' | qty_sum=' || TO_CHAR(ROUND(qty_sum)) || ' | by=' || created_by AS line
  FROM (
    SELECT 'MF ' AS tbl, MEASURE, TRUNC(LAST_UPDATE_DATE) AS upd_day, COUNT(*) AS cnt, SUM(QTY) AS qty_sum, MIN(LAST_UPDATED_BY) AS created_by
      FROM DM_PLN_MKT_FCST
     WHERE DIVISION_ID = '40' AND YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD')
       AND MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'VMI_In_Plan', 'AS_In_Plan', 'RTF_PR', 'VMI_Inv', 'VMI_DIO', 'BALANCE')
     GROUP BY MEASURE, TRUNC(LAST_UPDATE_DATE)
    UNION ALL
    SELECT 'CFM', MEASURE, TRUNC(LAST_UPDATE_DATE), COUNT(*), SUM(QTY), MIN(LAST_UPDATED_BY)
      FROM DM_PLN_CFM_MKT_DEMAND_PLAN
     WHERE DIVISION_ID = '40' AND YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD')
       AND MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'VMI_In_Plan', 'AS_In_Plan', 'RTF_PR', 'VMI_Inv', 'VMI_DIO', 'BALANCE')
     GROUP BY MEASURE, TRUNC(LAST_UPDATE_DATE)
  )
 ORDER BY tbl, measure, upd_day;

SELECT 'C9-c | last END runs: ' || LISTAGG(TO_CHAR(event_date, 'MM-DD HH24:MI:SS'), ' , ') WITHIN GROUP (ORDER BY event_date DESC) AS line
  FROM (SELECT event_date FROM SCM_MGR.SCM_SYS_LOG_BATCH
         WHERE program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}' AND log_type = 'END'
         ORDER BY event_date DESC FETCH FIRST 3 ROWS ONLY);

/* ---------- C10. 실행별 처리 행수 비교 — "데이터 양이 달라서 빨라진 것인가" (AWR SQLSTAT, 최근 8일, 잡 세션 SQL 만) ----------
 * 같은 SQL_ID(문장 원문이 바뀌지 않은 문장)에 대해 날짜별 EXECUTIONS / ROWS_PROCESSED / ELAPSED 를 비교한다.
 * 행수가 비슷한데 시간이 줄었으면 = 실행계획 개선, 행수가 크게 줄었으면 = 입력 데이터(계획·대상) 차이.
 * 기준 문장(원문 불변·실행마다 1회): 630stwpcj5tr1 BALANCE INSERT(MF) · 242jv1rzat1x7 BALANCE DELETE(MF) · 3yvf4k3w1tpc6 GT_PRDM2_RESULTS INSERT
 *   · bdywpw9bh169n GT_PRDM2_MF_RTF_ALLOCATION INSERT · 259ukvubwgd34 RTF 메저 DELETE(MF) · 4rb7702gb1zjm MAX(PLAN_ID) · 3g9x8t27cmu5k VMI_MST_MAIN INSERT(구판 텍스트)
 * 스냅샷 1시간 단위라 00시 실행은 00:00~01:00 스냅샷에 들어간다. 10-01 이전은 보존 만료로 비어 있을 수 있음.                                  */
WITH ids AS (
    SELECT h.sql_id, COUNT(*) AS samples
      FROM dba_hist_active_sess_history h
     WHERE h.sample_time >= SYSDATE - 8 AND h.dbid = h.con_dbid
       AND h.module = 'DBMS_SCHEDULER' AND h.action LIKE 'JOB_PR_DM_PLN_MKT_FCST%'
       AND (h.plsql_entry_object_id IN (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING'))
            OR h.sql_id IN ('630stwpcj5tr1', '242jv1rzat1x7', '3yvf4k3w1tpc6', 'bdywpw9bh169n', '259ukvubwgd34', '4rb7702gb1zjm', '3g9x8t27cmu5k'))
     GROUP BY h.sql_id
)
SELECT 'C10 | ' || t.sql_id || ' | ' || TO_CHAR(sn.begin_interval_time, 'MM-DD HH24') || 'h | exec=' || LPAD(SUM(t.executions_delta), 3)
    || ' | rows=' || LPAD(SUM(t.rows_processed_delta), 9) || ' | elapsed=' || LPAD(ROUND(SUM(t.elapsed_time_delta) / 1e6), 5) || 's'
    || ' | cpu=' || LPAD(ROUND(SUM(t.cpu_time_delta) / 1e6), 5) || 's | gets=' || LPAD(SUM(t.buffer_gets_delta), 11)
    || ' | ' || SUBSTR(REPLACE(REPLACE((SELECT DBMS_LOB.SUBSTR(x.sql_text, 70, 1) FROM dba_hist_sqltext x WHERE x.sql_id = t.sql_id AND x.dbid = x.con_dbid AND ROWNUM = 1), CHR(10), ' '), CHR(13), ' '), 1, 70) AS line
  FROM dba_hist_sqlstat t
  JOIN dba_hist_snapshot sn ON sn.snap_id = t.snap_id AND sn.dbid = t.dbid AND sn.instance_number = t.instance_number
  JOIN ids ON ids.sql_id = t.sql_id
 WHERE t.dbid = t.con_dbid AND t.parsing_schema_name = 'SCM_MGR'
   AND sn.begin_interval_time >= SYSDATE - 8
   AND t.module = 'DBMS_SCHEDULER'
 GROUP BY t.sql_id, TO_CHAR(sn.begin_interval_time, 'MM-DD HH24')
HAVING SUM(t.executions_delta) > 0
 ORDER BY t.sql_id, TO_CHAR(sn.begin_interval_time, 'MM-DD HH24');

-- SPOOL OFF
