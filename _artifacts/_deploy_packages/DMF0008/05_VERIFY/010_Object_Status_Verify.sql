--==============================================================================
-- 010_Object_Status_Verify.sql (DMF0008)
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === VERIFY 1 : DMF0008 SP 9개 + 공용 + 종속 STATUS ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0008_%'
        OR object_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS',
                           'PKG_DMF0008', 'PKG_SCM_USER_MNU', 'UF_FX_STRING_SPLIT',
                           'PR_SCM_SYS_LOG_BATCH'))
 ORDER BY object_type, object_name;

PROMPT === VERIFY 2 : INVALID 객체 ===

SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0008_%' OR object_name LIKE 'DMF0000_%' OR object_name = 'PKG_DMF0008')
   AND status = 'INVALID';

PROMPT === VERIFY 3 : INVALID 컴파일 오류 ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND (name LIKE 'DMF0008%' OR name LIKE 'DMF0000%' OR name = 'PKG_DMF0008')
 ORDER BY name, sequence
 FETCH FIRST 50 ROWS ONLY;
