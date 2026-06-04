-- ============================================================================
-- SCM0005 Phase 3 — INVALID 3 SP 정밀 fix (CREATE OR REPLACE)
-- 작성: 2026-06-04
-- 대상:
--   (1) PR_DM_ADM_DQ_CREATE           — SCM_ADM_DQ_LIST INSERT/UPDATE/DELETE
--   (2) PR_DM_ADM_DQ_CREATE_COLUMN    — SCM_ADM_DQ_COLUMN INSERT/UPDATE/DELETE
--   (3) PR_DM_ADM_DQ_CREATE_PARAMETER — SCM_ADM_DQ_PARAMETER INSERT/UPDATE/DELETE
--
-- INVALID 원인: 자동변환 도구가 MSSQL → Oracle 변환 시 결함 다발 (BEGIN TRY 잔존,
--               EXEC 키워드 누락, IF 분기 BEGIN/END 위치 오류 등).
-- 변환 룰:
--   (a) BEGIN TRY/END TRY/BEGIN CATCH/END CATCH → BEGIN ... EXCEPTION WHEN OTHERS
--   (b) EXEC [dbo].SP arg1, arg2 → SP(arg1, arg2)
--   (c) NEXT VALUE FOR SEQ → SEQ.NEXTVAL
--   (d) sysdatetime() → SYSDATE (또는 SYSTIMESTAMP)
--   (e) SET @var = val → var := val
--   (f) IF cond BEGIN ... END → IF cond THEN ... END IF
--   (g) ERROR_MESSAGE() → SQLERRM, ERROR_LINE() → -- N/A in Oracle, use BACKTRACE
-- ============================================================================

-- BLOCK 0: SCM_ADM_DQ_LIST 의 DQ_ID sequence 신규 생성 (AS-IS SEQ1_SCM_ADM_DQ_LIST 등동)
DECLARE
    v_max NUMBER;
    v_seq_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_seq_exists FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'SEQ1_SCM_ADM_DQ_LIST';
    IF v_seq_exists = 0 THEN
        SELECT NVL(MAX(DQ_ID), 0) + 100 INTO v_max FROM SCM_ADM_DQ_LIST;
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SCM_MGR.SEQ1_SCM_ADM_DQ_LIST START WITH ' || v_max || ' INCREMENT BY 1 NOCACHE NOCYCLE';
    END IF;
END;
/

