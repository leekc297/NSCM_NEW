CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0042" IS

  PROCEDURE P_DMF0042_GET_DM_MDF_VERSION 
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
		-- [20260805] 검색어 미입력 시 전행 — AS-IS `NULL LIKE '%'` 탈락(파리티)을 사용자 지시로 보정(Δ)
		AND ( p_version_description IS NULL OR VERSION_DESCRIPTION like p_version_description  ||  '%' )
		-- [20260805 hook #119] NVL(x,NULL)<>'MOVE' 는 ATTRIBUTE1 NULL 행 전멸(항상 UNKNOWN) —
		--   AS-IS ISNULL(x,'')<>'MOVE' 파리티 = CHR(0) 센티널 (본문 L110 BP_CUTOFF_VERSION 판과 동일 패턴)
		AND NVL(ATTRIBUTE1, CHR(0)) <> 'MOVE'

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
END P_DMF0042_GET_DM_MDF_VERSION;


  PROCEDURE P_DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION 
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
END P_DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION;


  PROCEDURE P_DMF0042_GET_EXCHANGE_PRICE 
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
END P_DMF0042_GET_EXCHANGE_PRICE;


  PROCEDURE P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP 
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
END P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP;


  PROCEDURE P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA 
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
END P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA;


  PROCEDURE P_DMF0042_GET_SPREAD_TITLE 
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
				, 'N' AS EDIT_YN
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = 'N'
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
				, 'N' AS EDIT_YN
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
				, 'N' AS EDIT_YN
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = 'N'
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
				, 'N' AS EDIT_YN
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
END P_DMF0042_GET_SPREAD_TITLE;


  PROCEDURE P_DMF0042_SAVE_DM_BP_EXCHANGE_RATE 
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
    -- [20260805 SPLIT-FIX] AS-IS 원본은 p_x(나머지)/v_x(토큰) 2변수 구조 — 변환본이 1변수로 합쳐
    --   토큰 추출 직후 NULL 파괴(전 필드 NULL 적재→INVALID). v_recv_* = 나머지 보관용 복원.
    v_recv_division_id VARCHAR2(4000 CHAR);
    v_recv_YYYYMMDD VARCHAR2(4000 CHAR);
    v_recv_CURRENCY VARCHAR2(4000 CHAR);
    v_recv_UNIT_CURRENCY VARCHAR2(4000 CHAR);
    v_recv_EXCHANGE_PRICE VARCHAR2(4000 CHAR);
    v_recv_CREATED_BY VARCHAR2(4000 CHAR);
    v_recv_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
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

	-- [20260805 SPLIT-FIX] 나머지 보관 변수(v_recv_*)에 적재 — 토큰(v_*)과 분리 (AS-IS @p_x/@v_x 1:1)
	v_recv_active_flag := RTRIM(p_active_flag     )  ||  '^';
	v_recv_division_id := RTRIM(p_division_id     )  ||  '^';
	v_recv_YYYYMMDD := RTRIM(p_YYYYMMDD        )  ||  '^';
	v_recv_CURRENCY := RTRIM(p_CURRENCY        )  ||  '^';
	v_recv_UNIT_CURRENCY := RTRIM(p_UNIT_CURRENCY   )  ||  '^';
	v_recv_EXCHANGE_PRICE := RTRIM(p_EXCHANGE_PRICE  )  ||  '^';
	v_recv_CREATED_BY := RTRIM(p_CREATED_BY      )  ||  '^';
	v_recv_LAST_UPDATED_BY := RTRIM(p_LAST_UPDATED_BY )  ||  '^';

	-- LOG 용 변수 설정
	DELETE FROM GT_SDBE_RESULTS;

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
WHILE LENGTH(v_recv_division_id) > 0 LOOP

    v_index_active_flag := INSTR(v_recv_active_flag, '^');
	v_index_division_id := INSTR(v_recv_division_id, '^');
	v_index_YYYYMMDD := INSTR(v_recv_YYYYMMDD, '^');
	v_index_CURRENCY := INSTR(v_recv_CURRENCY, '^');
	v_index_UNIT_CURRENCY := INSTR(v_recv_UNIT_CURRENCY, '^');
	v_index_EXCHANGE_PRICE := INSTR(v_recv_EXCHANGE_PRICE, '^');
	v_index_CREATED_BY := INSTR(v_recv_CREATED_BY, '^');
	v_index_LAST_UPDATED_BY := INSTR(v_recv_LAST_UPDATED_BY, '^');

	--확인  select v_index_DIVISION_ID as 'v_index_DIVISION_ID';
    IF v_index_DIVISION_ID > 0 THEN
			-- [20260805 SPLIT-FIX] 토큰 = 나머지의 선두, 나머지 = 구분자 이후 (AS-IS 원본 1:1)
			v_active_flag := SUBSTR(v_recv_active_flag, 1, v_index_active_flag - 1);
			v_recv_active_flag := SUBSTR(v_recv_active_flag, v_index_active_flag + 1);

			v_DIVISION_ID := SUBSTR(v_recv_DIVISION_ID, 1, v_index_DIVISION_ID - 1);
			v_recv_DIVISION_ID := SUBSTR(v_recv_DIVISION_ID, v_index_DIVISION_ID + 1);

			v_YYYYMMDD := SUBSTR(v_recv_YYYYMMDD, 1, v_index_YYYYMMDD - 1);
			v_recv_YYYYMMDD := SUBSTR(v_recv_YYYYMMDD, v_index_YYYYMMDD + 1);

			v_CURRENCY := SUBSTR(v_recv_CURRENCY, 1, v_index_CURRENCY - 1);
			v_recv_CURRENCY := SUBSTR(v_recv_CURRENCY, v_index_CURRENCY + 1);

			v_UNIT_CURRENCY := SUBSTR(v_recv_UNIT_CURRENCY, 1, v_index_UNIT_CURRENCY - 1);
			v_recv_UNIT_CURRENCY := SUBSTR(v_recv_UNIT_CURRENCY, v_index_UNIT_CURRENCY + 1);

			v_EXCHANGE_PRICE := SUBSTR(v_recv_EXCHANGE_PRICE, 1, v_index_EXCHANGE_PRICE - 1);
			v_recv_EXCHANGE_PRICE := SUBSTR(v_recv_EXCHANGE_PRICE, v_index_EXCHANGE_PRICE + 1);

			v_CREATED_BY := SUBSTR(v_recv_CREATED_BY, 1, v_index_CREATED_BY - 1);
			v_recv_CREATED_BY := SUBSTR(v_recv_CREATED_BY, v_index_CREATED_BY + 1);

			v_LAST_UPDATED_BY := SUBSTR(v_recv_LAST_UPDATED_BY, 1, v_index_LAST_UPDATED_BY - 1);
			v_recv_LAST_UPDATED_BY := SUBSTR(v_recv_LAST_UPDATED_BY, v_index_LAST_UPDATED_BY + 1);

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
			-- [20260805 SPLIT-FIX] 도달 불가 잔존 분기(모든 토큰이 '^' 종결) — 만약 도달 시 무한루프 방어
			v_DIVISION_ID := p_DIVISION_ID;
			v_recv_division_id := NULL;

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
END P_DMF0042_SAVE_DM_BP_EXCHANGE_RATE;


  PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF 
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
 * Program ID	: DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF
 * Description	: Business Plan ('DM_PLN_BP_FCST' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date	In Charge      Description
 *===================================================================================================
 * 2022/11/08  chano0612   [C20221025-000029] Business Plan Current버전 특정 컷오프 버전으로 덮어쓰기 기능 구현 요청의 건
 * 2026/03/15	ZIONEX	[PJ20264226] NextSCM Pilot 프로시저 변환 적용
 * 2026.06.02	ZIONEX	[PJ202650304] NextSCM Migration
 */
AS

/*
 * ========================================
 * [자동변환] 2026-03-08 20:46:07
 * 원본: dbo.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF.sql
 * ----------------------------------------
 * 짝 BEGIN: BEGIN:8  END:9  차이:-1
 * ----------------------------------------
 * IF 시작:	  L263
 * END IF 시작: L273
 * BEGIN 시작:  L33, L58, L60, L67, L79, L164, L219, L242
 * END;  시작:  L64, L71, L74, L161, L211, L221, L246, L259, L275
 * 비고: END가 1개 더 많으므로 자동 변환 시 END; 짝을 확인하세요.
 * ----------------------------------------
 * 자동 변환 결과이므로 반드시 검토 후 사용하세요.
 * ========================================
 */

    p_count			 INTEGER; -- 적용데이터 수량

--DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF('40', 'BP_M', '202401', '202401', 'chano0612', 'BP_M_20221115_V001');
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    v_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_in_para_data VARCHAR2(4000);
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
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
	v_log_message := NULL;	/*-- <- 변수 재사용을 위하여 초기화해야함 --*/

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
	-- BEGIN TRY (Oracle: EXCEPTION 블록으로 변환)

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

	-- 종료 LOG
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
			    v_log_count,
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
END P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF;


  PROCEDURE P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 
(
	  p_division_id			IN  VARCHAR2
	, p_dept_id				IN  VARCHAR2
	, p_end_customer		IN  VARCHAR2
	, p_scm_site_id			IN  VARCHAR2
	, p_project_code		IN  VARCHAR2
	, p_item_id				IN  VARCHAR2
	, p_item_type			IN  VARCHAR2
	, p_from_yyyymmdd		IN  VARCHAR2
	, p_now_yyyymmdd		IN  VARCHAR2
	, p_to_yyyymmdd			IN  VARCHAR2
	, p_created_by			IN  VARCHAR2
	, p_plant_site_id		IN  VARCHAR2
	, p_biztype				IN  VARCHAR2
	, p_userinfo			IN  VARCHAR2
	, p_owner				IN  VARCHAR2
	, p_qty_yn				IN  VARCHAR2
	-- SELECT 결과셋 반환: ① 동적 PIVOT 결과, ② 중장기 계획 날짜 결과 → SYS_REFCURSOR OUT 2개
	, p_cursor1				OUT SYS_REFCURSOR
	, p_cursor2				OUT SYS_REFCURSOR
)
/*=====================================================================================================================================================
 * Program ID  : [DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA]
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date        In Charge    Description
 *=====================================================================================================================================================
 * 2019/04/11	JYE			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/05/13	JYE			40사업부는 Incoterms, Fcst type, Dom exp 필수 제외
 * 2019/08/26	JYE			칼럼 수정
 * 2019/09/05	JYE			LEFT JOIN 으로 변경
 * 2019/10/02   KHSONG		조회시 DB Lock 현상으로 로직수정
 * 2019/10/18   KYH			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4
 * 2020/03/11   KHSONG		C20200103-000586 권한그룹을 LOOKUP
 * 2020/04/08	P.C.I		[PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/07/10	hwi1993     소스정리
 * 2020/07/10	hwi1993		[C20200706-000011] BP 메저정리
 * 2020/09/04	hwi1993		[c20200722-000060] biz plan active YN
 * 2021/07/22	hwi1993		과제(중장기) pk 변경에 따른 컬럼추가
 * 2021/07/29	hwi1993		과제(중장기) owner 컬럼 길이 제한
 * 2022/03/02	rosia27		[C20220224-000160]DM_LONG_PLAN 기능 고도화 요청의 건
 * 2022/06/21	rosia27		[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2024/08/01	JSSBAE		[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청
 * 2024/08/26	JSSBAE		[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가
 * 2024/08/27	KJJ			[PJ2024-50461] Team Mapping
 * 2024/09/12	JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2026.06.01	ZIONEX			[PJ202650304] NextSCM Migration
 *===================================================================================================================================================*/
AS
	v_Prod				CLOB;          -- 피벗 컬럼 식별자 목록 (outer SELECT 용 : "M_xxx",...)
	v_Prod_in			CLOB;          -- 피벗 IN 목록 ('M_xxx' AS "M_xxx",...)
	v_ColList			CLOB;
	v_GroupList			CLOB;
	v_nsql				CLOB;
	v_nsql2				CLOB;
	p_program_id		VARCHAR2(50 CHAR) := 'DMF0042';
	v_MEASURE			PLS_INTEGER := 0;
	v_i_count			PLS_INTEGER := 0;
	v_dept_id			VARCHAR2(50 CHAR) := NULL;   -- 원본 @v_dept_id (초기값 ''→NULL)
	v_group_id			VARCHAR2(50 CHAR) := NULL;   -- 원본 @v_group_id (초기값 ''→NULL)

	v_from_yyyymmdd		VARCHAR2(6 CHAR);            -- 원본은 IN 파라미터 @p_from_yyyymmdd 재대입 → Oracle 로컬변수 사용
	v_to_yyyymmdd		VARCHAR2(6 CHAR);

	v_from_yyyymm		VARCHAR2(6 CHAR);            -- 중장기 계획 구간 (원본 @FROM_YYYYMM); UF_FX_STRING_SPLITFORIN 은 T_STR_TAB 반환 → 컬럼명 COLUMN_VALUE
	v_to_yyyymm			VARCHAR2(6 CHAR);
	v_valid_yn			VARCHAR2(1 CHAR);
BEGIN
	v_ColList	:= NULL;     -- 원본 SET @ColList=''  (Oracle ''=NULL)
	v_GroupList	:= NULL;
	v_Prod		:= NULL;
	v_from_yyyymmdd	:= SUBSTR(p_from_yyyymmdd, 1, 6);
	v_to_yyyymmdd	:= SUBSTR(p_to_yyyymmdd, 1, 6);

	--============================================================================
	-- 사용자의 팀정보 & 권한
	--============================================================================
	BEGIN
		SELECT NVL(( SELECT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
					 WHERE LOOKUP_TYPE = 'PM_TEAM_MAPPING'
					 AND   VALID_YN = 'Y'
					 AND   SEGMENT1 = U.DEPT_ID
					 FETCH FIRST 1 ROWS ONLY ), U.DEPT_ID)
		INTO v_dept_id
		FROM TB_FX_User U
		WHERE U.UserID = p_created_by;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;   -- 사용자 미존재 시 원본(@v_dept_id 미변경)과 동일하게 NULL 유지
	END;

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A001-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--============================================================================
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (START)
	--============================================================================
	SELECT COUNT(1)
	INTO   v_i_count
	FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
	AND    VALID_YN = 'Y'
	AND    SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
	AND    SEGMENT1 = p_userinfo;
	IF v_i_count > 0 THEN
		v_group_id := 'ADMIN';
	END IF;
	v_i_count := 0;   -- 권한판별용으로만 사용하므로 원복
	--============================================================================
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	--============================================================================
	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A002-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--============================================================================
	-- TEMP TABLE DROP (START)
	-- (Oracle GTT: DROP 대신 세션 데이터 DELETE 로 초기화)
	--============================================================================
	DELETE FROM GT_DMF0042_RAW_DATA;
	DELETE FROM GT_DMF0042_DM_MST_ITEM_SINGLE_V;
	DELETE FROM GT_DMF0042_SELECT_MEASURE;
	DELETE FROM GT_DMF0042_RAW_DATA_SUM;
	DELETE FROM GT_DMF0042_SCM_MST_SSO_USER_INFO;
	DELETE FROM GT_DMF0042_SCM_MST_SITE_ITEM;
	--------------------------------------------------------------------------------------------------
	-- [E20240920-000300]_SCM.DM 화면 조회 속도 개선  (START)
	DELETE FROM GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V;
	DELETE FROM GT_DMF0042_DM_MST_ITEM_SINGLE_A_V;
	DELETE FROM GT_DMF0042_DM_MST_ITEM_SINGLE_B_V;
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (END)
	--------------------------------------------------------------------------------------------------
	--============================================================================
	-- TEMP TABLE DROP (END)
	--============================================================================
	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A003-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--============================================================================
	-- TEMP TABLE CREATE (START) → Oracle GTT 는 사전 생성(DDL 파일) 이므로 본문에서 생성하지 않음
	--============================================================================
	--============================================================================
	-- TEMP TABLE CREATE (END)
	--============================================================================
	--============================================================================
	-- 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (START)
	--============================================================================
	-- 20191002 KHSONG 주석처리 (BEGIN)
	/*
	  -- 기존로직
	SELECT *
	 INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM DM_MST_ITEM_SINGLE_V WITH(NOLOCK)
	  WHERE DIVISION_ID = @p_division_id
		--and CASE WHEN @p_item_id = ''			THEN @p_item_id			ELSE ITEM_ID			END  in  (SELECT DISTINCT token FROM dbo.String_Split(@p_item_id,','		))
	*/
	-- 20191002 KHSONG 주석처리 (END)

	--------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (START)
	--원소스 주석처리
	/*
	-----------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (BEGIN)
	-----------------------------------------------------------------------------------------

	SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME
		,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
		--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 START
		,ENERGE AS ENERGE_WH
		,CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (CONVERT(NUMERIC(15,3),ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 7))) ELSE NULL END AS ENERGE_KWH
		--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 END
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	 FROM
			(SELECT *
			FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
							ON	T2.ITEM_ID		like  b.tst
							OR	T2.NICK_NAME	like  b.tst
			  WHERE DIVISION_ID = @p_division_id
			) G
	GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME
		,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
		,ENERGE --[E20240731-000852]_ENERGE 컬럼 추가
	-----------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
	-----------------------------------------------------------------------------------------
	*/

	--> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
	INSERT INTO GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V
		( DIVISION_ID, ITEM_ID, ITEM_NAME, NICK_NAME, ITEM_TYPE, ITEM_CLASS, ITEM_CLASS_NAME
		, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE
		, CELL_QUANTITY, SCP_EXTRA_SPEC, CELL_TYPE, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION )
	SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, NICK_NAME, ITEM_TYPE, ITEM_CLASS, ITEM_CLASS_NAME
		 , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE
		 , CELL_QUANTITY, SCP_EXTRA_SPEC, CELL_TYPE, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
	FROM SCM_MST_ITEM_SN
	WHERE DIVISION_ID = p_division_id;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	INSERT INTO GT_DMF0042_DM_MST_ITEM_SINGLE_A_V
		( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
		, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE
		, CELL_QUANTITY, SCP_EXTRA_SPEC )
	SELECT T1.DIVISION_ID
		 , T1.ITEM_ID
		 , MAX(T1.ITEM_NAME)						AS ITEM_NAME
		 , MAX(T1.ITEM_CLASS)						AS ITEM_CLASS
		 , MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
		 , MAX(T1.NICK_NAME)						AS NICK_NAME
		 , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
						  WHEN T1.ITEM_TYPE = 'H' THEN 2
						  WHEN T1.ITEM_TYPE = 'Q' THEN 3
					 ELSE 4 END )
									WHEN 1 THEN 'P'
									WHEN 2 THEN 'H'
									WHEN 3 THEN 'Q'
									ELSE 'R' END	AS ITEM_TYPE
		 , MAX(T1.MATERIAL_CLASS_NAME)				AS MATERIAL_CLASS_NAME
		 , MAX(T1.ITEM_UOM)							AS ITEM_UOM
		 , MAX(T1.SPEC)								AS SPEC
		 , MAX(T1.MDM_PROJECT_NAME)					AS MDM_PROJECT_NAME
		 , MAX(T1.MIN_CAPACITY)						AS MIN_CAPACITY
		 , MAX(T1.ACTIVE_FLAG)						AS ACTIVE_FLAG
		 , MAX(T1.ENERGE)							AS ENERGE
		 , MAX(T1.CELL_QUANTITY)					AS CELL_QUANTITY
		 , MAX(T1.SCP_EXTRA_SPEC)					AS SCP_EXTRA_SPEC
	FROM GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V T1
	WHERE 1=1
	GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	INSERT INTO GT_DMF0042_DM_MST_ITEM_SINGLE_B_V
		( DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
		, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
	SELECT DIVISION_ID
		 , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
		 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
		 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
		 , MAX(CELL_TYPE) AS CELL_TYPE
	FROM GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V T2
	GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

	--TEMP 테이블에 넣은 데이터를 JOIN 한다.
	INSERT INTO GT_DMF0042_DM_MST_ITEM_SINGLE_V
		( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		, ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC, ENERGE_WH, ENERGE_KWH )
	SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		 , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
		 --------------------------------------------------------------------------------------------------
		 --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 START
		 , ENERGE AS ENERGE_WH
		 , CASE WHEN REGEXP_LIKE(ENERGE, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN ROUND(TO_NUMBER(ENERGE)/1000, 7) ELSE NULL END AS ENERGE_KWH
		 --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 END
		 --------------------------------------------------------------------------------------------------
	FROM
	( SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
		   , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE
		   , T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC
		   , T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
		FROM GT_DMF0042_DM_MST_ITEM_SINGLE_A_V T1
		INNER JOIN GT_DMF0042_DM_MST_ITEM_SINGLE_B_V T2
				ON T1.DIVISION_ID = T2.DIVISION_ID
			   AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
		INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_item_id,'%'),',')) ) b
				ON	T1.ITEM_ID		like  b.tst
				OR	T1.NICK_NAME	like  b.tst
		WHERE 1=1
	) T2
	GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		   , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		   , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC;

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (END)
	--------------------------------------------------------------------------------------------------

	/* 원본 CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON #TEMP_DM_MST_ITEM_SINGLE_V (DIVISION_ID, ITEM_ID)
	   → GTT 인덱스는 배포 시점(GTT DDL)에서 처리. 본문 인덱스 생성 제거. */
	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A004-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--============================================================================
	-- 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
	--============================================================================
	--============================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	--============================================================================
	INSERT INTO GT_DMF0042_SCM_MST_SSO_USER_INFO ( USER_ID, DEPT_ID )
	SELECT USER_ID, DEPT_ID
	FROM SCM_MST_SSO_USER_INFO
	ORDER BY USER_ID;

	-- 2020.4.23 속도문제로 쿼리 변경
	-- ※ 타깃 Oracle SCM_MST_SITE_ITEM 은 MSSQL 과 컬럼 구성이 다름(REPORT_GROUP1~8/CUST_ENG_NM 등 없음).
	--    하위에서 SI 가 사용하는 컬럼만으로 한정 적재. REPORT_GROUP1~8 은 타깃에 없어 NULL 대체(TODO/이슈).
	INSERT INTO GT_DMF0042_SCM_MST_SITE_ITEM
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CURRENCY, APPLICATION, CUST_GROUP, CUST_GROUP_DTL, ROUTE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, OWNER
		, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8
		, OWNER_NAME, OWNER_NAME_KO, DEPT_ID, EDIT_FLAG )
	SELECT SMSI.DIVISION_ID, SMSI.PROJECT_CODE, SMSI.SCM_SITE_ID, SMSI.ITEM_ID, SMSI.CURRENCY, SMSI.APPLICATION, SMSI.CUST_GROUP, SMSI.CUST_GROUP_DTL, SMSI.ROUTE
		 , SMSI.ATTRIBUTE1, SMSI.ATTRIBUTE2, SMSI.ATTRIBUTE5, SMSI.OWNER
		 /* TODO: REPORT_GROUP1~8 가 타깃 SCM_MST_SITE_ITEM 에 없어 NULL 대체 — 실제 소스 컬럼 확인 필요 */
		 , CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR))
		 , CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR)), CAST(NULL AS VARCHAR2(300 CHAR))
		 , FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' )                AS OWNER_NAME
		 , FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
		 ,( SELECT SU.DEPT_ID  FROM GT_DMF0042_SCM_MST_SSO_USER_INFO SU  WHERE UPPER(SU.USER_ID)
			= UPPER((SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(SMSI.OWNER, ',')) WHERE ROWNUM = 1)) ) DEPT_ID   -- [대소문자] MSSQL CI 비교 재현: USER_ID 매칭 시 UPPER 양변 적용
		 , SMSI.SALES_PLAN_ADJUST_YN AS EDIT_FLAG
	FROM SCM_MST_SITE_ITEM SMSI
	WHERE SMSI.DIVISION_ID = p_division_id;

	--============================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
	--============================================================================

	/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
	   과거 구간은 전체 Data가 포함되어야 함.
	   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
	   단위 환산이 되어야 함.
	*/

	INSERT INTO GT_DMF0042_SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, MEASURE, SORT_ORDER_NO )
	SELECT U.PROGRAM_ID, U.SHEET_NAME--, U.USER_ID
		 , U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO
	FROM SCM_MST_SHEET_MEASURE U
	WHERE 1 = 1
	--AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	AND U.PROGRAM_ID = p_program_id
	AND ( U.DIVISION_ID IS NULL OR U.DIVISION_ID LIKE '%' || p_division_id || '%' );  -- [2026-07-15 사용자 확정] DIVISION_ID NULL = 전 division 표기 대상 (SHEET_MEASURE NULL 5행 탈락 결함 수정)
	--AND U.USER_ID      = @p_created_by
	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A005-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--============================================================================
	-- (1) DM_PLN_BP_FCST
	--============================================================================
	IF p_division_id = '40' THEN
		INSERT INTO GT_DMF0042_RAW_DATA
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER40--,A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS  -- [PJ20200138] Incoterms 삭제
			 --,A.INCOTERMS AS INCOTERMS82 -- [PJ20200138] Incoterms 삭제
			 --,A.DOM_EXP
			 , A.FCST_TYPE, A.MEASURE
			 --[E20240731-000845]_조회당시 코드값으로 넘기도록 수정(원소스 주석처리)
			 --,LK1.ATTRIBUTE1 AS CELL_PROD_SITE
			 , LK1.SEGMENT1 AS CELL_PROD_SITE, 'M_' || A.YYYYMM AS COLNAME, SM.SORT_ORDER_NO
			 , CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ, CAL.CALENDAR_YYYY AS CALENDAR_YYYY
			 , A.YYYYMM, A.QTY
			 , CASE WHEN RTRIM(A.CURRENCY) IS NULL THEN SI.CURRENCY ELSE NVL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY   -- 원본 A.CURRENCY = '' (빈문자/공백 → RTRIM IS NULL)
			 , ISV.FORECAST_INFO_CELL_PACK_COUNT
			 , ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40
			 --,A.BIZ_TYPE AS BIZ_TYPE_NAME40
			 , ( SELECT LMD.SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD
				 WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
			 , ISV.ITEM_CLASS_NAME AS ITEM_CLASS_NAME, ISV.ITEM_NAME AS ITEM_NAME
			 , ISV.ITEM_TYPE AS ITEM_TYPE, ISV.NICK_NAME AS NICK_NAME
			 , ISV.MIN_CAPACITY
			 --,CASE WHEN ISV.ITEM_ID IS NULL THEN 'N' WHEN isnull(SI.EDIT_FLAG,'')  = 'N' THEN 'N' ELSE 'Y' END + '_'   +
			 , CASE WHEN ( CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END ) = v_dept_id THEN 'Y'
					WHEN v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG
			 , SI.APPLICATION, SI.CUST_GROUP, SI.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL, SI.OWNER_NAME OWNER
			 --,CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE S.DEPT_ID END AS DEPT_ID
			 --[PJ2024-50461] Team Mapping------------------------------------
			 --,A.DEPT_ID  AS DEPT_ID
			 , SI.DEPT_ID  AS DEPT_ID
			 --[PJ2024-50461] Team Mapping------------------------------------
			 , S.VMI_YN, SI.ROUTE, ISV.FORECAST_INFO_PRODUCT_GROUP, ISV.FORECAST_INFO_SPEC || ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
			 , ISV.FORECAST_INFO_SPEC, ISV.FORECAST_INFOR_VERSION, ISV.MDM_PROJECT_NAME, SI.CUST_GROUP_DTL
			 , SI.ATTRIBUTE1 AS DMS_SALES, SI.ATTRIBUTE2 AS DMS_CUSTOMER
			 --,MP.BIZ_TYPE as BIZ_TYPE_NAME
			 , A.PROJECT_NAME, '' AS PROJECT_OWNER, '' AS PROJECT_STATUS, A.END_CUSTOMER, S.CITY_NAME, S.COUNTRY_NAME
			 --,A.INCOTERMS AS INCOTERMS40		-- 20190513 -- [PJ20200138] Incoterms 삭제
			 , A.FCST_TYPE AS FCST_TYPE40		-- 20190513
			 --,A.DOM_EXP AS DOM_EXP40			-- 20190513
			 , SI.REPORT_GROUP1, SI.REPORT_GROUP2, SI.REPORT_GROUP3, SI.REPORT_GROUP4, SI.REPORT_GROUP5, SI.REPORT_GROUP6
			 , SI.REPORT_GROUP7, SI.REPORT_GROUP8
			 -- 201990826
			 , A.BIZ_TYPE AS BIZ_TYPE_NAME81, A.PROJECT_CODE AS PROJECT_CODE82, A.BIZ_TYPE AS BIZ_TYPE_NAME82
			 , A.ITEM_ID AS ITEM_ID40, A.SCM_SITE_ID AS SCM_SITE_ID40, A.SCM_SITE_ID AS SCM_SITE_ID81
			 , A.SCM_SITE_ID AS SCM_SITE_ID82 --,A.CELL_PER_PACK--,A.CELL_PER_MODULE--,A.MODULE_PER_PACK
			 , SI.DEPT_ID AS DEPT_ID40
			 -- 201990826
			 , '' AS PRODUCT_GROUP_NAME, A.ITEM_USE  -- [PJ20200138] item_use, unit_energy 추가
			 , A.UNIT_ENERGY, 0 AS CELL_PER_CAR, 0 AS MODULE_PER_CAR, ISV.ENERGE_WH	--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
			 , ISV.ENERGE_KWH --[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
		FROM DM_PLN_BP_FCST A
		INNER JOIN SCM_MST_SITE S1
				ON A.DIVISION_ID = S1.DIVISION_ID AND A.SCM_SITE_ID = S1.SCM_SITE_ID
			 --AND S1.VALID_YN	  = 'Y'	-- [c20200722-000060]
		INNER JOIN SCM_MST_SITE_ITEM S2
				ON A.DIVISION_ID = S2.DIVISION_ID AND A.PROJECT_CODE = S2.PROJECT_CODE
				AND A.SCM_SITE_ID = S2.SCM_SITE_ID AND A.ITEM_ID = S2.ITEM_ID
			  --AND S2.VALID_YN			= 'Y'	--[c20200722-000060]
		INNER JOIN GT_DMF0042_DM_MST_ITEM_SINGLE_V ISV
				ON A.DIVISION_ID = ISV.DIVISION_ID AND A.ITEM_ID = ISV.ITEM_ID
		LEFT JOIN GT_DMF0042_SCM_MST_SITE_ITEM SI
			   ON A.DIVISION_ID	= SI.DIVISION_ID AND A.SCM_SITE_ID = SI.SCM_SITE_ID
			  AND A.PROJECT_CODE = SI.PROJECT_CODE AND A.ITEM_ID = SI.ITEM_ID
			--AND SI.VALID_YN			= 'Y'	--[c20200722-000060]
		LEFT JOIN (	SELECT X.DIVISION_ID, X.SOLDTO_CUSTOMER, X.END_CUSTOMER, X.DEPT_ID, X.SCM_SITE_ID, X.VMI_YN, X.VALID_YN, Y.CITY_NAME, Z.COUNTRY_NAME
					FROM SCM_MST_SITE X, SCM_MST_CITY Y, SCM_MST_COUNTRY Z
					WHERE X.CITY = Y.CITY AND X.COUNTRY = Z.COUNTRY	) S
			   ON A.DIVISION_ID	= S.DIVISION_ID
			  AND A.SCM_SITE_ID	= S.SCM_SITE_ID
			--AND S.VALID_YN			= 'Y'	--[c20200722-000060]
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON A.CELL_PROD_SITE = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'DM_CELL_PROD_SITE'
		-------------------------- Project 조건 ------------------------------------------------------
		INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_project_code,'%'),',')) ) b1
		ON      CASE WHEN p_project_code IS NULL THEN '%'
	    			ELSE A.PROJECT_CODE  END like  b1.tst
			OR   CASE WHEN p_project_code IS NULL THEN '%'
					ELSE A.PROJECT_NAME  END like  b1.tst
		-----------------------------------------------------------------------------------------------
		-------------------------- Model 조건 ---------------------------------------------------------
		INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_item_id,'%'),',')) ) b2
		ON      CASE WHEN p_item_id IS NULL THEN '%'
					ELSE A.ITEM_ID  END like  b2.tst
			OR   CASE WHEN p_item_id IS NULL THEN '%'
					ELSE ISV.NICK_NAME  END like  b2.tst
		-----------------------------------------------------------------------------------------------
		-------------------------- Owner 조건 ---------------------------------------------------------
		INNER JOIN ( SELECT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_owner,'%'),',')) ) b3
		ON      CASE WHEN p_owner IS NULL THEN '%'
					ELSE SI.OWNER         END like  b3.tst
			OR   CASE WHEN p_owner IS NULL THEN '%'
					ELSE SI.OWNER_NAME    END like  b3.tst
			OR   CASE WHEN p_owner IS NULL THEN '%'
					ELSE SI.OWNER_NAME_KO END like  b3.tst
		-----------------------------------------------------------------------------------------------
		INNER JOIN GT_DMF0042_SELECT_MEASURE SM
				ON SM.MEASURE = A.MEASURE
		INNER JOIN ( SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM
					 FROM SCM_SYS_CALENDAR_M
					 WHERE ( BASIS_YYYYMM >= v_from_yyyymmdd AND BASIS_YYYYMM <= v_to_yyyymmdd )
					 GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) CAL
				ON CAL.BASIS_YYYYMM = A.YYYYMM
		WHERE 1=1
		AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
					ELSE CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
			END IN ( SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_dept_id,',')) P WHERE
							(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE
								CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
							END) = P.COLUMN_VALUE
							)
		AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   			ELSE NVL(
					CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
					,NULL)
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_end_customer,',')) P WHERE
					(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
						CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
					,NULL) END) = P.COLUMN_VALUE
					)
		AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   			ELSE A.SCM_SITE_ID
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_scm_site_id,',')) P WHERE
					(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.COLUMN_VALUE
					)
		AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL'
		   			ELSE A.PLANT_SITE_ID
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_plant_site_id,',')) P WHERE
					(CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.COLUMN_VALUE
					)
		AND CASE WHEN p_item_type = 'ALL' THEN 'ALL'
		   			ELSE ISV.ITEM_TYPE
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_item_type,',')) P WHERE
					(CASE WHEN p_item_type = 'ALL' THEN 'ALL' ELSE ISV.ITEM_TYPE END) = P.COLUMN_VALUE
					)
		AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'
		   			ELSE
					CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
			END IN (
					SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_biztype,',')) P WHERE
					(CASE WHEN p_biztype = 'ALL' THEN 'ALL' ELSE
					CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
					END) = P.COLUMN_VALUE
					)
		AND (A.YYYYMM >= v_from_yyyymmdd AND A.YYYYMM <= v_to_yyyymmdd)
		AND A.DIVISION_ID = p_division_id
				--AND A.MEASURE IN ('Business_Plan','KRW','USD','LOC','SalesAmt_KRW','SalesAmt_USD','SalesAmt_LOC')
				--and A.currency = 'KRW'
				;

		DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A006-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	ELSE
			INSERT INTO GT_DMF0042_RAW_DATA
				 ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER40, PLANT_SITE_ID, ITEM_ID
				 , INCOTERMS, FCST_TYPE, MEASURE, CELL_PROD_SITE, COLNAME
				 , SORT_ORDER_NO, CALENDAR_YYYYQQ, CALENDAR_YYYY, YYYYMM, QTY
				 , CURRENCY, FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE_NAME40, CELL_TYPE, ITEM_CLASS_NAME
				 , ITEM_NAME, ITEM_TYPE, NICK_NAME, MIN_CAPACITY, EDIT_FLAG

				 , APPLICATION, CUST_GROUP
				 , FORECAST_INFO_CELL_MODEL
				 , OWNER
				 , DEPT_ID
				 , VMI_YN, ROUTE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
				 , FORECAST_INFOR_VERSION, MDM_PROJECT_NAME, CUST_GROUP_DTL, DMS_SALES, DMS_CUSTOMER

				 , PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS, END_CUSTOMER, CITY_NAME
				 , COUNTRY_NAME, FCST_TYPE40, REPORT_GROUP1, REPORT_GROUP2

				 , REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7
				 , REPORT_GROUP8, BIZ_TYPE_NAME81, PROJECT_CODE82, BIZ_TYPE_NAME82, ITEM_ID40
				 , SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PRODUCT_GROUP_NAME
				 , ITEM_USE, UNIT_ENERGY, CELL_PER_CAR, MODULE_PER_CAR
				 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
				 , ENERGE_WH, ENERGE_KWH
				 )
			SELECT
				A.DIVISION_ID
				,A.PROJECT_CODE
				,A.PROJECT_CODE AS END_CUSTOMER40
				--,A.SCM_SITE_ID
				,A.PLANT_SITE_ID
				,A.ITEM_ID
				,A.INCOTERMS -- [PJ20200138] Incoterms 삭제
				--,A.INCOTERMS AS INCOTERMS82 -- [PJ20200138] Incoterms 삭제
				--,A.DOM_EXP
				,A.FCST_TYPE
				,A.MEASURE
				,A.CELL_PROD_SITE
				,'M_' || A.YYYYMM AS COLNAME
				,SM.SORT_ORDER_NO
				,CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ
				,CAL.CALENDAR_YYYY AS CALENDAR_YYYY
				,A.YYYYMM ,A.QTY
				,CASE WHEN RTRIM(A.CURRENCY) IS NULL THEN SI.CURRENCY ELSE NVL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY   -- 원본 A.CURRENCY = '' (빈문자/공백 → RTRIM IS NULL)
				,ISV.FORECAST_INFO_CELL_PACK_COUNT
				,ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40
				--,A.BIZ_TYPE AS BIZ_TYPE_NAME40
				,(SELECT LMD.SEGMENT2  AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
				,ISV.ITEM_CLASS_NAME AS ITEM_CLASS_NAME
				,ISV.ITEM_NAME AS ITEM_NAME
				,ISV.ITEM_TYPE AS ITEM_TYPE
				,ISV.NICK_NAME AS NICK_NAME
				,ISV.MIN_CAPACITY
				--,CASE WHEN ISV.ITEM_ID IS NULL THEN 'N' WHEN isnull(SI.EDIT_FLAG,'')  = 'N' THEN 'N' ELSE 'Y' END + '_'   +

				--[PJ2024-50461] Team Mapping------------------------------------
				/*,CASE WHEN ( CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END ) = @v_dept_id THEN 'Y'
						WHEN @v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG*/
				,CASE WHEN SI.DEPT_ID = v_dept_id THEN 'Y'
										WHEN v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG
				--[PJ2024-50461] Team Mapping------------------------------------
				,SI.APPLICATION
				,SI.CUST_GROUP
				,SI.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL
				,SUBSTR(SI.OWNER_NAME, 1, 100) AS OWNER
				--------,CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE S.DEPT_ID END AS DEPT_ID

				--[PJ2024-50461] Team Mapping------------------------------------
				--,A.DEPT_ID  AS DEPT_ID
				,SI.DEPT_ID AS DEPT_ID
				--[PJ2024-50461] Team Mapping------------------------------------

				,S.VMI_YN
				,SI.ROUTE
				,ISV.FORECAST_INFO_PRODUCT_GROUP
				,ISV.FORECAST_INFO_SPEC||ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
				,ISV.FORECAST_INFO_SPEC
				,ISV.FORECAST_INFOR_VERSION
				,ISV.MDM_PROJECT_NAME
				,SI.CUST_GROUP_DTL
				,SI.attribute1 DMS_SALES
				,SI.attribute2 DMS_CUSTOMER
							----,MP.BIZ_TYPE as BIZ_TYPE_NAME
				,CASE WHEN MP.PROJECT_NAME IS NULL THEN A.PROJECT_NAME ELSE MP.PROJECT_NAME END PROJECT_NAME
				,MP.PROJECT_OWNER
				,MP.PROJECT_STATUS
				,A.END_CUSTOMER
				,S.CITY_NAME
				,S.COUNTRY_NAME
				--,A.INCOTERMS AS INCOTERMS40		-- 20190513 -- [PJ20200138] Incoterms 삭제
				,A.FCST_TYPE AS FCST_TYPE40		-- 20190513
				--,A.DOM_EXP AS DOM_EXP40			-- 20190513
				,SI.REPORT_GROUP1
				,SI.REPORT_GROUP2
				,SI.REPORT_GROUP3
				,SI.REPORT_GROUP4
				,SI.REPORT_GROUP5
				,SI.REPORT_GROUP6
				,SI.REPORT_GROUP7
				,SI.REPORT_GROUP8
				-- 201990826
				,A.BIZ_TYPE as BIZ_TYPE_NAME81
				,A.PROJECT_CODE AS PROJECT_CODE82
				,A.BIZ_TYPE AS BIZ_TYPE_NAME82
				,A.ITEM_ID AS ITEM_ID40
				,A.SCM_SITE_ID AS SCM_SITE_ID40
				,A.SCM_SITE_ID AS SCM_SITE_ID81
				,A.SCM_SITE_ID AS SCM_SITE_ID82
				--,A.CELL_PER_PACK
				--,A.CELL_PER_MODULE
				--,A.MODULE_PER_PACK
				,SI.DEPT_ID AS DEPT_ID40
				-- 201990826
				,MP.PRODUCT_GROUP_NAME
				,A.ITEM_USE  -- [PJ20200138] item_use, unit_energy 추가
				,A.UNIT_ENERGY
				,NVL(S2.CELL_PER_CAR, 0) AS CELL_PER_CAR
				,NVL(S2.CELL_PER_CAR / S2.CELL_PER_MODULE, 0) AS MODULE_PER_CAR
				,ISV.ENERGE_WH			--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
				,ISV.ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
			FROM DM_PLN_BP_FCST A
				LEFT JOIN SCM_MST_SITE S1
					ON (A.DIVISION_ID		= S1.DIVISION_ID
					AND A.SCM_SITE_ID		= S1.SCM_SITE_ID
					--AND S1.VALID_YN	  = 'Y'	--[c20200722-000060]
					)
				LEFT JOIN SCM_MST_SITE_ITEM S2
					ON (A.DIVISION_ID		= S2.DIVISION_ID
					AND A.PROJECT_CODE		= S2.PROJECT_CODE
					AND A.SCM_SITE_ID		= S2.SCM_SITE_ID
					AND A.ITEM_ID			= S2.ITEM_ID
					--AND S2.VALID_YN			= 'Y' --[c20200722-000060]
					)
				LEFT JOIN GT_DMF0042_DM_MST_ITEM_SINGLE_V ISV
					ON A.DIVISION_ID		= ISV.DIVISION_ID
					AND A.ITEM_ID			= ISV.ITEM_ID
				LEFT JOIN GT_DMF0042_SCM_MST_SITE_ITEM SI
					 ON A.DIVISION_ID		= SI.DIVISION_ID
					AND A.SCM_SITE_ID		= SI.SCM_SITE_ID
					AND A.PROJECT_CODE		= SI.PROJECT_CODE
					AND A.iTEM_ID			= SI.ITEM_ID
					--AND SI.VALID_YN			= 'Y'	-- [c20200722-000060]
				LEFT JOIN SCM_MST_PROJECT MP
					ON A.DIVISION_ID		= MP.DIVISION_ID
					AND A.PROJECT_CODE		= MP.PROJECT_CODE
				LEFT JOIN (
							SELECT X.DIVISION_ID,X.SOLDTO_CUSTOMER, X.END_CUSTOMER, X.DEPT_ID, X.SCM_SITE_ID, X.VMI_YN, X.VALID_YN, Y.CITY_NAME, Z.COUNTRY_NAME
							FROM SCM_MST_SITE X, SCM_MST_CITY Y, SCM_MST_COUNTRY z
							WHERE x.city = y.city  and x.country = z.country
						) S
					ON A.DIVISION_ID		= S.DIVISION_ID
					AND A.SCM_SITE_ID		= S.SCM_SITE_ID
					--AND S.VALID_YN			= 'Y'	-- [c20200722-000060]
				-------------------------- Project 조건 ------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_project_code,'%'),',')) ) b1
				ON      CASE WHEN p_project_code IS NULL THEN '%'
	    					ELSE A.PROJECT_CODE  END like  b1.tst
					OR   CASE WHEN p_project_code IS NULL THEN '%'
							ELSE A.PROJECT_NAME  END like  b1.tst
				-----------------------------------------------------------------------------------------------
				-------------------------- Model 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_item_id,'%'),',')) ) b2
				ON      CASE WHEN p_item_id IS NULL THEN '%'
							ELSE A.ITEM_ID  END like  b2.tst
					OR   CASE WHEN p_item_id IS NULL THEN '%'
							ELSE ISV.NICK_NAME  END like  b2.tst
				-----------------------------------------------------------------------------------------------
				-------------------------- Owner 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT '%'||TOKEN||'%' tst FROM TABLE(FN_STRING_SPLIT(NVL(p_owner,'%'),',')) ) b3
				ON      CASE WHEN p_owner IS NULL THEN '%'
							ELSE SI.OWNER         END like  b3.tst
					OR   CASE WHEN p_owner IS NULL THEN '%'
							ELSE SI.OWNER_NAME    END like  b3.tst
					OR   CASE WHEN p_owner IS NULL THEN '%'
							ELSE SI.OWNER_NAME_KO END like  b3.tst
				-----------------------------------------------------------------------------------------------
				INNER JOIN GT_DMF0042_SELECT_MEASURE SM
				ON SM.MEASURE = A.MEASURE
				INNER JOIN (SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM
					FROM SCM_SYS_CALENDAR_M
					WHERE (BASIS_YYYYMM >= v_from_yyyymmdd AND BASIS_YYYYMM <= v_to_yyyymmdd)
					GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) CAL
				ON CAL.BASIS_YYYYMM = A.YYYYMM
			WHERE 1=1
			--[PJ2024-50461] Team Mapping------------------------------------
				AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
							ELSE SI.DEPT_ID
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_dept_id,',')) P WHERE
							(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE
								SI.DEPT_ID
							END) = P.COLUMN_VALUE
							)
