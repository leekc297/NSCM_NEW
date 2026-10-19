/* =====================================================================================================
 * 클라우드 배치 장시간(40분+) 실행 식별 — 2026-09-29(화) ~ 2026-10-01(목) 3일 로그
 *
 * 목적   : "지난주 BALANCE 배치 기동 시 40분 이상 소요" 가 어느 잡(DBMS_SCHEDULER JOB) / 어느 SP 호출이었는지 로그로 특정
 * 원천 1 : SCM_MGR.SCM_SYS_LOG_BATCH   — SP 가 직접 남기는 START / END / ERROR 로그 (PR_DM_SYS_LOG_BATCH · PR_SCM_SYS_LOG_BATCH 적재)
 *            PROGRAM_NAME = SP 이름 · EVENT_DATE = 기록 시각 · CREATED_BY = 세션 계정(PR_DM_) 또는 'scm_batch' 고정(PR_SCM_)
 *            IN_PARA_DATA / DESCRIPTION = 호출 인자(사업부·버전 등). 인덱스 없음 → 기간 넓히면 느려짐(3일이면 수 초)
 * 원천 2 : ALL_SCHEDULER_JOB_RUN_DETAILS / ALL_SCHEDULER_JOB_LOG — Oracle 스케줄러가 기록한 잡 단위 실행 이력(잡 이름 · RUN_DURATION · 세션)
 *            ⚠ 사내 정의 기준 모든 잡은 PLSQL_BLOCK 이고 다수 step 이 `EXCEPTION WHEN OTHERS THEN NULL` 로 감싸져 있어
 *              SP 가 실패해도 잡 STATUS 는 SUCCEEDED 로 남을 수 있다 → 잡 상태가 아니라 Q2 의 SP 로그 ERROR 로 판단
 * 원천 3 : (권한 있을 때) DBA_HIST_ACTIVE_SESS_HISTORY — 세션 단위 MODULE/ACTION(DBMS_SCHEDULER + 잡 이름) 으로 "잡 실행" vs "수동 실행(DBeaver 등)" 구분
 *
 * 왜 잡 이름만으로 못 찾는가 : 잡 이름에 BALANCE 가 들어간 잡은 없다(사내 126 잡 전수). BALANCE 를 실행하는 경로는 3 가지
 *   ① JOB_SCMPROD_PLAN_FINAL_40/81_CREATION      → PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(div, NULL) 직접 호출  (사내·클라우드 모두 DISABLED, runs=0 — 2026-10-07 확인)
 *   ② JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_*     → PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING(div, …, MF_D/MF_W/SF_W) 안에서 QTY_BALANCE_CREATE 호출 (매일 00시 TOTAL_MOBILE/TUE_TOTAL 등)
 *   ③ JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_*   → PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE(div)
 *   ④ 화면 CALL (PKG_DMF0003 등) / DBeaver 수동 실행 → 잡 이력 없음, SP 로그만 남음 (CREATED_BY = 사용자 계정)
 *   따라서 "모든 SP 의 START→END 를 짝지어 소요가 긴 것" 을 먼저 뽑고(Q2), 그 시간 구간을 잡 실행 이력(Q1)과 겹쳐서(Q3) 어느 잡인지 확정한다.
 *
 * 기간   : 2026-09-29 00:00 ~ 2026-10-02 00:00 (미포함) = 9/29 · 9/30 · 10/1
 *          09-28 에 시작해 09-29 로 넘어온 실행도 잡히도록 START 스캔은 09-28 00:00 부터, END 스캔은 10-03 00:00 까지(SCAN_FROM/SCAN_TO)
 *          다른 기간 : 모든 쿼리의 w 서브쿼리 날짜 4 개만 바꾼다.
 * 조회 전용 — DB 변경 없음. 클라우드 SCM_MGR(또는 SCM_SYS_LOG_BATCH 조회 + 잡 로그 조회 권한 계정)으로 실행.
 *          Q1 은 잡 소유 계정이 아니면 0행일 수 있음(ALL_ → DBA_ 로 바꾸면 전체). Q4 는 Diagnostics Pack / DBA_HIST 권한 필요(없으면 ORA-00942 — 무시).
 * ===================================================================================================== */