-- ============================================================================
-- (1) PR_DM_ADM_DQ_CREATE (LIST)
-- ============================================================================
CREATE OR REPLACE PROCEDURE SCM_MGR.PR_DM_ADM_DQ_CREATE
(
    p_active_flag      IN VARCHAR2,
    p_DQ_ID            IN VARCHAR2,
    p_DIVISION_ID      IN VARCHAR2,
    p_DQ_NAME          IN VARCHAR2,
    p_DESCRIPTION      IN VARCHAR2,
    p_DQ_TEXT          IN CLOB,
    p_VALID_YN         IN VARCHAR2,
    p_ADMIN_ONLY_YN    IN VARCHAR2,
    p_sesUserId        IN VARCHAR2,   -- BE 자동 주입 — CREATED_BY/LAST_UPDATED_BY 동시 매핑
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE
 * Description  : Dynamic DQ_TEXT Register Batch (SCM_ADM_DQ_LIST I/M/D, AS-IS 1:1)
 * History
 * 2017.01.04   DWOK/KHSONG       AS-IS Initial PJ20170278
 * 2020.09.09   P.C.I             AS-IS LOG 표준화
 * 2026.06.04   gyucheollee       Oracle 정밀 재변환 (자동변환 도구 결함 fix)
 */
IS
    v_history_seq    NUMBER;
    v_program_name   NVARCHAR2(150) := 'PR_DM_ADM_DQ_CREATE';
    v_log_type       NVARCHAR2(30);
    n_log_count      NUMBER := 0;
    v_log_message    NVARCHAR2(1000);
    v_description    NVARCHAR2(500);
    d_event_date     DATE;
BEGIN
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := NULL;
    d_event_date := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;
    v_log_message := NULL;

    -- HISTORY INSERT (AS-IS EXEC PR_DM_ADM_DQ_CREATE_HIST)
    BEGIN
        SCM_MGR.PR_DM_ADM_DQ_CREATE_HIST(
            p_DQ_ID, p_DIVISION_ID, p_DQ_NAME, p_DESCRIPTION, p_DQ_TEXT,
            p_VALID_YN, p_ADMIN_ONLY_YN, p_sesUserId, p_sesUserId
        );
    EXCEPTION WHEN OTHERS THEN
        -- history 실패는 main 처리를 막지 않음 (AS-IS 동작)
        NULL;
    END;

    /* INSERT */
    IF p_active_flag = 'I' THEN
        v_history_seq := SCM_MGR.SEQ1_SCM_ADM_DQ_LIST.NEXTVAL;
        INSERT INTO SCM_ADM_DQ_LIST
            (DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT, VALID_YN, ADMIN_ONLY_YN,
             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES
            (v_history_seq, p_DIVISION_ID, p_DQ_NAME, p_DESCRIPTION, p_DQ_TEXT, p_VALID_YN, p_ADMIN_ONLY_YN,
             p_sesUserId, SYSDATE, p_sesUserId, SYSDATE);
        n_log_count := n_log_count + SQL%ROWCOUNT;
    END IF;

    /* UPDATE */
    IF p_active_flag = 'M' THEN
        UPDATE SCM_ADM_DQ_LIST
           SET DQ_ID            = TO_NUMBER(p_DQ_ID),
               DIVISION_ID      = p_DIVISION_ID,
               DQ_NAME          = p_DQ_NAME,
               DESCRIPTION      = p_DESCRIPTION,
               DQ_TEXT          = p_DQ_TEXT,
               VALID_YN         = p_VALID_YN,
               ADMIN_ONLY_YN    = p_ADMIN_ONLY_YN,
               LAST_UPDATED_BY  = p_sesUserId,
               LAST_UPDATE_DATE = SYSDATE
         WHERE DQ_ID = TO_NUMBER(p_DQ_ID);
        n_log_count := n_log_count + SQL%ROWCOUNT;
    END IF;

    /* DELETE */
    IF p_active_flag = 'D' THEN
        DELETE FROM SCM_ADM_DQ_LIST WHERE DQ_ID = TO_NUMBER(p_DQ_ID);
        n_log_count := n_log_count + SQL%ROWCOUNT;
    END IF;

    COMMIT;

    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    OPEN O_RESULT_CURSOR FOR
        SELECT 'success'         AS CODE,
               TO_CHAR(v_history_seq) AS SEQNO,
               TO_CHAR(n_log_count)   AS EVENT
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        v_log_type := 'ERROR';
        v_log_message := SUBSTR(SQLERRM, 1, 1000);
        v_description := TO_CHAR(SQLCODE);
        d_event_date := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || v_program_name || '] SQLCODE=' || v_description ||
            ' / SQLERRM=' || v_log_message ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END PR_DM_ADM_DQ_CREATE;
/
SHOW ERRORS PROCEDURE SCM_MGR.PR_DM_ADM_DQ_CREATE;

-- ============================================================================
-- (2) PR_DM_ADM_DQ_CREATE_COLUMN
-- ============================================================================
CREATE OR REPLACE PROCEDURE SCM_MGR.PR_DM_ADM_DQ_CREATE_COLUMN
(
    p_active_flag      IN VARCHAR2,
    p_DQ_ID            IN VARCHAR2,
    p_COLUMN_NAME      IN VARCHAR2,
    p_VALUE_YN         IN VARCHAR2,
    p_VALUE_TYPE       IN VARCHAR2,
    p_VALID_YN         IN VARCHAR2,
    p_SEQNO            IN VARCHAR2,
    p_sesUserId        IN VARCHAR2,   -- BE 자동 주입 — CREATED_BY/LAST_UPDATED_BY 동시 매핑
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_COLUMN
 * Description  : Dynamic Query Register Batch (SCM_ADM_DQ_COLUMN I/M/D, AS-IS 1:1)
 * History
 * 2017.01.04   DWOK/KHSONG       AS-IS Initial PJ20170278
 * 2020.09.09   P.C.I             AS-IS LOG 표준화
 * 2026.06.04   gyucheollee       Oracle 정밀 재변환
 */
IS
    v_program_name   NVARCHAR2(150) := 'PR_DM_ADM_DQ_CREATE_COLUMN';
    v_log_type       NVARCHAR2(30);
    n_log_count      NUMBER := 0;
    v_log_message    NVARCHAR2(1000);
    v_description    NVARCHAR2(500);
    d_event_date     DATE;
BEGIN
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    d_event_date := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, NULL, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    /* INSERT — AS-IS 는 INSERT 전 PK DELETE (idempotent INSERT) */
    IF p_active_flag = 'I' THEN
        DELETE FROM SCM_ADM_DQ_COLUMN
         WHERE DQ_ID       = TO_NUMBER(p_DQ_ID)
           AND COLUMN_NAME = p_COLUMN_NAME;

        INSERT INTO SCM_ADM_DQ_COLUMN
            (DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN,
             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1)
        VALUES
            (TO_NUMBER(p_DQ_ID), p_COLUMN_NAME, p_VALUE_YN, p_VALUE_TYPE, p_VALID_YN,
             p_sesUserId, SYSDATE, p_sesUserId, SYSDATE, p_SEQNO);
        n_log_count := n_log_count + SQL%ROWCOUNT;
    END IF;

    /* UPDATE */
    IF p_active_flag = 'M' THEN
        UPDATE SCM_ADM_DQ_COLUMN
           SET VALUE_YN         = p_VALUE_YN,
               VALUE_TYPE       = p_VALUE_TYPE,
               VALID_YN         = p_VALID_YN,
               LAST_UPDATED_BY  = p_sesUserId,
               LAST_UPDATE_DATE = SYSDATE,
               ATTRIBUTE1       = p_SEQNO
         WHERE DQ_ID       = TO_NUMBER(p_DQ_ID)
           AND COLUMN_NAME = p_COLUMN_NAME;
        n_log_count := n_log_count + SQL%ROWCOUNT;
    END IF;

    /* DELETE */
    IF p_active_flag = 'D' THEN
        DELETE FROM SCM_ADM_DQ_COLUMN
         WHERE DQ_ID       = TO_NUMBER(p_DQ_ID)
           AND COLUMN_NAME = p_COLUMN_NAME;
        n_log_count := n_log_count + SQL%ROWCOUNT;
    END IF;

    -- HISTORY INSERT (AS-IS 위치는 분기 후 — 본 변환에서도 동일)
    BEGIN
        SCM_MGR.PR_DM_ADM_DQ_CREATE_COLUMN_HIST(
            p_DQ_ID, p_COLUMN_NAME, p_VALUE_YN, p_VALUE_TYPE,
            p_VALID_YN, p_sesUserId, p_sesUserId
        );
    EXCEPTION WHEN OTHERS THEN NULL; END;

    COMMIT;

    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, NULL, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    OPEN O_RESULT_CURSOR FOR
        SELECT 'success' AS CODE, TO_CHAR(n_log_count) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        v_log_type := 'ERROR';
        v_log_message := SUBSTR(SQLERRM, 1, 1000);
        v_description := TO_CHAR(SQLCODE);
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, SYSDATE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || v_program_name || '] ' || v_log_message);
END PR_DM_ADM_DQ_CREATE_COLUMN;
/
SHOW ERRORS PROCEDURE SCM_MGR.PR_DM_ADM_DQ_CREATE_COLUMN;

-- ============================================================================
-- (3) PR_DM_ADM_DQ_CREATE_PARAMETER
-- ============================================================================
CREATE OR REPLACE PROCEDURE SCM_MGR.PR_DM_ADM_DQ_CREATE_PARAMETER
(
    p_active_flag      IN VARCHAR2,
    p_DQ_ID            IN VARCHAR2,
    p_PARAMETER_ID     IN VARCHAR2,
    p_PARAMETER_TYPE   IN VARCHAR2,
    p_OPERATION_ID     IN VARCHAR2,
    p_VALID_YN         IN VARCHAR2,
    p_SEQNO            IN VARCHAR2,
    p_REP_YN           IN VARCHAR2,
    p_sesUserId        IN VARCHAR2,   -- BE 자동 주입 — CREATED_BY/LAST_UPDATED_BY 동시 매핑
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_DM_ADM_DQ_CREATE_PARAMETER
 * Description  : Dynamic Query Register Batch (SCM_ADM_DQ_PARAMETER I/M/D, AS-IS 1:1)
 * History
 * 2017.01.04   DWOK/KHSONG       AS-IS Initial PJ20170278
 * 2020.09.09   P.C.I             AS-IS LOG 표준화
 * 2026.06.04   gyucheollee       Oracle 정밀 재변환
 */
IS
    v_program_name   NVARCHAR2(150) := 'PR_DM_ADM_DQ_CREATE_PARAMETER';
    v_log_type       NVARCHAR2(30);
    n_log_count      NUMBER := 0;
    v_log_message    NVARCHAR2(1000);
    v_description    NVARCHAR2(500);
    d_event_date     DATE;
BEGIN
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    d_event_date := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, NULL, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    /* INSERT — idempotent INSERT (PK DELETE 후 INSERT) */
    IF p_active_flag = 'I' THEN
        DELETE FROM SCM_ADM_DQ_PARAMETER
         WHERE DQ_ID        = TO_NUMBER(p_DQ_ID)
           AND PARAMETER_ID = p_PARAMETER_ID;

        INSERT INTO SCM_ADM_DQ_PARAMETER
            (DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID, VALID_YN, REP_YN,
             CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1)
        VALUES
            (TO_NUMBER(p_DQ_ID), p_PARAMETER_ID, p_PARAMETER_TYPE, p_OPERATION_ID, p_VALID_YN, p_REP_YN,
             p_sesUserId, SYSDATE, p_sesUserId, SYSDATE, p_SEQNO);
        n_log_count := n_log_count + SQL%ROWCOUNT;
    END IF;

    /* UPDATE */
    IF p_active_flag = 'M' THEN
        UPDATE SCM_ADM_DQ_PARAMETER
           SET PARAMETER_TYPE   = p_PARAMETER_TYPE,
               OPERATION_ID     = p_OPERATION_ID,
               VALID_YN         = p_VALID_YN,
               REP_YN           = p_REP_YN,
               LAST_UPDATED_BY  = p_sesUserId,
               LAST_UPDATE_DATE = SYSDATE,
               ATTRIBUTE1       = p_SEQNO
         WHERE DQ_ID        = TO_NUMBER(p_DQ_ID)
           AND PARAMETER_ID = p_PARAMETER_ID;
        n_log_count := n_log_count + SQL%ROWCOUNT;
    END IF;

    /* DELETE */
    IF p_active_flag = 'D' THEN
        DELETE FROM SCM_ADM_DQ_PARAMETER
         WHERE DQ_ID        = TO_NUMBER(p_DQ_ID)
           AND PARAMETER_ID = p_PARAMETER_ID;
        n_log_count := n_log_count + SQL%ROWCOUNT;
    END IF;

    -- HISTORY
    BEGIN
        SCM_MGR.PR_DM_ADM_DQ_CREATE_PARAMETER_HIST(
            p_DQ_ID, p_PARAMETER_ID, p_PARAMETER_TYPE, p_OPERATION_ID,
            p_VALID_YN, p_REP_YN, p_sesUserId, p_sesUserId
        );
    EXCEPTION WHEN OTHERS THEN NULL; END;

    COMMIT;

    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, NULL, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    OPEN O_RESULT_CURSOR FOR
        SELECT 'success' AS CODE, TO_CHAR(n_log_count) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        v_log_type := 'ERROR';
        v_log_message := SUBSTR(SQLERRM, 1, 1000);
        v_description := TO_CHAR(SQLCODE);
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, SYSDATE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || v_program_name || '] ' || v_log_message);
END PR_DM_ADM_DQ_CREATE_PARAMETER;
/
SHOW ERRORS PROCEDURE SCM_MGR.PR_DM_ADM_DQ_CREATE_PARAMETER;

PROMPT === Final SP states ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('PR_DM_ADM_DQ_CREATE', 'PR_DM_ADM_DQ_CREATE_COLUMN', 'PR_DM_ADM_DQ_CREATE_PARAMETER')
 ORDER BY OBJECT_NAME;
