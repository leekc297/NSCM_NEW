/* =====================================================================================================
 * 실측 쿼리 — 1순위 구간: PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING 루트 자체 로직 93초 (40 / MF_W)
 *   구간 = VERSION_CREATE END ~ FUTURE_PRICE_CUTOFF START. 원문 = 02_root_block_L236-712_corp_20261007.sql
 *   40/MF_W 에서 실행되는 문장 (사내 줄번호 기준 — 클라우드 줄번호는 Q7 의 ALL_SOURCE 조인으로 확인)
 *     L248 DELETE DM_PLN_MKT_FCST (40, MKT_FCST_PRE 계열)      L254 INSERT DM_PLN_MKT_FCST ← DM_PLN_MKT_FCST
 *     L291 DELETE DM_PLN_CFM_MKT_DEMAND_PLAN                     L297 INSERT DM_PLN_CFM_MKT_DEMAND_PLAN ← 자기 자신
 *     L384 INSERT DM_PLN_MKT_FCST_C ← DM_PLN_MKT_FCST (UNION ALL 2 갈래)
 *     L517 INSERT DM_PLN_MKT_FCST_RESULT_C ← DM_PLN_MKT_FCST_RESULT
 *     L616 DELETE DM_PLN_CFM_MKT_DEMAND_PLAN_C                   L623 INSERT DM_PLN_CFM_MKT_DEMAND_PLAN_C ← DM_PLN_CFM_MKT_DEMAND_PLAN
 *     L709 COMMIT
 *   + 2·3순위 SP(PR_SCM_MST_FUTURE_PRICE_CUTOFF 82초 · PR_DM_PLN_MKT_FCST_TO_NET_DEMAND 55초)도 같은 방식으로 문장별 실측
 * 원칙(hook #129): 대상 환경(클라우드) 실측이 먼저 — 수정·힌트 없음. 조회 전용 · DB 변경 없음.
 * 실행 계정: SCM_MGR (V$ 조회는 Q6 가 됐던 계정이면 됨). SQL*Plus 전용 명령 없음.
 * ===================================================================================================== */

/* ---------- Q7. 문장별 실측 (공유풀) — SP 안 각 SQL 의 실행 횟수·누적 시간·I/O·행수 ----------
 * V$SQLAREA.PROGRAM_ID = SP 의 OBJECT_ID, PROGRAM_LINE# = 그 문장이 시작하는 줄. ALL_SOURCE 를 붙여 문장 첫 줄을 같이 보인다.
 * 최근 실행(이번 주 월요일 15:00 MF_W, 00:xx MF_D 등)이 공유풀에 남아 있을 때만 나온다 — 비어 있으면 Q10 의 ASH/AWR 로.
 * 3 SP 를 한 번에: elapsed_sec 상위가 튜닝 대상. sec_per_exec 가 크고 executions 가 1~2 = 배치 1회당 그 시간.        */
SELECT o.object_name                                             AS sp
     , s.program_line#                                          AS line_no
     , REGEXP_REPLACE(SUBSTR(src.text, 1, 90), '\s+', ' ')      AS stmt_first_line
     , s.sql_id, s.plan_hash_value
     , s.executions
     , ROUND(s.elapsed_time / 1e6, 1)                           AS elapsed_sec
     , ROUND(s.elapsed_time / NULLIF(s.executions, 0) / 1e6, 1) AS sec_per_exec
     , ROUND(s.cpu_time / 1e6, 1)                               AS cpu_sec
     , ROUND((s.elapsed_time - s.cpu_time) / 1e6, 1)            AS wait_sec
     , s.buffer_gets, s.disk_reads, s.rows_processed
     , ROUND(s.buffer_gets / NULLIF(s.executions, 0))           AS gets_per_exec
     , s.last_active_time
     , SUBSTR(s.sql_text, 1, 120)                               AS sql_text
  FROM v$sqlarea s
  JOIN all_objects o  ON o.object_id = s.program_id AND o.owner = 'SCM_MGR'
  LEFT JOIN all_source src ON src.owner = o.owner AND src.name = o.object_name AND src.type = o.object_type AND src.line = s.program_line#
 WHERE o.object_name IN ('PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_PLN_MKT_FCST_TO_NET_DEMAND')
   AND s.parsing_schema_name = 'SCM_MGR'
 ORDER BY s.elapsed_time DESC
 FETCH FIRST 60 ROWS ONLY;


