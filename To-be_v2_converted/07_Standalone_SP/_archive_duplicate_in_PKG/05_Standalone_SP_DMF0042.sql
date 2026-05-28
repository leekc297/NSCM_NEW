-- ============================================================================
-- ARCHIVED: 다음 SP들은 PKG_DMF0042 에 이미 등록되어 있어 standalone에서 제거됨
--          PKG 호출 권장: SCM_MGR.PKG_DMF0042.P_{SP_NAME}
-- ============================================================================


-- DMF0042_GET_DM_MDF_VERSION → PKG_DMF0042.P_DMF0042_GET_DM_MDF_VERSION에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_GET_DM_MDF_VERSION
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

-- DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION → PKG_DMF0042.P_DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION
(
				p_division_id                VARCHAR2,   -- 부서코드
				p_yyyyMM_from                VARCHAR2,    -- 조회(데이터)시작구간
				p_yyyyMM_to                  VARCHAR2,    -- 조회(데이터)끝구간
				p_version_type               VARCHAR2    -- 버전유형
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION
 * Description  : Business Plan ('DM_PLN_BP_FCST' TABLE SELECT)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/11/08  chano0612   [C20221025-000029] Business Plan Current버전 특정 컷오프 버전으로 덮어쓰기 기능 구현 요청의 건
 * 2026/03/15  김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

--DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION('40', '20220501', '20231101', 'BP_M');
--DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION('40', '20211101', '20211231', 'BP_M');

/*
 * ========================================
 * [변환검증] 2026-03-08 20:46:04
 * 파일: dbo.DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:1  END:2  차이:-1
 * ----------------------------------------
 * BEGIN 위치:  L23
 * END;  위치:  L49, L59
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */

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
            'p_yyyyMM_from' VALUE p_yyyyMM_from
          );

 OPEN O_RC1 FOR
 SELECT
  	   A.DIVISION_ID
      ,A.VERSION_NO
      ,A.VERSION_DESCRIPTION
      ,A.VERSION_TYPE
      ,A.YYYYMMDD
      ,A.VER_CRE_SEQ
      ,A.CREATED_BY
      ,A.CREATION_DATE
      ,A.LAST_UPDATED_BY
      ,A.LAST_UPDATE_DATE
      ,tei.EDIT_YN
  FROM DM_MST_VERSION A
 INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
    ON tei.UNIT_ID = A.DIVISION_ID
  WHERE A.DIVISION_ID = p_division_id
		AND A.VERSION_NO IN (SELECT VERSION_NO FROM DM_PLN_BP_FCST_C
		WHERE DIVISION_ID = p_division_id AND CUTOFF_TYPE LIKE p_version_type  ||  '%' AND YYYYMM BETWEEN p_yyyyMM_from AND p_yyyyMM_to GROUP BY VERSION_NO )
		AND NVL(A.ATTRIBUTE1, CHR(0)) <> 'MOVE'
  ORDER BY A.DIVISION_ID, A.VERSION_NO DESC, A.CREATION_DATE DESC;

DBMS_OUTPUT.PUT_LINE(p_division_id  ||  ' _ '  ||  p_version_type  ||  ' _ '  ||  p_yyyyMM_from || ' _ '  ||  p_yyyyMM_to);

  --SELECT * FROM INFORMATION_SCHEMA.COLUMNS
  --WHERE TABLE_NAME = 'DM_PLN_BP_FCST_C'
  --SELECT * FROM INFORMATION_SCHEMA.COLUMNS
  --WHERE TABLE_NAME = 'DM_MST_VERSION'
  --SELECT * FROM DM_MST_VERSION WHERE CREATED_BY = 'CHANO0612'

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

-- DMF0042_GET_EXCHANGE_PRICE → PKG_DMF0042.P_DMF0042_GET_EXCHANGE_PRICE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_GET_EXCHANGE_PRICE
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

-- DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP → PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP
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

-- DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA → PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA
(
    p_division_id              VARCHAR2,
	p_from_yyyymmdd            VARCHAR2,
	p_to_yyyymmdd             VARCHAR2,
	p_created_by              VARCHAR2,
	p_cate						  VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA                                      */
/* Description : Procedure 작성 가이드                                                               */
/* Usage       : Procedure 작성 시 참조하세요!                                                       */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2019/04/10    JYE			Business Plan 추가                                                   */
/* 2022/10/25	 rosia27		[C20221024-000510]DM UI 소스 정리 요청								*/
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
			,'D'  ||  YYYYMMDD AS YYYYMMDD
			,EXCHANGE_PRICE
			, tei.EDIT_YN
		FROM DM_BP_EXCHANGE_RATE
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = DIVISION_ID
		WHERE
		(YYYYMMDD >= p_from_yyyymmdd and YYYYMMDD <= p_to_yyyymmdd)
		AND CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   				ELSE DIVISION_ID
				END IN (
						SELECT * FROM TABLE(fn_string_split(p_division_id,',')) P WHERE
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.token
						);
	ELSE
		OPEN O_RC1 FOR
		SELECT
			DIVISION_ID
			,CURRENCY
			,UNIT_CURRENCY
			,'D'  ||  YYYYMMDD AS YYYYMMDD
			,EXCHANGE_PRICE
			, tei.EDIT_YN
		FROM DM_MST_EXCHANGE_RATE
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = DIVISION_ID
		WHERE
		(YYYYMMDD >= p_from_yyyymmdd and YYYYMMDD <= p_to_yyyymmdd)
		AND CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   				ELSE DIVISION_ID
				END IN (
						SELECT * FROM TABLE(fn_string_split(p_division_id,',')) P WHERE
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.token
						);
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

-- DMF0042_GET_SPREAD_TITLE → PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_GET_SPREAD_TITLE
(
    p_start_yyyymmdd	VARCHAR2,
    p_end_yyyymmdd		VARCHAR2,
	p_created_by			VARCHAR2,
	p_division_id			VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0042_GET_SPREAD_TITLE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/09	JYE			DMF0042_GET_SPREAD_TITLE
 * 2020/04/07	P.C.I   	PJ20200138 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Division 추가
 * 2020/08/06	hwi1993		item_use 가 안나와서 세팅 변경함
 * 2020/10/15	hwi1993		C20201008-000332 bp 컬럼 정렬순서
 * 2022/04/11	rosia27		과제PJ20216891RGM_JV
 * 2026/03/15	김준규		[PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 07:40:14
 * 파일: dbo.DMF0042_GET_SPREAD_TITLE.sql
 * ----------------------------------------
 * ⚠ IF: IF:1  END IF:0  차이:+1
 * ----------------------------------------
 * IF 위치:     L50
 * END IF 위치: 
 * BEGIN 위치:  L29
 * END;  위치:  L411
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_user_col_cnt INTEGER;
    v_program_id VARCHAR2(4000 CHAR);
    v_sheet_name VARCHAR2(4000 CHAR);
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
            'p_end_yyyymmdd' VALUE p_end_yyyymmdd,
            'p_created_by' VALUE p_created_by,
            'p_division_id' VALUE p_division_id
          );

	v_program_id := 'DMF0042';
	v_sheet_name := 'Biz Plan';
	v_user_col_cnt := 0;

	SELECT COUNT(*)
  INTO v_user_col_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_ID    = p_created_by;

	IF v_user_col_cnt > 0 THEN
		OPEN O_RC1 FOR
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, CASE WHEN P_DIVISION_ID LIKE '81%'
							THEN (CASE WHEN C.ATTRIBUTE4 = 'Y' THEN REPLACE(C.COLUMN_LABEL_NAME,'*','')  ||  '*'
									   ELSE REPLACE(C.COLUMN_LABEL_NAME,'*','')
								   END)
					   WHEN P_DIVISION_ID = '82'
							THEN (CASE WHEN C.ATTRIBUTE5 = 'Y' THEN REPLACE(C.COLUMN_LABEL_NAME,'*','')  ||  '*'
									   ELSE REPLACE(C.COLUMN_LABEL_NAME,'*','')
								   END)
					   ELSE C.COLUMN_LABEL_NAME END		 AS COLUMN_LABEL_NAME --PJ20200138 Division별 필수 컬럼 기준 적용
				--, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
				, CASE WHEN REGEXP_LIKE(U.SORT_ORDER_NO, '^\d+$') THEN TO_CHAR(U.SORT_ORDER_NO)
						WHEN P_DIVISION_ID = '40' THEN TO_CHAR(C.SORT_ORDER_NO)
					   WHEN P_DIVISION_ID LIKE '81%' THEN C.ATTRIBUTE2
					   WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE3
					   END AS SORT_ORDER_NO --PJ20200138 Division별 정렬 기준 적용
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, TO_CHAR(C.COLUMN_WIDTH) COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, TO_CHAR(C.DATA_SCALE_NUMBER) DATA_SCALE_NUMBER
				, TO_CHAR(C.DATA_MAX_LENGTH) DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
				, p_division_id ATTRIBUTE1		-- PJ20200138 COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
				, CASE WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE '' END AS ATTRIBUTE2
				, '' as ATTRIBUTE3
				, C.ATTRIBUTE4
				, C.ATTRIBUTE5
				, tei.EDIT_YN
		FROM   SCM_MST_TITLESET_USER U
				, SCM_MST_SHEET_COLUMNS C
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = C.DIVISION_ID
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = v_program_id
		AND    U.SHEET_NAME  = v_sheet_name
		AND    U.USER_ID     = p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
		UNION ALL
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, CASE WHEN P_DIVISION_ID LIKE '81%'
							THEN (CASE WHEN C.ATTRIBUTE4 = 'Y' THEN REPLACE(C.COLUMN_LABEL_NAME,'*','')  ||  '*'
									   ELSE REPLACE(C.COLUMN_LABEL_NAME,'*','')
								   END)
					   WHEN P_DIVISION_ID = '82'
							THEN (CASE WHEN C.ATTRIBUTE5 = 'Y' THEN REPLACE(C.COLUMN_LABEL_NAME,'*','')  ||  '*'
									   ELSE REPLACE(C.COLUMN_LABEL_NAME,'*','')
								   END)
					   ELSE C.COLUMN_LABEL_NAME END		 AS COLUMN_LABEL_NAME --PJ20200138 Division별 필수 컬럼 기준 적용
				--, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
				, CASE WHEN P_DIVISION_ID = '40' THEN TO_CHAR(C.SORT_ORDER_NO)
					   WHEN P_DIVISION_ID LIKE '81%' THEN C.ATTRIBUTE2
					   WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE3
					   END AS SORT_ORDER_NO -- PJ20200138 Division별 정렬 기준 적용
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, TO_CHAR(C.COLUMN_WIDTH) COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, TO_CHAR(C.DATA_SCALE_NUMBER) DATA_SCALE_NUMBER
				, TO_CHAR(C.DATA_MAX_LENGTH) DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
				, p_division_id ATTRIBUTE1		-- PJ20200138 COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
				, C.ATTRIBUTE2
				, C.ATTRIBUTE3
				, C.ATTRIBUTE4
				, C.ATTRIBUTE5
				, '' AS EDIT_YN
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = ''
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

		UNION ALL

		SELECT v_program_id   AS PROGRAM_ID
				, v_sheet_name SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, CAST(NULL AS VARCHAR2(1))         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, CAST(NULL AS VARCHAR2(1)) AS DAY_CODE
				, CAST(NULL AS VARCHAR2(1))         AS FIXED_FLAG
				, TO_CHAR(50) COLUMN_WIDTH
				, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				, CAST(NULL AS VARCHAR2(1))         AS CELL_COMBO_DATA_TYPE
				, '3'        AS DATA_SCALE_NUMBER
				, CAST(NULL AS VARCHAR2(1))         AS DATA_MAX_LENGTH
				, 'R'        AS HORIZONTAL_ALIGN_CODE
				, 'Y'        AS UPPERCASE_APPLY_FLAG
				, 'Y'        AS VISIBLE_FLAG
				, ''         AS DEFAULT_FLAG
				, ''         AS USER_SELECTABLE_FLAG
				, ''         AS VALID_YN
				, ''		 AS DIVISION_ID
				, '' AS ATTRIBUTE1 -- PJ20200138
				, '' AS ATTRIBUTE2
				, '' AS ATTRIBUTE3
				, '' AS ATTRIBUTE4
				, '' AS ATTRIBUTE5
				, '' AS EDIT_YN
		FROM  (
			SELECT * FROM (
				-- Monthly
				SELECT
						'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME COLUMN_LABEL_NAME
						, 'Q'  ||  TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q'))) SMALL_CLASS_LABEL_NAME
						, A.CALENDAR_YYYY LARGE_CLASS_LABEL_NAME
						, BASIS_YYYYMM  ||  '01' AS SORT_ORDER_NO
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
				GROUP BY
						CALENDAR_YYYY
						, A.BASIS_YYYYMM
						, A.MONTH_NAME
				UNION ALL
				-- Quarterly
				SELECT DISTINCT
					'Q_'  ||  CALENDAR_YYYY  ||  '_'  ||  TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q'))) COLUMN_NAME
					, 'Q'  ||  TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q'))) COLUMN_LABEL_NAME
					, 'Q'  ||  TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q'))) SMALL_CLASS_LABEL_NAME
					, CALENDAR_YYYY LARGE_CLASS_LABEL_NAME
					, CASE
						WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q')) = 1 THEN CALENDAR_YYYY  ||  '0100'
						WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q')) = 2 THEN CALENDAR_YYYY  ||  '0400'
						WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q')) = 3 THEN CALENDAR_YYYY  ||  '0700'
						ELSE CALENDAR_YYYY  ||  '1000' END AS SORT_ORDER_NO
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd

				UNION ALL
				-- Yearly
				SELECT DISTINCT
					'Y_'  ||  CALENDAR_YYYY AS COLUMN_NAME
					, CALENDAR_YYYY COLUMN_LABEL_NAME
					, CALENDAR_YYYY SMALL_CLASS_LABEL_NAME
					, CALENDAR_YYYY LARGE_CLASS_LABEL_NAME
					, CALENDAR_YYYY  ||  '0000' AS SORT_ORDER_NO
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
			) MA
		) T
		ORDER BY SORT_ORDER_NO;

	ELSE
		OPEN O_RC1 FOR
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, CASE WHEN P_DIVISION_ID LIKE '81%'
							THEN (CASE WHEN C.ATTRIBUTE4 = 'Y' THEN REPLACE(C.COLUMN_LABEL_NAME,'*','')  ||  '*'
									   ELSE REPLACE(C.COLUMN_LABEL_NAME,'*','')
								   END)
					   WHEN P_DIVISION_ID = '82'
							THEN (CASE WHEN C.ATTRIBUTE5 = 'Y' THEN REPLACE(C.COLUMN_LABEL_NAME,'*','')  ||  '*'
									   ELSE REPLACE(C.COLUMN_LABEL_NAME,'*','')
								   END)
					   ELSE C.COLUMN_LABEL_NAME END		 AS COLUMN_LABEL_NAME --PJ20200138 Division별 필수 컬럼 기준 적용
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
				, TO_CHAR(C.COLUMN_WIDTH) COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, TO_CHAR(C.DATA_SCALE_NUMBER) DATA_SCALE_NUMBER
				, TO_CHAR(C.DATA_MAX_LENGTH) DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
				, p_division_id ATTRIBUTE1		-- PJ20200138 COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
				, CASE WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE '' END AS ATTRIBUTE2
				, '' as ATTRIBUTE3
				, C.ATTRIBUTE4
				, C.ATTRIBUTE5
				, tei.EDIT_YN
		FROM   SCM_MST_SHEET_COLUMNS C
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = C.DIVISION_ID
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

		UNION ALL

		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, CASE WHEN P_DIVISION_ID LIKE '81%'
							THEN (CASE WHEN C.ATTRIBUTE4 = 'Y' THEN REPLACE(C.COLUMN_LABEL_NAME,'*','')  ||  '*'
									   ELSE REPLACE(C.COLUMN_LABEL_NAME,'*','')
								   END)
					   WHEN P_DIVISION_ID = '82'
							THEN (CASE WHEN C.ATTRIBUTE5 = 'Y' THEN REPLACE(C.COLUMN_LABEL_NAME,'*','')  ||  '*'
									   ELSE REPLACE(C.COLUMN_LABEL_NAME,'*','')
								   END)
					   ELSE C.COLUMN_LABEL_NAME END		 AS COLUMN_LABEL_NAME --PJ20200138 Division별 필수 컬럼 기준 적용
				--, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
				, CASE WHEN P_DIVISION_ID = '40' THEN TO_CHAR(C.SORT_ORDER_NO)
					   WHEN P_DIVISION_ID LIKE '81%' THEN C.ATTRIBUTE2
					   WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE3
					   END AS SORT_ORDER_NO -- PJ20200138 Division별 정렬 기준 적용
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, TO_CHAR(C.COLUMN_WIDTH) COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, TO_CHAR(C.DATA_SCALE_NUMBER) DATA_SCALE_NUMBER
				, TO_CHAR(C.DATA_MAX_LENGTH) DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
				, p_division_id ATTRIBUTE1		-- PJ20200138 COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
				, CASE WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE C.ATTRIBUTE1 END AS ATTRIBUTE2
				, C.ATTRIBUTE3
				, C.ATTRIBUTE4
				, C.ATTRIBUTE5
				, '' AS EDIT_YN
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = ''
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

		UNION ALL

		SELECT v_program_id  AS PROGRAM_ID
				, v_sheet_name SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, CAST(NULL AS VARCHAR2(1))         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, CAST(NULL AS VARCHAR2(1)) AS DAY_CODE
				, CAST(NULL AS VARCHAR2(1))         AS FIXED_FLAG
				, TO_CHAR(50) COLUMN_WIDTH
				, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				, CAST(NULL AS VARCHAR2(1))         AS CELL_COMBO_DATA_TYPE
				, '3'         AS DATA_SCALE_NUMBER
				, CAST(NULL AS VARCHAR2(1))         AS DATA_MAX_LENGTH
				, 'R'        AS HORIZONTAL_ALIGN_CODE
				, 'Y'        AS UPPERCASE_APPLY_FLAG
				, 'Y'        AS VISIBLE_FLAG
				, ''         AS DEFAULT_FLAG
				, ''         AS USER_SELECTABLE_FLAG
				, ''         AS VALID_YN
				, ''		 AS DIVISION_ID
				, '' AS ATTRIBUTE1 -- PJ20200138
				, '' AS ATTRIBUTE2
				, '' AS ATTRIBUTE3
				, '' AS ATTRIBUTE4
				, '' AS ATTRIBUTE5
				, '' AS EDIT_YN
		FROM  (
			SELECT * FROM (
				-- Monthly
				SELECT
						'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME COLUMN_LABEL_NAME
						, 'Q'  ||  TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q'))) SMALL_CLASS_LABEL_NAME
						, A.CALENDAR_YYYY LARGE_CLASS_LABEL_NAME
						, BASIS_YYYYMM  ||  '01' AS SORT_ORDER_NO
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
				GROUP BY
						CALENDAR_YYYY
						, A.BASIS_YYYYMM
						, A.MONTH_NAME
				UNION ALL
				-- Quarterly
				SELECT DISTINCT
					'Q_'  ||  CALENDAR_YYYY  ||  '_'  ||  TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q'))) COLUMN_NAME
					, 'Q'  ||  TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q'))) COLUMN_LABEL_NAME
					, 'Q'  ||  TO_CHAR(TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q'))) SMALL_CLASS_LABEL_NAME
					, CALENDAR_YYYY LARGE_CLASS_LABEL_NAME
					, CASE
						WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q')) = 1 THEN CALENDAR_YYYY  ||  '0100'
						WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q')) = 2 THEN CALENDAR_YYYY  ||  '0400'
						WHEN TO_NUMBER(TO_CHAR(TO_DATE(A.BASIS_YYYYMM  ||  '01', 'YYYYMMDD'), 'Q')) = 3 THEN CALENDAR_YYYY  ||  '0700'
						ELSE CALENDAR_YYYY  ||  '1000' END AS SORT_ORDER_NO
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd

				UNION ALL
				-- Yearly
				SELECT DISTINCT
					'Y_'  ||  CALENDAR_YYYY AS COLUMN_NAME
					, CALENDAR_YYYY COLUMN_LABEL_NAME
					, CALENDAR_YYYY SMALL_CLASS_LABEL_NAME
					, CALENDAR_YYYY LARGE_CLASS_LABEL_NAME
					, CALENDAR_YYYY  ||  '0000' AS SORT_ORDER_NO
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
			) MA
		) T
		ORDER BY SORT_ORDER_NO   ;

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

-- DMF0042_SAVE_DM_BP_EXCHANGE_RATE → PKG_DMF0042.P_DMF0042_SAVE_DM_BP_EXCHANGE_RATE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_SAVE_DM_BP_EXCHANGE_RATE
(
    p_active_flag            VARCHAR2,
	p_division_id            VARCHAR2,
    p_YYYYMMDD               VARCHAR2,
    p_CURRENCY               VARCHAR2,
    p_UNIT_CURRENCY          VARCHAR2,
    p_EXCHANGE_PRICE         VARCHAR2,
    p_CREATED_BY             VARCHAR2,
    p_LAST_UPDATED_BY        VARCHAR2
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0042_SAVE_DM_BP_EXCHANGE_RATE
 * Description  : Business Plan DM_BP_EXCHANGE_RATE TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190410 KHSONG Initial Release PJ20189106 전지본부 GSCM(DM) 고도화 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026/03/15     김준규		[PJ20264226] NextSCM Pilot 설계 및 개발
 *
 *
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 17:03:31
 * 파일: DMF0042_SAVE_DM_BP_EXCHANGE_RATE.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:2  END:3  차이:-1
 * ----------------------------------------
 * IF 위치:     L123, L192, L313, L329
 * END IF 위치: L190, L196, L338, L340
 * BEGIN 위치:  L56, L201
 * END;  위치:  L214, L277, L342
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * LOOP 위치:     L111
 * END LOOP 위치: L197
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_recv_active_flag VARCHAR2(4000 CHAR);
    v_active_flag VARCHAR2(4000 CHAR);
    v_division_id VARCHAR2(4000 CHAR);
    v_YYYYMMDD VARCHAR2(4000 CHAR);
    v_CURRENCY VARCHAR2(4000 CHAR);
    v_UNIT_CURRENCY VARCHAR2(4000 CHAR);
    v_EXCHANGE_PRICE VARCHAR2(4000 CHAR);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_merge_count INTEGER := 0;
    v_index_active_flag INTEGER;
    v_index_division_id INTEGER;
    v_index_YYYYMMDD INTEGER;
    v_index_CURRENCY INTEGER;
    v_index_UNIT_CURRENCY INTEGER;
    v_index_EXCHANGE_PRICE INTEGER;
    v_index_CREATED_BY INTEGER;
    v_index_LAST_UPDATED_BY INTEGER;
    v_in_para_data VARCHAR2(4000);
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_active_flag' VALUE p_active_flag,
            'p_division_id' VALUE p_division_id,
            'p_YYYYMMDD' VALUE p_YYYYMMDD,
            'p_CURRENCY' VALUE p_CURRENCY,
            'p_UNIT_CURRENCY' VALUE p_UNIT_CURRENCY,
            'p_EXCHANGE_PRICE' VALUE p_EXCHANGE_PRICE,
            'p_CREATED_BY' VALUE p_CREATED_BY,
            'p_LAST_UPDATED_BY' VALUE p_LAST_UPDATED_BY
          );

	-- 스플릿관련 변수
	v_recv_active_flag := NULL;
	v_recv_active_flag := p_active_flag;

    v_active_flag := NULL;
    v_division_id := NULL;
    v_YYYYMMDD := NULL;
    v_CURRENCY := NULL;
    v_UNIT_CURRENCY := NULL;
    v_EXCHANGE_PRICE := NULL;
    v_CREATED_BY := NULL;
    v_LAST_UPDATED_BY := NULL;

	v_delimiter := '^'; -- 데이터 구분자

	v_active_flag := RTRIM(p_active_flag     )  ||  '^';
	v_division_id := RTRIM(p_division_id     )  ||  '^';
	v_YYYYMMDD := RTRIM(p_YYYYMMDD        )  ||  '^';
	v_CURRENCY := RTRIM(p_CURRENCY        )  ||  '^';
	v_UNIT_CURRENCY := RTRIM(p_UNIT_CURRENCY   )  ||  '^';
	v_EXCHANGE_PRICE := RTRIM(p_EXCHANGE_PRICE  )  ||  '^';
	v_CREATED_BY := RTRIM(p_CREATED_BY      )  ||  '^';
	v_LAST_UPDATED_BY := RTRIM(p_LAST_UPDATED_BY )  ||  '^';

	-- LOG 용 변수 설정
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDBE_RESULTS';

		-- 시작 LOG  (START)
		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
		v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)
		-- 트랜잭션 (START)
	-- -----------------------------------------------------------------------------------------
		-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
	-- -----------------------------------------------------------------------------------------
--###############################################  GT_SDBE_RESULTS 테이블에 split후 insert (START)
WHILE LENGTH(v_DIVISION_ID) > 0 LOOP

    v_index_active_flag := INSTR(v_active_flag, '^');
	v_index_division_id := INSTR(v_division_id, '^');
	v_index_YYYYMMDD := INSTR(v_YYYYMMDD, '^');
	v_index_CURRENCY := INSTR(v_CURRENCY, '^');
	v_index_UNIT_CURRENCY := INSTR(v_UNIT_CURRENCY, '^');
	v_index_EXCHANGE_PRICE := INSTR(v_EXCHANGE_PRICE, '^');
	v_index_CREATED_BY := INSTR(v_CREATED_BY, '^');
	v_index_LAST_UPDATED_BY := INSTR(v_LAST_UPDATED_BY, '^');

	--확인  select v_index_DIVISION_ID as 'v_index_DIVISION_ID';
    IF v_index_DIVISION_ID > 0 THEN
			v_active_flag := SUBSTR(v_active_flag, 1, v_index_active_flag - 1);
			v_active_flag := SUBSTR(v_active_flag, LENGTH(v_active_flag  ||  '^') + 1);

			v_DIVISION_ID := SUBSTR(v_DIVISION_ID, 1, v_index_DIVISION_ID - 1);
			v_DIVISION_ID := SUBSTR(v_DIVISION_ID, LENGTH(v_DIVISION_ID  ||  '^') + 1);

			v_YYYYMMDD := SUBSTR(v_YYYYMMDD, 1, v_index_YYYYMMDD - 1);
			v_YYYYMMDD := SUBSTR(v_YYYYMMDD, LENGTH(v_YYYYMMDD  ||  '^') + 1);

			v_CURRENCY := SUBSTR(v_CURRENCY, 1, v_index_CURRENCY - 1);
			v_CURRENCY := SUBSTR(v_CURRENCY, LENGTH(v_CURRENCY  ||  '^') + 1);

			v_UNIT_CURRENCY := SUBSTR(v_UNIT_CURRENCY, 1, v_index_UNIT_CURRENCY - 1);
			v_UNIT_CURRENCY := SUBSTR(v_UNIT_CURRENCY, LENGTH(v_UNIT_CURRENCY  ||  '^') + 1);

			v_EXCHANGE_PRICE := SUBSTR(v_EXCHANGE_PRICE, 1, v_index_EXCHANGE_PRICE - 1);
			v_EXCHANGE_PRICE := SUBSTR(v_EXCHANGE_PRICE, LENGTH(v_EXCHANGE_PRICE || '^') + 1);

			v_CREATED_BY := SUBSTR(v_CREATED_BY, 1, v_index_CREATED_BY - 1);
			v_CREATED_BY := SUBSTR(v_CREATED_BY, LENGTH(v_CREATED_BY  ||  '^') + 1);

			v_LAST_UPDATED_BY := SUBSTR(v_LAST_UPDATED_BY, 1, v_index_LAST_UPDATED_BY - 1);
			v_LAST_UPDATED_BY := SUBSTR(v_LAST_UPDATED_BY, LENGTH(v_LAST_UPDATED_BY  ||  '^') + 1);

			INSERT INTO GT_SDBE_RESULTS (
			                         active_flag
									,division_id
									,YYYYMMDD
									,CURRENCY
									,UNIT_CURRENCY
									,EXCHANGE_PRICE
									,CREATED_BY
									,LAST_UPDATED_BY
			) VALUES (
			                         v_active_flag
									,v_division_id
									,v_YYYYMMDD
									,v_CURRENCY
									,v_UNIT_CURRENCY
									,v_EXCHANGE_PRICE
									,v_CREATED_BY
									,v_LAST_UPDATED_BY
			);
    ELSE
			v_DIVISION_ID := p_DIVISION_ID;

			INSERT INTO GT_SDBE_RESULTS (
			                         active_flag
									,division_id
									,YYYYMMDD
									,CURRENCY
									,UNIT_CURRENCY
									,EXCHANGE_PRICE
									,CREATED_BY
									,LAST_UPDATED_BY
			) VALUES (
			                         v_active_flag
									,v_division_id
									,v_YYYYMMDD
									,v_CURRENCY
									,v_UNIT_CURRENCY
									,v_EXCHANGE_PRICE
									,v_CREATED_BY
									,v_LAST_UPDATED_BY
			);
		END IF;
			-- Division_id Null Validation
			SELECT COUNT(1) INTO v_max_loop_cnt FROM SCM_MST_DIVISION  WHERE 1=1
									  AND DIVISION_ID = v_DIVISION_ID;
			IF v_max_loop_cnt = 0 THEN
					v_log_type := 'INVALID';
					GOTO ERR_RTN;
				END IF;
END LOOP;

	--###############################################   GT_SDBE_RESULTS 테이블에 split후 insert (END)
--===================================================================================== DELETE FROM start
BEGIN
		   --  select * from GT_SDBE_RESULTS
		   DELETE
           FROM DM_BP_EXCHANGE_RATE
           WHERE exists(
                    SELECT DIVISION_ID
					  FROM GT_SDBE_RESULTS
					 where active_flag      = 'D'
                       and DM_BP_EXCHANGE_RATE.DIVISION_ID        =   DIVISION_ID
                       AND DM_BP_EXCHANGE_RATE.YYYYMMDD           =   YYYYMMDD
                       AND DM_BP_EXCHANGE_RATE.CURRENCY           =   CURRENCY
                       AND DM_BP_EXCHANGE_RATE.UNIT_CURRENCY      =   UNIT_CURRENCY
				  );
END;
--===================================================================================== DELETE FROM end
--===================================================================================== update, INSERT INTO start

					MERGE INTO DM_BP_EXCHANGE_RATE A
					USING (
							SELECT
								     division_id
								    ,YYYYMMDD
								    ,CURRENCY
								    ,UNIT_CURRENCY
								    ,max(EXCHANGE_PRICE) EXCHANGE_PRICE
									,max(CREATED_BY) CREATED_BY
									,max(LAST_UPDATED_BY) LAST_UPDATED_BY
                             FROM  GT_SDBE_RESULTS  WHERE active_flag <> 'D'   -- DELETE값이 아닌경우만
                          group by   division_id
								    ,YYYYMMDD
								    ,CURRENCY
								    ,UNIT_CURRENCY
						  ) B
					ON(
                                A.division_id        =   B.division_id
                            AND A.YYYYMMDD           =   B.YYYYMMDD
                            AND A.CURRENCY           =   B.CURRENCY
                            AND A.UNIT_CURRENCY      =   B.UNIT_CURRENCY
					  )
					WHEN MATCHED THEN
						 UPDATE SET
 									 EXCHANGE_PRICE      =  b.EXCHANGE_PRICE
									,CREATED_BY          =  b.CREATED_BY
									,CREATION_DATE       =  SYSTIMESTAMP	--,CREATION_DATE       =  v_CREATION_DATE
									,LAST_UPDATED_BY     =  b.LAST_UPDATED_BY
									,LAST_UPDATE_DATE    =  SYSTIMESTAMP

					WHEN NOT MATCHED THEN

					     INSERT
								  ( division_id
								   ,YYYYMMDD
								   ,CURRENCY
								   ,UNIT_CURRENCY
								   ,EXCHANGE_PRICE
								   ,CREATED_BY
								   ,CREATION_DATE
								   ,LAST_UPDATED_BY
								   ,LAST_UPDATE_DATE
								)
						 VALUES (
									b.division_id
								   ,b.YYYYMMDD
								   ,b.CURRENCY
								   ,b.UNIT_CURRENCY
								   ,b.EXCHANGE_PRICE
								   ,b.CREATED_BY
								   ,SYSTIMESTAMP
								   ,b.LAST_UPDATED_BY
								   ,SYSTIMESTAMP
								);

--
--===================================================================================== update, INSERT INTO end
     -- IF 0 > 0
  	-- 트랜잭션 (COMMIT)
        COMMIT;

	-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------

<<ERR_RTN>>
	-- 수행결과 성공여부 DISPLAY
     IF v_log_message IS NULL THEN
	  SELECT 'success'
	  INTO v_description FROM DUAL;

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
    d_event_date := SYSTIMESTAMP;

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );

	END IF;

	IF v_log_type = 'INVALID' THEN
						v_log_message := '########## END of procedure ##########';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
			SELECT 'Division 값이 존재하지 않습니다.'
			INTO v_description FROM DUAL;
		END IF;

	-- -----------------------------------------------------------
    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
	-- -----------------------------------------------------------
	  --[C20200909-000203] LOG 표준화 적용
	  -- 트랜잭션 (END)
	        -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := SUBSTR(SQLERRM, 1, 1000);
      v_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
      d_event_date := SYSTIMESTAMP;

	  v_log_message := '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		--[C20200909-000203] LOG 표준화 적용
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data  => v_in_para_data,
        p_sql_err_code  => SQLCODE,
        p_sql_err_msg   => SQLERRM,
        p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

	-- -----------------------------------------------------------
    -- END CATCH
	-- -----------------------------------------------------------
    RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || v_in_para_data
    );
