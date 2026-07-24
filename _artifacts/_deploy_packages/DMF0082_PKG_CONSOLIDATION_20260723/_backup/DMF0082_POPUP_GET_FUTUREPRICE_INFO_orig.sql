CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0082_POPUP_GET_FUTUREPRICE_INFO" 
(
    P_START_YYYYMMDD   IN  VARCHAR2,
    P_END_YYYYMMDD     IN  VARCHAR2,
    P_USER_ID          IN VARCHAR2, -- For EditYn
    P_MNU_ID           IN VARCHAR2, -- For EditYn
    O_RC1              OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : DMF0020_GET_FUTUREPRICE_INFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;
BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT YYYYMMDD,
               SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM,
               t1.DIVISION_ID,
               CURRENCY,
               UNIT_CURRENCY,
               EXCHANGE_PRICE,
               NVL(T2.EDIT_YN,'N') AS EDIT_YN
          FROM SCM_MGR.DM_MST_EXCHANGE_RATE t1
              INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T1.DIVISION_ID = T2.UNIT_ID
                     WHERE YYYYMMDD >= P_START_YYYYMMDD
                       AND YYYYMMDD <= P_END_YYYYMMDD;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE,
               'SUCCESS' AS MSG,
               CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
                             'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                             'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                             'P_USER_ID'        VALUE P_USER_ID,
                             'P_MNU_ID'         VALUE P_MNU_ID
                         );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0082_POPUP_GET_FUTUREPRICE_INFO;