/* ---------- Q0. 기간 확인 ---------- */
SELECT TO_DATE('2026-09-29', 'YYYY-MM-DD') AS from_dt
     , TO_DATE('2026-10-02', 'YYYY-MM-DD') AS to_dt_exclusive
     , TO_DATE('2026-09-28', 'YYYY-MM-DD') AS scan_from
     , TO_DATE('2026-10-03', 'YYYY-MM-DD') AS scan_to
     , SYSDATE                             AS now_
  FROM dual;


/* ---------- Q1. 스케줄러 잡 실행 이력 — 3일 동안 돈 모든 잡, 소요 순 ----------
 * RUN_MIN ≥ 40 이 "40분 이상 걸린 잡". SESSION_ID('SID,SERIAL#') 는 Q4(ASH) 와 대조 키.
 * STATUS 는 PL/SQL 블록이 예외를 삼키면 SUCCEEDED 로 남으므로 참고만(실패 여부는 Q2 ERROR 로).
 * OWNER 를 걸지 않음 — 클라우드 잡 소유 계정이 SCM_MGR 이 아닐 수 있음. 보이는 행이 없으면 DBA_SCHEDULER_JOB_RUN_DETAILS 로 재실행. */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt FROM dual)
SELECT d.owner, d.job_name, d.status
     , TO_CHAR(d.actual_start_date, 'MM-DD(DY) HH24:MI:SS')                                                                     AS started
     , TO_CHAR(d.actual_start_date + d.run_duration, 'MM-DD HH24:MI:SS')                                                          AS ended
     , ROUND(EXTRACT(DAY FROM d.run_duration) * 1440 + EXTRACT(HOUR FROM d.run_duration) * 60
           + EXTRACT(MINUTE FROM d.run_duration) + EXTRACT(SECOND FROM d.run_duration) / 60, 1)                                   AS run_min
     , CASE WHEN d.run_duration >= INTERVAL '40' MINUTE THEN '◆ 40분+' END                                                       AS flag
     , d.session_id, d.error#, d.cpu_used
     , SUBSTR(d.additional_info, 1, 200)                                                                                           AS additional_info
     , SUBSTR(d.errors, 1, 300)                                                                                                    AS errors
  FROM all_scheduler_job_run_details d, w
 WHERE d.actual_start_date >= w.from_dt AND d.actual_start_date < w.to_dt
 ORDER BY d.run_duration DESC, d.actual_start_date;

-- Q1-b. 잡 로그(RUN 이벤트) — RUN_DETAILS 가 비었거나 STOPPED/아직 끝나지 않은 실행을 볼 때. 잡 정의도 같이(스케줄·ENABLED)
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt FROM dual)
SELECT TO_CHAR(g.log_date, 'MM-DD(DY) HH24:MI:SS') AS log_time, g.owner, g.job_name, g.operation, g.status, g.user_name
     , SUBSTR(g.additional_info, 1, 200)         AS additional_info
     , j.enabled, j.state, j.run_count, j.failure_count, SUBSTR(j.repeat_interval, 1, 80) AS repeat_interval
  FROM all_scheduler_job_log g
  LEFT JOIN all_scheduler_jobs j ON j.owner = g.owner AND j.job_name = g.job_name
  , w
 WHERE g.log_date >= w.from_dt AND g.log_date < w.to_dt
 ORDER BY g.log_date;


