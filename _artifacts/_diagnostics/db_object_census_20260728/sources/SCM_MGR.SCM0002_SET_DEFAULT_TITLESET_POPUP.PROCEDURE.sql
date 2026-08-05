PROCEDURE           "SCM0002_SET_DEFAULT_TITLESET_POPUP"
(
    P_PROGRAM_ID   IN VARCHAR2,
    P_SHEET_NAME   IN VARCHAR2,
    P_COLUMN_TYPE  IN VARCHAR2,
    P_USER_ID      IN VARCHAR2,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0002_SET_DEFAULT_TITLESET_POPUP
 * Description  : Column Setting, Measure Setting
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정병훈         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.19    윤혜원           유저컬럼 조회 조건 수정
 * 2026.05.19  최용훈           MS-SQL -> Oracle 변환
 * 2026.05.20	변명주		 불필요 파라미터 제거
 *
 */
AS
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    IF P_COLUMN_TYPE = 'C' THEN
        -- COLUMN
        INSERT INTO SCM_MST_TITLESET_USER
        (
            USER_ID
        ,   PROGRAM_ID
        ,   SHEET_NAME
        ,   USER_INQUIRY_COLUMN_TYPE_CODE
        ,   COLUMN_NAME
        ,   SORT_ORDER_NO
        ,   DATA_SORT_METHOD_CODE
        ,   CREATED_BY
        ,   CREATION_DATE
        ,   LAST_UPDATED_BY
        ,   LAST_UPDATE_DATE
        )
        SELECT P_USER_ID
             , B.PROGRAM_ID
             , B.SHEET_NAME
             , P_COLUMN_TYPE
             , B.COLUMN_NAME
             , RANK( ) OVER (ORDER BY B.SORT_ORDER_NO)
             , FN_SCM_SYS_NVL( B.DATA_SORT_METHOD_CODE, 'ASC' )
             , P_USER_ID
             , SYSTIMESTAMP
             , P_USER_ID
             , SYSTIMESTAMP
        FROM SCM_MST_SHEET_COLUMNS B
        WHERE B.PROGRAM_ID = P_PROGRAM_ID
          AND B.SHEET_NAME = FN_SCM_SYS_NVL( P_SHEET_NAME, B.SHEET_NAME )
          AND B.VALID_YN = 'Y'
          --AND    B.USER_SELECTABLE_FLAG = 'Y'
          AND B.DEFAULT_FLAG = 'Y'
          AND NVL( B.ATTRIBUTE6, 'Y' ) <> 'N'
          AND NOT EXISTS
            (
                SELECT 1
                FROM SCM_MST_TITLESET_USER U
                WHERE U.USER_ID = P_USER_ID
                  AND U.PROGRAM_ID = B.PROGRAM_ID
                  AND U.SHEET_NAME = B.SHEET_NAME
                  AND U.USER_INQUIRY_COLUMN_TYPE_CODE = P_COLUMN_TYPE
            );
    ELSE
        -- MEASURE
        INSERT INTO SCM_MST_TITLESET_USER
        (
            USER_ID
        ,   PROGRAM_ID
        ,   SHEET_NAME
        ,   USER_INQUIRY_COLUMN_TYPE_CODE
        ,   COLUMN_NAME
        ,   SORT_ORDER_NO
        ,   DATA_SORT_METHOD_CODE
        ,   CREATED_BY
        ,   CREATION_DATE
        ,   LAST_UPDATED_BY
        ,   LAST_UPDATE_DATE
        )

        SELECT P_USER_ID
             , B.PROGRAM_ID
             , B.SHEET_NAME
             , P_COLUMN_TYPE
             , B.COLUMN_NAME
             , B.SORT_ORDER_NO
             , NULL
             , P_USER_ID
             , SYSTIMESTAMP
             , P_USER_ID
             , SYSTIMESTAMP
        FROM SCM_MST_SHEET_MEASURE B
        WHERE B.PROGRAM_ID = P_PROGRAM_ID
          AND B.SHEET_NAME = FN_SCM_SYS_NVL( P_SHEET_NAME, B.SHEET_NAME )
          AND B.DEFAULT_FLAG = 'Y'
          AND NOT EXISTS
            (
                SELECT 1
                FROM SCM_MST_TITLESET_USER U
                WHERE U.USER_ID = P_USER_ID
                  AND U.PROGRAM_ID = B.PROGRAM_ID
                  AND U.SHEET_NAME = B.SHEET_NAME
                  AND U.USER_INQUIRY_COLUMN_TYPE_CODE = P_COLUMN_TYPE
            );
    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_PROGRAM_ID' VALUE P_PROGRAM_ID,
            'P_SHEET_NAME' VALUE P_SHEET_NAME,
            'P_COLUMN_TYPE' VALUE P_COLUMN_TYPE,
            'P_USER_ID' VALUE P_USER_ID
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

END SCM0002_SET_DEFAULT_TITLESET_POPUP;