-- ============================================================================================
-- File         : 00_create_schema_DBeaver.sql
-- Description  : DBeaver 호환판 (SQL*Plus 명령 제거). SYS as SYSDBA 로 FREEPDB1 에 접속한 뒤
--              : 각 statement 를 순서대로 Ctrl+Enter 실행.
-- Connection   : URL = jdbc:oracle:thin:@//localhost:1521/FREEPDB1 , user = sys as sysdba
-- ============================================================================================

-- ---------------------------------------------------------------------------------------------
-- BLOCK 1. 현재 컨테이너 확인 (DBeaver 는 접속 시 이미 FREEPDB1 — ALTER SESSION 불필요)
-- ---------------------------------------------------------------------------------------------
SELECT SYS_CONTEXT('USERENV','CON_NAME')      AS con_name,
       SYS_CONTEXT('USERENV','CURRENT_USER')  AS current_user
  FROM dual;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 2. SCM_MGR 스키마 (있으면 DROP 후 재생성)
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

CREATE USER SCM_MGR
    IDENTIFIED BY "!SCMroqkf2026"
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 3. 기본 권한
-- ---------------------------------------------------------------------------------------------
GRANT CREATE SESSION          TO SCM_MGR;
GRANT CONNECT, RESOURCE       TO SCM_MGR;
GRANT UNLIMITED TABLESPACE    TO SCM_MGR;
GRANT CREATE TABLE            TO SCM_MGR;
GRANT CREATE VIEW             TO SCM_MGR;
GRANT CREATE PROCEDURE        TO SCM_MGR;
GRANT CREATE SEQUENCE         TO SCM_MGR;
GRANT CREATE TRIGGER          TO SCM_MGR;
GRANT CREATE SYNONYM          TO SCM_MGR;
GRANT CREATE PUBLIC SYNONYM   TO SCM_MGR;
GRANT DROP PUBLIC SYNONYM     TO SCM_MGR;
GRANT CREATE TYPE             TO SCM_MGR;
GRANT CREATE JOB              TO SCM_MGR;
GRANT EXECUTE ON DBMS_LOCK    TO SCM_MGR;
GRANT EXECUTE ON DBMS_OUTPUT  TO SCM_MGR;
GRANT EXECUTE ON DBMS_UTILITY TO SCM_MGR;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 4. 역할 (있으면 DROP 후 재생성)
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

CREATE ROLE RL_SCM_DML;
CREATE ROLE RL_SCM_SEL;
CREATE ROLE SCMD_APP;

GRANT RL_SCM_DML, RL_SCM_SEL TO SCMD_APP;
GRANT SCMD_APP               TO SCM_MGR;