/* ---------- Q2. SP 실행 재구성 — 3일 동안 START 가 찍힌 모든 SP 의 소요(분), 긴 것부터 ----------
 * 짝짓기 : 같은 PROGRAM_NAME + CREATED_BY 안에서 시간순으로 START 다음에 오는 END/ERROR 를 종료로 본다(AS-IS PR_LONGTIME_CHK_SMS_SEND 와 같은 규칙).
 *          START 다음 행이 또 START 이면(같은 SP 가 겹쳐 돌거나 끝 로그 없이 재기동) STATUS = '미종료/중첩'.
 * 계층   : 상위 SP(WEEKLY_ROLLING)가 하위 SP(QTY_BALANCE_CREATE…)를 부르면 둘 다 각자 START/END 를 남기므로 둘 다 행으로 나온다.
 *          상위 소요 ⊇ 하위 소요. "40분" 이 어느 층에서 났는지는 Q5 타임라인으로 확인.
 * 인자   : START 행의 IN_PARA_DATA(JSON) 또는 DESCRIPTION('Div: 40 / MF_W', 'p_division_id : 40 / p_plan_id : NULL' 등)이 사업부·버전.
 * 임계값 : ELAPSED_MIN ≥ 10 만 표시(마지막 WHERE). 전부 보려면 그 조건을 지운다. 40분+ 는 FLAG 열. */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt
                , TO_DATE('2026-09-28','YYYY-MM-DD') AS scan_from, TO_DATE('2026-10-03','YYYY-MM-DD') AS scan_to FROM dual)
, l AS (
    SELECT l.program_name, l.created_by, l.log_type, l.event_date, l.creation_date
         , l.in_para_data, l.description, l.log_message, l.sql_err_code, l.sql_err_msg, l.sql_backtrace
         , CASE l.log_type WHEN 'START' THEN 0 ELSE 1 END AS ord          -- 같은 초에 START 와 END 가 찍히면 START 먼저
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.event_date >= w.scan_from AND l.event_date < w.scan_to
       AND l.log_type IN ('START', 'END', 'ERROR', 'error')               -- 'error' 소문자 = 로그 SP 자체 예외 행 · ING/INVALID/step 은 종료 아님
)
, s AS (
    SELECT l.*
         , LEAD(log_type)      OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
         , LEAD(event_date)    OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
         , LEAD(sql_err_code)  OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_err_code
         , LEAD(log_message)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_msg
         , LEAD(description)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_desc
         , LEAD(sql_backtrace) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_bt
      FROM l
)
, r AS (
    SELECT program_name, created_by
         , event_date                                                                              AS run_start
         , CASE WHEN next_type IN ('END', 'ERROR', 'error') THEN next_date END                     AS run_end
         , CASE WHEN next_type = 'END'                 THEN 'END'
                WHEN next_type IN ('ERROR', 'error')   THEN 'ERROR'
                WHEN next_type = 'START'               THEN '미종료/중첩'
                ELSE '미종료' END                                                                   AS status
         , next_type, next_err_code, next_msg, next_desc, next_bt
         , in_para_data, description
      FROM s
     WHERE log_type = 'START'
)
SELECT ROUND((run_end - run_start) * 1440, 1)                                                           AS elapsed_min
     , CASE WHEN (run_end - run_start) * 1440 >= 40 THEN '◆ 40분+' END                                   AS flag
     , program_name
     , CASE WHEN REGEXP_LIKE(program_name, 'BALANCE|WEEKLY_ROLLING|SALES_PLAN_CUTOFF|CREATE_WS_RTF|AMT_CREATE_LOCAL_KRW|SCP_ENG', 'i')
            THEN 'BALANCE 계열' END                                                                      AS chain
     , TO_CHAR(run_start, 'MM-DD(DY) HH24:MI:SS')                                                       AS start_time
     , TO_CHAR(run_end,   'MM-DD HH24:MI:SS')                                                           AS end_time
     , status, created_by
     , SUBSTR(NVL(in_para_data, description), 1, 120)                                                   AS start_params
     , next_err_code                                                                                     AS err_code
     , CASE WHEN status = 'ERROR' THEN SUBSTR(NVL(next_msg, next_desc), 1, 150) END                      AS err_msg
     , CASE WHEN status = 'ERROR' THEN SUBSTR(REGEXP_SUBSTR(NVL(next_bt, next_desc), 'line [0-9]+'), 1, 20) END AS err_line
  FROM r, w
 WHERE run_start < w.to_dt                                       -- 10-02 이후 시작 제외
   AND run_end >= w.from_dt                                      -- 09-29 전에 끝난 실행 제외(09-28 시작·09-29 종료는 포함). END/ERROR 로 닫힌 실행만(닫히지 않은 것은 Q2-c)
   AND (run_end - run_start) * 1440 >= 10
 ORDER BY elapsed_min DESC, run_start;


