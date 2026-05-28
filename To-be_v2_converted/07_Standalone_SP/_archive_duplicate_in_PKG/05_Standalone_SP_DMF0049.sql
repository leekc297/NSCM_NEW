-- ============================================================================
-- ARCHIVED: 다음 SP들은 PKG_DMF0049 에 이미 등록되어 있어 standalone에서 제거됨
--          PKG 호출 권장: SCM_MGR.PKG_DMF0049.P_{SP_NAME}
-- ============================================================================


-- DMF0049_GET_MEASURE → PKG_DMF0049.P_DMF0049_GET_MEASURE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0049_GET_MEASURE
(
 p_division_id  VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0049_GET_MEASURE
 * Description  :  Sales ETC Report 메저 가져오기
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/03/30 HWI1993   Initial Release -- dmf0044 에서 복사해서 생성
 * 2020/05/04 HWI1993   DIVISION_ID 를 WHERE 절에 추가
 * 2020/06/10 HWI1993   40이 아닌 경우 USD 추가
 * 2021/01/28 P.C.I   [C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
   2022.04.25 HWI1993   GM JV 작업
   2026.03.14 김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
*/
AS

    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_in_para_data VARCHAR2(4000);
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_division_id' VALUE p_division_id
          );

  IF p_division_id = '40' THEN
    OPEN O_RC1 FOR
    SELECT
        COLUMN_NAME AS CODE
        , COLUMN_LABEL_NAME NAME
        , tei.EDIT_YN
    FROM SCM_MST_SHEET_MEASURE A
    INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
       ON tei.UNIT_ID = A.DIVISION_ID
    WHERE  1 = 1
    AND   PROGRAM_ID  = 'DMF0049'
    AND   SHEET_NAME  = 'MDF Reports'
    AND   COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'RTF_SYS_RP') --[C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
    AND   INSTR(A.DIVISION_ID, p_division_id) > 0
    ORDER BY SORT_ORDER_NO;
  ELSE
    OPEN O_RC1 FOR
    SELECT
        COLUMN_NAME AS CODE
        , COLUMN_LABEL_NAME NAME
        , tei.EDIT_YN
    FROM SCM_MST_SHEET_MEASURE A
    INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
       ON tei.UNIT_ID = A.DIVISION_ID
    WHERE  1 = 1
    AND   PROGRAM_ID  = 'DMF0049'
    AND   SHEET_NAME  = 'MDF Reports'
    AND   COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD')
    AND   INSTR(A.DIVISION_ID, p_division_id) > 0
    ORDER BY SORT_ORDER_NO;
  END IF;

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

-- DMF0049_GET_SPREAD_TITLE → PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0049_GET_SPREAD_TITLE
(
	p_division_id			VARCHAR2,
	p_created_by			VARCHAR2,
	p_start_dt				VARCHAR2,
	p_end_dt				VARCHAR2

    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
)
/*
 * Program ID   : DMF0049_GET_SPREAD_TITLE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/04/02	hwi1993		DMF0049_GET_SPREAD_TITLE
 * 2022/05/12	hwi1993		GM JV
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

    p_program_id VARCHAR2(50 CHAR);
    p_sheet_name VARCHAR2(50 CHAR);
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
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_created_by' VALUE p_created_by,
            'p_start_dt' VALUE p_start_dt,
            'p_end_dt' VALUE p_end_dt
          );

	p_program_id := 'DMF0049';
	p_sheet_name := 'MDF Reports';

	OPEN O_RC1 FOR
	SELECT C.PROGRAM_ID
		, C.SHEET_NAME
		, C.COLUMN_NAME
		, C.COLUMN_LABEL_NAME
		--, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
		, CASE WHEN P_DIVISION_ID = '40' THEN TO_CHAR(C.SORT_ORDER_NO)
			   WHEN P_DIVISION_ID LIKE '81%' THEN C.ATTRIBUTE2
			   WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE3
			   END AS SORT_ORDER_NO
		, C.DATA_SORT_METHOD_CODE
		, C.SMALL_CLASS_LABEL_NAME
		, C.LARGE_CLASS_LABEL_NAME
		, '' AS DAY_CODE
		, C.FIXED_FLAG
		, CASE WHEN
				CASE WHEN P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
					 WHEN P_DIVISION_ID LIKE '81%' THEN C.ATTRIBUTE4
					 WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
					 END = 'Y'
					 THEN C.COLUMN_WIDTH
			ELSE 0
			END AS COLUMN_WIDTH
		, C.CELL_CONTROL_OBJECT_TYPE_CODE
		, C.CELL_COMBO_DATA_TYPE
		, TO_CHAR(C.DATA_SCALE_NUMBER) DATA_SCALE_NUMBER
		, TO_CHAR(C.DATA_MAX_LENGTH) DATA_MAX_LENGTH
		, C.HORIZONTAL_ALIGN_CODE
		, C.UPPERCASE_APPLY_FLAG
		, CASE  WHEN P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
				WHEN P_DIVISION_ID LIKE '81%' THEN C.ATTRIBUTE4
				WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
				END AS VISIBLE_FLAG
		, C.DEFAULT_FLAG
		, C.USER_SELECTABLE_FLAG
		, C.VALID_YN
		, C.DIVISION_ID
		, p_division_id ATTRIBUTE1		-- COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
		, CASE WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE C.ATTRIBUTE1 END AS ATTRIBUTE2
		, '' as ATTRIBUTE3
		, '' as ATTRIBUTE4
		, '' as ATTRIBUTE5
		, tei.EDIT_YN
	FROM   SCM_MST_SHEET_COLUMNS C
	INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
	   ON tei.UNIT_ID = C.DIVISION_ID
	WHERE  1 = 1
		AND    C.PROGRAM_ID  = p_program_id
		AND    C.SHEET_NAME  = p_sheet_name
		AND    C.VALID_YN     = 'Y'
		AND	   C.DIVISION_ID LIKE '%'  ||  P_DIVISION_ID  ||  '%'
	UNION ALL

	SELECT
		p_program_id PROGRAM_ID
		, p_sheet_name SHEET_NAME
		, MA.COLUMN_NAME
		, MA.COLUMN_LABEL_NAME
		, MA.SORT_ORDER_NO
		, ''         AS DATA_SORT_METHOD_CODE
		, MA.SMALL_CLASS_LABEL_NAME
		, MA.LARGE_CLASS_LABEL_NAME
		, MA.DAY_CODE
		, ''         AS FIXED_FLAG
		, 120 COLUMN_WIDTH
		, MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		, ''         AS CELL_COMBO_DATA_TYPE
		--, '2'         AS DATA_SCALE_NUMBER
		, '3'         AS DATA_SCALE_NUMBER -- 20181029
		, '2'         AS DATA_MAX_LENGTH
		, 'R'        AS HORIZONTAL_ALIGN_CODE
		, ''        AS UPPERCASE_APPLY_FLAG
		, 'Y'        AS VISIBLE_FLAG
		, ''         AS DEFAULT_FLAG
		, ''         AS USER_SELECTABLE_FLAG
		, ''         AS VALID_YN
		, ''			AS DIVISION_ID
		, '' AS ATTRIBUTE1
		, '' AS ATTRIBUTE2
		, '' AS ATTRIBUTE3
		, '' AS ATTRIBUTE4
		, '' AS ATTRIBUTE5
		, '' AS EDIT_YN
	FROM  (
		SELECT
			DISTINCT
			'M_'  ||  BASIS_YYYYMM								AS COLUMN_NAME
			, MONTH_NAME COLUMN_LABEL_NAME
			, MONTH_NAME SMALL_CLASS_LABEL_NAME
			, MONTH_NAME LARGE_CLASS_LABEL_NAME
			, ''														AS DAY_CODE
			, TO_CHAR(BASIS_YYYYMM) SORT_ORDER_NO
			, 'FPNumber'											AS CELL_CONTROL_OBJECT_TYPE_CODE
		FROM SCM_SYS_CALENDAR_M
		WHERE  BASIS_YYYYMMDD >= p_start_dt
			AND BASIS_YYYYMMDD <= p_end_dt

	) MA

	ORDER BY SORT_ORDER_NO;

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
