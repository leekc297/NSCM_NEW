PROCEDURE           "SCM0010_GET_NOTICE_MASTER"
(
    P_MODULE            IN VARCHAR2,
    P_SUBMODULE         IN VARCHAR2,
    P_ACTIVE            IN VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0010_GET_NOTICE_MASTER
 * Description  : NOTICE SET MASTER 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/22   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
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
    SELECT M.NOTICE_ID
         , M.MODULE_CODE
         , M.SUB_MODULE_CODE
         , M.NOTICE_TITLE NOTICE_MAIN_TITLE
         , M.CYCLE_CLASS_CODE
         , M.DETAIL_CLASS_CODE
         , M.SEND_TIME_TEXT
         , M.VALID_YN     ACTIVE_FLAG
    FROM SCM_ADM_NOTICE_MASTER M
    WHERE 1 = 1
      AND (P_MODULE IS NULL OR M.MODULE_CODE IN (
        SELECT VALUE
        FROM TABLE (FN_SPLITSTRING( P_MODULE, ',' ))
                                                ))
      AND (P_SUBMODULE IS NULL OR M.SUB_MODULE_CODE IN (
        SELECT VALUE
        FROM TABLE (FN_SPLITSTRING( P_SUBMODULE, ',' ))
                                                       ))
      AND (P_ACTIVE IS NULL OR M.VALID_YN IN (
        SELECT VALUE
        FROM TABLE (FN_SPLITSTRING( P_ACTIVE, ',' ))
                                             ))
    ORDER BY M.MODULE_CODE
           , M.SUB_MODULE_CODE
           , M.NOTICE_ID
           , M.CYCLE_CLASS_CODE
           , M.DETAIL_CLASS_CODE
           , M.SEND_TIME_TEXT
           , M.VALID_YN;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_MODULE' VALUE P_MODULE,
            'P_SUBMODULE' VALUE P_SUBMODULE,
            'P_ACTIVE' VALUE P_ACTIVE,
            'P_USER_ID' VALUE P_USER_ID,
            'P_MENU_ID' VALUE P_MENU_ID
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

END SCM0010_GET_NOTICE_MASTER;