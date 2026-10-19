/* =====================================================================================================
 * 17 — 클라우드 실행용 (조회만): 신판 16:35 실행에서 플랜이 바뀐 DELETE 2문장의 실제 플랜 + 구판 플랜 대조 + 호출별(MF_W/SF_W) 문장 분해
 *      U1 퇴행 문장 플랜(신) · U2 구판 플랜(공유풀에 남아 있으면) · U3 신/구 V$SQL 대조 · U4 호출별 문장 ASH(14:04 C#1/C#2 와 같은 자리)
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

-- U1. 신판 퇴행 후보 플랜 — MKT_FCST_C MEASURE IN GTT DELETE (05qrwgthrujm1) · CFM_C 짝 (b4r9df2w3nwck) · 예외품목 INSERT (1t8xwbj05zavs) · BALANCE INSERT (aq7z2saw11yds)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('05qrwgthrujm1', NULL, 'BASIC +PREDICATE +PARTITION +ROWS +OUTLINE'));
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('b4r9df2w3nwck', NULL, 'BASIC +PREDICATE +PARTITION +ROWS'));
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('1t8xwbj05zavs', NULL, 'BASIC +PREDICATE +PARTITION +ROWS'));
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('aq7z2saw11yds', NULL, 'BASIC +PREDICATE +PARTITION +ROWS'));

-- U2. 구판 같은 문장의 플랜 (14:04 실행 커서가 공유풀에 남아 있으면 나온다 · 없으면 AWR 의 PHV 1056814193)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('0m8x8bt5uuc33', NULL, 'BASIC +PREDICATE +PARTITION +ROWS +OUTLINE'));
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('0m8x8bt5uuc33', 1056814193, NULL, 'BASIC +PREDICATE +PARTITION +ROWS'));
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('4q3xrqnhzra5g', NULL, 'BASIC +PREDICATE +PARTITION +ROWS'));

-- U3. 신/구 V$SQL 대조 (실행당 초·버퍼·디스크·행)
SELECT s.sql_id, s.plan_hash_value AS phv, s.executions, ROUND(s.elapsed_time / NULLIF(s.executions, 0) / 1e6, 1) AS sec_per_exec
     , ROUND(s.cpu_time / 1e6, 1) AS cpu_sec, ROUND(s.user_io_wait_time / 1e6, 1) AS io_sec, s.buffer_gets, s.disk_reads, s.rows_processed
     , TO_CHAR(s.last_active_time, 'HH24:MI:SS') AS last_active, SUBSTR(REPLACE(REPLACE(s.sql_text, CHR(10), ' '), CHR(13), ' '), 1, 110) AS sql_text
  FROM v$sqlarea s
 WHERE s.sql_id IN ('05qrwgthrujm1', '0m8x8bt5uuc33', 'b4r9df2w3nwck', 'gjxu56g834230', '1t8xwbj05zavs', '4q3xrqnhzra5g', '2zqsa3nha01a1', '9nrrfxjtcj8xd', 'aq7z2saw11yds', 'fj0mxwa6h2ua8', '1nc5at1kvv06s', '6nzwwbfd3rzsz', 'bx3u5b3yf9rvw', 'dg7bnbmzh7pdb')
 ORDER BY s.sql_text, s.last_active_time;

-- U4. 호출별 문장 ASH — 신판 MF_W / SF_W 와 14:04 C#1 / C#2 를 문장 머리글로 묶어 한 줄에 (2초 이상). COMPARE(비교 쿼리) 와 16/17 조회는 제외
WITH a AS (
    SELECT CASE WHEN h.module = 'RUN_C_NEW_1464' THEN 'NEW_' || h.action
                WHEN h.sample_time < TO_TIMESTAMP('2026-10-08 14:09:05', 'YYYY-MM-DD HH24:MI:SS') THEN 'OLD_C1' ELSE 'OLD_C2' END AS ph
         , h.sql_id, h.event
      FROM v$active_session_history h
     WHERE (h.module = 'RUN_C_NEW_1464' AND h.action IN ('MF_W', 'SF_W'))
        OR (h.module = 'RERUN_QTY_BALANCE_40_1464' AND h.sample_time BETWEEN TO_TIMESTAMP('2026-10-08 14:06:07', 'YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP('2026-10-08 14:11:45', 'YYYY-MM-DD HH24:MI:SS')))
, t AS (
    SELECT a.ph, a.sql_id, COUNT(*) AS sec, SUM(CASE WHEN a.event IS NULL THEN 1 ELSE 0 END) AS cpu
         , SUBSTR(REPLACE(REPLACE((SELECT q.sql_text FROM v$sqlarea q WHERE q.sql_id = a.sql_id), CHR(10), ' '), CHR(13), ' '), 1, 60) AS stmt
      FROM a GROUP BY a.ph, a.sql_id)
SELECT stmt, MAX(CASE WHEN ph = 'NEW_MF_W' THEN sql_id END) AS new_id, SUM(CASE WHEN ph = 'NEW_MF_W' THEN sec END) AS new_mfw, SUM(CASE WHEN ph = 'NEW_MF_W' THEN cpu END) AS new_mfw_cpu
     , SUM(CASE WHEN ph = 'NEW_SF_W' THEN sec END) AS new_sfw, SUM(CASE WHEN ph = 'NEW_SF_W' THEN cpu END) AS new_sfw_cpu
     , MAX(CASE WHEN ph LIKE 'OLD%' THEN sql_id END) AS old_id, SUM(CASE WHEN ph = 'OLD_C1' THEN sec END) AS old_c1, SUM(CASE WHEN ph = 'OLD_C2' THEN sec END) AS old_c2
     , NVL(SUM(CASE WHEN ph = 'NEW_SF_W' THEN sec END), 0) - NVL(SUM(CASE WHEN ph = 'OLD_C2' THEN sec END), 0) AS delta_2nd_call
  FROM t
 GROUP BY stmt
HAVING MAX(sec) >= 2
 ORDER BY NVL(SUM(CASE WHEN ph = 'NEW_SF_W' THEN sec END), 0) - NVL(SUM(CASE WHEN ph = 'OLD_C2' THEN sec END), 0) DESC;
-- 해석: delta_2nd_call = 캐시가 따뜻한 2회차끼리의 차이(공정 비교). 양수 큰 문장 = 신판에서 실제로 늘어난 문장.
