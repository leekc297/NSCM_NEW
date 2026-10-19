/* =====================================================================================================
 * 03_sales_plan_weekly_rolling_40_diag.sql — 잡 JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40 이력·소요 진단 (행당 한 줄 출력, 조회 전용)
 *
 * 잡 정의(사내 2026-10-08 확인, 클라우드는 S1 로 재확인):
 *   step 1  RTF Check : SCP_PLN_RTF_ALLOCATION_V 에 당주 월요일 PLAN 없으면 ERROR 로그('40 Final Plan NULL', PROGRAM_NAME=PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE) 후 RAISE -20001 → 잡 FAILED
 *   step 2  PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE('40', NULL, NULL)  → COMMIT
 *   스케줄(사내): TUE 16:30 / 16:40 / 18:00, WED 17:00, THU 12:00
 *
 * step 2 SP 의 로그 구조 (PR_SCM_SYS_LOG_BATCH → SCM_SYS_LOG_BATCH, CREATED_BY='scm_batch' 고정):
 *   PROGRAM_NAME 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE' · START/END DESCRIPTION '@p_division_id : 40' · ING 1건 'SALES_PLAN WEEKLY CUTOFF'(버전 정보)
 *   ERROR = SQLERRM + IN_PARA_DATA JSON · INVALID(82/81 전용)
 *   호출 순서(원문 줄): L155 PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW('40','SYSTEM') → L160 PR_DM_PLN_VERSION_CREATE → L213 ING → L225 PR_SCM_MST_FUTURE_PRICE_CUTOFF
 *                     → L227 PR_DM_MST_EXCHANGE_RATE_CUTOFF → L228~L1950 본체(로그 없음: Sales Plan Cutoff 적재·BALANCE·81 분기) → L1954 PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND → END
 *   하위 SP 중 VERSION_CREATE / FUTURE_PRICE_CUTOFF / EXCHANGE_RATE_CUTOFF 는 DESCRIPTION 이 비어 있어 사업부로 못 가른다 → 실행 구간 안 + created_by 'scm_batch' 로 묶음
 *     (같은 시각에 다른 사업부 Cutoff 가 겹치면 섞일 수 있음 — S4 의 at_time 으로 식별)
 *
 * 기간: 최근 8주 (TRUNC(SYSDATE,'IW') - 56). 바꾸려면 각 블록의 w 를 수정.
 * ===================================================================================================== */
SET PAGESIZE 0 LINESIZE 400 TRIMSPOOL ON TRIMOUT ON FEEDBACK OFF HEADING OFF VERIFY OFF LONG 4000
-- SPOOL sales_plan_wr40_diag.txt

/* ---------- S1. 잡 정의·스케줄·상태 ---------- */
SELECT 'S1-def | ' || j.job_name || ' | enabled=' || j.enabled || ' | ' || j.state || ' | runs=' || j.run_count || ' | fails=' || j.failure_count
    || ' | last=' || TO_CHAR(j.last_start_date, 'MM-DD HH24:MI') || ' | last_dur=' || j.last_run_duration || ' | next=' || TO_CHAR(j.next_run_date, 'MM-DD HH24:MI')
    || ' | sched=' || NVL(j.schedule_name, j.repeat_interval) || ' | log=' || j.logging_level AS line
  FROM all_scheduler_jobs j WHERE j.owner = 'SCM_MGR' AND j.job_name = 'JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40';

SELECT 'S1-sch | ' || s.schedule_name || ' | ' || s.repeat_interval AS line
  FROM all_scheduler_schedules s WHERE s.owner = 'SCM_MGR' AND s.schedule_name LIKE 'SCH_JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40%' ORDER BY 1;


