CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0049_GET_MEASURE" 
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
 * 2020/03/30	HWI1993		Initial Release -- dmf0044 에서 복사해서 생성
 * 2020/05/04	HWI1993		DIVISION_ID 를 WHERE 절에 추가
 * 2020/06/10	HWI1993		40이 아닌 경우 USD 추가
 * 2021/01/28	P.C.I		[C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
   2022.04.25	HWI1993		GM JV 작업
   2026.03.14	김준규		[PJ20264226] NextSCM Pilot 설계 및 개발
   2026.06.05	NextSCM Migration	[PJ202650304] EDIT_YN 권한조인을 콤마분리 IN 조인으로 보정(다중값 DIVISION_ID 행 탈락 수정, MSSQL 결과셋 동등 복원)
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
       ON tei.UNIT_ID IN (
            SELECT TRIM(REGEXP_SUBSTR(A.DIVISION_ID, '[^,]+', 1, LEVEL))
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(A.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
          )
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
       ON tei.UNIT_ID IN (
            SELECT TRIM(REGEXP_SUBSTR(A.DIVISION_ID, '[^,]+', 1, LEVEL))
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(A.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
          )
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