/*
				AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
							ELSE CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
					END IN (
							Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where
							(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE
								CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
							END) = P.data
							)
*/
				--[PJ2024-50461] Team Mapping------------------------------------

				AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   						ELSE NVL(
							CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							,NULL)
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_end_customer,',')) P WHERE
							(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
								CASE WHEN p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							,NULL) END) = P.COLUMN_VALUE
							)
				AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   						ELSE A.SCM_SITE_ID
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_scm_site_id,',')) P WHERE
							(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.COLUMN_VALUE
							)
				AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL'
		   						ELSE A.PLANT_SITE_ID
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_plant_site_id,',')) P WHERE
							(CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.COLUMN_VALUE
							)
				AND CASE WHEN p_item_type = 'ALL' THEN 'ALL'
		   						ELSE ISV.ITEM_TYPE
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_item_type,',')) P WHERE
							(CASE WHEN p_item_type = 'ALL' THEN 'ALL' ELSE ISV.ITEM_TYPE END) = P.COLUMN_VALUE
							)
				AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'
		   						ELSE
							CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
					END IN (
							SELECT P.COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLITFORIN(p_biztype,',')) P WHERE
							(CASE WHEN p_biztype = 'ALL' THEN 'ALL' ELSE
							CASE WHEN p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
							END) = P.COLUMN_VALUE
							)
				AND (A.YYYYMM >= v_from_yyyymmdd and A.YYYYMM <= v_to_yyyymmdd)
				AND A.DIVISION_ID = p_division_id
                AND ( ( p_item_id IS NULL ) OR A.ITEM_ID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(p_item_id    ,','))) )
				--AND A.MEASURE IN ('Business_Plan','KRW','USD','LOC','SalesAmt_KRW','SalesAmt_USD','SalesAmt_LOC')
				--and A.currency = 'KRW'
		     ;

	END IF;

	IF p_qty_yn = 'Y' THEN
		DELETE FROM GT_DMF0042_DLT_ITEM_ID;

		INSERT INTO GT_DMF0042_DLT_ITEM_ID
			( DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
			, MEASURE, ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
			, INCOTERMS, CURRENCY, CELL_PROD_SITE
			--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
			, ENERGE_WH, ENERGE_KWH )
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.FCST_TYPE, A.PLANT_SITE_ID, A.DEPT_ID, A.END_CUSTOMER
			 , A.MEASURE, A.ITEM_ID40, A.SCM_SITE_ID40, A.SCM_SITE_ID81, A.SCM_SITE_ID82, A.DEPT_ID40, A.PROJECT_CODE82, A.END_CUSTOMER40, A.FCST_TYPE40
			 , A.INCOTERMS, A.CURRENCY, A.CELL_PROD_SITE
			 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
			 , A.ENERGE_WH, A.ENERGE_KWH
		FROM GT_DMF0042_RAW_DATA A
		INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
						  , ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
						  , INCOTERMS, CURRENCY, CELL_PROD_SITE
					 FROM GT_DMF0042_RAW_DATA
					 WHERE MEASURE = 'Business_Plan'
					 GROUP BY DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
					 	    , ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
					 	    , INCOTERMS, CURRENCY, CELL_PROD_SITE
					 HAVING SUM(QTY) = 0) B
				 ON A.DIVISION_ID		= B.DIVISION_ID
				AND A.PROJECT_CODE		= B.PROJECT_CODE
				AND A.ITEM_ID			= B.ITEM_ID
				AND A.FCST_TYPE			= B.FCST_TYPE
				AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
				AND A.DEPT_ID			= B.DEPT_ID
				AND A.ITEM_ID40			= B.ITEM_ID40
				AND A.SCM_SITE_ID40		= B.SCM_SITE_ID40
				AND A.SCM_SITE_ID81		= B.SCM_SITE_ID81
				AND A.SCM_SITE_ID82		= B.SCM_SITE_ID82
				AND A.DEPT_ID40			= B.DEPT_ID40
				AND A.PROJECT_CODE82	= B.PROJECT_CODE82
				AND A.END_CUSTOMER40	= B.END_CUSTOMER40
				AND A.FCST_TYPE40		= B.FCST_TYPE40
				AND A.INCOTERMS			= B.INCOTERMS
				AND A.CURRENCY			= B.CURRENCY
				AND A.CELL_PROD_SITE	= B.CELL_PROD_SITE;

		-- 원본 DELETE A FROM #RAW_DATA A INNER JOIN #DLT_ITEM_ID B → Oracle: EXISTS 서브쿼리
		DELETE FROM GT_DMF0042_RAW_DATA A
		WHERE EXISTS ( SELECT 1 FROM GT_DMF0042_DLT_ITEM_ID B
					   WHERE A.DIVISION_ID		= B.DIVISION_ID
						 AND A.PROJECT_CODE		= B.PROJECT_CODE
						 AND A.ITEM_ID			= B.ITEM_ID
						 AND A.FCST_TYPE		= B.FCST_TYPE
						 AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
						 AND A.DEPT_ID			= B.DEPT_ID
						 AND A.END_CUSTOMER		= B.END_CUSTOMER
						 AND A.ITEM_ID40		= B.ITEM_ID40
						 AND A.SCM_SITE_ID40	= B.SCM_SITE_ID40
						 AND A.SCM_SITE_ID81	= B.SCM_SITE_ID81
						 AND A.SCM_SITE_ID82	= B.SCM_SITE_ID82
						 AND A.DEPT_ID40		= B.DEPT_ID40
						 AND A.PROJECT_CODE82	= B.PROJECT_CODE82
						 AND A.END_CUSTOMER40	= B.END_CUSTOMER40
						 AND A.FCST_TYPE40		= B.FCST_TYPE40
						 AND A.INCOTERMS		= B.INCOTERMS
						 AND A.CURRENCY			= B.CURRENCY
						 AND A.CELL_PROD_SITE	= B.CELL_PROD_SITE );
	END IF;

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A007-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- 분기 합계 → #RAW_DATA_SUM
	INSERT INTO GT_DMF0042_RAW_DATA_SUM
		( DIVISION_ID, PROJECT_CODE, END_CUSTOMER40, PLANT_SITE_ID, ITEM_ID, INCOTERMS, FCST_TYPE, MEASURE, CELL_PROD_SITE, COLNAME
		, SORT_ORDER_NO, CALENDAR_YYYYQQ, CALENDAR_YYYY, YYYYMM, QTY, CURRENCY, FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE_NAME40
		, CELL_TYPE, ITEM_CLASS_NAME, ITEM_NAME, ITEM_TYPE, NICK_NAME, MIN_CAPACITY, EDIT_FLAG, APPLICATION, CUST_GROUP
		, FORECAST_INFO_CELL_MODEL, OWNER, DEPT_ID, VMI_YN, ROUTE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
		, FORECAST_INFOR_VERSION, MDM_PROJECT_NAME, CUST_GROUP_DTL, DMS_SALES, DMS_CUSTOMER, PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS
		, END_CUSTOMER, CITY_NAME, COUNTRY_NAME, FCST_TYPE40, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5
		, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8, BIZ_TYPE_NAME81, PROJECT_CODE82, BIZ_TYPE_NAME82, ITEM_ID40, SCM_SITE_ID40
		, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PRODUCT_GROUP_NAME, ITEM_USE, UNIT_ENERGY, CELL_PER_CAR, MODULE_PER_CAR, ENERGE_WH, ENERGE_KWH )
	SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER40--,X.SCM_SITE_ID
		 , X.PLANT_SITE_ID, X.ITEM_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제--,X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제--,X.DOM_EXP
		 , X.FCST_TYPE, X.MEASURE, X.CELL_PROD_SITE, 'Q_' || REPLACE(X.CALENDAR_YYYYQQ, 'Q', '_') AS COLNAME
		 , X.SORT_ORDER_NO, X.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ, X.CALENDAR_YYYY,  X.CALENDAR_YYYYQQ AS YYYYMM
		 --,CASE WHEN MEASURE = 'KRW' OR MEASURE = 'USD' OR MEASURE = 'LOC' OR MEASURE = 'Business_Plan'
		 , CASE WHEN X.MEASURE = 'SalesAmt_KRW' OR X.MEASURE = 'SalesAmt_LOC' OR X.MEASURE = 'SalesAmt_USD' OR X.MEASURE = 'Business_Plan'
				THEN SUM(X.QTY) ELSE MAX(X.QTY) END QTY
		 , X.CURRENCY
		 , MAX(X.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT, MAX(X.BIZ_TYPE_NAME40) AS BIZ_TYPE_NAME40
		 , MAX(X.CELL_TYPE) AS CELL_TYPE, MAX(X.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME, MAX(X.ITEM_NAME) AS ITEM_NAME
		 , MAX(X.ITEM_TYPE) AS ITEM_TYPE, MAX(X.NICK_NAME) AS NICK_NAME, MAX(X.MIN_CAPACITY) AS MIN_CAPACITY
		 , MAX(X.EDIT_FLAG) AS EDIT_FLAG, MAX(X.APPLICATION) AS APPLICATION, MAX(X.CUST_GROUP) AS CUST_GROUP
		 , MAX(X.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL, MAX(X.OWNER) AS OWNER, X.DEPT_ID AS DEPT_ID
		 , MAX(X.VMI_YN) AS VMI_YN, MAX(X.ROUTE) AS ROUTE, MAX(X.FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(X.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL, MAX(X.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(X.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION, MAX(X.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
		 , MAX(X.CUST_GROUP_DTL) AS CUST_GROUP_DTL, MAX(X.DMS_SALES) AS DMS_SALES, MAX(X.DMS_CUSTOMER) AS DMS_CUSTOMER--,MAX(X.BIZ_TYPE_NAME) BIZ_TYPE_NAME
		 , MAX(X.PROJECT_NAME) AS PROJECT_NAME, MAX(X.PROJECT_OWNER) AS PROJECT_OWNER, MAX(X.PROJECT_STATUS) AS PROJECT_STATUS
		 , MAX(X.END_CUSTOMER) AS END_CUSTOMER, MAX(X.CITY_NAME) AS CITY_NAME, MAX(X.COUNTRY_NAME) AS COUNTRY_NAME
		 --, MAX(X.INCOTERMS40) AS INCOTERMS40 		-- 20190513 -- [PJ20200138] Incoterms 삭제
		 , MAX(X.FCST_TYPE40) AS FCST_TYPE40		-- 20190513
		 --, MAX(X.DOM_EXP40) AS DOM_EXP40 			-- 20190513
		 , MAX(X.REPORT_GROUP1) AS REPORT_GROUP1, MAX(X.REPORT_GROUP2) AS REPORT_GROUP2, MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
		 , MAX(X.REPORT_GROUP4) AS REPORT_GROUP4, MAX(X.REPORT_GROUP5) AS REPORT_GROUP5, MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
		 , MAX(X.REPORT_GROUP7) AS REPORT_GROUP7, MAX(X.REPORT_GROUP8) AS REPORT_GROUP8
		 -- 201990826
		 , MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81, MAX(X.PROJECT_CODE82) AS PROJECT_CODE82, MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
		 , MAX(X.ITEM_ID40) AS ITEM_ID40, MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40, MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
		 , MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82--,MAX(X.CELL_PER_PACK) AS CELL_PER_PACK--,MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE--,MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK
		 , MAX(X.DEPT_ID40) AS DEPT_ID40
		 -- 201990826
		 , X.PRODUCT_GROUP_NAME, X.ITEM_USE, X.UNIT_ENERGY-- [PJ20200138] item_use, unit_energy 추가
		 , MAX(NVL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR
		 , MAX(NVL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (START)
		, X.ENERGE_WH, X.ENERGE_KWH
		 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (END)
	FROM GT_DMF0042_RAW_DATA X
	GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.PROJECT_NAME, X.END_CUSTOMER, X.END_CUSTOMER40, X.SCM_SITE_ID40, X.SCM_SITE_ID81
		   , X.SCM_SITE_ID82, X.PLANT_SITE_ID, X.ITEM_ID, X.ITEM_ID40, X.DEPT_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제--, X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제--, X.DOM_EXP
		   , X.FCST_TYPE, X.SORT_ORDER_NO, X.BIZ_TYPE_NAME40, X.BIZ_TYPE_NAME81, X.BIZ_TYPE_NAME82, X.CALENDAR_YYYY
		   , X.CALENDAR_YYYYQQ, X.CURRENCY, X.MEASURE, X.PRODUCT_GROUP_NAME,  X.ITEM_USE
		   , X.UNIT_ENERGY, X.CELL_PROD_SITE
		   --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (START)
		   , X.ENERGE_WH, X.ENERGE_KWH;
		   --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (END)

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A008-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- 연 합계 → #RAW_DATA_SUM 누적
	INSERT INTO GT_DMF0042_RAW_DATA_SUM
		( DIVISION_ID, PROJECT_CODE, END_CUSTOMER40, PLANT_SITE_ID, ITEM_ID, INCOTERMS, FCST_TYPE, MEASURE, CELL_PROD_SITE, COLNAME
		, SORT_ORDER_NO, CALENDAR_YYYYQQ, CALENDAR_YYYY, YYYYMM, QTY, CURRENCY, FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE_NAME40
		, CELL_TYPE, ITEM_CLASS_NAME, ITEM_NAME, ITEM_TYPE, NICK_NAME, MIN_CAPACITY, EDIT_FLAG, APPLICATION, CUST_GROUP
		, FORECAST_INFO_CELL_MODEL, OWNER, DEPT_ID, VMI_YN, ROUTE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
		, FORECAST_INFOR_VERSION, MDM_PROJECT_NAME, CUST_GROUP_DTL, DMS_SALES, DMS_CUSTOMER, PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS
		, END_CUSTOMER, CITY_NAME, COUNTRY_NAME, FCST_TYPE40, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5
		, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8, BIZ_TYPE_NAME81, PROJECT_CODE82, BIZ_TYPE_NAME82, ITEM_ID40, SCM_SITE_ID40
		, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PRODUCT_GROUP_NAME, ITEM_USE, UNIT_ENERGY, CELL_PER_CAR, MODULE_PER_CAR, ENERGE_WH, ENERGE_KWH )
	SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER40--,X.SCM_SITE_ID
		 , X.PLANT_SITE_ID, X.ITEM_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제
		 --,X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제
		 --,X.DOM_EXP
		 , X.FCST_TYPE, X.MEASURE, X.CELL_PROD_SITE, 'Y_' || X.CALENDAR_YYYY AS COLNAME
		 , X.SORT_ORDER_NO, X.CALENDAR_YYYY AS CALENDAR_YYYYQQ, X.CALENDAR_YYYY, X.CALENDAR_YYYY AS YYYYMM
		--,CASE WHEN MEASURE = 'KRW' OR MEASURE = 'USD' OR MEASURE = 'LOC' OR MEASURE = 'Business_Plan'
		 , CASE WHEN X.MEASURE = 'SalesAmt_KRW' OR X.MEASURE = 'SalesAmt_LOC' OR X.MEASURE = 'SalesAmt_USD' OR X.MEASURE = 'Business_Plan'
				THEN SUM(X.QTY) ELSE MAX(X.QTY) END QTY
		 , X.CURRENCY, MAX(X.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT, MAX(X.BIZ_TYPE_NAME40) AS BIZ_TYPE_NAME40
		, MAX(X.CELL_TYPE) AS CELL_TYPE, MAX(X.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME, MAX(X.ITEM_NAME) AS ITEM_NAME
		, MAX(X.ITEM_TYPE) AS ITEM_TYPE, MAX(X.NICK_NAME) AS NICK_NAME, MAX(X.MIN_CAPACITY) AS MIN_CAPACITY
		, MAX(X.EDIT_FLAG) AS EDIT_FLAG, MAX(X.APPLICATION) AS APPLICATION, MAX(X.CUST_GROUP) AS CUST_GROUP
		, MAX(X.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL, MAX(X.OWNER) AS OWNER, X.DEPT_ID AS DEPT_ID
		, MAX(X.VMI_YN) AS VMI_YN, MAX(X.ROUTE) ROUTE, MAX(X.FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		, MAX(X.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL, MAX(X.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		, MAX(X.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION, MAX(X.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME, MAX(X.CUST_GROUP_DTL) CUST_GROUP_DTL
		, MAX(X.DMS_SALES) AS DMS_SALES, MAX(X.DMS_CUSTOMER) AS DMS_CUSTOMER--,MAX(X.BIZ_TYPE_NAME) BIZ_TYPE_NAME
		, MAX(X.PROJECT_NAME) AS PROJECT_NAME, MAX(X.PROJECT_OWNER) AS PROJECT_OWNER, MAX(X.PROJECT_STATUS) AS PROJECT_STATUS
		, MAX(X.END_CUSTOMER) AS END_CUSTOMER, MAX(X.CITY_NAME) AS CITY_NAME, MAX(X.COUNTRY_NAME) AS COUNTRY_NAME--,MAX(X.INCOTERMS40)	INCOTERMS40 		-- 20190513 -- [PJ20200138] Incoterms 삭제
		, MAX(X.FCST_TYPE40) AS FCST_TYPE40-- 20190513--,MAX(X.DOM_EXP40)		DOM_EXP40 			-- 20190513
		, MAX(X.REPORT_GROUP1) AS REPORT_GROUP1, MAX(X.REPORT_GROUP2) AS REPORT_GROUP2, MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
		, MAX(X.REPORT_GROUP4) AS REPORT_GROUP4, MAX(X.REPORT_GROUP5) AS REPORT_GROUP5, MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
		, MAX(X.REPORT_GROUP7) AS REPORT_GROUP7, MAX(X.REPORT_GROUP8) AS REPORT_GROUP8
		-- 201990826
		, MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81, MAX(X.PROJECT_CODE82) AS PROJECT_CODE82, MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
		, MAX(X.ITEM_ID40) AS ITEM_ID40, MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40, MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
		, MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82
		--,MAX(X.CELL_PER_PACK) AS CELL_PER_PACK
		--,MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE
		--,MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK
		, MAX(X.DEPT_ID40) AS DEPT_ID40
		-- 201990826
		, X.PRODUCT_GROUP_NAME, X.ITEM_USE -- [PJ20200138] item_use, unit_energy 추가
		, X.UNIT_ENERGY, MAX(NVL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR, MAX(NVL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		, X.ENERGE_WH, X.ENERGE_KWH
	FROM GT_DMF0042_RAW_DATA X
	GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.PROJECT_NAME, X.END_CUSTOMER, X.END_CUSTOMER40, X.SCM_SITE_ID40
		   , X.SCM_SITE_ID81, X.SCM_SITE_ID82, X.PLANT_SITE_ID, X.ITEM_ID, X.ITEM_ID40, X.DEPT_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제--, X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제--, X.DOM_EXP
		   , X.FCST_TYPE, X.SORT_ORDER_NO, X.BIZ_TYPE_NAME40, X.BIZ_TYPE_NAME81, X.BIZ_TYPE_NAME82, X.CALENDAR_YYYY
		   , X.CALENDAR_YYYYQQ, X.CURRENCY, X.MEASURE, X.PRODUCT_GROUP_NAME, X.ITEM_USE
		   , X.UNIT_ENERGY, X.CELL_PROD_SITE
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		   , X.ENERGE_WH, X.ENERGE_KWH;

	-- ################ #RAW_DATA and Quarter&Year Sum ###########################

	INSERT INTO GT_DMF0042_RAW_DATA
	SELECT *
	FROM GT_DMF0042_RAW_DATA_SUM;

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A009-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	SELECT Count(*)
	INTO   v_i_count
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID  = p_program_id
	AND    U.SHEET_NAME  = 'Biz Plan'
	AND    U.USER_ID     = p_created_by
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

	--print @i_Count

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A0010-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	IF v_i_count = 0 THEN
		-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
		FOR rec IN ( SELECT C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
					 FROM SCM_MST_SHEET_COLUMNS C
					 WHERE 1 = 1
					   AND C.PROGRAM_ID  = p_program_id
					   AND C.SHEET_NAME  = 'Biz Plan'
					   AND ( C.DEFAULT_FLAG = 'Y' OR
							(    C.VISIBLE_FLAG = 'N'
							 AND RTRIM(C.DEFAULT_FLAG) IS NULL   -- 원본 C.DEFAULT_FLAG = '' (MSSQL 빈문자/후행공백 비교 → Oracle RTRIM IS NULL 로 보존)
							 AND C.VALID_YN     = 'Y'
							))
					 ORDER BY C.SORT_ORDER_NO ) LOOP
			v_ColList   := v_ColList   || '"' || rec.COLUMN_NAME || '",';
			v_GroupList := v_GroupList || '"' || rec.COLUMN_NAME || '" ' || rec.DATA_SORT_METHOD_CODE || ',';
		END LOOP;
	ELSE
		FOR rec IN ( SELECT COLUMN_NAME, DATA_SORT_METHOD_CODE
					 FROM (
						SELECT U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
						FROM   SCM_MST_TITLESET_USER U
							 , SCM_MST_SHEET_COLUMNS C
						WHERE  1 = 1
							AND U.PROGRAM_ID  = C.PROGRAM_ID
							AND U.SHEET_NAME  = C.SHEET_NAME
							AND U.COLUMN_NAME = C.COLUMN_NAME
							AND U.PROGRAM_ID  = p_program_id
							AND U.SHEET_NAME  = 'Biz Plan'
							AND U.USER_ID     = p_created_by
							AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
							AND p_division_id IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(C.DIVISION_ID ,',')) )
						UNION ALL
						SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE
						FROM (
							SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
							FROM   SCM_MST_SHEET_COLUMNS C
							WHERE  1 = 1
								AND C.PROGRAM_ID  = p_program_id
								AND C.SHEET_NAME  = 'Biz Plan'
								AND C.VISIBLE_FLAG = 'N'
								AND RTRIM(C.DEFAULT_FLAG) IS NULL   -- 원본 C.DEFAULT_FLAG = '' (MSSQL 빈문자/후행공백 비교 → Oracle RTRIM IS NULL 로 보존)
								AND C.VALID_YN     = 'Y'
								AND p_division_id IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(C.DIVISION_ID ,',')) )
						) WHERE ROWNUM <= 100
					 ) tbColList
					 ORDER BY SORT_ORDER_NO ) LOOP
			v_ColList   := v_ColList   || '"' || rec.COLUMN_NAME || '",';
			v_GroupList := v_GroupList || '"' || rec.COLUMN_NAME || '" ' || rec.DATA_SORT_METHOD_CODE || ',';
		END LOOP;
	END IF;

	v_ColList   := SUBSTR(v_ColList,   1, LENGTH(v_ColList)  - 1);
	v_GroupList := SUBSTR(v_GroupList, 1, LENGTH(v_GroupList)- 1);

	DBMS_OUTPUT.PUT_LINE('-------------2! : ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A010-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--	print  @ColList

	-- 5. 피벗 결과 내기위한 날짜 리스트.
	-- @Prod = '';
	FOR rec IN ( SELECT DISTINCT COLNAME FROM GT_DMF0042_RAW_DATA ORDER BY COLNAME ) LOOP
		v_Prod    := v_Prod    || '"' || rec.COLNAME || '",';
		v_Prod_in := v_Prod_in || '''' || rec.COLNAME || ''' AS "' || rec.COLNAME || '",';
	END LOOP;

	IF v_Prod IS NULL THEN
		v_Prod    := '"D_99999999"';
		v_Prod_in := '''D_99999999'' AS "D_99999999"';
	ELSE
		v_Prod    := SUBSTR(v_Prod,    1, LENGTH(v_Prod)   - 1);
		v_Prod_in := SUBSTR(v_Prod_in, 1, LENGTH(v_Prod_in)- 1);
	END IF;
	DBMS_OUTPUT.PUT_LINE('-------------3! : ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A011-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- 6. 최종 피벗 내기.
	-- MEASURE에 따른 앞에 SORT_ORDER_NO 위한 삽입
	v_ColList   := REPLACE(v_ColList,   '"MEASURE"', '"SORT_ORDER_NO","MEASURE"');
	v_GroupList := REPLACE(v_GroupList, '"MEASURE"', '"SORT_ORDER_NO","MEASURE"');
	--SELECT @GroupList = REPLACE(@GroupList,'[CELL_PER_PACK] ASC,[CELL_PER_MODULE] ASC,[MODULE_PER_PACK] ASC,', '')
	v_GroupList := REPLACE(v_GroupList, '"CELL_PER_CAR" ASC,"MODULE_PER_CAR" ASC,', '');
	--select @ColList
	--return(0)
	-- Temp Table 삭제
	--IF OBJECT_ID (N'dbo.TEMP_SKH_0326_SALES_PLAN_TOBE', N'U') IS NOT NULL
	--	DROP TABLE TEMP_SKH_0326_SALES_PLAN_TOBE
	--	;
	DBMS_OUTPUT.PUT_LINE('-------------4! : ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

	v_nsql2 := '
	SELECT
			 ' || v_ColList || '
			,' || v_Prod || '
			--INTO TEMP_SKH_0326_SALES_PLAN_TOBE
		From(
			--SELECT COLNAME, SUM(QTY) AS QTY, ' || v_ColList || '
			SELECT COLNAME, case when MEASURE in (''LOC'',''USD'',''KRW'') then MAX(QTY) else SUM(QTY) end AS QTY, ' || v_ColList || '  -- 20190108 KHSONG Unit Price 인경우는 SUM하지 않고 AVG로 표기함
			FROM GT_DMF0042_RAW_DATA
			GROUP BY COLNAME, ' || v_ColList || '
			) T
		PIVOT (MAX(QTY) FOR COLNAME IN (' || v_Prod_in || ')
		) PVT
		ORDER BY
				 ' || v_GroupList;

	DBMS_OUTPUT.PUT_LINE(p_program_id || ' : A012-- :' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--SELECT @GroupList
	--select @nsql2
	--select convert(text, @nsql2)
	--for xml path('')--,root('x')

	-- 동적 PIVOT 결과셋 반환 (원본 execute dbo.SP_executesql @NSQL2)
	OPEN p_cursor1 FOR v_nsql2;

	--중장기 계획 관련 날짜 취득
	BEGIN
		SELECT ATTRIBUTE1, ATTRIBUTE2, VALID_YN
		INTO   v_from_yyyymm, v_to_yyyymm, v_valid_yn
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
		WHERE A.LOOKUP_TYPE = 'DM_LONG_PLAN'
		AND A.SEGMENT1 = p_division_id
		AND A.SEGMENT2 = 'Biz Plan'
		AND A.VALID_YN = 'Y';
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;   -- 미존재 시 원본(@변수 미설정)과 동일하게 NULL 유지
	END;

	DBMS_OUTPUT.PUT_LINE(v_from_yyyymm);

	-- 중장기 계획 날짜 결과셋 반환
	OPEN p_cursor2 FOR
	SELECT v_valid_yn AS VALID_YN
		, v_from_yyyymm AS START_YYYYMM
	    , v_to_yyyymm AS END_YYYYMM
	    , MIN(A.START_YYYYQQ) AS START_YYYYQQ
	    , MAX(A.END_YYYYQQ) AS END_YYYYQQ
	    , MIN(A.START_YYYY) AS START_YYYY
	    , MAX(A.END_YYYY) AS END_YYYY
	FROM (
	    SELECT
	          MIN(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS START_YYYYQQ
	        , MAX(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS END_YYYYQQ
	        , TO_CHAR(NULL) AS START_YYYY   -- [Set Operator 타입일치] CALENDAR_YYYY 가 VARCHAR2 이므로 NULL 을 TO_CHAR 로 캐스팅 (ORA-01790 회피)
	        , TO_CHAR(NULL) AS END_YYYY
	    FROM SCM_SYS_CALENDAR_M A
	       , (
	            SELECT DISTINCT CALENDAR_YYYYQQ
	            FROM SCM_SYS_CALENDAR_M A
	            WHERE BASIS_YYYYMM <  v_from_yyyymm
	                OR BASIS_YYYYMM > v_to_yyyymm
	                ) B
	    WHERE A.CALENDAR_YYYYQQ = B.CALENDAR_YYYYQQ(+)   -- [C-261/2-526] Outer Join → (+) 전환 (anti-join: IS NULL 과 함께)
	        AND A.BASIS_YYYYMM BETWEEN v_from_yyyymm AND v_to_yyyymm
	        AND B.CALENDAR_YYYYQQ IS NULL
	    UNION ALL
	    SELECT
	          TO_CHAR(NULL) AS START_YYYYQQ
	        , TO_CHAR(NULL) AS END_YYYYQQ
	        , MIN(A.CALENDAR_YYYY) AS START_YYYY
	        , MAX(A.CALENDAR_YYYY) AS END_YYYY
	    FROM SCM_SYS_CALENDAR_M A
	       , (
	            SELECT DISTINCT CALENDAR_YYYY
	            FROM SCM_SYS_CALENDAR_M A
	            WHERE BASIS_YYYYMM <  v_from_yyyymm
	                OR BASIS_YYYYMM > v_to_yyyymm
	                ) B
	    WHERE A.CALENDAR_YYYY = B.CALENDAR_YYYY(+)   -- [C-261/2-526] Outer Join → (+) 전환 (anti-join: IS NULL 과 함께)
	        AND A.BASIS_YYYYMM BETWEEN v_from_yyyymm AND v_to_yyyymm
	        AND B.CALENDAR_YYYY IS NULL
	    ) A;

END P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA;


  PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF 
(
    -- Add the parameters for the stored procedure here
      p_division_id          IN  VARCHAR2      -- division_id 전달받음
    , p_version_description  IN  CLOB          -- description 전달받음
    , p_ver_type             IN  CLOB
    , p_created_by           IN  CLOB
    -- 원본 CATCH 의 에러메시지 SELECT 결과셋 반환 → SYS_REFCURSOR OUT (DBMS_SQL.RETURN_RESULT 금지)
    , p_cursor1              OUT SYS_REFCURSOR
)
/*
EXEC DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF_TOBE
*/

/*
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF
 * Description  : Business Plan DM_PLN_BP_FCST_C TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190410 KHSONG Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190617 KHSONG DM_BP_EXCHANGE_RATE => DM_BP_EXCHANGE_RATE_C (6/11 추가)
 * 2020/04/23	P.C.I    [PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/07/26	SJHAN	중장기계획 과제 관련 - SEQ 추가
 * 2022/04/12	rosia27		[과제PJ20216891R]GM_JV
 * 2022/06/10	rosia27		[C20220526-000090]Business Plan Waterfall 개발 요청의 건
 * 2022/06/21	rosia27		[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2026.06.02	ZIONEX			[PJ202650304] NextSCM Migration
 */
AS
    n_history_seq      INTEGER;
    -- LOG 용 변수 설정
    v_program_name VARCHAR2(150 CHAR) := 'DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF';
    v_log_type     VARCHAR2(30 CHAR);  -- START/END/ERROR/...
    n_log_count    INTEGER := 0;
    v_log_message  VARCHAR2(1000 CHAR);
    v_description  VARCHAR2(500 CHAR);
    d_event_date   DATE;

    --
    v_division_id          VARCHAR2(4000 CHAR);   -- 원본 NVARCHAR(MAX) (DIVISION_ID 컬럼 비교 위해 VARCHAR2 유지)
    v_ver_description      CLOB;
    v_ver_type             CLOB;
    v_created_by           CLOB;

    v_ver_return_no        VARCHAR2(100 CHAR);    -- cut off Generated Number
    v_cutoff_yyyymmdd      VARCHAR2(8 CHAR);      -- 원본 NVARCHAR(MAX) (CONVERT(CHAR(8)) 값 8자리)
    v_OK_description       VARCHAR2(1200 CHAR);   -- cut off Generated Number

    n_Seq_No               INTEGER := 0;

    v_err_display          VARCHAR2(4100 CHAR);   -- 에러메시지 DISPLAY 용 (SQLERRM 은 SQL 문 내 직접 사용 불가 → 변수로 받아 사용)
BEGIN
    -- SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET XACT_ABORT ON; -- MSSQL 세션설정, Oracle 불필요

    v_division_id       := NULL;
    v_ver_description   := NULL;
    v_ver_type          := NULL;
    v_created_by        := NULL;
    v_cutoff_yyyymmdd   := TO_CHAR(SYSDATE, 'YYYYMMDD');   -- CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)

    -- 시작 LOG  (START)
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    v_log_message := NULL;     /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)
    SAVEPOINT SAVE_DM_PLN_BP_FCST_CUTOFF;

    --------------------------------------------------------------------------------------------
    BEGIN
    --------------------------------------------------------------------------------------------
        v_ver_description  := p_version_description;
        v_ver_type         := 'BP_M';
        v_created_by       := p_created_by;

        v_division_id := p_division_id;

        PR_DM_PLN_VERSION_CREATE( v_division_id
                                , v_ver_description
                                , v_ver_type
                                , v_created_by
                                , v_ver_return_no
                                , v_OK_description );

        -- [DM_PLN_BP_FCST] -> [DM_PLN_BP_FCST_C]
        SELECT MAX(NVL(SEQ_NO,0)) + 1 INTO n_Seq_No FROM DM_PLN_BP_FCST_C A;
        BEGIN

            INSERT INTO DM_PLN_BP_FCST_C
                 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                 , PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
                 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                 , PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
                 , YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY --[PJ20200138] item_use, unit_energy 추가
                 , QTY, CELL_PER_PACK
                 , CELL_PER_MODULE, MODULE_PER_PACK, CREATED_BY, CREATION_DATE
                 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
                 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
                 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, SEQ_NO, CELL_PROD_SITE )
            -- [NOT NULL 문자컬럼] 소스 NULL(=MSSQL '')은 '-' 치환(NVL). 검증 시 '' 와 '-' 동일 간주.
            SELECT NVL(A.DIVISION_ID,'-'), v_ver_return_no AS VERSION_NO, v_ver_type AS CUTOFF_TYPE, v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                 , NVL(A.PROJECT_CODE,'-'), A.PROJECT_NAME, NVL(A.SCM_SITE_ID,'-'), NVL(A.ITEM_ID,'-')
                 , NVL(A.DOM_EXP,'-'), NVL(A.FCST_TYPE,'-'), A.INCOTERMS, NVL(A.MEASURE,'-')
                 , NVL(A.PLANT_SITE_ID,'-'), NVL(A.DEPT_ID,'-'), NVL(A.END_CUSTOMER,'-'), NVL(A.BIZ_TYPE,'-')
                 , NVL(A.YYYYMM,'-'), NVL(A.CURRENCY,'-'), NVL(ITEM_USE,'-'), UNIT_ENERGY --[PJ20200138] item_use, unit_energy 추가
                 , A.QTY, A.CELL_PER_PACK
                 , A.CELL_PER_MODULE, A.MODULE_PER_PACK, A.CREATED_BY, A.CREATION_DATE
                 , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2
                 , A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
                 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                 , ROW_NUMBER() OVER(ORDER BY DIVISION_ID)	-- 2021/07/26 SJHAN 중장기계획 과제 관련 - SEQ 추가
                 , NVL(CELL_PROD_SITE,'-')  -- 2022/06/02 [C20220513-000327]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
              FROM DM_PLN_BP_FCST A
             WHERE 1 = 1
               AND A.DIVISION_ID = v_division_id
            ;
        END;

        /* 20190617 CUTOFF DATA INSERT (BEGIN) */
        BEGIN
            -- insert 작업
            INSERT INTO DM_BP_EXCHANGE_RATE_C
                 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                 , YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                 , ATTRIBUTE9, ATTRIBUTE10 )
            -- DM_PLN_BP_FCST_C 테이블에 생성된 동일한 version no 를 저장
            -- [NOT NULL 문자컬럼] 소스 NULL(=MSSQL '')은 '-' 치환(NVL).
            SELECT p_division_id, v_ver_return_no AS VERSION_NO, v_ver_type AS CUTOFF_TYPE, v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                 , NVL(YYYYMMDD,'-'), NVL(CURRENCY,'-'), NVL(UNIT_CURRENCY,'-'), EXCHANGE_PRICE
                 , NVL(CREATED_BY,'-'), CREATION_DATE, v_created_by AS LAST_UPDATED_BY, SYSDATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                 , ATTRIBUTE9, ATTRIBUTE10
              FROM DM_BP_EXCHANGE_RATE
             WHERE DIVISION_ID = p_division_id
            ;
        END;

        /* CUTOFF DATA INSERT END) */

        -- 트랜잭션 (COMMIT)
        COMMIT;

    --------------------------------------------------------------------------------------------
    EXCEPTION
    --------------------------------------------------------------
    -- ROLLBACK
    WHEN OTHERS THEN
        -- 트랜잭션 (END)
        ROLLBACK TO SAVEPOINT SAVE_DM_PLN_BP_FCST_CUTOFF;

        -- ERROR LOG VALUE SAVE
        v_log_type    := 'ERROR';
        v_log_message := SUBSTR(SQLERRM, 1, 1000);                                    -- ERROR_MESSAGE()
        v_description := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);  -- STR(ERROR_LINE())
        d_event_date  := SYSDATE;

        --[C20200909-000203] LOG 표준화 적용
        PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date
                            , P_IN_PARA_DATA  => 'p_division_id=' || p_division_id
                            , P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
                            , P_SQL_ERR_MSG   => SQLERRM
                            , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        -- 에러메시지 DISPLAY (원본: SELECT '[' + ERROR_NUMBER() + ']' + ERROR_MESSAGE())
        v_err_display := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;
        OPEN p_cursor1 FOR SELECT v_err_display AS ERROR_MESSAGE FROM DUAL;
    --------------------------------------------------------------
    END;
    --------------------------------------------------------------

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
END P_DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF;


  PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV 
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
      DELETE FROM GT_SDPBP_FUTURE_PRICE_TEMP0_4;

      -- Temp Table2 존재여부 확인하여 삭제
      DELETE FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4;

        DELETE FROM GT_SDPB_FUTURE_PRICE_TEMP_QTY;

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

      DELETE FROM GT_SDPBP_FUTURE_PRICE_TEMP3_2;

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


END P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV;


    PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_FCST
    (
        P_ACTIVE_FLAG   VARCHAR2
       ,P_DIVISION_ID   VARCHAR2
       ,P_PROJECT_CODE  VARCHAR2
       ,P_PROJECT_NAME  VARCHAR2
       ,P_SCM_SITE_ID   VARCHAR2
       ,P_PLANT_SITE_ID VARCHAR2
       ,P_ITEM_ID       VARCHAR2
        --, p_DOM_EXP         VARCHAR2
       ,P_FCST_TYPE VARCHAR2
       ,P_INCOTERMS VARCHAR2 -- PJ20200138 Incoterms 삭제
        -- -----------------------------------------------------------------------------------------------
        -- PJ20200138 item_use, unit_energy 추가 (START)
       ,P_ITEM_USE    VARCHAR2
       ,P_UNIT_ENERGY VARCHAR2
        -- PJ20200138 item_use, unit_energy 추가 (END)
        -- -----------------------------------------------------------------------------------------------
       ,P_MEASURE  VARCHAR2
       ,P_YYYYMM   VARCHAR2
       ,P_QTY      VARCHAR2
       ,P_CURRENCY VARCHAR2
        -- -----------------------------------------------------------------------------------------------
        -- 20190830 파라미터추가 (START)
       ,P_DEPT_ID        VARCHAR2
       ,P_END_CUSTOMER   VARCHAR2
       ,P_BIZ_TYPE       VARCHAR2
       ,P_CELL_PROD_SITE VARCHAR2
        --, p_CELL_PER_PACK            VARCHAR2
        --, p_CELL_PER_MODULE          VARCHAR2
        --, p_MODULE_PER_PACK          VARCHAR2
        -- 20190830 파라미터추가 (END)
        -- -----------------------------------------------------------------------------------------------
       ,P_CREATED_BY      VARCHAR2
       ,P_LAST_UPDATED_BY VARCHAR2
       ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
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
        * 2026/03/15 김준규        [PJ20264226] NextSCM Pilot 설계 및 개발
        ===============================================================================================================================*/
     AS

        N_ACTIVE_FLAG     VARCHAR2(4000 CHAR);
        V_ACTIVE_FLAG     VARCHAR2(4000 CHAR);
        V_DIVISION_ID     VARCHAR2(4000 CHAR);
        V_PROJECT_CODE    VARCHAR2(4000 CHAR);
        V_PROJECT_NAME    VARCHAR2(4000 CHAR);
        V_SCM_SITE_ID     VARCHAR2(4000 CHAR);
        V_PLANT_SITE_ID   VARCHAR2(4000 CHAR);
        V_ITEM_ID         VARCHAR2(4000 CHAR);
        V_FCST_TYPE       VARCHAR2(4000 CHAR);
        V_INCOTERMS       VARCHAR2(4000 CHAR);
        V_ITEM_USE        VARCHAR2(4000 CHAR);
        V_UNIT_ENERGY     VARCHAR2(4000 CHAR);
        V_MEASURE         VARCHAR2(4000 CHAR);
        V_YYYYMM          VARCHAR2(4000 CHAR);
        V_CURRENCY        VARCHAR2(4000 CHAR);
        V_QTY             VARCHAR2(4000 CHAR);
        V_DEPT_ID         VARCHAR2(4000 CHAR);
        V_END_CUSTOMER    VARCHAR2(4000 CHAR);
        V_BIZ_TYPE        VARCHAR2(4000 CHAR);
        V_CELL_PROD_SITE  VARCHAR2(4000 CHAR);
        V_CREATED_BY      VARCHAR2(4000 CHAR);
        V_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
        --
        NP_ACTIVE_FLAG     VARCHAR2(4000 CHAR);
        VP_ACTIVE_FLAG     VARCHAR2(4000 CHAR);
        VP_DIVISION_ID     VARCHAR2(4000 CHAR);
        VP_PROJECT_CODE    VARCHAR2(4000 CHAR);
        VP_PROJECT_NAME    VARCHAR2(4000 CHAR);
        VP_SCM_SITE_ID     VARCHAR2(4000 CHAR);
        VP_PLANT_SITE_ID   VARCHAR2(4000 CHAR);
        VP_ITEM_ID         VARCHAR2(4000 CHAR);
        VP_FCST_TYPE       VARCHAR2(4000 CHAR);
        VP_INCOTERMS       VARCHAR2(4000 CHAR);
        VP_ITEM_USE        VARCHAR2(4000 CHAR);
        VP_UNIT_ENERGY     VARCHAR2(4000 CHAR);
        VP_MEASURE         VARCHAR2(4000 CHAR);
        VP_YYYYMM          VARCHAR2(4000 CHAR);
        VP_CURRENCY        VARCHAR2(4000 CHAR);
        VP_QTY             VARCHAR2(4000 CHAR);
        VP_DEPT_ID         VARCHAR2(4000 CHAR);
        VP_END_CUSTOMER    VARCHAR2(4000 CHAR);
        VP_BIZ_TYPE        VARCHAR2(4000 CHAR);
        VP_CELL_PROD_SITE  VARCHAR2(4000 CHAR);
        VP_CREATED_BY      VARCHAR2(4000 CHAR);
        VP_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
        --
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             INTEGER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;
        N_DEL_COUNT             INTEGER := 0;
        N_INSERT_COUNT          INTEGER := 0;
        N_HISTORY_SEQ           INTEGER;
        V_INDEX_INCOTERMS       INTEGER;
        V_INDEX_INCOTERMS_LOCAL INTEGER; -- PJ20200138 Incoterms 삭제
        V_INDEX_ACTIVE_FLAG     INTEGER;
        V_INDEX_DIVISION_ID     INTEGER;
        V_INDEX_PROJECT_CODE    INTEGER;
        V_INDEX_PROJECT_NAME    INTEGER;
        V_INDEX_SCM_SITE_ID     INTEGER;
        V_INDEX_PLANT_SITE_ID   INTEGER;
        V_INDEX_ITEM_ID         INTEGER;
        V_INDEX_FCST_TYPE       INTEGER;
        V_INDEX_ITEM_USE        INTEGER;
        V_INDEX_UNIT_ENERGY     INTEGER;
        V_INDEX_MEASURE         INTEGER;
        V_INDEX_YYYYMM          INTEGER;
        V_INDEX_CURRENCY        INTEGER;
        V_INDEX_QTY             INTEGER;
        V_INDEX_DEPT_ID         INTEGER;
        V_INDEX_END_CUSTOMER    INTEGER;
        V_INDEX_BIZ_TYPE        INTEGER;
        V_INDEX_CELL_PROD_SITE  INTEGER;
        V_INDEX_CREATED_BY      INTEGER;
        V_INDEX_LAST_UPDATED_BY INTEGER;
        V_CNT_1                 INTEGER := 0;
        V_CNT_2                 INTEGER := 0;
        V_CNT_3                 INTEGER := 0;
        V_CNT_4                 INTEGER := 0;
        V_CNT_5                 INTEGER := 0;
        V_CNT_6                 INTEGER := 0;
        V_IN_PARA_DATA          VARCHAR2(4000);
        -- 선언부에 추가
        V_RC1_SUB SYS_REFCURSOR;
        V_RC2_SUB SYS_REFCURSOR;
        V_RESULT_CURSOR_SUB SYS_REFCURSOR;
        V_DUMMY        VARCHAR2(4000 CHAR) := NULL;
    BEGIN

        V_IN_PARA_DATA := JSON_OBJECT('p_active_flag' VALUE P_ACTIVE_FLAG
                                     ,'p_DIVISION_ID' VALUE P_DIVISION_ID
                                     ,'p_PROJECT_CODE' VALUE P_PROJECT_CODE
                                     ,'p_PROJECT_NAME' VALUE P_PROJECT_NAME
                                     ,'p_SCM_SITE_ID' VALUE P_SCM_SITE_ID
                                     ,'p_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID
                                     ,'p_ITEM_ID' VALUE P_ITEM_ID
                                     ,'p_DOM_EXP' VALUE NULL
                                     ,'p_FCST_TYPE' VALUE P_FCST_TYPE
                                     ,'p_INCOTERMS' VALUE P_INCOTERMS
                                     ,'p_ITEM_USE' VALUE P_ITEM_USE
                                     ,'p_UNIT_ENERGY' VALUE P_UNIT_ENERGY
                                     ,'p_MEASURE' VALUE P_MEASURE
                                     ,'p_YYYYMM' VALUE P_YYYYMM
                                     ,'p_QTY' VALUE P_QTY
                                     ,'p_CURRENCY' VALUE P_CURRENCY
                                     ,'p_DEPT_ID' VALUE P_DEPT_ID
                                     ,'p_END_CUSTOMER' VALUE P_END_CUSTOMER
                                     ,'p_BIZ_TYPE' VALUE P_BIZ_TYPE
                                     ,'p_CELL_PROD_SITE' VALUE P_CELL_PROD_SITE
                                     ,'p_INCOTERMS' VALUE P_INCOTERMS
                                     ,'p_INCOTERMS' VALUE P_INCOTERMS
                                     ,'p_INCOTERMS' VALUE P_INCOTERMS
                                     ,'p_INCOTERMS' VALUE P_INCOTERMS
                                     ,'p_CREATED_BY' VALUE P_CREATED_BY
                                     ,'p_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY);

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
        NP_ACTIVE_FLAG   := RTRIM(P_ACTIVE_FLAG) || '^';
        VP_DIVISION_ID   := RTRIM(P_DIVISION_ID) || '^';
        VP_PROJECT_CODE  := RTRIM(P_PROJECT_CODE) || '^';
        VP_PROJECT_NAME  := RTRIM(P_PROJECT_NAME) || '^';
        VP_SCM_SITE_ID   := RTRIM(P_SCM_SITE_ID) || '^';
        VP_PLANT_SITE_ID := RTRIM(P_PLANT_SITE_ID) || '^';
        VP_ITEM_ID       := RTRIM(P_ITEM_ID) || '^';
        --p_DOM_EXP := RTRIM(p_DOM_EXP         ) || '^';
        VP_FCST_TYPE := RTRIM(P_FCST_TYPE) || '^';
        VP_INCOTERMS := RTRIM(P_INCOTERMS) || '^'; -- PJ20200138 Incoterms 삭제
        -- -----------------------------------------------------------------------------------------------
        -- PJ20200138 item_use, unit_energy 추가 (START)
        VP_ITEM_USE    := RTRIM(P_ITEM_USE) || '^';
        VP_UNIT_ENERGY := RTRIM(P_UNIT_ENERGY) || '^';
        -- PJ20200138 item_use, unit_energy 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        VP_MEASURE  := RTRIM(P_MEASURE) || '^';
        VP_YYYYMM   := RTRIM(P_YYYYMM) || '^';
        VP_CURRENCY := RTRIM(P_CURRENCY) || '^';
        VP_QTY      := RTRIM(P_QTY) || '^';
        -- -----------------------------------------------------------------------------------------------
        -- 20190830 변수 추가 (START)
        VP_DEPT_ID        := RTRIM(P_DEPT_ID) || '^';
        VP_END_CUSTOMER   := RTRIM(P_END_CUSTOMER) || '^';
        VP_BIZ_TYPE       := RTRIM(P_BIZ_TYPE) || '^';
        VP_CELL_PROD_SITE := RTRIM(P_CELL_PROD_SITE) || '^';
        --p_CELL_PER_PACK := RTRIM(p_CELL_PER_PACK   ) || '^';
        --p_CELL_PER_MODULE := RTRIM(p_CELL_PER_MODULE ) || '^';
        --p_MODULE_PER_PACK := RTRIM(p_MODULE_PER_PACK ) || '^';
        -- 20190830 변수 추가 (END)
        -- -----------------------------------------------------------------------------------------------
        VP_CREATED_BY      := RTRIM(P_CREATED_BY) || '^';
        VP_LAST_UPDATED_BY := RTRIM(P_LAST_UPDATED_BY) || '^';

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
        DELETE FROM GT_SDPB2_BP_FCST_4;
        DELETE FROM GT_SDPB2_DM_PLN_BP_FCST_X_4;
        DELETE FROM GT_SDPB_DM_MST_ITEM_SINGLE_ORI;
        DELETE FROM GT_SDPB_DM_MST_ITEM_SINGLE_A_V;
        DELETE FROM GT_SDPB_DM_MST_ITEM_SINGLE_B_V;
        DELETE FROM GT_SDPB_DM_MST_ITEM_SINGLE_V;

        --======================================================
        -- 시작 LOG  (START)
        --======================================================
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);
        V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
        --======================================================
        -- 시작 LOG  (END)
        --======================================================
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A001-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        --======================================================
        -- 트랜잭션 (START)
        --======================================================
        -- -----------------------------------------------------------------------------------------
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
        -- -----------------------------------------------------------------------------------------
        WHILE LENGTH(VP_DIVISION_ID) > 0 LOOP
            -- 상단으로 이동 v_index_INCOTERMS_local       INTEGER;  -- PJ20200138 Incoterms 삭제

            -- -----------------------------------------------------------------------------------------------
            -- PJ20200138 item_use, unit_energy 추가 (START)
            -- -----------------------------------------------------------------------------------------------
            -- 20190830 추가 (START)
            --    v_index_CELL_PER_MODULE INTEGER;
            --    v_index_MODULE_PER_PACK INTEGER;
            -- 20190830 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            V_INDEX_ACTIVE_FLAG   := INSTR(NP_ACTIVE_FLAG, '^');
            V_INDEX_DIVISION_ID   := INSTR(VP_DIVISION_ID, '^');
            V_INDEX_PROJECT_CODE  := INSTR(VP_PROJECT_CODE, '^');
            V_INDEX_PROJECT_NAME  := INSTR(VP_PROJECT_NAME, '^');
            V_INDEX_SCM_SITE_ID   := INSTR(VP_SCM_SITE_ID, '^');
            V_INDEX_PLANT_SITE_ID := INSTR(VP_PLANT_SITE_ID, '^');
            V_INDEX_ITEM_ID       := INSTR(VP_ITEM_ID, '^');
            --v_index_DOM_EXP := INSTR(vp_DOM_EXP, '^')
            V_INDEX_FCST_TYPE       := INSTR(VP_FCST_TYPE, '^');
            V_INDEX_INCOTERMS_LOCAL := INSTR(VP_INCOTERMS, '^'); -- PJ20200138 Incoterms 삭제
            -- -----------------------------------------------------------------------------------------------
            -- PJ20200138 item_use, unit_energy 추가 (START)
            V_INDEX_ITEM_USE    := INSTR(VP_ITEM_USE, '^');
            V_INDEX_UNIT_ENERGY := INSTR(VP_UNIT_ENERGY, '^');
            -- PJ20200138 item_use, unit_energy 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            V_INDEX_MEASURE  := INSTR(VP_MEASURE, '^');
            V_INDEX_YYYYMM   := INSTR(VP_YYYYMM, '^');
            V_INDEX_CURRENCY := INSTR(VP_CURRENCY, '^');
            V_INDEX_QTY      := INSTR(VP_QTY, '^');
            -- -----------------------------------------------------------------------------------------------
            -- 20190830 추가 (START)
            V_INDEX_DEPT_ID        := INSTR(VP_DEPT_ID, '^');
            V_INDEX_END_CUSTOMER   := INSTR(VP_END_CUSTOMER, '^');
            V_INDEX_BIZ_TYPE       := INSTR(VP_BIZ_TYPE, '^');
            V_INDEX_CELL_PROD_SITE := INSTR(VP_CELL_PROD_SITE, '^');
            --v_index_CELL_PER_PACK := INSTR(vp_CELL_PER_PACK, '^');
            --v_index_CELL_PER_MODULE := INSTR(vp_CELL_PER_MODULE, '^');
            --v_index_MODULE_PER_PACK := INSTR(vp_MODULE_PER_PACK, '^');
            -- 20190830 추가 (END)
            -- -----------------------------------------------------------------------------------------------
            V_INDEX_CREATED_BY      := INSTR(VP_CREATED_BY, '^');
            V_INDEX_LAST_UPDATED_BY := INSTR(VP_LAST_UPDATED_BY, '^');
            V_INDEX_INCOTERMS       := V_INDEX_INCOTERMS_LOCAL;

            IF V_INDEX_DIVISION_ID > 0 THEN
                -- 추출: vp_XXX에서 '^' 앞 값 → v_XXX
                V_ACTIVE_FLAG  := SUBSTR(NP_ACTIVE_FLAG, 1, V_INDEX_ACTIVE_FLAG - 1);
                NP_ACTIVE_FLAG := SUBSTR(NP_ACTIVE_FLAG, V_INDEX_ACTIVE_FLAG + 1);

                V_DIVISION_ID  := SUBSTR(VP_DIVISION_ID, 1, V_INDEX_DIVISION_ID - 1);
                VP_DIVISION_ID := SUBSTR(VP_DIVISION_ID, V_INDEX_DIVISION_ID + 1);

                V_PROJECT_CODE  := SUBSTR(VP_PROJECT_CODE, 1, V_INDEX_PROJECT_CODE - 1);
                VP_PROJECT_CODE := SUBSTR(VP_PROJECT_CODE, V_INDEX_PROJECT_CODE + 1);

                V_PROJECT_NAME  := SUBSTR(VP_PROJECT_NAME, 1, V_INDEX_PROJECT_NAME - 1);
                VP_PROJECT_NAME := SUBSTR(VP_PROJECT_NAME, V_INDEX_PROJECT_NAME + 1);

                V_SCM_SITE_ID  := SUBSTR(VP_SCM_SITE_ID, 1, V_INDEX_SCM_SITE_ID - 1);
                VP_SCM_SITE_ID := SUBSTR(VP_SCM_SITE_ID, V_INDEX_SCM_SITE_ID + 1);

                V_PLANT_SITE_ID  := SUBSTR(VP_PLANT_SITE_ID, 1, V_INDEX_PLANT_SITE_ID - 1);
                VP_PLANT_SITE_ID := SUBSTR(VP_PLANT_SITE_ID, V_INDEX_PLANT_SITE_ID + 1);

                V_ITEM_ID  := SUBSTR(VP_ITEM_ID, 1, V_INDEX_ITEM_ID - 1);
                VP_ITEM_ID := SUBSTR(VP_ITEM_ID, V_INDEX_ITEM_ID + 1);

                --v_DOM_EXP := SUBSTR(vp_DOM_EXP, 1, v_index_DOM_EXP - 1);
                --p_DOM_EXP := SUBSTR(vp_DOM_EXP , LENGTH(v_DOM_EXP  || '^') + 1, LENGTH(p_DOM_EXP ))
                --vp_DOM_EXP := SUBSTR(vp_DOM_EXP, v_index_DOM_EXP + 1);

                V_FCST_TYPE  := SUBSTR(VP_FCST_TYPE, 1, V_INDEX_FCST_TYPE - 1);
                VP_FCST_TYPE := SUBSTR(VP_FCST_TYPE, V_INDEX_FCST_TYPE + 1);

                V_INCOTERMS  := SUBSTR(VP_INCOTERMS, 1, V_INDEX_INCOTERMS - 1); -- [PJ20200138] Incoterms 삭제
                VP_INCOTERMS := SUBSTR(VP_INCOTERMS, V_INDEX_INCOTERMS + 1);
                -- -----------------------------------------------------------------------------------------------
                -- [PJ20200138] item_use, unit_energy 추가 (START)
                V_ITEM_USE  := SUBSTR(VP_ITEM_USE, 1, V_INDEX_ITEM_USE - 1);
                VP_ITEM_USE := SUBSTR(VP_ITEM_USE, V_INDEX_ITEM_USE + 1);

                V_UNIT_ENERGY  := SUBSTR(VP_UNIT_ENERGY, 1, V_INDEX_UNIT_ENERGY - 1);
                VP_UNIT_ENERGY := SUBSTR(VP_UNIT_ENERGY, V_INDEX_UNIT_ENERGY + 1);
                -- [PJ20200138] item_use, unit_energy 추가 (END)
                -- -----------------------------------------------------------------------------------------------
                V_MEASURE  := SUBSTR(VP_MEASURE, 1, V_INDEX_MEASURE - 1);
                VP_MEASURE := SUBSTR(VP_MEASURE, V_INDEX_MEASURE + 1);

                V_YYYYMM  := SUBSTR(VP_YYYYMM, 1, V_INDEX_YYYYMM - 1);
                VP_YYYYMM := SUBSTR(VP_YYYYMM, V_INDEX_YYYYMM + 1);

                V_CURRENCY  := SUBSTR(VP_CURRENCY, 1, V_INDEX_CURRENCY - 1);
                VP_CURRENCY := SUBSTR(VP_CURRENCY, V_INDEX_CURRENCY + 1);
                -- -----------------------------------------------------------------------------------------------
                -- 20180319 skh added (START)
                IF VP_CURRENCY IS NULL THEN
                    VP_CURRENCY := NULL;
                END IF;
                -- 20180319 skh added (END)
                -- -----------------------------------------------------------------------------------------------
                V_QTY  := SUBSTR(VP_QTY, 1, V_INDEX_QTY - 1);
                VP_QTY := SUBSTR(VP_QTY, V_INDEX_QTY + 1);
                -- -----------------------------------------------------------------------------------------------
                -- 20190830 추가 (START)
                V_DEPT_ID  := SUBSTR(VP_DEPT_ID, 1, V_INDEX_DEPT_ID - 1);
                VP_DEPT_ID := SUBSTR(VP_DEPT_ID, V_INDEX_DEPT_ID + 1);

                V_END_CUSTOMER  := SUBSTR(VP_END_CUSTOMER, 1, V_INDEX_END_CUSTOMER - 1);
                VP_END_CUSTOMER := SUBSTR(VP_END_CUSTOMER, V_INDEX_END_CUSTOMER + 1);

                V_BIZ_TYPE  := SUBSTR(VP_BIZ_TYPE, 1, V_INDEX_BIZ_TYPE - 1);
                VP_BIZ_TYPE := SUBSTR(VP_BIZ_TYPE, V_INDEX_BIZ_TYPE + 1);

                V_CELL_PROD_SITE  := SUBSTR(VP_CELL_PROD_SITE, 1, V_INDEX_CELL_PROD_SITE - 1);
                VP_CELL_PROD_SITE := SUBSTR(VP_CELL_PROD_SITE, V_INDEX_CELL_PROD_SITE + 1);
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
                /*v_CELL_PER_PACK := SUBSTR(vp_CELL_PER , 0, v_index_CELL_PER_PACK )
                p_CELL_PER_PACK := SUBSTR(vp_CELL_PER_PACK , LENGTH(v_CELL_PER_PACK  || '^') + 1, LENGTH(p_CELL_PER_PACK ));

                v_CELL_PER_MODULE := SUBSTR(vp_CELL_PER_MODULE , 0, v_index_CELL_PER_MODULE );
                p_CELL_PER_MODULE := SUBSTR(vp_CELL_PER_MODULE , LENGTH(v_CELL_PER_MODULE  || '^') + 1, LENGTH(p_CELL_PER_MODULE ));

                v_MODULE_PER_PACK := SUBSTR(vp_MODULE_PER_PACK , 0, v_index_MODULE_PER_PACK );
                p_MODULE_PER_PACK := SUBSTR(vp_MODULE_PER_PACK , LENGTH(v_MODULE_PER_PACK  || '^') + 1, LENGTH(p_MODULE_PER_PACK ))*/
                -- 20190830 추가 (END)
                -- -----------------------------------------------------------------------------------------------
                V_CREATED_BY  := SUBSTR(VP_CREATED_BY, 1, V_INDEX_CREATED_BY - 1);
                VP_CREATED_BY := SUBSTR(VP_CREATED_BY, V_INDEX_CREATED_BY + 1);

                V_LAST_UPDATED_BY  := SUBSTR(VP_LAST_UPDATED_BY, 1, V_INDEX_LAST_UPDATED_BY - 1);
                VP_LAST_UPDATED_BY := SUBSTR(VP_LAST_UPDATED_BY, V_INDEX_LAST_UPDATED_BY + 1);

                -- -----------------------------------------------------------------------------------------------
                -- [E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리 (START)
                -- ITEM의 경우 중간의 공백이 없으므로 RTRM, LTRM으로 지워지지 않는 건들이 있고, 특수 문자가 안지워지는 건도 있어서 어떻게든 지우겠다는 의지
                V_ACTIVE_FLAG   := RTRIM(LTRIM(V_ACTIVE_FLAG));
                V_DIVISION_ID   := RTRIM(LTRIM(V_DIVISION_ID));
                V_PROJECT_CODE  := RTRIM(LTRIM(V_PROJECT_CODE));
                V_PROJECT_NAME  := RTRIM(LTRIM(V_PROJECT_NAME));
                V_SCM_SITE_ID   := RTRIM(LTRIM(V_SCM_SITE_ID));
                V_PLANT_SITE_ID := RTRIM(LTRIM(V_PLANT_SITE_ID));
                --CHAR(13): Carriage return / CHAR(10): Line feed / CHAR(9): TAB
                V_ITEM_ID         := REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(V_ITEM_ID)), CHR(13), ''), CHR(10), ''), CHR(9), ''), ' ', '');
                V_FCST_TYPE       := RTRIM(LTRIM(V_FCST_TYPE));
                V_INCOTERMS       := RTRIM(LTRIM(V_INCOTERMS));
                V_ITEM_USE        := RTRIM(LTRIM(V_ITEM_USE));
                V_UNIT_ENERGY     := RTRIM(LTRIM(V_UNIT_ENERGY));
                V_MEASURE         := RTRIM(LTRIM(V_MEASURE));
                V_YYYYMM          := RTRIM(LTRIM(V_YYYYMM));
                V_CURRENCY        := RTRIM(LTRIM(V_CURRENCY));
                V_QTY             := RTRIM(LTRIM(V_QTY));
                V_DEPT_ID         := RTRIM(LTRIM(V_DEPT_ID));
                V_END_CUSTOMER    := RTRIM(LTRIM(V_END_CUSTOMER));
                V_BIZ_TYPE        := RTRIM(LTRIM(V_BIZ_TYPE));
                V_CELL_PROD_SITE  := RTRIM(LTRIM(V_CELL_PROD_SITE));
                V_CREATED_BY      := RTRIM(LTRIM(V_CREATED_BY));
                V_LAST_UPDATED_BY := RTRIM(LTRIM(V_LAST_UPDATED_BY));
                -- [E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리 (END)
                -- -----------------------------------------------------------------------------------------------
                INSERT /*+ NO_PARALLEL */
                INTO GT_SDPB2_BP_FCST_4
                    (ACTIVE_FLAG
                    ,DIVISION_ID
                    ,PROJECT_CODE
                    ,PROJECT_NAME
                    ,SCM_SITE_ID
                    ,PLANT_SITE_ID
                    ,ITEM_ID --,DOM_EXP
                    ,FCST_TYPE
                    ,INCOTERMS -- PJ20200138 Incoterms 삭제
                     -- -----------------------------------------------------------------------------------------------
                     -- PJ20200138 item_use, unit_energy 추가 (START)
                    ,ITEM_USE
                    ,UNIT_ENERGY
                     -- PJ20200138 item_use, unit_energy 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,MEASURE
                    ,YYYYMM
                    ,CURRENCY
                    ,QTY
                     -- -----------------------------------------------------------------------------------------------
                     -- 20190830 추가 (START)
                    ,DEPT_ID
                    ,END_CUSTOMER
                    ,BIZ_TYPE
                    ,CELL_PROD_SITE --,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
                     -- 20190830 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,CREATED_BY
                    ,LAST_UPDATED_BY)
                VALUES
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_PROJECT_CODE
                    ,V_PROJECT_NAME
                    ,V_SCM_SITE_ID
                    ,V_PLANT_SITE_ID
                    ,V_ITEM_ID --,v_DOM_EXP
                    ,V_FCST_TYPE
                    ,V_INCOTERMS -- PJ20200138 Incoterms 삭제
                     -- -----------------------------------------------------------------------------------------------
                     -- PJ20200138 item_use, unit_energy 추가 (START)
                    ,V_ITEM_USE
                    ,(CASE WHEN V_UNIT_ENERGY IS NULL THEN 0 ELSE TO_NUMBER(V_UNIT_ENERGY) END)
                     -- PJ20200138 item_use, unit_energy 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,V_MEASURE
                    ,V_YYYYMM
                    ,V_CURRENCY
                    ,V_QTY
                     -- -----------------------------------------------------------------------------------------------
                     -- 20190830 추가 (START)
                    /*,CASE WHEN V_DIVISION_ID = '40' THEN NULL ELSE V_DEPT_ID END
                    ,CASE WHEN V_DIVISION_ID = '40' THEN NULL ELSE V_END_CUSTOMER END
                    ,CASE WHEN V_DIVISION_ID = '40' THEN NULL ELSE V_BIZ_TYPE END*/
                    -- 2026-03-29 not null 컬럼이기에 무조건 입력값을 넣어야 된다.
                    ,V_DEPT_ID
                    ,V_END_CUSTOMER
                    ,V_BIZ_TYPE
                    ,V_CELL_PROD_SITE --,v_CELL_PER_PACK--,v_CELL_PER_MODULE--,v_MODULE_PER_PACK
                     -- 20190830 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,V_CREATED_BY
                    ,V_LAST_UPDATED_BY);
                -- ----------------------------------------
            ELSE
                -- ----------------------------------------
                -- 마지막 데이터: 잔여값 할당 후 루프 종료
                V_DIVISION_ID  := VP_DIVISION_ID;
                VP_DIVISION_ID := NULL; -- ★ 루프 종료 조건

                INSERT /*+ NO_PARALLEL */
                INTO GT_SDPB2_BP_FCST_4
                    (ACTIVE_FLAG
                    ,DIVISION_ID
                    ,PROJECT_CODE
                    ,PROJECT_NAME
                    ,SCM_SITE_ID
                    ,PLANT_SITE_ID
                    ,ITEM_ID --,DOM_EXP
                    ,FCST_TYPE
                    ,INCOTERMS -- PJ20200138 Incoterms 삭제
                     -- -----------------------------------------------------------------------------------------------
                     -- PJ20200138 item_use, unit_energy 추가 (START)
                    ,ITEM_USE
                    ,UNIT_ENERGY
                     -- PJ20200138 item_use, unit_energy 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,MEASURE
                    ,YYYYMM
                    ,CURRENCY
                    ,QTY
                     -- -----------------------------------------------------------------------------------------------
                     -- 20190830 추가 (START)
                    ,DEPT_ID
                    ,END_CUSTOMER
                    ,BIZ_TYPE
                    ,CELL_PROD_SITE --,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
                     -- 20190830 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,CREATED_BY
                    ,LAST_UPDATED_BY)
                VALUES
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_PROJECT_CODE
                    ,V_PROJECT_NAME
                    ,V_SCM_SITE_ID
                    ,V_PLANT_SITE_ID
                    ,V_ITEM_ID --,v_DOM_EXP
                    ,V_FCST_TYPE
                    ,V_INCOTERMS -- PJ20200138 Incoterms 삭제
                     -- -----------------------------------------------------------------------------------------------
                     -- PJ20200138 item_use, unit_energy 추가 (START)
                    ,V_ITEM_USE
                    ,(CASE WHEN V_UNIT_ENERGY IS NULL THEN 0 ELSE TO_NUMBER(V_UNIT_ENERGY) END)
                     -- PJ20200138 item_use, unit_energy 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,V_MEASURE
                    ,V_YYYYMM
                    ,V_CURRENCY
                    ,V_QTY
                     -- -----------------------------------------------------------------------------------------------
                     -- 20190830 추가 (START)
                    /*,CASE WHEN V_DIVISION_ID = '40' THEN NULL ELSE V_DEPT_ID END
                    ,CASE WHEN V_DIVISION_ID = '40' THEN NULL ELSE V_END_CUSTOMER END
                    ,CASE WHEN V_DIVISION_ID = '40' THEN NULL ELSE V_BIZ_TYPE END*/
                    -- 2026-03-29 not null 컬럼이기에 무조건 입력값을 넣어야 된다.
                    ,V_DEPT_ID
                    ,V_END_CUSTOMER
                    ,V_BIZ_TYPE
                    ,V_CELL_PROD_SITE --,v_CELL_PER_PACK--,v_CELL_PER_MODULE--,v_MODULE_PER_PACK
                     -- 20190830 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,V_CREATED_BY
                    ,V_LAST_UPDATED_BY);

            END IF;

        END LOOP;

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A002-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        -- -----------------------------------------------------------------------------------------------
        -- [E20250522-001188]_속도 개선을 위해 DM_MST_ITEM_SINGLE_V를 TEMP로 생성함 (START)
        BEGIN
            --> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
            INSERT /*+ NO_PARALLEL */
            INTO GT_SDPB_DM_MST_ITEM_SINGLE_ORI
                SELECT *
                FROM   SCM_MST_ITEM_SN
                WHERE  DIVISION_ID = V_DIVISION_ID
                AND    ACTIVE_FLAG = 'Y';

            --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
            INSERT /*+ NO_PARALLEL */
            INTO GT_SDPB_DM_MST_ITEM_SINGLE_A_V
                SELECT T1.DIVISION_ID
                      ,T1.ITEM_ID
                      ,MAX(T1.ITEM_NAME) ITEM_NAME
                      ,MAX(T1.ITEM_CLASS) ITEM_CLASS
                      ,MAX(T1.ITEM_CLASS_NAME) ITEM_CLASS_NAME
                      ,MAX(T1.NICK_NAME) NICK_NAME
                      ,CASE MIN(CASE
                                WHEN T1.ITEM_TYPE = 'P' THEN
                                 1
                                WHEN T1.ITEM_TYPE = 'H' THEN
                                 2
                                WHEN T1.ITEM_TYPE = 'Q' THEN
                                 3
                                ELSE
                                 4
                            END)
                           WHEN 1 THEN
                            'P'
                           WHEN 2 THEN
                            'H'
                           WHEN 3 THEN
                            'Q'
                           ELSE
                            'R'
                       END AS ITEM_TYPE
                      ,MAX(T1.MATERIAL_CLASS_NAME) MATERIAL_CLASS_NAME
                      ,MAX(T1.ITEM_UOM) ITEM_UOM
                      ,MAX(T1.SPEC) SPEC
                      ,MAX(T1.MDM_PROJECT_NAME) MDM_PROJECT_NAME
                      ,MAX(T1.MIN_CAPACITY) MIN_CAPACITY
                      ,MAX(T1.ACTIVE_FLAG) ACTIVE_FLAG
                      ,MAX(T1.ENERGE) ENERGE
                      ,MAX(T1.CELL_QUANTITY) CELL_QUANTITY
                      ,MAX(T1.SCP_EXTRA_SPEC) SCP_EXTRA_SPEC
                FROM   GT_SDPB_DM_MST_ITEM_SINGLE_ORI T1
                WHERE  1 = 1
                GROUP  BY T1.DIVISION_ID, T1.ITEM_ID;

            --멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
            INSERT /*+ NO_PARALLEL */
            INTO GT_SDPB_DM_MST_ITEM_SINGLE_B_V
                SELECT DIVISION_ID
                      ,SUBSTR(ITEM_ID, 1, 12) ITEM_ID
                      ,MAX(FORECAST_INFO_BIZ_TYPE) FORECAST_INFO_BIZ_TYPE
                      ,MAX(FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
                      ,MAX(FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
                      ,MAX(FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT
                      ,MAX(FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
                      ,MAX(FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
                      ,MAX(CELL_TYPE) CELL_TYPE
                FROM   GT_SDPB_DM_MST_ITEM_SINGLE_ORI T2
                GROUP  BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

            --TEMP 테이블에 넣은 데이터를 JOIN 한다.
            INSERT /*+ NO_PARALLEL */
            INTO GT_SDPB_DM_MST_ITEM_SINGLE_V
                SELECT DIVISION_ID
                      ,ITEM_ID
                      ,ITEM_NAME
                      ,ITEM_CLASS
                      ,ITEM_CLASS_NAME
                      ,NICK_NAME
                      ,ITEM_TYPE
                      ,MATERIAL_CLASS_NAME
                      ,ITEM_UOM
                      ,SPEC
                      ,MDM_PROJECT_NAME
                      ,MIN_CAPACITY
                      ,FORECAST_INFO_BIZ_TYPE
                      ,FORECAST_INFO_PRODUCT_GROUP
                      ,FORECAST_INFO_CELL_MODEL
                      ,FORECAST_INFO_CELL_PACK_COUNT
                      ,FORECAST_INFO_SPEC
                      ,FORECAST_INFOR_VERSION
                      ,ACTIVE_FLAG
                      ,CELL_TYPE
                      ,ENERGE
                      ,CELL_QUANTITY
                      ,SCP_EXTRA_SPEC
                FROM   (SELECT T1.DIVISION_ID
                              ,T1.ITEM_ID
                              ,T1.ITEM_NAME
                              ,T1.ITEM_CLASS
                              ,T1.ITEM_CLASS_NAME
                              ,T1.NICK_NAME
                              ,T1.ITEM_TYPE
                              ,T1.MATERIAL_CLASS_NAME
                              ,T1.ITEM_UOM
                              ,T1.SPEC
                              ,T1.MDM_PROJECT_NAME
                              ,T1.MIN_CAPACITY
                              ,T2.FORECAST_INFO_BIZ_TYPE
                              ,T2.FORECAST_INFO_PRODUCT_GROUP
                              ,T2.FORECAST_INFO_CELL_MODEL
                              ,T2.FORECAST_INFO_CELL_PACK_COUNT
                              ,T2.FORECAST_INFO_SPEC
                              ,T2.FORECAST_INFOR_VERSION
                              ,T1.ACTIVE_FLAG
                              ,T2.CELL_TYPE
                              ,T1.ENERGE
                              ,T1.CELL_QUANTITY
                              ,T1.SCP_EXTRA_SPEC
                        FROM   GT_SDPB_DM_MST_ITEM_SINGLE_A_V T1
                        INNER  JOIN GT_SDPB_DM_MST_ITEM_SINGLE_B_V T2
                        ON     T1.DIVISION_ID = T2.DIVISION_ID
                        AND    SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
                        WHERE  1 = 1) T2
                WHERE  DIVISION_ID = P_DIVISION_ID
                GROUP  BY DIVISION_ID
                         ,ITEM_ID
                         ,ITEM_NAME
                         ,ITEM_CLASS
                         ,ITEM_CLASS_NAME
                         ,NICK_NAME
                         ,ITEM_TYPE
                         ,MATERIAL_CLASS_NAME
                         ,ITEM_UOM
                         ,SPEC
                         ,MDM_PROJECT_NAME
                         ,MIN_CAPACITY
                         ,FORECAST_INFO_BIZ_TYPE
                         ,FORECAST_INFO_PRODUCT_GROUP
                         ,FORECAST_INFO_CELL_MODEL
                         ,FORECAST_INFO_CELL_PACK_COUNT
                         ,FORECAST_INFO_SPEC
                         ,FORECAST_INFOR_VERSION
                         ,ACTIVE_FLAG
                         ,CELL_TYPE
                         ,ENERGE
                         ,CELL_QUANTITY
                         ,SCP_EXTRA_SPEC;
        END;
        -- [E20250522-001188]_속도 개선을 위해 DM_MST_ITEM_SINGLE_V를 TEMP로 생성함 (END)
        -- -----------------------------------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A003-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        --======================================================
        --INPUT된 active_flag='D' 인것 삭제수행 (START)
        --======================================================
        BEGIN
            SELECT COUNT(1) INTO N_DEL_COUNT FROM GT_SDPB2_BP_FCST_4 WHERE ACTIVE_FLAG = 'D';
            DELETE FROM DM_PLN_BP_FCST A
            WHERE  EXISTS
                   (SELECT 1
                    FROM   GT_SDPB2_BP_FCST_4 B
                    WHERE  1 = 1
                    AND    B.ACTIVE_FLAG = 'D'
                    -- [20260805 hook #119] B(GT)=FE 빈값이 NULL 로 적재 — 원장 A 는 전 키 NOT NULL('-' 정규화)
                    --   raw 비교 시 NULL 행 매칭 전멸 → 'D' 삭제·중복제거가 무시됨. B 측만 NVL 정규화.
                    AND    A.DIVISION_ID = NVL(B.DIVISION_ID, '-')
                    AND    A.PROJECT_CODE = NVL(B.PROJECT_CODE, '-')
                          --AND A.PROJECT_NAME = B.PROJECT_NAME
                    AND    A.SCM_SITE_ID = NVL(B.SCM_SITE_ID, '-')
                    AND    A.PLANT_SITE_ID = NVL(B.PLANT_SITE_ID, '-')
                    AND    A.ITEM_ID = NVL(B.ITEM_ID, '-')
                    AND    A.CELL_PROD_SITE = NVL(B.CELL_PROD_SITE, '-')
                    AND    A.FCST_TYPE = NVL(B.FCST_TYPE, '-')
                    AND    A.INCOTERMS = NVL(B.INCOTERMS, '-') -- PJ20200138 Incoterms 삭제
                          -- -----------------------------------------------------------------------------------------------
                          -- PJ20200138 item_use, unit_energy 추가 (START)
                    AND    A.ITEM_USE = NVL(B.ITEM_USE, '-')
                    AND    A.UNIT_ENERGY = NVL(B.UNIT_ENERGY, 0)
                          -- PJ20200138 item_use, unit_energy 추가 (END)
                          -- -----------------------------------------------------------------------------------------------
                    AND    A.MEASURE = NVL(B.MEASURE, '-')
                    AND    A.YYYYMM = NVL(B.YYYYMM, '-')
                          -- -----------------------------------------------------------------------------------------------
                          -- 20190830 추가 (START)
                    AND    A.DEPT_ID = NVL(B.DEPT_ID, '-')
                    AND    A.END_CUSTOMER = NVL(B.END_CUSTOMER, '-')
                    AND    A.BIZ_TYPE = NVL(B.BIZ_TYPE, '-')
                    AND    A.CURRENCY = NVL(B.CURRENCY, '-')
                    -- 20190830 추가 (END)
                    -- -----------------------------------------------------------------------------------------------
                    );

            -- -----------------------------------------------------------------------------------------------
            -- 삭제완료건 TEMP TABLE에서 제거
            -- -----------------------------------------------------------------------------------------------
            DELETE FROM GT_SDPB2_BP_FCST_4 WHERE ACTIVE_FLAG = 'D';
        END;
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A004-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        --======================================================
        --INPUT된 active_flag='D' 인것 삭제수행 (END)
        --======================================================
        --======================================================
        -- 2021.7.23 키 업데이트용으로 들어온 데이터 처리 (START)
        --======================================================
        BEGIN
            SELECT COUNT(1)
            INTO   V_CNT_1
            FROM   DM_PLN_BP_FCST A
            JOIN   (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE, CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
                    FROM   GT_SDPB2_BP_FCST_4
                    WHERE  MEASURE = 'Business_Plan'
                    GROUP  BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE, CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE) B
            ON     A.DIVISION_ID = B.DIVISION_ID
            AND    A.PROJECT_CODE = B.PROJECT_CODE
            AND    A.SCM_SITE_ID = B.SCM_SITE_ID
            AND    A.ITEM_ID = B.ITEM_ID
            AND    A.DEPT_ID = B.DEPT_ID
            AND    A.END_CUSTOMER = B.END_CUSTOMER
            AND    A.BIZ_TYPE = B.BIZ_TYPE
            AND    A.CURRENCY = B.CURRENCY
            AND    A.ITEM_USE = B.ITEM_USE
            AND    A.UNIT_ENERGY = B.UNIT_ENERGY
            AND    A.CELL_PROD_SITE = B.CELL_PROD_SITE
            WHERE  A.FCST_TYPE IS NULL
            OR     A.INCOTERMS IS NULL;
            IF V_CNT_1 > 0 THEN
                MERGE INTO DM_PLN_BP_FCST A
                USING (SELECT DIVISION_ID
                             ,PROJECT_CODE
                             ,SCM_SITE_ID
                             ,ITEM_ID
                             ,DEPT_ID
                             ,END_CUSTOMER
                             ,BIZ_TYPE
                             ,CURRENCY
                             ,ITEM_USE
                             ,UNIT_ENERGY
                             ,MAX(FCST_TYPE) FCST_TYPE --, MAX(DOM_EXP) DOM_EXP
                             ,MAX(INCOTERMS) INCOTERMS
                             ,CELL_PROD_SITE
                       FROM   GT_SDPB2_BP_FCST_4
                       WHERE  MEASURE = 'Business_Plan'
                       GROUP  BY DIVISION_ID
                                ,PROJECT_CODE
                                ,SCM_SITE_ID
                                ,ITEM_ID
                                ,DEPT_ID
                                ,END_CUSTOMER
                                ,BIZ_TYPE
                                ,CURRENCY
                                ,ITEM_USE
                                ,UNIT_ENERGY
                                ,CELL_PROD_SITE) B
                ON (A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.DEPT_ID = B.DEPT_ID AND A.END_CUSTOMER = B.END_CUSTOMER AND A.BIZ_TYPE = B.BIZ_TYPE AND A.CURRENCY = B.CURRENCY AND A.ITEM_USE = B.ITEM_USE AND A.UNIT_ENERGY = B.UNIT_ENERGY AND A.CELL_PROD_SITE = B.CELL_PROD_SITE)
                WHEN MATCHED THEN
                    UPDATE
                    SET    FCST_TYPE = NVL(B.FCST_TYPE, '-')
                           --, DOM_EXP = B.DOM_EXP
                          ,INCOTERMS = NVL(B.INCOTERMS, '-');
                GOTO END_PKUPDATE;
            END IF;
        END;
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A005-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        --======================================================
        -- INPUT된 Business_Plan MEASURE INSERT (START)
        --======================================================
        -- INSERT INTO 전 중복값 삭제
        BEGIN
            DELETE FROM DM_PLN_BP_FCST A
            WHERE  A.MEASURE IN ('Business_Plan', 'LOC', 'CAR_QTY', 'MKT_FCST')
            -- [20260805 hook #119] B(GT) 빈값=NULL → raw 비교 전멸 = 기존행 미삭제 → 아래 INSERT
            --   NOT EXISTS 에 걸려 재수정이 조용히 무시(SUCCESS·미반영). B 측만 NVL 정규화.
            AND    EXISTS (SELECT 1
                    FROM   GT_SDPB2_BP_FCST_4 B
                    WHERE  A.DIVISION_ID = NVL(B.DIVISION_ID, '-')
                    AND    A.PROJECT_CODE = NVL(B.PROJECT_CODE, '-')
                    AND    A.SCM_SITE_ID = NVL(B.SCM_SITE_ID, '-')
                    AND    A.PLANT_SITE_ID = NVL(B.PLANT_SITE_ID, '-')
                    AND    A.ITEM_ID = NVL(B.ITEM_ID, '-')
                    AND    A.CELL_PROD_SITE = NVL(B.CELL_PROD_SITE, '-')
                    AND    A.FCST_TYPE = NVL(B.FCST_TYPE, '-')
                    AND    A.ITEM_USE = NVL(B.ITEM_USE, '-')
                    AND    A.UNIT_ENERGY = NVL(B.UNIT_ENERGY, 0)
                    AND    A.MEASURE = NVL(B.MEASURE, '-')
                    AND    A.YYYYMM = NVL(B.YYYYMM, '-')
                    AND    A.DEPT_ID = NVL(B.DEPT_ID, '-')
                    AND    A.END_CUSTOMER = NVL(B.END_CUSTOMER, '-')
                    AND    A.BIZ_TYPE = NVL(B.BIZ_TYPE, '-')
                    AND    A.CURRENCY = NVL(B.CURRENCY, '-')
                    AND    A.INCOTERMS = NVL(B.INCOTERMS, '-'));
        END;
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A006-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        BEGIN
            INSERT INTO DM_PLN_BP_FCST
                (DIVISION_ID
                ,PROJECT_CODE
                ,PROJECT_NAME
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,YYYYMM
                ,CURRENCY
                ,MEASURE
                ,DOM_EXP
                ,FCST_TYPE
                 -- -----------------------------------------------------------------------------------------------
                 -- PJ20200138 item_use, unit_energy 추가 (START)
                ,ITEM_USE
                ,UNIT_ENERGY
                 -- PJ20200138 item_use, unit_energy 추가 (END)
                 -- -----------------------------------------------------------------------------------------------
                ,CELL_PROD_SITE
                ,INCOTERMS
                ,QTY -- PJ20200138 Incoterms 삭제
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                 -- -----------------------------------------------------------------------------------------------
                 -- 20190830 추가 (START)
                ,DEPT_ID
                ,END_CUSTOMER
                ,BIZ_TYPE --,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
                 -- 20190830 추가 (END)
                 -- -----------------------------------------------------------------------------------------------
                 )
                SELECT NVL(DIVISION_ID, '-')
                      ,NVL(PROJECT_CODE, '-')
                      ,PROJECT_NAME
                      ,NVL(SCM_SITE_ID, '-')
                      ,NVL(PLANT_SITE_ID, '-')
                      ,NVL(ITEM_ID, '-')
                      ,NVL(YYYYMM, '-')
                      ,NVL(CURRENCY, '-')
                      ,NVL(MEASURE, '-')
                      ,DOM_EXP
                      ,NVL(FCST_TYPE, '-')
                       -- -----------------------------------------------------------------------------------------------
                       -- PJ20200138 item_use, unit_energy 추가 (START)
                      ,ITEM_USE
                      ,UNIT_ENERGY
                       -- PJ20200138 item_use, unit_energy 추가 (END)
                       -- -----------------------------------------------------------------------------------------------
                      ,NVL(CELL_PROD_SITE, '-')
                      ,NVL(INCOTERMS, '-')
                      ,QTY -- PJ20200138 Incoterms 삭제
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE
                       -- -----------------------------------------------------------------------------------------------
                       -- 20190830 추가 (START)
                      ,DEPT_ID
                      ,NVL(END_CUSTOMER, '-')
                      ,BIZ_TYPE
                FROM   (SELECT DIVISION_ID
                              ,PROJECT_CODE
                              ,PROJECT_NAME
                              ,SCM_SITE_ID
                              ,NVL(PLANT_SITE_ID, '-') AS PLANT_SITE_ID
                              ,ITEM_ID
                              ,YYYYMM
                              ,CURRENCY
                              ,MEASURE
                              ,NULL AS DOM_EXP
                              ,FCST_TYPE
                               -- -----------------------------------------------------------------------------------------------
                               -- PJ20200138 item_use, unit_energy 추가 (START)
                              ,NVL(ITEM_USE, '-') AS ITEM_USE
                              ,UNIT_ENERGY
                               -- PJ20200138 item_use, unit_energy 추가 (END)
                               -- -----------------------------------------------------------------------------------------------
                              ,CELL_PROD_SITE
                              ,INCOTERMS
                              ,QTY -- PJ20200138 Incoterms 삭제
                              ,CREATED_BY
                              ,SYSDATE         CREATION_DATE
                              ,LAST_UPDATED_BY
                              ,SYSDATE         LAST_UPDATE_DATE
                               -- -----------------------------------------------------------------------------------------------
                               -- 20190830 추가 (START)
                              ,NVL(DEPT_ID, '-') AS DEPT_ID
                              ,NVL(END_CUSTOMER, '-') AS END_CUSTOMER
                              ,NVL(BIZ_TYPE, '-') AS BIZ_TYPE --,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
                               --UNIQUE ERROR 2026-03-19 김준규 추가
                              ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, MEASURE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE, YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY, INCOTERMS, CELL_PROD_SITE ORDER BY YYYYMM DESC) RNUM
                        -- 20190830 추가 (END)
                        -- -----------------------------------------------------------------------------------------------
                        FROM   GT_SDPB2_BP_FCST_4
                        WHERE  MEASURE IN ('Business_Plan', 'MKT_FCST', 'LOC')) X
                WHERE  RNUM = 1
                      --UNIQUE ERROR 2026-03-19 김준규 추가
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_PLN_BP_FCST DPBF
                        WHERE  1 = 1
                        AND    X.DIVISION_ID = DPBF.DIVISION_ID
                        AND    X.PROJECT_CODE = DPBF.PROJECT_CODE
                        AND    X.SCM_SITE_ID = DPBF.SCM_SITE_ID
                        AND    X.ITEM_ID = DPBF.ITEM_ID
                        AND    X.FCST_TYPE = DPBF.FCST_TYPE
                        AND    X.MEASURE = DPBF.MEASURE
                        AND    X.PLANT_SITE_ID = DPBF.PLANT_SITE_ID
                        AND    X.DEPT_ID = DPBF.DEPT_ID
                        AND    X.END_CUSTOMER = DPBF.END_CUSTOMER
                        AND    X.BIZ_TYPE = DPBF.BIZ_TYPE
                        AND    X.YYYYMM = DPBF.YYYYMM
                        AND    X.CURRENCY = DPBF.CURRENCY
                        AND    X.ITEM_USE = DPBF.ITEM_USE
                        AND    X.UNIT_ENERGY = DPBF.UNIT_ENERGY
                        AND    X.INCOTERMS = DPBF.INCOTERMS
                        AND    X.CELL_PROD_SITE = DPBF.CELL_PROD_SITE)

                ;

            -- -----------------------------------------------------------------------------------------------
            -- 20190830 81사업부 CAR_QTY 저장
            -- -----------------------------------------------------------------------------------------------
            INSERT /*+ NO_PARALLEL */
            INTO GT_SDPB2_BP_FCST_4
                (DIVISION_ID
                ,PROJECT_CODE
                ,PROJECT_NAME
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,YYYYMM
                ,CURRENCY
                ,MEASURE
                ,FCST_TYPE
                ,INCOTERMS -- PJ20200138 Incoterms 삭제
                 -- -----------------------------------------------------------------------------------------------
                 -- PJ20200138 item_use, unit_energy 추가 (START)
                ,ITEM_USE
                ,UNIT_ENERGY
                 -- PJ20200138 item_use, unit_energy 추가 (END)
                 -- -----------------------------------------------------------------------------------------------
                ,CELL_PROD_SITE
                ,QTY
                ,CREATED_BY
                ,LAST_UPDATED_BY
                 -- -----------------------------------------------------------------------------------------------
                 -- 20190830 추가 (START)
                ,DEPT_ID
                ,END_CUSTOMER
                ,BIZ_TYPE --,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
                 -- 20190830 추가 (END)
                 -- -----------------------------------------------------------------------------------------------
                 )
                SELECT F.DIVISION_ID
                      ,F.PROJECT_CODE
                      ,F.PROJECT_NAME
                      ,F.SCM_SITE_ID
                      ,F.PLANT_SITE_ID
                      ,F.ITEM_ID
                      ,F.YYYYMM
                      ,F.CURRENCY
                      ,'CAR_QTY' AS MEASURE
                      ,FCST_TYPE
                      ,INCOTERMS -- PJ20200138 Incoterms 삭제
                       -- -----------------------------------------------------------------------------------------------
                       -- PJ20200138 item_use, unit_energy 추가 (START)
                      ,ITEM_USE
                      ,NVL(TO_NUMBER(UNIT_ENERGY), 0)
                       -- PJ20200138 item_use, unit_energy 추가 (END)
                       -- -----------------------------------------------------------------------------------------------
                      ,CELL_PROD_SITE
                       /*,CASE WHEN BIZ_TYPE = 'CELL' THEN NVL(TO_NUMBER(QTY),0) / CASE WHEN TO_NUMBER(CELL_PER_PACK) = 0 THEN 1 END  -- 20190906 ZERO값 발생하는 오류로 CASE문 추가
                         WHEN BIZ_TYPE = 'MODULE' THEN NVL(TO_NUMBER(QTY),0) / CASE WHEN TO_NUMBER(MODULE_PER_PACK) = 0 THEN 1 END  -- 20190906 ZERO값 발생하는 오류로 CASE문 추가
                         WHEN BIZ_TYPE = 'PACK' THEN QTY
                       END AS QTY         */
                      ,CASE
                           WHEN INSTR(I.ITEM_CLASS_NAME, 'Cell') > 0 AND NVL(SI.CELL_PER_CAR, 0) > 0 THEN
                            NVL(TO_NUMBER(F.QTY), 0) / CASE
                                WHEN SI.CELL_PER_CAR = 0 THEN
                                 1
                                ELSE
                                 SI.CELL_PER_CAR
                            END
                           WHEN INSTR(I.ITEM_CLASS_NAME, 'Module') > 0 AND NVL(SI.CELL_PER_CAR / SI.CELL_PER_MODULE, 0) > 0 THEN
                            NVL(TO_NUMBER(F.QTY), 0) / CASE
                                WHEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE = 0 THEN
                                 1
                                ELSE
                                 SI.CELL_PER_CAR / SI.CELL_PER_MODULE
                            END
                           WHEN INSTR(I.ITEM_CLASS_NAME, 'Pack') > 0 THEN
                            NVL(TO_NUMBER(F.QTY), 0)
                           ELSE
                            0
                       END AS QTY
                      ,F.CREATED_BY
                      ,F.LAST_UPDATED_BY
                       -- -----------------------------------------------------------------------------------------------
                       -- 20190830 추가 (START)
                      ,F.DEPT_ID
                      ,END_CUSTOMER
                      ,BIZ_TYPE --,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
                -- 20190830 추가 (END)
                -- -----------------------------------------------------------------------------------------------
                FROM   GT_SDPB2_BP_FCST_4 F
                -- -----------------------------------------------------------------------------------------------
                -- [E20250522-001188]_DM_MST_ITEM_SINGLE_V 대신 TEMP로 생성한 테이블을 사용 원소스 주석처리 (START)
                --LEFT JOIN DM_MST_ITEM_SINGLE_V I
                LEFT   JOIN GT_SDPB_DM_MST_ITEM_SINGLE_V I
                -- [E20250522-001188]_DM_MST_ITEM_SINGLE_V 대신 TEMP로 생성한 테이블을 사용 원소스 주석처리 (END)
                -- -----------------------------------------------------------------------------------------------
                ON     F.DIVISION_ID = I.DIVISION_ID
                AND    F.ITEM_ID = I.ITEM_ID
                LEFT   JOIN SCM_MST_SITE_ITEM SI
                ON     F.DIVISION_ID = SI.DIVISION_ID
                AND    F.PROJECT_CODE = SI.PROJECT_CODE
                AND    F.SCM_SITE_ID = SI.SCM_SITE_ID
                AND    F.ITEM_ID = SI.ITEM_ID
                WHERE  MEASURE = 'Business_Plan'
                AND    F.DIVISION_ID = '81'
                AND    SI.VALID_YN = 'Y';
        END;
        --======================================================
        -- INPUT된 Business_Plan MEASURE INSERT (END)
        --======================================================
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A007-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        --======================================================
        -- FUTURE PRICE 계산 Procedure 호출 (START)
        --======================================================
        -- TEMP TABLE 을 전달함 GT_SDPB2_BP_FCST_4
        BEGIN
            PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV('CALL', NULL, V_RC1_SUB, V_RC2_SUB,V_RESULT_CURSOR_SUB);
        END;
        --======================================================
        -- FUTURE PRICE 계산 Procedure 호출 (END)
        --======================================================
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A008-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        --======================================================
        --GT_SDPB2_BP_FCST_4 테이블에 split후 INSERT (END)
        --======================================================
        BEGIN
            -- -----------------------------------------------------------------------------------------------
            -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (START)
            SELECT COUNT(1) INTO V_CNT_2 FROM GT_SDPB2_BP_FCST_4 WHERE DIVISION_ID <> '40';
            IF V_CNT_2 > 0 THEN
                SELECT COUNT(1)
                INTO   V_CNT_3
                FROM   GT_SDPB2_BP_FCST_4
                WHERE  (SELECT COUNT(1) FROM SCM_MST_PROJECT WHERE PROJECT_CODE = PROJECT_CODE) = 0
                AND    PROJECT_CODE <> 'N' --20180423 SKH validation 조건에서 제외시킴
                AND    DIVISION_ID <> '40'; -- 20180614 KHSOMG 40 DIVISION 조건 추가
                IF V_CNT_3 > 0 THEN
                    V_LOG_TYPE := 'INVALID';
                    SELECT '[' || PROJECT_CODE || ']' || ' Invalid Project Code !'
                    INTO   V_LOG_MESSAGE
                    FROM   GT_SDPB2_BP_FCST_4
                    WHERE  PROJECT_CODE NOT IN (SELECT PROJECT_CODE FROM SCM_MST_PROJECT) FETCH FIRST 1 ROWS ONLY;
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_MESSAGE AS EVENT FROM DUAL;
                    GOTO END_PROC;
                END IF;
            END IF;
            -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (END)
            -- -----------------------------------------------------------------------------------------------
            -- -----------------------------------------------------------------------------------------------
            -- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (START) [c20200722-000060]
            SELECT COUNT(1) INTO V_CNT_4 FROM GT_SDPB2_BP_FCST_4 WHERE DIVISION_ID = '40';
            IF V_CNT_4 > 0 THEN
                SELECT COUNT(1)
                INTO   V_CNT_5
                FROM   GT_SDPB2_BP_FCST_4 A
                LEFT   OUTER JOIN SCM_MST_SITE B
                ON     A.DIVISION_ID = B.DIVISION_ID
                AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                AND    B.VALID_YN = 'Y'
                WHERE  B.DIVISION_ID IS NULL;
                IF V_CNT_5 > 0 THEN
                    V_LOG_TYPE := 'INVALID';
                    SELECT '[' || A.SCM_SITE_ID || ']' || ' Invalid Sales Site !'
                    INTO   V_LOG_MESSAGE
                    FROM   GT_SDPB2_BP_FCST_4 A
                    LEFT   OUTER JOIN SCM_MST_SITE B
                    ON     A.DIVISION_ID = B.DIVISION_ID
                    AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND    B.VALID_YN = 'Y'
                    WHERE  B.DIVISION_ID IS NULL FETCH FIRST 1 ROWS ONLY;
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_MESSAGE AS EVENT FROM DUAL;
                    GOTO END_PROC;
                END IF;

                SELECT COUNT(1)
                INTO   V_CNT_6
                FROM   GT_SDPB2_BP_FCST_4 A
                LEFT   OUTER JOIN SCM_MST_SITE_ITEM B
                ON     A.DIVISION_ID = B.DIVISION_ID
                AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                AND    A.PROJECT_CODE = B.PROJECT_CODE
                AND    A.ITEM_ID = B.ITEM_ID
                AND    B.VALID_YN = 'Y'
                WHERE  B.DIVISION_ID IS NULL;
                IF V_CNT_6 > 0 THEN
                    V_LOG_TYPE := 'INVALID';
                    SELECT '[' || RTRIM(A.SCM_SITE_ID) || '/ ' || RTRIM(A.PROJECT_CODE) || '/ ' || RTRIM(A.ITEM_ID) || ']' ||
                           ' Invalid Sales Site/Project Code/Item !'
                    INTO   V_LOG_MESSAGE
                    FROM   GT_SDPB2_BP_FCST_4 A
                    LEFT   OUTER JOIN SCM_MST_SITE_ITEM B
                    ON     A.DIVISION_ID = B.DIVISION_ID
                    AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND    A.PROJECT_CODE = B.PROJECT_CODE
                    AND    A.ITEM_ID = B.ITEM_ID
                    AND    B.VALID_YN = 'Y'
                    WHERE  B.DIVISION_ID IS NULL FETCH FIRST 1 ROWS ONLY;
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_MESSAGE AS EVENT FROM DUAL;
                    GOTO END_PROC;
                END IF;
            END IF;
            -- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (END) [c20200722-000060]
            -- -----------------------------------------------------------------------------------------------
            BEGIN
                --======================================================
                -- LOC INSERT (START)
                --======================================================
                INSERT /*+ NO_PARALLEL */
                INTO GT_SDPB2_BP_FCST_4
                    SELECT ACTIVE_FLAG
                          ,TMP.DIVISION_ID
                          ,TMP.PROJECT_CODE
                          ,TMP.PROJECT_NAME
                          ,TMP.SCM_SITE_ID
                          ,TMP.PLANT_SITE_ID
                          ,TMP.ITEM_ID --,TMP.DOM_EXP
                          ,TMP.FCST_TYPE
                          ,TMP.INCOTERMS -- PJ20200138 Incoterms 삭제
                           -- -----------------------------------------------------------------------------------------------
                           -- PJ20200138 item_use, unit_energy 추가 (START)
                          ,TMP.ITEM_USE
                          ,TMP.UNIT_ENERGY
                           -- PJ20200138 item_use, unit_energy 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,'SalesAmt_LOC' MEASURE
                          ,TMP.YYYYMM
                          ,TMP.CURRENCY
                          ,NVL(FCST.QTY * TMP.QTY, 0)
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
                          ,TMP.DEPT_ID
                          ,TMP.END_CUSTOMER
                          ,TMP.BIZ_TYPE
                          ,TMP.CELL_PROD_SITE
                           -- 20190830 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,TMP.CREATED_BY
                          ,TMP.LAST_UPDATED_BY
                    FROM   GT_SDPB2_BP_FCST_4 TMP
                    INNER  JOIN DM_PLN_BP_FCST FCST
                    ON     TMP.DIVISION_ID = FCST.DIVISION_ID
                    AND    TMP.PROJECT_CODE = FCST.PROJECT_CODE
                          -- -----------------------------------------------------------------------------------------------
                          -- 20200106 KHSONG 수정 (START)
                          --AND TMP.PROJECT_NAME     = FCST.PROJECT_NAME  -- 주석처리
                    AND    TMP.SCM_SITE_ID = FCST.SCM_SITE_ID -- ADDED
                          -- 20200106 KHSONG 수정 (END)
                          -- -----------------------------------------------------------------------------------------------
                    AND    TMP.PLANT_SITE_ID = FCST.PLANT_SITE_ID
                    AND    TMP.ITEM_ID = FCST.ITEM_ID
                    AND    TMP.CELL_PROD_SITE = FCST.CELL_PROD_SITE
                    AND    TMP.FCST_TYPE = FCST.FCST_TYPE
                    AND    TMP.INCOTERMS = FCST.INCOTERMS -- PJ20200138 Incoterms 삭제
                    AND    TMP.YYYYMM = FCST.YYYYMM
                    AND    TMP.CURRENCY = FCST.CURRENCY
                    AND    FCST.MEASURE IN ('Business_Plan', 'MKT_FCST')
                          -- -----------------------------------------------------------------------------------------------
                          -- 20190830 추가 (START)
                    AND    TMP.DEPT_ID = FCST.DEPT_ID
                    AND    TMP.END_CUSTOMER = FCST.END_CUSTOMER
                    AND    TMP.BIZ_TYPE = FCST.BIZ_TYPE
                          -- 20190830 추가 (END)
                          -- -----------------------------------------------------------------------------------------------
                          -- -----------------------------------------------------------------------------------------------
                          -- PJ20200138 item_use, unit_energy 추가 (START)
                    AND    TMP.ITEM_USE = FCST.ITEM_USE
                    AND    TMP.UNIT_ENERGY = FCST.UNIT_ENERGY
                    -- PJ20200138 item_use, unit_energy 추가 (END)
                    -- -----------------------------------------------------------------------------------------------
                    WHERE  1 = 1
                    AND    TMP.MEASURE = 'LOC';
                --======================================================
                -- LOC INSERT (END)
                --======================================================
                --======================================================
                -- KRW INSERT (START)
                --======================================================
                INSERT /*+ NO_PARALLEL */
                INTO GT_SDPB2_BP_FCST_4
                    SELECT ACTIVE_FLAG
                          ,DIVISION_ID
                          ,PROJECT_CODE
                          ,PROJECT_NAME
                          ,SCM_SITE_ID
                          ,PLANT_SITE_ID
                          ,ITEM_ID --,DOM_EXP
                          ,FCST_TYPE
                          ,INCOTERMS -- PJ20200138 Incoterms 삭제
                           -- -----------------------------------------------------------------------------------------------
                           -- PJ20200138 item_use, unit_energy 추가 (START)
                          ,ITEM_USE
                          ,UNIT_ENERGY
                           -- PJ20200138 item_use, unit_energy 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,'SalesAmt_KRW' AS MEASURE
                          ,YYYYMM
                          ,CURRENCY
                          ,NVL((SELECT CASE
                                          WHEN TMP.CURRENCY = 'KRW' THEN
                                           TMP.QTY
                                          ELSE
                                           CASE
                                               WHEN TMP.CURRENCY = 'USD' THEN
                                                NVL(TMP.QTY * (SELECT EXCHANGE_PRICE
                                                               FROM   DM_BP_EXCHANGE_RATE
                                                               WHERE  DIVISION_ID = TMP.DIVISION_ID
                                                               AND    YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01'
                                                               AND    UNIT_CURRENCY = 'USD'
                                                               GROUP  BY EXCHANGE_PRICE)
                                                   ,0)
                                               ELSE
                                                CASE
                                                    WHEN TMP.CURRENCY NOT IN ('KRW', 'USD') THEN
                                                     NVL(TMP.QTY * (SELECT EXCHANGE_PRICE
                                                                    FROM   DM_BP_EXCHANGE_RATE
                                                                    WHERE  DIVISION_ID = TMP.DIVISION_ID
                                                                    AND    YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01'
                                                                    AND    UNIT_CURRENCY = TMP.CURRENCY
                                                                    GROUP  BY EXCHANGE_PRICE)
                                                        ,0)
                                                END
                                           END
                                      END
                               FROM   DUAL)
                              ,0)
                           -- -----------------------------------------------------------------------------------------------
                           -- 20190830 추가 (START)
                          ,DEPT_ID
                          ,END_CUSTOMER
                          ,BIZ_TYPE
                          ,CELL_PROD_SITE
                           -- 20190830 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,CREATED_BY
                          ,LAST_UPDATED_BY
                    FROM   GT_SDPB2_BP_FCST_4 TMP
                    WHERE  TMP.MEASURE = 'SalesAmt_LOC';
                --======================================================
                -- KRW INSERT (END)
                --======================================================
                --======================================================
                -- USD INSERT (START)
                --======================================================
                -- 20190906
                INSERT /*+ NO_PARALLEL */
                INTO GT_SDPB2_BP_FCST_4
                    SELECT ACTIVE_FLAG
                          ,DIVISION_ID
                          ,PROJECT_CODE
                          ,PROJECT_NAME
                          ,SCM_SITE_ID
                          ,PLANT_SITE_ID
                          ,ITEM_ID --,DOM_EXP
                          ,FCST_TYPE
                          ,INCOTERMS -- PJ20200138 Incoterms 삭제
                           -- -----------------------------------------------------------------------------------------------
                           -- PJ20200138 item_use, unit_energy 추가 (START)
                          ,ITEM_USE
                          ,UNIT_ENERGY
                           -- PJ20200138 item_use, unit_energy 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,'SalesAmt_USD' AS MEASURE
                          ,YYYYMM
                          ,CURRENCY
                          ,NVL((SELECT CASE
                                          WHEN TMP.CURRENCY = 'KRW' THEN
                                           NVL(TMP.QTY / (SELECT EXCHANGE_PRICE
                                                          FROM   DM_BP_EXCHANGE_RATE
                                                          WHERE  DIVISION_ID = TMP.DIVISION_ID
                                                          AND    YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01'
                                                          AND    UNIT_CURRENCY = 'USD'
                                                          GROUP  BY EXCHANGE_PRICE)
                                              ,0)
                                          ELSE
                                           CASE
                                               WHEN TMP.CURRENCY = 'USD' THEN
                                                TMP.QTY
                                               ELSE
                                                CASE
                                                    WHEN TMP.CURRENCY NOT IN ('KRW', 'USD') -- KRW산출후 / USD
                                                     THEN
                                                     NVL(TMP.QTY * (SELECT EXCHANGE_PRICE
                                                                    FROM   DM_BP_EXCHANGE_RATE
                                                                    WHERE  DIVISION_ID = TMP.DIVISION_ID
                                                                    AND    YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01'
                                                                    AND    UNIT_CURRENCY = TMP.CURRENCY
                                                                    GROUP  BY EXCHANGE_PRICE)
                                                        ,0) / (SELECT EXCHANGE_PRICE
                                                               FROM   DM_BP_EXCHANGE_RATE
                                                               WHERE  DIVISION_ID = TMP.DIVISION_ID
                                                               AND    YYYYMMDD = SUBSTR(TMP.YYYYMM, 1, 6) || '01'
                                                               AND    UNIT_CURRENCY = 'USD'
                                                               GROUP  BY EXCHANGE_PRICE)
                                                END
                                           END
                                      END
                               FROM   DUAL)
                              ,0)
                           -- -----------------------------------------------------------------------------------------------
                           -- 20190830 추가 (START)
                          ,DEPT_ID
                          ,END_CUSTOMER
                          ,BIZ_TYPE
                          ,CELL_PROD_SITE
                           -- 20190830 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,CREATED_BY
                          ,LAST_UPDATED_BY
                    FROM   GT_SDPB2_BP_FCST_4 TMP
                    WHERE  TMP.MEASURE = 'SalesAmt_LOC';
            END;
            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A008-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

            BEGIN
                SELECT COUNT(1) INTO N_INSERT_COUNT FROM GT_SDPB2_BP_FCST_4 WHERE MEASURE = 'SalesAmt_LOC';
            END;

            BEGIN
                INSERT /*+ NO_PARALLEL */
                INTO GT_SDPB2_DM_PLN_BP_FCST_X_4
                    (DIVISION_ID
                    ,PROJECT_CODE
                    ,PROJECT_NAME
                    ,SCM_SITE_ID
                    ,PLANT_SITE_ID
                    ,ITEM_ID --,DOM_EXP
                    ,FCST_TYPE
                    ,INCOTERMS -- PJ20200138 Incoterms 삭제
                     -- -----------------------------------------------------------------------------------------------
                     -- PJ20200138 item_use, unit_energy 추가 (START)
                    ,ITEM_USE
                    ,UNIT_ENERGY
                     -- PJ20200138 item_use, unit_energy 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,MEASURE
                    ,YYYYMM
                    ,CURRENCY
                    ,QTY
                     -- -----------------------------------------------------------------------------------------------
                     -- 20190830 추가 (START)
                    ,DEPT_ID
                    ,END_CUSTOMER
                    ,BIZ_TYPE
                    ,CELL_PROD_SITE --,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
                     -- 20190830 추가 (END)
                     -- -----------------------------------------------------------------------------------------------
                    ,CREATED_BY
                    ,LAST_UPDATED_BY)
                    SELECT DIVISION_ID
                          ,PROJECT_CODE
                          ,PROJECT_NAME
                          ,SCM_SITE_ID
                          ,PLANT_SITE_ID
                          ,ITEM_ID --,DOM_EXP
                          ,FCST_TYPE
                          ,INCOTERMS -- PJ20200138 Incoterms 삭제
                           -- -----------------------------------------------------------------------------------------------
                           -- PJ20200138 item_use, unit_energy 추가 (START)
                          ,ITEM_USE
                          ,UNIT_ENERGY
                           -- PJ20200138 item_use, unit_energy 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,MEASURE
                          ,YYYYMM
                          ,CURRENCY
                          ,NVL(QTY, 0)
                           -- -----------------------------------------------------------------------------------------------
                           -- 20190830 추가 (START)
                          ,DEPT_ID
                          ,END_CUSTOMER
                          ,BIZ_TYPE
                          ,CELL_PROD_SITE --,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
                           -- 20190830 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,CREATED_BY
                          ,LAST_UPDATED_BY
                    FROM   GT_SDPB2_BP_FCST_4
                    WHERE  1 = 1;

                -- ----------------------------------------------------------------
                /* [2018-03-19][CURSOR를 이용해 HISTORY TABLE ADD
                  방법1 : PROCEDURE CALL
                  방법2 : 바로입력
                */
                -- ----------------------------------------------------------------
                -- 커서를 이용해 DIVISION_ID 만큼 LOOP
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

                FOR CUR_REC IN (SELECT DIVISION_ID
                                      ,PROJECT_CODE
                                      ,PROJECT_NAME
                                      ,SCM_SITE_ID
                                      ,PLANT_SITE_ID
                                      ,ITEM_ID --,DOM_EXP
                                      ,FCST_TYPE
                                      ,INCOTERMS -- PJ20200138 Incoterms 삭제
                                       -- -----------------------------------------------------------------------------------------------
                                       -- PJ20200138 item_use, unit_energy 추가 (START)
                                      ,ITEM_USE
                                      ,UNIT_ENERGY
                                       -- PJ20200138 item_use, unit_energy 추가 (END)
                                       -- -----------------------------------------------------------------------------------------------
                                      ,MEASURE
                                      ,YYYYMM
                                      ,CURRENCY
                                      ,QTY
                                       -- -----------------------------------------------------------------------------------------------
                                       -- 20190830 추가 (START)
                                      ,DEPT_ID
                                      ,END_CUSTOMER
                                      ,BIZ_TYPE
                                      ,CELL_PROD_SITE --,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
                                       -- 20190830 추가 (END)
                                       -- -----------------------------------------------------------------------------------------------
                                      ,CREATED_BY
                                      ,LAST_UPDATED_BY
                                FROM   (SELECT DIVISION_ID
                                              ,PROJECT_CODE
                                              ,PROJECT_NAME
                                              ,SCM_SITE_ID
                                              ,PLANT_SITE_ID
                                              ,ITEM_ID --,DOM_EXP
                                              ,FCST_TYPE
                                              ,INCOTERMS -- PJ20200138 Incoterms 삭제
                                               -- -----------------------------------------------------------------------------------------------
                                               -- PJ20200138 item_use, unit_energy 추가 (START)
                                              ,ITEM_USE
                                              ,UNIT_ENERGY
                                               -- PJ20200138 item_use, unit_energy 추가 (END)
                                               -- -----------------------------------------------------------------------------------------------
                                              ,MEASURE
                                              ,YYYYMM
                                              ,CURRENCY
                                              ,QTY
                                               -- -----------------------------------------------------------------------------------------------
                                               -- 20190830 추가 (START)
                                              ,DEPT_ID
                                              ,END_CUSTOMER
                                              ,BIZ_TYPE
                                              ,CELL_PROD_SITE --,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
                                               -- 20190830 추가 (END)
                                               -- -----------------------------------------------------------------------------------------------
                                              ,CREATED_BY
                                              ,LAST_UPDATED_BY
                                               --UNIQUE ERROR 2026-03-19 김준규 추가
                                              ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, MEASURE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE, YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY, INCOTERMS, CELL_PROD_SITE ORDER BY YYYYMM DESC) RNUM
                                        FROM   GT_SDPB2_BP_FCST_4
                                        WHERE  1 = 1) X
                                WHERE  RNUM = 1
                                      --UNIQUE ERROR 2026-03-19 김준규 추가
                                AND    NOT EXISTS (SELECT 1
                                        FROM   DM_PLN_BP_FCST_H DPBF
                                        WHERE  1 = 1
                                        AND    X.DIVISION_ID = DPBF.DIVISION_ID
                                        AND    X.PROJECT_CODE = DPBF.PROJECT_CODE
                                        AND    X.SCM_SITE_ID = DPBF.SCM_SITE_ID
                                        AND    X.ITEM_ID = DPBF.ITEM_ID
                                        AND    X.FCST_TYPE = DPBF.FCST_TYPE
                                        AND    X.MEASURE = DPBF.MEASURE
                                        AND    X.PLANT_SITE_ID = DPBF.PLANT_SITE_ID
                                        AND    X.DEPT_ID = DPBF.DEPT_ID
                                        AND    X.END_CUSTOMER = DPBF.END_CUSTOMER
                                        AND    X.BIZ_TYPE = DPBF.BIZ_TYPE
                                        AND    X.YYYYMM = DPBF.YYYYMM
                                        AND    X.CURRENCY = DPBF.CURRENCY
                                        AND    X.ITEM_USE = DPBF.ITEM_USE
                                        AND    X.UNIT_ENERGY = DPBF.UNIT_ENERGY
                                        AND    X.INCOTERMS = DPBF.INCOTERMS
                                        AND    X.CELL_PROD_SITE = DPBF.CELL_PROD_SITE)) LOOP
                    V_DIVISION_ID     := CUR_REC.DIVISION_ID;
                    V_PROJECT_CODE    := CUR_REC.PROJECT_CODE;
                    V_PROJECT_NAME    := CUR_REC.PROJECT_NAME;
                    V_SCM_SITE_ID     := CUR_REC.SCM_SITE_ID;
                    V_PLANT_SITE_ID   := CUR_REC.PLANT_SITE_ID;
                    V_ITEM_ID         := CUR_REC.ITEM_ID;
                    V_FCST_TYPE       := CUR_REC.FCST_TYPE;
                    V_INCOTERMS       := CUR_REC.INCOTERMS;
                    V_ITEM_USE        := CUR_REC.ITEM_USE;
                    V_UNIT_ENERGY     := CUR_REC.UNIT_ENERGY;
                    V_MEASURE         := CUR_REC.MEASURE;
                    V_YYYYMM          := CUR_REC.YYYYMM;
                    V_CURRENCY        := CUR_REC.CURRENCY;
                    V_QTY             := CUR_REC.QTY;
                    V_DEPT_ID         := CUR_REC.DEPT_ID;
                    V_END_CUSTOMER    := CUR_REC.END_CUSTOMER;
                    V_BIZ_TYPE        := CUR_REC.BIZ_TYPE;
                    V_CELL_PROD_SITE  := CUR_REC.CELL_PROD_SITE;
                    V_CREATED_BY      := CUR_REC.CREATED_BY;
                    V_LAST_UPDATED_BY := CUR_REC.LAST_UPDATED_BY;
                    SELECT SEQ1_DM_PLN_BP_FCST_H.NEXTVAL INTO N_HISTORY_SEQ FROM DUAL;
                    --======================================================
                    -- HISTORY INSERT (START)
                    --======================================================
                    INSERT INTO DM_PLN_BP_FCST_H
                        (HISTORY_SEQ
                        ,ACTIVE_FLAG
                        ,DIVISION_ID
                        ,PROJECT_CODE
                        ,PROJECT_NAME
                        ,SCM_SITE_ID
                        ,PLANT_SITE_ID
                        ,ITEM_ID
                        ,DOM_EXP
                        ,FCST_TYPE
                         -- -----------------------------------------------------------------------------------------------
                         -- PJ20200138 item_use, unit_energy 추가 (START)
                        ,ITEM_USE
                        ,UNIT_ENERGY
                         -- PJ20200138 item_use, unit_energy 추가 (END)
                         -- -----------------------------------------------------------------------------------------------
                        ,INCOTERMS
                        ,MEASURE
                        ,YYYYMM
                        ,CURRENCY
                        ,QTY -- PJ20200138 Incoterms 삭제
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                         -- -----------------------------------------------------------------------------------------------
                         -- 20190830 추가 (START)
                        ,DEPT_ID
                        ,END_CUSTOMER
                        ,BIZ_TYPE
                        ,CELL_PROD_SITE --,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
                         -- 20190830 추가 (END)
                         -- -----------------------------------------------------------------------------------------------
                         )
                    VALUES
                        (N_HISTORY_SEQ
                        ,V_ACTIVE_FLAG
                        ,V_DIVISION_ID
                        ,V_PROJECT_CODE
                        ,V_PROJECT_NAME
                        ,V_SCM_SITE_ID
                        ,NVL(V_PLANT_SITE_ID, '-')
                        ,V_ITEM_ID
                        ,''
                        ,V_FCST_TYPE
                         -- -----------------------------------------------------------------------------------------------
                         -- PJ20200138 item_use, unit_energy 추가 (START)
                        ,NVL(V_ITEM_USE, '-')
                        ,V_UNIT_ENERGY
                         -- PJ20200138 item_use, unit_energy 추가 (END)
                         -- -----------------------------------------------------------------------------------------------
                        ,V_INCOTERMS
                        ,V_MEASURE
                        ,V_YYYYMM
                        ,V_CURRENCY
                        ,NVL(V_QTY, 0) -- PJ20200138 Incoterms 삭제
                        ,V_CREATED_BY
                        ,SYSDATE
                        ,V_LAST_UPDATED_BY
                        ,SYSDATE
                         -- -----------------------------------------------------------------------------------------------
                         -- 20190830 추가 (START)
                        ,NVL(V_DEPT_ID, '-')
                        ,NVL(V_END_CUSTOMER, '-')
                        ,NVL(V_BIZ_TYPE, '-')
                        ,NVL(V_CELL_PROD_SITE, '-') --,v_CELL_PER_PACK,v_CELL_PER_MODULE,v_MODULE_PER_PACK
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
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A009-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        --======================================================
        -- DELETE (START)
        --======================================================

        DELETE FROM DM_PLN_BP_FCST
        WHERE  (SELECT COUNT(1)
                FROM   GT_SDPB2_DM_PLN_BP_FCST_X_4
                WHERE  1 = 1
                AND    DM_PLN_BP_FCST.DIVISION_ID = DIVISION_ID
                AND    DM_PLN_BP_FCST.PROJECT_CODE = PROJECT_CODE
                      --AND DM_PLN_BP_FCST.PROJECT_NAME = PROJECT_NAME
                AND    DM_PLN_BP_FCST.SCM_SITE_ID = SCM_SITE_ID
                AND    DM_PLN_BP_FCST.PLANT_SITE_ID = PLANT_SITE_ID
                AND    DM_PLN_BP_FCST.ITEM_ID = ITEM_ID
                AND    DM_PLN_BP_FCST.CELL_PROD_SITE = CELL_PROD_SITE
                AND    DM_PLN_BP_FCST.FCST_TYPE = FCST_TYPE
                AND    DM_PLN_BP_FCST.INCOTERMS = INCOTERMS -- PJ20200138 Incoterms 삭제
                      -- -----------------------------------------------------------------------------------------------
                      -- PJ20200138 item_use, unit_energy 추가 (START)
                AND    DM_PLN_BP_FCST.ITEM_USE = ITEM_USE
                AND    DM_PLN_BP_FCST.UNIT_ENERGY = UNIT_ENERGY
                      -- PJ20200138 item_use, unit_energy 추가 (END)
                      -- -----------------------------------------------------------------------------------------------
                AND    DM_PLN_BP_FCST.MEASURE = MEASURE
                AND    DM_PLN_BP_FCST.YYYYMM = YYYYMM
                      -- -----------------------------------------------------------------------------------------------
                      -- 20190830 추가 (START)
                AND    DM_PLN_BP_FCST.DEPT_ID = DEPT_ID
                AND    DM_PLN_BP_FCST.END_CUSTOMER = END_CUSTOMER
                AND    DM_PLN_BP_FCST.BIZ_TYPE = BIZ_TYPE
                      -- 20190830 추가 (END)
                      -- -----------------------------------------------------------------------------------------------
                AND    DM_PLN_BP_FCST.CURRENCY = CURRENCY -- 20190916 KHSONG ADDED
                ) > 0;
        --======================================================
        --======================================================
        -- DELETE (END)
        --======================================================
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A010-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        INSERT INTO DM_PLN_BP_FCST
            (DIVISION_ID
            ,PROJECT_CODE
            ,PROJECT_NAME
            ,SCM_SITE_ID
            ,PLANT_SITE_ID
            ,ITEM_ID
            ,DOM_EXP
            ,FCST_TYPE
            ,INCOTERMS -- PJ20200138 Incoterms 삭제
             -- -----------------------------------------------------------------------------------------------
             -- PJ20200138 item_use, unit_energy 추가 (START)
            ,ITEM_USE
            ,UNIT_ENERGY
             -- PJ20200138 item_use, unit_energy 추가 (END)
             -- -----------------------------------------------------------------------------------------------
            ,MEASURE
            ,YYYYMM
            ,CURRENCY
            ,QTY
             -- -----------------------------------------------------------------------------------------------
             -- 20190830 추가 (START)
            ,DEPT_ID
            ,END_CUSTOMER
            ,BIZ_TYPE
            ,CELL_PROD_SITE --,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
             -- 20190830 추가 (END)
             -- -----------------------------------------------------------------------------------------------
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE)
            SELECT NVL(DIVISION_ID, '-')
                  ,NVL(PROJECT_CODE, '-')
                  ,PROJECT_NAME
                  ,NVL(SCM_SITE_ID, '-')
                  ,NVL(PLANT_SITE_ID, '-') AS PLANT_SITE_ID
                  ,NVL(ITEM_ID, '-')
                  ,'' AS DOM_EXP
                  ,NVL(FCST_TYPE, '-')
                  ,NVL(INCOTERMS, '-') -- PJ20200138 Incoterms 삭제
                   -- -----------------------------------------------------------------------------------------------
                   -- PJ20200138 item_use, unit_energy 추가 (START)
                  ,NVL(ITEM_USE, '-') AS ITEM_USE
                  ,UNIT_ENERGY
                   -- PJ20200138 item_use, unit_energy 추가 (END)
                   -- -----------------------------------------------------------------------------------------------
                  ,NVL(MEASURE, '-')
                  ,NVL(YYYYMM, '-')
                  ,NVL(CURRENCY, '-')
                  ,QTY
                   -- -----------------------------------------------------------------------------------------------
                   -- 20190830 추가 (START)
                  ,NVL(DEPT_ID, '-') AS DEPT_ID
                  ,NVL(END_CUSTOMER, '-') AS END_CUSTOMER
                  ,NVL(BIZ_TYPE, '-') AS BIZ_TYPE
                  ,NVL(CELL_PROD_SITE, '-') AS CELL_PROD_SITE --,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
                   -- 20190830 추가 (END)
                   -- -----------------------------------------------------------------------------------------------
                  ,CREATED_BY
                  ,CREATION_DATE
                  ,LAST_UPDATED_BY
                  ,LAST_UPDATE_DATE
            FROM   (SELECT DIVISION_ID
                          ,PROJECT_CODE
                          ,PROJECT_NAME
                          ,SCM_SITE_ID
                          ,NVL(PLANT_SITE_ID, '-') AS PLANT_SITE_ID
                          ,ITEM_ID
                          ,'' AS DOM_EXP
                          ,FCST_TYPE
                          ,INCOTERMS -- PJ20200138 Incoterms 삭제
                           -- -----------------------------------------------------------------------------------------------
                           -- PJ20200138 item_use, unit_energy 추가 (START)
                          ,NVL(ITEM_USE, '-') AS ITEM_USE
                          ,UNIT_ENERGY
                           -- PJ20200138 item_use, unit_energy 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,MEASURE
                          ,YYYYMM
                          ,CURRENCY
                          ,QTY
                           -- -----------------------------------------------------------------------------------------------
                           -- 20190830 추가 (START)
                          ,NVL(DEPT_ID, '-') AS DEPT_ID
                          ,NVL(END_CUSTOMER, '-') AS END_CUSTOMER
                          ,NVL(BIZ_TYPE, '-') AS BIZ_TYPE
                          ,NVL(CELL_PROD_SITE, '-') AS CELL_PROD_SITE --,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
                           -- 20190830 추가 (END)
                           -- -----------------------------------------------------------------------------------------------
                          ,CREATED_BY
                          ,SYSDATE         AS CREATION_DATE
                          ,LAST_UPDATED_BY
                          ,SYSDATE         AS LAST_UPDATE_DATE
                           --UNIQUE ERROR 2026-03-19 김준규 추가
                          ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, MEASURE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE, YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY, INCOTERMS, CELL_PROD_SITE ORDER BY YYYYMM DESC) RNUM
                    FROM   GT_SDPB2_DM_PLN_BP_FCST_X_4
                    WHERE  1 = 1) X
            WHERE  RNUM = 1
                  --UNIQUE ERROR 2026-03-19 김준규 추가
            AND    NOT EXISTS (SELECT 1
                    FROM   DM_PLN_BP_FCST DPBF
                    WHERE  1 = 1
                    AND    X.DIVISION_ID = DPBF.DIVISION_ID
                    AND    X.PROJECT_CODE = DPBF.PROJECT_CODE
                    AND    X.SCM_SITE_ID = DPBF.SCM_SITE_ID
                    AND    X.ITEM_ID = DPBF.ITEM_ID
                    AND    X.FCST_TYPE = DPBF.FCST_TYPE
                    AND    X.MEASURE = DPBF.MEASURE
                    AND    X.PLANT_SITE_ID = DPBF.PLANT_SITE_ID
                    AND    X.DEPT_ID = DPBF.DEPT_ID
                    AND    X.END_CUSTOMER = DPBF.END_CUSTOMER
                    AND    X.BIZ_TYPE = DPBF.BIZ_TYPE
                    AND    X.YYYYMM = DPBF.YYYYMM
                    AND    X.CURRENCY = DPBF.CURRENCY
                    AND    X.ITEM_USE = DPBF.ITEM_USE
                    AND    X.UNIT_ENERGY = DPBF.UNIT_ENERGY
                    AND    X.INCOTERMS = DPBF.INCOTERMS
                    AND    X.CELL_PROD_SITE = DPBF.CELL_PROD_SITE)

            ;

        -- PK UPDATE 를 위해서 들어온경우 UPDATE 처리 후 바로 빠짐
        <<END_PKUPDATE>>
        NULL;

        <<END_PROC>>
        NULL;

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A011-- :' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
        --======================================================
        -- 트랜잭션 (COMMIT)
        --======================================================
        COMMIT;
        -- -----------------------------------------------------------------------------------------
        -- END TRY
        -- -----------------------------------------------------------------------------------------
        -- 수행결과 성공여부 DISPLAY
        IF V_LOG_TYPE IS NULL OR V_LOG_TYPE NOT IN ('ERROR', 'INVALID') THEN
            --======================================================
            -- 종료 LOG (START)
            --======================================================
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'delete_count= ' || TO_CHAR(N_DEL_COUNT) || ' / insert_count= ' || TO_CHAR(N_INSERT_COUNT);
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            -- -----------------------------------------------------------------------------------------
            -- ROLLBACK
            --======================================================
            -- 트랜잭션 (END)
            --======================================================
            -- ERROR LOG VALUE SAVE
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
            D_EVENT_DATE  := SYSTIMESTAMP;
            V_LOG_MESSAGE := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM; /*-- 에러메시지 DISPLAY --*/
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            -- -----------------------------------------------------------------------------------------
            -- END CATCH
            -- -----------------------------------------------------------------------------------------
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '.' || 'P_DMF0042_SAVE_DM_PLN_BP_FCST' || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM ||
                                    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0042_SAVE_DM_PLN_BP_FCST;


    PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV
    (
        S_FLAG        VARCHAR2
       ,S_DIVISION_ID VARCHAR2
       ,O_RC1         OUT SYS_REFCURSOR
       ,O_RC2         OUT SYS_REFCURSOR

       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
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
        * 2026/03/15 김준규 [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS

        V_MAX_LOOP_CNT     INTEGER := 0;
        V_MST_LOOP_CNT     INTEGER := 0;
        V_DIVISION_ID      VARCHAR2(4000 CHAR);
        V_PROJECT_CODE     VARCHAR2(4000 CHAR);
        V_PROJECT_NAME     VARCHAR2(4000 CHAR);
        V_SCM_SITE_ID      VARCHAR2(4000 CHAR);
        V_PLANT_SITE_ID    VARCHAR2(4000 CHAR);
        V_ITEM_ID          VARCHAR2(4000 CHAR);
        V_YYYYMM           VARCHAR2(4000 CHAR);
        V_CURRENCY         VARCHAR2(4000 CHAR);
        V_MEASURE          VARCHAR2(4000 CHAR);
        V_DOM_EXP          VARCHAR2(4000 CHAR);
        V_FCST_TYPE        VARCHAR2(4000 CHAR);
        V_INCOTERMS        VARCHAR2(4000 CHAR);
        V_ITEM_USE         VARCHAR2(4000 CHAR);
        V_UNIT_ENERGY      NUMBER(30, 10);
        V_CELL_PROD_SITE   VARCHAR2(4000 CHAR);
        V_PRICE            NUMBER(30, 10);
        V_CREATED_BY       VARCHAR2(4000 CHAR);
        V_CREATION_DATE    DATE;
        V_LAST_UPDATED_BY  VARCHAR2(4000 CHAR);
        V_LAST_UPDATE_DATE DATE;
        V_ROW_COUNT        VARCHAR2(4000 CHAR);
        V_DEPT_ID          VARCHAR2(4000 CHAR);
        V_END_CUSTOMER     VARCHAR2(4000 CHAR);
        V_BIZ_TYPE         VARCHAR2(4000 CHAR);
        N1_MEASURE         VARCHAR2(4000 CHAR);
        N2_MEASURE         VARCHAR2(4000 CHAR);
        N1_PRICE           NUMBER(30, 10);
        N2_PRICE           NUMBER(30, 10);
        V_PROGRAM_NAME     VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE         VARCHAR2(30 CHAR);
        N_LOG_COUNT        INTEGER := 0;
        V_LOG_MESSAGE      VARCHAR2(1000 CHAR);
        V_DESCRIPTION      VARCHAR2(500 CHAR);
        D_EVENT_DATE       DATE;
        V_CNT_1            INTEGER := 0;
        V_IN_PARA_DATA     VARCHAR2(4000);
        V_BP_QTY           NUMBER(30, 10);
        V_EXCHANGE_PRICE   NUMBER(30, 10);
        V_SQL_CODE         VARCHAR2(100) := NULL;
        V_SQL_ERRMSG       VARCHAR2(4000 CHAR) := NULL;

        CURSOR FUTURE_PRICE_CUR IS
            SELECT B.DIVISION_ID
                  ,B.PROJECT_CODE
                  ,B.PROJECT_NAME
                  ,B.SCM_SITE_ID
                  ,B.PLANT_SITE_ID
                  ,B.ITEM_ID
                  ,B.YYYYMM
                  ,B.CURRENCY
                  ,B.MEASURE
                  ,B.DOM_EXP
                  ,B.FCST_TYPE
                  ,B.INCOTERMS
                  ,B.ITEM_USE
                  ,B.UNIT_ENERGY
                  ,B.CELL_PROD_SITE
                  ,B.QTY
                  ,B.DEPT_ID
                  ,B.END_CUSTOMER
                  ,B.BIZ_TYPE
                  ,B.ROW_COUNT
                  ,NVL((SELECT C.QTY
                       FROM   GT_SDPB_FUTURE_PRICE_TEMP_QTY C
                       WHERE  C.DIVISION_ID = B.DIVISION_ID
                       AND    C.PROJECT_CODE = B.PROJECT_CODE
                       AND    C.SCM_SITE_ID = B.SCM_SITE_ID
                       AND    C.PLANT_SITE_ID = B.PLANT_SITE_ID
                       AND    C.ITEM_ID = B.ITEM_ID
                       AND    C.YYYYMM = B.YYYYMM
                       AND    C.CURRENCY = B.CURRENCY
                       AND    C.DOM_EXP = B.DOM_EXP
                       AND    C.FCST_TYPE = B.FCST_TYPE
                       AND    C.INCOTERMS = B.INCOTERMS
                       AND    C.ITEM_USE = B.ITEM_USE
                       AND    C.UNIT_ENERGY = B.UNIT_ENERGY
                       AND    C.CELL_PROD_SITE = B.CELL_PROD_SITE
                       AND    C.DEPT_ID = B.DEPT_ID
                       AND    C.END_CUSTOMER = B.END_CUSTOMER
                       AND    C.BIZ_TYPE = B.BIZ_TYPE
                       AND    C.MEASURE = 'Business_Plan'
                       AND    ROWNUM = 1)
                      ,0) V_BP_QTY
            FROM   GT_SDPBP_FUTURE_PRICE_TEMP2_4 B
            WHERE  B.MEASURE = 'LOC'
            ORDER  BY B.ROW_COUNT;
    BEGIN

        DBMS_OUTPUT.PUT_LINE('EXEC_001                                       =>  ' || TO_CHAR(SYSDATE));

        V_IN_PARA_DATA := JSON_OBJECT('s_flag' VALUE S_FLAG, 's_division_id' VALUE S_DIVISION_ID);

        -- PJ20200138 item_use, unit_energy 추가
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        --v_description := 'DIVISION_ID : ' || p_division_id;
        D_EVENT_DATE := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);
        V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
        -- 시작 LOG  (END)
        -- 트랜잭션 (START)
        --
        -- -----------------------------------------------------------------------------------------
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
        -- -----------------------------------------------------------------------------------------
        BEGIN

            -- Temp Table0 존재여부 확인하여 삭제
            DELETE FROM GT_SDPBP_FUTURE_PRICE_TEMP0_4;
            -- Temp Table2 존재여부 확인하여 삭제
            DELETE FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4;
            DELETE FROM GT_SDPB_FUTURE_PRICE_TEMP_QTY;
            DELETE FROM GT_SDPBP_FUTURE_PRICE_TEMP1_2;

            -- -------------------------------------------------------------------------------------------------------------------------------------------------------
            -- PROCEDURE 에서 GT_SDPB_BP_FCST 테이블로 CALL받은경우
            -- -------------------------------------------------------------------------------------------------------------------------------------------------------
            IF S_FLAG = 'CALL' THEN
                --임시확인
                --SELECT 'GT_SDPB_BP_FCST'
                --SELECT * FROM GT_SDPB_BP_FCST
                INSERT /*+ NO_PARALLEL */
                INTO GT_SDPBP_FUTURE_PRICE_TEMP0_4
                    SELECT DIVISION_ID
                          ,PROJECT_CODE
                          ,PROJECT_NAME
                          ,SCM_SITE_ID
                          ,ITEM_ID
                          ,NULL AS DOM_EXP
                          ,FCST_TYPE
                          ,INCOTERMS -- PJ20200138 Incoterms 삭제
                          ,ITEM_USE
                          ,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                          ,CELL_PROD_SITE
                          ,MEASURE
                          ,PLANT_SITE_ID
                          ,YYYYMM
                          ,CURRENCY
                          ,MAX(QTY) QTY
                          ,DEPT_ID
                          ,END_CUSTOMER
                          ,BIZ_TYPE -- 20190830 추가
                          ,COUNT(*) G_COUNT
                    FROM   GT_SDPB_BP_FCST
                    WHERE  1 = 1
                          --AND DIVISION_ID = p_division_id
                          --AND YYYYMM >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') -- 당주 월요일이후 데이터만 대상으로함
                    AND    MEASURE NOT IN ('Business_Plan', 'MKT_FCST')
                    GROUP  BY DIVISION_ID
                             ,PROJECT_CODE
                             ,PROJECT_NAME
                             ,SCM_SITE_ID
                             ,ITEM_ID
                             ,FCST_TYPE
                             ,INCOTERMS
                             ,ITEM_USE
                             ,UNIT_ENERGY
                             ,CELL_PROD_SITE
                             ,MEASURE
                             ,PLANT_SITE_ID
                             ,YYYYMM
                             ,CURRENCY
                             ,DEPT_ID
                             ,END_CUSTOMER
                             ,BIZ_TYPE
                    ORDER  BY DIVISION_ID
                             ,PROJECT_CODE
                             ,PROJECT_NAME
                             ,SCM_SITE_ID
                             ,ITEM_ID
                             ,FCST_TYPE
                             ,INCOTERMS
                             ,ITEM_USE
                             ,UNIT_ENERGY
                             ,CELL_PROD_SITE
                             ,MEASURE
                             ,PLANT_SITE_ID
                             ,YYYYMM
                             ,CURRENCY
                             ,DEPT_ID
                             ,END_CUSTOMER
                             ,BIZ_TYPE;

            END IF;

            IF S_FLAG <> 'CALL' THEN
                -- -------------------------------------------------------------------------------------------------------------------------------------------------------
                -- 전체대상인경우
                -- -------------------------------------------------------------------------------------------------------------------------------------------------------
                INSERT /*+ NO_PARALLEL */
                INTO GT_SDPBP_FUTURE_PRICE_TEMP0_4
                    SELECT DIVISION_ID
                          ,PROJECT_CODE
                          ,PROJECT_NAME
                          ,SCM_SITE_ID
                          ,ITEM_ID
                          ,DOM_EXP
                          ,FCST_TYPE
                          ,INCOTERMS -- PJ20200138 Incoterms 삭제
                          ,ITEM_USE
                          ,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                          ,CELL_PROD_SITE
                          ,MEASURE
                          ,PLANT_SITE_ID
                          ,YYYYMM
                          ,CURRENCY
                          ,MAX(QTY) QTY
                          ,DEPT_ID
                          ,END_CUSTOMER
                          ,BIZ_TYPE -- 20190830 추가
                          ,COUNT(*) G_COUNT
                    FROM   DM_PLN_BP_FCST
                    WHERE  1 = 1
                    AND    DIVISION_ID = S_DIVISION_ID
                    --AND YYYYMM >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') -- 당주 월요일이후 데이터만 대상으로함
                    GROUP  BY DIVISION_ID
                             ,PROJECT_CODE
                             ,PROJECT_NAME
                             ,SCM_SITE_ID
                             ,ITEM_ID
                             ,DOM_EXP
                             ,FCST_TYPE
                             ,INCOTERMS
                             ,ITEM_USE
                             ,UNIT_ENERGY
                             ,CELL_PROD_SITE
                             ,MEASURE
                             ,PLANT_SITE_ID
                             ,YYYYMM
                             ,CURRENCY
                             ,DEPT_ID
                             ,END_CUSTOMER
                             ,BIZ_TYPE
                    ORDER  BY DIVISION_ID
                             ,PROJECT_CODE
                             ,PROJECT_NAME
                             ,SCM_SITE_ID
                             ,ITEM_ID
                             ,DOM_EXP
                             ,FCST_TYPE
                             ,INCOTERMS
                             ,ITEM_USE
                             ,UNIT_ENERGY
                             ,CELL_PROD_SITE
                             ,MEASURE
                             ,PLANT_SITE_ID
                             ,YYYYMM
                             ,CURRENCY
                             ,DEPT_ID
                             ,END_CUSTOMER
                             ,BIZ_TYPE;
            END IF;

            -- Temp Table1 존재여부 확인하여 삭제
            -- 임시확인
            --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP0_4'
            --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP0_4
            -- Temp Table1 에 작업대상을 저장
            INSERT /*+ NO_PARALLEL */
            INTO GT_SDPBP_FUTURE_PRICE_TEMP1_2
                SELECT DIVISION_ID
                      ,PROJECT_CODE
                      ,PROJECT_NAME
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,DOM_EXP
                      ,FCST_TYPE
                      ,INCOTERMS -- PJ20200138 Incoterms 삭제
                      ,ITEM_USE
                      ,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                      ,CELL_PROD_SITE
                      ,MEASURE
                      ,PLANT_SITE_ID
                      ,YYYYMM
                      ,CURRENCY
                      ,MAX(QTY) QTY
                      ,DEPT_ID
                      ,END_CUSTOMER
                      ,BIZ_TYPE -- 20190830 추가
                      ,G_COUNT
                FROM   GT_SDPBP_FUTURE_PRICE_TEMP0_4
                WHERE  1 = 1
                --AND G_COUNT < 3     -- 3개 정상 셋트가 아닌경우만 대상으로함 -> 20180720 KHSONG 주석처리 전체를 다시 계산함
                GROUP  BY DIVISION_ID
                         ,PROJECT_CODE
                         ,PROJECT_NAME
                         ,SCM_SITE_ID
                         ,ITEM_ID
                         ,DOM_EXP
                         ,FCST_TYPE
                         ,INCOTERMS
                         ,ITEM_USE
                         ,UNIT_ENERGY
                         ,CELL_PROD_SITE
                         ,MEASURE
                         ,PLANT_SITE_ID
                         ,YYYYMM
                         ,CURRENCY
                         ,G_COUNT
                         ,DEPT_ID
                         ,END_CUSTOMER
                         ,BIZ_TYPE
                ORDER  BY DIVISION_ID
                         ,PROJECT_CODE
                         ,PROJECT_NAME
                         ,SCM_SITE_ID
                         ,ITEM_ID
                         ,DOM_EXP
                         ,FCST_TYPE
                         ,INCOTERMS
                         ,ITEM_USE
                         ,UNIT_ENERGY
                         ,CELL_PROD_SITE
                         ,MEASURE
                         ,PLANT_SITE_ID
                         ,YYYYMM
                         ,CURRENCY
                         ,G_COUNT
                         ,DEPT_ID
                         ,END_CUSTOMER
                         ,BIZ_TYPE;

            -- 임시확인
            --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP1_2'
            --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP1_2
            -- -------------------------------------------------------------------------------------------------------------------------------------------------------
            -- PROCEDURE 에서 GT_SDPB_BP_FCST 테이블로 CALL받은경우
            -- -------------------------------------------------------------------------------------------------------------------------------------------------------
            -- 대상데이터 INSERT INTO INSERT /*+ NO_PARALLEL */ INTO GT_SDPBP_FUTURE_PRICE_TEMP2_4
            INSERT /*+ NO_PARALLEL */
            INTO GT_SDPBP_FUTURE_PRICE_TEMP2_4
                SELECT B.DIVISION_ID
                      ,B.PROJECT_CODE
                      ,B.PROJECT_NAME
                      ,B.SCM_SITE_ID
                      ,B.ITEM_ID
                      ,B.DOM_EXP
                      ,B.FCST_TYPE
                      ,B.INCOTERMS -- PJ20200138 Incoterms 삭제
                      ,B.ITEM_USE
                      ,B.UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                      ,B.CELL_PROD_SITE
                      ,B.MEASURE
                      ,B.PLANT_SITE_ID
                      ,B.YYYYMM
                      ,B.CURRENCY
                      ,B.QTY
                      ,B.DEPT_ID
                      ,B.END_CUSTOMER
                      ,B.BIZ_TYPE -- 20190830 추가
                      ,G_COUNT
                      ,ROW_NUMBER() OVER(ORDER BY B.DIVISION_ID) ROW_COUNT
                FROM   GT_SDPBP_FUTURE_PRICE_TEMP1_2 B
                ORDER  BY G_COUNT;

            -- Business Plan 메저만 별도 저장
            INSERT /*+ NO_PARALLEL */
            INTO GT_SDPB_FUTURE_PRICE_TEMP_QTY
                SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4 WHERE MEASURE IN ('Business_Plan', 'MKT_FCST');

            -- 임시확인
            --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP2_4'
            --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4
            -- Temp Table3 존재여부 확인하여 삭제
            /* SELECT * INTO GT_SDPBP_FUTURE_PRICE_TEMP3_2
            FROM DM_PLN_BP_FCST  ; -- TEMP 테이블 컬럼생성*/

            DELETE FROM GT_SDPBP_FUTURE_PRICE_TEMP3_2;

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

            -- future_price_cur CURSOR fast_forward for
            --OPEN O_RC1 FOR

            -- 커서 오픈
            OPEN FUTURE_PRICE_CUR;

            -- -----------------------------------------------------------------------------------------------------
            FETCH FUTURE_PRICE_CUR
                INTO V_DIVISION_ID
                    ,V_PROJECT_CODE
                    ,V_PROJECT_NAME
                    ,V_SCM_SITE_ID
                    ,V_PLANT_SITE_ID
                    ,V_ITEM_ID
                    ,V_YYYYMM
                    ,V_CURRENCY
                    ,V_MEASURE
                    ,V_DOM_EXP
                    ,V_FCST_TYPE
                    ,V_INCOTERMS -- PJ20200138 Incoterms 삭제
                     -- PJ20200138 item_use, unit_energy 추가
                    ,V_ITEM_USE
                    ,V_UNIT_ENERGY
                    ,V_CELL_PROD_SITE
                    ,V_PRICE
                     -- 20190830 추가
                    ,V_DEPT_ID
                    ,V_END_CUSTOMER
                    ,V_BIZ_TYPE

                    ,V_ROW_COUNT
                    ,V_BP_QTY;
            -- -----------------------------------------------------------------------------------------------------
            WHILE FUTURE_PRICE_CUR%FOUND LOOP
                -- -----------------------------------------------------------------------------------------------------
                --확인 SELECT V_ROW_COUNT AS 'V_ROW_COUNT'
                --확인 SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP2_4  WHERE ROW_COUNT = V_ROW_COUNT
                -- 변수 초기화
                N1_MEASURE := NULL;
                N2_MEASURE := NULL;
                N1_PRICE   := 0;
                N2_PRICE   := 0;

                -- 임시확인
                --SELECT 'v_MEASURE',v_MEASURE,'v_CURRENCY',v_CURRENCY
                -- -----------------------------------------------------------------------------------------------------
                IF V_MEASURE = 'LOC' AND V_CURRENCY = 'KRW' THEN
                    -- KRW SETTING
                    N1_MEASURE := 'KRW';
                    N1_PRICE   := V_PRICE;

                    -- USD 산출
                    N2_MEASURE := 'USD';
                    BEGIN
                        SELECT NVL(EXCHANGE_PRICE, 1)
                        INTO   V_EXCHANGE_PRICE
                        FROM   DM_BP_EXCHANGE_RATE
                        WHERE  DIVISION_ID = V_DIVISION_ID
                        AND    YYYYMMDD = SUBSTR(V_YYYYMM, 1, 6) || '01'
                        AND    UNIT_CURRENCY = 'USD'
                        AND    ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_EXCHANGE_PRICE := 1;
                    END;
                    N2_PRICE := NVL(V_PRICE / V_EXCHANGE_PRICE, 0);
                END IF;

                IF V_MEASURE = 'LOC' AND V_CURRENCY = 'USD' THEN
                    -- USD SETTING
                    N1_MEASURE := 'USD';
                    N1_PRICE   := V_PRICE;

                    -- KRW 산출
                    N2_MEASURE := 'KRW';
                    BEGIN
                        SELECT NVL(EXCHANGE_PRICE, 1)
                        INTO   V_EXCHANGE_PRICE
                        FROM   DM_BP_EXCHANGE_RATE
                        WHERE  DIVISION_ID = V_DIVISION_ID
                        AND    YYYYMMDD = SUBSTR(V_YYYYMM, 1, 6) || '01'
                        AND    UNIT_CURRENCY = 'USD'
                        AND    ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_EXCHANGE_PRICE := 1;
                    END;
                    N2_PRICE := NVL(V_PRICE * V_EXCHANGE_PRICE, 0);
                END IF;

                IF V_MEASURE = 'LOC' AND V_CURRENCY NOT IN ('KRW', 'USD') THEN
                    N1_MEASURE := 'KRW';
                    -- KRW 산출
                    BEGIN
                        SELECT NVL(EXCHANGE_PRICE, 1)
                        INTO   V_EXCHANGE_PRICE
                        FROM   DM_BP_EXCHANGE_RATE
                        WHERE  DIVISION_ID = V_DIVISION_ID
                        AND    YYYYMMDD = SUBSTR(V_YYYYMM, 1, 6) || '01'
                        AND    UNIT_CURRENCY = V_CURRENCY
                        AND    ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_EXCHANGE_PRICE := 1;
                    END;
                    N1_PRICE   := V_PRICE * V_EXCHANGE_PRICE;
                    N2_MEASURE := 'USD';
                    BEGIN
                        SELECT NVL(EXCHANGE_PRICE, 1)
                        INTO   V_EXCHANGE_PRICE
                        FROM   DM_BP_EXCHANGE_RATE
                        WHERE  DIVISION_ID = V_DIVISION_ID
                        AND    YYYYMMDD = SUBSTR(V_YYYYMM, 1, 6) || '01'
                        AND    UNIT_CURRENCY = 'USD'
                        AND    ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_EXCHANGE_PRICE := 1;
                    END;
                    N2_PRICE := NVL(N1_PRICE / V_EXCHANGE_PRICE, 0);
                END IF;

                -- 임시확인
                --SELECT   v_DIVISION_ID,v_PROJECT_CODE,v_PROJECT_NAME,v_SCM_SITE_ID,v_PLANT_SITE_ID,v_ITEM_ID,v_YYYYMM,v_CURRENCY,n2_MEASURE
                --    ,v_DOM_EXP,v_FCST_TYPE,v_INCOTERMS,ROUND(n2_PRICE,3),'SYSTEM',SYSTIMESTAMP,'SYSTEM',SYSTIMESTAMP
                IF N1_MEASURE IS NOT NULL THEN
                    -- PRICE INSERT #1
                    INSERT /*+ NO_PARALLEL */
                    INTO GT_SDPBP_FUTURE_PRICE_TEMP3_2
                        (DIVISION_ID
                        ,PROJECT_CODE
                        ,PROJECT_NAME
                        ,SCM_SITE_ID
                        ,PLANT_SITE_ID
                        ,ITEM_ID
                        ,YYYYMM
                        ,CURRENCY
                        ,MEASURE
                        ,DOM_EXP
                        ,FCST_TYPE
                        ,INCOTERMS -- PJ20200138 Incoterms 삭제
                        ,ITEM_USE
                        ,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                        ,CELL_PROD_SITE
                        ,QTY
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        ,ATTRIBUTE1
                        ,ATTRIBUTE2
                        ,ATTRIBUTE3
                        ,ATTRIBUTE4
                        ,ATTRIBUTE5
                        ,ATTRIBUTE6
                        ,ATTRIBUTE7
                        ,ATTRIBUTE8
                        ,ATTRIBUTE9
                        ,ATTRIBUTE10
                        ,DEPT_ID
                        ,END_CUSTOMER
                        ,BIZ_TYPE) -- 20190830 추가
                    VALUES
                        (V_DIVISION_ID
                        ,V_PROJECT_CODE
                        ,V_PROJECT_NAME
                        ,V_SCM_SITE_ID
                        ,V_PLANT_SITE_ID
                        ,V_ITEM_ID
                        ,V_YYYYMM
                        ,V_CURRENCY
                        ,N1_MEASURE
                        ,V_DOM_EXP
                        ,V_FCST_TYPE
                        ,V_INCOTERMS -- PJ20200138 Incoterms 삭제
                        ,V_ITEM_USE
                        ,V_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                        ,V_CELL_PROD_SITE
                        ,ROUND(N1_PRICE, 3)
                        ,'SYSTEM'
                        ,SYSTIMESTAMP
                        ,'SYSTEM'
                        ,SYSTIMESTAMP -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,V_DEPT_ID
                        ,V_END_CUSTOMER
                        ,V_BIZ_TYPE); -- 20190830 추가

                    IF S_FLAG <> 'CALL' THEN
                        -- Amount INSERT #1
                        INSERT /*+ NO_PARALLEL */
                        INTO GT_SDPBP_FUTURE_PRICE_TEMP3_2
                            (DIVISION_ID
                            ,PROJECT_CODE
                            ,PROJECT_NAME
                            ,SCM_SITE_ID
                            ,PLANT_SITE_ID
                            ,ITEM_ID
                            ,YYYYMM
                            ,CURRENCY
                            ,MEASURE
                            ,DOM_EXP
                            ,FCST_TYPE
                            ,INCOTERMS -- PJ20200138 Incoterms 삭제
                            ,ITEM_USE
                            ,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                            ,CELL_PROD_SITE
                            ,QTY
                            ,CREATED_BY
                            ,CREATION_DATE
                            ,LAST_UPDATED_BY
                            ,LAST_UPDATE_DATE
                            ,ATTRIBUTE1
                            ,ATTRIBUTE2
                            ,ATTRIBUTE3
                            ,ATTRIBUTE4
                            ,ATTRIBUTE5
                            ,ATTRIBUTE6
                            ,ATTRIBUTE7
                            ,ATTRIBUTE8
                            ,ATTRIBUTE9
                            ,ATTRIBUTE10
                            ,DEPT_ID
                            ,END_CUSTOMER
                            ,BIZ_TYPE) -- 20190830 추가
                        VALUES
                            (V_DIVISION_ID
                            ,V_PROJECT_CODE
                            ,V_PROJECT_NAME
                            ,V_SCM_SITE_ID
                            ,V_PLANT_SITE_ID
                            ,V_ITEM_ID
                            ,V_YYYYMM
                            ,V_CURRENCY
                            ,'SalesAmt_' || N1_MEASURE
                            ,V_DOM_EXP
                            ,V_FCST_TYPE
                            ,V_INCOTERMS -- PJ20200138 Incoterms 삭제
                            ,V_ITEM_USE
                            ,V_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                            ,V_CELL_PROD_SITE
                            ,ROUND(N1_PRICE * V_BP_QTY, 3)
                            ,'SYSTEM'
                            ,SYSTIMESTAMP
                            ,'SYSTEM'
                            ,SYSTIMESTAMP -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,V_DEPT_ID
                            ,V_END_CUSTOMER
                            ,V_BIZ_TYPE); -- 20190830 추가
                    END IF;

                END IF;

                IF N2_MEASURE IS NOT NULL THEN
                    -- PRICE INSERT #2
                    INSERT /*+ NO_PARALLEL */
                    INTO GT_SDPBP_FUTURE_PRICE_TEMP3_2
                        (DIVISION_ID
                        ,PROJECT_CODE
                        ,PROJECT_NAME
                        ,SCM_SITE_ID
                        ,PLANT_SITE_ID
                        ,ITEM_ID
                        ,YYYYMM
                        ,CURRENCY
                        ,MEASURE
                        ,DOM_EXP
                        ,FCST_TYPE
                        ,INCOTERMS -- PJ20200138 Incoterms 삭제
                        ,ITEM_USE
                        ,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                        ,CELL_PROD_SITE
                        ,QTY
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        ,ATTRIBUTE1
                        ,ATTRIBUTE2
                        ,ATTRIBUTE3
                        ,ATTRIBUTE4
                        ,ATTRIBUTE5
                        ,ATTRIBUTE6
                        ,ATTRIBUTE7
                        ,ATTRIBUTE8
                        ,ATTRIBUTE9
                        ,ATTRIBUTE10
                        ,DEPT_ID
                        ,END_CUSTOMER
                        ,BIZ_TYPE) -- 20190830 추가
                    VALUES
                        (V_DIVISION_ID
                        ,V_PROJECT_CODE
                        ,V_PROJECT_NAME
                        ,V_SCM_SITE_ID
                        ,V_PLANT_SITE_ID
                        ,V_ITEM_ID
                        ,V_YYYYMM
                        ,V_CURRENCY
                        ,N2_MEASURE
                        ,V_DOM_EXP
                        ,V_FCST_TYPE
                        ,V_INCOTERMS -- PJ20200138 Incoterms 삭제
                        ,V_ITEM_USE
                        ,V_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                        ,V_CELL_PROD_SITE
                        ,ROUND(N2_PRICE, 3)
                        ,'SYSTEM'
                        ,SYSTIMESTAMP
                        ,'SYSTEM'
                        ,SYSTIMESTAMP -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,NULL
                        ,V_DEPT_ID
                        ,V_END_CUSTOMER
                        ,V_BIZ_TYPE); -- 20190830 추가

                    IF S_FLAG <> 'CALL' THEN
                        -- Amount INSERT #2
                        INSERT /*+ NO_PARALLEL */
                        INTO GT_SDPBP_FUTURE_PRICE_TEMP3_2
                            (DIVISION_ID
                            ,PROJECT_CODE
                            ,PROJECT_NAME
                            ,SCM_SITE_ID
                            ,PLANT_SITE_ID
                            ,ITEM_ID
                            ,YYYYMM
                            ,CURRENCY
                            ,MEASURE
                            ,DOM_EXP
                            ,FCST_TYPE
                            ,INCOTERMS -- PJ20200138 Incoterms 삭제
                            ,ITEM_USE
                            ,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                            ,CELL_PROD_SITE
                            ,QTY
                            ,CREATED_BY
                            ,CREATION_DATE
                            ,LAST_UPDATED_BY
                            ,LAST_UPDATE_DATE
                            ,ATTRIBUTE1
                            ,ATTRIBUTE2
                            ,ATTRIBUTE3
                            ,ATTRIBUTE4
                            ,ATTRIBUTE5
                            ,ATTRIBUTE6
                            ,ATTRIBUTE7
                            ,ATTRIBUTE8
                            ,ATTRIBUTE9
                            ,ATTRIBUTE10
                            ,DEPT_ID
                            ,END_CUSTOMER
                            ,BIZ_TYPE) -- 20190830 추가
                        VALUES
                            (V_DIVISION_ID
                            ,V_PROJECT_CODE
                            ,V_PROJECT_NAME
                            ,V_SCM_SITE_ID
                            ,V_PLANT_SITE_ID
                            ,V_ITEM_ID
                            ,V_YYYYMM
                            ,V_CURRENCY
                            ,'SalesAmt_' || N2_MEASURE
                            ,V_DOM_EXP
                            ,V_FCST_TYPE
                            ,V_INCOTERMS -- PJ20200138 Incoterms 삭제
                            ,V_ITEM_USE
                            ,V_UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                            ,V_CELL_PROD_SITE
                            ,ROUND(N2_PRICE * V_BP_QTY, 3)
                            ,'SYSTEM'
                            ,SYSTIMESTAMP
                            ,'SYSTEM'
                            ,SYSTIMESTAMP -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,NULL
                            ,V_DEPT_ID
                            ,V_END_CUSTOMER
                            ,V_BIZ_TYPE); -- 20190830 추가
                    END IF;
                END IF;

                -- -----------------------------------------------------------------------------------------------------
                FETCH FUTURE_PRICE_CUR
                    INTO V_DIVISION_ID
                        ,V_PROJECT_CODE
                        ,V_PROJECT_NAME
                        ,V_SCM_SITE_ID
                        ,V_PLANT_SITE_ID
                        ,V_ITEM_ID
                        ,V_YYYYMM
                        ,V_CURRENCY
                        ,V_MEASURE
                        ,V_DOM_EXP
                        ,V_FCST_TYPE
                        ,V_INCOTERMS -- PJ20200138 Incoterms 삭제
                         -- PJ20200138 item_use, unit_energy 추가
                        ,V_ITEM_USE
                        ,V_UNIT_ENERGY
                        ,V_CELL_PROD_SITE
                        ,V_PRICE
                         -- 20190830 추가
                        ,V_DEPT_ID
                        ,V_END_CUSTOMER
                        ,V_BIZ_TYPE

                        ,V_ROW_COUNT
                        ,V_BP_QTY;
            END LOOP;
            -- -----------------------------------------------------------------------------------------------------
            CLOSE FUTURE_PRICE_CUR;
            -- deallocate  future_price_cur
            --select 'GT_SDPBP_FUTURE_PRICE_TEMP3_2', * from GT_SDPBP_FUTURE_PRICE_TEMP3_2
            --임시확인
            --SELECT 'GT_SDPBP_FUTURE_PRICE_TEMP3_2'
            --SELECT * FROM GT_SDPBP_FUTURE_PRICE_TEMP3_2

            DELETE FROM DM_PLN_BP_FCST
            WHERE  EXISTS (SELECT 1
                    FROM   GT_SDPBP_FUTURE_PRICE_TEMP3_2 B
                    WHERE  1 = 1
                    AND    DM_PLN_BP_FCST.DIVISION_ID = B.DIVISION_ID
                    AND    DM_PLN_BP_FCST.PROJECT_CODE = B.PROJECT_CODE
                          --and  DM_PLN_BP_FCST.PROJECT_NAME    =  B.PROJECT_NAME
                    AND    DM_PLN_BP_FCST.SCM_SITE_ID = B.SCM_SITE_ID
                    AND    DM_PLN_BP_FCST.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND    DM_PLN_BP_FCST.ITEM_ID = B.ITEM_ID
                    AND    DM_PLN_BP_FCST.YYYYMM = B.YYYYMM
                    AND    DM_PLN_BP_FCST.CURRENCY = B.CURRENCY
                    AND    DM_PLN_BP_FCST.MEASURE = B.MEASURE
                    AND    DM_PLN_BP_FCST.DOM_EXP = B.DOM_EXP
                    AND    DM_PLN_BP_FCST.FCST_TYPE = B.FCST_TYPE
                    AND    DM_PLN_BP_FCST.INCOTERMS = B.INCOTERMS -- PJ20200138 Incoterms 삭제
                          -- PJ20200138 item_use, unit_energy 추가
                    AND    DM_PLN_BP_FCST.ITEM_USE = B.ITEM_USE
                    AND    DM_PLN_BP_FCST.UNIT_ENERGY = B.UNIT_ENERGY
                    AND    DM_PLN_BP_FCST.CELL_PROD_SITE = B.CELL_PROD_SITE
                          -- 20190830 추가
                    AND    DM_PLN_BP_FCST.DEPT_ID = B.DEPT_ID
                    AND    DM_PLN_BP_FCST.END_CUSTOMER = B.END_CUSTOMER
                    AND    DM_PLN_BP_FCST.BIZ_TYPE = B.BIZ_TYPE);

            INSERT INTO DM_PLN_BP_FCST
                (DIVISION_ID
                ,PROJECT_CODE
                ,PROJECT_NAME
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,ITEM_ID
                ,YYYYMM
                ,CURRENCY
                ,MEASURE
                ,DOM_EXP
                ,FCST_TYPE
                ,INCOTERMS -- PJ20200138 Incoterms 삭제
                ,ITEM_USE
                ,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                ,CELL_PROD_SITE
                ,QTY
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                ,ATTRIBUTE1
                ,ATTRIBUTE2
                ,ATTRIBUTE3
                ,ATTRIBUTE4
                ,ATTRIBUTE5
                ,ATTRIBUTE6
                ,ATTRIBUTE7
                ,ATTRIBUTE8
                ,ATTRIBUTE9
                ,ATTRIBUTE10
                ,DEPT_ID
                ,END_CUSTOMER
                ,BIZ_TYPE -- 20190830 추가
                 )
                SELECT DIVISION_ID
                      ,PROJECT_CODE
                      ,PROJECT_NAME
                      ,SCM_SITE_ID
                      ,PLANT_SITE_ID
                      ,ITEM_ID
                      ,YYYYMM
                      ,CURRENCY
                      ,MEASURE
                      ,DOM_EXP
                      ,FCST_TYPE
                      ,INCOTERMS -- PJ20200138 Incoterms 삭제
                      ,ITEM_USE
                      ,UNIT_ENERGY -- PJ20200138 item_use, unit_energy 추가
                      ,CELL_PROD_SITE
                      ,QTY
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE
                      ,ATTRIBUTE1
                      ,ATTRIBUTE2
                      ,ATTRIBUTE3
                      ,ATTRIBUTE4
                      ,ATTRIBUTE5
                      ,ATTRIBUTE6
                      ,ATTRIBUTE7
                      ,ATTRIBUTE8
                      ,ATTRIBUTE9
                      ,ATTRIBUTE10
                      ,DEPT_ID
                      ,END_CUSTOMER
                      ,BIZ_TYPE -- 20190830 추가
                FROM   GT_SDPBP_FUTURE_PRICE_TEMP3_2 FPT
                WHERE  1=1
                AND   NOT EXISTS (SELECT 1
                                  FROM   DM_PLN_BP_FCST PBF
                                  WHERE  PBF.DIVISION_ID    = FPT.DIVISION_ID
                                    AND  PBF.PROJECT_CODE   = FPT.PROJECT_CODE
                                    AND  PBF.SCM_SITE_ID    = FPT.SCM_SITE_ID
                                    AND  PBF.ITEM_ID        = FPT.ITEM_ID
                                    AND  PBF.FCST_TYPE      = FPT.FCST_TYPE
                                    AND  PBF.MEASURE        = FPT.MEASURE
                                    AND  PBF.PLANT_SITE_ID  = FPT.PLANT_SITE_ID
                                    AND  PBF.DEPT_ID        = FPT.DEPT_ID
                                    AND  PBF.END_CUSTOMER   = FPT.END_CUSTOMER
                                    AND  PBF.BIZ_TYPE       = FPT.BIZ_TYPE
                                    AND  PBF.YYYYMM         = FPT.YYYYMM
                                    AND  PBF.CURRENCY       = FPT.CURRENCY
                                    AND  PBF.ITEM_USE       = FPT.ITEM_USE
                                    AND  PBF.UNIT_ENERGY    = FPT.UNIT_ENERGY
                                    AND  PBF.INCOTERMS      = FPT.INCOTERMS
                                    AND  PBF.CELL_PROD_SITE = FPT.CELL_PROD_SITE
                                  )
                ;

            /*---------------------------------------------------------------*/
            -- IF 0 > 0
            -- 트랜잭션 (COMMIT)
            COMMIT;
            -- -----------------------------------------------------------------------------------------
            -- END TRY
            -- -----------------------------------------------------------------------------------------
            -- -----------------------------------------------------------
            OPEN O_RESULT_CURSOR FOR
                SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                -- -----------------------------------------------------------
                --[C20200909-000203] LOG 표준화 적용
                -- 트랜잭션 (END)
                --    SELECT 'ERROR';
                -- ERROR LOG VALUE SAVE
                V_LOG_TYPE    := 'ERROR';
                V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
                V_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
                D_EVENT_DATE  := SYSTIMESTAMP;
                --[C20200909-000203] LOG 표준화 적용
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                    ,V_LOG_TYPE
                                    ,N_LOG_COUNT
                                    ,V_LOG_MESSAGE
                                    ,V_DESCRIPTION
                                    ,D_EVENT_DATE
                                    ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                    ,P_SQL_ERR_CODE  => SQLCODE
                                    ,P_SQL_ERR_MSG   => SQLERRM
                                    ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

                V_SQL_CODE   := SQLCODE;
                V_SQL_ERRMSG := SQLERRM;

                OPEN O_RC2 FOR
                    SELECT '[' || TO_CHAR(V_SQL_CODE) || ']' || V_LOG_MESSAGE FROM DUAL; /*-- 에러메시지 DISPLAY --*/

                RAISE_APPLICATION_ERROR(-20001
                                       ,'[' || $$PLSQL_UNIT || '.' || 'P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV' || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' ||
                                        SQLERRM || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);

        END;
        -- -----------------------------------------------------------
        -- END CATCH
        -- -----------------------------------------------------------
        -- 수행결과 성공여부 DISPLAY
        IF S_FLAG <> 'CALL' AND V_LOG_MESSAGE IS NULL THEN
            --SELECT 'success'
            OPEN O_RC1 FOR
                SELECT 'Sales Price Recalculation is Complete' FROM DUAL;
        END IF;

        -- Temp Table0 존재여부 확인하여 삭제
        -- 종료 LOG
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        --v_description := NULL;
        D_EVENT_DATE := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,'E'
                                ,0
                                ,SQLERRM
                                ,NULL
                                ,SYSDATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '.' || 'P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV' || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' ||
                                    SQLERRM || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV;

END PKG_DMF0042;
/