/* ---------- S2. 잡 실행 이력 (DB 스케줄러 기록) — 전체 소요시간 ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 56 AS from_dt FROM dual)
SELECT 'S2 | ' || TO_CHAR(d.actual_start_date, 'MM-DD Dy HH24:MI:SS') || ' | ' || RPAD(d.status, 9) || ' | dur=' || d.run_duration
    || ' | ' || LPAD(ROUND(EXTRACT(HOUR FROM d.run_duration) * 3600 + EXTRACT(MINUTE FROM d.run_duration) * 60 + EXTRACT(SECOND FROM d.run_duration)), 6) || 's'
    || ' | cpu=' || d.cpu_used || ' | err=' || d.error# || ' | sess=' || d.session_id || ' | ' || SUBSTR(REPLACE(REPLACE(d.additional_info, CHR(10), ' '), CHR(13), ' '), 1, 160) AS line
  FROM all_scheduler_job_run_details d, w
 WHERE d.owner = 'SCM_MGR' AND d.job_name = 'JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40' AND d.actual_start_date >= w.from_dt
 ORDER BY d.actual_start_date;

SELECT 'S2-log | ' || TO_CHAR(g.log_date, 'MM-DD HH24:MI:SS') || ' | ' || g.operation || ' | ' || g.status || ' | ' || g.user_name || ' | ' || SUBSTR(g.additional_info, 1, 150) AS line
  FROM all_scheduler_job_log g, (SELECT TRUNC(SYSDATE, 'IW') - 56 AS from_dt FROM dual) w
 WHERE g.owner = 'SCM_MGR' AND g.job_name = 'JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40' AND g.log_date >= w.from_dt
 ORDER BY g.log_date;


/* ---------- S3. step 2 SP 실행 목록 (로그 기준) — 실행별 시작/종료/소요/상태 ----------
 * step 1 실패(Final Plan NULL)는 START 없이 ERROR 1행만 남는다 → 별도 행(run_no=0) 으로 표시                                    */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 56 AS from_dt FROM dual)
