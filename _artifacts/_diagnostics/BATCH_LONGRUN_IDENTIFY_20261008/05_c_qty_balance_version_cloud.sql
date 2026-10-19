/* =====================================================================================================
 * 05 — 클라우드 실행용: A 결과(04) 후속 — 병목 SP 판본 확인 · 상위 SQL 실행계획 · 보정 전후 소요 비교
 *      SQL Developer 스크립트 창에 전체 붙여넣기 → F5. 조회 전용 · DB 변경 없음.
 *      배경: 09-30 51.9분 중 35.4분이 PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 5회 호출(MF_W/SF_W 버전 수). 그 안의
 *            3pkngsw1b3vng (INSERT GT_DPMFCQB_VMI_MST_MAIN, 플랜 21 INDEX RANGE SCAN ON CPU) 1,090초 = 사내 10-01 18:43 판에서
 *            END_CUSTOMER 조인 추가(L2218)로 보정된 문장. 6nzwwbfd3rzsz / 0jcr4bqngwpj2 (SCP_PLN_RTF_ALLOCATION_V MAX) 580초 = 미보정.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

/* ---------- V1. 클라우드 C_QTY_BALANCE 판본 — 사내 = 2026-10-01 18:43 · 3,092줄 · '2026.10.01 AJS' 2곳 · VMI INSERT 조인에 END_CUSTOMER 있음 ---------- */
SELECT o.object_name, o.status, TO_CHAR(o.last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
     , (SELECT MAX(line) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type) AS total_lines
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%2026.10.01 AJS%') AS ajs_1001_marks
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type
          AND REGEXP_LIKE(s.text, 'A\.END_CUSTOMER\s*=\s*C\.END_CUSTOMER')) AS endcust_join_lines     -- 사내: QTY_BALANCE 1 이상 · C_QTY_BALANCE 1 이상
  FROM all_objects o
 WHERE o.owner = 'SCM_MGR' AND o.object_type = 'PROCEDURE'
   AND o.object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                       , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND')
 ORDER BY o.object_name;

-- V1-b. 클라우드 C_QTY_BALANCE 의 VMI_MST_MAIN INSERT 조인 원문 (사내 L2204~2226 에 해당하는 블록) — END_CUSTOMER 줄이 있는지 눈으로 확인
SELECT line, SUBSTR(RTRIM(text), 1, 120) AS text
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND line BETWEEN (SELECT MIN(line) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE' AND UPPER(text) LIKE '%INSERT INTO GT_DPMFCQB_VMI_MST_MAIN%') + 45
                AND (SELECT MIN(line) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE' AND UPPER(text) LIKE '%INSERT INTO GT_DPMFCQB_VMI_MST_MAIN%') + 75
 ORDER BY line;


/* ---------- V2. 상위 SQL 실행계획 (AWR) — 플랜 라인 21 이 어느 인덱스인지 확정 ---------- */
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('3pkngsw1b3vng', 3514962743, NULL, 'BASIC +PREDICATE +ROWS +PARTITION'));   -- C: INSERT GT_DPMFCQB_VMI_MST_MAIN (1,090초)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('6nzwwbfd3rzsz', 4211265331, NULL, 'BASIC +PREDICATE +ROWS'));              -- C: MAX(PLAN_ID) FROM SCP_PLN_RTF_ALLOCATION_V … <= (510초)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('0jcr4bqngwpj2', 1503978154, NULL, 'BASIC +PREDICATE +ROWS'));              -- C: MAX(PLAN_START_YYYYMMDD) … PLAN_ID = (70초)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('3g9x8t27cmu5k', 1073052721, NULL, 'BASIC +PREDICATE +ROWS +PARTITION'));   -- 루트: INSERT GT_PRDM2_VMI_MST_MAIN (200초, 10-06 보정 반영분과 비교)


/* ---------- V3. C_QTY_BALANCE 호출별 소요 추이 (최근 14일) — 보정 전후 비교. 사내 10-01 18:43 보정이 클라우드에 반영됐으면 그 뒤 호출은 2분 미만이어야 함 ---------- */
WITH l AS (
    SELECT program_name, created_by, log_type, event_date, creation_date, description
         , CASE log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH
     WHERE event_date >= TRUNC(SYSDATE) - 14
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


/* ---------- V4. 40 사업부 주차별 MF_W/SF_W 버전 수 — CUTOFF 루프 횟수(= C_QTY_BALANCE 호출 수). 수동 RUN_JOB 으로 늘어난 주차가 보인다 ---------- */
SELECT TO_CHAR(TRUNC(TO_DATE(yyyymmdd, 'YYYYMMDD'), 'IW'), 'YYYY-MM-DD') AS week_monday
     , version_type, COUNT(*) AS versions
     , LISTAGG(version_no || '(' || TO_CHAR(creation_date, 'DD HH24:MI') || ')', ', ') WITHIN GROUP (ORDER BY version_no) AS list_
  FROM DM_MST_VERSION
 WHERE division_id = '40' AND version_type IN ('MF_W', 'SF_W', 'SP_W')
   AND yyyymmdd >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 28, 'YYYYMMDD')
 GROUP BY TRUNC(TO_DATE(yyyymmdd, 'YYYYMMDD'), 'IW'), version_type
 ORDER BY 1, 2;
