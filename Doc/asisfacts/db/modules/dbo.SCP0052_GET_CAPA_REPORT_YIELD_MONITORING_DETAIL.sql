/*
 * Program ID   : SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/07/28   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - YIELD MONITORING 상세 팝업 최초 작성
 * 2021/09/06   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 실적있는 정보만 조회 추가(옵션)
 * 2021/09/29   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - ACTUAL_QTY > 0 -> ACTUAL_GOOD_QTY > 0 수정
 * 2021/10/18   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 담당자 정보 칼럼 추가
 * 2021/11/08   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - GAP_PER 칼럼 소숫점 2자리
 * 2021/11/16   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - ORDER BY GAP DESC 추가, Line Assign 대상에 대해 Priority가 1~8만 조회
 * 2021/12/20   khj79        [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 이력 테이블(HIST) 조회

DECLARE 
	@p_from_yyyymm			NVARCHAR(6) = '202107'
	,@p_to_yyyymm			NVARCHAR(6) = '202207'
	,@p_division_id			NVARCHAR(20)= '81'
	,@p_group				NVARCHAR(1) = 'A'
	,@p_plant_id			NVARCHAR(30)= 'G382'
	,@p_site_id				NVARCHAR(30)= 'A003'
	,@p_signal				NVARCHAR(10)= 'TOTAL'
	,@p_check_production	VARCHAR(1) = 'Y'
	,@debug_mode			CHAR(1) = ''
 */