/* ---------- Q2-c. 종료 로그 없는 START — END/ERROR 없이 끊긴(세션 kill·타임아웃·예외 삼킴) 또는 같은 SP 가 겹쳐 돈 실행 ----------
 * 소요를 계산할 수 없어 Q2 에서 제외한 행. 40분+ 실행이 "끝 로그 없이" 끊겼다면 여기에 나온다(잡 소요는 Q1 RUN_DURATION 으로).
 * 화면 조회 SP(…GET…)는 동시 호출로 START 가 겹치는 것이 정상이라 제외. NEXT_START_MIN = 같은 SP·계정의 다음 START 까지 분(소요 상한 추정). */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt
                , TO_DATE('2026-09-28','YYYY-MM-DD') AS scan_from, TO_DATE('2026-10-03','YYYY-MM-DD') AS scan_to FROM dual)
, l AS (
    SELECT l.program_name, l.created_by, l.log_type, l.event_date, l.creation_date, l.in_para_data, l.description
         , CASE l.log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.event_date >= w.scan_from AND l.event_date < w.scan_to
       AND l.log_type IN ('START', 'END', 'ERROR', 'error')
)
, s AS (
    SELECT l.*
         , LEAD(log_type)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
         , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
      FROM l
)
SELECT TO_CHAR(event_date, 'MM-DD(DY) HH24:MI:SS')                                             AS start_time
     , program_name, created_by
     , CASE WHEN next_type = 'START' THEN '중첩(다음 로그가 START)' ELSE '미종료(이후 로그 없음)' END  AS status
     , ROUND((next_date - event_date) * 1440, 1)                                                AS next_start_min
     , SUBSTR(NVL(in_para_data, description), 1, 120)                                           AS start_params
  FROM s, w
 WHERE log_type = 'START'
   AND NVL(next_type, 'X') NOT IN ('END', 'ERROR', 'error')
   AND event_date >= w.from_dt AND event_date < w.to_dt
   AND NOT REGEXP_LIKE(program_name, '(^|_)GET_', 'i')
 ORDER BY event_date;


/* ---------- Q2-b. BALANCE 호출 체인 SP 만 — 소요 무관 전부 (짧은 정상 실행도 비교 기준으로) ---------- */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt
                , TO_DATE('2026-09-28','YYYY-MM-DD') AS scan_from, TO_DATE('2026-10-03','YYYY-MM-DD') AS scan_to FROM dual)
, l AS (
    SELECT l.program_name, l.created_by, l.log_type, l.event_date, l.creation_date, l.in_para_data, l.description, l.log_message, l.sql_err_code
         , CASE l.log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.event_date >= w.scan_from AND l.event_date < w.scan_to
       AND l.log_type IN ('START', 'END', 'ERROR', 'error')
       AND l.program_name IN ('PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING', 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
                            , 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                            , 'PR_DM_PLN_SALES_PLAN_CUTOFF', 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF'
                            , 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF'
                            , 'PR_DM_PLN_MKT_FCST_LASTEST_MEASURE', 'PR_DM_PLN_MKT_FCST_TO_NET_DEMAND', 'PR_DM_PLN_DEMANDID_PEGGING'
                            , 'PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND'
                            , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_CFM_TO_MKT_FCST_ALL', 'PR_DM_PLN_MKT_FCST_RESULT_MOVE'
                            , 'PR_DM_PLN_SALES_PLAN_RESULT_MOVE', 'PR_DM_MST_CUST_FCST_WEEKLY_ROLLING')
)
, s AS (
    SELECT l.*
         , LEAD(log_type)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
         , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
         , LEAD(sql_err_code) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_err_code
      FROM l
)
SELECT TO_CHAR(event_date, 'MM-DD(DY) HH24:MI:SS')                                                           AS start_time
     , TO_CHAR(CASE WHEN next_type IN ('END','ERROR','error') THEN next_date END, 'HH24:MI:SS')              AS end_time
     , ROUND((CASE WHEN next_type IN ('END','ERROR','error') THEN next_date END - event_date) * 1440, 1)   AS elapsed_min   -- 미종료/중첩 = NULL
     , CASE WHEN next_type = 'END' THEN 'END' WHEN next_type IN ('ERROR','error') THEN 'ERROR' WHEN next_type = 'START' THEN '미종료/중첩' ELSE '미종료' END AS status
     , program_name, created_by
     , SUBSTR(NVL(in_para_data, description), 1, 120)                                                         AS start_params
     , next_err_code                                                                                           AS err_code
  FROM s, w
 WHERE log_type = 'START'
   AND event_date < w.to_dt AND NVL(CASE WHEN next_type IN ('END','ERROR','error') THEN next_date END, w.scan_to) >= w.from_dt
 ORDER BY event_date;


