PROCEDURE           "SCM0006_GET_RECIPIENT_MESSAGE"
(
    P_USE_TYPE        IN  VARCHAR2,
    P_CATEGORYID      IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0006_GET_RECIPIENT_MESSAGE
 * Description  : MAIL SET MESSAGE 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/19   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
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
    SELECT M.USE_TYPE_CODE
         , M.CATEGORY_ID
         , R.CATEGORY_DESC AS CATEGORY_DESC
         , M.LANGUAGE_CODE
         , LD.SEGMENT2        LANGUAGE
         , M.MAIL_TITLE
         , M.MESSAGE_CONTENT
    FROM SCM_ADM_RECIPIENT_MESSAGE                   M
             INNER JOIN SCM_ADM_RECIPIENT_LIST       R
             ON R.CATEGORY_ID = M.CATEGORY_ID
             INNER JOIN SCM_ADM_LOOKUP_MASTER        LM
             ON LM.LOOKUP_TYPE = 'LANGUAGE' AND LM.VALID_YN = 'Y'
             INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD
             ON LD.LOOKUP_TYPE = LM.LOOKUP_TYPE AND LD.SEGMENT1 = M.LANGUAGE_CODE AND LD.VALID_YN = 'Y'
    WHERE M.USE_TYPE_CODE = P_USE_TYPE
      AND M.CATEGORY_ID = P_CATEGORYID;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_CATEGORYID' VALUE P_CATEGORYID
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

END SCM0006_GET_RECIPIENT_MESSAGE;