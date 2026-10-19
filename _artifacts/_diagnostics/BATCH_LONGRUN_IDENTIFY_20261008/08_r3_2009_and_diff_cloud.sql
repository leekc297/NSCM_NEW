/* =====================================================================================================
 * 08 — 클라우드 실행용 (06 후속): ① 10-01 20:09 실행(R3, 22.7분 — C 보정 직후로 추정)의 SP·SQL 분해 ② 클라우드에만 있는 8줄 원문 ③ 10-01 18:31~19:26 ERROR 4건 내용
 *      SQL Developer 스크립트 창에 전체 붙여넣기 → F5. 조회 전용.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

/* ---------- X1. R3 (10-01 20:09:01~20:31:43) SP 단위 분해 — R1 과 비교해 C_QTY_BALANCE 가 얼마나 줄었나 ---------- */
WITH runs AS (SELECT 'R3_1001_2009' AS run_id, TO_DATE('2026-10-01 20:09:00', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_DATE('2026-10-01 20:32:00', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual)
, chain AS (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
             AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                               , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
                               , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF'))
SELECT r.run_id
     , NVL((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id), '(루트 ' || (SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_entry_object_id) || ')') AS in_sp
     , COUNT(*) * 10 AS approx_sec, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
  FROM dba_hist_active_sess_history h JOIN runs r ON h.sample_time >= r.f AND h.sample_time < r.t
 WHERE h.dbid = h.con_dbid
   AND (h.plsql_entry_object_id IN (SELECT object_id FROM chain) OR h.plsql_object_id IN (SELECT object_id FROM chain))
 GROUP BY r.run_id, h.plsql_object_id, h.plsql_entry_object_id
 ORDER BY approx_sec DESC;

-- X2. R3 SQL 단위 합계 — 3pkngsw1b3vng(보정 전 1,090초) 가 사라졌는지, 뷰 MAX 6nzwwbfd3rzsz 가 얼마인지
WITH runs AS (SELECT 'R3_1001_2009' AS run_id, TO_DATE('2026-10-01 20:09:00', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_DATE('2026-10-01 20:32:00', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual)
, chain AS (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
             AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                               , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
                               , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF'))
SELECT h.sql_id, MAX(h.sql_plan_hash_value) AS phv
     , SUBSTR(MAX((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id)), 1, 42) AS in_sp
     , COUNT(*) * 10 AS approx_sec, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
     , (SELECT SUBSTR(REPLACE(REPLACE(DBMS_LOB.SUBSTR(x.sql_text, 90, 1), CHR(10), ' '), CHR(13), ' '), 1, 90) FROM dba_hist_sqltext x WHERE x.sql_id = h.sql_id AND x.dbid = x.con_dbid AND ROWNUM = 1) AS sql_text
  FROM dba_hist_active_sess_history h JOIN runs r ON h.sample_time >= r.f AND h.sample_time < r.t
 WHERE h.dbid = h.con_dbid
   AND (h.plsql_entry_object_id IN (SELECT object_id FROM chain) OR h.plsql_object_id IN (SELECT object_id FROM chain))
 GROUP BY h.sql_id
 ORDER BY approx_sec DESC
 FETCH FIRST 20 ROWS ONLY;

-- X3. R3 step 타임라인 (C_QTY_BALANCE 호출별 소요가 직접 보임)
SELECT TO_CHAR(x.event_date, 'HH24:MI:SS') AS at_time
     , ROUND((x.event_date - LAG(x.event_date) OVER (ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date)) * 86400) AS gap_sec
     , ROUND((x.event_date - TO_DATE('2026-10-01 20:09:01', 'YYYY-MM-DD HH24:MI:SS')) * 1440, 1) AS min_from_start
     , SUBSTR(x.program_name, 1, 42) AS program_name, x.log_type, x.created_by
     , SUBSTR(x.log_message, 1, 40) AS log_message, SUBSTR(x.description, 1, 70) AS description
  FROM SCM_MGR.SCM_SYS_LOG_BATCH x
 WHERE x.event_date BETWEEN TO_DATE('2026-10-01 20:09:01', 'YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2026-10-01 20:31:43', 'YYYY-MM-DD HH24:MI:SS')
   AND x.created_by IN ('SYSTEM', 'scm_batch')
   AND REGEXP_LIKE(x.program_name, 'BALANCE|WS_RTF|LOCAL_KRW|CUTOFF|VERSION_CREATE')
   AND x.log_type IN ('START', 'END', 'ERROR', 'ING', 'INVALID')
 ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date;


/* ---------- X4. 클라우드에만 있는 8줄 — 06 W3-b: 사내 대비 총 +8줄 · '--' 줄 +8 (11→19), 나머지 동일 → 마커 오프셋상 L726~L874 에 +4, L892~L1067 에 +4 ---------- */
SELECT line, SUBSTR(RTRIM(text), 1, 160) AS text
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, '^\s*-{2}')
 ORDER BY line;
-- 사내 '--' 11줄: L718 외 10줄은 X4 결과와 대조(README §4-4). 클라우드에서 추가된 8줄이 전부 설명문이면 무해, 코드가 들어 있으면 사내와 로직 차이.


/* ---------- X5. 10-01 18:31~19:26 QTY_BALANCE(40,1461) ERROR 4건 — 배포 중 오류(ORA-04068/06508)면 C 보정이 그 시각에 클라우드에 올라간 것 ---------- */
SELECT TO_CHAR(l.event_date, 'MM-DD HH24:MI:SS') AS at_time, SUBSTR(l.program_name, 1, 42) AS program_name, l.log_type, l.created_by
     , l.sql_err_code, SUBSTR(l.sql_err_msg, 1, 160) AS sql_err_msg
     , SUBSTR(REGEXP_SUBSTR(NVL(l.sql_backtrace, l.description), 'line [0-9]+'), 1, 12) AS err_line
     , SUBSTR(l.in_para_data, 1, 50) AS in_para_data
  FROM SCM_MGR.SCM_SYS_LOG_BATCH l
 WHERE l.event_date BETWEEN TO_DATE('2026-10-01 13:50', 'YYYY-MM-DD HH24:MI') AND TO_DATE('2026-10-01 20:10', 'YYYY-MM-DD HH24:MI')
   AND (l.log_type IN ('ERROR', 'error') OR l.sql_err_code IS NOT NULL)
 ORDER BY l.event_date;

-- X5-b. 같은 날 C_QTY_BALANCE / 루트 SP 의 DDL 이력(가능하면) — 10-01 저녁 배포 흔적
SELECT object_name, object_type, TO_CHAR(created, 'YYYY-MM-DD HH24:MI:SS') AS created, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl, TO_CHAR(TO_DATE(timestamp, 'YYYY-MM-DD:HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') AS spec_ts
  FROM all_objects
 WHERE owner = 'SCM_MGR' AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE') AND object_type = 'PROCEDURE';
