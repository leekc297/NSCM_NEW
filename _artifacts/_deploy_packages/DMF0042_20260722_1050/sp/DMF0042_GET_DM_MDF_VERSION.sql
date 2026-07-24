CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_GET_DM_MDF_VERSION" 
(
    p_division_id              VARCHAR2,
	p_version_description      VARCHAR2,
	p_version_type			    VARCHAR2,
	p_from_yyyymmdd            VARCHAR2,
	p_to_yyyymmdd              VARCHAR2,
	p_created_by				VARCHAR2

    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0042_GET_DM_MDF_VERSION                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/06/10  JYE			Business Plan > Cut Off 팝업 조회 */
/* 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리                                                                                                 */
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
            'p_version_description' VALUE p_version_description,
            'p_version_type' VALUE p_version_type,
            'p_from_yyyymmdd' VALUE p_from_yyyymmdd,
            'p_to_yyyymmdd' VALUE p_to_yyyymmdd,
            'p_created_by' VALUE p_created_by
          );

 OPEN O_RC1 FOR
 SELECT
		DIVISION_ID
      ,VERSION_NO
      ,VERSION_DESCRIPTION
      ,VERSION_TYPE
      ,YYYYMMDD
      ,VER_CRE_SEQ
      ,CREATED_BY
      ,CREATION_DATE
      ,LAST_UPDATED_BY
      ,LAST_UPDATE_DATE
      ,tei.EDIT_YN
  FROM DM_MST_VERSION
 INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
    ON tei.UNIT_ID = DM_MST_VERSION.DIVISION_ID
  WHERE (YYYYMMDD >= p_from_yyyymmdd and YYYYMMDD <= p_to_yyyymmdd)
		AND CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE DIVISION_ID
			END IN (
					Select * from TABLE(fn_string_split(p_division_id,',')) P Where
					(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.token
	               )
		AND VERSION_TYPE like p_version_type  ||  '%'
		AND VERSION_DESCRIPTION like p_version_description  ||  '%'
		AND NVL(ATTRIBUTE1, NULL) <> 'MOVE'

  ORDER BY DIVISION_ID, VERSION_NO DESC;


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
