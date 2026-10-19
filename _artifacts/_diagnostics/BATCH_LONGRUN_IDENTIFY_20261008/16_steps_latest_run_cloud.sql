/* =====================================================================================================
 * 16 — 클라우드 실행용 (조회만): 신판 적용 후 최근 실행(8분 2초)의 단계별 소요 분해 + 14:04 실행(7분 46초)과 문장 단위 비교
 *      T0 어떤 경로였는지(루트 1464 / C 직접) · T1 step 로그 타임라인(간격) · T2 모듈별 ASH 구간 · T3 문장별 ASH(신/구 창 비교) · T4 신판 핫 문장 V$SQL·플랜
 *      T5 같은 시간대 DB 전체 부하(다른 세션) · T6 GTT/파티션 통계 상태
 *      윈도: 오늘 15:00 이후 가장 최근 루트 또는 C START ~ 그 뒤 마지막 END. 1초 ASH 가 V$ 에서 빠졌으면 dba_hist(10초, dbid=con_dbid) 로 바꿔 재실행
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

/* ---------- T0-a. 신판 적용 여부 — 기대: VALID · total_lines 3128 · key_sites 32 · perf_marks 39 · last_ddl = 적용 시각(16:35 이전). 3092/0/0 이면 구판 그대로 ---------- */
SELECT o.object_name, o.status, TO_CHAR(o.last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
     , (SELECT MAX(line) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type) AS total_lines
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%CUTOFF_YYYYMMDD_DATE = C_CUTOFF_DATE%') AS key_sites
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%E20261008-PERF%') AS perf_marks
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%INSERT INTO GT_DPMFCQB_CUTOFF_MST_ACCUM%') AS accum_insert_should_be_0
  FROM all_objects o
 WHERE o.owner = 'SCM_MGR' AND o.object_type = 'PROCEDURE' AND o.object_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE';

-- T0-b. 16:35 실행이 실제로 신판 문장을 돌렸는지 — 파티션 키 조건이 든 SQL 이 공유풀에 16:35 이후 활성으로 있어야 한다 (0행이면 구판 코드가 실행된 것)
SELECT COUNT(*) AS new_code_sqls, MIN(TO_CHAR(s.last_active_time, 'HH24:MI:SS')) AS first_active, MAX(TO_CHAR(s.last_active_time, 'HH24:MI:SS')) AS last_active, SUM(s.executions) AS execs
  FROM v$sql s
 WHERE s.parsing_schema_name = 'SCM_MGR' AND s.sql_text LIKE '%CUTOFF_YYYYMMDD_DATE = :%' AND s.last_active_time >= TRUNC(SYSDATE) + 15/24;


/* ---------- T0. 오늘 15:00 이후 BALANCE 계열 START/END/ERROR 전부 — 어떤 SP 가 어느 경로로 돌았는지 (루트 START 가 있으면 1464 루트 경로, C START 만 있으면 03b 직접 호출) ---------- */
SELECT TO_CHAR(x.event_date, 'HH24:MI:SS') AS t, x.program_name, x.log_type, x.created_by
     , SUBSTR(x.log_message, 1, 40) AS msg, SUBSTR(x.in_para_data, 1, 90) AS para, SUBSTR(x.description, 1, 60) AS descr
  FROM SCM_MGR.SCM_SYS_LOG_BATCH x
 WHERE x.event_date >= TRUNC(SYSDATE) + 15/24
   AND x.log_type IN ('START', 'END', 'ERROR')
   AND REGEXP_LIKE(x.program_name, 'BALANCE|WS_RTF|LOCAL_KRW|SALES_PLAN|MAIL')
 ORDER BY x.event_date, x.creation_date;


/* ---------- T1. 최근 실행 step 타임라인 — 로그 행마다 다음 로그까지 간격(wall_sec) + 그 간격의 ASH 초(세션 모듈 무관, 로그 남긴 SP 세션 기준은 T2) ---------- */
WITH w AS (
    SELECT MAX(event_date) AS run_from
      FROM SCM_MGR.SCM_SYS_LOG_BATCH
     WHERE event_date >= TRUNC(SYSDATE) + 15/24 AND log_type = 'START'
       AND program_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE')
       AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_SYS_LOG_BATCH y WHERE y.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND y.log_type = 'START' AND y.event_date > SCM_SYS_LOG_BATCH.event_date AND y.event_date >= TRUNC(SYSDATE) + 15/24))