END;
/

-- DMF0042_SAVE_DM_PLN_BP_FCST → PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_SAVE_DM_PLN_BP_FCST
(
    -- Add the parameters for the stored procedure here
      p_active_flag       VARCHAR2
  , p_DIVISION_ID       VARCHAR2
  , p_PROJECT_CODE        VARCHAR2
  , p_PROJECT_NAME        VARCHAR2
  , p_SCM_SITE_ID       VARCHAR2
  , p_PLANT_SITE_ID       VARCHAR2
  , p_ITEM_ID         VARCHAR2
  --, p_DOM_EXP         VARCHAR2
  , p_FCST_TYPE         VARCHAR2
  , p_INCOTERMS         VARCHAR2 -- PJ20200138 Incoterms 삭제
  -- -----------------------------------------------------------------------------------------------
  -- PJ20200138 item_use, unit_energy 추가 (START)
  , p_ITEM_USE          VARCHAR2
  , p_UNIT_ENERGY       VARCHAR2
  -- PJ20200138 item_use, unit_energy 추가 (END)
  -- -----------------------------------------------------------------------------------------------
  , p_MEASURE         VARCHAR2
  , p_YYYYMM            VARCHAR2
  , p_QTY           VARCHAR2
  , p_CURRENCY          VARCHAR2
  -- -----------------------------------------------------------------------------------------------
  -- 20190830 파라미터추가 (START)
  , p_DEPT_ID         VARCHAR2
  , p_END_CUSTOMER        VARCHAR2
  , p_BIZ_TYPE          VARCHAR2
  , p_CELL_PROD_SITE        VARCHAR2
    --, p_CELL_PER_PACK            VARCHAR2
    --, p_CELL_PER_MODULE          VARCHAR2
    --, p_MODULE_PER_PACK          VARCHAR2
    -- 20190830 파라미터추가 (END)
  -- -----------------------------------------------------------------------------------------------
  , p_CREATED_BY          VARCHAR2
  , p_LAST_UPDATED_BY     VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
    , O_RC3  OUT  SYS_REFCURSOR
    , O_RC4  OUT  SYS_REFCURSOR
    , O_RC5  OUT  SYS_REFCURSOR
    , O_RC6  OUT  SYS_REFCURSOR
    , O_RC7  OUT  SYS_REFCURSOR
    , O_RC8  OUT  SYS_REFCURSOR
    , O_RC9  OUT  SYS_REFCURSOR
    , O_RC10  OUT  SYS_REFCURSOR
)
/*===============================================================================================================================
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST
 * Description  : Business Plan ('DM_PLN_BP_FCST' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===============================================================================================================================
 *   Date       In Charge      Description
 *===============================================================================================================================
 * 2019-04-11 KHSONG      Initial Release PJ20189106 전지본부 GSCM(DM) 고도화 프로젝트
 * 2019-04-26         DM_PLN_BP_FCST 테이블에 SalesAmt_KRW, SalesAmt_LOC, SalesAmt_USD 값을 계산하여 INSERT INTO 처리
 * 2019-08-30 JSYOUN      81, 82 사업부에 따른 변경
 * 2019-09-16 KHSONG      ADDED COLUMN
 * 2020-01-06 KHSONG      수정
 * 2020-04-08 P.C.I     PJ20200138 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020-06-10 hwi1993     대량데이터 저장시 오류 수정 ( 대량관련 오류는 없고, loc 메저가 저장되지 않는 현상 수정함 )
 * 2020-07-31 hwi1993     NUMBER CONVERT 오류 수정
 * 2020-09-04 hwi1993     [c20200722-000060] biz plan active YN
 * 2021-07-23 hwi1993     incoterms 추가 등 ( 중장기계획 과제 관련 )
 * 2021-08-06 hwi1993     MKT FCST 메저 추가
 * 2022-06-21 rosia27     [C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2024-08-01 JSSBAE      [E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청
 * 2025-07-15 JSSBAE      [E20250522-001188]_ Business Plan UI 데이터 저장 시 Trim 처리
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 ===============================================================================================================================*/
AS

    n_active_flag VARCHAR2(4000 CHAR);
    v_active_flag VARCHAR2(4000 CHAR);
    v_DIVISION_ID VARCHAR2(4000 CHAR);
    v_PROJECT_CODE VARCHAR2(4000 CHAR);
    v_PROJECT_NAME VARCHAR2(4000 CHAR);
    v_SCM_SITE_ID VARCHAR2(4000 CHAR);
    v_PLANT_SITE_ID VARCHAR2(4000 CHAR);
    v_ITEM_ID VARCHAR2(4000 CHAR);
    v_FCST_TYPE VARCHAR2(4000 CHAR);
    v_INCOTERMS VARCHAR2(4000 CHAR);
    v_ITEM_USE VARCHAR2(4000 CHAR);
    v_UNIT_ENERGY VARCHAR2(4000 CHAR);
    v_MEASURE VARCHAR2(4000 CHAR);
    v_YYYYMM VARCHAR2(4000 CHAR);
    v_CURRENCY VARCHAR2(4000 CHAR);
    v_QTY VARCHAR2(4000 CHAR);
    v_DEPT_ID VARCHAR2(4000 CHAR);
    v_END_CUSTOMER VARCHAR2(4000 CHAR);
    v_BIZ_TYPE VARCHAR2(4000 CHAR);
    v_CELL_PROD_SITE VARCHAR2(4000 CHAR);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_del_count INTEGER := 0;
    n_insert_count INTEGER := 0;
    n_history_seq INTEGER;
    v_index_INCOTERMS INTEGER;
    v_index_active_flag INTEGER;
    v_index_DIVISION_ID INTEGER;
    v_index_PROJECT_CODE INTEGER;
    v_index_PROJECT_NAME INTEGER;
    v_index_SCM_SITE_ID INTEGER;
    v_index_PLANT_SITE_ID INTEGER;
    v_index_ITEM_ID INTEGER;
    v_index_FCST_TYPE INTEGER;
    v_index_ITEM_USE INTEGER;
    v_index_UNIT_ENERGY INTEGER;
    v_index_MEASURE INTEGER;
    v_index_YYYYMM INTEGER;
    v_index_CURRENCY INTEGER;
    v_index_QTY INTEGER;
    v_index_DEPT_ID INTEGER;
    v_index_END_CUSTOMER INTEGER;
    v_index_BIZ_TYPE INTEGER;
    v_index_CELL_PROD_SITE INTEGER;
    v_index_CREATED_BY INTEGER;
    v_index_LAST_UPDATED_BY INTEGER;
    v_cnt_1  INTEGER := 0;
    v_cnt_2  INTEGER := 0;
    v_cnt_3  INTEGER := 0;
    v_cnt_4  INTEGER := 0;
    v_cnt_5  INTEGER := 0;
    v_cnt_6  INTEGER := 0;
    v_in_para_data VARCHAR2(4000);
    -- 선언부에 추가
    v_rc1_sub SYS_REFCURSOR;
    v_rc2_sub SYS_REFCURSOR;    
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_active_flag' VALUE p_active_flag,
            'p_DIVISION_ID' VALUE p_DIVISION_ID,
            'p_PROJECT_CODE' VALUE p_PROJECT_CODE,
            'p_PROJECT_NAME' VALUE p_PROJECT_NAME,
            'p_SCM_SITE_ID' VALUE p_SCM_SITE_ID,
            'p_PLANT_SITE_ID' VALUE p_PLANT_SITE_ID,
            'p_ITEM_ID' VALUE p_ITEM_ID,
            'p_DOM_EXP' VALUE null,
            'p_FCST_TYPE' VALUE p_FCST_TYPE,
            'p_INCOTERMS' VALUE p_INCOTERMS
          );

  --======================================================
    -- 스플릿관련 변수
  --======================================================
  -- -----------------------------------------------------------------------------------------------
  -- PJ20200138 item_use, unit_energy 추가 (START)
  -- -----------------------------------------------------------------------------------------------
    -- 20190830 변수 추가 (START)
  --    v_CELL_PER_MODULE VARCHAR2(4000 CHAR);
  --    v_MODULE_PER_PACK VARCHAR2(4000 CHAR);
  -- 20190830 변수 추가 (END)
  -- -----------------------------------------------------------------------------------------------
    -- LOG 용 변수 설정
  --======================================================
    -- SEQUENCE
  --======================================================
    -- 마지막 데이터 처리를 위한 구분자 추가
  --======================================================
    n_active_flag := RTRIM(p_active_flag     )  ||  '^';
    v_DIVISION_ID := RTRIM(p_DIVISION_ID     )  ||  '^';
    v_PROJECT_CODE := RTRIM(p_PROJECT_CODE    )  ||  '^';
    v_PROJECT_NAME := RTRIM(p_PROJECT_NAME    )  ||  '^';
    v_SCM_SITE_ID := RTRIM(p_SCM_SITE_ID     )  ||  '^';
    v_PLANT_SITE_ID := RTRIM(p_PLANT_SITE_ID   )  ||  '^';
    v_ITEM_ID := RTRIM(p_ITEM_ID         )  ||  '^';
    --p_DOM_EXP := RTRIM(p_DOM_EXP         ) || '^';
    v_FCST_TYPE := RTRIM(p_FCST_TYPE       )  ||  '^';
    v_INCOTERMS := RTRIM(p_INCOTERMS       )  ||  '^'; -- PJ20200138 Incoterms 삭제
  -- -----------------------------------------------------------------------------------------------
  -- PJ20200138 item_use, unit_energy 추가 (START)
    v_ITEM_USE := RTRIM(p_ITEM_USE        )  ||  '^';
    v_UNIT_ENERGY := RTRIM(p_UNIT_ENERGY     )  ||  '^';
  -- PJ20200138 item_use, unit_energy 추가 (END)
  -- -----------------------------------------------------------------------------------------------
    v_MEASURE := RTRIM(p_MEASURE         )  ||  '^';
    v_YYYYMM := RTRIM(p_YYYYMM          )  ||  '^';
    v_CURRENCY := RTRIM(p_CURRENCY        )  ||  '^';
    v_QTY := RTRIM(p_QTY             )  ||  '^';
  -- -----------------------------------------------------------------------------------------------
    -- 20190830 변수 추가 (START)
    v_DEPT_ID := RTRIM(p_DEPT_ID         )  ||  '^';
    v_END_CUSTOMER := RTRIM(p_END_CUSTOMER    )  ||  '^';
    v_BIZ_TYPE := RTRIM(p_BIZ_TYPE        )  ||  '^';
  v_CELL_PROD_SITE := RTRIM(p_CELL_PROD_SITE  )  ||  '^';
    --p_CELL_PER_PACK := RTRIM(p_CELL_PER_PACK   ) || '^';
    --p_CELL_PER_MODULE := RTRIM(p_CELL_PER_MODULE ) || '^';
    --p_MODULE_PER_PACK := RTRIM(p_MODULE_PER_PACK ) || '^';
  -- 20190830 변수 추가 (END)
  -- -----------------------------------------------------------------------------------------------
    v_CREATED_BY := RTRIM(p_CREATED_BY      )  ||  '^';
    v_LAST_UPDATED_BY := RTRIM(p_LAST_UPDATED_BY )  ||  '^';

  --======================================================
    -- TEMP TABLE DROP
  --======================================================
    -- -----------------------------------------------------------------------------------------------
  -- [E20250522-001188]_속도 개선을 위해 해당 테이블의 원테이블로 조회하여 TEMP로 사용함 (START)
  -- [E20250522-001188]_속도 개선을 위해 해당 테이블의 원테이블로 조회하여 TEMP로 사용함 (END)
  -- -----------------------------------------------------------------------------------------------
  --======================================================
    -- TEMP TABLE CREATE
  --======================================================
  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPB2_BP_FCST_4';

  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPB2_DM_PLN_BP_FCST_X_4';

  --======================================================
  -- 시작 LOG  (START)
  --======================================================
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
    v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
  --======================================================
  -- 시작 LOG  (END)
  --======================================================
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A001-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
  --======================================================
  -- 트랜잭션 (START)
  --======================================================
      -- -----------------------------------------------------------------------------------------
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
    -- -----------------------------------------------------------------------------------------
      WHILE LENGTH(p_DIVISION_ID) > 0 LOOP
        DECLARE
    v_index_INCOTERMS_local       INTEGER;  -- PJ20200138 Incoterms 삭제
        BEGIN
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          --    v_index_CELL_PER_MODULE INTEGER;
          --    v_index_MODULE_PER_PACK INTEGER;
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_index_active_flag := INSTR(p_active_flag, '^');
          v_index_DIVISION_ID := INSTR(p_DIVISION_ID, '^');
          v_index_PROJECT_CODE := INSTR(p_PROJECT_CODE, '^');
          v_index_PROJECT_NAME := INSTR(p_PROJECT_NAME, '^');
          v_index_SCM_SITE_ID := INSTR(p_SCM_SITE_ID, '^');
          v_index_PLANT_SITE_ID := INSTR(p_PLANT_SITE_ID, '^');
          v_index_ITEM_ID := INSTR(p_ITEM_ID, '^');
          --v_index_DOM_EXP := INSTR(p_DOM_EXP, '^')
          v_index_FCST_TYPE := INSTR(p_FCST_TYPE, '^');
          v_index_INCOTERMS_local := INSTR(p_INCOTERMS, '^'); -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          v_index_ITEM_USE := INSTR(p_ITEM_USE, '^');
          v_index_UNIT_ENERGY := INSTR(p_UNIT_ENERGY, '^');
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_index_MEASURE := INSTR(p_MEASURE, '^');
          v_index_YYYYMM := INSTR(p_YYYYMM, '^');
          v_index_CURRENCY := INSTR(p_CURRENCY, '^');
          v_index_QTY := INSTR(p_QTY, '^');
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          v_index_DEPT_ID := INSTR(p_DEPT_ID, '^');
          v_index_END_CUSTOMER := INSTR(p_END_CUSTOMER, '^');
          v_index_BIZ_TYPE := INSTR(p_BIZ_TYPE, '^');
          v_index_CELL_PROD_SITE := INSTR(p_CELL_PROD_SITE, '^');
          --v_index_CELL_PER_PACK := INSTR(p_CELL_PER_PACK, '^')
          --v_index_CELL_PER_MODULE := INSTR(p_CELL_PER_MODULE, '^')
          --v_index_MODULE_PER_PACK := INSTR(p_MODULE_PER_PACK, '^')
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_index_CREATED_BY := INSTR(p_CREATED_BY, '^');
          v_index_LAST_UPDATED_BY := INSTR(p_LAST_UPDATED_BY, '^');
        v_index_INCOTERMS := v_index_INCOTERMS_local;
        END;
        IF v_index_DIVISION_ID > 0 THEN
          v_active_flag := SUBSTR(n_active_flag, 0, v_index_active_flag - 1);
          n_active_flag := SUBSTR(n_active_flag, v_index_active_flag + 1);

          v_DIVISION_ID := SUBSTR(v_DIVISION_ID, 0, v_index_DIVISION_ID - 1);
          v_DIVISION_ID := SUBSTR(v_DIVISION_ID, v_index_DIVISION_ID + 1);

          v_PROJECT_CODE := SUBSTR(v_PROJECT_CODE, 0, v_index_PROJECT_CODE - 1);
          v_PROJECT_CODE := SUBSTR(v_PROJECT_CODE, v_index_PROJECT_CODE + 1);

          v_PROJECT_NAME := SUBSTR(v_PROJECT_NAME, 0, v_index_PROJECT_NAME - 1);
          v_PROJECT_NAME := SUBSTR(v_PROJECT_NAME, v_index_PROJECT_NAME + 1);

          v_SCM_SITE_ID := SUBSTR(v_SCM_SITE_ID, 0, v_index_SCM_SITE_ID - 1);
          v_SCM_SITE_ID := SUBSTR(v_SCM_SITE_ID, v_index_SCM_SITE_ID + 1);

          v_PLANT_SITE_ID := SUBSTR(v_PLANT_SITE_ID, 0, v_index_PLANT_SITE_ID - 1);
          v_PLANT_SITE_ID := SUBSTR(v_PLANT_SITE_ID, v_index_PLANT_SITE_ID + 1);

          v_ITEM_ID := SUBSTR(v_ITEM_ID, 0, v_index_ITEM_ID - 1);
          v_ITEM_ID := SUBSTR(v_ITEM_ID, v_index_ITEM_ID + 1);

          --v_DOM_EXP := SUBSTR(p_DOM_EXP , 0, v_index_DOM_EXP )
          --p_DOM_EXP := SUBSTR(p_DOM_EXP , LENGTH(v_DOM_EXP  || '^') + 1, LENGTH(p_DOM_EXP ))
          v_FCST_TYPE := SUBSTR(v_FCST_TYPE , 0, v_index_FCST_TYPE - 1);
          v_FCST_TYPE := SUBSTR(v_FCST_TYPE , v_index_FCST_TYPE + 1);

          v_INCOTERMS := SUBSTR(v_INCOTERMS , 1, v_index_INCOTERMS - 1); -- PJ20200138 Incoterms 삭제
          v_INCOTERMS := SUBSTR(v_INCOTERMS , v_index_INCOTERMS + 1);
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          v_ITEM_USE := SUBSTR(v_ITEM_USE , 0, v_index_ITEM_USE - 1);
          v_ITEM_USE := SUBSTR(v_ITEM_USE , v_index_ITEM_USE + 1);

          v_UNIT_ENERGY := SUBSTR(v_UNIT_ENERGY , 0, v_index_UNIT_ENERGY - 1);
          v_UNIT_ENERGY := SUBSTR(v_UNIT_ENERGY , v_index_UNIT_ENERGY + 1);
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_MEASURE := SUBSTR(v_MEASURE , 0, v_index_MEASURE - 1);
          v_MEASURE := SUBSTR(v_MEASURE , v_index_MEASURE + 1);

          v_YYYYMM := SUBSTR(v_YYYYMM , 0, v_index_YYYYMM - 1);
          v_YYYYMM := SUBSTR(v_YYYYMM , v_index_YYYYMM + 1);

          v_CURRENCY := SUBSTR(v_CURRENCY , 0, v_index_CURRENCY - 1);
          v_CURRENCY := SUBSTR(v_CURRENCY , v_index_CURRENCY + 1);
          -- -----------------------------------------------------------------------------------------------
          -- 20180319 skh added (START)
          IF v_CURRENCY is null THEN
            v_CURRENCY := NULL;
          END IF;
          -- 20180319 skh added (END)
          -- -----------------------------------------------------------------------------------------------
          v_QTY := SUBSTR(v_QTY , 0, v_index_QTY - 1);
          v_QTY := SUBSTR(v_QTY , v_index_QTY + 1);
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          v_DEPT_ID := SUBSTR(v_DEPT_ID , 0, v_index_DEPT_ID - 1);
          v_DEPT_ID := SUBSTR(v_DEPT_ID , v_index_DEPT_ID + 1);

          v_END_CUSTOMER := SUBSTR(v_END_CUSTOMER , 0, v_index_END_CUSTOMER - 1);
          v_END_CUSTOMER := SUBSTR(v_END_CUSTOMER , v_index_END_CUSTOMER + 1);

          v_BIZ_TYPE := SUBSTR(v_BIZ_TYPE , 0, v_index_BIZ_TYPE - 1);
          v_BIZ_TYPE := SUBSTR(v_BIZ_TYPE , v_index_BIZ_TYPE + 1);

          v_CELL_PROD_SITE := SUBSTR(v_CELL_PROD_SITE  , 0, v_index_CELL_PROD_SITE - 1);
          v_CELL_PROD_SITE := SUBSTR(v_CELL_PROD_SITE  , v_index_CELL_PROD_SITE + 1);
          -- -----------------------------------------------------------------------------------------------
          --[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청 (START)
          -- 화면에서 코드를 넘기는 것으로 변경했으므로, 더이상 필요없는 작업이므로 주석처리해서 막음
          /*
          -- 룩업 Code 로 바꿔준다.
          SELECT NVL(SEGMENT1, NULL)
  INTO v_CELL_PROD_SITE
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE lookup_type = 'dm_cell_prod_site'
            AND ATTRIBUTE1 = v_CELL_PROD_SITE;
          */
          --[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청 (END)
          -- -----------------------------------------------------------------------------------------------
          /*v_CELL_PER_PACK := SUBSTR(p_CELL_PER , 0, v_index_CELL_PER_PACK )
          p_CELL_PER_PACK := SUBSTR(p_CELL_PER_PACK , LENGTH(v_CELL_PER_PACK  || '^') + 1, LENGTH(p_CELL_PER_PACK ));

          v_CELL_PER_MODULE := SUBSTR(p_CELL_PER_MODULE , 0, v_index_CELL_PER_MODULE );
          p_CELL_PER_MODULE := SUBSTR(p_CELL_PER_MODULE , LENGTH(v_CELL_PER_MODULE  || '^') + 1, LENGTH(p_CELL_PER_MODULE ));

          v_MODULE_PER_PACK := SUBSTR(p_MODULE_PER_PACK , 0, v_index_MODULE_PER_PACK );
          p_MODULE_PER_PACK := SUBSTR(p_MODULE_PER_PACK , LENGTH(v_MODULE_PER_PACK  || '^') + 1, LENGTH(p_MODULE_PER_PACK ))*/
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          v_CREATED_BY := SUBSTR(v_CREATED_BY , 0, v_index_CREATED_BY - 1);
          v_CREATED_BY := SUBSTR(v_CREATED_BY , v_index_CREATED_BY + 1);

          v_LAST_UPDATED_BY := SUBSTR(v_LAST_UPDATED_BY , 0, v_index_LAST_UPDATED_BY - 1);
          v_LAST_UPDATED_BY := SUBSTR(v_LAST_UPDATED_BY , v_index_LAST_UPDATED_BY + 1);

          -- -----------------------------------------------------------------------------------------------
          -- [E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리 (START)
          -- ITEM의 경우 중간의 공백이 없으므로 RTRM, LTRM으로 지워지지 않는 건들이 있고, 특수 문자가 안지워지는 건도 있어서 어떻게든 지우겠다는 의지
          v_active_flag := RTRIM(LTRIM(v_active_flag));
          v_DIVISION_ID := RTRIM(LTRIM(v_DIVISION_ID));
          v_PROJECT_CODE := RTRIM(LTRIM(v_PROJECT_CODE));
          v_PROJECT_NAME := RTRIM(LTRIM(v_PROJECT_NAME));
          v_SCM_SITE_ID := RTRIM(LTRIM(v_SCM_SITE_ID));
          v_PLANT_SITE_ID := RTRIM(LTRIM(v_PLANT_SITE_ID));
          --CHAR(13): Carriage return / CHAR(10): Line feed / CHAR(9): TAB
          v_ITEM_ID := REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(v_ITEM_ID)),CHR(13),''),CHR(10),''),CHR(9),''), ' ', '');
          v_FCST_TYPE := RTRIM(LTRIM(v_FCST_TYPE));
          v_INCOTERMS := RTRIM(LTRIM(v_INCOTERMS));
          v_ITEM_USE := RTRIM(LTRIM(v_ITEM_USE));
          v_UNIT_ENERGY := RTRIM(LTRIM(v_UNIT_ENERGY));
          v_MEASURE := RTRIM(LTRIM(v_MEASURE));
          v_YYYYMM := RTRIM(LTRIM(v_YYYYMM));
          v_CURRENCY := RTRIM(LTRIM(v_CURRENCY));
          v_QTY := RTRIM(LTRIM(v_QTY));
          v_DEPT_ID := RTRIM(LTRIM(v_DEPT_ID));
          v_END_CUSTOMER := RTRIM(LTRIM(v_END_CUSTOMER));
          v_BIZ_TYPE := RTRIM(LTRIM(v_BIZ_TYPE));
          v_CELL_PROD_SITE := RTRIM(LTRIM(v_CELL_PROD_SITE));
          v_CREATED_BY := RTRIM(LTRIM(v_CREATED_BY  ));
          v_LAST_UPDATED_BY := RTRIM(LTRIM(v_LAST_UPDATED_BY));
          -- [E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리 (END)
          -- -----------------------------------------------------------------------------------------------
          INSERT INTO GT_SDPB2_BP_FCST_4
          ( active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
          , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , ITEM_USE, UNIT_ENERGY
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , MEASURE, YYYYMM, CURRENCY, QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , DEPT_ID
          , END_CUSTOMER
          , BIZ_TYPE
          , CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , CREATED_BY, LAST_UPDATED_BY )
          VALUES
          ( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_PROJECT_NAME, v_SCM_SITE_ID, v_PLANT_SITE_ID ,v_ITEM_ID--,v_DOM_EXP
          , v_FCST_TYPE, v_INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , v_ITEM_USE, (CASE WHEN v_UNIT_ENERGY IS NULL THEN 0 ELSE TO_NUMBER(v_UNIT_ENERGY) END)
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , v_MEASURE, v_YYYYMM, v_CURRENCY, v_QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_DEPT_ID END
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_END_CUSTOMER END
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_BIZ_TYPE END
          , v_CELL_PROD_SITE --,v_CELL_PER_PACK--,v_CELL_PER_MODULE--,v_MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , v_CREATED_BY, v_LAST_UPDATED_BY );
        -- ----------------------------------------
        ELSE
        -- ----------------------------------------
        BEGIN
          NULL;

          INSERT INTO GT_SDPB2_BP_FCST_4
          ( active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
          , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , ITEM_USE, UNIT_ENERGY
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , MEASURE, YYYYMM, CURRENCY, QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , DEPT_ID
          , END_CUSTOMER
          , BIZ_TYPE
          , CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , CREATED_BY, LAST_UPDATED_BY )
          VALUES
          ( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_PROJECT_NAME, v_SCM_SITE_ID, v_PLANT_SITE_ID ,v_ITEM_ID--,v_DOM_EXP
          , v_FCST_TYPE, v_INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , v_ITEM_USE, (CASE WHEN v_UNIT_ENERGY IS NULL THEN 0 ELSE TO_NUMBER(v_UNIT_ENERGY) END)
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , v_MEASURE, v_YYYYMM, v_CURRENCY, v_QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_DEPT_ID END
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_END_CUSTOMER END
          , CASE WHEN v_DIVISION_ID = '40' THEN '' ELSE v_BIZ_TYPE END
          , v_CELL_PROD_SITE --,v_CELL_PER_PACK--,v_CELL_PER_MODULE--,v_MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , v_CREATED_BY, v_LAST_UPDATED_BY );
        END;

      END IF;

      END LOOP;

DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A002-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      -- -----------------------------------------------------------------------------------------------
      -- [E20250522-001188]_속도 개선을 위해 DM_MST_ITEM_SINGLE_V를 TEMP로 생성함 (START)
      BEGIN
        --> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
        /* TODO:GTT:GT_SDPB_DM_MST_ITEM_SINGLE_ORI-->GT_SDPB_DM_MST_ITEM_SINGLE_ORI */
        INSERT INTO GT_SDPB_DM_MST_ITEM_SINGLE_ORI
        SELECT *
        FROM SCM_MST_ITEM_SN
        WHERE DIVISION_ID = v_DIVISION_ID
        AND ACTIVE_FLAG = 'Y';

        --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
        /* TODO:GTT:GT_SDPB_DM_MST_ITEM_SINGLE_A_V-->GT_SDPB_DM_MST_ITEM_SINGLE_A_V */
        INSERT INTO GT_SDPB_DM_MST_ITEM_SINGLE_A_V
        SELECT T1.DIVISION_ID, T1.ITEM_ID
           , MAX(T1.ITEM_NAME) ITEM_NAME
           , MAX(T1.ITEM_CLASS) ITEM_CLASS
           , MAX(T1.ITEM_CLASS_NAME) ITEM_CLASS_NAME
           , MAX(T1.NICK_NAME) NICK_NAME
           , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                    WHEN T1.ITEM_TYPE = 'H' THEN 2
                    WHEN T1.ITEM_TYPE = 'Q' THEN 3
                 ELSE 4 END )
                        WHEN 1 THEN 'P'
                        WHEN 2 THEN 'H'
                        WHEN 3 THEN 'Q'
                        ELSE 'R' END  AS ITEM_TYPE
           , MAX(T1.MATERIAL_CLASS_NAME) MATERIAL_CLASS_NAME
           , MAX(T1.ITEM_UOM) ITEM_UOM
           , MAX(T1.SPEC) SPEC
           , MAX(T1.MDM_PROJECT_NAME) MDM_PROJECT_NAME
           , MAX(T1.MIN_CAPACITY) MIN_CAPACITY
           , MAX(T1.ACTIVE_FLAG) ACTIVE_FLAG
           , MAX(T1.ENERGE) ENERGE
           , MAX(T1.CELL_QUANTITY) CELL_QUANTITY
           , MAX(T1.SCP_EXTRA_SPEC) SCP_EXTRA_SPEC
        FROM GT_SDPB_DM_MST_ITEM_SINGLE_ORI T1
        WHERE 1=1
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

        --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
        /* TODO:GTT:GT_SDPB_DM_MST_ITEM_SINGLE_B_V-->GT_SDPB_DM_MST_ITEM_SINGLE_B_V */
        INSERT INTO GT_SDPB_DM_MST_ITEM_SINGLE_B_V
        SELECT DIVISION_ID
           , SUBSTR(ITEM_ID, 1, 12) ITEM_ID
           , MAX(FORECAST_INFO_BIZ_TYPE) FORECAST_INFO_BIZ_TYPE
           , MAX(FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
           , MAX(FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
           , MAX(FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT
           , MAX(FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
           , MAX(FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
           , MAX(CELL_TYPE) CELL_TYPE
        FROM GT_SDPB_DM_MST_ITEM_SINGLE_ORI T2
        GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

        --TEMP 테이블에 넣은 데이터를 JOIN 한다.
        /* TODO:GTT:GT_SDPB_DM_MST_ITEM_SINGLE_V-->GT_SDPB_DM_MST_ITEM_SINGLE_V */
        INSERT INTO GT_SDPB_DM_MST_ITEM_SINGLE_V
        SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
           , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
           , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
           , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
        FROM ( SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME
              , T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
              , T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
              , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
             FROM GT_SDPB_DM_MST_ITEM_SINGLE_A_V T1
             INNER JOIN GT_SDPB_DM_MST_ITEM_SINGLE_B_V T2   ON T1.DIVISION_ID = T2.DIVISION_ID AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
             WHERE 1=1 ) T2
        WHERE DIVISION_ID = p_division_id
        GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
             , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
             , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
             , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC;
      END;
      -- [E20250522-001188]_속도 개선을 위해 DM_MST_ITEM_SINGLE_V를 TEMP로 생성함 (END)
      -- -----------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A003-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      --INPUT된 active_flag='D' 인것 삭제수행 (START)
      --======================================================
      BEGIN
        SELECT COUNT(1)
  INTO n_del_count
        FROM GT_SDPB2_BP_FCST_4  WHERE ACTIVE_FLAG = 'D';

        DELETE
        FROM DM_PLN_BP_FCST
        WHERE ( SELECT COUNT(1) FROM GT_SDPB2_BP_FCST_4
            WHERE 1=1
            AND ACTIVE_FLAG  = 'D'
            AND DM_PLN_BP_FCST.DIVISION_ID    = DIVISION_ID
            AND DM_PLN_BP_FCST.PROJECT_CODE   = PROJECT_CODE
            --AND DM_PLN_BP_FCST.PROJECT_NAME = PROJECT_NAME
            AND DM_PLN_BP_FCST.SCM_SITE_ID      = SCM_SITE_ID
            AND DM_PLN_BP_FCST.PLANT_SITE_ID    = PLANT_SITE_ID
            AND DM_PLN_BP_FCST.ITEM_ID          = ITEM_ID
            AND DM_PLN_BP_FCST.CELL_PROD_SITE   = CELL_PROD_SITE
            AND DM_PLN_BP_FCST.FCST_TYPE    = FCST_TYPE
            AND DM_PLN_BP_FCST.INCOTERMS        = INCOTERMS -- PJ20200138 Incoterms 삭제
            -- -----------------------------------------------------------------------------------------------
            -- PJ20200138 item_use, unit_energy 추가 (START)
            AND DM_PLN_BP_FCST.ITEM_USE         = ITEM_USE
            AND DM_PLN_BP_FCST.UNIT_ENERGY      = UNIT_ENERGY
            -- PJ20200138 item_use, unit_energy 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            AND DM_PLN_BP_FCST.MEASURE          = MEASURE
            AND DM_PLN_BP_FCST.YYYYMM           = YYYYMM
            -- -----------------------------------------------------------------------------------------------
            -- 20190830 추가 (START)
            AND DM_PLN_BP_FCST.DEPT_ID          = DEPT_ID
            AND DM_PLN_BP_FCST.END_CUSTOMER     = END_CUSTOMER
            AND DM_PLN_BP_FCST.BIZ_TYPE         = BIZ_TYPE
            AND DM_PLN_BP_FCST.CURRENCY         = CURRENCY
            -- 20190830 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            ) > 0;

        -- -----------------------------------------------------------------------------------------------
        -- 삭제완료건 TEMP TABLE에서 제거
        -- -----------------------------------------------------------------------------------------------
        DELETE FROM GT_SDPB2_BP_FCST_4 WHERE ACTIVE_FLAG  = 'D';
      END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A004-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      --INPUT된 active_flag='D' 인것 삭제수행 (END)
      --======================================================
      --======================================================
      -- 2021.7.23 키 업데이트용으로 들어온 데이터 처리 (START)
      --======================================================
      BEGIN
        SELECT COUNT(1)
        INTO v_cnt_1
        FROM DM_PLN_BP_FCST A
        JOIN (  SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
        , CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
        FROM GT_SDPB2_BP_FCST_4
        WHERE MEASURE = 'Business_Plan'
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
        , CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
        ) B  ON A.DIVISION_ID   = B.DIVISION_ID
        AND A.PROJECT_CODE    = B.PROJECT_CODE
        AND A.SCM_SITE_ID   = B.SCM_SITE_ID
        AND A.ITEM_ID     = B.ITEM_ID
        AND A.DEPT_ID     = B.DEPT_ID
        AND A.END_CUSTOMER    = B.END_CUSTOMER
        AND A.BIZ_TYPE      = B.BIZ_TYPE
        AND A.CURRENCY      = B.CURRENCY
        AND A.ITEM_USE      = B.ITEM_USE
        AND A.UNIT_ENERGY   = B.UNIT_ENERGY
        AND A.CELL_PROD_SITE  = B.CELL_PROD_SITE
        WHERE A.FCST_TYPE IS NULL OR A.INCOTERMS IS NULL;
        IF v_cnt_1 > 0 THEN
          MERGE INTO DM_PLN_BP_FCST A
          USING (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
            , CURRENCY, ITEM_USE, UNIT_ENERGY, MAX(FCST_TYPE) FCST_TYPE--, MAX(DOM_EXP) DOM_EXP
            , MAX(INCOTERMS) INCOTERMS, CELL_PROD_SITE
            FROM GT_SDPB2_BP_FCST_4
            WHERE MEASURE = 'Business_Plan'
            GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
            , CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
          ) B
          ON (A.DIVISION_ID   = B.DIVISION_ID AND A.PROJECT_CODE    = B.PROJECT_CODE AND A.SCM_SITE_ID    = B.SCM_SITE_ID AND A.ITEM_ID     = B.ITEM_ID AND A.DEPT_ID     = B.DEPT_ID AND A.END_CUSTOMER    = B.END_CUSTOMER AND A.BIZ_TYPE     = B.BIZ_TYPE AND A.CURRENCY     = B.CURRENCY AND A.ITEM_USE     = B.ITEM_USE AND A.UNIT_ENERGY    = B.UNIT_ENERGY AND A.CELL_PROD_SITE  = B.CELL_PROD_SITE)
          WHEN MATCHED THEN
          UPDATE SET FCST_TYPE = B.FCST_TYPE
            --, DOM_EXP = B.DOM_EXP
            , INCOTERMS = B.INCOTERMS;
          GOTO END_PKUPDATE;
        END IF;
      END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A005-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      -- INPUT된 Business_Plan MEASURE INSERT (START)
      --======================================================
      -- INSERT INTO 전 중복값 삭제
      BEGIN
        DELETE FROM DM_PLN_BP_FCST A
        WHERE A.MEASURE IN ( 'Business_Plan', 'LOC', 'CAR_QTY', 'MKT_FCST' )
        AND EXISTS (SELECT 1 FROM GT_SDPB2_BP_FCST_4 B
        WHERE A.DIVISION_ID   = B.DIVISION_ID
         AND A.PROJECT_CODE     = B.PROJECT_CODE
         AND A.SCM_SITE_ID      = B.SCM_SITE_ID
         AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
         AND A.ITEM_ID          = B.ITEM_ID
         AND A.CELL_PROD_SITE   = B.CELL_PROD_SITE
         AND A.FCST_TYPE        = B.FCST_TYPE
         AND A.ITEM_USE         = B.ITEM_USE
         AND A.UNIT_ENERGY      = B.UNIT_ENERGY
         AND A.MEASURE          = B.MEASURE
         AND A.YYYYMM           = B.YYYYMM
         AND A.DEPT_ID          = B.DEPT_ID
         AND A.END_CUSTOMER     = B.END_CUSTOMER
         AND A.BIZ_TYPE         = B.BIZ_TYPE
         AND A.CURRENCY         = B.CURRENCY
         AND A.INCOTERMS        = B.INCOTERMS);
      END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A006-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      BEGIN
        INSERT INTO DM_PLN_BP_FCST
        ( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMM, CURRENCY
        , MEASURE, DOM_EXP, FCST_TYPE
        -- -----------------------------------------------------------------------------------------------
        -- PJ20200138 item_use, unit_energy 추가 (START)
        , ITEM_USE, UNIT_ENERGY
        -- PJ20200138 item_use, unit_energy 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        , CELL_PROD_SITE, INCOTERMS, QTY-- PJ20200138 Incoterms 삭제
        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        -- -----------------------------------------------------------------------------------------------
        -- 20190830 추가 (START)
        , DEPT_ID, END_CUSTOMER, BIZ_TYPE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
        -- 20190830 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        )
        SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMM, CURRENCY
           , MEASURE, '' AS DOM_EXP, FCST_TYPE
           -- -----------------------------------------------------------------------------------------------
           -- PJ20200138 item_use, unit_energy 추가 (START)
           , ITEM_USE, UNIT_ENERGY
           -- PJ20200138 item_use, unit_energy 추가 (END)
           -- -----------------------------------------------------------------------------------------------
           , CELL_PROD_SITE, INCOTERMS, QTY -- PJ20200138 Incoterms 삭제
           , CREATED_BY, SYSDATE, LAST_UPDATED_BY, SYSDATE
           -- -----------------------------------------------------------------------------------------------
           -- 20190830 추가 (START)
           , DEPT_ID, END_CUSTOMER, BIZ_TYPE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
           -- 20190830 추가 (END)
           -- -----------------------------------------------------------------------------------------------
        FROM GT_SDPB2_BP_FCST_4
        WHERE MEASURE IN ( 'Business_Plan', 'MKT_FCST', 'LOC' );

        -- -----------------------------------------------------------------------------------------------
        -- 20190830 81사업부 CAR_QTY 저장
        -- -----------------------------------------------------------------------------------------------
        INSERT INTO GT_SDPB2_BP_FCST_4
        ( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMM, CURRENCY
        , MEASURE, FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
        -- -----------------------------------------------------------------------------------------------
        -- PJ20200138 item_use, unit_energy 추가 (START)
        , ITEM_USE, UNIT_ENERGY
        -- PJ20200138 item_use, unit_energy 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        , CELL_PROD_SITE
        , QTY
        , CREATED_BY, LAST_UPDATED_BY
        -- -----------------------------------------------------------------------------------------------
        -- 20190830 추가 (START)
        , DEPT_ID, END_CUSTOMER, BIZ_TYPE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
        -- 20190830 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        )
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.PROJECT_NAME, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.YYYYMM, F.CURRENCY
            , 'CAR_QTY' AS MEASURE, FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
            -- -----------------------------------------------------------------------------------------------
            -- PJ20200138 item_use, unit_energy 추가 (START)
            , ITEM_USE, NVL(TO_NUMBER(UNIT_ENERGY),0)
            -- PJ20200138 item_use, unit_energy 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            , CELL_PROD_SITE
            /*,CASE WHEN BIZ_TYPE = 'CELL' THEN NVL(TO_NUMBER(QTY),0) / CASE WHEN TO_NUMBER(CELL_PER_PACK) = 0 THEN 1 END  -- 20190906 ZERO값 발생하는 오류로 CASE문 추가
              WHEN BIZ_TYPE = 'MODULE' THEN NVL(TO_NUMBER(QTY),0) / CASE WHEN TO_NUMBER(MODULE_PER_PACK) = 0 THEN 1 END  -- 20190906 ZERO값 발생하는 오류로 CASE문 추가
              WHEN BIZ_TYPE = 'PACK' THEN QTY
            END AS QTY         */
            , CASE  WHEN INSTR(I.ITEM_CLASS_NAME, 'Cell') > 0  AND NVL(SI.CELL_PER_CAR, 0) > 0   THEN NVL(TO_NUMBER(F.QTY),0) /CASE WHEN SI.CELL_PER_CAR = 0 THEN 1 ELSE SI.CELL_PER_CAR END
                WHEN INSTR(I.ITEM_CLASS_NAME, 'Module') > 0  AND NVL(SI.CELL_PER_CAR/SI.CELL_PER_MODULE, 0) > 0 THEN NVL(TO_NUMBER(F.QTY),0) /CASE WHEN SI.CELL_PER_CAR/SI.CELL_PER_MODULE = 0 THEN 1 ELSE SI.CELL_PER_CAR/SI.CELL_PER_MODULE END
                WHEN INSTR(I.ITEM_CLASS_NAME, 'Pack') > 0  THEN NVL(TO_NUMBER(F.QTY),0)
                ELSE 0
              END AS QTY
            , F.CREATED_BY, F.LAST_UPDATED_BY
            -- -----------------------------------------------------------------------------------------------
            -- 20190830 추가 (START)
            , DEPT_ID, END_CUSTOMER, BIZ_TYPE --,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
            -- 20190830 추가 (END)
            -- -----------------------------------------------------------------------------------------------
        FROM GT_SDPB2_BP_FCST_4 F
        -- -----------------------------------------------------------------------------------------------
        -- [E20250522-001188]_DM_MST_ITEM_SINGLE_V 대신 TEMP로 생성한 테이블을 사용 원소스 주석처리 (START)
        --LEFT JOIN DM_MST_ITEM_SINGLE_V I
        LEFT JOIN GT_SDPB_DM_MST_ITEM_SINGLE_V I
        -- [E20250522-001188]_DM_MST_ITEM_SINGLE_V 대신 TEMP로 생성한 테이블을 사용 원소스 주석처리 (END)
        -- -----------------------------------------------------------------------------------------------
             ON F.DIVISION_ID   = I.DIVISION_ID
            AND F.ITEM_ID     = I.ITEM_ID
        LEFT JOIN SCM_MST_SITE_ITEM SI
             ON F.DIVISION_ID   = SI.DIVISION_ID
            AND F.PROJECT_CODE  = SI.PROJECT_CODE
            AND F.SCM_SITE_ID   = SI.SCM_SITE_ID
            AND F.ITEM_ID     = SI.ITEM_ID
        WHERE MEASURE = 'Business_Plan'
        AND F.DIVISION_ID = '81'
        AND SI.VALID_YN = 'Y';
      END;
      --======================================================
      -- INPUT된 Business_Plan MEASURE INSERT (END)
      --======================================================
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A007-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      -- FUTURE PRICE 계산 Procedure 호출 (START)
      --======================================================
      -- TEMP TABLE 을 전달함 GT_SDPB2_BP_FCST_4
      BEGIN
        DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV('CALL', NULL, v_rc1_sub, v_rc2_sub);
      END;
      --======================================================
      -- FUTURE PRICE 계산 Procedure 호출 (END)
      --======================================================
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A008-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      --======================================================
      --GT_SDPB2_BP_FCST_4 테이블에 split후 INSERT (END)
      --======================================================
      BEGIN
        -- -----------------------------------------------------------------------------------------------
        -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (START)
        SELECT COUNT(1)
        INTO v_cnt_2
        FROM GT_SDPB2_BP_FCST_4  WHERE DIVISION_ID <> '40';
        IF v_cnt_2 > 0 THEN
          SELECT COUNT(1)
          INTO v_cnt_3
          FROM GT_SDPB2_BP_FCST_4
          WHERE ( SELECT COUNT(1) FROM SCM_MST_PROJECT
          WHERE PROJECT_CODE = PROJECT_CODE ) = 0
          AND PROJECT_CODE <> ''  --20180423 SKH validation 조건에서 제외시킴
          AND DIVISION_ID <> '40'; -- 20180614 KHSOMG 40 DIVISION 조건 추가
          IF v_cnt_3 > 0 THEN
            v_log_type := 'INVALID';
            SELECT '[' || PROJECT_CODE || ']' || ' Invalid Project Code !' INTO v_log_message FROM GT_SDPB2_BP_FCST_4
                          WHERE PROJECT_CODE NOT IN ( SELECT PROJECT_CODE FROM SCM_MST_PROJECT )
                           FETCH FIRST 1 ROWS ONLY;
            OPEN O_RC5 FOR
            SELECT v_log_message FROM DUAL;
            GOTO END_PROC;
          END IF;
        END IF;
        -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (END)
        -- -----------------------------------------------------------------------------------------------
        -- -----------------------------------------------------------------------------------------------
        -- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (START) [c20200722-000060]
        SELECT COUNT(1)
        INTO v_cnt_4
        FROM GT_SDPB2_BP_FCST_4  WHERE DIVISION_ID = '40';
        IF v_cnt_4 > 0 THEN
          SELECT COUNT(1)
          INTO v_cnt_5
          FROM GT_SDPB2_BP_FCST_4 A
          LEFT OUTER JOIN SCM_MST_SITE B
          ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VALID_YN = 'Y'
          WHERE B.DIVISION_ID IS NULL;
          IF v_cnt_5 > 0 THEN
            v_log_type := 'INVALID';
            SELECT '[' || A.SCM_SITE_ID || ']' || ' Invalid Sales Site !' INTO v_log_message
                          FROM GT_SDPB2_BP_FCST_4 A
                          LEFT OUTER JOIN SCM_MST_SITE B
                                 ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VALID_YN = 'Y'
                          WHERE B.DIVISION_ID IS NULL
                           FETCH FIRST 1 ROWS ONLY;
            OPEN O_RC6 FOR
            SELECT v_log_message FROM DUAL;
            GOTO END_PROC;
          END IF;

          SELECT COUNT(1)
          INTO v_cnt_6
          FROM GT_SDPB2_BP_FCST_4 A
          LEFT OUTER JOIN SCM_MST_SITE_ITEM B
          ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID AND B.VALID_YN = 'Y'
          WHERE B.DIVISION_ID IS NULL;
          IF v_cnt_6 > 0 THEN
            v_log_type := 'INVALID';
            SELECT '[' || RTRIM(A.SCM_SITE_ID)  ||  '/ '  ||  RTRIM(A.PROJECT_CODE)  ||  '/ '  ||  RTRIM(A.ITEM_ID) || ']' ||  ' Invalid Sales Site/Project Code/Item !' INTO v_log_message
                          FROM GT_SDPB2_BP_FCST_4 A
                          LEFT OUTER JOIN SCM_MST_SITE_ITEM B
                                 ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID AND B.VALID_YN = 'Y'
                          WHERE B.DIVISION_ID IS NULL
                           FETCH FIRST 1 ROWS ONLY;
            OPEN O_RC7 FOR
            SELECT v_log_message FROM DUAL;
            GOTO END_PROC;
          END IF;
        END IF;
        -- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (END) [c20200722-000060]
        -- -----------------------------------------------------------------------------------------------
        BEGIN
          --======================================================
          -- LOC INSERT (START)
          --======================================================
          INSERT INTO GT_SDPB2_BP_FCST_4
          SELECT active_flag, TMP.DIVISION_ID, TMP.PROJECT_CODE, TMP.PROJECT_NAME, TMP.SCM_SITE_ID, TMP.PLANT_SITE_ID, TMP.ITEM_ID--,TMP.DOM_EXP
             , TMP.FCST_TYPE, TMP.INCOTERMS -- PJ20200138 Incoterms 삭제
             -- -----------------------------------------------------------------------------------------------
             -- PJ20200138 item_use, unit_energy 추가 (START)
             , TMP.ITEM_USE, TMP.UNIT_ENERGY
             -- PJ20200138 item_use, unit_energy 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , 'SalesAmt_LOC' MEASURE, TMP.YYYYMM, TMP.CURRENCY, NVL(FCST.QTY * TMP.QTY,0)
             --( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
             --  AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
             --AS QTY
             --, ( SELECT CASE WHEN TMP.CURRENCY = 'KRW' THEN TMP.QTY
             --       ELSE CASE WHEN TMP.CURRENCY = 'USD' THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
             --                                     AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0)
             --          ELSE CASE WHEN TMP.CURRENCY NOT IN ('KRW','USD') THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
             --                                             AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
             --           END
             --          END
             --       END )
             -- -----------------------------------------------------------------------------------------------
             -- 20190830 추가 (START)
             , TMP.DEPT_ID, TMP.END_CUSTOMER, TMP.BIZ_TYPE, TMP.CELL_PROD_SITE
             -- 20190830 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , TMP.CREATED_BY, TMP.LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4 TMP
          INNER JOIN DM_PLN_BP_FCST FCST
              ON TMP.DIVISION_ID    = FCST.DIVISION_ID
               AND TMP.PROJECT_CODE   = FCST.PROJECT_CODE
               -- -----------------------------------------------------------------------------------------------
               -- 20200106 KHSONG 수정 (START)
               --AND TMP.PROJECT_NAME     = FCST.PROJECT_NAME  -- 주석처리
               AND TMP.SCM_SITE_ID    = FCST.SCM_SITE_ID  -- ADDED
               -- 20200106 KHSONG 수정 (END)
               -- -----------------------------------------------------------------------------------------------
               AND TMP.PLANT_SITE_ID  = FCST.PLANT_SITE_ID
               AND TMP.ITEM_ID      = FCST.ITEM_ID
               AND TMP.CELL_PROD_SITE = FCST.CELL_PROD_SITE
               AND TMP.FCST_TYPE    = FCST.FCST_TYPE
               AND TMP.INCOTERMS    = FCST.INCOTERMS -- PJ20200138 Incoterms 삭제
               AND TMP.YYYYMM     = FCST.YYYYMM
               AND TMP.CURRENCY     = FCST.CURRENCY
               AND FCST.MEASURE IN ( 'Business_Plan', 'MKT_FCST' )
               -- -----------------------------------------------------------------------------------------------
               -- 20190830 추가 (START)
               AND TMP.DEPT_ID            = FCST.DEPT_ID
               AND TMP.END_CUSTOMER       = FCST.END_CUSTOMER
               AND TMP.BIZ_TYPE           = FCST.BIZ_TYPE
               -- 20190830 추가 (END)
               -- -----------------------------------------------------------------------------------------------
               -- -----------------------------------------------------------------------------------------------
               -- PJ20200138 item_use, unit_energy 추가 (START)
               AND TMP.ITEM_USE           = FCST.ITEM_USE
               AND TMP.UNIT_ENERGY        = FCST.UNIT_ENERGY
               -- PJ20200138 item_use, unit_energy 추가 (END)
               -- -----------------------------------------------------------------------------------------------
          WHERE 1=1
          AND TMP.MEASURE = 'LOC';
          --======================================================
          -- LOC INSERT (END)
          --======================================================
          --======================================================
          -- KRW INSERT (START)
          --======================================================
          INSERT INTO GT_SDPB2_BP_FCST_4
          SELECT active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
             , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
             -- -----------------------------------------------------------------------------------------------
             -- PJ20200138 item_use, unit_energy 추가 (START)
             , ITEM_USE, UNIT_ENERGY
             -- PJ20200138 item_use, unit_energy 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , 'SalesAmt_KRW' AS MEASURE, YYYYMM, CURRENCY
             , NVL(( SELECT CASE WHEN TMP.CURRENCY = 'KRW' THEN TMP.QTY
                       ELSE CASE WHEN TMP.CURRENCY = 'USD' THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                                     AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0)
                        ELSE CASE WHEN TMP.CURRENCY NOT IN ('KRW', 'USD') THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                                              AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
                           END
                        END
                       END FROM DUAL),0)
             -- -----------------------------------------------------------------------------------------------
             -- 20190830 추가 (START)
             , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE
             -- 20190830 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , CREATED_BY, LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4 TMP
          WHERE TMP.MEASURE = 'SalesAmt_LOC';
          --======================================================
          -- KRW INSERT (END)
          --======================================================
          --======================================================
          -- USD INSERT (START)
          --======================================================
          -- 20190906
          INSERT INTO GT_SDPB2_BP_FCST_4
          SELECT active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
             , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
             -- -----------------------------------------------------------------------------------------------
             -- PJ20200138 item_use, unit_energy 추가 (START)
             , ITEM_USE, UNIT_ENERGY
             -- PJ20200138 item_use, unit_energy 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , 'SalesAmt_USD' AS MEASURE, YYYYMM, CURRENCY
             , NVL(( SELECT CASE WHEN TMP.CURRENCY = 'KRW' THEN NVL(TMP.QTY / ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                                    AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0)
                         ELSE CASE WHEN TMP.CURRENCY = 'USD' THEN TMP.QTY
                            ELSE CASE WHEN TMP.CURRENCY NOT IN ('KRW', 'USD') -- KRW산출후 / USD
                                THEN NVL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                            AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
                                            / ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE  WHERE DIVISION_ID = TMP.DIVISION_ID
                                              AND YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE)
                               END
                            END
                         END FROM DUAL),0)
             -- -----------------------------------------------------------------------------------------------
             -- 20190830 추가 (START)
             , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE
             -- 20190830 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , CREATED_BY, LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4 TMP
          WHERE TMP.MEASURE = 'SalesAmt_LOC';
        END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A008-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        BEGIN
          SELECT COUNT(1) INTO n_insert_count FROM GT_SDPB2_BP_FCST_4  WHERE MEASURE = 'SalesAmt_LOC';
        END;

        BEGIN
          INSERT INTO GT_SDPB2_DM_PLN_BP_FCST_X_4
          ( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
          , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
          -- -----------------------------------------------------------------------------------------------
          -- PJ20200138 item_use, unit_energy 추가 (START)
          , ITEM_USE, UNIT_ENERGY
          -- PJ20200138 item_use, unit_energy 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , MEASURE, YYYYMM, CURRENCY, QTY
          -- -----------------------------------------------------------------------------------------------
          -- 20190830 추가 (START)
          , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
          -- 20190830 추가 (END)
          -- -----------------------------------------------------------------------------------------------
          , CREATED_BY, LAST_UPDATED_BY )
          SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
             , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
             -- -----------------------------------------------------------------------------------------------
             -- PJ20200138 item_use, unit_energy 추가 (START)
             , ITEM_USE, UNIT_ENERGY
             -- PJ20200138 item_use, unit_energy 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , MEASURE, YYYYMM, CURRENCY, NVL(QTY,0)
             -- -----------------------------------------------------------------------------------------------
             -- 20190830 추가 (START)
             , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
             -- 20190830 추가 (END)
             -- -----------------------------------------------------------------------------------------------
             , CREATED_BY, LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4
          WHERE 1=1;

          -- ----------------------------------------------------------------
          /* [2018-03-19][CURSOR를 이용해 HISTORY TABLE ADD
            방법1 : PROCEDURE CALL
            방법2 : 바로입력
          */
          -- ----------------------------------------------------------------
          -- 커서를 이용해 DIVISION_ID 만큼 LOOP
          -- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- SAVE_DM_PLN_BP_FCST_CUR CURSOR FAST_FORWARD FOR
          -- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- SAVE_DM_PLN_BP_FCST_CUR CURSOR FAST_FORWARD FOR
          --OPEN O_RC9 FOR
          --SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
          --    , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
          --    -- -----------------------------------------------------------------------------------------------
          --    -- PJ20200138 item_use, unit_energy 추가 (START)
          --    , ITEM_USE, UNIT_ENERGY
          --    -- PJ20200138 item_use, unit_energy 추가 (END)
          --    -- -----------------------------------------------------------------------------------------------
          --    , MEASURE, YYYYMM, CURRENCY, QTY
          --    -- -----------------------------------------------------------------------------------------------
          --    -- 20190830 추가 (START)
          --    , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
          --    -- 20190830 추가 (END)
          --    -- -----------------------------------------------------------------------------------------------
          --    , CREATED_BY, LAST_UPDATED_BY
          --FROM GT_SDPB2_BP_FCST_4
          --WHERE 1=1;

          FOR cur_rec IN (SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
              , FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
              -- -----------------------------------------------------------------------------------------------
              -- PJ20200138 item_use, unit_energy 추가 (START)
              , ITEM_USE, UNIT_ENERGY
              -- PJ20200138 item_use, unit_energy 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              , MEASURE, YYYYMM, CURRENCY, QTY
              -- -----------------------------------------------------------------------------------------------
              -- 20190830 추가 (START)
              , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
              -- 20190830 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              , CREATED_BY, LAST_UPDATED_BY
          FROM GT_SDPB2_BP_FCST_4
          WHERE 1=1) LOOP
            v_DIVISION_ID := cur_rec.DIVISION_ID;
            v_PROJECT_CODE := cur_rec.PROJECT_CODE;
            v_PROJECT_NAME := cur_rec.PROJECT_NAME;
            v_SCM_SITE_ID := cur_rec.SCM_SITE_ID;
            v_PLANT_SITE_ID := cur_rec.PLANT_SITE_ID;
            v_ITEM_ID := cur_rec.ITEM_ID;
            v_FCST_TYPE := cur_rec.FCST_TYPE;
            v_INCOTERMS := cur_rec.INCOTERMS;
            v_ITEM_USE := cur_rec.ITEM_USE;
            v_UNIT_ENERGY := cur_rec.UNIT_ENERGY;
            v_MEASURE := cur_rec.MEASURE;
            v_YYYYMM := cur_rec.YYYYMM;
            v_CURRENCY := cur_rec.CURRENCY;
            v_QTY := cur_rec.QTY;
            v_DEPT_ID := cur_rec.DEPT_ID;
            v_END_CUSTOMER := cur_rec.END_CUSTOMER;
            v_BIZ_TYPE := cur_rec.BIZ_TYPE;
            v_CELL_PROD_SITE := cur_rec.CELL_PROD_SITE;
            v_CREATED_BY := cur_rec.CREATED_BY;
            v_LAST_UPDATED_BY := cur_rec.LAST_UPDATED_BY;
            SELECT SEQ1_DM_PLN_BP_FCST_H.NEXTVAL INTO n_history_seq FROM DUAL;
              --======================================================
              -- HISTORY INSERT (START)
              --======================================================
               INSERT INTO DM_PLN_BP_FCST_H
              ( HISTORY_SEQ, ACTIVE_FLAG, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
              -- -----------------------------------------------------------------------------------------------
              -- PJ20200138 item_use, unit_energy 추가 (START)
              , ITEM_USE, UNIT_ENERGY
              -- PJ20200138 item_use, unit_energy 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              , INCOTERMS, MEASURE, YYYYMM, CURRENCY, QTY -- PJ20200138 Incoterms 삭제
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
              -- -----------------------------------------------------------------------------------------------
              -- 20190830 추가 (START)
              , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
              -- 20190830 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              )
              VALUES
              ( n_history_seq, v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_PROJECT_NAME, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID, '', v_FCST_TYPE
              -- -----------------------------------------------------------------------------------------------
              -- PJ20200138 item_use, unit_energy 추가 (START)
              , v_ITEM_USE, v_UNIT_ENERGY
              -- PJ20200138 item_use, unit_energy 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              , v_INCOTERMS, v_MEASURE, v_YYYYMM, v_CURRENCY, NVL(v_QTY,0) -- PJ20200138 Incoterms 삭제
              , v_CREATED_BY, SYSDATE, v_LAST_UPDATED_BY, SYSDATE
              -- -----------------------------------------------------------------------------------------------
              -- 20190830 추가 (START)
              , v_DEPT_ID, v_END_CUSTOMER, v_BIZ_TYPE, v_CELL_PROD_SITE--,v_CELL_PER_PACK,v_CELL_PER_MODULE,v_MODULE_PER_PACK
              -- 20190830 추가 (END)
              -- -----------------------------------------------------------------------------------------------
              );
              --======================================================
              -- HISTORY INSERT (END)
              --======================================================
              --FETCH SAVE_DM_PLN_BP_FCST_CUR INTO v_DIVISION_ID, v_PROJECT_CODE, v_PROJECT_NAME, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID--,v_DOM_EXP
              --                     , v_FCST_TYPE, v_INCOTERMS -- PJ20200138 Incoterms 삭제
              --                     -- -----------------------------------------------------------------------------------------------
              --                     -- PJ20200138 item_use, unit_energy 추가 (START)
              --                     , v_ITEM_USE, v_UNIT_ENERGY
              --                     -- PJ20200138 item_use, unit_energy 추가 (END)
              --                     -- -----------------------------------------------------------------------------------------------
              --                     , v_MEASURE, v_YYYYMM, v_CURRENCY, v_QTY
              --                     -- -----------------------------------------------------------------------------------------------
              --                     -- 20190830 추가 (START)
              --                     , v_DEPT_ID, v_END_CUSTOMER, v_BIZ_TYPE, v_CELL_PROD_SITE--,v_CELL_PER_PACK--,v_CELL_PER_MODULE--,v_MODULE_PER_PACK
              --                     -- 20190830 추가 (END)
              --                     -- -----------------------------------------------------------------------------------------------
              --                     , v_CREATED_BY, v_LAST_UPDATED_BY
          END LOOP;

          --CLOSE SAVE_DM_PLN_BP_FCST_CUR
          --DEALLOCATE SAVE_DM_PLN_BP_FCST_CUR
        END;
        --======================================================
        -- INPUT된 Business_Plan MEASURE INSERT (END)
        --======================================================
      END;
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A009-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

      --======================================================
      -- DELETE (START)
      --======================================================

        DELETE
        FROM DM_PLN_BP_FCST
        WHERE ( SELECT COUNT(1) FROM GT_SDPB2_DM_PLN_BP_FCST_X_4
            WHERE 1=1
            AND DM_PLN_BP_FCST.DIVISION_ID    = DIVISION_ID
            AND DM_PLN_BP_FCST.PROJECT_CODE   = PROJECT_CODE
            --AND DM_PLN_BP_FCST.PROJECT_NAME = PROJECT_NAME
            AND DM_PLN_BP_FCST.SCM_SITE_ID    = SCM_SITE_ID
            AND DM_PLN_BP_FCST.PLANT_SITE_ID  = PLANT_SITE_ID
            AND DM_PLN_BP_FCST.ITEM_ID      = ITEM_ID
            AND DM_PLN_BP_FCST.CELL_PROD_SITE = CELL_PROD_SITE
            AND DM_PLN_BP_FCST.FCST_TYPE    = FCST_TYPE
            AND DM_PLN_BP_FCST.INCOTERMS    = INCOTERMS -- PJ20200138 Incoterms 삭제
            -- -----------------------------------------------------------------------------------------------
            -- PJ20200138 item_use, unit_energy 추가 (START)
            AND DM_PLN_BP_FCST.ITEM_USE     = ITEM_USE
            AND DM_PLN_BP_FCST.UNIT_ENERGY    = UNIT_ENERGY
            -- PJ20200138 item_use, unit_energy 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            AND DM_PLN_BP_FCST.MEASURE      = MEASURE
            AND DM_PLN_BP_FCST.YYYYMM     = YYYYMM
            -- -----------------------------------------------------------------------------------------------
            -- 20190830 추가 (START)
            AND DM_PLN_BP_FCST.DEPT_ID      = DEPT_ID
            AND DM_PLN_BP_FCST.END_CUSTOMER   = END_CUSTOMER
            AND DM_PLN_BP_FCST.BIZ_TYPE     = BIZ_TYPE
            -- 20190830 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            AND DM_PLN_BP_FCST.CURRENCY     = CURRENCY  -- 20190916 KHSONG ADDED
            ) > 0;
      --======================================================
      --======================================================
      -- DELETE (END)
      --======================================================
DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A010-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
      INSERT INTO DM_PLN_BP_FCST
      ( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP ,FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
      -- -----------------------------------------------------------------------------------------------
      -- PJ20200138 item_use, unit_energy 추가 (START)
      , ITEM_USE, UNIT_ENERGY
      -- PJ20200138 item_use, unit_energy 추가 (END)
      -- -----------------------------------------------------------------------------------------------
      , MEASURE, YYYYMM, CURRENCY, QTY
      -- -----------------------------------------------------------------------------------------------
      -- 20190830 추가 (START)
      , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
      -- 20190830 추가 (END)
      -- -----------------------------------------------------------------------------------------------
      , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
      SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, '' AS DOM_EXP, FCST_TYPE, INCOTERMS -- PJ20200138 Incoterms 삭제
         -- -----------------------------------------------------------------------------------------------
         -- PJ20200138 item_use, unit_energy 추가 (START)
         , ITEM_USE, UNIT_ENERGY
         -- PJ20200138 item_use, unit_energy 추가 (END)
         -- -----------------------------------------------------------------------------------------------
         , MEASURE ,YYYYMM, CURRENCY, QTY
         -- -----------------------------------------------------------------------------------------------
         -- 20190830 추가 (START)
         , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
         -- 20190830 추가 (END)
         -- -----------------------------------------------------------------------------------------------
         , CREATED_BY, SYSDATE, LAST_UPDATED_BY, SYSDATE
      FROM GT_SDPB2_DM_PLN_BP_FCST_X_4
      WHERE 1=1;

      -- PK UPDATE 를 위해서 들어온경우 UPDATE 처리 후 바로 빠짐
      <<END_PKUPDATE>>
      NULL;

      <<END_PROC>>
      NULL;

DBMS_OUTPUT.PUT_LINE(v_program_name  ||  ' : A011-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    --======================================================
    -- 트랜잭션 (COMMIT)
    --======================================================
        COMMIT;
    -- -----------------------------------------------------------------------------------------
        -- END TRY
  -- -----------------------------------------------------------------------------------------
  -- 수행결과 성공여부 DISPLAY
  IF v_log_type IS NULL OR v_log_type NOT IN ('ERROR','INVALID') THEN
  OPEN O_RC1 FOR
  SELECT 'success' FROM DUAL;

  --======================================================
    -- 종료 LOG (START)
  --======================================================
  v_log_type := 'END';
  v_log_message := '########## END of procedure ##########';
  v_description := 'delete_count= '  ||  TO_CHAR(n_del_count)  ||  ' / insert_count= '  ||  TO_CHAR(n_insert_count)  ;
  d_event_date := SYSTIMESTAMP;
  PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );

  END IF;

  EXCEPTION
      WHEN OTHERS THEN
  -- -----------------------------------------------------------------------------------------
    -- ROLLBACK
    --======================================================
    -- 트랜잭션 (END)
    --======================================================
        -- ERROR LOG VALUE SAVE
    v_log_type := 'ERROR';
    v_log_message := SUBSTR(SQLERRM, 1, 1000);
    v_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
    d_event_date := SYSTIMESTAMP;
    v_log_message := '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data  => v_in_para_data,
        p_sql_err_code  => SQLCODE,
        p_sql_err_msg   => SQLERRM,
        p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );
  -- -----------------------------------------------------------------------------------------
  -- END CATCH
  -- -----------------------------------------------------------------------------------------
    RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || v_in_para_data
    );
END;
/

-- DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV → PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV
(

  -- Add the parameters for the stored procedure here
   s_flag                   VARCHAR2,
   s_division_id            VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
)
/*
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV
 * Description  : Business Plan PRICE 계산 Procedure
 *                1. Procedure에서 저장시 : s_flag = 'CALL'
           (1) DMF0042_SAVE_DM_PLN_BP_FCST 프로시져에서 호출시 TEMP TABLE로 대상을 전달받음
                     (2) DM_PLN_BP_FCST 테이블에 생성할 FUTURE PRICE 금액을 생성하여 TEMP TABLE로 RETURN해줌
                  2. ui에서 Set Price 버튼을 클릭하여 전체 재계산 요청시 : s_flag <> 'CALL'
           (1) Division만 전달받아 전체 Item에 대하여 재계산수행함
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190429 KHSONG Initial Release PJ20189106 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190830 JSYOUN 81, 82 사업부에 따른 변경
 * 2020/04/09 P.C.I    PJ20200138 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/06/12 hwi1993  temp3 에 넣을 때 Price <> 0 조건 제거 ( 오류내역 : Loc 를 0으로 변경시, USD, KRW Price 가 변경안됨 )
 * 2020/08/25 hwi1993 [C20200820-000170] Business Plan. Set Price 버튼 클릭시 Amnt 메저들 업데이트( 현재는 Price 메저만 업데이트함 )
 * 2020/08/27 hwi1993 [C20200820-000170] Business Plan. 운영에서 실행시간이 너무 오래 걸려서 속도개선함.
 2020/09/09     P.C.I   [C20200909-000203] LOG 표준화 적용
 * 2021/07/23 hwi1993 incoterms 추가 등 ( 중장기계획 과제 관련 )
 * 2021/08/06 hwi1993 MKT FCST 메저 추가
 * 2022/06/21 rosia27 [C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 18:40:46
 * 파일: DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:4  END:5  차이:-1
 * ----------------------------------------
 * IF 위치:     L106, L167, L230, L325, L336, L347, L360, L379, L402, L421, L560
 * END IF 위치: L233, L334, L345, L355, L398, L400, L439, L440, L526, L564, L576
 * BEGIN 위치:  L76, L93, L128, L188
 * END;  위치:  L141, L205, L504, L524, L578
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * LOOP 위치:     L312
 * END LOOP 위치: L468
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_DIVISION_ID VARCHAR2(4000 CHAR);
    v_PROJECT_CODE VARCHAR2(4000 CHAR);
    v_PROJECT_NAME VARCHAR2(4000 CHAR);
    v_SCM_SITE_ID VARCHAR2(4000 CHAR);
    v_PLANT_SITE_ID VARCHAR2(4000 CHAR);
    v_ITEM_ID VARCHAR2(4000 CHAR);
    v_YYYYMM VARCHAR2(4000 CHAR);
    v_CURRENCY VARCHAR2(4000 CHAR);
    v_MEASURE VARCHAR2(4000 CHAR);
    v_DOM_EXP VARCHAR2(4000 CHAR);
    v_FCST_TYPE VARCHAR2(4000 CHAR);
    v_INCOTERMS VARCHAR2(4000 CHAR);
    v_ITEM_USE VARCHAR2(4000 CHAR);
    v_UNIT_ENERGY NUMBER(30,10);
    v_CELL_PROD_SITE VARCHAR2(4000 CHAR);
    v_PRICE NUMBER(30,10);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_CREATION_DATE DATE;
    v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    v_LAST_UPDATE_DATE DATE;
    v_ROW_COUNT VARCHAR2(4000 CHAR);
    v_DEPT_ID VARCHAR2(4000 CHAR);
    v_END_CUSTOMER VARCHAR2(4000 CHAR);
    v_BIZ_TYPE VARCHAR2(4000 CHAR);
    n1_MEASURE VARCHAR2(4000 CHAR);
    n2_MEASURE VARCHAR2(4000 CHAR);
    n1_PRICE NUMBER(30,10);
    n2_PRICE NUMBER(30,10);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_cnt_1  INTEGER := 0;
    v_in_para_data VARCHAR2(4000);
    V_BP_QTY NUMBER(30,10);
    v_exchange_price NUMBER(30,10);
    V_SQL_CODE    VARCHAR2(100) := NULL;      
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;

    CURSOR future_price_cur IS
      SELECT B.DIVISION_ID,B.PROJECT_CODE,B.PROJECT_NAME,B.SCM_SITE_ID,B.PLANT_SITE_ID,B.ITEM_ID,B.YYYYMM,B.CURRENCY
            ,B.MEASURE,B.DOM_EXP,B.FCST_TYPE,B.INCOTERMS
            ,B.ITEM_USE,B.UNIT_ENERGY
            ,B.CELL_PROD_SITE
            ,B.QTY
            ,B.DEPT_ID,B.END_CUSTOMER,B.BIZ_TYPE
            ,B.ROW_COUNT
            ,NVL((SELECT C.QTY FROM GT_SDPB_FUTURE_PRICE_TEMP_QTY C
                  WHERE C.DIVISION_ID = B.DIVISION_ID AND C.PROJECT_CODE = B.PROJECT_CODE
                    AND C.SCM_SITE_ID = B.SCM_SITE_ID AND C.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND C.ITEM_ID = B.ITEM_ID AND C.YYYYMM = B.YYYYMM
                    AND C.CURRENCY = B.CURRENCY AND C.DOM_EXP = B.DOM_EXP
                    AND C.FCST_TYPE = B.FCST_TYPE AND C.INCOTERMS = B.INCOTERMS
                    AND C.ITEM_USE = B.ITEM_USE AND C.UNIT_ENERGY = B.UNIT_ENERGY
                    AND C.CELL_PROD_SITE = B.CELL_PROD_SITE
                    AND C.DEPT_ID = B.DEPT_ID AND C.END_CUSTOMER = B.END_CUSTOMER
                    AND C.BIZ_TYPE = B.BIZ_TYPE
                    AND C.MEASURE = 'Business_Plan'
                    AND ROWNUM = 1), 0) V_BP_QTY
       FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4 B
       WHERE B.MEASURE = 'LOC'
       ORDER BY B.ROW_COUNT;
BEGIN

DBMS_OUTPUT.PUT_LINE('EXEC_001                                       =>  '  ||  TO_CHAR(SYSDATE));

  -- PJ20200138 item_use, unit_energy 추가
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    --v_description := 'DIVISION_ID : ' || p_division_id;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );
    v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)
    -- 트랜잭션 (START)
    --
  -- -----------------------------------------------------------------------------------------
    -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
  -- -----------------------------------------------------------------------------------------
    BEGIN

      -- Temp Table0 존재여부 확인하여 삭제
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPBP_FUTURE_PRICE_TEMP0_4';

      -- Temp Table2 존재여부 확인하여 삭제
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPBP_FUTURE_PRICE_TEMP2_4';

        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPB_FUTURE_PRICE_TEMP_QTY';

      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      -- PROCEDURE 에서 GT_SDPB_BP_FCST 테이블로 CALL받은경우
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      IF s_flag = 'CALL' THEN
          --임시확인
          --SELECT 'GT_SDPB_BP_FCST'
          --SELECT * FROM GT_SDPB_BP_FCST
          insert into GT_SDPBP_FUTURE_PRICE_TEMP0_4
          SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,'' AS DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
              ,ITEM_USE, UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,CELL_PROD_SITE
                ,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,MAX(QTY) QTY
                          ,DEPT_ID,END_CUSTOMER,BIZ_TYPE-- 20190830 추가
                          ,COUNT(*) G_COUNT
           FROM GT_SDPB_BP_FCST  WHERE 1=1
              --AND DIVISION_ID = p_division_id
              --AND YYYYMM >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') -- 당주 월요일이후 데이터만 대상으로함
              AND MEASURE NOT IN ('Business_Plan', 'MKT_FCST')
              GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE, MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE
             ORDER BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE, MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE;

      END IF;

      IF s_flag <> 'CALL' THEN
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      -- 전체대상인경우
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
        insert into GT_SDPBP_FUTURE_PRICE_TEMP0_4
        SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
            ,ITEM_USE, UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,CELL_PROD_SITE
              ,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,MAX(QTY) QTY
                      ,DEPT_ID,END_CUSTOMER,BIZ_TYPE-- 20190830 추가
                      ,COUNT(*) G_COUNT
         FROM DM_PLN_BP_FCST  WHERE 1=1
            AND DIVISION_ID = s_division_id
            --AND YYYYMM >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') -- 당주 월요일이후 데이터만 대상으로함
          GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE
           ORDER BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE;
      END IF;

      -- Temp Table1 존재여부 확인하여 삭제
      -- 임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP0_4'
      --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP0_4
      -- Temp Table1 에 작업대상을 저장
      /* TODO:GTT:GT_SDPBP_FUTURE_PRICE_TEMP1_2-->GT_SDPBP_FUTURE_PRICE_TEMP1_2 */
      INSERT INTO GT_SDPBP_FUTURE_PRICE_TEMP1_2
      SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
          ,ITEM_USE, UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
          ,CELL_PROD_SITE
            ,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,MAX(QTY) QTY
                  ,DEPT_ID,END_CUSTOMER,BIZ_TYPE-- 20190830 추가
                  ,G_COUNT
       FROM GT_SDPBP_FUTURE_PRICE_TEMP0_4  WHERE 1=1
            --AND G_COUNT < 3     -- 3개 정상 셋트가 아닌경우만 대상으로함 -> 20180720 KHSONG 주석처리 전체를 다시 계산함
            GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,G_COUNT,DEPT_ID,END_CUSTOMER,BIZ_TYPE
         ORDER BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,G_COUNT,DEPT_ID,END_CUSTOMER,BIZ_TYPE;

      -- 임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP1_2'
      --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP1_2
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      -- PROCEDURE 에서 GT_SDPB_BP_FCST 테이블로 CALL받은경우
      -- -------------------------------------------------------------------------------------------------------------------------------------------------------
      -- 대상데이터 INSERT INTO insert into GT_SDPBP_FUTURE_PRICE_TEMP2_4
      INSERT INTO GT_SDPBP_FUTURE_PRICE_TEMP2_4
      SELECT B.DIVISION_ID,B.PROJECT_CODE,B.PROJECT_NAME,B.SCM_SITE_ID,B.ITEM_ID,B.DOM_EXP,B.FCST_TYPE,B.INCOTERMS-- PJ20200138 Incoterms 삭제
            ,B.ITEM_USE, B.UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
          ,B.CELL_PROD_SITE
            ,B.MEASURE,B.PLANT_SITE_ID,B.YYYYMM,B.CURRENCY,B.QTY
                  ,B.DEPT_ID,B.END_CUSTOMER,B.BIZ_TYPE-- 20190830 추가
                  ,G_COUNT,row_number() OVER (ORDER BY B.DIVISION_ID) ROW_COUNT
       FROM GT_SDPBP_FUTURE_PRICE_TEMP1_2 B
      ORDER BY G_COUNT;

      -- Business Plan 메저만 별도 저장
      insert into GT_SDPB_FUTURE_PRICE_TEMP_QTY
      SELECT *
      FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4
      WHERE MEASURE IN ( 'Business_Plan', 'MKT_FCST');

      -- 임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP2_4'
      --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4
      -- Temp Table3 존재여부 확인하여 삭제
     /* SELECT * INTO GT_SDPBP_FUTURE_PRICE_TEMP3_2
        FROM DM_PLN_BP_FCST  ; -- TEMP 테이블 컬럼생성*/

      EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDPBP_FUTURE_PRICE_TEMP3_2';

      -- 임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP2_4'
      --DROP TABLE TEMP_SKH_0605_FUTURE_PRICE_TEMP2
      --SELECT * INTO TEMP_SKH_0605_FUTURE_PRICE_TEMP2
      --FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4
--SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4
--SELECT * FROM GT_SDPB_FUTURE_PRICE_TEMP_QTY
      -- 변수선언
      --    V_ROW_COUNT VARCHAR2(2 CHAR);
    -- V_BP_QTY NUMBER(30,10) -- [C20200820-000170]

      -- 데이터 확인하여 INSERT
        -- 커서 확인후 초기화
      --SELECT COUNT(1)
      --INTO v_cnt_1
      --FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'future_price_cur';
      --IF v_cnt_1 > 0 THEN
      --  close future_price_cur
      --  deallocate future_price_cur
      --END IF;

      -- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- future_price_cur CURSOR fast_forward for
      --OPEN O_RC1 FOR

        -- 커서 오픈
      OPEN future_price_cur;

      -- -----------------------------------------------------------------------------------------------------
      FETCH future_price_cur INTO
                        v_DIVISION_ID
             ,v_PROJECT_CODE
             ,v_PROJECT_NAME
             ,v_SCM_SITE_ID
             ,v_PLANT_SITE_ID
             ,v_ITEM_ID
             ,v_YYYYMM
             ,v_CURRENCY
             ,v_MEASURE
             ,v_DOM_EXP
             ,v_FCST_TYPE
             ,v_INCOTERMS  -- PJ20200138 Incoterms 삭제
             -- PJ20200138 item_use, unit_energy 추가
             ,v_ITEM_USE
             ,v_UNIT_ENERGY
             ,v_CELL_PROD_SITE
             ,v_PRICE
                       -- 20190830 추가
                       ,v_DEPT_ID
                       ,v_END_CUSTOMER
                       ,v_BIZ_TYPE

             ,v_ROW_COUNT
             ,V_BP_QTY;
      -- -----------------------------------------------------------------------------------------------------
      WHILE future_price_cur%FOUND LOOP
      -- -----------------------------------------------------------------------------------------------------
        --확인 SELECT V_ROW_COUNT AS 'V_ROW_COUNT'
        --확인 SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4  WHERE ROW_COUNT = V_ROW_COUNT
        -- 변수 초기화
        n1_MEASURE := NULL;
        n2_MEASURE := NULL;
        n1_PRICE := 0;
        n2_PRICE := 0;

        -- 임시확인
        --SELECT 'v_MEASURE',v_MEASURE,'v_CURRENCY',v_CURRENCY
      -- -----------------------------------------------------------------------------------------------------
        IF  v_MEASURE='LOC' AND v_CURRENCY = 'KRW' THEN
            -- KRW SETTING
            n1_MEASURE := 'KRW';
            n1_PRICE := v_PRICE;

            -- USD 산출
            n2_MEASURE := 'USD';
                    BEGIN SELECT NVL(EXCHANGE_PRICE,1) INTO v_exchange_price FROM DM_BP_EXCHANGE_RATE WHERE DIVISION_ID = v_DIVISION_ID
                                         AND YYYYMMDD = SUBSTR(v_YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' AND ROWNUM = 1; EXCEPTION WHEN NO_DATA_FOUND THEN v_exchange_price := 1; END;
                    n2_PRICE := NVL(v_PRICE / v_exchange_price, 0);
            END IF;

        IF  v_MEASURE='LOC' AND v_CURRENCY = 'USD' THEN
            -- USD SETTING
            n1_MEASURE := 'USD';
            n1_PRICE := v_PRICE;

            -- KRW 산출
            n2_MEASURE := 'KRW';
                    BEGIN SELECT NVL(EXCHANGE_PRICE,1) INTO v_exchange_price FROM DM_BP_EXCHANGE_RATE WHERE DIVISION_ID = v_DIVISION_ID
                                         AND YYYYMMDD = SUBSTR(v_YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' AND ROWNUM = 1; EXCEPTION WHEN NO_DATA_FOUND THEN v_exchange_price := 1; END;
                    n2_PRICE := NVL(v_PRICE * v_exchange_price, 0);
            END IF;

        IF  v_MEASURE='LOC' AND v_CURRENCY NOT IN ('KRW','USD') THEN
            n1_MEASURE := 'KRW';
            -- KRW 산출
                    BEGIN SELECT NVL(EXCHANGE_PRICE,1) INTO v_exchange_price FROM DM_BP_EXCHANGE_RATE WHERE DIVISION_ID = v_DIVISION_ID
                                         AND YYYYMMDD = SUBSTR(v_YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = v_CURRENCY AND ROWNUM = 1; EXCEPTION WHEN NO_DATA_FOUND THEN v_exchange_price := 1; END;
                    n1_PRICE := v_PRICE * v_exchange_price;
            n2_MEASURE := 'USD';
                    BEGIN SELECT NVL(EXCHANGE_PRICE,1) INTO v_exchange_price FROM DM_BP_EXCHANGE_RATE WHERE DIVISION_ID = v_DIVISION_ID
                                         AND YYYYMMDD = SUBSTR(v_YYYYMM, 1, 6)  ||  '01' AND UNIT_CURRENCY = 'USD' AND ROWNUM = 1; EXCEPTION WHEN NO_DATA_FOUND THEN v_exchange_price := 1; END;
                    n2_PRICE := NVL(n1_PRICE / v_exchange_price, 0);
            END IF;

        -- 임시확인
        --SELECT   v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY,n2_MEASURE
        --    ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS,ROUND(n2_PRICE,3),'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP
        IF  n1_MEASURE IS NOT NULL THEN
          -- PRICE INSERT #1
          insert into  GT_SDPBP_FUTURE_PRICE_TEMP3_2
            (DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
              ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,CELL_PROD_SITE
            ,QTY
            ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                        ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
          values
            (v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY,n1_MEASURE
            ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS -- PJ20200138 Incoterms 삭제
            ,v_ITEM_USE,v_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,v_CELL_PROD_SITE
            ,ROUND(n1_PRICE,3),'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
            ,null,null,null,null,null,null,null,null,null,null
                        ,v_DEPT_ID,v_END_CUSTOMER,v_BIZ_TYPE);  -- 20190830 추가

          IF s_flag <> 'CALL' THEN
            -- Amount INSERT #1
            insert into  GT_SDPBP_FUTURE_PRICE_TEMP3_2
              (DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
              ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,CELL_PROD_SITE
              ,QTY
              ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
              ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
              ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
            values
              (v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY, 'SalesAmt_'  ||  n1_MEASURE
              ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS-- PJ20200138 Incoterms 삭제
              ,v_ITEM_USE,v_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,v_CELL_PROD_SITE
              ,ROUND(n1_PRICE * V_BP_QTY,3)
              ,'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
              ,null,null,null,null,null,null,null,null,null,null
              ,v_DEPT_ID,v_END_CUSTOMER,v_BIZ_TYPE);  -- 20190830 추가
          END IF;

          END IF;

        IF  n2_MEASURE IS NOT NULL THEN
          -- PRICE INSERT #2
          insert into  GT_SDPBP_FUTURE_PRICE_TEMP3_2
            (DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
            ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,CELL_PROD_SITE
            ,QTY
            ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                        ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
          values
            (v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY,n2_MEASURE
            ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS-- PJ20200138 Incoterms 삭제
            ,v_ITEM_USE,v_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
            ,v_CELL_PROD_SITE
            ,ROUND(n2_PRICE, 3),'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
            ,null,null,null,null,null,null,null,null,null,null
                        ,v_DEPT_ID,v_END_CUSTOMER,v_BIZ_TYPE);  -- 20190830 추가

          IF s_flag <> 'CALL' THEN
            -- Amount INSERT #2
            insert into  GT_SDPBP_FUTURE_PRICE_TEMP3_2
              (DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- PJ20200138 Incoterms 삭제
              ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,CELL_PROD_SITE
              ,QTY
              ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
              ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
              ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
            values
              (v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY, 'SalesAmt_'  ||  n2_MEASURE
              ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS-- PJ20200138 Incoterms 삭제
              ,v_ITEM_USE, v_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
              ,v_CELL_PROD_SITE
              ,ROUND(n2_PRICE * V_BP_QTY, 3),'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
              ,null,null,null,null,null,null,null,null,null,null
              ,v_DEPT_ID,v_END_CUSTOMER,v_BIZ_TYPE);  -- 20190830 추가
          END IF;
          END IF;

      -- -----------------------------------------------------------------------------------------------------
      FETCH future_price_cur INTO
                        v_DIVISION_ID
             ,v_PROJECT_CODE
             ,v_PROJECT_NAME
             ,v_SCM_SITE_ID
             ,v_PLANT_SITE_ID
             ,v_ITEM_ID
             ,v_YYYYMM
             ,v_CURRENCY
             ,v_MEASURE
             ,v_DOM_EXP
             ,v_FCST_TYPE
             ,v_INCOTERMS -- PJ20200138 Incoterms 삭제
             -- PJ20200138 item_use, unit_energy 추가
             ,v_ITEM_USE
             ,v_UNIT_ENERGY
             ,v_CELL_PROD_SITE
             ,v_PRICE
                       -- 20190830 추가
                       ,v_DEPT_ID
                       ,v_END_CUSTOMER
                       ,v_BIZ_TYPE

             ,v_ROW_COUNT
             ,V_BP_QTY;
      END LOOP;
      -- -----------------------------------------------------------------------------------------------------
      close future_price_cur;
      -- deallocate  future_price_cur
--select 'GT_SDPBP_FUTURE_PRICE_TEMP3_2', * from GT_SDPBP_FUTURE_PRICE_TEMP3_2
      --임시확인
      --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP3_2'
      --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP3_2

      DELETE
        FROM  DM_PLN_BP_FCST
                  WHERE EXISTS (
                    SELECT 1
            FROM GT_SDPBP_FUTURE_PRICE_TEMP3_2 B
             where  1=1
             and  DM_PLN_BP_FCST.DIVISION_ID     =  B.DIVISION_ID
             and  DM_PLN_BP_FCST.PROJECT_CODE    =  B.PROJECT_CODE
             --and  DM_PLN_BP_FCST.PROJECT_NAME    =  B.PROJECT_NAME
             and  DM_PLN_BP_FCST.SCM_SITE_ID     =  B.SCM_SITE_ID
             and  DM_PLN_BP_FCST.PLANT_SITE_ID   =  B.PLANT_SITE_ID
             and  DM_PLN_BP_FCST.ITEM_ID         =  B.ITEM_ID
             and  DM_PLN_BP_FCST.YYYYMM          =  B.YYYYMM
             and  DM_PLN_BP_FCST.CURRENCY        =  B.CURRENCY
             and  DM_PLN_BP_FCST.MEASURE         =  B.MEASURE
             and  DM_PLN_BP_FCST.DOM_EXP         =  B.DOM_EXP
             and  DM_PLN_BP_FCST.FCST_TYPE       =  B.FCST_TYPE
             and  DM_PLN_BP_FCST.INCOTERMS       =  B.INCOTERMS     -- PJ20200138 Incoterms 삭제
             -- PJ20200138 item_use, unit_energy 추가
             and  DM_PLN_BP_FCST.ITEM_USE        =  B.ITEM_USE
             and  DM_PLN_BP_FCST.UNIT_ENERGY     =  B.UNIT_ENERGY
             and  DM_PLN_BP_FCST.CELL_PROD_SITE  =  B.CELL_PROD_SITE
                       -- 20190830 추가
             and  DM_PLN_BP_FCST.DEPT_ID         =  B.DEPT_ID
             and  DM_PLN_BP_FCST.END_CUSTOMER    =  B.END_CUSTOMER
             and  DM_PLN_BP_FCST.BIZ_TYPE        =  B.BIZ_TYPE
          );


      INSERT INTO DM_PLN_BP_FCST
         ( DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE
        ,INCOTERMS-- PJ20200138 Incoterms 삭제
        ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
        ,CELL_PROD_SITE
        ,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
        ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                ,DEPT_ID,END_CUSTOMER,BIZ_TYPE  -- 20190830 추가
        )
        SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE
          ,INCOTERMS-- PJ20200138 Incoterms 삭제
          ,ITEM_USE,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
          ,CELL_PROD_SITE
          ,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
          ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                    ,DEPT_ID,END_CUSTOMER,BIZ_TYPE  -- 20190830 추가
        FROM GT_SDPBP_FUTURE_PRICE_TEMP3_2;

        /*---------------------------------------------------------------*/
     -- IF 0 > 0
    -- 트랜잭션 (COMMIT)
        --COMMIT;
  -- -----------------------------------------------------------------------------------------
    -- END TRY
  -- -----------------------------------------------------------------------------------------
  -- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
  -- -----------------------------------------------------------
    --[C20200909-000203] LOG 표준화 적용
    -- 트랜잭션 (END)
    --    SELECT 'ERROR';
      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := SUBSTR(SQLERRM, 1, 1000);
      v_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
      d_event_date := SYSTIMESTAMP;
    --[C20200909-000203] LOG 표준화 적용
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data  => v_in_para_data,
        p_sql_err_code  => SQLCODE,
        p_sql_err_msg   => SQLERRM,
        p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

    V_SQL_CODE    := SQLCODE;      
    V_SQL_ERRMSG  := SQLERRM;
    
    OPEN O_RC2 FOR
    SELECT '['  ||  TO_CHAR(V_SQL_CODE)  ||  ']'  ||  v_log_message FROM DUAL;  /*-- 에러메시지 DISPLAY --*/ 

  END;
  -- -----------------------------------------------------------
    -- END CATCH
  -- -----------------------------------------------------------
  -- 수행결과 성공여부 DISPLAY
    IF s_flag <> 'CALL' and v_log_message IS NULL THEN
        --SELECT 'success'
        OPEN O_RC1 FOR
        SELECT 'Sales Price Recalculation is Complete' FROM DUAL;
      END IF;

      -- Temp Table0 존재여부 확인하여 삭제
      -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    --v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );


END;
/

-- DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF → PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF
(
				p_division_id                VARCHAR2,   -- 부서코드
				p_version_type               VARCHAR2,   -- 버전유형
				p_yyyyMM_from                VARCHAR2,    -- 시작구간
				p_yyyyMM_to                  VARCHAR2,    -- 끝구간
				p_created_by                 VARCHAR2,   -- 작성자
				p_version_no                 VARCHAR2    -- 버전번호 (BP_M_20220822_V002)

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
)
/*
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF
 * Description  : Business Plan ('DM_PLN_BP_FCST' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/11/08  chano0612   [C20221025-000029] Business Plan Current버전 특정 컷오프 버전으로 덮어쓰기 기능 구현 요청의 건
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-08 20:46:07
 * 파일: dbo.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:8  END:9  차이:-1
 * ----------------------------------------
 * IF 위치:     L263
 * END IF 위치: L273
 * BEGIN 위치:  L33, L58, L60, L67, L79, L164, L219, L242
 * END;  위치:  L64, L71, L74, L161, L211, L221, L246, L259, L275
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */

    p_count                      INTEGER; -- 적용데이터 수량

--DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF('40', 'BP_M', '202401', '202401', 'chano0612', 'BP_M_20221115_V001');
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    v_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_in_para_data VARCHAR2(4000);
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    -- N_LOG_COUNT   NUMBER := 0;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_version_type' VALUE p_version_type,
            'p_yyyyMM_from' VALUE p_yyyyMM_from,
            'p_yyyyMM_to' VALUE p_yyyyMM_to,
            'p_created_by' VALUE p_created_by,
            'p_version_no' VALUE p_version_no
            --'P_M_20220822_V002' VALUE P_M_20220822_V002
          );

	-- LOG 용 변수 설정
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, v_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );

	-- 시작 LOG  (END)
	v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	-------------------------------------- 설정된 기간에서 기존 데이터 삭제 START
	BEGIN

		BEGIN
		  DELETE FROM DM_PLN_BP_FCST
		  WHERE DIVISION_ID = p_division_id AND YYYYMM BETWEEN p_yyyyMM_from AND p_yyyyMM_to;
		  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
		END;

		--PRINT 'DM_PLN_BP_FCST' || '_' || 'DELETE' || SQL%ROWCOUNT
		BEGIN
		  DELETE FROM DM_BP_EXCHANGE_RATE
		  WHERE DIVISION_ID = p_division_id AND SUBSTR(YYYYMMDD, 1, 6) BETWEEN p_yyyyMM_from AND p_yyyyMM_to;
		  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
		END;

		--PRINT 'DM_BP_EXCHANGE_RATE' || '_' || 'DELETE' || SQL%ROWCOUNT
	END;
	-------------------------------------- 설정된 기간에서 기존 데이터 삭제 END
	-------------------------------------- 컷오프데이터를 데이터를 삽입 START
	-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

	  BEGIN
		  INSERT INTO DM_PLN_BP_FCST(
			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			ITEM_ID,
			FCST_TYPE,
			MEASURE,
			PLANT_SITE_ID,
			DEPT_ID,
			END_CUSTOMER,
			BIZ_TYPE,
			YYYYMM,
			CURRENCY,
			ITEM_USE,
			UNIT_ENERGY,
			INCOTERMS,
			CELL_PROD_SITE,
			DOM_EXP,
			QTY,
			CREATED_BY,
			CREATION_DATE,
			LAST_UPDATED_BY,
			LAST_UPDATE_DATE,
			ATTRIBUTE1,
			ATTRIBUTE2,
			ATTRIBUTE3,
			ATTRIBUTE4,
			ATTRIBUTE5,
			ATTRIBUTE6,
			ATTRIBUTE7,
			ATTRIBUTE8,
			ATTRIBUTE9,
			ATTRIBUTE10,
			CELL_PER_MODULE,
			CELL_PER_PACK,
			PROJECT_NAME,
			MODULE_PER_PACK)
		  SELECT
  			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			ITEM_ID,
			FCST_TYPE,
			MEASURE,
			PLANT_SITE_ID,
			DEPT_ID,
			END_CUSTOMER,
			BIZ_TYPE,
			YYYYMM,
			CURRENCY,
			ITEM_USE,
			UNIT_ENERGY,
			INCOTERMS,
			CELL_PROD_SITE,
			DOM_EXP,
			QTY,
			CREATED_BY,
			CREATION_DATE,
			p_created_by, --LAST_UPDATED_BY,
			SYSDATE, --LAST_UPDATE_DATE,
			p_version_no, --ATTRIBUTE1,
			ATTRIBUTE2,
			ATTRIBUTE3,
			ATTRIBUTE4,
			ATTRIBUTE5,
			ATTRIBUTE6,
			ATTRIBUTE7,
			ATTRIBUTE8,
			ATTRIBUTE9,
			ATTRIBUTE10,
			CELL_PER_MODULE,
			CELL_PER_PACK,
			PROJECT_NAME,
			MODULE_PER_PACK

		  FROM DM_PLN_BP_FCST_C
		  WHERE VERSION_NO = p_version_no AND DIVISION_ID = p_division_id AND YYYYMM BETWEEN p_yyyyMM_from AND p_yyyyMM_to;

		  p_count := SQL%ROWCOUNT;
		  DBMS_OUTPUT.PUT_LINE(p_count);

	  END;

	  --PRINT 'DM_PLN_BP_FCST' || '_' || 'INSERT' || SQL%ROWCOUNT
	  BEGIN
		  INSERT INTO DM_BP_EXCHANGE_RATE(
					  DIVISION_ID,
					  YYYYMMDD,
					  CURRENCY,
					  UNIT_CURRENCY,
					  EXCHANGE_PRICE,
					  CREATED_BY,
					  CREATION_DATE,
					  LAST_UPDATED_BY,
					  LAST_UPDATE_DATE,
					  ATTRIBUTE1,
					  ATTRIBUTE2,
					  ATTRIBUTE3,
					  ATTRIBUTE4,
					  ATTRIBUTE5,
					  ATTRIBUTE6,
					  ATTRIBUTE7,
					  ATTRIBUTE8,
					  ATTRIBUTE9,
					  ATTRIBUTE10
					  )
		  SELECT
			DIVISION_ID,
			YYYYMMDD,
			CURRENCY,
			UNIT_CURRENCY,
			EXCHANGE_PRICE,
			CREATED_BY,
			CREATION_DATE,
			p_created_by,
			SYSDATE,
			p_version_no,
			ATTRIBUTE2,
			ATTRIBUTE3,
			ATTRIBUTE4,
			ATTRIBUTE5,
			ATTRIBUTE6,
			ATTRIBUTE7,
			ATTRIBUTE8,
			ATTRIBUTE9,
			ATTRIBUTE10
		  FROM DM_BP_EXCHANGE_RATE_C
		  WHERE VERSION_NO = p_version_no AND DIVISION_ID = p_division_id AND SUBSTR(YYYYMMDD, 1, 6) BETWEEN p_yyyyMM_from AND p_yyyyMM_to;

		  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);

	  END;
	  --PRINT 'DM_BP_EXCHANGE_RATE' || '_' || 'INSERT' || SQL%ROWCOUNT
	-------------------------------------- 컷오프데이터를 데이터를 삽입 END

	-- LOG 용 변수 설정
	v_log_type := 'END';
	v_log_count := p_count;
	v_log_message := '########## End of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, v_log_count, v_log_message, v_description, d_event_date,
        p_in_para_data => v_in_para_data
      );

	OPEN O_RC1 FOR SELECT 'OK' RESULT, p_count CNT FROM DUAL;
	OPEN O_RC2 FOR SELECT 'OK' RESULT FROM DUAL;


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
END DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF;
/
