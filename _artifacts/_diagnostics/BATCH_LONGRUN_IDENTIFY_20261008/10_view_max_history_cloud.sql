/* =====================================================================================================
 * 10 — 클라우드 실행용: SCP_PLN_RTF_ALLOCATION_V MAX 질의(6nzwwbfd3rzsz / 0jcr4bqngwpj2)가 09-30 에는 회당 ≈100초, 지금은 2초인 이유
 *      가설 A) 실행계획(PHV)이 바뀌었다  B) 같은 계획인데 그때만 느렸다(CPU 경합·캐시)  C) LOCK 대기 — ASH 는 ON CPU 만 보여 C 는 약함
 *      Z1 = 스냅샷별 PHV·실행수·실행당 소요/버퍼 → A/B 판별 · Z2 = 대기이벤트 분포 → C 판별 · Z3 = PHV 별 플랜 원문
 *      SQL Developer 스크립트 창에 전체 붙여넣기 → F5. 조회 전용 (DBA_HIST_* 권한).
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

/* ---------- Z1. 스냅샷별 실행 통계 — 같은 SQL_ID 가 날짜별로 어느 PHV 로 얼마나 걸렸나 ---------- */
SELECT TO_CHAR(sn.begin_interval_time, 'MM-DD(DY) HH24') AS snap_hour
     , t.sql_id, t.plan_hash_value AS phv
     , SUM(t.executions_delta) AS execs
     , ROUND(SUM(t.elapsed_time_delta) / 1e6, 1) AS elapsed_sec
     , ROUND(SUM(t.elapsed_time_delta) / 1e6 / NULLIF(SUM(t.executions_delta), 0), 1) AS sec_per_exec
     , ROUND(SUM(t.cpu_time_delta) / 1e6, 1) AS cpu_sec
     , ROUND(SUM(t.iowait_delta) / 1e6, 1) AS io_sec
     , ROUND(SUM(t.apwait_delta) / 1e6, 1) AS lock_wait_sec          -- application wait = enq(lock) 계열
     , ROUND(SUM(t.ccwait_delta) / 1e6, 1) AS concurrency_wait_sec   -- latch/mutex/buffer busy
     , ROUND(SUM(t.buffer_gets_delta) / NULLIF(SUM(t.executions_delta), 0)) AS gets_per_exec
     , SUM(t.rows_processed_delta) AS rows_
  FROM dba_hist_sqlstat t
  JOIN dba_hist_snapshot sn ON sn.snap_id = t.snap_id AND sn.dbid = t.dbid AND sn.instance_number = t.instance_number
 WHERE t.dbid = t.con_dbid
   AND t.sql_id IN ('6nzwwbfd3rzsz', '0jcr4bqngwpj2', '3pkngsw1b3vng', '1nc5at1kvv06s', '3g9x8t27cmu5k')
   AND sn.begin_interval_time >= TO_DATE('2026-09-22', 'YYYY-MM-DD')
 GROUP BY TO_CHAR(sn.begin_interval_time, 'MM-DD(DY) HH24'), t.sql_id, t.plan_hash_value
 ORDER BY t.sql_id, 1;


/* ---------- Z2. 대기이벤트 분포 — LOCK(enq) 이었나 CPU 였나 (전 기간) ---------- */
SELECT h.sql_id, h.sql_plan_hash_value AS phv
     , NVL(h.event, 'ON CPU') AS event, h.wait_class
     , COUNT(*) * 10 AS approx_sec
     , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER (PARTITION BY h.sql_id) * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'MM-DD HH24:MI') AS first_seen, TO_CHAR(MAX(h.sample_time), 'MM-DD HH24:MI') AS last_seen
     , COUNT(DISTINCT TO_CHAR(h.sample_time, 'MM-DD')) AS days_seen
  FROM dba_hist_active_sess_history h
 WHERE h.dbid = h.con_dbid
   AND h.sql_id IN ('6nzwwbfd3rzsz', '0jcr4bqngwpj2')
   AND h.sample_time >= TO_DATE('2026-09-22', 'YYYY-MM-DD')
 GROUP BY h.sql_id, h.sql_plan_hash_value, NVL(h.event, 'ON CPU'), h.wait_class
 ORDER BY h.sql_id, approx_sec DESC;

-- Z2-b. 09-30 15:39~16:32 그 쿼리 샘플의 blocking_session — LOCK 이면 값이 찍힘
SELECT h.sql_id, NVL(h.event, 'ON CPU') AS event, h.blocking_session, h.blocking_session_status
     , COUNT(*) * 10 AS approx_sec, TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
  FROM dba_hist_active_sess_history h
 WHERE h.dbid = h.con_dbid
   AND h.sql_id IN ('6nzwwbfd3rzsz', '0jcr4bqngwpj2')
   AND h.sample_time BETWEEN TO_DATE('2026-09-30 15:39', 'YYYY-MM-DD HH24:MI') AND TO_DATE('2026-09-30 16:32', 'YYYY-MM-DD HH24:MI')
 GROUP BY h.sql_id, NVL(h.event, 'ON CPU'), h.blocking_session, h.blocking_session_status
 ORDER BY approx_sec DESC;


/* ---------- Z3. PHV 별 플랜 원문 — Z1 에서 PHV 가 2개 이상이면 둘을 비교 ---------- */
SELECT p.sql_id, p.plan_hash_value AS phv, p.id, LPAD(' ', p.depth) || p.operation || ' ' || p.options AS op
     , p.object_name, p.cardinality AS e_rows, p.cost
  FROM dba_hist_sql_plan p
 WHERE p.dbid = p.con_dbid
   AND p.sql_id IN ('6nzwwbfd3rzsz', '0jcr4bqngwpj2')
 ORDER BY p.sql_id, p.plan_hash_value, p.id;


/* ---------- Z4. 그 시간대 DB 전체 부하 — 09-30 15:39~16:32 vs 10-01 20:09~20:32 활동 세션 수(ASH 샘플/10초) ---------- */
SELECT CASE WHEN h.sample_time < TO_DATE('2026-10-01', 'YYYY-MM-DD') THEN 'R1_0930_1539' ELSE 'R3_1001_2009' END AS win
     , NVL(h.wait_class, 'ON CPU') AS wait_class
     , ROUND(COUNT(*) / (53 * 6), 1) AS avg_active_sessions       -- 53분 × 6샘플/분
  FROM dba_hist_active_sess_history h
 WHERE h.dbid = h.con_dbid AND h.session_type = 'FOREGROUND'
   AND (h.sample_time BETWEEN TO_DATE('2026-09-30 15:39', 'YYYY-MM-DD HH24:MI') AND TO_DATE('2026-09-30 16:32', 'YYYY-MM-DD HH24:MI')
     OR h.sample_time BETWEEN TO_DATE('2026-10-01 20:09', 'YYYY-MM-DD HH24:MI') AND TO_DATE('2026-10-01 21:02', 'YYYY-MM-DD HH24:MI'))
 GROUP BY CASE WHEN h.sample_time < TO_DATE('2026-10-01', 'YYYY-MM-DD') THEN 'R1_0930_1539' ELSE 'R3_1001_2009' END, NVL(h.wait_class, 'ON CPU')
 ORDER BY 1, 3 DESC;
