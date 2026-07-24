
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_GET_EXCHANGE_PRICE" 
(
  p_start_yyyymmdd VARCHAR2,
  p_end_yyyymmdd VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0042_GET_EXCHANGE_PRICE
 * Description  : Biz Plan 에서 사용되는 환율 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/10   JYE         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026/03/15   김준규         [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
AS
    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE    VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
            'p_end_yyyymmdd' VALUE p_end_yyyymmdd
          );

	OPEN O_RC1 FOR
	SELECT YYYYMMDD, SUBSTR(YYYYMMDD,1,6) YYYYMM, DIVISION_ID, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
	     , tei.EDIT_YN
	FROM DM_MST_EXCHANGE_RATE
	INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
	   ON tei.UNIT_ID = DM_MST_EXCHANGE_RATE.DIVISION_ID
	WHERE
	YYYYMMDD >= p_start_yyyymmdd AND YYYYMMDD <= p_end_yyyymmdd;


    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE   := 'ERROR';
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                            V_LOG_TYPE,
                            N_LOG_COUNT,
                            V_LOG_MESSAGE,
                            V_DESCRIPTION,
                            D_EVENT_DATE,
                            V_PROC_INPUT,
                            V_SQL_CODE,
                            V_SQL_ERRMSG,
                            V_BACKTRACE
                            );
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || v_in_para_data
        );
END;
/