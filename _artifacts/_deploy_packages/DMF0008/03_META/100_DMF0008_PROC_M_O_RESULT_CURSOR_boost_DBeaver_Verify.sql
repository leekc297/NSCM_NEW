-- DBeaver Verify (UNION ALL 단일 SELECT, sqlplus 명령 없음)
-- 100_..._boost.sql 적용 후 실행. 기대값: 모두 status='OK'

SELECT 'SUMMARY' AS sp, rows_meta, has_result_cursor,
       CASE WHEN rows_meta = 8 AND has_result_cursor = 1 THEN 'OK' ELSE 'FAIL' END AS status
  FROM (SELECT COUNT(*) AS rows_meta,
               SUM(CASE WHEN COL_NM='O_RESULT_CURSOR' AND COL_TP_CD='OUT' THEN 1 ELSE 0 END) AS has_result_cursor
          FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0008_GET_EDI_MST_SUMMARY')
UNION ALL
SELECT 'REPAIR' AS sp, rows_meta, has_result_cursor,
       CASE WHEN rows_meta = 9 AND has_result_cursor = 1 THEN 'OK' ELSE 'FAIL' END AS status
  FROM (SELECT COUNT(*) AS rows_meta,
               SUM(CASE WHEN COL_NM='O_RESULT_CURSOR' AND COL_TP_CD='OUT' THEN 1 ELSE 0 END) AS has_result_cursor
          FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0008_GET_EDI_MST_REPAIR')
UNION ALL
SELECT 'SSPM' AS sp, rows_meta, has_result_cursor,
       CASE WHEN rows_meta = 7 AND has_result_cursor = 1 THEN 'OK' ELSE 'FAIL' END AS status
  FROM (SELECT COUNT(*) AS rows_meta,
               SUM(CASE WHEN COL_NM='O_RESULT_CURSOR' AND COL_TP_CD='OUT' THEN 1 ELSE 0 END) AS has_result_cursor
          FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0008_GET_SALES_SITE_PROJECT_MODEL');
