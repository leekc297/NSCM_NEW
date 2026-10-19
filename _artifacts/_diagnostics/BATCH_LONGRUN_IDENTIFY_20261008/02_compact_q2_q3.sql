/* =====================================================================================================
 * 02_compact — 01 의 Q2(긴 SP 실행) / Q3(잡 매칭) / Q2-c(끝 로그 없는 START) 를 행당 한 줄 문자열로 압축
 *   SQL Developer F5(스크립트) 로 실행 → 결과를 그대로 붙여넣기 가능(패딩 없음). 내용·필터는 01 과 동일.
 *   기간 2026-09-29 ~ 10-01 (스캔 여유 09-28 ~ 10-03). 조회 전용.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 0
SET LINESIZE 400

/* ---------- C2. 긴 SP 실행 (01 Q2 와 동일 조건: END/ERROR 로 닫힌 실행, 10분 이상, 긴 순) ----------
 * 형식: 소요분 | 플래그 | SP | 체인 | 시작 | 종료 | 상태 | 계정 | 인자 | 오류코드 | 오류줄 */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt
                , TO_DATE('2026-09-28','YYYY-MM-DD') AS scan_from, TO_DATE('2026-10-03','YYYY-MM-DD') AS scan_to FROM dual)
, l AS (
    SELECT l.program_name, l.created_by, l.log_type, l.event_date, l.creation_date, l.in_para_data, l.description, l.sql_err_code, l.sql_backtrace
         , CASE l.log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.event_date >= w.scan_from AND l.event_date < w.scan_to
       AND l.log_type IN ('START', 'END', 'ERROR', 'error')
)
, s AS (
    SELECT l.*
         , LEAD(log_type)      OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
         , LEAD(event_date)    OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
         , LEAD(sql_err_code)  OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_err_code
         , LEAD(sql_backtrace) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_bt
         , LEAD(description)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_desc
      FROM l
)
, r AS (
    SELECT program_name, created_by, event_date AS run_start
         , CASE WHEN next_type IN ('END','ERROR','error') THEN next_date END AS run_end
         , CASE WHEN next_type = 'END' THEN 'END' WHEN next_type IN ('ERROR','error') THEN 'ERROR' END AS status
         , next_err_code, next_bt, next_desc, in_para_data, description
      FROM s WHERE log_type = 'START'
)
SELECT 'C2|' || ROUND((run_end - run_start) * 1440, 1)
     || '|' || CASE WHEN (run_end - run_start) * 1440 >= 40 THEN '40분+' ELSE '-' END
     || '|' || program_name
     || '|' || CASE WHEN REGEXP_LIKE(program_name, 'BALANCE|WEEKLY_ROLLING|SALES_PLAN_CUTOFF|CREATE_WS_RTF|AMT_CREATE_LOCAL_KRW|SCP_ENG', 'i') THEN 'BAL' ELSE '-' END
     || '|' || TO_CHAR(run_start, 'MM-DD HH24:MI:SS') || '|' || TO_CHAR(run_end, 'MM-DD HH24:MI:SS')
     || '|' || status || '|' || created_by
     || '|' || SUBSTR(REPLACE(REPLACE(NVL(in_para_data, description), CHR(10), ' '), CHR(13), ' '), 1, 90)
     || '|' || NVL(next_err_code, '-')
     || '|' || NVL(SUBSTR(REGEXP_SUBSTR(NVL(next_bt, next_desc), 'line [0-9]+'), 1, 12), '-') AS row_
  FROM r, w
 WHERE run_start < w.to_dt AND run_end >= w.from_dt
   AND (run_end - run_start) * 1440 >= 10
 ORDER BY (run_end - run_start) DESC, run_start;


