/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0044.sql
 * Description  : Standalone Procedures — DMF0044 화면 (23개)
 *              : 향후 PKG_DMF0044로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE
(
    P_YEAR            IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE                                            */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/03/23  P.C.I        Initial Release [prepare] Sales Report Exchange Rate Popup              */
/* 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                 */ 
/*                                                                                                  */
/****************************************************************************************************/
IS

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT MIN(BASIS_START_DATE) AS BASIS_START_DATE, CALENDAR_YYYY, CALENDAR_MONTH
    FROM   SCM_SYS_CALENDAR_M
    WHERE  CALENDAR_YYYY = P_YEAR
    GROUP BY CALENDAR_YYYY, CALENDAR_MONTH
    ORDER BY BASIS_START_DATE;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_YEAR' VALUE P_YEAR
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0044_GET_SPREAD_TITLE
(
	p_division_id			VARCHAR2 DEFAULT '40',
	p_created_by			VARCHAR2 DEFAULT 'greenzun',
	p_start_dt				VARCHAR2 DEFAULT '20190101',
	p_end_dt				VARCHAR2 DEFAULT '20191231'

)
AS

    p_program_id VARCHAR2(50 CHAR);
    p_sheet_name VARCHAR2(50 CHAR);
    V_DATA_SCALE_NUMBER VARCHAR2(2 CHAR);
    p_program_id VARCHAR2(50 CHAR);
    p_sheet_name VARCHAR2(50 CHAR);
BEGIN





	SELECT SEGMENT3
  INTO V_DATA_SCALE_NUMBER
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE LOOKUP_TYPE = 'DMF0044_CONFIG'
		AND SEGMENT1 = p_division_id
		AND SEGMENT2 = 'DIGIT_NUMBER';



	p_program_id := 'DMF0044';
	p_sheet_name := 'MDF Reports';

	SELECT C.PROGRAM_ID
		, C.SHEET_NAME
		, C.COLUMN_NAME
		, C.COLUMN_LABEL_NAME
		--, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
		, CASE WHEN P_DIVISION_ID = '40' THEN C.SORT_ORDER_NO
			   WHEN P_DIVISION_ID like '81%' THEN C.ATTRIBUTE2
			   WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE3
			   END AS SORT_ORDER_NO
		, C.DATA_SORT_METHOD_CODE
		, C.SMALL_CLASS_LABEL_NAME
		, C.LARGE_CLASS_LABEL_NAME
		, '' AS DAY_CODE
		, C.FIXED_FLAG
		, CASE WHEN
				CASE WHEN P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
					 WHEN P_DIVISION_ID like '81%' THEN C.ATTRIBUTE4
					 WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
					 END = 'Y'
					 THEN C.COLUMN_WIDTH
			ELSE 0
			END AS COLUMN_WIDTH
		, C.CELL_CONTROL_OBJECT_TYPE_CODE
		, C.CELL_COMBO_DATA_TYPE
		, C.DATA_SCALE_NUMBER
		, C.DATA_MAX_LENGTH
		, C.HORIZONTAL_ALIGN_CODE
		, C.UPPERCASE_APPLY_FLAG
		, CASE  WHEN P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
				WHEN P_DIVISION_ID like '81%' THEN C.ATTRIBUTE4
				WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
				END AS VISIBLE_FLAG
		, C.DEFAULT_FLAG
		, C.USER_SELECTABLE_FLAG
		, C.VALID_YN
		, C.DIVISION_ID
		, p_division_id as ATTRIBUTE1		-- COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
		, CASE WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE C.ATTRIBUTE1 END AS ATTRIBUTE2
		, C.ATTRIBUTE3
		, C.ATTRIBUTE4
		, C.ATTRIBUTE5
	FROM   SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
		AND    C.PROGRAM_ID  = p_program_id
		AND    C.SHEET_NAME  = p_sheet_name
		AND    C.VALID_YN     = 'Y'
		--AND	   C.DIVISION_ID LIKE '%' + P_DIVISION_ID + '%'
        AND	    P_DIVISION_ID IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )
	UNION ALL

	SELECT
		p_program_id   AS PROGRAM_ID
		, p_sheet_name AS SHEET_NAME
		, MA.COLUMN_NAME
		, MA.COLUMN_LABEL_NAME
		, MA.SORT_ORDER_NO
		, ''         AS DATA_SORT_METHOD_CODE
		, MA.SMALL_CLASS_LABEL_NAME
		, MA.LARGE_CLASS_LABEL_NAME
		, MA.DAY_CODE
		, ''         AS FIXED_FLAG
		, CASE WHEN V_DATA_SCALE_NUMBER IS NULL THEN 120 ELSE 200 END         AS COLUMN_WIDTH
		, MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		, ''         AS CELL_COMBO_DATA_TYPE
		--, '2'         AS DATA_SCALE_NUMBER
		, NVL(V_DATA_SCALE_NUMBER, '3')         AS DATA_SCALE_NUMBER -- 20181029
		, '2'         AS DATA_MAX_LENGTH
		, 'R'        AS HORIZONTAL_ALIGN_CODE
		, ''        AS UPPERCASE_APPLY_FLAG
		, 'Y'        AS VISIBLE_FLAG
		, ''         AS DEFAULT_FLAG
		, ''     AS USER_SELECTABLE_FLAG
		, ''         AS VALID_YN
		, ''			AS DIVISION_ID
		, '' AS ATTRIBUTE1
		, '' AS ATTRIBUTE2
		, '' AS ATTRIBUTE3
		, '' AS ATTRIBUTE4
		, '' AS ATTRIBUTE5
	FROM  (
		SELECT
			DISTINCT
			'M_'  ||  BASIS_YYYYMM								AS COLUMN_NAME
			, MONTH_NAME										AS COLUMN_LABEL_NAME
			, MONTH_NAME										AS SMALL_CLASS_LABEL_NAME
			, MONTH_NAME										AS LARGE_CLASS_LABEL_NAME
			, ''														AS DAY_CODE
			, BASIS_YYYYMM									AS SORT_ORDER_NO
			, 'FPNumber'											AS CELL_CONTROL_OBJECT_TYPE_CODE
		FROM SCM_SYS_CALENDAR_M
		WHERE  BASIS_YYYYMMDD >= p_start_dt
			AND BASIS_YYYYMMDD <= p_end_dt

	) MA;

	ORDER BY SORT_ORDER_NO;

	/*



	p_program_id := 'DMF0044';
	p_sheet_name := 'MDF Reports';

	SELECT C.PROGRAM_ID
		, C.SHEET_NAME
		, C.COLUMN_NAME
		, C.COLUMN_LABEL_NAME
		, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
		, C.DATA_SORT_METHOD_CODE
		, C.SMALL_CLASS_LABEL_NAME
		, C.LARGE_CLASS_LABEL_NAME
		, '' AS DAY_CODE
		, C.FIXED_FLAG
		, C.COLUMN_WIDTH
		, C.CELL_CONTROL_OBJECT_TYPE_CODE
		, C.CELL_COMBO_DATA_TYPE
		, C.DATA_SCALE_NUMBER
		, C.DATA_MAX_LENGTH
		, C.HORIZONTAL_ALIGN_CODE
		, C.UPPERCASE_APPLY_FLAG
		, C.VISIBLE_FLAG
		, C.DEFAULT_FLAG
		, C.USER_SELECTABLE_FLAG
		, C.VALID_YN
		, C.DIVISION_ID
		, C.ATTRIBUTE1
	FROM   SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
		AND    C.PROGRAM_ID  = p_program_id
		AND    C.SHEET_NAME  = p_sheet_name
		--AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )
		--AND    C.COLUMN_NAME IN ('LAST_UPDATE_DATE', 'LAST_UPDATED_BY')
	UNION ALL

	SELECT
		p_program_id   AS PROGRAM_ID
		, p_sheet_name AS SHEET_NAME
		, MA.COLUMN_NAME
		, MA.COLUMN_LABEL_NAME
		, MA.SORT_ORDER_NO
		, ''         AS DATA_SORT_METHOD_CODE
		, MA.SMALL_CLASS_LABEL_NAME
		, MA.LARGE_CLASS_LABEL_NAME
		, MA.DAY_CODE
		, ''         AS FIXED_FLAG
		, 120         AS COLUMN_WIDTH
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
	FROM  (
		SELECT
			DISTINCT
			'M_' + BASIS_YYYYMM								AS COLUMN_NAME
			, MONTH_NAME										AS COLUMN_LABEL_NAME
			, MONTH_NAME										AS SMALL_CLASS_LABEL_NAME
			, MONTH_NAME										AS LARGE_CLASS_LABEL_NAME
			, ''														AS DAY_CODE
			, BASIS_YYYYMM									AS SORT_ORDER_NO
			, 'FPNumber'											AS CELL_CONTROL_OBJECT_TYPE_CODE
		FROM SCM_SYS_CALENDAR_M
		WHERE  BASIS_YYYYMMDD >= p_start_dt
			AND BASIS_YYYYMMDD <= p_end_dt

	) MA;

	ORDER BY SORT_ORDER_NO;
	*/

