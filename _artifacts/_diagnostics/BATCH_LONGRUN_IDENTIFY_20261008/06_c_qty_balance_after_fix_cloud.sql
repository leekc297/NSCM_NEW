/* =====================================================================================================
 * 06 — 클라우드 실행용 (05 후속, 짧음): ① 10-02 15:39 보정 이후 C_QTY_BALANCE 호출 소요 ② 주차별 버전 수 ③ 사내(3,092줄)·클라우드(3,100줄) 판본 이력 대조
 *      SQL Developer 스크립트 창에 전체 붙여넣기 → F5. 조회 전용.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

/* ---------- W1. 보정 이후(10-02 15:39~) C_QTY_BALANCE 호출별 소요 — 보정 전 40 사업부 회당 4.9~5.6분이 얼마로 줄었나 ---------- */
WITH l AS (
    SELECT program_name, created_by, log_type, event_date, creation_date, description
         , CASE log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH
     WHERE event_date >= TO_DATE('2026-10-02 15:00', 'YYYY-MM-DD HH24:MI')
       AND program_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE'
       AND log_type IN ('START', 'END', 'ERROR', 'error')
)
, s AS (
    SELECT l.*
         , LEAD(log_type)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
         , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
      FROM l
)
SELECT TO_CHAR(event_date, 'MM-DD(DY) HH24:MI:SS') AS start_time
     , ROUND((CASE WHEN next_type IN ('END','ERROR','error') THEN next_date END - event_date) * 1440, 1) AS elapsed_min
     , CASE WHEN next_type = 'END' THEN 'END' WHEN next_type IN ('ERROR','error') THEN 'ERROR' ELSE '미종료/중첩' END AS status
     , SUBSTR(description, 1, 90) AS params
  FROM s
 WHERE log_type = 'START'
 ORDER BY event_date;

-- W1-b. 같은 기간 PLAN_ID 지정 루트 실행(수동) 소요 — C 보정 반영 후 전체가 얼마인지
WITH l AS (
    SELECT program_name, created_by, log_type, event_date, creation_date, in_para_data
         , CASE log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH
     WHERE event_date >= TO_DATE('2026-10-01', 'YYYY-MM-DD')
       AND program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND log_type IN ('START', 'END', 'ERROR', 'error')
)
, s AS (
    SELECT l.*
         , LEAD(log_type)   OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
         , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
      FROM l
)
SELECT TO_CHAR(event_date, 'MM-DD(DY) HH24:MI:SS') AS start_time
     , ROUND((CASE WHEN next_type IN ('END','ERROR','error') THEN next_date END - event_date) * 1440, 1) AS elapsed_min
     , CASE WHEN next_type = 'END' THEN 'END' WHEN next_type IN ('ERROR','error') THEN 'ERROR' ELSE '미종료/중첩' END AS status
     , created_by, SUBSTR(in_para_data, 1, 60) AS params
  FROM s
 WHERE log_type = 'START'
   AND in_para_data NOT LIKE '%"NULL"%'          -- 배치 경로(PLAN_ID NULL) 제외 → CALL / PLAN_ID 지정만
 ORDER BY event_date;


/* ---------- W2. 40 사업부 주차별 MF_W/SF_W/SP_W 버전 수 (05 V4 재실행 — 앞 결과에서 잘림) ---------- */
SELECT TO_CHAR(TRUNC(TO_DATE(yyyymmdd, 'YYYYMMDD'), 'IW'), 'YYYY-MM-DD') AS week_monday
     , version_type, COUNT(*) AS versions
     , LISTAGG(version_no || '(' || TO_CHAR(creation_date, 'DD HH24:MI') || ')', ', ') WITHIN GROUP (ORDER BY version_no) AS list_
  FROM DM_MST_VERSION
 WHERE division_id = '40' AND version_type IN ('MF_W', 'SF_W', 'SP_W')
   AND yyyymmdd >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 28, 'YYYYMMDD')
 GROUP BY TRUNC(TO_DATE(yyyymmdd, 'YYYYMMDD'), 'IW'), version_type
 ORDER BY 1, 2;


/* ---------- W3. 클라우드 C_QTY_BALANCE 판본 이력 — 사내 3,092줄과 클라우드 3,100줄의 8줄 차이가 어느 변경인지 (헤더 이력 + 본문 마커 줄) ---------- */
SELECT line, SUBSTR(RTRIM(text), 1, 150) AS text
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND ( (line <= 120 AND REGEXP_LIKE(text, '20(25|26)[./-][0-9]{2}'))                        -- 헤더 PROGRAM HISTORY 의 날짜 줄 (Oracle 정규식: 대괄호 안 하이픈은 맨 뒤)
      OR REGEXP_LIKE(text, '\[E2026|\[PJ2026|2026\.(09|10)\.[0-9]{2} (AJS|ZIONEX)|ASISDELTA|VIEWONCE|DATEVAR|PERF\]') )   -- 본문 변경 마커
 ORDER BY line;

-- W3-b. 줄 수 분포로 빠른 대조 (사내 값은 README §4-4 에 기록)
SELECT COUNT(*) AS total_lines
     , SUM(CASE WHEN TRIM(text) IS NULL THEN 1 ELSE 0 END) AS blank_lines
     , SUM(CASE WHEN REGEXP_LIKE(text, '^\s*-{2}') THEN 1 ELSE 0 END) AS comment_lines
     , SUM(CASE WHEN UPPER(text) LIKE '%GATHER_TABLE_STATS%' THEN 1 ELSE 0 END) AS gather_stats
     , SUM(CASE WHEN UPPER(text) LIKE '%SCP_PLN_RTF_ALLOCATION_V%' THEN 1 ELSE 0 END) AS view_refs
     , SUM(CASE WHEN UPPER(text) LIKE '%PR_SCM_SYS_LOG_BATCH(%' THEN 1 ELSE 0 END) AS log_calls
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE';