/* ---------- Q3. 잡 ↔ SP 매칭 — 긴 SP 실행(Q2 조건)이 어느 잡의 실행 구간 안에서 돌았나 ----------
 * 잡 실행 구간 [ACTUAL_START_DATE, +RUN_DURATION] 안에 SP START 가 들어가면 그 잡이 호출 주체.
 * JOB_NAME 이 NULL 이면 어떤 잡 구간에도 안 들어감 = 수동 실행(DBeaver/SQL 툴) 또는 화면 CALL 또는 잡 소유자 권한 밖(Q1 참조). */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt
                , TO_DATE('2026-09-28','YYYY-MM-DD') AS scan_from, TO_DATE('2026-10-03','YYYY-MM-DD') AS scan_to FROM dual)
, l AS (
    SELECT l.program_name, l.created_by, l.log_type, l.event_date, l.creation_date, l.in_para_data, l.description
         , CASE l.log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.event_date >= w.scan_from AND l.event_date < w.scan_to
       AND l.log_type IN ('START', 'END', 'ERROR', 'error')
)
, s AS (
    SELECT l.*
         , LEAD(log_type)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
         , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
      FROM l
)
, r AS (
    SELECT program_name, created_by, event_date AS run_start
         , CASE WHEN next_type IN ('END','ERROR','error') THEN next_date END AS run_end
         , CASE WHEN next_type = 'END' THEN 'END' WHEN next_type IN ('ERROR','error') THEN 'ERROR' WHEN next_type = 'START' THEN '미종료/중첩' ELSE '미종료' END AS status
         , in_para_data, description
      FROM s WHERE log_type = 'START'
)
, j AS (
    SELECT d.owner, d.job_name, d.status AS job_status, d.session_id
         , CAST(d.actual_start_date AS DATE)                   AS job_start
         , CAST(d.actual_start_date + d.run_duration AS DATE)  AS job_end
      FROM all_scheduler_job_run_details d, w
     WHERE d.actual_start_date >= w.scan_from AND d.actual_start_date < w.scan_to
)
SELECT ROUND((r.run_end - r.run_start) * 1440, 1)                                     AS sp_elapsed_min
     , r.program_name
     , TO_CHAR(r.run_start, 'MM-DD(DY) HH24:MI:SS')                                    AS sp_start
     , TO_CHAR(r.run_end,   'HH24:MI:SS')                                              AS sp_end
     , r.status                                                                        AS sp_status
     , r.created_by
     , j.job_name                                                                      AS job_name          -- NULL = 잡 구간 밖(수동/화면)
     , CASE WHEN j.job_name IS NULL THEN NULL
            WHEN EXISTS (SELECT 1 FROM all_scheduler_jobs sj WHERE sj.owner = j.owner AND sj.job_name = j.job_name
                            AND UPPER(sj.job_action) LIKE '%' || UPPER(REGEXP_SUBSTR(r.program_name, '[^.]+$')) || '%') THEN 'ACT'
            ELSE 'TIME' END                                                            AS match_kind        -- ACT = 잡 본문에 SP 이름 있음(확정) · TIME = 시간 겹침만(30분 주기 EDI_CALLOFF 등 오탐 가능. 하위 SP 는 TIME 이 정상)
     , TO_CHAR(j.job_start, 'HH24:MI:SS')                                              AS job_start
     , ROUND((j.job_end - j.job_start) * 1440, 1)                                      AS job_run_min
     , j.job_status, j.session_id
     , SUBSTR(NVL(r.in_para_data, r.description), 1, 100)                              AS start_params
  FROM r
  LEFT JOIN j ON r.run_start BETWEEN j.job_start - 1/86400 AND j.job_end + 1/86400
  , w
 WHERE r.run_start < w.to_dt AND r.run_end >= w.from_dt            -- END/ERROR 로 닫힌 실행만(Q2 와 동일 조건)
   AND (r.run_end - r.run_start) * 1440 >= 10
 ORDER BY sp_elapsed_min DESC, r.run_start;


