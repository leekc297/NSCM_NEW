
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP" 
(
    p_division_id					VARCHAR2,
	p_from_yyyymmdd				VARCHAR2,
	p_to_yyyymmdd					VARCHAR2,
	p_created_by					VARCHAR2,
	p_cate							VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP                                           */
/* Description : Procedure 작성 가이드                                                               */
/* Usage       : Procedure 작성 시 참조하세요!                                                       */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2019/04/10  JYE            Business Plan 추가														*/
/* 2022/10/24	ROSIA27				[C20221024-000510]DM UI 소스 정리 요청							*/
/****************************************************************************************************/
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
            'p_division_id' VALUE p_division_id,
            'p_from_yyyymmdd' VALUE p_from_yyyymmdd,
            'p_to_yyyymmdd' VALUE p_to_yyyymmdd,
            'p_created_by' VALUE p_created_by,
            'p_cate' VALUE p_cate
          );

	IF (p_cate = 'BP') THEN
		OPEN O_RC1 FOR
		SELECT
			DIVISION_ID
			,CURRENCY
			,UNIT_CURRENCY
			,CURRENCY  ||  '/'  ||  UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
			, tei.EDIT_YN
		FROM DM_BP_EXCHANGE_RATE
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = DIVISION_ID
		WHERE
		(YYYYMMDD >= p_from_yyyymmdd and YYYYMMDD <= p_to_yyyymmdd)
		AND CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   				ELSE DIVISION_ID
				END IN (
						Select * from TABLE(fn_string_split(p_division_id,',')) P Where
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.token
						)
		GROUP BY DIVISION_ID,CURRENCY, UNIT_CURRENCY;
	ELSE
		OPEN O_RC1 FOR
		SELECT
			DIVISION_ID
			,CURRENCY
			,UNIT_CURRENCY
			,CURRENCY  ||  '/'  ||  UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
			, tei.EDIT_YN
		FROM DM_MST_EXCHANGE_RATE
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = DIVISION_ID
		WHERE
		(YYYYMMDD >= p_from_yyyymmdd and YYYYMMDD <= p_to_yyyymmdd)
		AND CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   				ELSE DIVISION_ID
				END IN (
						Select * from TABLE(fn_string_split(p_division_id,',')) P Where
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.token
						)
		GROUP BY DIVISION_ID,CURRENCY, UNIT_CURRENCY;
	END IF;

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