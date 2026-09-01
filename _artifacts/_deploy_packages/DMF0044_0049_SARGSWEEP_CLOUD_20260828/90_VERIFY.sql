--------------------------------------------------------------------------------
-- DMF0044/0049 SARGSWEEP 클라우드 적용 검증 (2026-08-28)
--------------------------------------------------------------------------------

-- V1. 마커 카운트 — 기대:
--   PKG_DMF0044: SARGSWEEP=6 / LOCDELSARG=2 / CFMERGE=2 / CFSETBASED=2 / CFNOSTATS=1 / EXAUTH=4 / DS2=9
--   PKG_DMF0049: SARGSWEEP=4 / DIVIDSCALAR=3 / DS2=2
SELECT s.name, m.marker, COUNT(s.line) cnt
  FROM (SELECT 'E20260828-SARGSWEEP'  marker FROM DUAL UNION ALL
        SELECT 'E20260828-LOCDELSARG'        FROM DUAL UNION ALL
        SELECT 'E20260820-CFMERGE'           FROM DUAL UNION ALL
        SELECT 'E20260820-DIVIDSCALAR'       FROM DUAL UNION ALL
        SELECT 'E20260812-DS2'               FROM DUAL) m
  CROSS JOIN (SELECT 'PKG_DMF0044' name FROM DUAL UNION ALL SELECT 'PKG_DMF0049' FROM DUAL) p
  LEFT JOIN ALL_SOURCE s
    ON s.owner = 'SCM_MGR' AND s.name = p.name AND s.type = 'PACKAGE BODY'
   AND s.text LIKE '%' || m.marker || '%'
 GROUP BY p.name, m.marker, s.name
HAVING s.name IS NOT NULL OR 1 = 1
 ORDER BY p.name, m.marker;

-- V2. VALID 확인 — 4행 모두 VALID 필수
SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') last_ddl
  FROM ALL_OBJECTS
 WHERE owner = 'SCM_MGR' AND object_name IN ('PKG_DMF0044', 'PKG_DMF0049')
 ORDER BY object_name, object_type;

-- V3. 효과 실측 — Version 팝업에서 COPY 또는 CREATE 1회, DMF0049 저장 1회 재현 직후 실행.
--     기대: MERGE INTO ... DM_PLN_SALES_PLAN_REPORT_C (LOOKA) 행과
--           DELETE/UPDATE DM_PLN_SALES_ETC_REPORT_C 행의 SEC_PER_EXEC 이 초 단위 미만.
SELECT sql_id, plan_hash_value phv, executions execs,
       ROUND(elapsed_time / 1e6 / NULLIF(executions, 0), 2) sec_per_exec,
       buffer_gets, disk_reads, rows_processed,
       SUBSTR(REPLACE(REPLACE(sql_text, CHR(10), ' '), CHR(13), ' '), 1, 120) sql_head
  FROM V$SQL
 WHERE (UPPER(sql_text) LIKE '%DM_PLN_SALES_PLAN_REPORT_C%'
     OR UPPER(sql_text) LIKE '%DM_PLN_SALES_ETC_REPORT_C%')
   AND (UPPER(sql_text) LIKE 'DELETE%' OR UPPER(sql_text) LIKE 'UPDATE%' OR UPPER(sql_text) LIKE 'MERGE%')
   AND executions > 0
 ORDER BY elapsed_time DESC
 FETCH FIRST 25 ROWS ONLY;
