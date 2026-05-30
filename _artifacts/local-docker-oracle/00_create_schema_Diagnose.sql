-- ============================================================================================
-- File         : 00_create_schema_Diagnose.sql
-- Description  : DBeaver Diagnose — 스키마 생성 실패 시 진단용 (각 SELECT 개별 Ctrl+Enter)
-- Connection   : sys as sysdba @ FREEPDB1
-- ============================================================================================

-- 1) 현재 컨테이너 (반드시 FREEPDB1 이어야 함)
SELECT SYS_CONTEXT('USERENV','CON_NAME') AS con_name FROM dual;

-- 2) SCM_MGR 사용자 상태 (account_status, default_tablespace, expiry_date)
SELECT username, account_status, default_tablespace, expiry_date, lock_date
  FROM dba_users WHERE username = 'SCM_MGR';

-- 3) SCM_MGR 의 시스템 권한 목록
SELECT privilege FROM dba_sys_privs WHERE grantee = 'SCM_MGR' ORDER BY privilege;

-- 4) SCM_MGR 의 역할 목록
SELECT granted_role, admin_option, default_role
  FROM dba_role_privs WHERE grantee = 'SCM_MGR' ORDER BY granted_role;

-- 5) 역할 정의 자체
SELECT role FROM dba_roles
 WHERE role IN ('RL_SCM_DML','RL_SCM_SEL','SCMD_APP')
 ORDER BY role;

-- 6) 각 역할에 부여된 권한 (SCMD_APP 이 RL_SCM_DML, RL_SCM_SEL 을 갖고 있어야 함)
SELECT grantee, granted_role FROM dba_role_privs
 WHERE grantee IN ('RL_SCM_DML','RL_SCM_SEL','SCMD_APP')
 ORDER BY grantee, granted_role;

-- 7) SCM_MGR 가 객체 만들 수 있는 tablespace quota
SELECT tablespace_name, max_bytes
  FROM dba_ts_quotas WHERE username = 'SCM_MGR';

-- 8) 현재 INVALID 객체 (스키마 생성 직후엔 0 이어야 함)
SELECT object_type, COUNT(*) AS invalid_cnt
  FROM dba_objects WHERE owner = 'SCM_MGR' AND status = 'INVALID'
 GROUP BY object_type ORDER BY object_type;
