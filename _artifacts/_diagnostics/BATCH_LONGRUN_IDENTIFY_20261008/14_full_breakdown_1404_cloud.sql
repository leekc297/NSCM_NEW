/* =====================================================================================================
 * 14 — 클라우드 실행용 (긴급: V$ASH 1초 샘플이 살아 있을 때): 2026-10-08 14:03:58~14:11:44 실행(모듈 RERUN_QTY_BALANCE_40_1464, SID 948)의
 *      루트 / C#1 / C#2 구간별 **전 문장** 소요 분포 (hook #129 0-a 전수) + 상위 문장 플랜 라인 (0-b) + 로그 간격 대비 ASH 커버리지
 *      구간(step 로그 기준): ROOT = 14:03:58~14:06:07 · C1(MF_W_20261005_V001) = 14:06:07~14:09:05 · GAP = 14:09:05~14:09:23 · C2(SF_W_20261005_V001) = 14:09:23~14:11:44
 *      13:30 실행(같은 모듈명)은 시간창으로 제외한다. V$ 에서 샘플이 빠졌으면 각 쿼리의 v$active_session_history 를 dba_hist_active_sess_history 로 바꾸고
 *      (h.dbid = h.con_dbid 추가, 초 = COUNT(*)*10) 재실행 — 정밀도는 10초로 떨어진다.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

/* ---------- K0. 샘플 생존 확인 — 14:03~14:12 모듈 샘플 수 (기대 ≈ 440 ± ; 0 이면 V$ 에서 빠진 것 → dba_hist 로 전환) ---------- */
SELECT COUNT(*) AS samples_1s, TO_CHAR(MIN(sample_time), 'HH24:MI:SS') AS first_, TO_CHAR(MAX(sample_time), 'HH24:MI:SS') AS last_
     , SUM(CASE WHEN event IS NULL THEN 1 ELSE 0 END) AS cpu_sec, SUM(CASE WHEN event IS NOT NULL THEN 1 ELSE 0 END) AS wait_sec
  FROM v$active_session_history
 WHERE module = 'RERUN_QTY_BALANCE_40_1464'
   AND sample_time BETWEEN TO_TIMESTAMP('2026-10-08 14:03:50', 'YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP('2026-10-08 14:11:50', 'YYYY-MM-DD HH24:MI:SS');


/* ---------- K1. 구간 × 대기클래스 — 어느 구간이 크고, CPU 인가 I/O 인가 ---------- */
WITH ph AS (
    SELECT 'ROOT' AS phase, TO_TIMESTAMP('2026-10-08 14:03:58', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_TIMESTAMP('2026-10-08 14:06:07', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual UNION ALL
    SELECT 'C1_MF_W',       TO_TIMESTAMP('2026-10-08 14:06:07', 'YYYY-MM-DD HH24:MI:SS'),      TO_TIMESTAMP('2026-10-08 14:09:05', 'YYYY-MM-DD HH24:MI:SS')      FROM dual UNION ALL
    SELECT 'GAP',           TO_TIMESTAMP('2026-10-08 14:09:05', 'YYYY-MM-DD HH24:MI:SS'),      TO_TIMESTAMP('2026-10-08 14:09:23', 'YYYY-MM-DD HH24:MI:SS')      FROM dual UNION ALL
    SELECT 'C2_SF_W',       TO_TIMESTAMP('2026-10-08 14:09:23', 'YYYY-MM-DD HH24:MI:SS'),      TO_TIMESTAMP('2026-10-08 14:11:45', 'YYYY-MM-DD HH24:MI:SS')      FROM dual)
SELECT ph.phase
     , ROUND((CAST(ph.t AS DATE) - CAST(ph.f AS DATE)) * 86400) AS wall_sec
     , COUNT(h.sample_id) AS ash_sec
     , SUM(CASE WHEN h.event IS NULL THEN 1 ELSE 0 END) AS cpu_sec
     , SUM(CASE WHEN h.wait_class = 'User I/O' THEN 1 ELSE 0 END) AS io_sec
     , SUM(CASE WHEN h.wait_class = 'Cluster' THEN 1 ELSE 0 END) AS cluster_sec
     , SUM(CASE WHEN h.wait_class = 'Concurrency' THEN 1 ELSE 0 END) AS concurrency_sec
     , SUM(CASE WHEN h.wait_class = 'Application' THEN 1 ELSE 0 END) AS lock_sec
     , SUM(CASE WHEN h.event IS NOT NULL AND NVL(h.wait_class, 'x') NOT IN ('User I/O', 'Cluster', 'Concurrency', 'Application') THEN 1 ELSE 0 END) AS other_wait_sec
     , ROUND((CAST(ph.t AS DATE) - CAST(ph.f AS DATE)) * 86400) - COUNT(h.sample_id) AS idle_or_unsampled_sec   -- 벽시계 − ASH = DB 밖 시간(세션 유휴·네트워크·COMMIT 대기 등)
  FROM ph LEFT JOIN v$active_session_history h
    ON h.module = 'RERUN_QTY_BALANCE_40_1464' AND h.sample_time >= ph.f AND h.sample_time < ph.t
 GROUP BY ph.phase, ph.f, ph.t
 ORDER BY ph.f;


/* ---------- K2. 구간 × SQL 전수 (2초 이상 전부) — 0-a. 구간 안 비중(pct_in_phase)과 전체 비중(pct_total) ---------- */
WITH ph AS (
    SELECT 'ROOT' AS phase, TO_TIMESTAMP('2026-10-08 14:03:58', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_TIMESTAMP('2026-10-08 14:06:07', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual UNION ALL
    SELECT 'C1_MF_W',       TO_TIMESTAMP('2026-10-08 14:06:07', 'YYYY-MM-DD HH24:MI:SS'),      TO_TIMESTAMP('2026-10-08 14:09:05', 'YYYY-MM-DD HH24:MI:SS')      FROM dual UNION ALL
    SELECT 'GAP',           TO_TIMESTAMP('2026-10-08 14:09:05', 'YYYY-MM-DD HH24:MI:SS'),      TO_TIMESTAMP('2026-10-08 14:09:23', 'YYYY-MM-DD HH24:MI:SS')      FROM dual UNION ALL
    SELECT 'C2_SF_W',       TO_TIMESTAMP('2026-10-08 14:09:23', 'YYYY-MM-DD HH24:MI:SS'),      TO_TIMESTAMP('2026-10-08 14:11:45', 'YYYY-MM-DD HH24:MI:SS')      FROM dual)
, a AS (
    SELECT ph.phase, h.sql_id, h.sql_plan_hash_value AS phv, h.event, h.wait_class, h.sql_opname
      FROM ph JOIN v$active_session_history h
        ON h.module = 'RERUN_QTY_BALANCE_40_1464' AND h.sample_time >= ph.f AND h.sample_time < ph.t)
SELECT phase, sql_id, MAX(phv) AS phv, MAX(sql_opname) AS op
     , COUNT(*) AS sec
     , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER (PARTITION BY phase) * 100, 1) AS pct_in_phase
     , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1) AS pct_total
     , SUM(CASE WHEN event IS NULL THEN 1 ELSE 0 END) AS cpu_sec
     , SUM(CASE WHEN event IS NOT NULL THEN 1 ELSE 0 END) AS wait_sec
     , SUBSTR(STATS_MODE(CASE WHEN event IS NOT NULL THEN event END), 1, 30) AS top_wait_event
     , (SELECT SUBSTR(REPLACE(REPLACE(q.sql_text, CHR(10), ' '), CHR(13), ' '), 1, 110) FROM v$sqlarea q WHERE q.sql_id = a.sql_id) AS sql_text
  FROM a
 GROUP BY phase, sql_id
HAVING COUNT(*) >= 2
 ORDER BY CASE phase WHEN 'ROOT' THEN 1 WHEN 'C1_MF_W' THEN 2 WHEN 'GAP' THEN 3 ELSE 4 END, sec DESC;


/* ---------- K3. SQL × 플랜 라인 × 이벤트 (5초 이상 문장만) — 0-b. 어느 연산(라인)에서 시간이 가는가 ---------- */
WITH a AS (
    SELECT h.sql_id, h.sql_plan_hash_value AS phv, h.sql_plan_line_id AS line_id, h.sql_plan_operation || ' ' || h.sql_plan_options AS op, NVL(h.event, 'ON CPU') AS event
         , h.current_obj#
      FROM v$active_session_history h
     WHERE h.module = 'RERUN_QTY_BALANCE_40_1464'
       AND h.sample_time BETWEEN TO_TIMESTAMP('2026-10-08 14:03:58', 'YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP('2026-10-08 14:11:45', 'YYYY-MM-DD HH24:MI:SS'))
, tot AS (SELECT sql_id, COUNT(*) AS sql_sec FROM a GROUP BY sql_id HAVING COUNT(*) >= 5)
, g AS (
    SELECT a.sql_id, t.sql_sec, a.phv, a.line_id, a.op, a.event
         , COUNT(*) AS sec, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER (PARTITION BY a.sql_id) * 100, 1) AS pct_in_sql
         , STATS_MODE(a.current_obj#) AS obj_id
      FROM a JOIN tot t ON t.sql_id = a.sql_id
     GROUP BY a.sql_id, t.sql_sec, a.phv, a.line_id, a.op, a.event)
SELECT g.sql_id, g.sql_sec, g.phv, g.line_id, SUBSTR(g.op, 1, 34) AS plan_op, SUBSTR(g.event, 1, 30) AS event
     , g.sec, g.pct_in_sql
     , SUBSTR((SELECT o.object_name FROM dba_objects o WHERE o.object_id = g.obj_id), 1, 36) AS current_obj   -- I/O 대기 시 읽던 객체
  FROM g
 ORDER BY g.sql_sec DESC, g.sql_id, g.sec DESC;


/* ---------- K4. 상위 문장 실행계획 (공유풀에 남아 있는 커서, 실제 행수 포함 시도) — K2 상위 sql_id 를 넣는다. 기본 4개 ---------- */
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('9nrrfxjtcj8xd', NULL, 'ALLSTATS LAST +PREDICATE +PARTITION'));   -- MKT_FCST_C BALANCE DELETE (물리읽기 47s)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('aq7z2saw11yds', NULL, 'ALLSTATS LAST +PREDICATE +PARTITION'));   -- MKT_FCST_C BALANCE INSERT
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('1nc5at1kvv06s', NULL, 'ALLSTATS LAST +PREDICATE +PARTITION'));   -- GT_DPMFCQB_VMI_MST_MAIN INSERT (보정분)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('242jv1rzat1x7', NULL, 'ALLSTATS LAST +PREDICATE +PARTITION'));   -- 루트 DM_PLN_MKT_FCST BALANCE DELETE
-- ALLSTATS 의 A-Rows/A-Time 이 비어 있으면(통계 미수집) 'BASIC +PREDICATE +PARTITION +ROWS' 로 바꿔 E-Rows 만 본다.


/* ---------- K5. 상위 문장 누적 통계 (V$SQL) — 실행 횟수·실행당 소요·버퍼·디스크·행수 ---------- */
SELECT s.sql_id, s.plan_hash_value AS phv, s.executions, ROUND(s.elapsed_time / 1e6, 1) AS elapsed_sec
     , ROUND(s.elapsed_time / NULLIF(s.executions, 0) / 1e6, 1) AS sec_per_exec
     , ROUND(s.cpu_time / 1e6, 1) AS cpu_sec, ROUND(s.user_io_wait_time / 1e6, 1) AS io_sec, ROUND(s.cluster_wait_time / 1e6, 1) AS cluster_sec
     , s.buffer_gets, s.disk_reads, s.rows_processed, ROUND(s.rows_processed / NULLIF(s.executions, 0)) AS rows_per_exec
     , TO_CHAR(s.last_active_time, 'MM-DD HH24:MI:SS') AS last_active
     , SUBSTR(REPLACE(REPLACE(s.sql_text, CHR(10), ' '), CHR(13), ' '), 1, 100) AS sql_text
  FROM v$sqlarea s
 WHERE s.sql_id IN ('9nrrfxjtcj8xd', 'aq7z2saw11yds', '1nc5at1kvv06s', '242jv1rzat1x7', '630stwpcj5tr1', '19b6bty7zk5bu', 'fx7r3yjtr7990'
                  , '1d6ujwqtu1v46', 'bv4t2rqbavhqt', 'd7p0p42xmn5s2', '21hhfn0hxxs3u', '2uajmr7x0yar2', '2zp2yzun77891', '0m8x8bt5uuc33', '6nzwwbfd3rzsz', '3uh72s3j2h3xh')
 ORDER BY s.elapsed_time DESC;


/* ---------- K6. step 로그 간격 vs ASH — 로그 구간마다 ASH 가 설명하는 초 (벽시계 − ASH 가 큰 구간 = DB 밖 시간) ---------- */
WITH lg AS (
    SELECT x.event_date, x.program_name, x.log_type, SUBSTR(x.log_message, 1, 20) AS msg
         , LEAD(x.event_date) OVER (ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date) AS next_date
      FROM SCM_MGR.SCM_SYS_LOG_BATCH x
     WHERE x.event_date BETWEEN TO_DATE('2026-10-08 14:04:16', 'YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2026-10-08 14:11:44', 'YYYY-MM-DD HH24:MI:SS')
       AND (x.created_by = 'SCM_MGR' OR x.created_by = 'scm_batch')
       AND REGEXP_LIKE(x.program_name, 'BALANCE|WS_RTF|LOCAL_KRW'))
SELECT TO_CHAR(lg.event_date, 'HH24:MI:SS') AS from_, TO_CHAR(lg.next_date, 'HH24:MI:SS') AS to_
     , SUBSTR(lg.program_name, 1, 40) AS program_name, lg.log_type, lg.msg
     , ROUND((lg.next_date - lg.event_date) * 86400) AS wall_sec
     , (SELECT COUNT(*) FROM v$active_session_history h WHERE h.module = 'RERUN_QTY_BALANCE_40_1464' AND h.sample_time >= lg.event_date AND h.sample_time < lg.next_date) AS ash_sec
     , ROUND((lg.next_date - lg.event_date) * 86400) - (SELECT COUNT(*) FROM v$active_session_history h WHERE h.module = 'RERUN_QTY_BALANCE_40_1464' AND h.sample_time >= lg.event_date AND h.sample_time < lg.next_date) AS unsampled_sec
     , (SELECT SUBSTR(STATS_MODE(h.sql_id), 1, 13) FROM v$active_session_history h WHERE h.module = 'RERUN_QTY_BALANCE_40_1464' AND h.sample_time >= lg.event_date AND h.sample_time < lg.next_date) AS top_sql_in_gap
  FROM lg
 WHERE lg.next_date IS NOT NULL AND (lg.next_date - lg.event_date) * 86400 >= 5
 ORDER BY lg.event_date;
