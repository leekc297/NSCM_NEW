--==============================================================================
-- 010_DEPENDENT_OBJECTS_CHECK.sql (DMF0072)
-- 작성: 2026-06-05
--==============================================================================
SET LINESIZE 200
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0072 SP + 공용 + 종속 STATUS ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0072_%'
        OR object_name IN ('PKG_DMF0072', 'DMF0008_GET_MY_DIVISION_LIST',
                           'UF_FX_STRING_SPLIT', 'UF_FX_STRING_SPLITFORIN',
                           'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH'))
 ORDER BY object_type, object_name;

PROMPT === DIAG 2 : 누락 객체 ===

WITH expected AS (
  SELECT 'DMF0072_GET_DATA_TYPE_LIST'        AS name FROM DUAL UNION ALL
  SELECT 'DMF0072_GET_TEAM_LIST'                     FROM DUAL UNION ALL
  SELECT 'DMF0072_GET_END_CUSTOMER_LIST'             FROM DUAL UNION ALL
  SELECT 'DMF0072_GET_SALES_SITE_LIST'               FROM DUAL UNION ALL
  SELECT 'DMF0072_GET_PROJECT_POPUP_LIST'            FROM DUAL UNION ALL
  SELECT 'DMF0072_GET_ITEM_POPUP_LIST'               FROM DUAL UNION ALL
  SELECT 'PKG_DMF0072'                                FROM DUAL UNION ALL
  SELECT 'DMF0008_GET_MY_DIVISION_LIST'              FROM DUAL UNION ALL
  SELECT 'UF_FX_STRING_SPLITFORIN'                    FROM DUAL
)
SELECT e.name AS MISSING_OBJECT
  FROM expected e
 WHERE NOT EXISTS (
   SELECT 1 FROM all_objects a
    WHERE a.owner = 'SCM_MGR' AND a.object_name = e.name
 );

PROMPT === DIAG 3 : INVALID 컴파일 오류 ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND (name LIKE 'DMF0072_%' OR name = 'PKG_DMF0072')
 ORDER BY name, sequence
 FETCH FIRST 50 ROWS ONLY;