, w2 AS (SELECT run_from - 1/1440 AS run_from FROM w)   -- 루트 START 가 있으면 그 START, 없으면 가장 최근 C START (1분 여유)
, lg AS (
    SELECT x.event_date, x.creation_date, x.program_name, x.log_type, SUBSTR(x.log_message, 1, 24) AS msg, SUBSTR(x.in_para_data, 1, 40) AS para
         , LEAD(x.event_date) OVER (ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date) AS next_date
      FROM SCM_MGR.SCM_SYS_LOG_BATCH x, w2
     WHERE x.event_date >= w2.run_from AND x.event_date < w2.run_from + 1/24
       AND REGEXP_LIKE(x.program_name, 'BALANCE|WS_RTF|LOCAL_KRW|SALES_PLAN|MAIL'))
SELECT TO_CHAR(lg.event_date, 'HH24:MI:SS') AS from_, TO_CHAR(lg.next_date, 'HH24:MI:SS') AS to_
     , SUBSTR(lg.program_name, 1, 40) AS program_name, lg.log_type, lg.msg, lg.para
     , ROUND((lg.next_date - lg.event_date) * 86400) AS wall_sec
     , (SELECT COUNT(*) FROM v$active_session_history h WHERE h.sample_time >= lg.event_date AND h.sample_time < lg.next_date AND h.user_id = (SELECT user_id FROM all_users WHERE username = 'SCM_MGR')
         AND (h.module LIKE 'RUN_C_%' OR h.module LIKE 'RERUN_QTY_BALANCE%' OR h.program LIKE 'SQL Developer%' OR h.program LIKE 'DBeaver%')) AS ash_sec
     , (SELECT SUBSTR(STATS_MODE(h.sql_id), 1, 13) FROM v$active_session_history h WHERE h.sample_time >= lg.event_date AND h.sample_time < lg.next_date AND h.user_id = (SELECT user_id FROM all_users WHERE username = 'SCM_MGR')
         AND (h.module LIKE 'RUN_C_%' OR h.module LIKE 'RERUN_QTY_BALANCE%' OR h.program LIKE 'SQL Developer%' OR h.program LIKE 'DBeaver%')) AS top_sql
  FROM lg
 WHERE lg.next_date IS NOT NULL
 ORDER BY lg.event_date;


/* ---------- T2. 모듈·액션별 ASH — 03b(RUN_C_NEW_1464: MF_W / SF_W / COMPARE) 또는 11(RERUN_QTY_BALANCE_40_1464). 14:04 실행과 같은 자리에서 비교 ---------- */
SELECT h.module, h.action, COUNT(*) AS ash_sec
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_
     , ROUND((CAST(MAX(h.sample_time) AS DATE) - CAST(MIN(h.sample_time) AS DATE)) * 86400) + 1 AS wall_sec
     , SUM(CASE WHEN h.event IS NULL THEN 1 ELSE 0 END) AS cpu_sec
     , SUM(CASE WHEN h.wait_class = 'User I/O' THEN 1 ELSE 0 END) AS io_sec
     , SUM(CASE WHEN h.wait_class = 'Cluster' THEN 1 ELSE 0 END) AS cluster_sec
     , SUM(CASE WHEN h.wait_class = 'Concurrency' THEN 1 ELSE 0 END) AS concurrency_sec
     , SUM(CASE WHEN h.wait_class = 'Application' THEN 1 ELSE 0 END) AS lock_sec
     , SUM(CASE WHEN h.event IS NOT NULL AND NVL(h.wait_class, 'x') NOT IN ('User I/O', 'Cluster', 'Concurrency', 'Application') THEN 1 ELSE 0 END) AS other_wait_sec
  FROM v$active_session_history h
 WHERE h.module IN ('RUN_C_NEW_1464', 'RUN_C_OLD_1464', 'RERUN_QTY_BALANCE_40_1464')
   AND h.sample_time >= TRUNC(SYSDATE)
 GROUP BY h.module, h.action
 ORDER BY MIN(h.sample_time);


