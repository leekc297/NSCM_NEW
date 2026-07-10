CREATE OR REPLACE PROCEDURE           "DMF0000_GET_UPDATE_HISTORY"
(
    O_RC1            OUT SYS_REFCURSOR,
    O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
/***************************************************************************************************
 Program ID  : DMF0000_GET_UPDATE_HISTORY
 Description : EDI STATUS UPDATE HISTORY 조회 (PR_DM_DNM_EDI_CALLOFF_STATUS 의 SCM_SYS_LOG_BATCH 결과)
--------------------------------------------------------------------------------------------------
 2023/11/30  kjj    PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - EDI STATUS UPDATE HISTORY 조회
 2026.03.16  jcnam  [PJ20264226] NextSCM Pilot 설계 및 개발
**************************************************************************************************/
AS
    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;
BEGIN
    OPEN O_RC1 FOR
    SELECT
    (
        SELECT TO_CHAR(MAX(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') FROM SCM_SYS_LOG_BATCH
        WHERE  PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
        AND    LOG_TYPE = 'START'
    ) AS SDATE,
    (
        SELECT TO_CHAR(MAX(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') FROM SCM_SYS_LOG_BATCH
        WHERE  PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
        AND    LOG_TYPE = 'END'
    ) AS EDATE,
    (
        SELECT LAST_UPDATED_BY FROM SCM_SYS_LOG_BATCH
        WHERE  LAST_UPDATE_DATE =
        (
            SELECT MAX(LAST_UPDATE_DATE) FROM SCM_SYS_LOG_BATCH
            WHERE  PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
            AND    LOG_TYPE = 'START'
        )
        AND    ROWNUM = 1
    ) AS UPDATED_BY
    FROM DUAL;

    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END DMF0000_GET_UPDATE_HISTORY;
/
