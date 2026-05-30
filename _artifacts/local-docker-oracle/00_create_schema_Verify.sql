-- ============================================================================================
-- File         : 00_create_schema_Verify.sql
-- Description  : DBeaver Verify — 단일 SELECT (UNION ALL) 로 스키마/역할 생성 결과 검증
-- Expected     : check_name = ['SCM_MGR user exists','RL_SCM_DML','RL_SCM_SEL','SCMD_APP',
--              :              'SCM_MGR has SCMD_APP','SCM_MGR has CREATE SESSION'] 모두 1
-- Connection   : sys as sysdba @ FREEPDB1
-- ============================================================================================

SELECT 'SCM_MGR user exists'        AS check_name,
       COUNT(*)                      AS pass_count
  FROM dba_users WHERE username = 'SCM_MGR'
UNION ALL
SELECT 'role RL_SCM_DML exists',  COUNT(*) FROM dba_roles WHERE role = 'RL_SCM_DML'
UNION ALL
SELECT 'role RL_SCM_SEL exists',  COUNT(*) FROM dba_roles WHERE role = 'RL_SCM_SEL'
UNION ALL
SELECT 'role SCMD_APP   exists',  COUNT(*) FROM dba_roles WHERE role = 'SCMD_APP'
UNION ALL
SELECT 'SCM_MGR has SCMD_APP',    COUNT(*) FROM dba_role_privs
       WHERE grantee = 'SCM_MGR' AND granted_role = 'SCMD_APP'
UNION ALL
SELECT 'SCM_MGR has CREATE SESSION', COUNT(*) FROM dba_sys_privs
       WHERE grantee = 'SCM_MGR' AND privilege = 'CREATE SESSION'
UNION ALL
SELECT 'SCMD_APP has RL_SCM_DML',  COUNT(*) FROM dba_role_privs
       WHERE grantee = 'SCMD_APP' AND granted_role = 'RL_SCM_DML'
UNION ALL
SELECT 'SCMD_APP has RL_SCM_SEL',  COUNT(*) FROM dba_role_privs
       WHERE grantee = 'SCMD_APP' AND granted_role = 'RL_SCM_SEL'
ORDER BY 1
