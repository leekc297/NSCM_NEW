/* =====================================================================================================
 * [E20261007-PERF] 클라우드 적용 전/후 검증 — 조회 전용
 *  V1 적용 전 : 판본 확인 (3181줄 · 마커 0)  → 01_APPLY 실행 → V1 다시 (3201줄 · 마커 8 · VALID)
 *  V2 적용 전/후 : 배치 경로 결과 동치 가드 — MAX 2질의 vs KEEP 1질의 (40 과 전 사업부)
 *  V3 다음 00시 Daily Rolling 실행 후 : 구간 집계 (02_compact_output.sql 의 C3W/C2W 와 동일) — A001→A007 구간 전후 비교
 * ===================================================================================================== */
SET PAGESIZE 0 LINESIZE 300 TRIMSPOOL ON HEADING OFF FEEDBACK OFF

-- V1. 판본
SELECT 'V1 | ' || o.object_name || ' | ' || o.status || ' | ddl=' || TO_CHAR(o.last_ddl_time, 'YYYY-MM-DD HH24:MI:SS')
    || ' | lines=' || (SELECT MAX(line) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type)
    || ' | perf1007=' || (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%E20261007-PERF%')
    || ' | view_refs=' || (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%FROM SCP_PLN_RTF_ALLOCATION_V%')   -- 적용 전 4 · 후 3 (1회는 비배치 경로 ELSE 안)
    || ' | errors=' || (SELECT COUNT(*) FROM all_errors e WHERE e.owner = o.owner AND e.name = o.object_name) AS line
  FROM all_objects o WHERE o.owner = 'SCM_MGR' AND o.object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND o.object_type = 'PROCEDURE';

-- V2. 동치 가드 (사업부별: 두 질의 결과 = KEEP 결과 이어야 함. MISMATCH 가 1건이라도 있으면 적용 보류)
WITH d AS (SELECT DISTINCT division_id FROM SCP_PLN_RTF_ALLOCATION_V)
, two AS (
    SELECT d.division_id
         , (SELECT NVL(MAX(plan_id), '') FROM SCP_PLN_RTF_ALLOCATION_V v WHERE v.division_id = d.division_id) AS pid
      FROM d
)
, two2 AS (
    SELECT t.division_id, t.pid
         , (SELECT NVL(MAX(plan_start_yyyymmdd), '') FROM SCP_PLN_RTF_ALLOCATION_V v WHERE v.division_id = t.division_id AND v.plan_id = t.pid) AS pstart
      FROM two t
)
, keep AS (
    SELECT division_id, NVL(MAX(plan_id), '') AS pid, NVL(MAX(plan_start_yyyymmdd) KEEP (DENSE_RANK LAST ORDER BY plan_id), '') AS pstart
      FROM SCP_PLN_RTF_ALLOCATION_V GROUP BY division_id
)
SELECT 'V2 | ' || a.division_id || ' | two=(' || a.pid || ',' || a.pstart || ') keep=(' || k.pid || ',' || k.pstart || ') | '
    || CASE WHEN NVL(a.pid, '~') = NVL(k.pid, '~') AND NVL(a.pstart, '~') = NVL(k.pstart, '~') THEN 'OK' ELSE 'MISMATCH' END AS line
  FROM two2 a JOIN keep k ON k.division_id = a.division_id
 ORDER BY a.division_id;

-- V3. 실행 구간 집계 — 이번 주 (적용 후 첫 00시 실행이 들어오면 A001→A007 값을 10-07 00:03 실행(14초)과 비교)
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') AS from_dt, SYSDATE + 1 AS to_dt FROM dual)
, l AS (
    SELECT l.program_name, l.log_type, l.log_message, l.description, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (SELECT l.*, SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END) OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no FROM l)
, x AS (
    SELECT run_no, event_date, ord, log_message, log_type
         , NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), log_type) AS marker
         , MIN(event_date) OVER (PARTITION BY run_no) AS run_start
      FROM s WHERE run_no > 0
)
SELECT 'V3 | run=' || run_no || ' ' || TO_CHAR(run_start, 'MM-DD HH24:MI') || ' | ' || RPAD(LAG(marker) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message) || '->' || marker, 16)
    || ' | gap=' || ROUND((event_date - LAG(event_date) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message)) * 86400) || 's'
    || CASE WHEN log_type = 'ERROR' THEN ' | ' || SUBSTR(log_message, 1, 120) ELSE '' END AS line
  FROM x
 ORDER BY run_no, event_date, ord, log_message;
