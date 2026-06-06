--==============================================================================
-- 010_Object_Status_Verify.sql (DMF0072)
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === VERIFY 1 : DMF0072 SP 8개 + 공용 + 종속 STATUS ===

SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0072_%'
        OR object_name IN ('PKG_DMF0072', 'DMF0008_GET_MY_DIVISION_LIST',
                           'UF_FX_STRING_SPLIT', 'UF_FX_STRING_SPLITFORIN',
                           'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH'))
 ORDER BY object_type, object_name;

PROMPT === VERIFY 2 : INVALID 객체 ===

SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0072_%' OR object_name = 'PKG_DMF0072')
   AND status = 'INVALID';

PROMPT === VERIFY 3 : INVALID 컴파일 오류 ===

SELECT name, type, line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND (name LIKE 'DMF0072_%' OR name = 'PKG_DMF0072')
 ORDER BY name, sequence
 FETCH FIRST 50 ROWS ONLY;
