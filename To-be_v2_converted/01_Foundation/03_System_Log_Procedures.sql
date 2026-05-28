/*=============================================================================================
 * File         : 03_System_Log_Procedures.sql
 * Description  : MSSQL → Oracle 변환 — 표준 로깅 SP
 *              : 모든 PKG/SP의 EXCEPTION 블록에서 호출되는 표준 로깅 프로시저
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 * Source Rule  : Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md §11
 *
 * 실행 순서   : Foundation 세번째 (TYPE + 로그 테이블 이후)
 * 실행 계정   : SCM_MGR
 *
 * Program History
 *=============================================================================================
 *   Date         In Charge      Description
 *=============================================================================================
 * 2026-05-13     이규철          최초 작성 — AUTONOMOUS_TRANSACTION 적용 (호출 트랜잭션과 분리)
 *===========================================================================================*/

-- =============================================================================================
-- 1. PR_SCM_SYS_LOG_BATCH — SCM 도메인 표준 로깅 SP
--    원 SP의 트랜잭션과 분리하기 위해 AUTONOMOUS_TRANSACTION 사용
-- =============================================================================================
CREATE OR REPLACE PROCEDURE SCM_MGR.PR_SCM_SYS_LOG_BATCH
(
    p_program_name  IN VARCHAR2,
    p_log_type      IN VARCHAR2,
    p_log_count     IN NUMBER   DEFAULT 0,
    p_log_message   IN VARCHAR2 DEFAULT NULL,
    p_description   IN CLOB     DEFAULT NULL,
    p_event_date    IN DATE     DEFAULT SYSDATE
)
/*=============================================================================================
 * Program ID   : PR_SCM_SYS_LOG_BATCH
 * Description  : SCM 도메인 SP/PKG 표준 로깅
 *              : 호출 트랜잭션과 분리(AUTONOMOUS_TRANSACTION)되어 ROLLBACK 영향 없이 로그 보존
 * Parameters   :
 *   p_program_name : $$PLSQL_UNIT 값 권장
 *   p_log_type     : START / END / INFO / ERROR / WARN
 *   p_log_count    : 처리 건수
 *   p_log_message  : 로그 메시지 (≤4000 byte)
 *   p_description  : 상세 (BACKTRACE + JSON 파라미터 등)
 *   p_event_date   : 이벤트 시각 (생략 시 SYSDATE)
 *===========================================================================================*/
AS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO SCM_MGR.SCM_SYS_LOG (
        LOG_ID, PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE
    ) VALUES (
        SCM_MGR.SEQ_SCM_SYS_LOG.NEXTVAL,
        p_program_name,
        p_log_type,
        p_log_count,
        SUBSTR(p_log_message, 1, 4000),
        p_description,
        p_event_date
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- 로깅 실패는 호출자 트랜잭션에 영향 없도록 무시
        ROLLBACK;
END PR_SCM_SYS_LOG_BATCH;
/

-- =============================================================================================
-- 2. PR_DM_SYS_LOG_BATCH — DM 도메인 표준 로깅 SP
-- =============================================================================================
CREATE OR REPLACE PROCEDURE SCM_MGR.PR_DM_SYS_LOG_BATCH
(
    p_program_name  IN VARCHAR2,
    p_log_type      IN VARCHAR2,
    p_log_count     IN NUMBER   DEFAULT 0,
    p_log_message   IN VARCHAR2 DEFAULT NULL,
    p_description   IN CLOB     DEFAULT NULL,
    p_event_date    IN DATE     DEFAULT SYSDATE
)
/*=============================================================================================
 * Program ID   : PR_DM_SYS_LOG_BATCH
 * Description  : DM 도메인 SP/PKG 표준 로깅 (PR_SCM_SYS_LOG_BATCH와 동일 인터페이스, 별도 테이블)
 *===========================================================================================*/
AS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO SCM_MGR.DM_SYS_LOG (
        LOG_ID, PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE
    ) VALUES (
        SCM_MGR.SEQ_DM_SYS_LOG.NEXTVAL,
        p_program_name,
        p_log_type,
        p_log_count,
        SUBSTR(p_log_message, 1, 4000),
        p_description,
        p_event_date
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END PR_DM_SYS_LOG_BATCH;
/

-- =============================================================================================
-- 권한 부여
-- =============================================================================================
GRANT EXECUTE ON SCM_MGR.PR_SCM_SYS_LOG_BATCH TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.PR_SCM_SYS_LOG_BATCH TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.PR_DM_SYS_LOG_BATCH  TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.PR_DM_SYS_LOG_BATCH  TO RL_SCM_DML;

CREATE OR REPLACE PUBLIC SYNONYM PR_SCM_SYS_LOG_BATCH FOR SCM_MGR.PR_SCM_SYS_LOG_BATCH;
CREATE OR REPLACE PUBLIC SYNONYM PR_DM_SYS_LOG_BATCH  FOR SCM_MGR.PR_DM_SYS_LOG_BATCH;

-- =============================================================================================
-- 검증
-- =============================================================================================
-- BEGIN
--     SCM_MGR.PR_SCM_SYS_LOG_BATCH('TEST_PROG', 'INFO', 1, 'Test log message', 'Test description');
-- END;
-- /
-- SELECT * FROM SCM_MGR.SCM_SYS_LOG ORDER BY LOG_ID DESC;