END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0044_MOBILE_REPORT_CREATE
(
	  p_division_id            VARCHAR2
	, p_version_no             VARCHAR2
	, p_version_type           VARCHAR2
	, p_action_type            VARCHAR2 		-- T:Transfer, C:Cancel
	, p_created_by				VARCHAR2
/*========================================================================================================================
 * Program ID   : DMF0044_MOBILE_REPORT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *========================================================================================================================
 *	Date		In Charge		Description
 *========================================================================================================================
 * 2019.05.22	JSYOUN			Initial Release PJ20189106 전지본부 GSCM(DM) 고도화 프로젝트
 * 2019.11.18	hwi1993			파라미터 추가  및 데이터타입 변경, Cancel 기능 추가
 * 2020.05.19	HWI1993			V_YYYY 를 버전번호를 잘라서 사용하던 것을 MDF_VERSION 에서 가져오도록 함
 * 2020.05.22	HWI1993			전송시 etc 를 묶는 로직 추가
 * 2020.06.05	HWI1993			BP 로직 제거 ( SP 와 변합 )
 * 2020.09.09   P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020.09.21	HWI1993			[C20200909-000188] ESS영업관리팀 GDW 용도별 매출 수정 (프로젝트 코드 S 주택용/상업용 분리)
 * 2021.08.16	hwi1993			[C20210811-000341] ETC Report - GDW 전송시 누락 컬럼 점검 요청의 건 -- ETC 누락 데이터 등 수정
 * 2024.05.09	JSSBAE			[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2025.04.04   JSSBAE			[E20250401-000548] SMS 선감지 대상 정리
 * 2025.05.09   JSSBAE			[E20250418-001567]_40사업부 Sales Report, ETC Report 개선
 ========================================================================================================================*/
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:26
 * 파일: dbo.DMF0044_MOBILE_REPORT_CREATE.sql
 * ----------------------------------------
 * ⚠ IF: IF:15  END IF:7  차이:+8
 * ----------------------------------------
 * BEGIN 위치: L42, L79, L89, L99, L109, L119, L133, L169, L184, L195
 * END;  위치: L83, L93, L103, L113, L123, L137, L174, L244, L245
 * ----------------------------------------
 * 힌트: BEGIN이 1개 더 많음 → END; 누락 가능성
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    -- $$PLSQL_UNIT 제거: $$PLSQL_UNIT 사용 (사내 표준 §11)
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_merge_count INTEGER := 0;
    v_yyyy VARCHAR2(4 CHAR);
    s_duplicate_validation VARCHAR2(1000 CHAR) := null;
    v_cnt_1  INTEGER := 0;
BEGIN
            	-- -----------------------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	-- -----------------------------------------------------------------------------------------------------------------------
    -- local 변수선언
	-- -----------------------------------------------------------------------------------------------------------------------
	SELECT SUBSTR(YYYYMMDD, 1, 4)
  INTO v_yyyy
	FROM  DM_MDF_VERSION
	WHERE VERSION_NO = p_version_no;

	-- -----------------------------------------------------------------------------------------------------------------------
	-- 시작 LOG  (START)
	-- -----------------------------------------------------------------------------------------------------------------------
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
	--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- -----------------------------------------------------------------------------------------------------------------------
	-- 시작 LOG  (END)
	-- -----------------------------------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (START)
	-- -----------------------------------------------------------------------------------------------------------------------
	-- ------------------------------------------------------------------------------------------------------------------------
	BEGIN TRY
	-- ------------------------------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------------------------
		-- Validation (BEGIN)
		-- --------------------------------------------------------------------------------------------------------------------
		IF NOT EXISTS ( SELECT 1 FROM SCM_MST_DIVISION
								 WHERE 1=1
								 AND   DIVISION_ID = p_division_id );
			BEGIN
DBMS_OUTPUT.PUT_LINE('1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				v_log_type := 'DIVISION_INVALID';
				GOTO ERR_RTN
			END

		IF NOT EXISTS ( SELECT 1 FROM DM_MDF_VERSION
								 WHERE 1=1
								 AND   DIVISION_ID = p_division_id
								 AND   VERSION_NO  = p_version_no );
			BEGIN
DBMS_OUTPUT.PUT_LINE('2--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				v_log_type := 'VERSION_NO_INVALID';
				GOTO ERR_RTN
			END

		IF p_action_type = 'C'	AND NOT EXISTS ( SELECT DIVISION_ID FROM  DM_MDF_VERSION
												 WHERE DIVISION_ID = p_division_id
												 AND   VERSION_NO  = p_version_no
												 AND   SEND_YN = 'Y' );
			BEGIN
DBMS_OUTPUT.PUT_LINE('3--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				v_log_type := 'ACTION_TYPE_INVALID_C';
				GOTO ERR_RTN
			END

		IF p_action_type = 'C' AND NOT EXISTS ( SELECT DIVISION_ID	FROM DM_MDF_VERSION
												 WHERE DIVISION_ID = p_division_id
												 AND   VERSION_NO  = p_version_no
												 AND   SEND_YN = 'Y' );
			BEGIN
DBMS_OUTPUT.PUT_LINE('4--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				v_log_type := 'ACTION_TYPE_INVALID_C';
				GOTO ERR_RTN
			END

		IF p_action_type = 'T'	AND NOT EXISTS ( SELECT DIVISION_ID FROM DM_MDF_VERSION
												 WHERE DIVISION_ID = p_division_id
												 AND   VERSION_NO  = p_version_no
												 AND   SEND_YN IN ( 'Y', '' ));
			BEGIN
DBMS_OUTPUT.PUT_LINE('5--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				v_log_type := 'ACTION_TYPE_INVALID_T';
				GOTO ERR_RTN
			END

		--[E20250401-000548]_DEPT_NAME VALIDATION 추가 START
		 SELECT COUNT(1)
		 INTO v_cnt_1
		 FROM DM_PLN_SALES_ETC_REPORT_C
		 WHERE DIVISION_ID = p_division_id
		 AND   VERSION_NO  = p_version_no
		 AND   DEPT_NAME IS NULL;
		 IF v_cnt_1 > 0
			BEGIN
DBMS_OUTPUT.PUT_LINE('6--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				v_log_type := 'DEPT_NAME INVALID';
				GOTO ERR_RTN
			END
		--[E20250401-000548]_DEPT_NAME VALIDATION 추가 END
		-- --------------------------------------------------------------------------------------------------------------------
		--[E20250418-001567]_ETC Report 데이터를 Report로 병합하는 과정에서 중복오류발생하여,
		--해당 데이터 INSERT INTO 하기 전 데이터 생성 가능여부 확인 START
		-- --------------------------------------------------------------------------------------------------------------------
		SELECT'VERSION_NO_ : ' ||  NVL(A.VERSION_NO , NULL;
										 ||  CHAR(10)  ||  'DIVISION_ID_ : ' ||  NVL(A.DIVISION_ID , NULL)
										 ||  CHAR(10)  ||  'DEPARTMENT_ID_ : ' ||  NVL(A.DEPARTMENT_ID , NULL)
										 ||  CHAR(10)  ||  'DEPT_ID_ : ' ||  NVL(A.DEPT_ID , NULL)
										 ||  CHAR(10)  ||  'ITEM_ID_ : ' ||  NVL(A.ITEM_ID , NULL)
										 ||  CHAR(10)  ||  'MEASURE_ : ' ||  NVL(A.MEASURE , NULL)
										 ||  CHAR(10)  ||  'YYYYMMDD_ : ' ||  NVL(A.YYYYMMDD , NULL)
										 ||  CHAR(10)  ||  'CURRENCY_ : ' ||  NVL(A.CURRENCY , NULL)
										 ||  CHAR(10)  ||  'COMPANY_ID_ : ' ||  NVL(A.COMPANY_ID , NULL)
										 ||  CHAR(10)  ||  'END_CUST_REPORT_ : ' ||  NVL(A.END_CUST_REPORT , NULL)
										 ||  CHAR(10)  ||  'CUST_REPORT_ : ' ||  NVL(A.CUST_REPORT , NULL)
										 ||  CHAR(10)  ||  'PRODUCT_GROUP_ : ' ||  NVL(A.PRODUCT_GROUP , NULL)
										 ||  CHAR(10)  ||  'COUNTRY_KR_NAME_ : ' ||  NVL(A.COUNTRY_KR_NAME , NULL)
										 ||  CHAR(10)  ||  CHAR(10)
									FROM
									(	SELECT A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID
											 , A.MEASURE, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.END_CUST_REPORT
											 , A.CUST_REPORT, A.PRODUCT_GROUP, FN_GET_COUNTRY_KR_NAME(A.COUNTRY_CODE) AS COUNTRY_KR_NAME, COUNT(*) AS CNT
										FROM DM_PLN_SALES_ETC_REPORT_C A
										WHERE A.DIVISION_ID = p_division_id
										AND   A.VERSION_NO = p_version_no
										GROUP BY A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID
											   , A.MEASURE, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.END_CUST_REPORT
											   , A.CUST_REPORT, A.PRODUCT_GROUP, FN_GET_COUNTRY_KR_NAME(A.COUNTRY_CODE)
										HAVING  COUNT(*) > 1 ) A );
		IF (s_duplicate_validation IS NOT NULL)
			BEGIN
DBMS_OUTPUT.PUT_LINE('7--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
FETCH FIRST 1 ROWS ONLY;
				v_log_type := 'DUPLICATION VALIDATION';
				GOTO ERR_RTN
			END
		-- --------------------------------------------------------------------------------------------------------------------
		--[E20250418-001567]_ETC Report 데이터를 Report로 병합하는 과정에서 중복오류발생하여,
		--해당 데이터 INSERT INTO 하기 전 데이터 생성 가능여부 확인 END
		-- --------------------------------------------------------------------------------------------------------------------
		-- Validation (END)
		-- --------------------------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------------------------
		-- 전송준비 및 매출/사업계획 리포트 데이터 생성 (BEGIN)
		-- --------------------------------------------------------------------------------------------------------------------
		BEGIN
DBMS_OUTPUT.PUT_LINE('8--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
            -- 발송플래그 업데이트
		    UPDATE DM_MDF_VERSION
               SET SEND_YN = CASE WHEN p_action_type = 'T' THEN 'Y' ELSE 'C' END -- 초기는 N, 완료되면 Y, 취소되면 C, 삭제되면 D
                 , LAST_UPDATED_BY = p_created_by
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID = p_division_id
		       AND VERSION_NO  = p_version_no;

			IF ( p_division_id = '40' ) -- 소형일 때만 적용
			BEGIN
DBMS_OUTPUT.PUT_LINE('9--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				--같은 버전이 생성되어 있다면, 삭제 먼저 진행한다.
				DELETE FROM DM_PLN_SALES_PLAN_REPORT_C
				WHERE DIVISION_ID = p_division_id
				AND   VERSION_NO = p_version_no
				AND   DATA_TYPE = '2';

DBMS_OUTPUT.PUT_LINE('10--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				--데이터를 생성한다.
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
				( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
				, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
				, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
				, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
				, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS
				, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
				, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE
				, COMPANY_NAME, APPLICATION, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
				, CELL_PROD_SITE )
				SELECT '2' AS DATA_TYPE, DIVISION_ID, VERSION_NO, 'REPORT_SP_W_E' AS CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
				, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
				, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
				, LAST_UPDATE_DATE, PRODUCT_DETAILS AS ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
				, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS
				, FORECAST_INFO_SPEC, NICK_NAME, CASE WHEN ATTRIBUTE2 IS NOT NULL THEN ATTRIBUTE2 ELSE CELL_MODEL_INFO END AS FORECAST_INFO_CELL_MODEL
				, FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE AS FORECAST_INFO_BIZ_TYPE
				, COMPANY_NAME, APPLICATION, APPLICATION_GR, FN_GET_COUNTRY_KR_NAME(COUNTRY_CODE) AS COUNTRY_KR_NAME, ROUTE
				, '-' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM DM_PLN_SALES_ETC_REPORT_C
				WHERE DIVISION_ID = p_division_id
				AND   VERSION_NO  = p_version_no;

DBMS_OUTPUT.PUT_LINE('11--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				DMF0044_SALES_REPORT_PRODUCT_CREATE p_division_id, p_version_no, p_action_type, v_yyyy;

DBMS_OUTPUT.PUT_LINE('12--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				DMF0044_SALES_REPORT_DEPT_CREATE p_division_id, p_version_no, p_action_type, v_yyyy;

DBMS_OUTPUT.PUT_LINE('13--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

				DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE p_division_id, p_version_no, p_action_type, v_yyyy;

DBMS_OUTPUT.PUT_LINE('14--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

			END
		END

		-- --------------------------------------------------------------------------------------------------------------------
		-- 전송준비 및 매출/사업계획 리포트 데이터 생성 (END)
		-- --------------------------------------------------------------------------------------------------------------------
    COMMIT WORK;
	-- ------------------------------------------------------------------------------------------------------------------------
	END TRY
	-- ------------------------------------------------------------------------------------------------------------------------
	-- ------------------------------------------------------------------------------------------------------------------------
	BEGIN CATCH
	-- ------------------------------------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (END)
	-- -----------------------------------------------------------------------------------------------------------------------
	--[C20200909-000203] LOG 표준화 적용
		-- ROLLBACK
	-- ERROR LOG VALUE SAVE
	-- -----------------------------------------------------------------------------------------------------------------------
	-- ERROR LOG (START)
	-- -----------------------------------------------------------------------------------------------------------------------
		v_log_type := 'ERROR';
		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
		v_description := 'ERROR_LINE : '  ||  STR(NULL);
		d_event_date := SYSTIMESTAMP;

		SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
		--[C20200909-000203] LOG 표준화 적용
		--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
	-- -----------------------------------------------------------------------------------------------------------------------
	-- ERROR LOG (END)
	-- -----------------------------------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------------------------------------------------------------------
	-- END CATCH
	-- -----------------------------------------------------------------------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
		IF v_log_message IS NULL THEN
		SELECT 'success'

	-- -----------------------------------------------------------------------------------------------------------------------
	-- 종료 LOG (START)
	-- -----------------------------------------------------------------------------------------------------------------------
	v_log_type := 'END';
	v_log_message := '########## END of procedure ##########';
	v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
	d_event_date := SYSTIMESTAMP;

	--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
	-- -----------------------------------------------------------------------------------------------------------------------
	-- 종료 LOG (END)
	-- -----------------------------------------------------------------------------------------------------------------------
	ERR_RTN:
	IF v_log_type = 'DIVISION_INVALID' THEN
DBMS_OUTPUT.PUT_LINE('15--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
						--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 START
			--v_log_message := '########## END of procedure ##########';
			v_log_message := 'Division 값이 존재하지 않습니다.';
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 END
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			SELECT 'Division 값이 존재하지 않습니다.'

			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 START
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
			d_event_date := SYSTIMESTAMP;

			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 END
		END IF;

	IF v_log_type = 'VERSION_NO_INVALID' THEN
DBMS_OUTPUT.PUT_LINE('16--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
						--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 START
			--v_log_message := '########## END of procedure ##########';
			v_log_message := 'VERSION 값이 존재하지 않습니다.';
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 END
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			SELECT 'VERSION 값이 존재하지 않습니다.'

			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 START
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
			d_event_date := SYSTIMESTAMP;

			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 END
		END IF;

	IF v_log_type = 'ACTION_TYPE_INVALID_C' THEN
DBMS_OUTPUT.PUT_LINE('17--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
						--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 START
			--v_log_message := '########## END of procedure ##########';
			v_log_message := 'Transfer Cancel은 SendYN 이 Y일 경우만 가능합니다.';
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 END
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			SELECT 'Transfer Cancel은 SendYN 이 Y일 경우만 가능합니다.'

			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 START
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
			d_event_date := SYSTIMESTAMP;

			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 END
		END IF;
	IF v_log_type = 'ACTION_TYPE_INVALID_T' THEN
DBMS_OUTPUT.PUT_LINE('18--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
						--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 START
			--v_log_message := '########## END of procedure ##########';
			v_log_message := 'Transfer 는 SendYN 이 N일 경우만 가능합니다.';
			--[E20250401-000548]_LOG_MESSAGE에 정확한 정보를 찍고 있지않아서, 정확한 정보를 찍도록 수정 END
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			SELECT 'Transfer 는 SendYN 이 N일 경우만 가능합니다.'

			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 START
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
			d_event_date := SYSTIMESTAMP;

			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			--[E20250401-000548]_END LOG 누락되어 있어서 END LOG 추가 END
		END IF;
	--[E20250401-000548] SMS 선감지 대상 정리	START
	IF v_log_type = 'DEPT_NAME INVALID' THEN
DBMS_OUTPUT.PUT_LINE('19--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
						v_log_message := 'TEAM정보가 존재하지 않아 저장할 수 없습니다.';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			SELECT 'TEAM정보가 존재하지 않아 저장할 수 없습니다.'

			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
			d_event_date := SYSTIMESTAMP;

			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
		END IF;

	--[E20250418-001567]_중복데이터 발생시 VALIDATION 내용 추가
	IF v_log_type = 'DUPLICATION VALIDATION' THEN
DBMS_OUTPUT.PUT_LINE('20--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
						v_log_message := s_duplicate_validation  ||  'ETC Report데이터를 Sales Report 데이터와 병합하는 과정에서 중복 데이터가 발생했습니다.'
							     ||  char(10)  ||  'ETC Rpeort데이터에서 해당 데이터의 정보를 수정하시기 바랍니다.'
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
			SELECT s_duplicate_validation  ||  'ETC Report데이터를 Sales Report 데이터와 병합하는 과정에서 중복 데이터가 발생했습니다.'
							     ||  char(10)  ||  'ETC Rpeort데이터에서 해당 데이터의 정보를 수정하시기 바랍니다.'
			FROM DUAL;

			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
			d_event_date := SYSTIMESTAMP;

			--[E20250401-000548]_로그찍는경우 실제 저장한 사용자 정보가 저장되도록 수정
			--PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_CREATED_BY);
		END IF;
		--[E20250401-000548] SMS 선감지 대상 정리	END
	END IF;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0044_SALES_REPORT_DEPT_CREATE
(
	p_division_id            VARCHAR2,
	p_version_no             VARCHAR2,
	p_action_type            VARCHAR2,		-- T:Transfer, C:Cancel
	p_yyyy                   VARCHAR2

)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:26
 * 파일: dbo.DMF0044_SALES_REPORT_DEPT_CREATE.sql
 * ----------------------------------------
 * ⚠ IF: IF:3  END IF:0  차이:+3
 * ⚠ BEGIN: BEGIN:6  END:7  차이:-1
 * ----------------------------------------
 * BEGIN 위치: L49, L84, L96, L107, L111, L205
 * END;  위치: L88, L109, L113, L388, L394, L426
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    -- $$PLSQL_UNIT 제거: $$PLSQL_UNIT 사용 (사내 표준 §11)
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_merge_count INTEGER := 0;
    v_yyyy VARCHAR2(4 CHAR);
    v_user_id VARCHAR2(10 CHAR) := 'mdf_batch';
    v_getdate VARCHAR2(50 CHAR) := SYSDATE;
    v_ori_version_no VARCHAR2(50 CHAR);
    V_SP_BP VARCHAR2(2 CHAR);
    v_ETC_DEPARTMENT_ID VARCHAR2(30 CHAR);
    v_cnt_1  INTEGER := 0;
    v_cnt_2  INTEGER := 0;
BEGIN
            	-- LOG 용 변수 설정













	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- ------------------------------------------------------------------------------------------------------------------------
	BEGIN TRY
	-- ------------------------------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------
		--                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
		-- --------------------------------------------------------------------------------------------------
		SELECT COUNT(1)
		INTO v_cnt_1
		FROM DM_MOBILE_REPORT_DEPT  WHERE 1=1
		AND DIVISION_ID = p_division_id
		AND VERSION_NO  = p_version_no;
		IF v_cnt_1 > 0
			BEGIN
				DELETE FROM DM_MOBILE_REPORT_DEPT WHERE 1=1
					AND DIVISION_ID = p_division_id
					AND VERSION_NO  = p_version_no;
			END
		-- --------------------------------------------------------------------------------------------------
		--                              중복 VERSION이 있는경우 삭제후 COPY (END)
		-- --------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------
		--                           요청VERSION COPY (BEGIN)
		-- --------------------------------------------------------------------------------------------------
		IF p_action_type = 'T' -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리
		BEGIN
           SELECT ORI_VERSION_NO INTO v_ori_version_no FROM DM_MDF_VERSION  WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
			--------------------------------------------------------- TEMP TABLE 확인후 초기화
			-- 20210716
			SELECT COUNT(1)
			INTO v_cnt_2
			FROM DM_PLN_SALES_PLAN_REPORT_C A
			WHERE A.DIVISION_ID = p_division_id
			AND A.VERSION_NO  = p_version_no
			AND A.MEASURE = 'Business_Plan';
			IF v_cnt_2 > 0
			BEGIN
				V_SP_BP := 'BP';
			END
			ELSE
			BEGIN
				V_SP_BP := 'SP';
			END


            /* TODO:GTT:GT_DMF0_REPORT_C-->GT_DMF0_REPORT_C */
            INSERT INTO GT_DMF0_REPORT_C
            SELECT A.DIVISION_ID, A.PRODUCT_GROUP
				, CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF'
						ELSE A.MEASURE
						END AS MEASURE
				, A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT
				, CASE WHEN A.MEASURE IN ( 'RTF','Business_Plan','RTF_SYS_RP') AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
					ELSE A.QTY
					END AS QTY
              FROM DM_PLN_SALES_PLAN_REPORT_C A
			  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
				    ON A.DIVISION_ID = B.DIVISION_ID
						AND A.ITEM_ID = B.ITEM_ID
             WHERE A.DIVISION_ID = p_division_id
               AND A.VERSION_NO  = p_version_no
               AND A.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW')
			   AND A.DATA_TYPE = '1'
			UNION ALL
            SELECT A.DIVISION_ID, A.PRODUCT_GROUP
				, CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF'
						WHEN A.MEASURE = 'RTF_SYS_RP' THEN CASE WHEN V_SP_BP = 'BP' THEN 'RTF' ELSE A.MEASURE  END
						ELSE A.MEASURE
						END AS MEASURE
				, A.YYYYMMDD, A.PRODUCT_DETAILS, A.ATTRIBUTE2, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT
				, CASE WHEN A.MEASURE in ( 'RTF','Business_Plan' ) AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
					ELSE A.QTY
					END AS QTY
              FROM DM_PLN_SALES_ETC_REPORT_C A
			  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
				    ON A.DIVISION_ID = B.DIVISION_ID
						AND A.ITEM_ID = B.ITEM_ID
             WHERE A.DIVISION_ID = p_division_id
               AND A.VERSION_NO  = p_version_no
               AND A.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW');

--SELECT * FROM GT_DMF0_REPORT_C WHERE MEASURE = 'Business_Plan'

			-- 2020.05.25 1~3 담당 외에는 기타로 묶는다.

			SELECT SEGMENT1
  INTO V_ETC_DEPARTMENT_ID
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
			WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
				--AND SEGMENT1 = '기타'
				AND ATTRIBUTE1 = 'Y';

			UPDATE A
			SET DEPARTMENT_ID = v_ETC_DEPARTMENT_ID
			FROM GT_DMF0_REPORT_C A
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y'
			WHERE B.SEGMENT1 IS NULL;

			UPDATE A
			SET DEPARTMENT_ID = v_ETC_DEPARTMENT_ID
				, DEPT_ID = v_ETC_DEPARTMENT_ID
			FROM DM_PLN_SALES_PLAN_REPORT_C A
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y'
			WHERE B.SEGMENT1 IS NULL
				AND DIVISION_ID = p_division_id
				AND VERSION_NO = p_version_no;

			UPDATE A
			SET DEPARTMENT_ID = v_ETC_DEPARTMENT_ID
				, DEPT_ID = v_ETC_DEPARTMENT_ID
			FROM DM_PLN_SALES_ETC_REPORT_C A
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y'
			WHERE B.SEGMENT1 IS NULL
				AND DIVISION_ID = p_division_id
				AND VERSION_NO = p_version_no
				--AND DATA_TYPE = '1'


			--------------------------------------------------------- TEMP TABLE 확인후 초기화
			    -- 연도 커서 선언
			-- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- yyyyList CURSOR FOR
			SELECT A.YYYY
			  FROM (
					SELECT DISTINCT SUBSTR(YYYYMMDD, 1, 4) AS YYYY
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					WHERE A.DIVISION_ID = p_division_id
						AND A.VERSION_NO  = p_version_no
				   ) A;

            OPEN yyyyList
            FETCH yyyyList INTO v_yyyy;

            WHILE v_fetch_status = 0
            BEGIN

			--SELECT C.DIVISION_ID
			--	, p_version_no AS VERSION_NO
			--	, v_yyyy         AS YYYY
			--	, 'SP'          AS SP_BP_TYPE
			--	-- 20191023 kyh
			--	, CASE WHEN NVL((SELECT ATTRIBUTE1
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--						WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1),'') = 'Y'
			--				THEN (SELECT ATTRIBUTE2
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--					WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1)
			--		ELSE ( SELECT Segment2
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--						WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1)
			--	END AS DEPARTMENT_NAME
			--	, CASE WHEN NVL((SELECT ATTRIBUTE1
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--						WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1),'') = 'Y'
			--				THEN (SELECT ATTRIBUTE3
			--						FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--					WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
			--						AND C.DEPARTMENT_ID = SEGMENT1)
			--		ELSE C.DEPT_NAME
			--	END AS DEPT_NAME
			--	, ATTRIBUTE1, DEPARTMENT_ID, ATTRIBUTE2
			--	, C.CUST_REPORT
			--	, C.END_CUST_REPORT
			--	, C.PRODUCT_GROUP AS PRODUCT_NAME
			--	, C.ATTRIBUTE1 AS PRODUCT_DETAIL
			--	, C.MEASURE
			--	, SUBSTR(C.YYYYMMDD,1,6) AS YYYYMM
			--	, C.QTY
			--FROM GT_DMF0_REPORT_C C
			--WHERE 1 = 1
			----AND C.DIVISION_ID = p_division_id
			----AND C.VERSION_NO  = p_version_no
			--AND C.MEASURE IN ('RTF','SalesAmt_KRW')
			--AND C.YYYYMMDD LIKE v_yyyy+'%'





 INSERT INTO DM_MOBILE_REPORT_DEPT
                     ( DIVISION_ID
                     , VERSION_NO
                     , YYYY
                     , SP_BP_TYPE
                     , UPPER_DEPT_NAME
                     , DEPT_NAME
                     , CUST_INFO
           , PRODUCT_NAME
                     , PRODUCT_DETAIL
                     , MEASURE
                     , MM01
                     , MM02
                     , MM03
                     , MM04
				     , MM05
                     , MM06
                     , MM07
                     , MM08
                     , MM09
                     , MM10
                     , MM11
                     , MM12
                     , ORI_VERSION_NO
                     , SORT_NO
                     , CREATED_BY
       , CREATION_DATE
                     , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
			   SELECT A.DIVISION_ID
                     , A.VERSION_NO
                 , A.YYYY
                     , A.SP_BP_TYPE
                     , A.DEPARTMENT_NAME
                     , A.DEPT_NAME
                     , CUST_INFO
                     , A.PRODUCT_NAME
                     , A.PRODUCT_DETAIL
                     , CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
                     , MM01
                     , MM02
                     , MM03
                     , MM04
         , MM05
                     , MM06
                     , MM07
 , MM08
                     , MM09
                     , MM10
                     , MM11
                     , MM12
                     , v_ori_version_no AS ORI_VERSION_NO
                     , ROW_NUMBER() OVER(ORDER BY CASE WHEN A.DEPARTMENT_NAME IS NULL OR A.DEPARTMENT_NAME = '기타' THEN '힣' ELSE A.DEPARTMENT_NAME END
                                                 , CASE WHEN A.DEPT_NAME = 'MDF' THEN '힣' ELSE A.DEPT_NAME END
                                                 , A.DEPT_NAME
                                                 , A.DISPLAY_SEQ
                                                 , A.MEASURE) AS SORT_NO
                     , v_user_id   AS CREATED_BY
                     , SYSDATE  AS CREATION_DATE
                     , v_user_id   AS LAST_UPDATED_BY
               , SYSDATE  AS LAST_UPDATE_DATE
				FROM (
						SELECT A.DIVISION_ID
							 , p_version_no AS VERSION_NO
							 , A.YYYY
							 , A.SP_BP_TYPE
							 , A.DEPARTMENT_NAME
							 , A.DEPT_NAME
							 , A.CUST_REPORT     AS CUST_INFO
							 , A.PRODUCT_NAME
							 , A.PRODUCT_DETAIL
							 , A.MEASURE
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '01' THEN QTY ELSE 0 END) AS MM01
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '02' THEN QTY ELSE 0 END) AS MM02
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '03' THEN QTY ELSE 0 END) AS MM03
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '04' THEN QTY ELSE 0 END) AS MM04
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '05' THEN QTY ELSE 0 END) AS MM05
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '06' THEN QTY ELSE 0 END) AS MM06
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '07' THEN QTY ELSE 0 END) AS MM07
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '08' THEN QTY ELSE 0 END) AS MM08
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '09' THEN QTY ELSE 0 END) AS MM09
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '10' THEN QTY ELSE 0 END) AS MM10
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '11' THEN QTY ELSE 0 END) AS MM11
							 , SUM(CASE WHEN A.YYYYMM = v_yyyy || '12' THEN QTY ELSE 0 END) AS MM12
							 , B.DISPLAY_SEQ
						  FROM (SELECT C.DIVISION_ID
									 , p_version_no AS VERSION_NO
									 , v_yyyy         AS YYYY
									 , 'SP'          AS SP_BP_TYPE
									 -- 20191023 kyh
									, NVL((SELECT SEGMENT2
											FROM SCM_ADM_LOOKUP_MASTER_DETAIL
											WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
											AND C.DEPARTMENT_ID = SEGMENT1), NULL);
									   AS DEPARTMENT_NAME
									 ,  NVL((SELECT SEGMENT2
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL
										WHERE LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
										AND C.DEPT_ID = SEGMENT1), NULL);
										AS DEPT_NAME
									 , C.CUST_REPORT
									 , C.END_CUST_REPORT
									 , C.PRODUCT_GROUP AS PRODUCT_NAME
									 , C.ATTRIBUTE1 AS PRODUCT_DETAIL
									 , C.MEASURE
									 , SUBSTR(C.YYYYMMDD,1,6) AS YYYYMM
									 , C.QTY
								  FROM GT_DMF0_REPORT_C C
								 WHERE 1 = 1
								   --AND C.DIVISION_ID = p_division_id
								   --AND C.VERSION_NO  = p_version_no
								   AND C.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW')
								   AND C.YYYYMMDD LIKE v_yyyy || '%'
								) A;
								LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
								  ON A.CUST_REPORT = B.SEGMENT1
								 AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
						 GROUP BY;
							 A.DIVISION_ID
							 , A.VERSION_NO
							 , A.YYYY
							 , A.SP_BP_TYPE
							 , A.DEPARTMENT_NAME
							 , A.DEPT_NAME
							 , A.CUST_REPORT
							 --, CASE WHEN A.DATA_TYPE = '1' THEN A.CUST_REPORT ELSE A.END_CUST_REPORT END
							 , A.PRODUCT_NAME
							 , A.PRODUCT_DETAIL
							 , B.DISPLAY_SEQ
							 , A.MEASURE
				) A;

                FETCH yyyyList INTO v_yyyy;

            END

            CLOSE yyyyList
            DEALLOCATE yyyyList


		END

		-- --------------------------------------------------------------------------------------------------
		--                                                                           요청VERSION COPY (END)
		-- --------------------------------------------------------------------------------------------------
 	-- ------------------------------------------------------------------------------------------------------------------------
	END TRY
	-- ------------------------------------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
	BEGIN CATCH
	-- -----------------------------------------------------------
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		v_log_type := 'ERROR';
		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
		v_description := 'ERROR_LINE : '  ||  STR(NULL);
		d_event_date := SYSTIMESTAMP;

		SELECT '(DMF0044_SALES_REPORT_DEPT_CREATE)['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

	-- -----------------------------------------------------------
	-- END CATCH
	-- -----------------------------------------------------------
	-- 종료 LOG
	v_log_type := 'END';
	v_log_message := '########## END of procedure ##########';
	v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
	d_event_date := SYSTIMESTAMP;

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0044_SALES_REPORT_PRODUCT_CREATE
(
	p_division_id            VARCHAR2,
	p_version_no             VARCHAR2,
	p_action_type            VARCHAR2,		-- T:Transfer, C:Cancel
	p_yyyy                   VARCHAR2

/*
 * Program ID   : DMF0044_SALES_REPORT_PRODUCT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release PJ20189106 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191113 KYH 팩일 경우 QTY 조정
 * 20191118 hwi1993 파라미터 추가 및 데이터타입 변경, Cancel 기능 추가
 * 20200512 hwi1993 ETC 매출 테이블 추가
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:26
 * 파일: dbo.DMF0044_SALES_REPORT_PRODUCT_CREATE.sql
 * ----------------------------------------
 * ⚠ IF: IF:2  END IF:0  차이:+2
 * ⚠ BEGIN: BEGIN:4  END:5  차이:-1
 * ----------------------------------------
 * BEGIN 위치: L44, L78, L91, L138
 * END;  위치: L82, L204, L210, L216, L250
 * ----------------------------------------
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    -- $$PLSQL_UNIT 제거: $$PLSQL_UNIT 사용 (사내 표준 §11)
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_merge_count INTEGER := 0;
    v_yyyy VARCHAR2(4 CHAR);
    v_user_id VARCHAR2(10 CHAR) := 'mdf_batch';
    v_getdate VARCHAR2(50 CHAR) := SYSDATE;
    v_ori_version_no VARCHAR2(50 CHAR);
    v_cnt_1  INTEGER := 0;
BEGIN
            	-- LOG 용 변수 설정












	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- ------------------------------------------------------------------------------------------------------------------------
	BEGIN TRY
	-- ------------------------------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------
		--                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
		-- --------------------------------------------------------------------------------------------------
		SELECT COUNT(1)
		INTO v_cnt_1
		FROM DM_MOBILE_REPORT_PRODUCT  WHERE 1=1
		AND DIVISION_ID = p_division_id
		AND VERSION_NO  = p_version_no;
		IF v_cnt_1 > 0
			BEGIN
				DELETE FROM DM_MOBILE_REPORT_PRODUCT WHERE 1=1
					AND DIVISION_ID = p_division_id
					AND VERSION_NO  = p_version_no;
			END

		-- --------------------------------------------------------------------------------------------------
		--                                                     중복 VERSION이 있는경우 삭제후 COPY (END)
		-- --------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------
		--                                       요청VERSION COPY (BEGIN)
		-- --------------------------------------------------------------------------------------------------
		IF p_action_type = 'T' -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리
		BEGIN

			--------------------------------------------------------- TEMP TABLE 확인후 초기화
            SELECT ORI_VERSION_NO INTO v_ori_version_no FROM DM_MDF_VERSION  WHERE DIVISION_ID = p_division_id AND VERSION_NO = p_version_no;
			/* TODO:GTT:GT_DMF0_REPORT_C-->GT_DMF0_REPORT_C */
			INSERT INTO GT_DMF0_REPORT_C
			SELECT A.DIVISION_ID, A.PRODUCT_GROUP, CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE, A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2
				, CASE WHEN A.MEASURE = 'RTF' AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
					ELSE A.QTY
					END AS QTY
              FROM DM_PLN_SALES_PLAN_REPORT_C A
				  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
				    ON A.DIVISION_ID = B.DIVISION_ID
						AND A.ITEM_ID = B.ITEM_ID
             WHERE A.DIVISION_ID = p_division_id
               AND A.VERSION_NO  = p_version_no
			   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')
			UNION ALL
            SELECT A.DIVISION_ID, A.PRODUCT_GROUP, CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE, A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2
				, CASE WHEN A.MEASURE = 'RTF' AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
					ELSE A.QTY
					END AS QTY
              FROM DM_PLN_SALES_ETC_REPORT_C A
				  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
				    ON A.DIVISION_ID = B.DIVISION_ID
						AND A.ITEM_ID = B.ITEM_ID
             WHERE A.DIVISION_ID = p_division_id
               AND A.VERSION_NO  = p_version_no
			   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW');
			--------------------------------------------------------- TEMP TABLE 확인후 초기화
			-- 연도 커서 선언
			-- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- yyyyList CURSOR FOR
			SELECT A.YYYY
			  FROM (SELECT TO_CHAR(TO_NUMBER(p_yyyy) - 1) AS YYYY
					UNION ALL
					SELECT p_yyyy
					UNION ALL
					SELECT TO_CHAR(TO_NUMBER(p_yyyy) || 1) AS YYYY
				   ) A
					FROM DUAL;


            OPEN yyyyList
            FETCH yyyyList INTO v_yyyy;

            WHILE v_fetch_status = 0
            BEGIN
                INSERT INTO DM_MOBILE_REPORT_PRODUCT
                     ( DIVISION_ID
                     , VERSION_NO
                     , YYYY
                     , SP_BP_TYPE
                     , PRODUCT_NAME
                     , PRODUCT_DETAIL
                     , MEASURE
                     , MM01
                     , MM02
                     , MM03
                     , MM04
                     , MM05
                     , MM06
                     , MM07
                     , MM08
                     , MM09
                     , MM10
                     , MM11
                     , MM12
                     , ORI_VERSION_NO
					 , SORT_NO
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE )
                SELECT A.DIVISION_ID
                     , p_version_no AS VERSION_NO
                     , v_yyyy         AS YYYY
                     , 'SP'          AS SP_BP_TYPE
                     , A.PRODUCT_GROUP AS PRODUCT_NAME
                     , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1, NULL)
                            WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2, NULL)
                            ELSE ''
                       END           AS PRODUCT_DETAIL
                     , A.MEASURE
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '01' THEN A.QTY ELSE 0 END) AS MM01
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '02' THEN A.QTY ELSE 0 END) AS MM02
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '03' THEN A.QTY ELSE 0 END) AS MM03
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '04' THEN A.QTY ELSE 0 END) AS MM04
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '05' THEN A.QTY ELSE 0 END) AS MM05
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '06' THEN A.QTY ELSE 0 END) AS MM06
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '07' THEN A.QTY ELSE 0 END) AS MM07
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '08' THEN A.QTY ELSE 0 END) AS MM08
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '09' THEN A.QTY ELSE 0 END) AS MM09
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '10' THEN A.QTY ELSE 0 END) AS MM10
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '11' THEN A.QTY ELSE 0 END) AS MM11
                     , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = v_yyyy || '12' THEN A.QTY ELSE 0 END) AS MM12
                     , v_ori_version_no AS ORI_VERSION_NO
					 , B.DISPLAY_SEQ
                     , v_user_id   AS CREATED_BY
                     , SYSDATE  AS CREATION_DATE
                     , v_user_id   AS LAST_UPDATED_BY
                     , SYSDATE  AS LAST_UPDATE_DATE
                  FROM GT_DMF0_REPORT_C A
				  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
					ON A.PRODUCT_GROUP = B.SEGMENT1
                         AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
                 WHERE 1 = 1
                   AND A.YYYYMMDD LIKE v_yyyy || '%'
                 GROUP BY A.DIVISION_ID
                     , A.PRODUCT_GROUP
                     , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1, NULL)
                            WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2, NULL)
                            ELSE ''
                       END
                     , A.MEASURE
					 , B.DISPLAY_SEQ

              FETCH yyyyList INTO v_yyyy;

            END

            CLOSE yyyyList
            DEALLOCATE yyyyList


		END

		-- --------------------------------------------------------------------------------------------------
		--                                                                           요청VERSION COPY (END)
		-- --------------------------------------------------------------------------------------------------
 	-- ------------------------------------------------------------------------------------------------------------------------
	END TRY
	-- ------------------------------------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
	BEGIN CATCH
	-- -----------------------------------------------------------
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		v_log_type := 'ERROR';
		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
		v_description := 'ERROR_LINE : '  ||  STR(NULL);
		d_event_date := SYSTIMESTAMP;

		SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		--[C20200909-000203] LOG 표준화 적용
		PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	-- -----------------------------------------------------------
	-- END CATCH
	-- -----------------------------------------------------------
	-- 종료 LOG
	v_log_type := 'END';
	v_log_message := '########## END of procedure ##########';
	v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
	d_event_date := SYSTIMESTAMP;

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0044_SAVE_SALES_PLAN_VERSION_COPY
(
--DECLARE
	p_division_id				VARCHAR2,
	p_version_no				VARCHAR2,
	p_version_description		VARCHAR2,
	p_created_by				VARCHAR2,
	p_result_date				VARCHAR2,		-- 실적기준일
	p_action_type				VARCHAR2,		-- D:삭제, CR: 생성, CP:복사
	p_mv_plan_yyyymm			VARCHAR2,		-- 이동계획 월
	p_update_yn				VARCHAR2			-- Y일 경우 마스터들을 최신 데이터로 업데이트한다.

)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:29
 * 파일: dbo.DMF0044_SAVE_SALES_PLAN_VERSION_COPY.sql
 * ----------------------------------------
 * ⚠ IF: IF:42  END IF:21  차이:+21
 * ⚠ BEGIN: BEGIN:26  END:24  차이:+2
 * ----------------------------------------
 * BEGIN 위치: L44, L102, L116, L213, L222, L228, L245, L255, L264, L275 ...
 * END;  위치: L112, L118, L220, L233, L234, L235, L248, L258, L267, L278 ...
 * ----------------------------------------
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    -- $$PLSQL_UNIT 제거: $$PLSQL_UNIT 사용 (사내 표준 §11)
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_merge_count INTEGER := 0;
    v_version_type VARCHAR2(50 CHAR);
    v_Ori_Version VARCHAR2(30 CHAR);
    v_cp_VERSION_NO VARCHAR2(30 CHAR);
    v_cp_CUTOFF_TYPE VARCHAR2(20 CHAR);
    v_cp_CUTOFF_YYYYMMDD VARCHAR2(8 CHAR);
    V_RESULT_YEAR_CNT VARCHAR2(1 CHAR);
    V_MAX_ETC_RESULT_VERSION_NO VARCHAR2(30 CHAR);
    V_ETC_RESULT_MONTH VARCHAR2(6 CHAR);
    V_MAX_DATA_SEQ INTEGER;
    c_ER_version VARCHAR2(100 CHAR);
    v_plan_start_yyyymmdd VARCHAR2(08 CHAR);
    c_cutoff_yyyymmdd VARCHAR2(08 CHAR);
    v_ETC_DEPARTMENT_ID VARCHAR2(30 CHAR);
    v_rp_version VARCHAR2(2 CHAR);
    V_RPT_SEQ INTEGER;
    v_version_x VARCHAR2(50 CHAR);
    V_VERSION_NO_VMI VARCHAR2(50 CHAR);
    V_MON_CNT INTEGER;
    v_cnt_1  INTEGER := 0;
