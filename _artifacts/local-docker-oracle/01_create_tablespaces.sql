/*=============================================================================================
 * File         : 01_create_tablespaces.sql
 * Description  : To-be_v2_converted DDL 이 사용하는 사내 tablespace 2개를 로컬에 생성
 *              : (TS_SCM_D01 = Data, TS_SCM_X01 = Index)
 * Connection   : sys as sysdba @ FREEPDB1
 * Created      : 2026-05-26
 *
 * 사이즈 정책 :
 *   D01 = 500M START, AUTOEXTEND NEXT 100M MAXSIZE UNLIMITED
 *   X01 = 200M START, AUTOEXTEND NEXT  50M MAXSIZE UNLIMITED
 *===========================================================================================*/

SET ECHO ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE

ALTER SESSION SET CONTAINER = FREEPDB1;

PROMPT === Container ===
SELECT SYS_CONTEXT('USERENV','CON_NAME') AS con_name FROM dual;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 1. TS_SCM_D01 — Data tablespace
-- ---------------------------------------------------------------------------------------------
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM dba_tablespaces WHERE tablespace_name = 'TS_SCM_D01';
    IF v_cnt = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE TABLESPACE TS_SCM_D01
                DATAFILE '/opt/oracle/oradata/FREE/FREEPDB1/ts_scm_d01.dbf' SIZE 500M
                AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED
                EXTENT MANAGEMENT LOCAL AUTOALLOCATE
                SEGMENT SPACE MANAGEMENT AUTO
        ]';
        DBMS_OUTPUT.PUT_LINE('Created tablespace TS_SCM_D01');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TS_SCM_D01 already exists, skipping.');
    END IF;
END;
/

-- ---------------------------------------------------------------------------------------------
-- BLOCK 2. TS_SCM_X01 — Index tablespace
-- ---------------------------------------------------------------------------------------------
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM dba_tablespaces WHERE tablespace_name = 'TS_SCM_X01';
    IF v_cnt = 0 THEN
        EXECUTE IMMEDIATE q'[
            CREATE TABLESPACE TS_SCM_X01
                DATAFILE '/opt/oracle/oradata/FREE/FREEPDB1/ts_scm_x01.dbf' SIZE 200M
                AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED
                EXTENT MANAGEMENT LOCAL AUTOALLOCATE
                SEGMENT SPACE MANAGEMENT AUTO
        ]';
        DBMS_OUTPUT.PUT_LINE('Created tablespace TS_SCM_X01');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TS_SCM_X01 already exists, skipping.');
    END IF;
END;
/

-- ---------------------------------------------------------------------------------------------
-- BLOCK 3. SCM_MGR 의 quota — 두 tablespace 모두에 UNLIMITED
-- ---------------------------------------------------------------------------------------------
ALTER USER SCM_MGR QUOTA UNLIMITED ON TS_SCM_D01;
ALTER USER SCM_MGR QUOTA UNLIMITED ON TS_SCM_X01;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 4. 검증
-- ---------------------------------------------------------------------------------------------
PROMPT === Created tablespaces ===
SELECT df.tablespace_name,
       ts.status,
       ts.contents,
       ROUND(SUM(df.bytes)/1024/1024,1) AS total_mb
  FROM dba_data_files df
  JOIN dba_tablespaces ts ON ts.tablespace_name = df.tablespace_name
 WHERE df.tablespace_name IN ('TS_SCM_D01','TS_SCM_X01')
 GROUP BY df.tablespace_name, ts.status, ts.contents
 ORDER BY df.tablespace_name;

PROMPT === DONE: 01_create_tablespaces.sql ===
EXIT
