--==============================================================================
-- 010_DEPENDENT_OBJECTS_CHECK.sql (DMF0008)
--
-- 목적: DMF0008 (ERP-EDI Master) 종속 객체 존재 + STATUS 확인 (READ-ONLY)
-- 작성: 2026-06-05
--==============================================================================
SET LINESIZE 200
SET PAGESIZE 100
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0008 SP 9개 + 종속 객체 STATUS ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name IN (
     'DMF0008_GET_EDI_MST_SUMMARY',
     'DMF0008_GET_EDI_MST_REPAIR',
     'DMF0008_GET_SALES_SITE',
     'DMF0008_GET_SALES_SITE_PROJECT_MODEL',
     'DMF0008_SAVE_SALES_SITE_EDI_REPAIR',
     'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR',
     'DMF0008_GET_UPDATE_HISTORY',
     'DMF0008_GET_MY_DIVISION_LIST',
     'DMF0000_GET_UPDATE_HISTORY',
     'PR_DM_DNM_EDI_CALLOFF_STATUS',
     'UF_FX_STRING_SPLIT',
     'PKG_SCM_USER_MNU',
     'PR_SCM_SYS_LOG_BATCH'
   )
 ORDER BY object_type, object_name;

PROMPT === DIAG 2 : 누락 객체 ===

WITH expected AS (
  SELECT 'DMF0008_GET_EDI_MST_SUMMARY'              AS name FROM DUAL UNION ALL
  SELECT 'DMF0008_GET_EDI_MST_REPAIR'                       FROM DUAL UNION ALL
  SELECT 'DMF0008_GET_SALES_SITE'                          FROM DUAL UNION ALL
  SELECT 'DMF0008_GET_SALES_SITE_PROJECT_MODEL'            FROM DUAL UNION ALL
  SELECT 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR'              FROM DUAL UNION ALL
  SELECT 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR'      FROM DUAL UNION ALL
  SELECT 'DMF0008_GET_UPDATE_HISTORY'                      FROM DUAL UNION ALL
  SELECT 'DMF0008_GET_MY_DIVISION_LIST'                    FROM DUAL UNION ALL
  SELECT 'DMF0000_GET_UPDATE_HISTORY'                      FROM DUAL UNION ALL
  SELECT 'PR_DM_DNM_EDI_CALLOFF_STATUS'                    FROM DUAL
)
SELECT e.name AS MISSING_OBJECT,
       'CLOUD 운영팀 / DBA 객체 생성 또는 GRANT 필요' AS RESOLUTION
  FROM expected e
 WHERE NOT EXISTS (
   SELECT 1 FROM all_objects a
    WHERE a.owner = 'SCM_MGR' AND a.object_name = e.name
 );

PROMPT === DIAG 3 : INVALID 컴파일 오류 ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND name LIKE 'DMF0008_%'
 ORDER BY name, sequence
 FETCH FIRST 50 ROWS ONLY;

PROMPT === 판독 ===
PROMPT - DIAG 1 10+ row + STATUS=VALID 모두 → OK
PROMPT - DIAG 2 row 0 → OK
PROMPT - DIAG 3 row 0 → OK