BEGIN
            	-- LOG 용 변수 설정









	    d_Result_Date NCHAR(8); -- 실적구간을 판단하는 기준일자. p_action_type 이 CR 일 경우 컷오프시점 기준으로 월요일까지의 일자들을 실적으로 보고, CP일 경우 지정된 날짜를 그대로 받는다.

	DECLARE v_err_mv_version_no	VARCHAR2(30 CHAR)	-- 기 존재하는 이동계획버전

	-- copy 시 Result 에서 데이터를 불러오면 version 관련 컬럼이 없어서 Report_c 의 정보를 담아놓는 변수



	DECLARE v_cp_MIN_YYYYMMDD		VARCHAR2(8 CHAR)	-- Sales Report_C 테이블의 해당 버전의 시작일자. 이 날짜부터 실적을 복사한다.




	SELECT ATTRIBUTE1
  INTO V_RESULT_YEAR_CNT
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE LOOKUP_TYPE = 'SALES_REPORT_SETTING'
		and segment1 = 'Result_Start_Year_Cnt'
		and segment2 = p_division_id;

	IF ISNUMERIC(V_RESULT_YEAR_CNT) > 0 THEN
		SELECT v_cp_MIN_YYYYMMDD = TO_CHAR(ADD_MONTHS(SYSDATE, (-1 * V_RESULT_YEAR_CNT)*12), 'YYYYMMDD') ||  '0101'
	END IF;

	-- 버전 유형 확인
	SELECT VERSION_TYPE
  INTO v_version_type
	FROM DM_MDF_VERSION
	WHERE DIVISION_ID = p_division_id
		AND VERSION_NO = p_version_no;

	IF v_version_type IS NULL THEN
		SELECT v_version_type = VERSION_TYPE
		FROM DM_MST_VERSION
		WHERE DIVISION_ID = p_division_id
			AND VERSION_NO = p_version_no;
	END IF;

	-- PJ202001380 Future Price Version_No 구분
	/*



	-- 변수값 셋팅
	-- ----------------------------------------------------------------------------------------------------------------------------------------
	-- Weekly Cutoff 환율 Version No 조회 (40,81 : 화요일 /82 : SP Version과 동일)
	IF v_version_type NOT LIKE 'REPORT%' AND p_division_id IN ('40', '81') AND  SUBSTR(p_version_no, 1, 4) = 'SP_W'
		BEGIN
			c_cutoff_yyyymmdd := SUBSTR(p_version_no,6,8);
			v_plan_start_yyyymmdd := TO_CHAR(FN_NEXT_DAY(c_cutoff_yyyymmdd, 'MON') + (-7), 'YYYYMMDD')   -- 월요일
			SELECT c_ER_version = NVL(MAX(VERSION_NO), p_version_no)
			FROM   DM_MST_VERSION
			WHERE  DIVISION_ID  = p_division_id
			and    yyyymmdd    >= v_plan_start_yyyymmdd
			and    yyyymmdd    <= c_cutoff_yyyymmdd
			and    version_type = 'SP_W'
			and    CREATED_BY   = 'WITHOUT_SP_W';
		END

	ELSE

		BEGIN
			c_ER_version := p_version_no;
		END

	-- ----------------------------------------------------------------------------------------------------------------------------------------
	*/

	-- 시작 LOG  (START)
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);
	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)

	-- ------------------------------------------------------------------------------------------------------------------------
	BEGIN TRY
	-- ------------------------------------------------------------------------------------------------------------------------
		-- Div 에 관계없이 여기에 넣고, 나중에 집계하면서 Div 별 처리한다.
		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_VERSION_COPY';

		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_REPORT';

		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_MEASURE';

	--[E20230906-001160]_DM SINGLE VIEW 수정
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
	SELECT DISTINCT ITEM_ID,ITEM_CLASS_NAME
			, CASE WHEN ISNUMERIC(ENERGE) > 0 THEN CAST(ENERGE AS NUMERIC(30,10)) ELSE 0 END AS ENERGY
			, CASE WHEN ISNUMERIC(CELL_QUANTITY) > 0 THEN CAST(CELL_QUANTITY AS NUMERIC(30,10)) ELSE 0 END AS CELL_QUANTITY
			, FORECAST_INFO_BIZ_TYPE	-- 소형 BIZ_TYPE ( 부자재 매출 제거에 사용 )
			, FORECAST_INFO_SPEC, NICK_NAME,FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
	FROM (
			SELECT	T1.DIVISION_ID, T1.ITEM_ID
				  , MAX(T1.ITEM_CLASS_NAME)						AS ITEM_CLASS_NAME			--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
				  , MAX(T1.ENERGE)  							AS ENERGE
				  , MAX(T1.CELL_QUANTITY)						AS CELL_QUANTITY
				  , MAX(T2.FORECAST_INFO_BIZ_TYPE)				AS FORECAST_INFO_BIZ_TYPE
				  , MAX(T2.FORECAST_INFO_SPEC)					AS FORECAST_INFO_SPEC
				  , MAX(T1.NICK_NAME)							AS NICK_NAME				--닉네임이 NULL인 경우가 있으므로 하나로 통일
				  , MAX(T2.FORECAST_INFO_CELL_MODEL)			AS FORECAST_INFO_CELL_MODEL
				  , MAX(T2.FORECAST_INFO_CELL_PACK_COUNT)		AS FORECAST_INFO_CELL_PACK_COUNT
			FROM SCM_MST_ITEM_SN T1
			INNER JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
							, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
							, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
							, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
							, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
						 FROM  SCM_MST_ITEM_SN T2
				         WHERE  DIVISION_ID =  p_division_id
						 GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
					   ) T2;
					ON T1.DIVISION_ID = T2.DIVISION_ID
				   AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
			WHERE 1=1
			AND		T1.DIVISION_ID = p_division_id
			GROUP BY T1.DIVISION_ID, T1.ITEM_ID
			) G;


	-- --------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
	-- --------------------------------------------------------------------------------------
	CREATE CLUSTERED INDEX IDX1_TEMP_DM_MST_ITEM_SINGLE_V ON GT_DMF0_DM_MST_ITEM_SINGLE_V
	(
		item_id       ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY
	-- ---------------------------------------------------------------------------------------
	--                      20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
	-- ---------------------------------------------------------------------------------------
	-- ---------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	-- ---------------------------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_SCM_MST_SITE_ITEM-->GT_DMF0_SCM_MST_SITE_ITEM */
	INSERT INTO GT_DMF0_SCM_MST_SITE_ITEM
	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
		, CASE WHEN ISNUMERIC(CELL_PER_CAR) > 0 THEN CAST(CELL_PER_CAR AS NUMERIC(30,10)) ELSE 0 END AS CELL_PER_CAR
		, CASE WHEN ISNUMERIC(CELL_PER_MODULE) > 0 THEN CAST(CELL_PER_MODULE AS NUMERIC(30,10)) ELSE 0 END AS CELL_PER_MODULE
		--, CURRENCY, LIABILITY_PERIOD
		--, SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID, VALID_YN, BPMS_EXIST, CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION
		--, ROUTE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
		--, ATTRIBUTE9, ATTRIBUTE10, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5, REPORT_GROUP6
		--, REPORT_GROUP7, REPORT_GROUP8, OS_CORP, CONTRIBUTION_TYPE, EDI_LT, SCP_VMI_LT
		--, FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' )                AS OWNER_NAME
		--, FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
		--,(	SELECT SU.DEPT_ID
		--	FROM SCM_MST_SSO_USER_INFO SU
		--	WHERE SU.USER_ID = (SELECTtoken FROM TABLE(fn_string_split(SMSI.owner, ','))) ) DEPT_ID
	FROM SCM_MST_SITE_ITEM SMSI
	WHERE SMSI.Division_id = p_division_id;

		-- 실적 기준일 지정
		IF ( p_action_type = 'CR')
		BEGIN
FETCH FIRST 1 ROWS ONLY
			SELECT TO_CHAR(FN_NEXT_DAY(YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
  INTO d_Result_Date
			FROM DM_MST_VERSION
			WHERE DIVISION_ID = P_DIVISION_ID
				AND VERSION_NO = P_VERSION_NO;
		END
		ELSE IF (p_action_type = 'CP')
		BEGIN
			-- 화면에서 실적기준일을 안받았을 경우 '' 으로 처리한다.
			d_Result_Date := REPLACE(p_result_date, '-', '');

			-- 말일자일 경우 해당월, 아니면 직전월
			IF d_Result_Date IS NOT NULL
			BEGIN
				V_ETC_RESULT_MONTH := CASE WHEN d_Result_Date = TO_CHAR(TO_CHAR(ADD_MONTHS(d_Result_Date, 1), 'YYYYMMDD') || '01'  ||  (-1)ADD_MONTHS(d_Result_Date, 1), 'YYYYMMDD') || '01'), 'YYYYMMDD');
												THEN SUBSTR(d_Result_Date, 1, 6)
										ELSE
											TO_CHAR(ADD_MONTHS(d_Result_Date, -1), 'YYYYMMDD')
										END
			END
		END

		IF ISDATE( NVL(V_ETC_RESULT_MONTH, NULL)  ||  '01') < 1
			V_ETC_RESULT_MONTH := TO_CHAR(SYSDATE, 'YYYYMMDD');

		-- --------------------------------------------------------------------------------------------------
		--                                                   Validation (BEGIN)
		-- --------------------------------------------------------------------------------------------------
		IF NOT EXISTS ( SELECT 1 FROM SCM_MST_DIVISION  WHERE 1=1
									AND DIVISION_ID = p_division_id );
			BEGIN
				v_log_type := 'DIVISION_INVALID';
				GOTO ERR_RTN
			END

		-- 기능과 버전이 안맞는 경우 ( 생성 : SP_W, BP_M 만 가능, 복사, 삭제 : REPORT_로 시작하는 버전만 가능 )
		IF p_action_type IN ( 'CP', 'D' )
			AND NOT EXISTS ( SELECT 1 FROM DM_MDF_VERSION NOLOCK
								WHERE DIVISION_ID = p_division_id
									AND VERSION_NO  = p_version_no );
			BEGIN
				v_log_type := 'VERSION_NO_INVALID';
				GOTO ERR_RTN
			END

		IF p_action_type = 'CR'
			AND NOT EXISTS ( SELECT 1 FROM DM_MST_VERSION NOLOCK
								WHERE DIVISION_ID = p_division_id
									AND VERSION_NO  = p_version_no );
			BEGIN
				v_log_type := 'VERSION_NO_INVALID';
				GOTO ERR_RTN
			END

		-- 삭제인데, Send_YN 이 Y 인 경우
		IF p_action_type = 'D'
			AND EXISTS ( SELECT 1 FROM DM_MDF_VERSION  WHERE 1=1
									AND DIVISION_ID = p_division_id
									AND VERSION_NO  = p_version_no
									AND SEND_YN = 'Y' );
			BEGIN
				v_log_type := 'VERSION_NO_INVALID';
				GOTO ERR_RTN
			END

		-- 이동계획일 경우 DIV 별로 UNIQUE 한 지 확인
		IF ISDATE(p_mv_plan_yyyymm  ||  '01') > 0
			AND EXISTS ( SELECT DIVISION_ID
							FROM DM_MDF_VERSION
							WHERE SEND_YN <> 'D'
								AND MV_PLAN_YYYYMM = p_mv_plan_yyyymm
								AND DIVISION_ID = p_division_id
						)
			AND p_action_type = 'D';
			BEGIN
				SELECT v_err_mv_version_no = MAX(VERSION_NO)
				FROM DM_MDF_VERSION
				WHERE SEND_YN <> 'D'
					AND MV_PLAN_YYYYMM = p_mv_plan_yyyymm
					AND DIVISION_ID = p_division_id;

				IF v_err_mv_version_no IS NOT NULL
				BEGIN
					SELECT v_log_type = '이동계획 중복'
						, v_description = '이미 해당월의 이동계획이 있습니다.['  ||  RTRIM(v_err_mv_version_no)  ||  ']'
					GOTO ERR_RTN
				END
			END

		-- 1~3 담당 외에는 기타로 묶기 위애서 기타 부서코드를 찾는다.

				, v_ETC_DEPARTMENT_NAME VARCHAR2(100 CHAR)
		SELECT V_ETC_DEPARTMENT_ID = SEGMENT1
			, v_ETC_DEPARTMENT_NAME = SEGMENT2
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
		WHERE A.LOOKUP_TYPE = 'MDF_DEPARTMENT'
			AND A.SEGMENT3 = 'Y'
			AND A.ATTRIBUTE1 = 'Y';


		-- --------------------------------------------------------------------------------------------------
		--                                                                                 Validation (END)
		-- --------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------
		--                                                   MDF VERSION MST INSERT (BEGIN)
		-- --------------------------------------------------------------------------------------------------
		    V_VERSION_DATE NCHAR(8);
				, V_NEW_VERSION_NO		VARCHAR2(50 CHAR)
				, V_ORI_CUTOFF_VERSION	VARCHAR2(50 CHAR)
				, V_SP_BP				NCHAR(2)
		V_VERSION_DATE := TO_CHAR(SYSDATE, 'YYYYMMDD'); -- 채번 기준일자

		--[PJ2024-50611] Sales Report 생성 시 Catcu_Up 수량 더해줌 START
		--CATCH_UP 메저를 가진 데이터셋 생성
		/* TODO:GTT:GT_DMF0_PLAN_C_CATCHUP-->GT_DMF0_PLAN_C_CATCHUP */
		INSERT INTO GT_DMF0_PLAN_C_CATCHUP
		SELECT *
		FROM
		(
			SELECT
				A.DIVISION_ID
				,A.VERSION_NO
				, 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE
				,A.CUTOFF_YYYYMMDD
				,A.PROJECT_CODE
				,A.SCM_SITE_ID
				,A.ITEM_ID
				,A.DOM_EXP
				,A.FCST_TYPE
				,A.INCOTERMS
				,A.CURRENCY
				,A.MEASURE AS ORG_MEASURE
				,CASE WHEN A.MEASURE = 'Catch_Up' THEN 'RTF_SYS_RP'
					  WHEN A.MEASURE = 'SalesAmt_KRW_Catch_Up' THEN 'SalesAmt_KRW'
					  WHEN A.MEASURE = 'SalesAmt_LOC_Catch_Up' THEN 'SalesAmt_LOC'
					  WHEN A.MEASURE = 'SalesAmt_USD_Catch_Up' THEN 'SalesAmt_USD'
				 END AS MEASURE -- RTF_ALLOCATION 과 매핑을 위한 MEASURE로 변경
				 ,A.PLANT_SITE_ID
				,A.YYYYMMDD
				,A.QTY
				,B.SALES_COMPANY AS COMPANY_ID
				,B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
				--,'' AS CELL_PROD_SITE
				,'-' AS CELL_PROD_SITE--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
				--FROM DM_PLN_SALES_PLAN_C A
				FROM DM_PLN_SALES_ETC_PLAN_C A --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
				JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
				WHERE A.VERSION_NO = p_version_no
				AND A.DIVISION_ID = p_division_id
				AND A.YYYYMMDD >= d_Result_Date
				AND A.MEASURE IN (
					SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
					WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
					AND SEGMENT1 = p_division_id
					AND VALID_YN = 'Y'
				)
				UNION ALL
				SELECT
				A.DIVISION_ID
				,A.VERSION_NO
				, 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE
				,A.CUTOFF_YYYYMMDD
				,A.PROJECT_CODE
				,A.SCM_SITE_ID
				,A.ITEM_ID
				,A.DOM_EXP
				,A.FCST_TYPE
				,A.INCOTERMS
				,A.CURRENCY
				,A.MEASURE AS ORG_MEASURE
				,CASE WHEN A.MEASURE = 'Catch_Up' THEN 'MKT_FCST'
				 END AS MEASURE -- RTF_ALLOCATION 과 매핑을 위한 MEASURE로 변경
				 ,A.PLANT_SITE_ID
				,A.YYYYMMDD
				,A.QTY
				,B.SALES_COMPANY AS COMPANY_ID
				,B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
				--,'' AS CELL_PROD_SITE
				--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
				,'-' AS CELL_PROD_SITE
				--FROM DM_PLN_SALES_PLAN_C A
				FROM DM_PLN_SALES_ETC_PLAN_C A --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
				JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
				WHERE A.VERSION_NO = p_version_no
				AND A.DIVISION_ID = p_division_id
				AND A.YYYYMMDD >= d_Result_Date
				AND A.MEASURE = 'Catch_Up'
				AND A.cutoff_type = 'SP_W'
			) A;
		--[PJ2024-50611] Sales Report 생성 시 Catcu_Up 수량 더해줌 END


		-- 버전처리
		IF p_action_type IN ( 'CR')
		BEGIN

			SELECT NVL(MAX(VER_CRE_SEQ),0) || 1
  INTO V_RPT_SEQ
			FROM DM_MDF_VERSION
			WHERE DIVISION_ID		= p_division_id
				AND TO_CHAR(CREATION_DATE, 'YYYYMMDD') = V_VERSION_DATE

			-- [C20201014-000098] SP_M추가 ( LIKE '%SP_W' -> LIKE '%SP%' )
			SELECT V_SP_BP		= CASE WHEN VERSION_TYPE LIKE '%SP%' THEN 'SP' ELSE 'BP' END
			FROM DM_MST_VERSION
			WHERE DIVISION_ID = p_division_id
				AND VERSION_NO = P_VERSION_NO;

			-- 최종 버전 셋팅
			V_NEW_VERSION_NO := CASE WHEN ISDATE(p_mv_plan_yyyymm  ||  '01') > 0 THEN 'RP_' ELSE 'R_' END
					 ||  SUBSTR(V_SP_BP, 1, 1)
					 ||  '_'
					 ||  V_VERSION_DATE
					 ||  '_V'
					 ||  RPAD('_', '0', 3-LENGTH(V_RPT_SEQ)) || CAST(V_RPT_SEQ AS VARCHAR2(3 CHAR))

			INSERT INTO DM_MDF_VERSION (;
				DIVISION_ID,VERSION_NO,VERSION_DESCRIPTION,VERSION_TYPE,SEND_YN,YYYYMMDD,VER_CRE_SEQ,ORI_VERSION_NO, ORI_CUTOFF_VERSION_NO, MV_PLAN_YYYYMM
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
			SELECT p_division_id, V_NEW_VERSION_NO AS VERSION_NO,p_version_description
				, 'REPORT_' ||  (CASE WHEN VERSION_TYPE = 'SP_M' THEN 'SP_W' ELSE VERSION_TYPE END) AS VERSION_TYPE -- [C20201014-000098] VERSION_TYPE이 SP_M인 경우 SP_W로 변경
				,'', YYYYMMDD, V_RPT_SEQ AS VER_CRE_SEQ, VERSION_NO AS ORI_VERSION_NO, VERSION_NO AS ORI_CUTOFF_VERSION_NO, p_mv_plan_yyyymm
				,p_created_by,SYSDATE,p_created_by,SYSDATE,'CR' AS ATTRIBUTE1,NULL,NULL,NULL,NULL
			FROM DM_MST_VERSION  WHERE 1=1
				AND DIVISION_ID = p_division_id
				AND VERSION_NO  = p_version_no;

			--PJ20200138 환율 정보 copy
			--
			IF V_SP_BP = 'SP'
			BEGIN
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C (;
					DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, V_NEW_VERSION_NO as VERSION_NO
				     , 'REPORT_'  ||  (CASE WHEN CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
				     , CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, p_created_by,SYSDATE
					 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_MST_EXCHANGE_RATE_C
				WHERE  DIVISION_ID = p_division_id
				AND VERSION_NO = p_version_no;
				--AND    VERSION_NO  = c_ER_version -- PJ202001380 Exchange Rate Version_No 구분
			END
			ELSE
			BEGIN
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C
					( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, V_NEW_VERSION_NO as VERSION_NO
				     , 'REPORT_'  ||   CUTOFF_TYPE AS CUTOFF_TYPE
					 , CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, p_created_by,SYSDATE
					 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_BP_EXCHANGE_RATE_C
				WHERE  DIVISION_ID = p_division_id
				AND VERSION_NO = p_version_no;
				--AND    VERSION_NO  = c_ER_version -- PJ202001380 Exchange Rate Version_No 구분
			END
		END
		ELSE IF p_action_type IN ( 'CP')
		BEGIN

			SELECT NVL(MAX(VER_CRE_SEQ),0) || 1
  INTO V_RPT_SEQ
			FROM DM_MDF_VERSION
			WHERE DIVISION_ID		= p_division_id
				AND TO_CHAR(CREATION_DATE, 'YYYYMMDD') = V_VERSION_DATE

			-- [C20201014-000098] SP_M추가 ( LIKE '%SP_W' -> LIKE '%SP%' )
			SELECT V_SP_BP		= CASE WHEN VERSION_TYPE LIKE '%SP%' THEN 'SP' ELSE 'BP' END
			FROM DM_MDF_VERSION
			WHERE DIVISION_ID = p_division_id
				AND VERSION_NO = P_VERSION_NO;

			-- 최종 버전 셋팅
			V_NEW_VERSION_NO := CASE WHEN ISDATE(p_mv_plan_yyyymm  ||  '01') > 0 THEN 'RP_' ELSE 'R_' END
					 ||  SUBSTR(V_SP_BP, 1, 1)
					 ||  '_'
					 ||  V_VERSION_DATE
					 ||  '_V'
					 ||  RPAD('_', '0', 3-LENGTH(V_RPT_SEQ)) || CAST(V_RPT_SEQ AS VARCHAR2(3 CHAR))
					 ||  '_C'
			INSERT INTO DM_MDF_VERSION
				(DIVISION_ID,VERSION_NO,VERSION_DESCRIPTION,VERSION_TYPE,SEND_YN,YYYYMMDD,VER_CRE_SEQ,ORI_VERSION_NO,ORI_CUTOFF_VERSION_NO, ETC_RESULT_MONTH, MV_PLAN_YYYYMM
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
			SELECT p_division_id,V_NEW_VERSION_NO AS VERSION_NO,p_version_description, VERSION_TYPE AS VERSION_TYPE, '', YYYYMMDD
				  ,V_RPT_SEQ, P_VERSION_NO, ORI_CUTOFF_VERSION_NO, V_ETC_RESULT_MONTH, p_mv_plan_yyyymm
				  ,p_created_by,SYSDATE,p_created_by,SYSDATE,'CP' AS ATTRIBUTE1, p_result_date AS ATTRIBUTE2, NULL, NULL, NULL
			FROM DM_MDF_VERSION  WHERE 1=1
				AND DIVISION_ID = p_division_id
				AND VERSION_NO  = P_VERSION_NO;

			--PJ20200138 환율 정보 copy
			IF V_SP_BP = 'SP'
			BEGIN
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C
					( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, V_NEW_VERSION_NO as VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, p_created_by,SYSDATE
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_PLN_SALES_REPORT_EXCHANGE_C
				WHERE  DIVISION_ID = p_division_id
				AND    VERSION_NO  = p_version_no;

			END
			ELSE
			BEGIN
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C
					( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, V_NEW_VERSION_NO as VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, p_created_by,SYSDATE
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_PLN_SALES_REPORT_EXCHANGE_C
				WHERE  DIVISION_ID = p_division_id
				AND    VERSION_NO  = p_version_no;
			END

		END
		ELSE	-- 삭제일 경우
		BEGIN
			UPDATE DM_MDF_VERSION
			SET SEND_YN = 'D'
			WHERE DIVISION_ID = p_division_id
				AND VERSION_NO = p_version_no;

			DELETE
			FROM DM_PLN_SALES_PLAN_REPORT_C
			WHERE DIVISION_ID = p_division_id
				AND VERSION_NO = p_version_no;

			DELETE
			FROM DM_PLN_BP_FCST_REPORT_C
			WHERE DIVISION_ID = p_division_id
				AND VERSION_NO = p_version_no;

			--PJ20200138 환율 정보 Delete
			DELETE FROM DM_PLN_SALES_REPORT_EXCHANGE_C
			WHERE  DIVISION_ID = p_division_id
			AND    VERSION_NO  = p_version_no;
		END

		INSERT INTO GT_DMF0_MEASURE ( PLAN_RESULT, I_MEASURE, O_MEASURE, CALC_YN, QTY_AMT, SRC_TABLE )
		SELECT SEGMENT3, SEGMENT4, SEGMENT5
			, CASE WHEN SEGMENT4 <> SEGMENT5 AND ATTRIBUTE2 IS NOT NULL THEN 'Y' ELSE '' END, ATTRIBUTE2, ATTRIBUTE1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		WHERE LOOKUP_TYPE = 'DM_SALES_REPORT_' || p_action_type
			AND SEGMENT1 = P_DIVISION_ID
			AND SEGMENT2 = V_SP_BP;

	--SELECT P_DIVISION_ID , P_ACTION_TYPE, V_SP_BP

--SELECT 'X', 0
		-- --------------------------------------------------------------------------------------------------
		--                                                                        요청VERSION COPY (BEGIN)
		-- --------------------------------------------------------------------------------------------------
		IF p_action_type IN ( 'CR', 'CP' )
		BEGIN

			IF p_action_type = 'CR'
			BEGIN

				-- [C20210315-000347]
				SELECT VERSION_TYPE,
    YYYYMMDD
  INTO v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD
				FROM DM_MDF_VERSION
				WHERE DIVISION_ID = p_division_id
					AND VERSION_NO = V_NEW_VERSION_NO;

				/* 20190916, SCM_SITE_ID 가 NULL 인 데이터는 제외한다. */
				IF V_SP_BP = 'SP' THEN
					INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
							,DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							,CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.DIVISION_ID, A.VERSION_NO
					        , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
							, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, SUM(A.QTY) AS QTY
							, B.SALES_COMPANY AS COMPANY_ID
							, B.ATTRIBUTE1
							--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE
					FROM DM_PLN_SALES_PLAN_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
					WHERE	A.VERSION_NO = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD >= d_Result_Date -- 미래구간
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
						AND A.FCST_TYPE <> 'ETC'--[PJ2024-50611] Sales Report 생성 시 ETC 제외
						--마이그레이션 된 데이터 지우면 조건삭제
						AND A.MEASURE NOT IN
						(
							SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
							AND VALID_YN = 'Y'
						)
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
						, B.SALES_COMPANY, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
					--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 START
					UNION ALL
					SELECT A.DIVISION_ID, A.VERSION_NO
					        , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
							, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, SUM(A.QTY) AS QTY
							, B.SALES_COMPANY AS COMPANY_ID
							, B.ATTRIBUTE1
							--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, '-' AS CELL_PROD_SITE
					FROM DM_PLN_SALES_ETC_PLAN_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
					WHERE	A.VERSION_NO = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD >= d_Result_Date -- 미래구간
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
						AND A.FCST_TYPE <> 'ETC'--[PJ2024-50611] Sales Report 생성 시 ETC 제외
						AND A.MEASURE IN
						(
							SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
							AND VALID_YN = 'Y'
						)
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
						, B.SALES_COMPANY, B.ATTRIBUTE1
					--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 END
					-- ------
					UNION ALL
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						 , CASE WHEN( NVL(A.CURRENCY, NULL) = '-' ) THEN ''   -- [C20210315-000347]
														ELSE NVL(A.CURRENCY, NULL) END
														AS CURRENCY

						 , M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
						 , A.COMPANY_ID
						 , B.ATTRIBUTE1
						 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						 --, '-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_SALES_PLAN_RESULT_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'RESULT' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_SALES_PLAN_RESULT_C'
					WHERE	A.VERSION_NO = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID
						, A.COMPANY_ID, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					-- ------
					UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS Measure ,A.PLANT_SITE_ID, A.YYYYMMDD
						 , SUM(CASE	WHEN NVL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
										ELSE A.QTY/NVL(FP.EXCHANGE_PRICE,0)
										END) AS QTY
						 , A.COMPANY_ID, B.ATTRIBUTE1
						 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_SALES_PLAN_RESULT_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP
							 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTR(A.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD'  AND FP.VERSION_NO = V_NEW_VERSION_NO
					WHERE	A.VERSION_NO = p_version_no
						AND A.MEASURE IN ('SalesAmt_KRW')
						AND A.CURRENCY <> 'USD'
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					-- ------
					UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다. ( LOC = USD 인 경우 )
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS Measure ,A.PLANT_SITE_ID, A.YYYYMMDD
						 ,SUM(A.QTY) AS QTY
						, A.COMPANY_ID, B.ATTRIBUTE1
						--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						--,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_SALES_PLAN_RESULT_C A
					JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					WHERE	A.VERSION_NO = p_version_no
						AND A.MEASURE IN ('SalesAmt_LOC')
						AND A.CURRENCY = 'USD'
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					--Start [C20201014-000094] 82 사업부 비물동 구분코드 추가
					-- ------
					UNION ALL
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					        , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
							, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, SUM(A.QTY) AS QTY
							, B.SALES_COMPANY AS COMPANY_ID
							, B.ATTRIBUTE1
							--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
					FROM DM_PLN_SALES_PLAN_C A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
					WHERE	A.VERSION_NO  = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD   >= d_Result_Date -- 미래구간
						AND D.COMPANY_ID IS NULL
						AND A.DIVISION_ID = '82'
						AND NVL(A.QTY,0) <> 0
						AND A.FCST_TYPE <> 'ETC'--[PJ2024-50611] Sales Report 생성 시 ETC 제외
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, B.SALES_COMPANY
						, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
					-- ------
					UNION ALL
					-- ------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , 'REPORT_' || (CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
						 , A.COMPANY_ID, B.ATTRIBUTE1
						 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_SALES_PLAN_RESULT_C A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'RESULT' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_SALES_PLAN_RESULT_C'
					WHERE	A.VERSION_NO  = p_version_no
						AND A.DIVISION_ID = p_division_id
						AND A.YYYYMMDD    < d_Result_Date   -- 과거실적구간으로 추출
						--AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
						AND A.DIVISION_ID = '82'
						AND NVL(A.QTY,0) <> 0
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID
						, A.COMPANY_ID, B.ATTRIBUTE1
						, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					--End [C20201014-000094] 82 사업부 비물동 구분코드 추가

					-- 소형 처리( 무상건 제외 )
					-- [C20210315-000140]
					IF p_division_id = '40' THEN
						DELETE A
						FROM GT_DMF0_VERSION_COPY A
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.FCST_TYPE = B.SEGMENT1 AND B.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND SEGMENT4 = 'FREE'
					END IF;

					-- RTF_SCP 처리
					IF p_division_id like '81%' THEN
						INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
								, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							    , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DIVISION_ID, A.VERSION_NO, 'REPORT_SP_W' as Cutoff_Type, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
								, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, '' AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								, SUM(A.QTY) AS QTY
								, E.COMPANY_ID AS COMPANY_ID, B.ATTRIBUTE1
								--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
								--, '-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
								, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_MKT_FCST_RESULT_C A
						JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_MKT_FCST_RESULT_C'
						WHERE	A.VERSION_NO = 'MF_'  ||  SUBSTR(p_version_no,4,15)
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
							AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, E.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					END IF;
					-- [C20210315-000347]
					IF p_division_id = '40' THEN


						V_VERSION_NO_VMI := 'MF_W_'  ||  TO_CHAR(FN_NEXT_DAY( TO_DATE(SUBSTR(p_version_no,6,8)), 'MON')  ||  (-6), 'YYYYMMDD')  -- 당주 월요일 이후인건만 추출
												 ||  '_V001'

						INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
							, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DIVISION_ID, A.VERSION_NO
								, v_cp_CUTOFF_TYPE  , v_cp_CUTOFF_YYYYMMDD --	, 'REPORT_SP_W' as Cutoff_Type , A.CUTOFF_YYYYMMDD
								, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
								, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, '' AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								, SUM(A.QTY) AS QTY
								,'' AS COMPANY_ID  --, E.COMPANY_ID AS COMPANY_ID
								, B.ATTRIBUTE1
								--, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
								, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE
						--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						--FROM DM_PLN_MKT_FCST_C A
						FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
						JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_MKT_FCST_C'
						WHERE	A.VERSION_NO = V_VERSION_NO_VMI
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD >= d_Result_Date   -- 미래구간
							AND MEASURE IN ('VMI_In_Plan', 'VMI_In_Req')
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, E.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경

						-- MKT FCST 테이블에서 데이터를 가져오면 Currency 및 Company_id 가 없어서 업데이트 해준다.
						-- 여기에서 하고 최종 INSERT INTO 전에 한 번 더 해준다.
						UPDATE A
						SET CURRENCY = B.CURRENCY
						FROM GT_DMF0_VERSION_COPY A
						JOIN ( SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
									, MAX(CURRENCY) AS CURRENCY
								FROM DM_PLN_SALES_PLAN_C A
								WHERE A.VERSION_NO = p_version_no
									AND A.DIVISION_ID = p_division_id
									AND A.YYYYMMDD >= d_Result_Date -- 미래구간
								GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, SUBSTR(YYYYMMDD, 1, 6)
							) B ON A.PROJECT_CODE = B.PROJECT_CODE
								AND A.SCM_SITE_ID	= B.SCM_SITE_ID
								AND A.ITEM_ID		= B.ITEM_ID
								AND A.DOM_EXP		= B.DOM_EXP
								AND A.FCST_TYPE		= B.FCST_TYPE
								AND A.INCOTERMS		= B.INCOTERMS
								AND SUBSTR(A.YYYYMMDD, 1, 6)	= B.YYYYMM
						WHERE A.MEASURE IN ('VMI_In_Plan', 'VMI_In_Req')
							AND NVL(A.CURRENCY, NULL) IS NULL;

						UPDATE A
						SET CURRENCY = B.CURRENCY
						FROM GT_DMF0_VERSION_COPY A
						JOIN ( SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
									, MAX(CURRENCY) AS CURRENCY
								FROM DM_PLN_SALES_PLAN_C A
								WHERE A.VERSION_NO = p_version_no
									AND A.DIVISION_ID = p_division_id
									AND A.YYYYMMDD >= d_Result_Date -- 미래구간
								GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
							) B ON A.PROJECT_CODE = B.PROJECT_CODE
								AND A.SCM_SITE_ID	= B.SCM_SITE_ID
								AND A.ITEM_ID		= B.ITEM_ID
								AND A.DOM_EXP		= B.DOM_EXP
								AND A.FCST_TYPE		= B.FCST_TYPE
								AND A.INCOTERMS		= B.INCOTERMS
						WHERE A.MEASURE IN ('VMI_In_Plan', 'VMI_In_Req')
							AND NVL(A.CURRENCY, NULL) IS NULL;

						UPDATE A
						SET COMPANY_ID = B.SALES_COMPANY
						FROM GT_DMF0_VERSION_COPY A
						JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					END IF;
				ELSE
					INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
						, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER
							, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.DIVISION_ID, A.VERSION_NO
					    , 'REPORT_' ||  A.CUTOFF_TYPE AS CUTOFF_TYPE
						, A.CUTOFF_YYYYMMDD
						, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, '' AS INCOTERMS, A.CURRENCY, A.MEASURE,A.PLANT_SITE_ID
						, A.YYYYMM  ||  '01', SUM(A.QTY) AS QTY
						, NVL(B.SALES_COMPANY, NULL) AS COMPANY_ID
						, B.ATTRIBUTE1
						, CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID ELSE NULL END AS DEPT_ID
						, NVL(A.ITEM_USE, NULL) AS ITEM_USE, NVL(A.END_CUSTOMER, NULL) AS END_CUSTOMER
						, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_BP_FCST_C A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_MST_SITE C  ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					JOIN ( SELECT DISTINCT I_MEASURE FROM GT_DMF0_MEASURE ) M ON A.MEASURE = M.I_MEASURE
					WHERE A.VERSION_NO = p_version_no
					--AND MEASURE IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'Business_Plan','CAR_QTY')
					AND A.DIVISION_ID = p_division_id
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID
						, A.YYYYMM, B.ATTRIBUTE1
						--[C20201125-000012] COMPANY_ID 변경(Site -> Sales Site Project Model)
						--, NVL(C.COMPANY_ID, NULL)
						, NVL(B.SALES_COMPANY, NULL)
						, CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID ELSE NULL END
						, NVL(A.ITEM_USE, NULL), NVL(A.END_CUSTOMER, NULL), A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				END IF;
			ELSIF p_action_type = 'CP' THEN
				SELECT VERSION_TYPE,
    YYYYMMDD
  INTO v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD
				FROM DM_MDF_VERSION
				WHERE VERSION_NO = p_version_no

				SELECT  v_cp_VERSION_NO		= A.VERSION_NO
						, v_cp_MIN_YYYYMMDD	= MIN(A.YYYYMMDD)
				FROM DM_PLN_SALES_PLAN_REPORT_C A
				WHERE	A.VERSION_NO = p_version_no
					and A.Cutoff_type = v_cp_CUTOFF_TYPE
					and A.Data_type = '1'
				GROUP BY A.VERSION_NO

				-- 실적 불러오기 처리시, 실적의 시작일자를 CUTOFF 일자를 기준으로 룩업에 세팅된 개월수만큼 전으로 가서 가져온다.

				SELECT V_MON_CNT  = CAST(SEGMENT3 AS INTEGER)
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
				WHERE LOOKUP_TYPE = 'DMF0044_CONFIG'
					AND SEGMENT1 = P_DIVISION_ID
					AND SEGMENT2 = 'RESULT_START_PERIOD';

				v_cp_MIN_YYYYMMDD := TO_CHAR(ADD_MONTHS(v_cp_CUTOFF_YYYYMMDD, V_MON_CNT * -1), 'YYYYMMDD');
				-- ----------------------------------------------------------------------------------------------------
				BEGIN
					-- 실적불러오기 선택을 하지 않은 순수한 복사시에만 기존 마스터 그대로 유지가 가능함. 아니면 항상 마스터 최신화 적용됨
					IF ( P_UPDATE_YN <> 'Y' AND d_Result_Date IS NULL) THEN
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
							 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
							 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
							 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
							 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
							 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
							 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
							 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
							 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
							 -- 2021.7.23
							 , SOLDTO_CUST_REPORT
							 , OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
							 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
							 , APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
							 , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DATA_TYPE, A.DIVISION_ID, V_NEW_VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
							 , A.YYYYMMDD, A.CURRENCY, A.QTY, p_created_by, SYSDATE
							 , p_created_by, SYSDATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
							 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
							 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
							 , A.SOLDTO_CUST_REPORT
							 , A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
							 , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION
							 , A.APPLICATION_GR, A.COUNTRY_KR_NAME, A.ROUTE
							 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM   DM_PLN_SALES_PLAN_REPORT_C A
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
						WHERE A.VERSION_NO = p_version_no
							AND A.DATA_TYPE = '1'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD > d_Result_Date; -- 미래구간
					ELSE
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
							 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
							 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
							 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
							 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
							 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
							 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
							 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
							 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
							 -- 2021.7.23
							 , SOLDTO_CUST_REPORT
							 , OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
							 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
							 , APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
							 , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DATA_TYPE, A.DIVISION_ID, V_NEW_VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , CASE WHEN LK1.SEGMENT1 IS NULL  THEN v_ETC_DEPARTMENT_ID ELSE A.DEPARTMENT_ID END AS DEPARTMENT_ID
							 , CASE WHEN LK1.SEGMENT1 IS NULL  THEN v_ETC_DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
							 , A.DEPT_ID, LK2.SEGMENT2 AS DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
							 , A.YYYYMMDD, A.CURRENCY, A.QTY, p_created_by, SYSDATE
							 , p_created_by, SYSDATE
							 , CASE WHEN NVL(B.REPORT_GROUP4, NULL) IS NOT NULL THEN NVL(B.REPORT_GROUP4, NULL) ELSE NVL(B.REPORT_GROUP5, NULL) END
							 , A.ATTRIBUTE2, A.ATTRIBUTE3
							 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
							 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
							 , B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
							 , FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' )                AS OWNER_NAME
							 , B.CUST_GROUP_DTL
							 , CASE WHEN NVL(B.REPORT_GROUP4, NULL) IS NOT NULL THEN NVL(B.REPORT_GROUP4, NULL) ELSE NVL(B.REPORT_GROUP5, NULL) END AS PRODUCT_DETAILS
							 , C.FORECAST_INFO_SPEC, C.NICK_NAME
							 , B.REPORT_GROUP6 AS FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE
							 , D.SEGMENT2, B.APPLICATION, B.REPORT_GROUP1 AS APPLICATION_GR, F.COUNTRY_KR_NAME, B.ROUTE
							 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM   DM_PLN_SALES_PLAN_REPORT_C A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
						LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
						LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
						LEFT OUTER JOIN SCM_MST_COUNTRY F ON E.COUNTRY = F.COUNTRY
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = ''
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 (NOLOCK) ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'
													 ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK1.VALID_YN = 'Y' AND LK1.SEGMENT3 = 'Y'
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 (NOLOCK) ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
													 ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK2.VALID_YN = 'Y'
						WHERE A.VERSION_NO = p_version_no
							AND A.DATA_TYPE = '1'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD > d_Result_Date; -- 미래구간

					END IF;
					-- --------
					--UNION ALL -- 여기부터는 실적구간
					-- --------
					BEGIN

						INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
								, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
								, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'RESULT' AND M.CALC_YN = ''
						WHERE	A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD <= d_Result_Date   -- 과거실적구간으로 추출
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						-- ------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(CASE	WHEN NVL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
										ELSE A.QTY/NVL(FP.EXCHANGE_PRICE,0)
										END) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP
								 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTR(A.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD' AND FP.VERSION_NO = V_NEW_VERSION_NO
						WHERE	A.MEASURE = 'SalesAmt_KRW'
							AND A.CURRENCY <> 'USD'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD <= d_Result_Date   -- 과거실적구간으로 추출
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						-- ------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.	( LOC = USD )
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(A.QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						WHERE	A.MEASURE = 'SalesAmt_LOC'
							AND A.CURRENCY = 'USD'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD <= d_Result_Date   -- 과거실적구간으로 추출
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						--Start [C20201014-000094] 82 사업부 비물동 구분코드 추가
						-- ------
						UNION ALL
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'RESULT' AND M.CALC_YN = ''
						WHERE	A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD   <= d_Result_Date   -- 과거실적구간으로 추출
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD   >= v_cp_MIN_YYYYMMDD
							AND D.COMPANY_ID IS NULL
							AND A.DIVISION_ID = '82'
							AND NVL(A.QTY,0) <> 0
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						-- ------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(CASE	WHEN NVL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
										ELSE A.QTY/NVL(FP.EXCHANGE_PRICE,0)
										END) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP
								 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTR(A.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD' AND FP.VERSION_NO = V_NEW_VERSION_NO
						WHERE	A.MEASURE = 'SalesAmt_KRW'
							AND A.CURRENCY <> 'USD'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD   <= d_Result_Date
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD   >= v_cp_MIN_YYYYMMDD
							AND D.COMPANY_ID IS NULL
							AND A.DIVISION_ID = '82'
							AND NVL(A.QTY,0) <> 0
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						-- ------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다. ( LOC = USD )
						-- ------
						SELECT A.DIVISION_ID, v_cp_VERSION_NO, v_cp_CUTOFF_TYPE, v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL) AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(A.QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							 --,'-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						FROM DM_PLN_SALES_PLAN_RESULT A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
						LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP
								 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTR(A.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD' AND FP.VERSION_NO = V_NEW_VERSION_NO
						WHERE	A.MEASURE = 'SalesAmt_LOC'
							AND A.CURRENCY = 'USD'
							AND A.DIVISION_ID = p_division_id
							AND A.YYYYMMDD   <= d_Result_Date
							AND NVL(d_Result_Date, NULL) IS NOT NULL
							AND A.YYYYMMDD   >= v_cp_MIN_YYYYMMDD
							--AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
							AND A.DIVISION_ID = '82'
							AND NVL(A.QTY,0) <> 0
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, NULL),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
							, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						--End [C20201014-000094] 82 사업부 비물동 구분코드 추가

						-- RTF_SCP 처리
						IF p_division_id like '81%' THEN
							INSERT INTO GT_DMF0_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
									  , DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
									  , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
							SELECT A.DIVISION_ID, A.VERSION_NO, 'REPORT_SP_W' as Cutoff_Type, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
								 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, '' AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								 , SUM(A.QTY) AS QTY
								 , B.SALES_COMPANY AS COMPANY_ID
								 , B.ATTRIBUTE1
								 --, '' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
								 --, '-' AS CELL_PROD_SITE --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
								, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
							FROM DM_PLN_MKT_FCST_RESULT_C A
							JOIN SCM_MST_SITE_ITEM B  ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
							LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C  ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
							LEFT OUTER JOIN SCM_MST_COMPANY_SN D  ON A.SCM_SITE_ID = D.COMPANY_ID
							JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
							JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'PLAN' AND M.CALC_YN = '' AND M.SRC_TABLE = 'DM_PLN_MKT_FCST_RESULT_C'
							WHERE	A.VERSION_NO = 'MF_'  ||  SUBSTR(p_version_no,4,15)
								AND A.DIVISION_ID = p_division_id
								AND A.YYYYMMDD < d_Result_Date   -- 과거실적구간으로 추출
								AND NVL(d_Result_Date, NULL) IS NOT NULL
								AND A.YYYYMMDD >= v_cp_MIN_YYYYMMDD
								AND C.LOOKUP_TYPE IS NULL
								AND D.COMPANY_ID IS NULL
							GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
								, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								, B.SALES_COMPANY
								, B.ATTRIBUTE1
								, A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						END IF;
					END;

				END;

			END IF;

			-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- DIV 별로 키값에 맞춰서 묶어준다. ( YYYYMMDD 때문에 단순 MAX 처리로는 안되고, 키값전체를 이용해서 정리해줘야 한다. )
			-- Scm_site_id 와 Project Code 를 뭉친다.
			-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF P_DIVISION_ID = '40' THEN

				-- [PJ2024-50611] 소형 매출 프로세스 개선
				IF (p_action_type IN ('CR') AND V_SP_BP = 'SP') THEN
				/*
					/* TODO:GTT:GT_DMF0_VERSION_COPY_RTF_ALLOC-->GT_DMF0_VERSION_COPY_RTF_ALLOC */
					INSERT INTO GT_DMF0_VERSION_COPY_RTF_ALLOC
					SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
						 , COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
					FROM GT_DMF0_VERSION_COPY
					WHERE DIVISION_ID = P_DIVISION_ID
					AND   MEASURE IN ('RTF_SYS_RP','VMI_In_Plan','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

					/* TODO:GTT:GT_DMF0_VERSION_COPY_RTF_ALLOC-->GT_DMF0_VERSION_COPY_RTF_ALLOC */
					INSERT INTO GT_DMF0_VERSION_COPY_RTF_ALLOC
					SELECT   DISTINCT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
							,DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							,DEPT_ID,ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
					FROM GT_DMF0_VERSION_COPY_RTF_ALLOC;

					DELETE GT_DMF0_VERSION_COPY
					WHERE DIVISION_ID	= P_DIVISION_ID
					AND   YYYYMMDD		> d_Result_Date
					AND   MEASURE IN ('RTF_SYS_RP','VMI_In_Plan','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

					INSERT INTO GT_DMF0_VERSION_COPY
					(
						   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
						 , COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
					)
					SELECT A.DIVISION_ID, A.VERSION_NO,A.CUTOFF_TYPE,A.CUTOFF_YYYYMMDD,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID
							,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.CURRENCY,A.MEASURE
							,B.PLANT_SITE_ID
							,B.YYYYMMDD
							,B.QTY, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							,A.DEPT_ID,A.ITEM_USE, A.END_CUSTOMER
							--, B.FROM_SITE_ID AS CELL_PROD_SITE
							,B.CELL_PROD_SITE_ID AS CELL_PROD_SITE
					FROM GT_DMF0_VERSION_COPY_RTF_ALLOC A
					--INNER JOIN DM_PLN_RTF_ALLOCATION_C B
					--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
					 INNER JOIN DM_PLN_SALES_PLAN_C B
					ON	A.DIVISION_ID   = B.DIVISION_ID
					AND A.PROJECT_CODE  = B.PROJECT_CODE
					AND A.SCM_SITE_ID   = B.SCM_SITE_ID
					AND A.ITEM_ID       = B.ITEM_ID
					AND A.DOM_EXP       = B.DOM_EXP
					AND A.FCST_TYPE     = B.FCST_TYPE
					AND A.INCOTERMS     = B.INCOTERMS
					AND A.MEASURE		= B.MEASURE
					AND A.YYYYMMDD		= B.YYYYMMDD
					WHERE A.DIVISION_ID = P_DIVISION_ID
					AND   A.YYYYMMDD	> d_Result_Date
					AND   B.MEASURE IN ('RTF_SYS_RP','VMI_In_Plan','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
					AND   B.VERSION_NO = p_version_no
					AND   B.CUTOFF_TYPE	= v_version_type;
					*/
					--[PJ2024-50611] Sales Report 생성 시 Catcu_Up 수량 더해줌 START
					MERGE INTO GT_DMF0_VERSION_COPY AS A;
							USING GT_DMF0_PLAN_C_CATCHUP AS B
							ON   (  A.DIVISION_ID = B.DIVISION_ID
								AND A.VERSION_NO = B.VERSION_NO
								AND A.CUTOFF_TYPE= B.CUTOFF_TYPE
								AND A.CUTOFF_YYYYMMDD= B.CUTOFF_YYYYMMDD
								AND A.PROJECT_CODE = B.PROJECT_CODE
								AND A.SCM_SITE_ID = B.SCM_SITE_ID
								AND A.ITEM_ID = B.ITEM_ID
								AND A.DOM_EXP = B.DOM_EXP
								AND A.FCST_TYPE= B.FCST_TYPE
								AND A.INCOTERMS = B.INCOTERMS
								AND A.CURRENCY = B.CURRENCY
								AND A.MEASURE = B.MEASURE
								AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
								AND A.YYYYMMDD = B.YYYYMMDD
								AND A.COMPANY_ID = B.COMPANY_ID
								AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
								AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
								)
							WHEN MATCHED THEN
								UPDATE SET;
									A.QTY = A.QTY  ||  B.QTY
							WHEN NOT MATCHED THEN
								INSERT
								(
								   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
								 , DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
								 , COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
									)
								VALUES
								(
									B.DIVISION_ID
									,B.VERSION_NO
									,B.CUTOFF_TYPE
									,B.CUTOFF_YYYYMMDD
									,B.PROJECT_CODE
									,B.SCM_SITE_ID
									,B.ITEM_ID
									,B.DOM_EXP
									,B.FCST_TYPE
									,B.INCOTERMS
									,B.CURRENCY
									,B.MEASURE
									,B.PLANT_SITE_ID
									,B.YYYYMMDD
									,B.QTY
									,B.COMPANY_ID
									,B.SOLDTO_CUST_REPORT
									,'','',''
									,B.CELL_PROD_SITE
								);
						--[PJ2024-50611] Sales Report 생성 시 Catcu_Up 수량 더해줌 END
				END IF;

				-- 월별로 하나의 날짜로 변환시킴
				UPDATE GT_DMF0_VERSION_COPY
				SET YYYYMMDD = SUBSTR(YYYYMMDD, 1, 6)  ||  '01'


				-- VMI 의 경우 통화가 빠진 데이터가 있어서 여기서 업데이트 해준다.
				UPDATE A
				SET CURRENCY = B.CURRENCY
				FROM GT_DMF0_VERSION_COPY A
				JOIN ( SELECT PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY, COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, END_CUSTOMER
						FROM GT_DMF0_VERSION_COPY
						WHERE NVL(CURRENCY, NULL) IS NOT NULL
						GROUP BY PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY, COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, END_CUSTOMER
					) B ON		A.PROJECT_CODE			= B.PROJECT_CODE
							AND A.SCM_SITE_ID			= B.SCM_SITE_ID
							AND A.ITEM_ID				= B.ITEM_ID
							AND A.DOM_EXP				= B.DOM_EXP
							AND A.FCST_TYPE				= B.FCST_TYPE
							AND A.INCOTERMS				= B.INCOTERMS
							AND A.COMPANY_ID			= B.COMPANY_ID
							AND NVL(A.SOLDTO_CUST_REPORT, NULL)	= NVL(B.SOLDTO_CUST_REPORT, NULL)
							AND A.DEPT_ID				= B.DEPT_ID
							AND NVL(A.END_CUSTOMER, NULL)		= NVL(B.END_CUSTOMER, NULL)
				WHERE NVL(A.CURRENCY, NULL) IS NULL;

				UPDATE A
				SET CURRENCY = B.CURRENCY
				FROM GT_DMF0_VERSION_COPY A
				JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, MAX(CURRENCY) AS CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS
						--FROM SCM_MST_FUTURE_PRICE A
						--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
						FROM DM_PLN_CFM_SELLING_PRICE A
						WHERE YYYYMMDD > d_Result_Date
							AND A.DIVISION_ID = P_DIVISION_ID
						GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					) B ON		A.DIVISION_ID			= B.DIVISION_ID
							AND	A.PROJECT_CODE			= B.PROJECT_CODE
							AND A.SCM_SITE_ID			= B.SCM_SITE_ID
							AND A.ITEM_ID				= B.ITEM_ID
							AND A.DOM_EXP				= B.DOM_EXP
							AND A.FCST_TYPE				= B.FCST_TYPE
							AND A.INCOTERMS				= B.INCOTERMS
				WHERE NVL(A.CURRENCY, NULL) IS NULL;

				INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
						  , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
						  , CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
						  , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
						  , PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, COMPANY_ID, ATTRIBUTE1, SOLDTO_CUST_REPORT
						  , APPLICATION, CUST_GROUP_DTL, COUNTRY
						  , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						, D.UPPER_DEPT_ID AS DEPARTMENT_ID, E.SEGMENT2 AS DEPARTMENT_NAME
						, D.DEPT_ID AS DEPT_ID, F.SEGMENT2 AS DEPT_NAME
						, NVL(B.report_group2, NULL)	AS CUST_REPORT    -- (DMS)판매처
						, NVL(B.attribute2, NULL)	AS END_CUST_REPORT  -- (DMS)고객군
						, NVL(B.report_group3, NULL)	AS PRODUCT_GROUP
						, B.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
						, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY
						--[C20210304-000196] 소형 부자재 및 전극 매출 수량 표기(biz_type is null 제외)
						/*, CASE WHEN V.FORECAST_INFO_BIZ_TYPE IS NULL AND ( A.MEASURE LIKE '%RTF%' OR A.MEASURE LIKE '%MKT_FCST%' ) THEN 0
								ELSE A.QTY END AS QTY*/
						, A.QTY AS QTY
						, NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
						, CASE WHEN NVL(B.report_group4, NULL) IS NOT NULL THEN NVL(B.report_group4, NULL) ELSE NVL(B.report_group5, NULL) END	AS ATTRIBUTE1
						, NVL(A.SOLDTO_CUST_REPORT, NULL)
						, B.APPLICATION, B.CUST_GROUP_DTL
						, G.COUNTRY
						, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM GT_DMF0_VERSION_COPY A
				JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
				JOIN SCM_MST_SSO_USER_INFO C ON SUBSTR(B.OWNER, 1, CASE WHEN PATINDEX('%,%', B.OWNER) > 0 THEN PATINDEX('%,%', B.OWNER)-1 ELSE LENGTH(B.OWNER) END) = C.USER_ID
				JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND E.VALID_YN = 'Y'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' AND F.VALID_YN = 'Y'
				JOIN SCM_MST_SITE G ON B.DIVISION_ID = G.DIVISION_ID AND B.SCM_SITE_ID = G.SCM_SITE_ID
				LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V V ON A.ITEM_ID = V.ITEM_ID

				-- 1~3 담당 외에는 기타로 묶는다.
				UPDATE A
				SET DEPARTMENT_ID = v_ETC_DEPARTMENT_ID
				FROM GT_DMF0_REPORT A
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' AND VALID_YN = 'Y'
				WHERE B.SEGMENT1 IS NULL;

--SELECT * FROM GT_DMF0_REPORT WHERE MEASURE = 'MKT_FCST'
				-- 인서트
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (;
					  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
					, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
					, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY, COMPANY_ID
					, CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1
					-- 2021.7.23
					, SOLDTO_CUST_REPORT
					, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
					, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
					, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
					, ATTRIBUTE3	-- CELL MODEL
					, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, P_DIVISION_ID AS DIVISION_ID, V_NEW_VERSION_NO AS VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
					 , A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
					 , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
					 , A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.QTY, A.COMPANY_ID
					 , p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE, A.ATTRIBUTE1
					 , B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
					 , FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' ) AS OWNER_NAME
					 , A.CUST_GROUP_DTL
					 , CASE WHEN NVL(B.REPORT_GROUP4, NULL) IS NOT NULL THEN NVL(B.REPORT_GROUP4, NULL) ELSE NVL(B.REPORT_GROUP5, NULL) END AS PRODUCT_DETAILS
					 , C.FORECAST_INFO_SPEC, C.NICK_NAME
					 , B.REPORT_GROUP6 AS FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE
					 , D.SEGMENT2, A.APPLICATION, B.REPORT_GROUP1 AS APPLICATION_GR, F.COUNTRY_KR_NAME, B.ROUTE
					 , B.ATTRIBUTE5 AS CELL_MODEL
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (
					SELECT '1' AS DATA_TYPE, P_DIVISION_ID AS DIVISION_ID, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
							, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.CUST_REPORT
							, A.END_CUST_REPORT, A.PRODUCT_GROUP
							, FN_SCM_SPLIT(A.MIX_VAL, 1, '^') AS PROJECT_CODE
							, FN_SCM_SPLIT(A.MIX_VAL, 2, '^') AS SCM_SITE_ID
							, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
							, A.PLANT_SITE_ID, B.YYYYMMDD, A.CURRENCY, SUM(B.QTY) as QTY, A.COMPANY_ID
							, B.ATTRIBUTE1
							, A.APPLICATION, A.CUST_GROUP_DTL
							, A.COUNTRY
							, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM (
						-- 병합처리를 위해 키 중 병합되지 않은 키만 분리 ( 하지만 SCM_SITE_ID-PROJECT_CODE-ITEM_ID 간의 관계는 유지되어야 함
						--- 그냥 MAX로 조합할 경우 SCM_MST_SITE_ITEM 에 JOIN 이 안됨 )
						SELECT A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
							, A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP, A.ITEM_ID, A.CURRENCY, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							, MAX((NVL(A.PROJECT_CODE, NULL) || '^' || NVL(A.SCM_SITE_ID, NULL))) AS MIX_VAL
							, MAX(A.DOM_EXP) AS DOM_EXP
							, MAX(A.FCST_TYPE) AS FCST_TYPE, MAX(A.INCOTERMS) AS INCOTERMS, MAX(A.PLANT_SITE_ID) AS PLANT_SITE_ID
							, A.APPLICATION, A.CUST_GROUP_DTL, A.COUNTRY
						FROM GT_DMF0_REPORT A
						LEFT OUTER JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
						LEFT OUTER JOIN SCM_MST_COUNTRY C ON B.COUNTRY = C.COUNTRY
						GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
							, A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP, A.ITEM_ID, A.CURRENCY, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							, A.APPLICATION, A.CUST_GROUP_DTL, A.COUNTRY
						) A;
					JOIN GT_DMF0_REPORT B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
							AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
							AND A.DEPT_ID = B.DEPT_ID
							AND A.DEPT_NAME = B.DEPT_NAME
							AND A.CUST_REPORT = B.CUST_REPORT
							AND A.END_CUST_REPORT = B.END_CUST_REPORT
							AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
							AND A.ITEM_ID = B.ITEM_ID
							AND A.CURRENCY = B.CURRENCY
							AND A.COMPANY_ID = B.COMPANY_ID
							AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
							AND A.APPLICATION = B.APPLICATION
							AND A.CUST_GROUP_DTL = B.CUST_GROUP_DTL
							AND A.COUNTRY = B.COUNTRY
					GROUP BY B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
							, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
							, A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP
							, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
							, A.PLANT_SITE_ID, B.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, B.ATTRIBUTE1
							, A.APPLICATION, A.CUST_GROUP_DTL
							, A.MIX_VAL, A.COUNTRY, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					) A;
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
					LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY = F.COUNTRY

			ELSIF P_DIVISION_ID like '81%' THEN
				IF V_SP_BP = 'SP' THEN
					-- 자동차는 팀 없는 건은 전송하지 않음.
					INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							  , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							  , PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							  , INCOTERMS, CURRENCY
							  , MEASURE, YYYYMMDD, QTY
							  , DOM_EXP, COMPANY_ID
							  , CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							  , CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						 , D.UPPER_DEPT_ID AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
						 , D.DEPT_ID AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
						 , NVL(B.PROJECT_CODE, NULL), NVL(A.FCST_TYPE, NULL), NVL(A.PLANT_SITE_ID, NULL), NVL(A.ITEM_ID, NULL), NVL(A.SCM_SITE_ID, NULL)
						 , NVL(A.INCOTERMS, NULL), NVL(A.CURRENCY, NULL)
						 , A.MEASURE, A.YYYYMMDD, A.QTY
						 , NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
						 , ''	AS CUST_REPORT    -- (DMS)판매처
						 , ''	AS END_CUST_REPORT  --
						 , ''	AS PRODUCT_GROUP
						 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
					JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT'  ||  p_division_id
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'  ||  p_division_id
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G ON A.FCST_TYPE = G.SEGMENT1 AND G.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND G.SEGMENT4 <> 'FREE'
				ELSE
					INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							, PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							, INCOTERMS, CURRENCY
							, MEASURE, YYYYMMDD, QTY
							, DOM_EXP, COMPANY_ID
							, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, D.UPPER_DEPT_ID AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
							, D.DEPT_ID AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
							, NVL(A.PROJECT_CODE, NULL), NVL(A.FCST_TYPE, NULL), NVL(A.PLANT_SITE_ID, NULL), NVL(A.ITEM_ID, NULL), NVL(A.SCM_SITE_ID, NULL)
							, NVL(A.INCOTERMS, NULL), NVL(A.CURRENCY, NULL)
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, A.END_CUSTOMER	AS END_CUST_REPORT  --
							, ''	AS PRODUCT_GROUP
						    , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID = D.DEPT_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT'  ||  p_division_id
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'  ||  p_division_id
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G ON A.FCST_TYPE = G.SEGMENT1 AND G.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND G.SEGMENT4 <> 'FREE'
				END IF;
--select * from GT_DMF0_MEASURE
--select measure, count(*) from GT_DMF0_VERSION_COPY group by measure
--select measure, count(*) from GT_DMF0_REPORT group by measure

				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (;
					  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
					, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
					, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY, COMPANY_ID
					, CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT '1' AS DATA_TYPE, P_DIVISION_ID, V_NEW_VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, SUBSTR(B.YYYYMMDD, 1, 6)  ||  '01' AS YYYYMMDD, A.CURRENCY, SUM(B.QTY) as QTY, A.COMPANY_ID
						,'mdf_batch',SYSDATE,'mdf_batch',SYSDATE
						, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (
					-- 병합처리를 위해 키 중 병합되지 않은 키만 분리
					SELECT A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.FCST_TYPE, A.PLANT_SITE_ID, A.ITEM_ID, A.SCM_SITE_ID
						, A.INCOTERMS, A.CURRENCY
						, MAX(A.DOM_EXP) AS DOM_EXP, MAX(A.COMPANY_ID) AS COMPANY_ID
					FROM GT_DMF0_REPORT A
					GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.FCST_TYPE, A.PLANT_SITE_ID, A.ITEM_ID, A.SCM_SITE_ID
						, A.INCOTERMS, A.CURRENCY
					) A;
				JOIN GT_DMF0_REPORT B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
						AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
						AND A.DEPT_ID = B.DEPT_ID
						AND A.DEPT_NAME = B.DEPT_NAME
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.FCST_TYPE = B.FCST_TYPE
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.INCOTERMS = B.INCOTERMS
						AND A.CURRENCY = B.CURRENCY
				GROUP BY B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, SUBSTR(B.YYYYMMDD, 1, 6), A.CURRENCY, A.COMPANY_ID, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청

			ELSIF P_DIVISION_ID = '82' THEN

				IF V_SP_BP = 'SP' THEN
					INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							, PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							, INCOTERMS, CURRENCY
							, MEASURE, YYYYMMDD, QTY
							, DOM_EXP, COMPANY_ID
							, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, D.UPPER_DEPT_ID AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
							, D.DEPT_ID AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
							, NVL(B.PROJECT_CODE, NULL), NVL(A.FCST_TYPE, NULL), NVL(A.PLANT_SITE_ID, NULL), NVL(A.ITEM_ID, NULL), NVL(A.SCM_SITE_ID, NULL)
							, NVL(A.INCOTERMS, NULL), NVL(A.CURRENCY, NULL)
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, ''	AS END_CUST_REPORT  --
							, ''	AS PRODUCT_GROUP
							, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
					JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT_82'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2_82'
				    -- ------
					UNION ALL --[C20201014-000094] 82 사업부 비물동 구분코드 추가
					-- ------
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					        --[C20201014-000094] 82 사업부 비물동 구분코드 추가 (NVL(D.UPPER_DEPT_ID, NULL),  NVL(D.DEPT_ID, NULL))
							, NVL(D.UPPER_DEPT_ID, NULL) AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
							, NVL(D.DEPT_ID, NULL) AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
							, NVL(B.PROJECT_CODE, NULL), NVL(A.FCST_TYPE, NULL), NVL(A.PLANT_SITE_ID, NULL), NVL(A.ITEM_ID, NULL), NVL(A.SCM_SITE_ID, NULL)
							, NVL(A.INCOTERMS, NULL), NVL(A.CURRENCY, NULL)
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, ''	AS END_CUST_REPORT  --
							, ''	AS PRODUCT_GROUP
							, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					--[C20201014-000094] 82 사업부 비물동 구분코드 추가 (JOIN -> LEFT OUTER JOIN)
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT_82'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2_82'
					--[C20201014-000094] 82 사업부 비물동 구분코드 추가
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G  ON A.ITEM_ID = G.SEGMENT1 AND A.DIVISION_ID = G.SEGMENT3 AND G.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
					WHERE A.DIVISION_ID = '82';
				ELSE
					INSERT INTO GT_DMF0_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							, PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							, INCOTERMS, CURRENCY
							, MEASURE, YYYYMMDD, QTY
							, DOM_EXP, COMPANY_ID
							, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, D.UPPER_DEPT_ID AS DEPARTMENT_ID, NVL(E.SEGMENT2, NULL) AS DEPARTMENT_NAME
							, D.DEPT_ID AS DEPT_ID, NVL(F.SEGMENT2, NULL) AS DEPT_NAME
							, A.ITEM_USE AS PROJECT_CODE, '' AS FCST_TYPE, '' AS PLANT_SITE_ID, '' AS ITEM_ID, '' AS SCM_SITE_ID
							, '' AS INCOTERMS, NVL(A.CURRENCY, NULL)
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, NVL(A.DOM_EXP, NULL), NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, ''	AS END_CUST_REPORT  --
							, ''	AS PRODUCT_GROUP
							, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM GT_DMF0_VERSION_COPY A
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID = D.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = 'MDF_DEPARTMENT_82'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2_82'

				END IF;

				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (;
					  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
					, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
					, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY, COMPANY_ID
					, CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT '1' AS DATA_TYPE, P_DIVISION_ID, V_NEW_VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, SUBSTR(B.YYYYMMDD, 1, 6)  ||  '01', A.CURRENCY, SUM(B.QTY) as QTY, A.COMPANY_ID
						,p_created_by, SYSDATE, p_created_by, SYSDATE
						, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (
					-- 병합처리를 위해 키 중 병합되지 않은 키만 분리
					SELECT A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.INCOTERMS, A.CURRENCY, A.SCM_SITE_ID, A.ITEM_ID
						, MAX(A.FCST_TYPE) AS FCST_TYPE, MAX(A.PLANT_SITE_ID) AS PLANT_SITE_ID
						, MAX(A.DOM_EXP) AS DOM_EXP, MAX(A.COMPANY_ID) AS COMPANY_ID
					FROM GT_DMF0_REPORT A
					GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID
						, A.INCOTERMS, A.CURRENCY
					) A;
				JOIN GT_DMF0_REPORT B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
						AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
						AND A.DEPT_ID = B.DEPT_ID
						AND A.DEPT_NAME = B.DEPT_NAME
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.INCOTERMS = B.INCOTERMS
						AND A.CURRENCY = B.CURRENCY
				GROUP BY B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, SUBSTR(B.YYYYMMDD, 1, 6), A.CURRENCY, A.COMPANY_ID, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청


--SELECT SQL%ROWCOUNT AS ROW_CNT
--SELECT * FROM GT_DMF0_VERSION_COPY
--SELECT * FROM GT_DMF0_REPORT

			END IF;

			-- --------------------------------------------------------------------------------------------------
			--		PRICE 메저 생성
			-- --------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE('B');
				-- LOC 메저는 CP, CR 관계없이 추가한다. ( 실적구간때문에 Loc 메저를 새로 만들어야 하는데, 기존 계획구간에는 Loc 메저가 있을 수도 있어서 복사시에는 Loc 를 복사하지 않고, 여기에서 한꺼번에 새로 만들어준다.
				-- RTF 가 있는 품목들에 대해서 Unit Price ( LOC ) 를 만들어준다. SalesAmt_LOC / Unit Price ( LOCAL )
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
				(  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
				 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
				 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
				 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID
				 -- 2021.7.23
				 , SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC
				 , NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME
				 , APPLICATION, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, ATTRIBUTE3
				 , CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, A.DIVISION_ID ,A.VERSION_NO ,A.CUTOFF_TYPE ,A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , MAX(A.DOM_EXP) AS DOM_EXP, MAX(A.FCST_TYPE) AS FCST_TYPE, MAX(A.INCOTERMS) AS INCOTERMS, 'LOC' AS MEASURE, MAX(A.PLANT_SITE_ID) AS PLANT_SITE_ID
					 , A.YYYYMM  || '01' AS YYYYMMDD, A.CURRENCY
					 , CASE WHEN SUM(A.Qty) <> 0 THEN ROUND(SUM(B.Qty) / SUM(A.Qty), 3)
							ELSE 0 END AS Qty
					 , p_created_by, SYSDATE, p_created_by, SYSDATE, MAX(A.ATTRIBUTE1) AS ATTRIBUTE1
					 , NVL(A.COMPANY_ID, NULL) AS COMPANY_ID
					 -- 2021.7.23
					 , MAX(A.SOLDTO_CUST_REPORT) AS SOLDTO_CUST_REPORT, MAX(A.OWNER_NAME) AS OWNER_NAME, MAX(A.CUST_GROUP_DTL) AS CUST_GROUP_DTL, MAX(A.PRODUCT_DETAILS) AS PRODUCT_DETAILS
					 , MAX(A.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC, MAX(A.NICK_NAME) AS NICK_NAME, MAX(A.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL, MAX(A.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
					 , MAX(A.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE, MAX(A.COMPANY_NAME) AS COMPANY_NAME, MAX(A.APPLICATION) AS APPLICATION, MAX(A.APPLICATION_GR) AS APPLICATION_GR, A.COUNTRY_KR_NAME
					 , MAX(A.ROUTE) AS ROUTE, MAX(A.ATTRIBUTE3) AS CELL_MODEL
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						 , DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM, CURRENCY, SUM(QTY) AS QTY
						 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						 , SOLDTO_CUST_REPORT
						 , OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						 , APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'LOC' AND M.QTY_AMT = 'QTY'
					WHERE DIVISION_ID = P_DIVISION_ID
						--AND MEASURE IN ( 'RTF', 'Business_Plan')
						AND VERSION_NO = V_NEW_VERSION_NO
					GROUP BY  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						, DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						, SOLDTO_CUST_REPORT
						, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						) A;
				JOIN (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						, DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM, CURRENCY, SUM(QTY) AS QTY
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						, SOLDTO_CUST_REPORT
						, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = 'LOC' AND M.QTY_AMT = 'AMT'
					WHERE DIVISION_ID = P_DIVISION_ID
						--AND MEASURE = 'SalesAmt_LOC'
						AND VERSION_NO = V_NEW_VERSION_NO
					GROUP BY DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						, DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						, SOLDTO_CUST_REPORT
						, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						) B ON A.PROJECT_CODE = B.PROJECT_CODE AND A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
										AND A.YYYYMM = B.YYYYMM AND A.COMPANY_ID = B.COMPANY_ID AND A.CURRENCY = B.CURRENCY AND A.INCOTERMS = B.INCOTERMS
										AND A.COUNTRY_KR_NAME = B.COUNTRY_KR_NAME
										AND A.CELL_PROD_SITE  = B.CELL_PROD_SITE			--[PJ2024-50611] 소형 매출 프로세스 개선
				GROUP BY   A.DATA_TYPE, A.DIVISION_ID,A.VERSION_NO,A.CUTOFF_TYPE,A.CUTOFF_YYYYMMDD,A.DEPARTMENT_ID,A.DEPARTMENT_NAME,A.DEPT_ID,A.DEPT_NAME,A.END_CUST_REPORT,A.CUST_REPORT,A.PRODUCT_GROUP
							,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.MEASURE,A.YYYYMM, A.CURRENCY, NVL(A.COMPANY_ID, NULL), A.COUNTRY_KR_NAME, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청

DBMS_OUTPUT.PUT_LINE('C');

			-- 자동차 : KRW, USD 메저 생성
			IF ( P_DIVISION_ID LIKE '81%' ) THEN
					-- KRW
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					 , CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'KRW' AS MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , A.QTY * EX.EXCHANGE_PRICE
					 , p_created_by, SYSDATE, p_created_by, SYSDATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
					 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
						 , YYYYMMDD, CURRENCY, QTY
						 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
						 , CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					WHERE DIVISION_ID = P_DIVISION_ID
						AND MEASURE = 'LOC'
						AND VERSION_NO = V_NEW_VERSION_NO
						) A;
				JOIN DM_PLN_SALES_REPORT_EXCHANGE_C EX ON A.DIVISION_ID = EX.DIVISION_ID AND A.CUTOFF_TYPE = EX.CUTOFF_TYPE
									AND A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND A.CURRENCY = EX.UNIT_CURRENCY
									AND A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_NEW_VERSION_NO;

DBMS_OUTPUT.PUT_LINE('D');
					-- USD
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					 , CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					, A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'USD' AS MEASURE, A.PLANT_SITE_ID
					, A.YYYYMMDD, A.CURRENCY
					, CASE WHEN NVL(EX.EXCHANGE_PRICE, 0) <> 0 THEN ROUND( A.QTY / EX.EXCHANGE_PRICE, 3)
							ELSE 0 END AS QTY
					, p_created_by, SYSDATE, p_created_by, SYSDATE
					, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
					, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
						 , YYYYMMDD, CURRENCY, QTY
						 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
						 , CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					WHERE DIVISION_ID = P_DIVISION_ID
						AND MEASURE = 'KRW'
						AND VERSION_NO = V_NEW_VERSION_NO
						) A;
				JOIN DM_PLN_SALES_REPORT_EXCHANGE_C EX ON A.DIVISION_ID = EX.DIVISION_ID AND A.CUTOFF_TYPE = EX.CUTOFF_TYPE
									AND A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND EX.UNIT_CURRENCY = 'USD'
									AND A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_NEW_VERSION_NO;


			END IF;

DBMS_OUTPUT.PUT_LINE('E');
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 사업부별 메저 생성 ( 사업부별로 특성이 있는 메저들은 수량메저들이고, 40은 없음
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF ( P_DIVISION_ID LIKE '81%' ) THEN
				IF ( p_action_type = 'CP' ) THEN
					DELETE FROM DM_PLN_SALES_PLAN_REPORT_C
					WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = V_NEW_VERSION_NO AND MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL');
				END IF;

				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					 , CELL_PROD_SITE ) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, C.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , CASE WHEN M.O_MEASURE IN ('RTF_SYS_RP_CAR', 'RTF_CAR') THEN
								CASE WHEN INSTR(B.ITEM_CLASS_NAME, 'Cell') > 0 AND C.CELL_PER_CAR > 0 THEN A.QTY / C.CELL_PER_CAR
									WHEN  INSTR(B.ITEM_CLASS_NAME, 'Module') > 0  AND C.CELL_PER_CAR > 0 AND C.CELL_PER_MODULE > 0 THEN A.QTY/ ( C.CELL_PER_CAR/ C.CELL_PER_MODULE )
									WHEN  INSTR(B.ITEM_CLASS_NAME, 'Pack') > 0  THEN A.QTY
									ELSE 0
								END IF;
							WHEN M.O_MEASURE IN ('RTF_SYS_RP_CELL','RTF_CELL') THEN
								CASE WHEN INSTR(B.ITEM_CLASS_NAME, 'Cell') > 0 AND C.CELL_PER_CAR > 0 THEN A.QTY
									WHEN ( INSTR(B.ITEM_CLASS_NAME, 'Module') > 0 OR INSTR(B.ITEM_CLASS_NAME, 'Pack') > 0 ) AND C.CELL_PER_MODULE > 0 THEN A.QTY * C.CELL_PER_MODULE
									ELSE 0
								END;
						END AS QTY
					 , p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM   DM_PLN_SALES_PLAN_REPORT_C A (NOLOCK)
				JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
				JOIN GT_DMF0_SCM_MST_SITE_ITEM C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
				JOIN SCM_MST_SITE D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID
				JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.O_MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL','RTF_CAR', 'RTF_CELL' ) AND M.PLAN_RESULT = 'PLAN'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON D.END_CUSTOMER = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'DM_CAR_QTY_FORD' AND A.ITEM_ID = LK1.SEGMENT3
				WHERE A.DIVISION_ID = P_DIVISION_ID AND A.VERSION_NO = V_NEW_VERSION_NO
					AND ( M.O_MEASURE NOT IN ( 'RTF_SYS_RP_CAR', 'RTF_CAR') OR LK1.SEGMENT1 IS NULL ) -- FORD 환산건은 별도 처리
					AND D.END_CUSTOMER = 'FORD'
				-- FORD 환산건 추가
				UNION ALL
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, C.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , ROUND(SUM(CAST(C.CELL_PER_MODULE AS INTEGER) * CAST(A.QTY AS NUMERIC(13,1)))/MAX(LK1.SEGMENT4), 0) AS QTY
					 , p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM   DM_PLN_SALES_PLAN_REPORT_C A (NOLOCK)
				JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
				JOIN GT_DMF0_SCM_MST_SITE_ITEM C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
				JOIN SCM_MST_SITE D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID
				JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.O_MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_CAR' ) AND M.PLAN_RESULT = 'PLAN'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON D.END_CUSTOMER = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'DM_CAR_QTY_FORD' AND A.ITEM_ID = LK1.SEGMENT3
				WHERE A.DIVISION_ID = P_DIVISION_ID AND A.VERSION_NO = V_NEW_VERSION_NO
					AND ( M.O_MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_CAR') AND LK1.SEGMENT1 IS NOT NULL ) -- FORD 환산건
					AND D.END_CUSTOMER = 'FORD'
				GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, C.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청

			ELSIF P_DIVISION_ID = '82' THEN
				IF ( p_action_type = 'CP' ) THEN
					DELETE FROM DM_PLN_SALES_PLAN_REPORT_C
					WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = V_NEW_VERSION_NO AND MEASURE IN ( 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL');
				END IF;

DBMS_OUTPUT.PUT_LINE('F');
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					 , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , CASE WHEN M.O_MEASURE IN ('RTF_CELL', 'RTF_SYS_RP_CELL') THEN A.QTY * B.CELL_QUANTITY
							WHEN M.O_MEASURE IN ('RTF_ENG', 'RTF_SYS_RP_ENG')	THEN A.QTY * B.ENERGY/1000	-- ENERGY 컬럼값이 KWh 이므로 1,000 으로 나눠준다.
							END AS QTY
					 , p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM   DM_PLN_SALES_PLAN_REPORT_C A (NOLOCK)
				JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
				JOIN GT_DMF0_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.O_MEASURE IN ( 'RTF_CELL', 'RTF_ENG','RTF_SYS_RP_CELL', 'RTF_SYS_RP_ENG' ) AND M.PLAN_RESULT = 'PLAN' --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
				WHERE A.DIVISION_ID = P_DIVISION_ID AND A.VERSION_NO = V_NEW_VERSION_NO
					--and a.item_id = 'EABB00252AA'
					--and a.yyyymmdd = '20191101'
					--and a.scm_site_id = 'Fluence_US_SAN'

				order by measure;
DBMS_OUTPUT.PUT_LINE('G');


			END IF;
			--RAISE_APPLICATION_ERROR(-20001, 'TEST')

			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 사업부별 메저 끝
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 기타매출 복사 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			/*
				기타매출 테이블에서 기타매출 테이블로 복사한다.
				COPY 시에는 실적 기준일이 있을 경우에는 해당 기준일을 기준으로 이전월은 실적으로 보고 해당 기간까지는 실적버전을 복사하고, 이 후 기간은 원본버전을 그대로 복사한다.
			              실적 기준일이 없을 경우에는 그냥 복사한다.
				CREATE 시에는 최신 버전을 그대로 복사한다.
			*/
			DECLARE V_ETC_CUTOFF_TYPE VARCHAR2(20 CHAR), V_ETC_CUTOFF_YYYYMMDD VARCHAR2(8 CHAR)

			SELECT /*__INTO_V_ETC_CUTOFF_TYPE__*/ CUTOFF_TYPE
				, V_ETC_CUTOFF_YYYYMMDD = CUTOFF_YYYYMMDD
			FROM DM_PLN_SALES_PLAN_REPORT_C
			WHERE DIVISION_ID = P_DIVISION_ID
				AND VERSION_NO = V_NEW_VERSION_NO;

--select V_ETC_CUTOFF_TYPE, V_ETC_CUTOFF_YYYYMMDD, V_NEW_VERSION_NO
			IF p_action_type = 'CR' THEN

				INSERT INTO DM_PLN_SALES_ETC_REPORT_C (;
					VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
					, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
					, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
					-- 2021.07.23
					, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
					, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
					, DEPARTMENT_NAME, DEPT_NAME
					 )
				SELECT V_NEW_VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, V_ETC_CUTOFF_TYPE, V_ETC_CUTOFF_YYYYMMDD
					, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_ID ELSE A.DEPARTMENT_ID END AS DEPARTMENT_ID
					, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_ID ELSE A.DEPT_ID END AS DEPT_ID
					, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT
					, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
					, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.QTY
					, p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
					, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
					-- 2021.07.23
					, FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' )                AS OWNER_NAME
					, B.CUST_GROUP_DTL, C.FORECAST_INFO_SPEC
					, NVL(LK3.ATTRIBUTE1, C.NICK_NAME ) AS NICK_NAME
					, NVL(CASE WHEN ISNUMERIC(LK3.ATTRIBUTE2) > 0 THEN LK3.ATTRIBUTE2 ELSE 0 END, C.FORECAST_INFO_CELL_PACK_COUNT ) AS FORECAST_INFO_CELL_PACK_COUNT
					, D.SEGMENT2, F.COUNTRY_KR_NAME, B.ROUTE
					, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
					, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
				FROM DM_PLN_SALES_ETC_REPORT_C A
				LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
				--LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
				LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY_CODE = F.COUNTRY
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 (NOLOCK) ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK1.SEGMENT3 = 'Y'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 (NOLOCK) ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 (NOLOCK) ON A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL'
				WHERE A.DIVISION_ID = P_DIVISION_ID
					AND A.VERSION_NO = ( SELECTA.VERSION_NO
										FROM DM_MDF_VERSION A
										JOIN (
FETCH FIRST 1 ROWS ONLY
											SELECT MAX(A.CREATION_DATE) AS CREATION_DATE
											FROM DM_MDF_VERSION A
											JOIN DM_PLN_SALES_ETC_REPORT_C B ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_NO = B.VERSION_NO
											WHERE A.DIVISION_ID = P_DIVISION_ID
											) B ON A.CREATION_DATE = B.CREATION_DATE
										WHERE A.DIVISION_ID = P_DIVISION_ID
										ORDER BY A.VERSION_NO DESC
										)
--RAISE_APPLICATION_ERROR(-20001, 'SS')
DBMS_OUTPUT.PUT_LINE('H');

			ELSIF p_action_type = 'CP' THEN
				IF D_RESULT_DATE IS NULL THEN
					INSERT INTO DM_PLN_SALES_ETC_REPORT_C (;
						VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
						, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, COMPANY_NAME, COUNTRY_KR_NAME, CUST_GROUP_DTL, DEPARTMENT_NAME, DEPT_NAME
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, NICK_NAME, OWNER_NAME, ROUTE
						  )
					SELECT V_NEW_VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, V_ETC_CUTOFF_TYPE, V_ETC_CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT
						, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
						, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.QTY
						, p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
						, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
						, CASE WHEN p_update_yn = 'Y' AND NVL(D.SEGMENT2, NULL) IS NOT NULL THEN D.SEGMENT2 ELSE A.COMPANY_NAME END AS COMPANY_NAME
						, CASE WHEN p_update_yn = 'Y' AND NVL(F.COUNTRY_KR_NAME, NULL) IS NOT NULL THEN F.COUNTRY_KR_NAME ELSE A.COUNTRY_KR_NAME END AS COUNTRY_KR_NAME
						, CASE WHEN p_update_yn = 'Y' AND NVL(B.CUST_GROUP_DTL, NULL) IS NOT NULL THEN B.CUST_GROUP_DTL ELSE A.CUST_GROUP_DTL END AS CUST_GROUP_DTL
						, CASE WHEN p_update_yn = 'Y' AND P_DIVISION_ID = '40' AND NVL(LK1.SEGMENT2, NULL) IS NOT NULL THEN LK1.SEGMENT2
								WHEN p_update_yn = 'Y' AND P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME
								ELSE A.DEPARTMENT_NAME
								END AS DEPARTMENT_NAME
						, CASE WHEN p_update_yn = 'Y' AND P_DIVISION_ID = '40' AND NVL(LK2.SEGMENT2, NULL) IS NOT NULL THEN LK2.SEGMENT2
								WHEN p_update_yn = 'Y' AND P_DIVISION_ID = '40' AND LK2.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME
								ELSE A.DEPT_NAME
								END AS DEPT_NAME
						, CASE WHEN p_update_yn = 'Y' AND CASE WHEN ISNUMERIC(LK3.ATTRIBUTE2) > 0 THEN LK3.ATTRIBUTE2
																ELSE NVL(C.FORECAST_INFO_CELL_PACK_COUNT,0)
																END <> 0
											THEN CASE WHEN ISNUMERIC(LK3.ATTRIBUTE2) > 0 THEN LK3.ATTRIBUTE2
																ELSE NVL(C.FORECAST_INFO_CELL_PACK_COUNT,0)
								ELSE A.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT
						, CASE WHEN p_update_yn = 'Y' AND NVL(C.FORECAST_INFO_SPEC, NULL) IS NOT NULL THEN C.FORECAST_INFO_SPEC ELSE A.FORECAST_INFO_SPEC END AS FORECAST_INFO_SPEC
						, CASE WHEN p_update_yn = 'Y' AND NVL(LK3.ATTRIBUTE1, C.NICK_NAME ) IS NOT NULL THEN NVL(LK3.ATTRIBUTE1, C.NICK_NAME ) ELSE A.NICK_NAME END AS NICK_NAME
						, CASE WHEN p_update_yn = 'Y' AND NVL(FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' ),'') IS NOT NULL THEN FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' ) ELSE A.OWNER_NAME END AS OWNER_NAME
						, CASE WHEN p_update_yn = 'Y' AND NVL(B.ROUTE, NULL) IS NOT NULL THEN B.ROUTE ELSE A.ROUTE END AS ROUTE
					FROM DM_PLN_SALES_ETC_REPORT_C A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
					--LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY_CODE = F.COUNTRY
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 (NOLOCK) ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK1.SEGMENT3 = 'Y'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 (NOLOCK) ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 (NOLOCK) ON A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL'
					WHERE A.DIVISION_ID = P_DIVISION_ID
						AND A.VERSION_NO = P_VERSION_NO;
DBMS_OUTPUT.PUT_LINE('I');
				ELSE  -- 실적기준일이 있는 복사일 경우 ( 최신화는 UI 에서 강제체크됨 )

					-- 실적을 복사할 버전을 찾는다.
					SELECT MIN(A.VERSION_NO)
  INTO V_MAX_ETC_RESULT_VERSION_NO
					FROM DM_MDF_VERSION A
					JOIN ( SELECT DIVISION_ID, MIN(ETC_RESULT_MONTH) AS ETC_RESULT_MONTH
							FROM DM_MDF_VERSION
							WHERE DIVISION_ID = P_DIVISION_ID
								AND ETC_RESULT_MONTH >= V_ETC_RESULT_MONTH
								AND VERSION_NO <> V_NEW_VERSION_NO
								AND VERSION_TYPE LIKE 'REPORT_SP%'
								AND SEND_YN <> 'D'
							GROUP BY DIVISION_ID
						) B ON A.DIVISION_ID = B.DIVISION_ID
							AND A.ETC_RESULT_MONTH = B.ETC_RESULT_MONTH
							AND A.VERSION_NO <> V_NEW_VERSION_NO
					WHERE A.VERSION_TYPE LIKE 'REPORT_SP%'
						AND A.SEND_YN <> 'D'

					-- LOOKUP 에 복사할 버전이 지정되어있으면 해당 버전을 사용한다.
					SELECT COUNT(1) SEGMENT2
					INTO v_cnt_1
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
					WHERE LOOKUP_TYPE = 'DM_SR_ETC_VERSION'
					AND SEGMENT1 = P_DIVISION_ID
					AND SEGMENT2 IS NOT NULL;
					IF v_cnt_1 > 0 THEN

						SELECT V_MAX_ETC_RESULT_VERSION_NO = SEGMENT2
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
						WHERE LOOKUP_TYPE = 'DM_SR_ETC_VERSION'
							AND SEGMENT1 = P_DIVISION_ID
							AND SEGMENT2 IS NOT NULL;

						IF NOT EXISTS (
								SELECT 1 FROM DM_MDF_VERSION NOLOCK
								WHERE DIVISION_ID = P_DIVISION_ID
								AND VERSION_NO  = V_MAX_ETC_RESULT_VERSION_NO
								 ) THEN
							v_log_type := 'INVALID_ETC_VERSION';
							GOTO ERR_RTN
						END IF;


					SELECT MAX(DATA_SEQ)
  INTO V_MAX_DATA_SEQ
					FROM DM_PLN_SALES_ETC_REPORT_C A
					WHERE A.DIVISION_ID = P_DIVISION_ID
						AND A.VERSION_NO = V_NEW_VERSION_NO;
DBMS_OUTPUT.PUT_LINE('J');
--SELECT V_MAX_ETC_RESULT_VERSION_NO, V_NEW_VERSION_NO, V_ETC_RESULT_MONTH, V_MAX_DATA_SEQ

					INSERT INTO DM_PLN_SALES_ETC_REPORT_C (;
						VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
						, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						-- 2021.07.23
						, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
						, DEPARTMENT_NAME, DEPT_NAME
						 )
					SELECT A.VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD

						-- 최신화가 아닐 경우 기존 값 복사, 일치하는 부서가 없으면 DEAFULT 기타 부서로 세팅
						, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_ID ELSE A.DEPARTMENT_ID END AS DEPARTMENT_ID
						, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_ID ELSE A.DEPT_ID END AS DEPT_ID
						, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT
						, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
						, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
						, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
						-- 2021.07.23
						, FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' )       AS OWNER_NAME
						, B.CUST_GROUP_DTL, C.FORECAST_INFO_SPEC
						, NVL(LK3.ATTRIBUTE1, C.NICK_NAME ) AS NICK_NAME
						, NVL(CASE WHEN ISNUMERIC(LK3.ATTRIBUTE2) > 0 THEN LK3.ATTRIBUTE2 ELSE 0 END, C.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
						, D.SEGMENT2, F.COUNTRY_KR_NAME, B.ROUTE

						, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
						, CASE WHEN P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN v_ETC_DEPARTMENT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
					FROM (
						SELECT
							  V_NEW_VERSION_NO AS VERSION_NO, DIVISION_ID
							, DENSE_RANK() OVER (
									ORDER BY DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
									, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME
									, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CURRENCY, COMPANY_ID
									, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
										 ) AS DATA_SEQ
							, V_ETC_CUTOFF_TYPE AS CUTOFF_TYPE, V_ETC_CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
							, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
							, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY
							, p_created_by AS CREATED_BY, SYSDATE AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
							, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
							, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
							, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
							, DEPARTMENT_NAME, DEPT_NAME
						FROM (
							-- 계획구간
							SELECT DIVISION_ID
								, CUTOFF_TYPE, /* CUTOFF_YYYYMMDD ,*/ DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
								, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
								, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
								, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
								, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
								, DEPARTMENT_NAME, DEPT_NAME
							FROM DM_PLN_SALES_ETC_REPORT_C A
							WHERE A.DIVISION_ID = P_DIVISION_ID
								AND A.VERSION_NO = P_VERSION_NO
								AND A.YYYYMMDD > d_Result_Date
							-- 실적구간
							UNION ALL
							SELECT A.DIVISION_ID, CUTOFF_TYPE, /* CUTOFF_YYYYMMDD ,*/ DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
								, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
								, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
								, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
								, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
								, DEPARTMENT_NAME, DEPT_NAME
							FROM DM_PLN_SALES_ETC_REPORT_C A
							WHERE A.DIVISION_ID = P_DIVISION_ID
								AND A.VERSION_NO = V_MAX_ETC_RESULT_VERSION_NO
								AND A.YYYYMMDD <= d_Result_Date
							) A;
						) A;
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
					--LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY_CODE = F.COUNTRY
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 (NOLOCK) ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END AND LK1.SEGMENT3 = 'Y'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 (NOLOCK) ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' ||  CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_'  ||  A.DIVISION_ID END
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 (NOLOCK) ON A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL'

				END IF;


			-- 1~3 담당이 아니면 기타로 처리
			IF P_DIVISION_ID = '40' THEN
				UPDATE A
				SET DEPARTMENT_ID	= v_ETC_DEPARTMENT_ID
					, DEPT_ID		= v_ETC_DEPARTMENT_ID
				FROM DM_PLN_SALES_ETC_REPORT_C A
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y'
				WHERE B.SEGMENT1 IS NULL
					AND DIVISION_ID = P_DIVISION_ID
					AND VERSION_NO = V_NEW_VERSION_NO;
			END IF;

--VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
--, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
--, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
--, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10


			-- 기타매출 복사 끝 ------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 20230907
DBMS_OUTPUT.PUT_LINE('K');
			BEGIN
			UPDATE A
			SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT
			  , A.FORECAST_INFO_BIZ_TYPE = LOOKA.BIZ_TYPE
			FROM DM_PLN_SALES_PLAN_REPORT_C A
			INNER JOIN (
						SELECT A.MODEL
							 , A.BIZ_TYPE
							 , A.CELL_PACK_COUNT
							 , A.MODEL_RANK
							 , A.DIVISION_ID
						FROM
						(
							SELECT SEGMENT2  AS MODEL
								 , SEGMENT3  AS BIZ_TYPE
								 , SEGMENT4  AS CELL_PACK_COUNT
								 , SEGMENT1  AS DIVISION_ID
								 , RANK () OVER (
													PARTITION BY SEGMENT2
													ORDER BY DISPLAY_SEQ DESC
												 ) MODEL_RANK;
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
						) A;
						WHERE MODEL_RANK = '1'
					  ) LOOKA;
					ON LOOKA.MODEL = A.ITEM_ID
				   AND LOOKA.DIVISION_ID = A.DIVISION_ID
			WHERE A.DIVISION_ID = '40'
			AND A.ITEM_ID = LOOKA.MODEL
			AND A.VERSION_NO = V_NEW_VERSION_NO;

			END;


		END;


    -- IF @V_TRANCOUNT > 0

-- 트랜잭션 (COMMIT)
    COMMIT WORK;

	-- ------------------------------------------------------------------------------------------------------------------------
	-- END TRY
	-- ------------------------------------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
	EXCEPTION
	    WHEN OTHERS THEN
	-- -----------------------------------------------------------
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)

		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		v_log_type := 'ERROR';
		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
		v_description := 'ERROR_LINE : '  ||  STR(NULL);
		d_event_date := SYSTIMESTAMP;
		--[C20200909-000203] LOG 표준화 적용
		PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);

		SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/


	-- -----------------------------------------------------------
	END CATCH;
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
		IF v_log_message IS NULL
		SELECT 'success'


	--------------------------------------------------------- TEMP TABLE 확인후 초기화
	--------------------------------------------------------- TEMP TABLE 확인후 초기화


	-- 종료 LOG
	v_log_type := 'END';
	v_log_message := '########## END of procedure ##########';
	v_description := 'delete_count: ' ||  TO_CHAR(n_delete_count)   ||  ' / merge_count: '  ||  TO_CHAR(n_merge_count) ;
	d_event_date := SYSTIMESTAMP;

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);

	ERR_RTN:
	IF v_log_type = 'DIVISION_INVALID'
		BEGIN
						v_log_message := '########## END of procedure ##########';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);
			SELECT 'Division 값이 존재하지 않습니다.'
		END

	IF v_log_type = 'VERSION_NO_INVALID'
		BEGIN
						v_log_message := '########## END of procedure ##########';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);
			SELECT 'VERSION 값이 존재하지 않습니다.'
		END

	IF v_log_type = 'INVALID_ETC_VERSION'
		BEGIN
						v_log_message := '########## END of procedure ##########';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);
			SELECT '룩업에 설정된 ETC 버전이 잘못되었습니다.'
		END

	IF v_log_type = '이동계획 중복'
		BEGIN
						v_log_message := '########## END of procedure ##########';
			d_event_date := SYSTIMESTAMP;
			PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, p_created_by);
			SELECT v_description
		END

        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
	END;
/