/* ---------- Q4. (권한 필요) 세션 단위 실행 주체 — 40분+ 구간에 활동한 세션의 MODULE/ACTION/PROGRAM ----------
 * DBMS_SCHEDULER 잡 세션 : MODULE='DBMS_SCHEDULER', ACTION=잡 이름.  수동 실행 : MODULE 이 'DBeaver …' / 'SQL Developer' / 'node.exe'(BE) 등.
 * SPAN_MIN = 그 세션이 ASH 에 처음~마지막 보인 시간 폭. ACTIVE_SEC = 활동 샘플 수 × 10초(AWR 10초 샘플).
 * TOP_SQL = 그 세션에서 가장 많이 잡힌 SQL_ID(→ DBMS_XPLAN.DISPLAY_AWR 로 원문/플랜). IN_PLSQL = 진입 PL/SQL 객체(어느 SP 를 돌리던 세션인지).
 * DBID = CON_DBID : CDB/PDB 2벌 보존 중 PDB 1벌만. 권한 없으면 ORA-00942/01031 → 이 블록은 건너뛴다. AWR 보존기간 지나면 0행. */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt FROM dual)
, a AS (
    SELECT h.session_id, h.session_serial#, h.user_id, h.module, h.action, h.program, h.machine
         , h.sample_time, h.sql_id, h.plsql_entry_object_id
      FROM dba_hist_active_sess_history h, w
     WHERE h.sample_time >= w.from_dt AND h.sample_time < w.to_dt
       AND h.dbid = h.con_dbid
       AND h.session_type = 'FOREGROUND'
       AND h.user_id <> 0                                                       -- SYS 내부 세션(자동 리포트 등) 제외
)
, g AS (
    SELECT session_id, session_serial#, MAX(user_id) AS user_id, MAX(module) AS module, MAX(action) AS action, MAX(program) AS program, MAX(machine) AS machine
         , MIN(sample_time) AS first_seen, MAX(sample_time) AS last_seen, COUNT(*) * 10 AS active_sec
         , STATS_MODE(sql_id) AS top_sql, STATS_MODE(plsql_entry_object_id) AS entry_obj
      FROM a
     GROUP BY session_id, session_serial#
)
SELECT ROUND((CAST(last_seen AS DATE) - CAST(first_seen AS DATE)) * 1440, 1)              AS span_min
     , active_sec
     , CASE WHEN (CAST(last_seen AS DATE) - CAST(first_seen AS DATE)) * 1440 >= 40 THEN '◆ 40분+' END AS flag
     , session_id || ',' || session_serial#                                                 AS sid_serial   -- Q1 SESSION_ID 와 대조
     , (SELECT username FROM all_users u WHERE u.user_id = g.user_id)                        AS db_user
     , module, action, program, machine
     , TO_CHAR(first_seen, 'MM-DD(DY) HH24:MI:SS')                                          AS first_seen
     , TO_CHAR(last_seen,  'MM-DD HH24:MI:SS')                                              AS last_seen
     , (SELECT object_name FROM dba_objects o WHERE o.object_id = g.entry_obj)              AS in_plsql
     , top_sql
  FROM g
 WHERE active_sec >= 600                                                                    -- 활동 10분 이상 세션만(자동튜닝·모니터링 잡음 제거)
 ORDER BY span_min DESC, active_sec DESC
 FETCH FIRST 40 ROWS ONLY;


