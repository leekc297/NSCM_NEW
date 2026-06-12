-- DMF0043 caller body 안의 REPORT_GROUP3 잔존 정밀 audit
SET SERVEROUTPUT ON
SET LINESIZE 200
SET PAGESIZE 200

PROMPT === 1. REPORT_GROUP3 reference 잔존 라인 ===
SELECT line, text
  FROM user_source
 WHERE name = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'
   AND type = 'PROCEDURE'
   AND UPPER(text) LIKE '%REPORT_GROUP3%'
 ORDER BY line;

PROMPT === 2. caller 의 line 840~850 (오류 지점 주변) ===
SELECT line, text
  FROM user_source
 WHERE name = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'
   AND type = 'PROCEDURE'
   AND line BETWEEN 840 AND 850
 ORDER BY line;

PROMPT === 3. SCM_MST_SITE_ITEM 컬럼 인벤토리 — REPORT_GROUP* 존재 여부 ===
SELECT column_name, data_type, nullable
  FROM all_tab_columns
 WHERE owner = 'SCM_MGR'
   AND table_name = 'SCM_MST_SITE_ITEM'
   AND UPPER(column_name) LIKE '%REPORT%'
 ORDER BY column_id;
