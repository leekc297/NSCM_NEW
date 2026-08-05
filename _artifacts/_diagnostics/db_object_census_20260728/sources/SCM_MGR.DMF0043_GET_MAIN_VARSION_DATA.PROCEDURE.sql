PROCEDURE           "DMF0043_GET_MAIN_VARSION_DATA"
/****************************************************************************************************/
/* Program ID  : DMF0043_GET_MAIN_VARSION_DATA								   */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :										    */
/*												    */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description 							    */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/07/18     JYE		기여율 등록화면 Version 바인딩 데이터                    */
/****************************************************************************************************/
(
    p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
)
AS
    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE	  VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
BEGIN

	/* TODO:EDIT_YN:수동확인필요 */
	OPEN O_RC1 FOR
	SELECT
		VER_SEQ AS CODE
		,VERSION_NM NAME
		,VER_SEQ
		,YYYY
		,VERSION_NM
		,DESCRIPTION
		,YYYY  ||  '('	||  VERSION_NM	||  ')' AS NAME2
		, 'Y' AS EDIT_YN
	FROM DM_MST_CONTRIBUTE_VER
	WHERE VALID_YN = 'Y'
    ORDER BY YYYY DESC;

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