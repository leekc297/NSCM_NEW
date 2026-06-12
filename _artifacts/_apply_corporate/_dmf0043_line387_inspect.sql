-- line 380~430 + 845 부근 정밀 inspection
SET LINESIZE 250
SET PAGESIZE 100

PROMPT === line 380~435 (REPORT_GROUP3 변환 자리) ===
SELECT line, text
  FROM user_source
 WHERE name = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'
   AND type = 'PROCEDURE'
   AND line BETWEEN 380 AND 435
 ORDER BY line;
