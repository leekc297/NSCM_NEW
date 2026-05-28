/*=============================================================================================
 * File         : 02_System_Log_Table.sql
 * Description  : MSSQL → Oracle 변환 — 시스템 로깅 테이블
 *              : SP/PKG의 표준 EXCEPTION 처리에서 사용
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : Foundation 두번째 (TYPE 객체 이후, 로깅 SP 이전)
 * 실행 계정   : SCM_MGR
 *
 * Program History
 *=============================================================================================
 *   Date         In Charge      Description
 *=============================================================================================
 * 2026-05-13     이규철          최초 작성
 *===========================================================================================*/

-- =============================================================================================
-- 1. SCM 시스템 로그 테이블
-- =============================================================================================
CREATE TABLE SCM_MGR.SCM_SYS_LOG (
    LOG_ID            NUMBER(19)           NOT NULL,
    PROGRAM_NAME      VARCHAR2(150 CHAR)   NOT NULL,  -- $$PLSQL_UNIT 값
    LOG_TYPE          VARCHAR2(30 CHAR)    NOT NULL,  -- START / END / INFO / ERROR / WARN
    LOG_COUNT         NUMBER(19)           DEFAULT 0,
    LOG_MESSAGE       VARCHAR2(4000 CHAR),
    DESCRIPTION       CLOB,                            -- BACKTRACE + JSON 입력 파라미터
    EVENT_DATE        TIMESTAMP(6)         DEFAULT SYSTIMESTAMP NOT NULL,
    SESSION_ID        NUMBER(10)           DEFAULT SYS_CONTEXT('USERENV','SID'),
    USER_ID           VARCHAR2(150 CHAR)   DEFAULT SYS_CONTEXT('USERENV','SESSION_USER'),
    CONSTRAINT PK_SCM_SYS_LOG PRIMARY KEY (LOG_ID)
)
  PCTFREE 10 INITRANS 1 MAXTRANS 255
  STORAGE (INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS UNLIMITED PCTINCREASE 0)
  TABLESPACE TS_SCM_D01;

CREATE SEQUENCE SCM_MGR.SEQ_SCM_SYS_LOG
  START WITH 1 INCREMENT BY 1 NOCACHE NOORDER;

CREATE INDEX SCM_MGR.IDX_SCM_SYS_LOG_DATE
ON SCM_MGR.SCM_SYS_LOG (EVENT_DATE, LOG_TYPE)
  TABLESPACE TS_SCM_X01;

CREATE INDEX SCM_MGR.IDX_SCM_SYS_LOG_PROG
ON SCM_MGR.SCM_SYS_LOG (PROGRAM_NAME, EVENT_DATE)
  TABLESPACE TS_SCM_X01;

COMMENT ON TABLE SCM_MGR.SCM_SYS_LOG IS 'SCM 시스템 로그 — SP/PKG 표준 로깅 저장소';
COMMENT ON COLUMN SCM_MGR.SCM_SYS_LOG.LOG_ID         IS '로그 ID (Sequence)';
COMMENT ON COLUMN SCM_MGR.SCM_SYS_LOG.PROGRAM_NAME   IS '프로그램명 ($$PLSQL_UNIT)';
COMMENT ON COLUMN SCM_MGR.SCM_SYS_LOG.LOG_TYPE       IS '로그 유형 (START/END/INFO/ERROR/WARN)';
COMMENT ON COLUMN SCM_MGR.SCM_SYS_LOG.LOG_COUNT      IS '처리 건수';
COMMENT ON COLUMN SCM_MGR.SCM_SYS_LOG.LOG_MESSAGE    IS '로그 메시지';
COMMENT ON COLUMN SCM_MGR.SCM_SYS_LOG.DESCRIPTION    IS '상세 설명 (BACKTRACE, JSON 파라미터)';
COMMENT ON COLUMN SCM_MGR.SCM_SYS_LOG.EVENT_DATE     IS '이벤트 발생 시각';
COMMENT ON COLUMN SCM_MGR.SCM_SYS_LOG.SESSION_ID     IS '세션 ID';
COMMENT ON COLUMN SCM_MGR.SCM_SYS_LOG.USER_ID        IS '실행 사용자 ID';

GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.SCM_SYS_LOG TO RL_SCM_DML;
GRANT SELECT                          ON SCM_MGR.SCM_SYS_LOG TO RL_SCM_SEL;
GRANT SELECT, INSERT                  ON SCM_MGR.SCM_SYS_LOG TO SCMD_APP;
GRANT SELECT                          ON SCM_MGR.SEQ_SCM_SYS_LOG TO RL_SCM_DML;
GRANT SELECT                          ON SCM_MGR.SEQ_SCM_SYS_LOG TO SCMD_APP;

-- =============================================================================================
-- 2. DM 시스템 로그 테이블 (도메인 분리)
-- =============================================================================================
CREATE TABLE SCM_MGR.DM_SYS_LOG (
    LOG_ID            NUMBER(19)           NOT NULL,
    PROGRAM_NAME      VARCHAR2(150 CHAR)   NOT NULL,
    LOG_TYPE          VARCHAR2(30 CHAR)    NOT NULL,
    LOG_COUNT         NUMBER(19)           DEFAULT 0,
    LOG_MESSAGE       VARCHAR2(4000 CHAR),
    DESCRIPTION       CLOB,
    EVENT_DATE        TIMESTAMP(6)         DEFAULT SYSTIMESTAMP NOT NULL,
    SESSION_ID        NUMBER(10)           DEFAULT SYS_CONTEXT('USERENV','SID'),
    USER_ID           VARCHAR2(150 CHAR)   DEFAULT SYS_CONTEXT('USERENV','SESSION_USER'),
    CONSTRAINT PK_DM_SYS_LOG PRIMARY KEY (LOG_ID)
)
  PCTFREE 10 INITRANS 1 MAXTRANS 255
  STORAGE (INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS UNLIMITED PCTINCREASE 0)
  TABLESPACE TS_SCM_D01;

CREATE SEQUENCE SCM_MGR.SEQ_DM_SYS_LOG
  START WITH 1 INCREMENT BY 1 NOCACHE NOORDER;

CREATE INDEX SCM_MGR.IDX_DM_SYS_LOG_DATE
ON SCM_MGR.DM_SYS_LOG (EVENT_DATE, LOG_TYPE)
  TABLESPACE TS_SCM_X01;

CREATE INDEX SCM_MGR.IDX_DM_SYS_LOG_PROG
ON SCM_MGR.DM_SYS_LOG (PROGRAM_NAME, EVENT_DATE)
  TABLESPACE TS_SCM_X01;

COMMENT ON TABLE SCM_MGR.DM_SYS_LOG IS 'DM 도메인 시스템 로그';

GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.DM_SYS_LOG TO RL_SCM_DML;
GRANT SELECT                          ON SCM_MGR.DM_SYS_LOG TO RL_SCM_SEL;
GRANT SELECT, INSERT                  ON SCM_MGR.DM_SYS_LOG TO SCMD_APP;
GRANT SELECT                          ON SCM_MGR.SEQ_DM_SYS_LOG TO RL_SCM_DML;
GRANT SELECT                          ON SCM_MGR.SEQ_DM_SYS_LOG TO SCMD_APP;
