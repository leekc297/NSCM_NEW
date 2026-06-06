--==============================================================================
-- 010_Object_Status_Verify.sql (DMF0043_01)
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === VERIFY 1 : DMF0043_01 종속 객체 STATUS ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name IN (
     'DMF0043_GET_CONTRIBUTION_SALES_LIST',
     'DMF0043_GET_SALES_LIST_SPREAD_TITLE',
     'DMF0043_GET_MAIN_VARSION_DATA',
     'DMF0043_GET_CONTRIBUTE_RATE_POPUP',
     'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',
     'DMF0043_GET_MAIN_SPREAD_TITLE',
     'DMF0002_GET_TITLESET_POPUP',
     'PKG_DMF0043', 'PKG_DMF0002',
     'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH', 'UF_FX_STRING_SPLIT'
   )
 ORDER BY object_type, object_name;

PROMPT === VERIFY 2 : INVALID 객체 ===

SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name IN (
     'DMF0043_GET_CONTRIBUTION_SALES_LIST',
     'DMF0043_GET_SALES_LIST_SPREAD_TITLE',
     'DMF0043_GET_MAIN_VARSION_DATA',
     'DMF0043_GET_CONTRIBUTE_RATE_POPUP',
     'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',
     'DMF0002_GET_TITLESET_POPUP',
     'PKG_DMF0043', 'PKG_DMF0002'
   )
   AND status = 'INVALID';

PROMPT === VERIFY 3 : INVALID 컴파일 오류 ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND (name LIKE 'DMF0043%' OR name = 'DMF0002_GET_TITLESET_POPUP' OR name LIKE 'PKG_DMF%')
 ORDER BY name, sequence
 FETCH FIRST 50 ROWS ONLY;

PROMPT === 판독 ===
PROMPT - VERIFY 1 모두 STATUS=VALID → OK
PROMPT - VERIFY 2 row 0 → OK
PROMPT - VERIFY 3 row 0 → OK
