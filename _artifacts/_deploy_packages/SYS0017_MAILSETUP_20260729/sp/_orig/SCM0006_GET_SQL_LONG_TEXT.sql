PROCEDURE           "SCM0006_GET_SQL_LONG_TEXT"
(
    P_USE_TYPE    IN VARCHAR2,
    P_MODULE      IN VARCHAR2,
    P_SUBMODULE   IN VARCHAR2,
    P_CATEGORY_ID IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0006_GET_SQL_LONG_TEXT
 * Description  : 등록된 Query를 새창에 보여준다.
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/30   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */
AS
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    OPEN O_RC1 FOR
    SELECT FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 1 ) AS TEXT1
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 2 ) AS TEXT2
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 3 ) AS TEXT3
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 4 ) AS TEXT4
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 5 ) AS TEXT5
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 6 ) AS TEXT6
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 7 ) AS TEXT7
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 8 ) AS TEXT8
    FROM DUAL;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_MODULE' VALUE P_MODULE,
            'P_SUBMODULE' VALUE P_SUBMODULE,
            'P_CATEGORY_ID' VALUE P_CATEGORY_ID
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END SCM0006_GET_SQL_LONG_TEXT;