/* ---------- Q8. 특정 문장의 실행계획 (Q7 의 SQL_ID 를 넣는다) ----------
 * 실제 실행된 커서의 계획. STATISTICS_LEVEL=ALL 이 아니면 A-Rows 가 비므로 E-Rows(예상)로 읽는다.
 * Q7 에서 elapsed_sec 상위 3개 SQL_ID 에 대해 각각 실행해 결과를 붙여 주면 된다.                              */
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('&sql_id', NULL, 'ALLSTATS LAST +PREDICATE +NOTE'));
-- SQL Developer 외 도구에서 &치환이 안 되면: '&sql_id' 자리에 Q7 의 sql_id 문자열을 직접 넣는다.


/* ---------- Q9. 40 사업부 데이터 규모 — 각 문장이 다루는 행수 (카디널리티) ----------
 * 93초가 "행이 많아서" 인지 "계획이 나빠서" 인지 가르는 기준. 전부 COUNT 라 테이블 크기에 비례해 걸린다(사내 4.6분 — 한가한 시간에).  */
SELECT 'DM_PLN_MKT_FCST 40 전체' AS what, COUNT(*) AS cnt FROM SCM_MGR.DM_PLN_MKT_FCST WHERE division_id = '40'
UNION ALL SELECT 'DM_PLN_MKT_FCST 40 MEASURE=' || measure, COUNT(*) FROM (SELECT measure FROM SCM_MGR.DM_PLN_MKT_FCST WHERE division_id = '40') GROUP BY measure
UNION ALL SELECT 'DM_PLN_MKT_FCST_C 40 최신 MF_W 버전 행', COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_C
           WHERE division_id = '40' AND version_no = (SELECT MAX(version_no) FROM SCM_MGR.DM_PLN_MKT_FCST_C WHERE division_id = '40' AND cutoff_type = 'MF_W')
UNION ALL SELECT 'DM_PLN_MKT_FCST_C 40 전체(모든 버전)', COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_C WHERE division_id = '40'
UNION ALL SELECT 'DM_PLN_MKT_FCST_RESULT 40', COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT WHERE division_id = '40'
UNION ALL SELECT 'DM_PLN_MKT_FCST_RESULT_C 40 최신 버전 행', COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C
           WHERE division_id = '40' AND version_no = (SELECT MAX(version_no) FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C WHERE division_id = '40')
UNION ALL SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN 40', COUNT(*) FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN WHERE division_id = '40'
UNION ALL SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN_C 40 최신 버전 행', COUNT(*) FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C
           WHERE division_id = '40' AND version_no = (SELECT MAX(version_no) FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE division_id = '40')
UNION ALL SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN_C 40 전체(모든 버전)', COUNT(*) FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE division_id = '40';


/* ---------- Q10. 대상 테이블 통계·크기·인덱스·파티션 — 통계 부실/인덱스 부재/풀스캔 근거 ---------- */
SELECT t.table_name, t.num_rows, t.blocks, ROUND(t.blocks * 8 / 1024) AS mb_est
     , TO_CHAR(t.last_analyzed, 'YYYY-MM-DD HH24:MI') AS last_analyzed
     , m.inserts + m.updates + m.deletes                AS mods_since_stats
     , ROUND((m.inserts + m.updates + m.deletes) / NULLIF(t.num_rows, 0) * 100, 1) AS stale_pct
     , t.partitioned, t.degree
     , (SELECT LISTAGG(i.index_name || '(' || i.cols || ')' || CASE WHEN i.uniqueness = 'UNIQUE' THEN '*' END, ' / ') WITHIN GROUP (ORDER BY i.index_name)
          FROM (SELECT ix.table_name, ix.index_name, ix.uniqueness
                     , LISTAGG(ic.column_name, ',') WITHIN GROUP (ORDER BY ic.column_position) AS cols
                  FROM all_indexes ix JOIN all_ind_columns ic ON ic.index_owner = ix.owner AND ic.index_name = ix.index_name
                 WHERE ix.table_owner = 'SCM_MGR' GROUP BY ix.table_name, ix.index_name, ix.uniqueness) i
         WHERE i.table_name = t.table_name)                  AS indexes
  FROM all_tables t
  LEFT JOIN all_tab_modifications m ON m.table_owner = t.owner AND m.table_name = t.table_name AND m.partition_name IS NULL
 WHERE t.owner = 'SCM_MGR'
   AND t.table_name IN ('DM_PLN_MKT_FCST', 'DM_PLN_MKT_FCST_C', 'DM_PLN_MKT_FCST_RESULT', 'DM_PLN_MKT_FCST_RESULT_C'
                      , 'DM_PLN_CFM_MKT_DEMAND_PLAN', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', 'SCM_MST_FUTURE_PRICE', 'SCM_MST_FUTURE_PRICE_C'
                      , 'DM_PLN_NET_DEMAND', 'DM_PLN_MKT_FCST_CONFIRM')
 ORDER BY t.table_name;