/* ---------- Q5. 가장 오래 걸린 실행 1건의 타임라인 — 그 구간 안에 찍힌 모든 배치 로그(하위 SP 포함)와 직전 행과의 간격 ----------
 * Q2 1위 실행을 자동 선택한다(다른 실행을 보려면 pick 의 FETCH FIRST 를 OFFSET n 으로, 또는 program_name/run_start 를 직접 지정).
 * GAP_SEC 큰 행 = 그 직전 구간에서 시간이 간 것. 같은 세션 계정(CREATED_BY)의 상위 로그 + 'scm_batch' 하위 로그를 함께 놓는다. */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt
                , TO_DATE('2026-09-28','YYYY-MM-DD') AS scan_from, TO_DATE('2026-10-03','YYYY-MM-DD') AS scan_to FROM dual)
, l AS (
    SELECT l.program_name, l.created_by, l.log_type, l.event_date, l.creation_date
         , CASE l.log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.event_date >= w.scan_from AND l.event_date < w.scan_to
       AND l.log_type IN ('START', 'END', 'ERROR', 'error')
)
, s AS (
    SELECT l.*
         , LEAD(log_type)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
         , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
      FROM l
)
, pick AS (
    SELECT program_name, created_by, event_date AS run_start, next_date AS run_end
      FROM s, w
     WHERE log_type = 'START' AND next_type IN ('END', 'ERROR', 'error')          -- 닫힌 실행만(Q2 와 동일)
       AND event_date < w.to_dt AND next_date >= w.from_dt
     ORDER BY (next_date - event_date) DESC
     FETCH FIRST 1 ROW ONLY
)
SELECT p.program_name                                                                                   AS picked_run
     , TO_CHAR(p.run_start, 'MM-DD HH24:MI:SS')                                                         AS picked_start
     , TO_CHAR(x.event_date, 'MM-DD HH24:MI:SS')                                                        AS at_time
     , ROUND((x.event_date - LAG(x.event_date) OVER (ORDER BY x.event_date, x.creation_date)) * 86400)  AS gap_sec
     , ROUND((x.event_date - p.run_start) * 1440, 1)                                                    AS min_from_start
     , x.program_name, x.log_type, x.log_count, x.created_by
     , SUBSTR(x.log_message, 1, 100)                                                                    AS log_message
     , SUBSTR(x.description, 1, 100)                                                                    AS description
     , x.sql_err_code
  FROM pick p
  JOIN SCM_MGR.SCM_SYS_LOG_BATCH x
    ON x.event_date BETWEEN p.run_start AND p.run_end
   AND (x.created_by = p.created_by OR x.created_by IN ('scm_batch', 'SCP_BATCH', 'SYSTEM'))   -- 하위 SP 는 'scm_batch' 고정이라 같은 시간대의 무관한 scm_batch 로그(화면 저장 등)도 섞일 수 있음 → PROGRAM_NAME 으로 가려 읽는다
 ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date;


/* ---------- Q6. 오류 전체 — 3일 안 ERROR/INVALID (어느 SP 가 왜 실패했는지) ---------- */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt FROM dual)
SELECT TO_CHAR(l.event_date, 'MM-DD(DY) HH24:MI:SS') AS at_time
     , l.program_name, l.log_type, l.created_by
     , l.sql_err_code
     , SUBSTR(l.sql_err_msg, 1, 200)                 AS sql_err_msg
     , SUBSTR(l.log_message, 1, 200)                 AS log_message
     , SUBSTR(l.description, 1, 200)                 AS description
     , SUBSTR(REGEXP_SUBSTR(NVL(l.sql_backtrace, l.description), 'line [0-9]+'), 1, 20) AS err_line
     , SUBSTR(l.in_para_data, 1, 150)                AS in_para_data
  FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
 WHERE l.event_date >= w.from_dt AND l.event_date < w.to_dt
   AND (l.log_type IN ('ERROR', 'error', 'INVALID') OR l.sql_err_code IS NOT NULL)
 ORDER BY l.event_date;
