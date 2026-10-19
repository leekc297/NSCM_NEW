/* =====================================================================================================
 * 07 — 클라우드 실행용: 소요시간에서 "메일 발송(SLEEP 포함)" 을 분리 — 전체 / 메일 / 순소요(메일 제외)
 *      메일 SP 2종 = PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND · PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND
 *      (클라우드 판 08-14: 수신자 5명마다 DBMS_SESSION.SLEEP(30) → 106명 ≈ 21회 × 30초 = 10.5분 대기 + 발송 0.5분 ≈ 11.0분)
 *      방식 변경 예정이라 이 시간은 전체에서 제외하고 본다. 기간 9/29~10/1 (w 의 날짜 2개로 변경).
 *      SQL Developer 스크립트 창에 전체 붙여넣기 → F5. 조회 전용.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

/* ---------- M1. 메일 SP 호출별 소요 — 분리 대상 원장 ---------- */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt FROM dual)
, l AS (
    SELECT program_name, created_by, log_type, event_date, creation_date, description
         , CASE log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH, w
     WHERE event_date >= w.from_dt AND event_date < w.to_dt + 1
       AND program_name IN ('PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND')
       AND log_type IN ('START', 'END', 'ERROR', 'error')
)
, s AS (
    SELECT l.*, LEAD(log_type) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
              , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
      FROM l
)
SELECT TO_CHAR(event_date, 'MM-DD(DY) HH24:MI:SS') AS start_time, TO_CHAR(next_date, 'HH24:MI:SS') AS end_time
     , ROUND((CASE WHEN next_type IN ('END','ERROR','error') THEN next_date END - event_date) * 1440, 1) AS mail_min
     , SUBSTR(program_name, 1, 42) AS mail_sp, SUBSTR(description, 1, 80) AS params
  FROM s, w
 WHERE log_type = 'START' AND event_date < w.to_dt
 ORDER BY event_date;


/* ---------- M2. 긴 SP 실행(10분+)별 전체 / 메일 / 순소요 — 01 Q2 와 같은 실행 재구성 + 그 구간 안 메일 SP 소요 합산 ---------- */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt FROM dual)
, l AS (
    SELECT program_name, created_by, log_type, event_date, creation_date, in_para_data, description
         , CASE log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH, w
     WHERE event_date >= w.from_dt - 1 AND event_date < w.to_dt + 1
       AND log_type IN ('START', 'END', 'ERROR', 'error')
)
, s AS (
    SELECT l.*, LEAD(log_type) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
              , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
      FROM l
)
, r AS (   -- 닫힌 실행
    SELECT program_name, created_by, event_date AS run_start, next_date AS run_end, in_para_data, description
      FROM s WHERE log_type = 'START' AND next_type IN ('END','ERROR','error')
)
, m AS (   -- 메일 SP 실행
    SELECT event_date AS m_start, next_date AS m_end
      FROM s WHERE log_type = 'START' AND next_type IN ('END','ERROR','error')
       AND program_name IN ('PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND')
)
SELECT ROUND((r.run_end - r.run_start) * 1440, 1)                                                              AS total_min
     , ROUND(NVL((SELECT SUM(LEAST(m.m_end, r.run_end) - GREATEST(m.m_start, r.run_start)) FROM m
                   WHERE m.m_start < r.run_end AND m.m_end > r.run_start), 0) * 1440, 1)                        AS mail_min
     , ROUND(((r.run_end - r.run_start) - NVL((SELECT SUM(LEAST(m.m_end, r.run_end) - GREATEST(m.m_start, r.run_start)) FROM m
                   WHERE m.m_start < r.run_end AND m.m_end > r.run_start), 0)) * 1440, 1)                      AS net_min
     , SUBSTR(r.program_name, 1, 42) AS program_name
     , TO_CHAR(r.run_start, 'MM-DD(DY) HH24:MI:SS') AS start_time, TO_CHAR(r.run_end, 'HH24:MI:SS') AS end_time
     , r.created_by, SUBSTR(NVL(r.in_para_data, r.description), 1, 70) AS params
  FROM r, w
 WHERE r.run_start < w.to_dt AND r.run_end >= w.from_dt
   AND (r.run_end - r.run_start) * 1440 >= 10
   AND r.program_name NOT IN ('PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND')   -- 메일 SP 자체는 제외
   AND NOT REGEXP_LIKE(r.program_name, '(^|_)GET_', 'i')
 ORDER BY net_min DESC, r.run_start;


/* ---------- M3. 스케줄러 잡 실행별 전체 / 메일 / 순소요 (5분+ 잡만) ---------- */
WITH w AS (SELECT TO_DATE('2026-09-29','YYYY-MM-DD') AS from_dt, TO_DATE('2026-10-02','YYYY-MM-DD') AS to_dt FROM dual)
, l AS (
    SELECT program_name, created_by, log_type, event_date, creation_date
         , CASE log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH, w
     WHERE event_date >= w.from_dt - 1 AND event_date < w.to_dt + 1
       AND program_name IN ('PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND')
       AND log_type IN ('START', 'END', 'ERROR', 'error')
)
, m AS (
    SELECT event_date AS m_start
         , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS m_end
         , LEAD(log_type)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
         , log_type
      FROM l
)
, mm AS (SELECT m_start, m_end FROM m WHERE log_type = 'START' AND next_type IN ('END','ERROR','error'))
, j AS (
    SELECT d.job_name, d.status, CAST(d.actual_start_date AS DATE) AS job_start, CAST(d.actual_start_date + d.run_duration AS DATE) AS job_end
      FROM all_scheduler_job_run_details d, w
     WHERE d.actual_start_date >= w.from_dt AND d.actual_start_date < w.to_dt
)
SELECT ROUND((j.job_end - j.job_start) * 1440, 1) AS total_min
     , ROUND(NVL((SELECT SUM(LEAST(mm.m_end, j.job_end) - GREATEST(mm.m_start, j.job_start)) FROM mm
                   WHERE mm.m_start < j.job_end AND mm.m_end > j.job_start), 0) * 1440, 1) AS mail_min
     , ROUND(((j.job_end - j.job_start) - NVL((SELECT SUM(LEAST(mm.m_end, j.job_end) - GREATEST(mm.m_start, j.job_start)) FROM mm
                   WHERE mm.m_start < j.job_end AND mm.m_end > j.job_start), 0)) * 1440, 1) AS net_min
     , SUBSTR(j.job_name, 1, 55) AS job_name, j.status
     , TO_CHAR(j.job_start, 'MM-DD(DY) HH24:MI:SS') AS started, TO_CHAR(j.job_end, 'HH24:MI:SS') AS ended
  FROM j
 WHERE (j.job_end - j.job_start) * 1440 >= 5
 ORDER BY net_min DESC, j.job_start;
