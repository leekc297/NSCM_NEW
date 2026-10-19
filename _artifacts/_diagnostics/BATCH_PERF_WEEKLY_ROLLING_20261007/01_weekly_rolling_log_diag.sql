/* =====================================================================================================
 * 배치 속도 진단 — PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING('40', 'MKT FCST Weekly Cutoff', 'MF_W', 'Weekly Rolling', 'system')
 * 대상 로그 : SCM_MGR.SCM_SYS_LOG_BATCH (PR_SCM_SYS_LOG_BATCH / PR_DM_SYS_LOG_BATCH 가 적재)
 *             PROGRAM_NAME = SP 이름 · LOG_TYPE = START / END / ERROR / INVALID / (단계 메시지)
 *             DESCRIPTION  = 'Div: 40 / MF_W' 형식 · EVENT_DATE = 기록 시각 · CREATED_BY = 실행 계정
 * 기간     : 전주 월요일 00:00 ~ 전주 목요일 24:00  (= 이번 주 월요일 TRUNC(SYSDATE,'IW') 기준 -7일 ~ -3일)
 *             다른 기간을 보려면 각 쿼리의 W(윈도) 에서 두 날짜를 직접 바꾼다.
 * 조회 전용 — DB 변경 없음. 클라우드에서 SCM_MGR 또는 SCM_SYS_LOG_BATCH 조회 권한 계정으로 실행.
 * 주의     : SCM_SYS_LOG_BATCH 에 인덱스가 없어 전부 풀스캔 — 기간을 넓히면 느려진다.
 * ===================================================================================================== */

/* ---------- Q0. 기간 확인 ---------- */
SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt            -- 전주 월요일 00:00
     , TRUNC(SYSDATE, 'IW') - 3 AS to_dt_exclusive    -- 전주 금요일 00:00 (목요일 24:00)
  FROM dual;


