-- Profiler 결과 분석 (RUNID 받은 후 사용)
-- 1. 단위별 (SP/PKG) 총 elapsed time
-- 2. SP body line별 top 30 elapsed
-- 3. line# → SP 코드 매핑 (ALL_SOURCE LINE)

PROMPT === 1. Unit별 총 time ===
SELECT runid, unit_number, unit_owner, unit_name, unit_type,
       ROUND(total_time / 1e9, 3) AS elapsed_sec
  FROM plsql_profiler_units
 WHERE runid = (SELECT MAX(runid) FROM plsql_profiler_runs)
 ORDER BY total_time DESC;

PROMPT
PROMPT === 2. Top 30 line 별 elapsed (DMF0003_GET_MKT_FCST_DATA) ===
SELECT d.line#, d.total_occur,
       ROUND(d.total_time / 1e9, 3) AS total_sec,
       ROUND(d.max_time / 1e6, 3)   AS max_ms,
       s.text
  FROM plsql_profiler_data d
  JOIN plsql_profiler_units u ON d.runid = u.runid AND d.unit_number = u.unit_number
  LEFT JOIN ALL_SOURCE s ON s.owner = u.unit_owner AND s.name = u.unit_name
   AND s.type IN ('PROCEDURE','PACKAGE BODY') AND s.line = d.line#
 WHERE d.runid = (SELECT MAX(runid) FROM plsql_profiler_runs)
   AND u.unit_name = 'DMF0003_GET_MKT_FCST_DATA'
   AND d.total_time > 0
 ORDER BY d.total_time DESC
 FETCH FIRST 30 ROWS ONLY;
