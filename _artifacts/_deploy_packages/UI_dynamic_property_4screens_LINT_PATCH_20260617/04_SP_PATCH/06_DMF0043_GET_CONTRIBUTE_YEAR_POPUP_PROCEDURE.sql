CREATE OR REPLACE PROCEDURE           "DMF0043_GET_CONTRIBUTE_YEAR_POPUP"
/*
 **************************************************************************************************
 * Program ID  :  DMF0043_GET_CONTRIBUTE_YEAR_POPUP
 * Description : DMF0043 > 검색 연도
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description
 *--------------------------------------------------------------------------------------------------
 * 2019/05/09  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 **************************************************************************************************
*/
(
    p_user_id VARCHAR2
  , p_menu_id VARCHAR2
  , O_RC1  OUT	SYS_REFCURSOR
)
AS
    V_LOG_TYPE	  VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    v_in_para_data VARCHAR2(4000) := NULL;
BEGIN

	/* TODO:EDIT_YN:수동확인필요 */
	OPEN O_RC1 FOR
	SELECT CODE, NAME
	     , 'Y' AS EDIT_YN
	FROM
	(
		SELECT
			'ALL' AS CODE
			,'ALL' AS NAME
			,0 SORTORDER
		FROM DUAL
		UNION ALL

		SELECT
			YYYY AS CODE
			,YYYY NAME
			,ROW_NUMBER() OVER (ORDER BY YYYY) SORTORDER
		FROM DM_MST_CONTRIBUTE_VER
		GROUP BY YYYY
	) MA
	ORDER BY SORTORDER;

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