/* ---------- Q10b. 파티션 테이블이면 파티션 키·개수 ---------- */
SELECT p.table_name, p.partitioning_type, p.partition_count, p.subpartitioning_type
     , (SELECT LISTAGG(k.column_name, ',') WITHIN GROUP (ORDER BY k.column_position) FROM all_part_key_columns k WHERE k.owner = p.owner AND k.name = p.table_name) AS part_key
  FROM all_part_tables p
 WHERE p.owner = 'SCM_MGR'
   AND p.table_name IN ('DM_PLN_MKT_FCST', 'DM_PLN_MKT_FCST_C', 'DM_PLN_MKT_FCST_RESULT', 'DM_PLN_MKT_FCST_RESULT_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C');


/* ---------- Q11. 최근 40/MF_W 실행의 93초 구간 시각 (Q12 ASH 입력) ---------- */
SELECT TO_CHAR(r.run_start, 'YYYY-MM-DD HH24:MI:SS') AS block_start
     , TO_CHAR((SELECT MIN(f.event_date) FROM SCM_MGR.SCM_SYS_LOG_BATCH f
                 WHERE f.program_name = 'PR_SCM_MST_FUTURE_PRICE_CUTOFF' AND f.log_type = 'START' AND f.event_date > r.run_start AND f.created_by = r.created_by), 'YYYY-MM-DD HH24:MI:SS') AS block_end
  FROM (SELECT l.event_date AS run_start, l.created_by
          FROM SCM_MGR.SCM_SYS_LOG_BATCH l
         WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND l.description = 'Div: 40 / MF_W' AND l.log_type = 'START'
           AND l.event_date >= TRUNC(SYSDATE) - 14
         ORDER BY l.event_date DESC FETCH FIRST 2 ROWS ONLY) r;


/* ---------- Q12. (선택 · Diagnostics Pack 라이선스/권한 있을 때) ASH — 93초 동안 어떤 SQL 이 무엇을 기다렸나 ----------
 * Q11 의 block_start/block_end 를 넣는다. 1초 샘플이라 count ≈ 초. 공유풀에서 밀려난 뒤에도 7일 정도 남는다(DBA_HIST 는 더 오래).
 * 권한 없으면 ORA-00942 — 그러면 Q7 결과로만 간다.                                                                    */
