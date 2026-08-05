PROCEDURE           "SCM0006_GET_RECIPIENT_MASTER"
(
    P_USE_TYPE  IN VARCHAR2,
    P_MODULE    IN VARCHAR2,
    P_SUBMODULE IN VARCHAR2,
    P_ACTIVE    IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0006_GET_RECIPIENT_MASTER
 * Description  : MAIL SET MASTER 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/05   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/15    hwyoon    메일링 분단위 발송 추가
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
         , M.MODULE_CODE
         , M.SUB_MODULE_CODE
         , M.CATEGORY_ID
         , M.CATEGORY_DESC
         , M.CYCLE_CLASS_CODE
         , M.DETAIL_CLASS_CODE
         , M.SEND_TIME_TEXT
         , M.SEND_MIN_TIME_TEXT
         , M.VALID_YN ACTIVE_FLAG
    FROM SCM_ADM_RECIPIENT_LIST M
    WHERE 1 = 1
      AND M.USE_TYPE_CODE = P_USE_TYPE
      AND ( P_MODULE IS NULL
            OR M.MODULE_CODE IN (
                                    SELECT VALUE
                                    FROM JSON_TABLE( '["' || REPLACE( P_MODULE, ',', '","' ) || '"]', '$[*]' COLUMNS (VALUE VARCHAR2(4000) PATH '$') )
                                )
          )
      AND ( P_SUBMODULE IS NULL
            OR M.SUB_MODULE_CODE IN (
                                    SELECT VALUE
                                    FROM JSON_TABLE( '["' || REPLACE( P_SUBMODULE, ',', '","' ) || '"]', '$[*]' COLUMNS (VALUE VARCHAR2(4000) PATH '$') )
                                    )
          )
      AND ( P_ACTIVE IS NULL
            OR M.VALID_YN IN (
                                    SELECT VALUE
                                    FROM JSON_TABLE( '["' || REPLACE( P_ACTIVE, ',', '","' ) || '"]', '$[*]' COLUMNS (VALUE VARCHAR2(4000) PATH '$') )
                             )
          )
    ORDER BY M.USE_TYPE_CODE
           , M.MODULE_CODE
           , M.SUB_MODULE_CODE
           , M.CATEGORY_DESC
           , M.CYCLE_CLASS_CODE
           , M.DETAIL_CLASS_CODE
           , M.SEND_TIME_TEXT
           , M.SEND_MIN_TIME_TEXT
           , M.VALID_YN;

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
            'P_ACTIVE' VALUE P_ACTIVE
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

END SCM0006_GET_RECIPIENT_MASTER;