CREATE PROCEDURE [dbo].[SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL]
	@p_from_yyyymm			NVARCHAR(6)
	,@p_to_yyyymm			NVARCHAR(6)
	,@p_division_id			NVARCHAR(1000)
	,@p_group				NVARCHAR(1000)
	,@p_plant_id			NVARCHAR(1000)
	,@p_site_id				NVARCHAR(1000)
	,@p_signal				NVARCHAR(10)
	,@p_check_production	VARCHAR(1)
	,@debug_mode			CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- 부동 소수점 오류(0이나 NULL값을 무시한 연산을 수행) 
	SET ANSI_WARNINGS OFF
	SET ARITHIGNORE ON
	SET ARITHABORT OFF

	-- 날짜 조건용 변수 설정
	DECLARE @v_start_month		NVARCHAR(6);	--시작 월(현재월 +1 년)
	DECLARE @v_end_month		NVARCHAR(6);	--마지막 월

	DECLARE @v_start_result	NVARCHAR(6);	--과거 시작 월(과거 테이블 조회)
	DECLARE @v_end_result	NVARCHAR(6);	--과거 마지막 월(과거 테이블 조회)
	DECLARE @v_result_month		INT = 2;	--과거 데이터 조회 월		

	DECLARE @v_result_table_month NVARCHAR(8) = CONVERT(VARCHAR(8) , DATEADD(MM, -@v_result_month  ,GETDATE()),112); -- 이력 테이블 조회 기준 월

	--SET @v_start_month = @p_from_yyyymm ;
	--SET @v_end_month= @p_to_yyyymm;

	-- 과거 조회 일자 설정
	IF @p_from_yyyymm < @v_result_table_month
		BEGIN
			-- 이력 테이블 조회
			SET @v_start_result = @p_from_yyyymm;
			SET @v_end_result	= @v_result_table_month
			SET @v_start_month		= CONVERT(VARCHAR(6) , DATEADD(MM,1 ,@v_result_table_month),112) ; -- 현재월 -1@v_result_table_month
			SET @v_end_month		= @p_to_yyyymm;
		END
	ELSE
		BEGIN
			-- 이력 테이블 조회 하지 않는다.
			SET @v_start_result = @p_to_yyyymm;
			SET @v_end_result	= @p_from_yyyymm;
			SET @v_start_month	= @p_from_yyyymm;  -- 조회 시작 월
			SET @v_end_month	= @p_to_yyyymm;
		END

	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT '@v_start_month		=' +@v_start_month;
		PRINT '@v_end_month			=' +@v_end_month;
		PRINT '@v_start_result		=' +@v_start_result;
		PRINT '@v_end_result		=' +@v_end_result;
		PRINT '----------------------------------';
	END;

	
	BEGIN

		--
		IF OBJECT_ID('TEMPDB..#TMP_SCP0052_YIELD_DETAIL') IS NOT NULL
			DROP TABLE #TMP_SCP0052_YIELD_DETAIL;

		SELECT DIVISION_ID
			 , A.COMPANY_ID
			 , A.SITE_ID
			 , A.PLANT_ID 
			 , A.FACTORY_ID
			 , A.OPERATION_ID
			 , A.LINE_ID 
			 , A.ITEM_ID 
			 , A.MONTH 
			 , A.YIELD
			 , A.RESULT_YIELD 
		  INTO #TMP_SCP0052_YIELD_DETAIL
		  FROM SCM_MST_YIELD_SN A WITH(NOLOCK)
		 WHERE 1=1
		   AND A.MONTH >= @V_START_MONTH 
		   AND A.MONTH <= @V_END_MONTH
		   AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
		   AND (( @p_plant_id		IS NULL OR @p_plant_id		='') OR A.PLANT_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
		   AND (( @p_site_id		IS NULL OR @p_site_id		='') OR A.SITE_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_site_id		, ',')))
		   AND (A.YIELD			IS NOT NULL AND A.RESULT_YIELD > 0)

		 UNION ALL

		SELECT DIVISION_ID
			 , A.COMPANY_ID
			 , A.SITE_ID
			 , A.PLANT_ID
			 , A.FACTORY_ID
			 , A.OPERATION_ID
			 , A.LINE_ID
			 , A.ITEM_ID
			 , A.MONTH
			 , A.YIELD
			 , A.RESULT_YIELD 
		  FROM HIST_SCM_YIELD_M_SN A WITH(NOLOCK)  -- 이력(HIST) 테이블 조회
		 WHERE 1=1
		   AND A.MONTH >= @v_start_result
		   AND A.MONTH <= @v_end_result
		   AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
		   AND (( @p_plant_id		IS NULL OR @p_plant_id		='') OR A.PLANT_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
		   AND (( @p_site_id		IS NULL OR @p_site_id		='') OR A.SITE_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_site_id		, ',')))
		   AND (A.YIELD			IS NOT NULL AND A.RESULT_YIELD > 0)
		;


		IF OBJECT_ID('TEMPDB..#TMP_SCP0052_LINE_ASSIGN_DETAIL') IS NOT NULL
			DROP TABLE #TMP_SCP0052_LINE_ASSIGN_DETAIL;

		SELECT COMPANY_ID
			 , DIVISION_ID
			 , SITE_ID
			 , PLANT_ID
			 , FACTORY_ID
			 , OPERATION_ID
			 , LINE_ID
			 , ITEM_ID
			 , MONTH
		  INTO #TMP_SCP0052_LINE_ASSIGN_DETAIL
		  FROM SCM_MST_ITEM_LINE_ASSIGN_SN D WITH(NOLOCK)
		 WHERE 1=1
		   AND D.MONTH			>= @V_START_MONTH
		   AND D.MONTH			<= @V_END_MONTH
		   AND (( @p_division_id	IS NULL OR @p_division_id	='') OR D.DIVISION_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
		   AND (( @p_plant_id		IS NULL OR @p_plant_id		='') OR D.PLANT_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
		   AND (( @p_site_id		IS NULL OR @p_site_id		='') OR D.SITE_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_site_id		, ',')))
		   AND D.PRIORITY		NOT IN ('0', '9')
		UNION ALL

		SELECT COMPANY_ID
			 , DIVISION_ID
			 , SITE_ID
			 , PLANT_ID
			 , FACTORY_ID
			 , OPERATION_ID
			 , LINE_ID
			 , ITEM_ID
			 , MONTH
		  FROM HIST_SCM_ITEM_LINE_ASSIGN_M_SN D WITH(NOLOCK)
		 WHERE 1=1
		   AND D.MONTH			>= @v_start_result
		   AND D.MONTH			<= @v_end_result
		   AND (( @p_division_id	IS NULL OR @p_division_id	='') OR D.DIVISION_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id		, ',')))
		   AND (( @p_plant_id		IS NULL OR @p_plant_id		='') OR D.PLANT_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
		   AND (( @p_site_id		IS NULL OR @p_site_id		='') OR D.SITE_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_site_id		, ',')))
		   AND D.PRIORITY		NOT IN ('0', '9')
    ;	

		
		WITH AA AS (
			SELECT 
				A.DIVISION_ID
				, B.DIVISION_NAME
				, A.SITE_ID
				, B.SITE_NAME
				, A.PLANT_ID 
				, B.PLANT_NAME
				, A.FACTORY_ID
				, A.OPERATION_ID
				, A.LINE_ID 
				, A.ITEM_ID 
				, A.MONTH 
				, A.YIELD AS PLAN_YIELD 
				, A.RESULT_YIELD 
				, ABS(YIELD-RESULT_YIELD) AS GAP
				, CONVERT(NUMERIC(20, 2), (ABS(YIELD-RESULT_YIELD)*100)) AS GAP_PER
				, CASE WHEN ABS(YIELD-RESULT_YIELD) < 0.01 THEN 'GREEN'
				  WHEN ABS(YIELD-RESULT_YIELD) > 0.03 THEN 'RED'
				  WHEN ABS(YIELD-RESULT_YIELD) >= 0.01 AND ABS(YIELD-RESULT_YIELD) <= 0.03 THEN 'YELLOW'
				  END SIGNAL
				, ISNULL(M.DEPARTMENT, CASE WHEN A.SITE_ID = 'A001' THEN C.DEPT_NAME_KO
											WHEN A.SITE_ID = 'A002' THEN C.DEPT_NAME_CN
										ELSE DEPT_NAME_EN	
				   END) AS DEPARTMENT
				, C.USER_NAME AS MANAGER

			FROM #TMP_SCP0052_YIELD_DETAIL A WITH(NOLOCK)

			JOIN ( 
					SELECT DISTINCT
						X1.COMPANY_ID
						, X1.DIVISION_ID
						, ISNULL((SELECT DESCRIPTION FROM SCM_DIVISION_M_SN X2 WITH(NOLOCK) WHERE X1.COMPANY_ID=X2.COMPANY_ID AND X1.DIVISION_ID=X2.DIVISION_ID), X1.DIVISION_NAME) AS DIVISION_NAME
						, X1.SITE_ID
						, X1.SITE_NAME
						, X1.PLANT_ID
						, ISNULL((SELECT DESCRIPTION FROM SCM_PLANT_M_SN X3 WITH(NOLOCK) WHERE X1.COMPANY_ID=X3.COMPANY_ID AND X1.DIVISION_ID=X3.DIVISION_ID AND X1.SITE_ID=X3.SITE_ID AND X1.PLANT_ID=X3.PLANT_ID), X1.PLANT_NAME) AS PLANT_NAME
						, X1.OPERATION_GROUP_ID
						, X1.OPERATION_GROUP
						, X1.FACTORY_ID
						, X1.LINE_ID
						, X1.OPERATION_ID
					FROM SCM_LINE_HIERARCHY_V_SN X1 WITH(NOLOCK)

				) B
				ON A.COMPANY_ID		= B.COMPANY_ID
			   AND A.DIVISION_ID	= B.DIVISION_ID
			   AND A.SITE_ID		= B.SITE_ID
			   AND A.PLANT_ID		= B.PLANT_ID
			   AND A.FACTORY_ID		= B.FACTORY_ID
			   AND A.LINE_ID		= B.LINE_ID
			   AND A.OPERATION_ID	= B.OPERATION_ID

			LEFT JOIN ( 
				SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, LOSS_CODE, USER_ID_1, DEPARTMENT
				FROM SCM_MASTER_MANAGER_M_SN WITH(NOLOCK) --기준정보별 담당자 정보
			) M
			ON A.COMPANY_ID			= M.COMPANY_ID
			 AND A.DIVISION_ID		= M.DIVISION_ID
			 AND A.SITE_ID			= M.SITE_ID
			 AND A.PLANT_ID			= M.PLANT_ID
			 AND A.FACTORY_ID		= M.FACTORY_ID
			 AND A.OPERATION_ID		= M.OPERATION_ID
			 AND A.LINE_ID			= M.LINE_ID
			 AND M.LOSS_CODE		= 'LA003'

			LEFT JOIN (
				SELECT A.USER_NAME, A.USER_ID, A.DEPT_ID, B.DEPT_NAME_KO, B.DEPT_NAME_EN, B.DEPT_NAME_CN
				FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)
					,SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)
				WHERE A.DEPT_ID = B.DEPT_ID
			) C
			ON M.USER_ID_1 = C.USER_ID

			WHERE 1=1
			--AND	A.MONTH >= @V_START_MONTH 
			--AND A.MONTH <= @V_END_MONTH
			AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id		, ',')))
			AND (( @p_group			IS NULL OR @p_group			='') OR B.OPERATION_GROUP_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_group		, ',')))
			AND (( @p_plant_id		IS NULL OR @p_plant_id		='') OR A.PLANT_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
			AND (( @p_site_id		IS NULL OR @p_site_id		='') OR A.SITE_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_site_id		, ',')))
			AND (A.YIELD			IS NOT NULL AND A.RESULT_YIELD > 0)
			AND (@p_check_production = 'N' OR EXISTS (

					SELECT DISTINCT
						C.COMPANY_ID
					FROM  SCM_DNM_DAILY_PRODUCT_RESULT_SN C WITH(NOLOCK)
					WHERE 1=1
					AND CONVERT(VARCHAR(6), C.PLAN_DATE, 112) >= @p_from_yyyymm 
					AND CONVERT(VARCHAR(6), C.PLAN_DATE, 112) <= @p_to_yyyymm
					AND C.ACTUAL_GOOD_QTY	> 0
					AND A.COMPANY_ID		= C.COMPANY_ID
					AND A.DIVISION_ID		= C.DIVISION_ID
					AND A.SITE_ID			= C.SITE_ID
					AND A.PLANT_ID			= C.PLANT_ID
					AND A.FACTORY_ID		= C.FACTORY_ID
					AND A.LINE_ID			= C.LINE_ID
					AND A.OPERATION_ID		= C.OPERATION_ID
					AND A.ITEM_ID			= C.ITEM_ID
					AND A.MONTH				= CONVERT(VARCHAR(6), C.PLAN_DATE, 112)

				)
			)
			AND EXISTS ( -- LINE ASSIGN PRIORITY (1~8), SCP0052_GET_CAPA_REPORT 참고
				
				SELECT 1
				FROM #TMP_SCP0052_LINE_ASSIGN_DETAIL D WITH(NOLOCK)
				WHERE 1=1
				AND A.COMPANY_ID	= D.COMPANY_ID
				AND A.DIVISION_ID	= D.DIVISION_ID
				AND A.SITE_ID		= D.SITE_ID
				AND A.PLANT_ID		= D.PLANT_ID
				AND A.FACTORY_ID	= D.FACTORY_ID
				AND A.OPERATION_ID	= D.OPERATION_ID
				AND A.LINE_ID		= D.LINE_ID
				AND A.ITEM_ID		= D.ITEM_ID
				AND A.MONTH			= D.MONTH
				--AND D.MONTH			>= @v_start_month
				--AND D.MONTH			<= @v_end_month
				--AND D.PRIORITY		NOT IN ('0', '9')
			
			)

		)
		SELECT
			DIVISION_ID
			, DIVISION_NAME
			, SITE_ID
			, SITE_NAME
			, PLANT_ID 
			, PLANT_NAME
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID 
			, ITEM_ID 
			, MONTH 
			, PLAN_YIELD 
			, RESULT_YIELD 
			, GAP
			, CONVERT(NVARCHAR, GAP_PER) + ' %' AS GAP_PER
			, SIGNAL
			, DEPARTMENT
			, MANAGER
		FROM AA
		WHERE	1 = 1
		AND (( @p_signal		IS NULL OR @p_signal		=''	OR @p_signal = 'TOTAL') OR SIGNAL				= @p_signal )
		ORDER BY GAP DESC
		;





	END;


END