/* ---------- C3. 잡 ↔ SP 매칭 (01 Q3 동일) — 형식: 소요분 | SP | 시작 | 종료 | 상태 | 계정 | 잡이름(없으면 NO_JOB) | ACT/TIME | 잡시작 | 잡소요 | 잡세션 | 인자 */
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
         , CASE WHEN next_type = 'END' THEN 'END' WHEN next_type IN ('ERROR','error') THEN 'ERROR' END AS status
         , in_para_data, description
      FROM s WHERE log_type = 'START'
)
, j AS (
    SELECT d.owner, d.job_name, d.status AS job_status, d.session_id
         , CAST(d.actual_start_date AS DATE)                  AS job_start
         , CAST(d.actual_start_date + d.run_duration AS DATE) AS job_end
      FROM all_scheduler_job_run_details d, w
     WHERE d.actual_start_date >= w.scan_from AND d.actual_start_date < w.scan_to
)
/* ACT 열: 그 잡의 JOB_ACTION 본문에 SP 이름이 직접 쓰여 있으면 'ACT', 아니면 'TIME'(시간 겹침만 — 30분 주기 EDI_CALLOFF 등과 우연히 겹친 오탐 가능).
 *        하위 SP(메일 발송·KRW 등)는 잡 본문에 이름이 없어 TIME 으로 나오는 것이 정상 → 상위 SP 행의 ACT 로 판단. */
SELECT 'C3|' || ROUND((r.run_end - r.run_start) * 1440, 1)
     || '|' || r.program_name
     || '|' || TO_CHAR(r.run_start, 'MM-DD HH24:MI:SS') || '|' || TO_CHAR(r.run_end, 'HH24:MI:SS')
     || '|' || r.status || '|' || r.created_by
     || '|' || NVL(j.job_name, 'NO_JOB')
     || '|' || CASE WHEN j.job_name IS NULL THEN '-'
                    WHEN EXISTS (SELECT 1 FROM all_scheduler_jobs sj WHERE sj.owner = j.owner AND sj.job_name = j.job_name
                                    AND UPPER(sj.job_action) LIKE '%' || UPPER(REGEXP_SUBSTR(r.program_name, '[^.]+$')) || '%') THEN 'ACT'
                    ELSE 'TIME' END
     || '|' || NVL(TO_CHAR(j.job_start, 'HH24:MI:SS'), '-')
     || '|' || NVL(TO_CHAR(ROUND((j.job_end - j.job_start) * 1440, 1)), '-')
     || '|' || NVL(j.session_id, '-')
     || '|' || SUBSTR(REPLACE(REPLACE(NVL(r.in_para_data, r.description), CHR(10), ' '), CHR(13), ' '), 1, 80) AS row_
  FROM r
  LEFT JOIN j ON r.run_start BETWEEN j.job_start - 1/86400 AND j.job_end + 1/86400
  , w
 WHERE r.run_start < w.to_dt AND r.run_end >= w.from_dt
   AND (r.run_end - r.run_start) * 1440 >= 10
 ORDER BY (r.run_end - r.run_start) DESC, r.run_start;


/* ---------- C2c. 끝 로그 없는 START (01 Q2-c 동일, 화면 GET 제외) — 형식: 시작 | SP | 계정 | 상태 | 다음START까지분 | 인자 */
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
SELECT 'C2c|' || TO_CHAR(event_date, 'MM-DD HH24:MI:SS')
     || '|' || program_name || '|' || created_by
     || '|' || CASE WHEN next_type = 'START' THEN '중첩' ELSE '미종료' END
     || '|' || NVL(TO_CHAR(ROUND((next_date - event_date) * 1440, 1)), '-')
     || '|' || SUBSTR(REPLACE(REPLACE(NVL(in_para_data, description), CHR(10), ' '), CHR(13), ' '), 1, 80) AS row_
  FROM s, w
 WHERE log_type = 'START'
   AND NVL(next_type, 'X') NOT IN ('END', 'ERROR', 'error')
   AND event_date >= w.from_dt AND event_date < w.to_dt
   AND NOT REGEXP_LIKE(program_name, '(^|_)GET_', 'i')
 ORDER BY event_date;