/* ---------- Q1. 루트 SP 실행 목록 — 실행별 시작/종료/소요/상태 ----------
 * 같은 PROGRAM_NAME + DESCRIPTION(사업부) 의 START 다음에 오는 END/ERROR 를 짝지어 소요를 구한다.
 * 상태 '미종료' = START 뒤에 END/ERROR 가 없음(중단·타임아웃·세션 kill 의심).            */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, l AS (
    SELECT l.program_name, l.description, l.log_type, l.event_date, l.created_by, l.log_message
         , LEAD(l.log_type)   OVER (PARTITION BY l.program_name, l.description ORDER BY l.event_date, l.creation_date) AS next_type
         , LEAD(l.event_date) OVER (PARTITION BY l.program_name, l.description ORDER BY l.event_date, l.creation_date) AS next_date
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
SELECT program_name
     , description                                        AS div_ver
     , TO_CHAR(event_date, 'YYYY-MM-DD HH24:MI:SS')       AS start_time
     , TO_CHAR(next_date,  'YYYY-MM-DD HH24:MI:SS')       AS end_time
     , ROUND((next_date - event_date) * 24 * 60, 1)       AS elapsed_min
     , CASE WHEN next_type IN ('END', 'ERROR', 'INVALID') THEN next_type ELSE '미종료' END AS status
     , created_by
  FROM l
 WHERE log_type = 'START'
 ORDER BY event_date;


/* ---------- Q2. 실행 1건의 단계별 타임라인 — 어느 단계에서 시간이 가는가 ----------
 * 루트 START~END 구간 안에 기록된 모든 배치 로그(하위 SP 포함)를 시간순으로 놓고,
 * 직전 로그와의 간격(gap_sec)을 구한다. gap 이 큰 행 = 그 직전 구간이 오래 걸린 단계.
 * 40 사업부만 보려면 r.description LIKE 'Div: 40%' 유지, 전체면 그 조건을 지운다.           */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, r AS (   -- 루트 실행 구간
    SELECT l.description, l.event_date AS run_start
         , LEAD(l.event_date) OVER (PARTITION BY l.description ORDER BY l.event_date) AS run_end
         , l.log_type
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING'
       AND l.description LIKE 'Div: 40%'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, run AS (SELECT description, run_start, NVL(run_end, run_start + 1) AS run_end FROM r WHERE log_type = 'START')
, t AS (
    SELECT run.description AS run_div, run.run_start
         , l.program_name, l.log_type, l.log_count, l.log_message, l.description, l.event_date
         , l.sql_err_code, l.sql_err_msg
      FROM run
      JOIN SCM_MGR.SCM_SYS_LOG_BATCH l
        ON l.event_date >= run.run_start AND l.event_date <= run.run_end
       AND l.created_by = (SELECT created_by FROM SCM_MGR.SCM_SYS_LOG_BATCH x
                            WHERE x.program_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND x.event_date = run.run_start AND ROWNUM = 1)
)
SELECT run_div
     , TO_CHAR(run_start, 'MM-DD HH24:MI')                 AS run_id
     , TO_CHAR(event_date, 'HH24:MI:SS')                   AS at_time
     , ROUND((event_date - LAG(event_date) OVER (PARTITION BY run_start ORDER BY event_date)) * 86400) AS gap_sec
     , ROUND((event_date - run_start) * 60 * 24, 1)        AS min_from_start
     , program_name, log_type, log_count
     , SUBSTR(log_message, 1, 120)                         AS log_message
     , description
     , sql_err_code
  FROM t
 ORDER BY run_start, event_date;


/* ---------- Q3. 하위 SP 별 소요 집계 — 병목 SP 순위 ----------
 * 기간 안의 모든 배치 SP 에 대해 START→END 짝으로 소요를 구하고, SP 별 합계·최대·호출 수를 낸다.
 * WEEKLY_ROLLING 이 부르는 SP: VERSION_CREATE / FUTURE_PRICE_CUTOFF / LASTEST_MEASURE / QTY_BALANCE_CREATE
 *   / AMT_CREATE_LOCAL_KRW / TO_NET_DEMAND / DEMANDID_PEGGING(_SECTION_SUM) / SALES_PLAN_CUTOFF / CUTOFF_MAIL_SEND
 *   / EXCHANGE_RATE_CUTOFF / DNM_CREATE_WS_RTF / MKT_FCST_C_QTY_BALANCE_CREATE / SALES_PLAN_C_QTY_BALANCE_CREATE … */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, r AS (   -- 루트 실행 구간 (40 사업부)
    SELECT l.description, l.created_by, l.event_date AS run_start
         , LEAD(l.event_date) OVER (PARTITION BY l.description ORDER BY l.event_date) AS run_end, l.log_type
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND l.description LIKE 'Div: 40%'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, run AS (SELECT description, created_by, run_start, NVL(run_end, run_start + 1) AS run_end FROM r WHERE log_type = 'START')
, l AS (   -- 루트 구간 안에 같은 계정으로 기록된 하위 SP 로그만
    SELECT run.run_start, l.program_name, l.description, l.log_type, l.event_date
         , LEAD(l.log_type)   OVER (PARTITION BY run.run_start, l.program_name, l.description ORDER BY l.event_date, l.creation_date) AS next_type
         , LEAD(l.event_date) OVER (PARTITION BY run.run_start, l.program_name, l.description ORDER BY l.event_date, l.creation_date) AS next_date
      FROM run
      JOIN SCM_MGR.SCM_SYS_LOG_BATCH l
        ON l.event_date >= run.run_start AND l.event_date <= run.run_end AND l.created_by = run.created_by
       AND l.log_type IN ('START', 'END', 'ERROR', 'INVALID')
       -- 호출 체인만 (같은 시간대에 같은 계정으로 도는 메일·SMS 배치 로그 제외). 전부 보려면 이 IN 조건을 지운다
       AND l.program_name IN ('PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF'
                            , 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_PLN_MKT_FCST_LASTEST_MEASURE'
                            , 'PR_DM_PLN_MKT_FCST_TO_NET_DEMAND', 'PR_DM_PLN_DEMANDID_PEGGING', 'PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM'
                            , 'PR_DM_PLN_SALES_PLAN_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF', 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF'
                            , 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND'
                            , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_MKT_FCST_KPI', 'PR_DM_PLN_MKT_FCST_KPI_CFCR', 'PR_DM_TO_XIF_DM_PLN_MKT_FCST_C')
)
SELECT program_name
     , COUNT(*)                                            AS runs
     , ROUND(SUM((next_date - event_date) * 24 * 60), 1)   AS total_min
     , ROUND(MAX((next_date - event_date) * 24 * 60), 1)   AS max_min
     , ROUND(AVG((next_date - event_date) * 24 * 60), 1)   AS avg_min
     , SUM(CASE WHEN next_type <> 'END' THEN 1 ELSE 0 END) AS not_ended
     , MIN(TO_CHAR(event_date, 'MM-DD HH24:MI'))           AS first_start
     , LISTAGG(DISTINCT description, ' | ') WITHIN GROUP (ORDER BY description) AS descriptions
  FROM l
 WHERE log_type = 'START' AND next_date IS NOT NULL
 GROUP BY program_name
 ORDER BY total_min DESC;


/* ---------- Q4. 오류·INVALID·경고 — 기간 안 전체 ---------- */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
SELECT TO_CHAR(l.event_date, 'YYYY-MM-DD HH24:MI:SS') AS at_time
     , l.program_name, l.log_type, l.description
     , SUBSTR(l.log_message, 1, 200)                   AS log_message
     , l.sql_err_code, SUBSTR(l.sql_err_msg, 1, 200)   AS sql_err_msg
     , SUBSTR(l.sql_backtrace, 1, 200)                 AS backtrace
     , l.created_by
  FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
 WHERE l.event_date >= w.from_dt AND l.event_date < w.to_dt
   AND (l.log_type IN ('ERROR', 'INVALID', 'WARNING') OR l.sql_err_code IS NOT NULL)
 ORDER BY l.event_date;


/* ---------- Q5. 최근 8주 추이 — 루트 SP 사업부별 소요(분) ----------
 * 속도 개선 전후 비교 기준선. 주차 = ISO 주 월요일 날짜.                                   */
WITH l AS (
    SELECT l.description, l.log_type, l.event_date
         , LEAD(l.log_type)   OVER (PARTITION BY l.description ORDER BY l.event_date, l.creation_date) AS next_type
         , LEAD(l.event_date) OVER (PARTITION BY l.description ORDER BY l.event_date, l.creation_date) AS next_date
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING'
       AND l.event_date >= TRUNC(SYSDATE, 'IW') - 56
)
SELECT TO_CHAR(TRUNC(event_date, 'IW'), 'YYYY-MM-DD') AS week_monday
     , description                                     AS div_ver
     , COUNT(*)                                        AS runs
     , ROUND(MAX((next_date - event_date) * 24 * 60), 1) AS max_min
     , ROUND(AVG((next_date - event_date) * 24 * 60), 1) AS avg_min
     , SUM(CASE WHEN next_type <> 'END' THEN 1 ELSE 0 END) AS not_ended
  FROM l
 WHERE log_type = 'START'
 GROUP BY TRUNC(event_date, 'IW'), description
 ORDER BY 1, 2;


/* ---------- Q6. (선택 · V$ 조회 권한이 있을 때만) 아직 공유풀에 남아 있는 무거운 SQL ----------
 * 배치 SP 안에서 실행된 SQL 의 누적 실행시간 상위. 공유풀에서 밀려났으면 안 나온다.
 * PROGRAM_ID 로 SP 를 특정: DBA_OBJECTS 권한이 없으면 마지막 JOIN 을 빼고 PROGRAM_ID 만 본다.          */
SELECT s.sql_id, s.plan_hash_value
     , s.executions
     , ROUND(s.elapsed_time / 1e6)                              AS elapsed_sec
     , ROUND(s.elapsed_time / NULLIF(s.executions, 0) / 1e6, 1) AS sec_per_exec
     , s.buffer_gets, s.disk_reads, s.rows_processed
     , TO_CHAR(TO_DATE(s.last_active_time, 'YYYY-MM-DD/HH24:MI:SS'), 'MM-DD HH24:MI') AS last_active
     , o.object_name                                            AS from_program
     , s.program_line#
     , SUBSTR(s.sql_text, 1, 150)                               AS sql_text
  FROM v$sqlarea s
  LEFT JOIN dba_objects o ON o.object_id = s.program_id
 WHERE s.parsing_schema_name = 'SCM_MGR'
   AND (o.object_name IN ('PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING', 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE'
                        , 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_DEMANDID_PEGGING', 'PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM'
                        , 'PR_DM_PLN_MKT_FCST_TO_NET_DEMAND', 'PR_DM_PLN_SALES_PLAN_CUTOFF', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF'
                        , 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_PLN_MKT_FCST_LASTEST_MEASURE', 'PR_DM_PLN_VERSION_CREATE'
                        , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND')
        OR o.object_name IS NULL AND s.program_id > 0)
   AND s.elapsed_time > 10 * 1e6
 ORDER BY s.elapsed_time DESC
 FETCH FIRST 40 ROWS ONLY;
