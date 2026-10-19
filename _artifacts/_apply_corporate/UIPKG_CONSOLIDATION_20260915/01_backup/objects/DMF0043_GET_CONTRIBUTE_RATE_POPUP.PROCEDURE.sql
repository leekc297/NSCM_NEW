-- SOURCE-FRESH: SCM_MGR.DMF0043_GET_CONTRIBUTE_RATE_POPUP PROCEDURE LAST_DDL=2026-09-02 17:30:23 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0043_GET_CONTRIBUTE_RATE_POPUP" 
(
	p_yyyy		    VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 **************************************************************************************************
 * Program ID  :  DMF0043_GET_CONTRIBUTE_RATE_POPUP
 * Description : DMF0043 > 기여율 관리 팝업
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
AS
    v_in_para_data VARCHAR2(4000);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_yyyy' VALUE p_yyyy
	  );
	OPEN O_RC1 FOR
	SELECT
		VER_SEQ
		,YYYY
		,VERSION_NM
		,DESCRIPTION
		,VALID_YN
	FROM DM_MST_CONTRIBUTE_VER
	WHERE YYYY = CASE WHEN p_yyyy IS NULL OR p_yyyy = 'ALL' THEN YYYY ELSE p_yyyy END
    ORDER BY YYYY DESC;
    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
	    p_in_para_data  => v_in_para_data,
	    p_sql_err_code  => SQLCODE,
	    p_sql_err_msg   => SQLERRM,
	    p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
	);
	RAISE_APPLICATION_ERROR(-20001,
	    '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	    ' / SQLERRM=' || SQLERRM ||
	    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	    ' / PARAMS=' || v_in_para_data
	);
END;
/
