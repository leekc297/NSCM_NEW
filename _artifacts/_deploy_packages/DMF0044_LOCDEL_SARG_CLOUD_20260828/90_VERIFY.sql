--------------------------------------------------------------------------------
-- DMF0044 LOCDELSARG 클라우드 적용 검증 (2026-08-28)
-- 적용 직후 V1→V3 실행. V3 은 화면에서 저장 1회 재현한 뒤 실행.
--------------------------------------------------------------------------------

-- V1. 마커 카운트 — 기대: LOCDELSARG=2 / CFMERGE=2 / CFSETBASED=2 / CFNOSTATS=1 / EXAUTH=4 / DS2=9
SELECT m.marker, COUNT(s.line) cnt
  FROM (SELECT 'E20260828-LOCDELSARG' marker FROM DUAL UNION ALL
        SELECT 'E20260820-CFMERGE'           FROM DUAL UNION ALL
        SELECT 'E20260820-CFSETBASED'        FROM DUAL UNION ALL
        SELECT 'E20260820-CFNOSTATS'         FROM DUAL UNION ALL
        SELECT 'E20260820-EXAUTH'            FROM DUAL UNION ALL
        SELECT 'E20260812-DS2'               FROM DUAL) m
  LEFT JOIN ALL_SOURCE s
    ON s.owner = 'SCM_MGR' AND s.name = 'PKG_DMF0044' AND s.type = 'PACKAGE BODY'
   AND s.text LIKE '%' || m.marker || '%'
 GROUP BY m.marker ORDER BY m.marker;

-- V2. VALID 확인 — 두 행 모두 VALID 필수 (INVALID 면 ALL_ERRORS 회신)
SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') last_ddl
  FROM ALL_OBJECTS
 WHERE owner = 'SCM_MGR' AND object_name = 'PKG_DMF0044'
 ORDER BY object_type;

-- V3. 효과 실측 — 화면에서 저장 1회 재현 직후 실행.
--     기대: DELETE ... MEASURE = 'LOC' 행의 SEC_PER_EXEC 가 117초 → 1초 미만,
--           PHV 가 425434007(구계획) 이 아닌 새 값 (사내 EXPLAIN 기준 2103538383 계열).
SELECT sql_id, plan_hash_value phv, executions execs,
       ROUND(elapsed_time / 1e6 / NULLIF(executions, 0), 2) sec_per_exec,
       buffer_gets, disk_reads, rows_processed,
       SUBSTR(REPLACE(REPLACE(sql_text, CHR(10), ' '), CHR(13), ' '), 1, 120) sql_head
  FROM V$SQL
 WHERE UPPER(sql_text) LIKE 'DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A%'
   AND UPPER(sql_text) LIKE '%MEASURE = ''LOC''%'
 ORDER BY last_active_time DESC;