, l AS (
    SELECT l.log_type, l.log_message, l.description, l.event_date, l.created_by, l.sql_err_code, l.in_para_data
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
       AND l.event_date >= w.from_dt
       AND (REGEXP_LIKE(l.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i')          -- START/END/ING
            OR l.in_para_data LIKE '%"p_division_id":"40"%'                                 -- ERROR (JSON)
            OR l.log_message LIKE '40 Final Plan NULL%')                                    -- step 1 RTF Check 실패
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' OR log_message LIKE '% Final Plan NULL%' THEN 1 ELSE 0 END) OVER (ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
SELECT 'S3 | run=' || run_no
    || ' | ' || TO_CHAR(MIN(event_date), 'MM-DD Dy HH24:MI:SS') || ' ~ ' || TO_CHAR(MAX(CASE WHEN log_type IN ('END', 'ERROR', 'INVALID') THEN event_date END), 'HH24:MI:SS')
    || ' | ' || ROUND((MAX(CASE WHEN log_type IN ('END', 'ERROR', 'INVALID') THEN event_date END) - MIN(CASE WHEN log_type = 'START' THEN event_date END)) * 1440, 1) || 'min'
    || ' | ' || CASE WHEN MAX(CASE WHEN log_type = 'ERROR' THEN 1 ELSE 0 END) = 1 THEN 'ERROR'
                     WHEN MAX(CASE WHEN log_type = 'INVALID' THEN 1 ELSE 0 END) = 1 THEN 'INVALID'
                     WHEN MAX(CASE WHEN log_type = 'END' THEN 1 ELSE 0 END) = 1 THEN 'END' ELSE 'OPEN' END
    || ' | ING=' || SUM(CASE WHEN log_type = 'ING' THEN 1 ELSE 0 END)
    || ' | ' || NVL(MAX(CASE WHEN log_type = 'ING' THEN SUBSTR(description, 1, 90) END), '-')
    || ' | ' || NVL(MAX(CASE WHEN log_type = 'ERROR' THEN sql_err_code || ' ' || SUBSTR(log_message, 1, 100) || ' @' || REGEXP_SUBSTR(description, 'line [0-9]+') END), '-') AS line
  FROM s
 GROUP BY run_no
 ORDER BY MIN(event_date);


/* ---------- S4. 실행별 세션(하위 SP) 타임라인 — 각 하위 SP 의 START/END 와 간격 ----------
 * MARKER : SPC=PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE 자신 · KRW=AMT_CREATE_LOCAL_KRW · VER=VERSION_CREATE · FPC=FUTURE_PRICE_CUTOFF · FXC=EXCHANGE_RATE_CUTOFF · MAIL=IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND
 * GAP_SEC = 직전 로그와 간격. SECTION = 그 간격 동안 수행된 구간. 같은 초의 여러 로그는 호출 순서(START→KRW→VER→ING→FPC→FXC→MAIL→END)로 정렬.                                                                                                      */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 56 AS from_dt FROM dual)
, l AS (
    SELECT l.log_type, l.log_message, l.description, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE' AND l.event_date >= w.from_dt
       AND (REGEXP_LIKE(l.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i') OR l.in_para_data LIKE '%"p_division_id":"40"%')
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, run AS (
    SELECT run_no, MIN(CASE WHEN log_type = 'START' THEN event_date END) AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR', 'INVALID') THEN event_date END)
             , NVL(LEAD(MIN(CASE WHEN log_type = 'START' THEN event_date END)) OVER (ORDER BY run_no) - 1 / 86400, MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1)) AS run_end
      FROM s WHERE run_no > 0 GROUP BY run_no
)
, t AS (
    SELECT run_no, 'SPC' AS prog, log_type, log_message, description, event_date, ord FROM s WHERE run_no > 0
    UNION ALL
    SELECT run.run_no
         , CASE WHEN c.program_name = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' THEN 'KRW'
                WHEN c.program_name = 'PR_DM_PLN_VERSION_CREATE' THEN 'VER'
                WHEN c.program_name = 'PR_SCM_MST_FUTURE_PRICE_CUTOFF' THEN 'FPC'
                WHEN c.program_name = 'PR_DM_MST_EXCHANGE_RATE_CUTOFF' THEN 'FXC'
                WHEN c.program_name LIKE 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND%' THEN 'MAIL' END
         , c.log_type, c.log_message, c.description, c.event_date, CASE c.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END
      FROM run JOIN SCM_MGR.SCM_SYS_LOG_BATCH c
        ON c.event_date BETWEEN run.run_start AND run.run_end
       AND c.created_by = 'scm_batch'
       AND (   (c.program_name = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' AND REGEXP_LIKE(c.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i'))
            OR c.program_name IN ('PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF')
            OR c.program_name LIKE 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND%')
       AND c.log_type IN ('START', 'END', 'ERROR', 'INVALID', 'ING')
)
, x AS (
    SELECT t.*, prog || ':' || CASE WHEN log_type = 'ING' THEN 'ING' ELSE log_type END AS marker
         , ROUND((event_date - LAG(event_date) OVER (PARTITION BY run_no ORDER BY event_date, CASE prog || ':' || log_type WHEN 'SPC:START' THEN 0 WHEN 'KRW:START' THEN 1 WHEN 'KRW:END' THEN 2 WHEN 'VER:START' THEN 3 WHEN 'VER:END' THEN 4 WHEN 'SPC:ING' THEN 5 WHEN 'FPC:START' THEN 6 WHEN 'FPC:END' THEN 7 WHEN 'FXC:START' THEN 8 WHEN 'FXC:END' THEN 9 WHEN 'MAIL:START' THEN 10 WHEN 'MAIL:END' THEN 11 WHEN 'SPC:END' THEN 12 ELSE 13 END)) * 86400) AS gap_sec
         , LAG(prog || ':' || log_type) OVER (PARTITION BY run_no ORDER BY event_date, CASE prog || ':' || log_type WHEN 'SPC:START' THEN 0 WHEN 'KRW:START' THEN 1 WHEN 'KRW:END' THEN 2 WHEN 'VER:START' THEN 3 WHEN 'VER:END' THEN 4 WHEN 'SPC:ING' THEN 5 WHEN 'FPC:START' THEN 6 WHEN 'FPC:END' THEN 7 WHEN 'FXC:START' THEN 8 WHEN 'FXC:END' THEN 9 WHEN 'MAIL:START' THEN 10 WHEN 'MAIL:END' THEN 11 WHEN 'SPC:END' THEN 12 ELSE 13 END) AS prev_marker
         , MIN(event_date) OVER (PARTITION BY run_no) AS run_start
      FROM t
)
SELECT 'S4 | run=' || run_no || ' ' || TO_CHAR(run_start, 'MM-DD HH24:MI') || ' | ' || TO_CHAR(event_date, 'HH24:MI:SS') || ' | ' || RPAD(NVL(prev_marker, '-') || '->' || marker, 22) || ' | gap=' || LPAD(NVL(TO_CHAR(gap_sec), '-'), 5) || 's'
    || ' | ' || CASE marker
         WHEN 'SPC:START'  THEN '시작'
         WHEN 'KRW:START'  THEN 'SPC L100~155 변수·82/81 모델체크 → KRW 호출'
         WHEN 'KRW:END'    THEN 'KRW 본체 (금액 생성)'
         WHEN 'VER:START'  THEN 'KRW 복귀 → L160 VERSION_CREATE 호출'
         WHEN 'VER:END'    THEN 'VERSION_CREATE 본체'
         WHEN 'SPC:ING'    THEN 'L160~213 버전 확정 (' || SUBSTR(description, 1, 80) || ')'
         WHEN 'FPC:START'  THEN 'L213~225'
         WHEN 'FPC:END'    THEN 'FUTURE_PRICE_CUTOFF 본체'
         WHEN 'FXC:START'  THEN 'L225~227'
         WHEN 'FXC:END'    THEN 'EXCHANGE_RATE_CUTOFF 본체'
         WHEN 'MAIL:START' THEN '★ L228~1950 Sales Plan Cutoff 본체 (로그 없음 — SQL 단위는 S6 ASH 로)'
         WHEN 'MAIL:END'   THEN 'MAIL_SEND 본체'
         WHEN 'SPC:END'    THEN '종료'
         WHEN 'SPC:ERROR'  THEN '예외: ' || SUBSTR(log_message, 1, 100) || ' @' || REGEXP_SUBSTR(description, 'line [0-9]+')
         ELSE SUBSTR(log_message, 1, 60) END AS line
  FROM x
 ORDER BY run_no, event_date, CASE prog || ':' || log_type WHEN 'SPC:START' THEN 0 WHEN 'KRW:START' THEN 1 WHEN 'KRW:END' THEN 2 WHEN 'VER:START' THEN 3 WHEN 'VER:END' THEN 4 WHEN 'SPC:ING' THEN 5 WHEN 'FPC:START' THEN 6 WHEN 'FPC:END' THEN 7 WHEN 'FXC:START' THEN 8 WHEN 'FXC:END' THEN 9 WHEN 'MAIL:START' THEN 10 WHEN 'MAIL:END' THEN 11 WHEN 'SPC:END' THEN 12 ELSE 13 END;


/* ---------- S5. 구간별 집계 (전 실행 합산) — 어느 세션이 큰가 ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 56 AS from_dt FROM dual)
, l AS (
    SELECT l.log_type, l.log_message, l.description, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE' AND l.event_date >= w.from_dt
       AND (REGEXP_LIKE(l.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i') OR l.in_para_data LIKE '%"p_division_id":"40"%')
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, run AS (
    SELECT run_no, MIN(CASE WHEN log_type = 'START' THEN event_date END) AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR', 'INVALID') THEN event_date END)
             , NVL(LEAD(MIN(CASE WHEN log_type = 'START' THEN event_date END)) OVER (ORDER BY run_no) - 1 / 86400, MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1)) AS run_end
      FROM s WHERE run_no > 0 GROUP BY run_no
)
, t AS (
    SELECT run_no, 'SPC' AS prog, log_type, log_message, event_date, ord FROM s WHERE run_no > 0
    UNION ALL
    SELECT run.run_no
         , CASE WHEN c.program_name = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' THEN 'KRW' WHEN c.program_name = 'PR_DM_PLN_VERSION_CREATE' THEN 'VER'
                WHEN c.program_name = 'PR_SCM_MST_FUTURE_PRICE_CUTOFF' THEN 'FPC' WHEN c.program_name = 'PR_DM_MST_EXCHANGE_RATE_CUTOFF' THEN 'FXC' ELSE 'MAIL' END
         , c.log_type, c.log_message, c.event_date, CASE c.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END
      FROM run JOIN SCM_MGR.SCM_SYS_LOG_BATCH c
        ON c.event_date BETWEEN run.run_start AND run.run_end AND c.created_by = 'scm_batch'
       AND (   (c.program_name = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' AND REGEXP_LIKE(c.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i'))
            OR c.program_name IN ('PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF')
            OR c.program_name LIKE 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND%')
       AND c.log_type IN ('START', 'END', 'ERROR', 'INVALID', 'ING')
)
, g AS (
    SELECT run_no, prog, log_type, prog || ':' || log_type AS marker
         , LAG(prog || ':' || log_type) OVER (PARTITION BY run_no ORDER BY event_date, CASE prog || ':' || log_type WHEN 'SPC:START' THEN 0 WHEN 'KRW:START' THEN 1 WHEN 'KRW:END' THEN 2 WHEN 'VER:START' THEN 3 WHEN 'VER:END' THEN 4 WHEN 'SPC:ING' THEN 5 WHEN 'FPC:START' THEN 6 WHEN 'FPC:END' THEN 7 WHEN 'FXC:START' THEN 8 WHEN 'FXC:END' THEN 9 WHEN 'MAIL:START' THEN 10 WHEN 'MAIL:END' THEN 11 WHEN 'SPC:END' THEN 12 ELSE 13 END) AS prev_marker
         , (event_date - LAG(event_date) OVER (PARTITION BY run_no ORDER BY event_date, CASE prog || ':' || log_type WHEN 'SPC:START' THEN 0 WHEN 'KRW:START' THEN 1 WHEN 'KRW:END' THEN 2 WHEN 'VER:START' THEN 3 WHEN 'VER:END' THEN 4 WHEN 'SPC:ING' THEN 5 WHEN 'FPC:START' THEN 6 WHEN 'FPC:END' THEN 7 WHEN 'FXC:START' THEN 8 WHEN 'FXC:END' THEN 9 WHEN 'MAIL:START' THEN 10 WHEN 'MAIL:END' THEN 11 WHEN 'SPC:END' THEN 12 ELSE 13 END)) * 86400 AS gap_sec
      FROM t
)
SELECT 'S5 | ' || RPAD(prev_marker || '->' || marker, 22) || ' | runs=' || COUNT(*) || ' | total=' || LPAD(ROUND(SUM(gap_sec)), 6) || 's | avg=' || LPAD(ROUND(AVG(gap_sec)), 5) || 's | max=' || LPAD(ROUND(MAX(gap_sec)), 5) || 's'
    || ' | ' || LPAD(ROUND(RATIO_TO_REPORT(SUM(gap_sec)) OVER () * 100, 1), 5) || '% | per_run=' || LISTAGG(ROUND(gap_sec), ',') WITHIN GROUP (ORDER BY run_no) AS line
  FROM g WHERE prev_marker IS NOT NULL
 GROUP BY prev_marker || '->' || marker
 ORDER BY SUM(gap_sec) DESC;


/* ---------- S6. (AWR 권한) 잡 세션의 SQL × 플랜라인 × 대기 — 로그 없는 본체(L228~1950) 안의 병목 문장 (최근 8일 보존 범위) ----------
 * 잡 세션 = MODULE 'DBMS_SCHEDULER' / ACTION = 잡 이름. 10초 샘플 1건 ≈ 10초. CDB/PDB 2벌 보존 → dbid=con_dbid 1벌만.                   */
SELECT 'S6 | ' || h.sql_id || ' | phv=' || h.sql_plan_hash_value || ' | line=' || h.sql_plan_line_id || ' ' || RPAD(NVL(h.sql_plan_operation || ' ' || h.sql_plan_options, '-'), 28)
    || ' | ' || RPAD(NVL(h.event, 'ON CPU'), 26) || ' | ' || LPAD(COUNT(*) * 10, 6) || 's ' || LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1), 5) || '%'
    || ' | ' || MIN(TO_CHAR(h.sample_time, 'MM-DD HH24:MI')) || '~' || MAX(TO_CHAR(h.sample_time, 'MM-DD HH24:MI'))
    || ' | in=' || NVL((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_entry_object_id), '-')
    || ' | sess=' || LISTAGG(DISTINCT h.session_id || ',' || h.session_serial#, ' ') WITHIN GROUP (ORDER BY h.session_id) AS line
  FROM dba_hist_active_sess_history h
 WHERE h.sample_time >= SYSDATE - 8 AND h.dbid = h.con_dbid
   AND h.module = 'DBMS_SCHEDULER' AND h.action = 'JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40'
 GROUP BY h.sql_id, h.sql_plan_hash_value, h.sql_plan_line_id, h.sql_plan_operation || ' ' || h.sql_plan_options, NVL(h.event, 'ON CPU'), h.plsql_entry_object_id
 ORDER BY COUNT(*) DESC
 FETCH FIRST 30 ROWS ONLY;

-- S6-txt. 상위 sql_id 원문 앞부분
WITH top AS (
    SELECT h.sql_id, COUNT(*) AS cnt FROM dba_hist_active_sess_history h
     WHERE h.sample_time >= SYSDATE - 8 AND h.dbid = h.con_dbid AND h.module = 'DBMS_SCHEDULER' AND h.action = 'JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40'
     GROUP BY h.sql_id ORDER BY COUNT(*) DESC FETCH FIRST 12 ROWS ONLY
)
SELECT 'S6-txt | ' || t.sql_id || ' | ' || t.cnt * 10 || 's | ' || REPLACE(REPLACE(SUBSTR(DBMS_LOB.SUBSTR(x.sql_text, 400, 1), 1, 400), CHR(10), ' '), CHR(13), ' ') AS line
  FROM top t LEFT JOIN dba_hist_sqltext x ON x.sql_id = t.sql_id AND x.dbid = x.con_dbid
 ORDER BY t.cnt DESC;

-- SPOOL OFF