SELECT a.sql_id, a.sql_plan_hash_value
     , NVL(a.event, 'ON CPU')                                 AS event
     , a.sql_plan_operation || ' ' || a.sql_plan_options       AS plan_step
     , COUNT(*)                                                AS samples_sec
     , MIN(TO_CHAR(a.sample_time, 'HH24:MI:SS'))               AS first_seen
     , MAX(TO_CHAR(a.sample_time, 'HH24:MI:SS'))               AS last_seen
     , SUBSTR(MAX(s.sql_text), 1, 100)                          AS sql_text
  FROM v$active_session_history a
  LEFT JOIN v$sqlarea s ON s.sql_id = a.sql_id
 WHERE a.sample_time BETWEEN TO_TIMESTAMP('&block_start', 'YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP('&block_end', 'YYYY-MM-DD HH24:MI:SS')
   AND a.user_id = (SELECT user_id FROM all_users WHERE username = 'SCM_MGR')
 GROUP BY a.sql_id, a.sql_plan_hash_value, NVL(a.event, 'ON CPU'), a.sql_plan_operation || ' ' || a.sql_plan_options
 ORDER BY samples_sec DESC
 FETCH FIRST 40 ROWS ONLY;

/* ---------- Q13. AWR 스냅샷 기준 문장별 실측 — 공유풀에서 밀려난 문장까지 전부 (DBA_HIST_SQLSTAT) ----------
 * 실행 시각을 품는 스냅샷 구간(보통 1시간)의 문장별 증가분(DELTA). 10-05 15:00 실행이면 14:00~16:00 스냅샷.
 * Q7 에 안 보이던 L248/254/291/297/384/616/623 문장이 여기 나온다. 날짜 두 곳을 바꿔 쓴다.                          */
SELECT x.sql_id, x.plan_hash_value, x.execs, x.elapsed_sec, x.cpu_sec, x.io_wait_sec, x.buffer_gets, x.disk_reads, x.rows_processed, x.module
     , o.object_name                                    AS sp
     , x.line_no
     , DBMS_LOB.SUBSTR(t.sql_text, 110, 1)              AS sql_text
  FROM (SELECT st.sql_id, st.plan_hash_value, st.dbid
             , SUM(st.executions_delta)                   AS execs
             , ROUND(SUM(st.elapsed_time_delta) / 1e6, 1) AS elapsed_sec
             , ROUND(SUM(st.cpu_time_delta) / 1e6, 1)     AS cpu_sec
             , ROUND(SUM(st.iowait_delta) / 1e6, 1)       AS io_wait_sec
             , SUM(st.buffer_gets_delta)                  AS buffer_gets
             , SUM(st.disk_reads_delta)                   AS disk_reads
             , SUM(st.rows_processed_delta)               AS rows_processed
             , MAX(st.module)                             AS module
             , MAX(sq.program_id)                         AS program_id
             , MAX(sq.program_line#)                      AS line_no
          FROM dba_hist_sqlstat st
          JOIN dba_hist_snapshot sn ON sn.snap_id = st.snap_id AND sn.dbid = st.dbid AND sn.instance_number = st.instance_number
          LEFT JOIN v$sqlarea sq ON sq.sql_id = st.sql_id
         WHERE sn.begin_interval_time >= TO_TIMESTAMP('2026-10-05 14:00', 'YYYY-MM-DD HH24:MI')
           AND sn.end_interval_time   <= TO_TIMESTAMP('2026-10-05 16:30', 'YYYY-MM-DD HH24:MI')
           AND st.parsing_schema_name = 'SCM_MGR'
           AND st.elapsed_time_delta > 2 * 1e6
         GROUP BY st.sql_id, st.plan_hash_value, st.dbid) x
  LEFT JOIN all_objects o      ON o.object_id = x.program_id AND o.owner = 'SCM_MGR'
  LEFT JOIN (SELECT sql_id, dbid, MAX(DBMS_LOB.SUBSTR(sql_text, 110, 1)) AS sql_text FROM dba_hist_sqltext GROUP BY sql_id, dbid) t
         ON t.sql_id = x.sql_id AND t.dbid = x.dbid
 ORDER BY x.elapsed_sec DESC
 FETCH FIRST 40 ROWS ONLY;

/* ---------- Q13b. Q13 의 SQL_ID 하나의 AWR 실행계획 + 전체 원문 (공유풀에 없어도 됨) ---------- */
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('&sql_id', NULL, NULL, 'TYPICAL +PREDICATE'));
-- 원문 전체: SELECT sql_text FROM dba_hist_sqltext WHERE sql_id = '&sql_id';

/* ---------- Q12b. 7일보다 오래됐으면 AWR 이력 (DBA_HIST — 권한·라이선스 필요) ---------- */
SELECT a.sql_id, NVL(a.event, 'ON CPU') AS event, COUNT(*) * 10 AS approx_sec
  FROM dba_hist_active_sess_history a
 WHERE a.sample_time BETWEEN TO_TIMESTAMP('&block_start', 'YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP('&block_end', 'YYYY-MM-DD HH24:MI:SS')
   AND a.user_id = (SELECT user_id FROM all_users WHERE username = 'SCM_MGR')
 GROUP BY a.sql_id, NVL(a.event, 'ON CPU')
 ORDER BY approx_sec DESC
 FETCH FIRST 40 ROWS ONLY;
