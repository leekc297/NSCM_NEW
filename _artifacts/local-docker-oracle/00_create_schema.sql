/*=============================================================================================
 * File         : 00_create_schema.sql
 * Description  : 로컬 Docker Oracle (gvenzl/oracle-free:23-slim-faststart, PDB=FREEPDB1)
 *              : SCM_MGR 스키마 + 권한 + 역할 생성 (SYS DBA 로 실행)
 * Target       : sqlplus sys/<pwd>@//localhost:1521/FREEPDB1 as sysdba
 * Created      : 2026-05-26
 *
 * 실행 방법    :
 *   docker exec -i nscm-oracle sqlplus -L sys/'!SCMroqkf2026'@//localhost:1521/FREEPDB1 as sysdba @/work/_artifacts/local-docker-oracle/00_create_schema.sql
 *
 * 사용자 결정 :
 *   - DDL 적재 범위 = To-be_v2_converted 만 (As-Is MSSQL 변환은 화면 단위 점진)
 *   - DB 비밀번호  = As-Is 와 동일 (!SCMroqkf2026)
 *   - 호스트 포트  = 1521
 *   - BE 연결도 SCM_MGR 로 직접 (로컬 환경, app 계정 분리 생략)
 *===========================================================================================*/

SET ECHO ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE

-- ---------------------------------------------------------------------------------------------
-- BLOCK 1. 컨테이너 위치 / 세션 확인 (CDB$ROOT 가 아니라 FREEPDB1 PDB 안에 있어야 함)
-- ---------------------------------------------------------------------------------------------
ALTER SESSION SET CONTAINER = FREEPDB1;

PROMPT === Current container ===
SELECT SYS_CONTEXT('USERENV','CON_NAME')   AS con_name,
       SYS_CONTEXT('USERENV','CURRENT_USER') AS current_user
  FROM dual;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 2. SCM_MGR 스키마 생성 (이미 있으면 DROP 후 재생성 — 로컬 환경 reset 안전)
-- ---------------------------------------------------------------------------------------------
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM dba_users WHERE username = 'SCM_MGR';
    IF v_cnt > 0 THEN
        EXECUTE IMMEDIATE 'DROP USER SCM_MGR CASCADE';
        DBMS_OUTPUT.PUT_LINE('Dropped existing SCM_MGR user.');
    END IF;
END;
/

CREATE USER SCM_MGR
    IDENTIFIED BY "!SCMroqkf2026"
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 3. 기본 권한 (Oracle 23c — 명시적 DBA 권한 부여 필요)
-- ---------------------------------------------------------------------------------------------
GRANT CREATE SESSION         TO SCM_MGR;
GRANT CONNECT, RESOURCE      TO SCM_MGR;
GRANT UNLIMITED TABLESPACE   TO SCM_MGR;
GRANT CREATE TABLE           TO SCM_MGR;
GRANT CREATE VIEW            TO SCM_MGR;
GRANT CREATE PROCEDURE       TO SCM_MGR;
GRANT CREATE SEQUENCE        TO SCM_MGR;
GRANT CREATE TRIGGER         TO SCM_MGR;
GRANT CREATE SYNONYM         TO SCM_MGR;
GRANT CREATE PUBLIC SYNONYM  TO SCM_MGR;
GRANT DROP PUBLIC SYNONYM    TO SCM_MGR;
GRANT CREATE TYPE            TO SCM_MGR;
GRANT CREATE JOB             TO SCM_MGR;
GRANT EXECUTE ON DBMS_LOCK   TO SCM_MGR;
GRANT EXECUTE ON DBMS_OUTPUT TO SCM_MGR;
GRANT EXECUTE ON DBMS_UTILITY TO SCM_MGR;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 4. 역할 생성 (To-be_v2_converted Foundation 의 GRANT 대상)
--          이미 있으면 CREATE OR REPLACE 가 안 되므로 DROP 후 재생성
-- ---------------------------------------------------------------------------------------------
DECLARE
    PROCEDURE drop_role(p_role VARCHAR2) IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM dba_roles WHERE role = p_role;
        IF v_cnt > 0 THEN
            EXECUTE IMMEDIATE 'DROP ROLE ' || p_role;
            DBMS_OUTPUT.PUT_LINE('Dropped role ' || p_role);
        END IF;
    END;
BEGIN
    drop_role('RL_SCM_DML');
    drop_role('RL_SCM_SEL');
    drop_role('SCMD_APP');
END;
/

CREATE ROLE RL_SCM_DML;
CREATE ROLE RL_SCM_SEL;
CREATE ROLE SCMD_APP;

GRANT RL_SCM_DML, RL_SCM_SEL TO SCMD_APP;
GRANT SCMD_APP                TO SCM_MGR;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 5. 검증
-- ---------------------------------------------------------------------------------------------
PROMPT === Created user & roles ===
SELECT username, account_status, default_tablespace
  FROM dba_users
 WHERE username = 'SCM_MGR';

SELECT role FROM dba_roles
 WHERE role IN ('RL_SCM_DML','RL_SCM_SEL','SCMD_APP')
 ORDER BY role;

PROMPT === SCM_MGR granted roles ===
SELECT granted_role FROM dba_role_privs
 WHERE grantee = 'SCM_MGR'
 ORDER BY granted_role;

PROMPT === DONE: 00_create_schema.sql ===
EXIT