/* ---------- T3. 문장별 ASH — 신판 창(오늘 15:00 이후 모듈) vs 14:04 창(RERUN_QTY_BALANCE_40_1464 14:06:07~14:11:45 = C 2회). 문장 텍스트 앞 70자로 묶어 sql_id 가 바뀐 문장도 같은 줄에 ---------- */
WITH a AS (
    SELECT CASE WHEN h.sample_time >= TRUNC(SYSDATE) + 15/24 THEN 'NEW' ELSE 'OLD_1404' END AS win
         , h.sql_id, h.sql_plan_hash_value AS phv, h.event, h.wait_class
      FROM v$active_session_history h
     WHERE (h.module IN ('RUN_C_NEW_1464', 'RUN_C_OLD_1464') AND h.sample_time >= TRUNC(SYSDATE) + 15/24)
        OR (h.module = 'RERUN_QTY_BALANCE_40_1464' AND h.sample_time BETWEEN TO_TIMESTAMP('2026-10-08 14:06:07', 'YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP('2026-10-08 14:11:45', 'YYYY-MM-DD HH24:MI:SS'))
        OR (h.module = 'RERUN_QTY_BALANCE_40_1464' AND h.sample_time >= TRUNC(SYSDATE) + 15/24))
, t AS (
    SELECT a.win, a.sql_id, MAX(a.phv) AS phv, COUNT(*) AS sec, SUM(CASE WHEN a.event IS NULL THEN 1 ELSE 0 END) AS cpu_sec
         , SUBSTR(STATS_MODE(CASE WHEN a.event IS NOT NULL THEN a.event END), 1, 28) AS top_wait
         , SUBSTR(REPLACE(REPLACE((SELECT q.sql_text FROM v$sqlarea q WHERE q.sql_id = a.sql_id), CHR(10), ' '), CHR(13), ' '), 1, 70) AS stmt
      FROM a GROUP BY a.win, a.sql_id)
SELECT NVL(n.stmt, o.stmt) AS stmt_head
     , n.sql_id AS new_sql_id, n.phv AS new_phv, n.sec AS new_sec, n.cpu_sec AS new_cpu, n.top_wait AS new_top_wait
     , o.sql_id AS old_sql_id, o.phv AS old_phv, o.sec AS old_sec
     , NVL(n.sec, 0) - NVL(o.sec, 0) AS delta_sec
  FROM (SELECT * FROM t WHERE win = 'NEW') n
  FULL OUTER JOIN (SELECT * FROM t WHERE win = 'OLD_1404') o ON o.stmt = n.stmt
 WHERE NVL(n.sec, 0) >= 2 OR NVL(o.sec, 0) >= 2
 ORDER BY NVL(n.sec, 0) - NVL(o.sec, 0) DESC, NVL(n.sec, 0) DESC;
-- 해석: delta_sec 가 큰 양수 = 신판에서 늘어난 문장. new_phv 가 old_phv 와 다르면 플랜 교체. stmt_head 가 NULL/빈 문장은 공유풀에서 밀린 것(sql_id 로 V$SQL 재조회).


/* ---------- T4. 신판 핫 문장 — V$SQL 누적(실행당 초·버퍼·행) + 실제 플랜(PARTITION Pstart/Pstop 확인). 변경 문장은 텍스트로 찾는다 ---------- */
SELECT s.sql_id, s.child_number, s.plan_hash_value AS phv, s.executions, ROUND(s.elapsed_time / 1e6, 1) AS elapsed_sec
     , ROUND(s.elapsed_time / NULLIF(s.executions, 0) / 1e6, 1) AS sec_per_exec, ROUND(s.cpu_time / 1e6, 1) AS cpu_sec, ROUND(s.user_io_wait_time / 1e6, 1) AS io_sec
     , s.buffer_gets, s.disk_reads, s.rows_processed, TO_CHAR(s.last_active_time, 'HH24:MI:SS') AS last_active, TO_CHAR(s.last_load_time) AS loaded
     , SUBSTR(REPLACE(REPLACE(s.sql_text, CHR(10), ' '), CHR(13), ' '), 1, 90) AS sql_text
  FROM v$sql s
 WHERE s.parsing_schema_name = 'SCM_MGR' AND s.last_active_time >= TRUNC(SYSDATE) + 15/24
   AND (s.sql_text LIKE 'INSERT INTO GT_DPMFCQB_VMI_MST_MAIN%'
     OR s.sql_text LIKE 'DELETE FROM DM_PLN_MKT_FCST_C WHERE MEASURE = ''BALANCE''%'
     OR s.sql_text LIKE 'INSERT INTO DM_PLN_MKT_FCST_C ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1%'
     OR s.sql_text LIKE 'DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE MEASURE = ''BALANCE''%'
     OR s.sql_text LIKE 'INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD , PROJECT_CODE, END_CUSTOMER%'
     OR s.sql_text LIKE 'INSERT INTO GT_DPMFCQB_CUTOFF_TEMPX%'
     OR s.sql_text LIKE 'INSERT INTO GT_DPMFCQB_CUTOFF_MST %'
     OR s.sql_text LIKE 'DELETE FROM DM_PLN_MKT_FCST_C A WHERE A.MEASURE IN ( SELECT MEASURE FROM GT_DPMFCQB_MEASURE_MF_ALL%'
     OR s.sql_text LIKE 'INSERT INTO GT_DPMFCQB_MKT_FCST_INSERT%'
     OR s.sql_text LIKE 'INSERT INTO GT_DPMFCQB_MF_C_BALANCE_MKT_FCST%')
 ORDER BY s.elapsed_time DESC;

-- T4-b. 신판 VMI INSERT 실제 플랜 (오늘 15:00 이후 활성 커서) — 기대: DM_PLN_CFM_MKT_DEMAND_PLAN_C 접근이 PARTITION RANGE SINGLE / Pstart=Pstop
SELECT p.plan_table_output
  FROM v$sql s, TABLE(DBMS_XPLAN.DISPLAY_CURSOR(s.sql_id, s.child_number, 'BASIC +PREDICATE +PARTITION +ROWS')) p
 WHERE s.parsing_schema_name = 'SCM_MGR' AND s.last_active_time >= TRUNC(SYSDATE) + 15/24
   AND s.sql_text LIKE 'INSERT INTO GT_DPMFCQB_VMI_MST_MAIN%' AND s.sql_text LIKE '%CUTOFF_YYYYMMDD_DATE%';

-- T4-c. 신판 BALANCE DELETE(MKT_FCST_C) 실제 플랜 — 기대: PARTITION RANGE SINGLE
SELECT p.plan_table_output
  FROM v$sql s, TABLE(DBMS_XPLAN.DISPLAY_CURSOR(s.sql_id, s.child_number, 'BASIC +PREDICATE +PARTITION +ROWS')) p
 WHERE s.parsing_schema_name = 'SCM_MGR' AND s.last_active_time >= TRUNC(SYSDATE) + 15/24
   AND s.sql_text LIKE 'DELETE FROM DM_PLN_MKT_FCST_C WHERE MEASURE = ''BALANCE''%' AND s.sql_text LIKE '%CUTOFF_YYYYMMDD_DATE%';

-- T4-d. 신판 TEMPX 직접 적재(ACCUM 제거분) 실제 플랜
SELECT p.plan_table_output
  FROM v$sql s, TABLE(DBMS_XPLAN.DISPLAY_CURSOR(s.sql_id, s.child_number, 'BASIC +PREDICATE +ROWS')) p
 WHERE s.parsing_schema_name = 'SCM_MGR' AND s.last_active_time >= TRUNC(SYSDATE) + 15/24
   AND s.sql_text LIKE 'INSERT INTO GT_DPMFCQB_CUTOFF_TEMPX%' AND s.sql_text LIKE '%NOT EXISTS%';


/* ---------- T5. 같은 시간대 DB 전체 부하 — 신판 실행 창에서 다른 세션이 얼마나 돌았나 (14:04 와 환경 차이: 경합·동시 배치) ---------- */
WITH w AS (
    SELECT MIN(sample_time) AS f, MAX(sample_time) AS t
      FROM v$active_session_history WHERE module IN ('RUN_C_NEW_1464', 'RERUN_QTY_BALANCE_40_1464') AND sample_time >= TRUNC(SYSDATE) + 15/24)
SELECT CASE WHEN h.module IN ('RUN_C_NEW_1464', 'RERUN_QTY_BALANCE_40_1464') THEN 'THIS_RUN' ELSE 'OTHERS' END AS who
     , NVL(h.module, '(null)') AS module, h.session_id, h.user_id
     , COUNT(*) AS ash_sec, SUM(CASE WHEN h.event IS NULL THEN 1 ELSE 0 END) AS cpu_sec
     , SUBSTR(STATS_MODE(h.event), 1, 28) AS top_event, SUBSTR(STATS_MODE(h.sql_id), 1, 13) AS top_sql
  FROM v$active_session_history h, w
 WHERE h.sample_time BETWEEN w.f AND w.t
 GROUP BY CASE WHEN h.module IN ('RUN_C_NEW_1464', 'RERUN_QTY_BALANCE_40_1464') THEN 'THIS_RUN' ELSE 'OTHERS' END, NVL(h.module, '(null)'), h.session_id, h.user_id
HAVING COUNT(*) >= 5
 ORDER BY 1, ash_sec DESC;

-- T5-b. 14:04 창의 동일 지표 (비교용) — V$ 에서 빠졌으면 dba_hist 로
SELECT CASE WHEN h.module = 'RERUN_QTY_BALANCE_40_1464' THEN 'THIS_RUN' ELSE 'OTHERS' END AS who, COUNT(DISTINCT h.session_id) AS sessions, COUNT(*) AS ash_sec
  FROM v$active_session_history h
 WHERE h.sample_time BETWEEN TO_TIMESTAMP('2026-10-08 14:03:58', 'YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP('2026-10-08 14:11:45', 'YYYY-MM-DD HH24:MI:SS')
 GROUP BY CASE WHEN h.module = 'RERUN_QTY_BALANCE_40_1464' THEN 'THIS_RUN' ELSE 'OTHERS' END;


/* ---------- T6. 통계 상태 — 이번 주 파티션 통계(E-Rows 1 원인) · GTT 세션 통계 선호 · 신판 첫 실행 하드파스 여부 ---------- */
SELECT p.table_name, p.partition_name, p.num_rows, TO_CHAR(p.last_analyzed, 'MM-DD HH24:MI') AS last_analyzed
  FROM all_tab_partitions p
 WHERE p.table_owner = 'SCM_MGR' AND p.table_name IN ('DM_PLN_MKT_FCST_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C')
   AND p.partition_position >= (SELECT MAX(partition_position) - 1 FROM all_tab_partitions p2 WHERE p2.table_owner = p.table_owner AND p2.table_name = p.table_name)
 ORDER BY 1, p.partition_position;

SELECT s.sql_id, s.plan_hash_value, s.executions, s.parse_calls, s.loads, s.invalidations, TO_CHAR(s.last_load_time) AS last_load, ROUND(s.elapsed_time / 1e6, 1) AS elapsed_sec
     , SUBSTR(REPLACE(s.sql_text, CHR(10), ' '), 1, 60) AS sql_text
  FROM v$sql s
 WHERE s.parsing_schema_name = 'SCM_MGR' AND s.last_active_time >= TRUNC(SYSDATE) + 15/24
   AND s.sql_text LIKE '%CUTOFF_YYYYMMDD_DATE = :%'
 ORDER BY s.elapsed_time DESC
 FETCH FIRST 15 ROWS ONLY;
