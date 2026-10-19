/*
 * Program ID   : SCP0052_GET_CAPA_REPORT_YIELD_MONITORING
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/07/27   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - YIELD MONITORING 최초 작성
 * 2021/09/01   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - YIELD MONITORING 수정
 * 2021/09/29   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - ACTUAL_QTY > 0 -> ACTUAL_GOOD_QTY > 0 수정
 * 2021/11/16   KMJ          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - GREEN -> YELLOW -> RED 순서로 변경, Line Assign 대상에 대해 Priority가 1~8만 조회
 * 2021/12/20   khj79        [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 이력 테이블(HIST) 조회
 
DECLARE
	@p_from_yyyymm			NVARCHAR(6) = '202108'
	,@p_to_yyyymm			NVARCHAR(6) = '202108'
	,@p_division_id			NVARCHAR(20) = '40,81,82'
	,@p_group				NVARCHAR(1) = 'A,E,F,P'
	,@p_plant_id			NVARCHAR(1000) = 'A050,A010,A040,G383,G388,G382,G451,G452,G631,G632,G634,G182,G183,G184,G481,G482,A011,A041'
	,@p_factory_id			NVARCHAR(1000) = ''
	,@p_line_id				NVARCHAR(1000) = ''
	,@p_operation_id		NVARCHAR(1000) = ''
	,@p_model_id			NVARCHAR(30) = ''
	,@p_item_id				NVARCHAR(30) = ''
	,@p_nick_name			NVARCHAR(30) = ''
	,@p_check_production	NVARCHAR(1) = 'N'
	,@p_check_accuracy		NVARCHAR(1) = 'N'
	,@p_user_id				NVARCHAR(30) = 'khj79'
	,@debug_mode			CHAR(1) = 'F'
 */


CREATE PROCEDURE [dbo].[SCP0052_GET_CAPA_REPORT_YIELD_MONITORING]
	@p_from_yyyymm			NVARCHAR(6)
	,@p_to_yyyymm			NVARCHAR(6)
	,@p_division_id			NVARCHAR(1000)
	,@p_group				NVARCHAR(1000)
	,@p_plant_id			NVARCHAR(1000)
	,@p_factory_id			NVARCHAR(1000) = ''
	,@p_line_id				NVARCHAR(1000) = ''
	,@p_operation_id		NVARCHAR(1000) = ''
	,@p_model_id			NVARCHAR(30)
	,@p_item_id				NVARCHAR(30)
	,@p_nick_name			NVARCHAR(30)
	,@p_check_production	NVARCHAR(1)
	,@p_check_accuracy		NVARCHAR(1)
	,@p_user_id				NVARCHAR(30)
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

	--SET @v_start_month = @p_from_yyyymm ;
	--SET @v_end_month= @p_to_yyyymm;

	DECLARE @v_start_result	NVARCHAR(6);	--과거 시작 월(과거 테이블 조회)
	DECLARE @v_end_result	NVARCHAR(6);	--과거 마지막 월(과거 테이블 조회)
	DECLARE @v_result_month		INT = 2;		--과거 데이터 조회 월		

	DECLARE @v_result_table_month NVARCHAR(8) = CONVERT(VARCHAR(8) , DATEADD(MM, -@v_result_month  ,GETDATE()),112); -- 이력 테이블 조회 기준 월
	
	DECLARE @MQRY_SUM NVARCHAR(max) = '';
	DECLARE @MEXEC NVARCHAR(MAX) = '';


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
	---------------------------------------------------------------
	-- 임시조회테이블 생성 (YIELD)
	---------------------------------------------------------------
	BEGIN

	IF OBJECT_ID('TEMPDB..#TMP_SCP0049_YIELD_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0049_YIELD_DATA;

	SELECT COMPANY_ID
		 , DIVISION_ID
		 , SITE_ID
		 , PLANT_ID
		 , FACTORY_ID
		 , OPERATION_ID
		 , LINE_ID
		 , ITEM_ID
		 , MONTH
		 , YIELD
		 , RESULT_YIELD

	  INTO #TMP_SCP0049_YIELD_DATA -- 임시 테이블 저장

	  FROM SCM_MST_YIELD_SN A WITH(NOLOCK)
	 WHERE MONTH >= @v_start_month
	   AND MONTH <= @v_end_month
	   AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id		, ',')))
	   AND (( @p_plant_id		IS NULL OR @p_plant_id		='') OR A.PLANT_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
	   AND (A.YIELD	IS NOT NULL AND A.RESULT_YIELD > 0)

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
		 , YIELD
		 , RESULT_YIELD
	  FROM HIST_SCM_YIELD_M_SN A WITH(NOLOCK)  -- 이력 테이블(HIST)  조회
	 WHERE MONTH >= @v_start_result
	   AND MONTH <= @v_end_result
	   AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id		, ',')))
	   AND (( @p_plant_id		IS NULL OR @p_plant_id		='') OR A.PLANT_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
	   AND (A.YIELD	IS NOT NULL AND A.RESULT_YIELD > 0)
	;

	---------------------------------------------------------------
	-- 임시조회테이블 생성 (LINE ASSIGN)
	---------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TMP_SCP0049_LINE_ASSIGN_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0049_LINE_ASSIGN_DATA;

	SELECT DISTINCT COMPANY_ID
		 , DIVISION_ID
		 , SITE_ID
		 , PLANT_ID
		 , FACTORY_ID
		 , OPERATION_ID
		 , LINE_ID
		 , ITEM_ID
		 , MONTH

	  INTO #TMP_SCP0049_LINE_ASSIGN_DATA -- 임시 테이블 저장

	  FROM SCM_MST_ITEM_LINE_ASSIGN_SN A WITH(NOLOCK)
	 WHERE MONTH >= @v_start_month
	   AND MONTH <= @v_end_month
	   AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
	   AND (( @p_plant_id		IS NULL OR @p_plant_id		='') OR A.PLANT_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
	   AND PRIORITY NOT IN ('0', '9')

	UNION ALL

	SELECT DISTINCT COMPANY_ID
		 , DIVISION_ID
		 , SITE_ID
		 , PLANT_ID
		 , FACTORY_ID
		 , OPERATION_ID
		 , LINE_ID
		 , ITEM_ID
		 , MONTH
	  FROM HIST_SCM_ITEM_LINE_ASSIGN_M_SN A WITH(NOLOCK)  -- 이력 테이블(HIST)  조회
	 WHERE MONTH >= @v_start_result
	   AND MONTH <= @v_end_result
	   AND (( @p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
	   AND (( @p_plant_id		IS NULL OR @p_plant_id		='') OR A.PLANT_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id		, ',')))
	   AND PRIORITY NOT IN ('0', '9')
	   ;


	---------------------------------------------------------------
	-- 임시조회테이블 INDEX 생성
	---------------------------------------------------------------
	CREATE NONCLUSTERED INDEX TempTalbeIndex_YIELD ON [dbo].[#TMP_SCP0049_YIELD_DATA] ([COMPANY_ID], [DIVISION_ID],[SITE_ID],[PLANT_ID],[FACTORY_ID],[OPERATION_ID],[LINE_ID],[ITEM_ID],[MONTH]);

	CREATE NONCLUSTERED INDEX TempTalbeIndex_LINE ON [dbo].[#TMP_SCP0049_LINE_ASSIGN_DATA] ([COMPANY_ID], [DIVISION_ID],[SITE_ID],[PLANT_ID],[FACTORY_ID],[OPERATION_ID],[LINE_ID],[ITEM_ID],[MONTH]);



	IF OBJECT_ID('TEMPDB..#TMP_SCP0049_TARGET_ITEM') IS NOT NULL
		DROP TABLE #TMP_SCP0049_TARGET_ITEM
		;
		-- Elec > assem > formation  >pack
		WITH AA AS (
				SELECT 
					A.DIVISION_ID
					, B.DIVISION_NAME
					, B.OPERATION_GROUP_ID
					, B.OPERATION_GROUP
					, A.SITE_ID
					, B.SITE_NAME
					, A.PLANT_ID
					, B.PLANT_NAME
					, A.MONTH				AS YYYYMM
					, CASE WHEN ABS(YIELD-RESULT_YIELD) < 0.01 THEN 1 ELSE 0 END 'GREEN'
					, CASE WHEN ABS(YIELD-RESULT_YIELD) >= 0.01 AND ABS(YIELD-RESULT_YIELD) <= 0.03 THEN 1 ELSE 0 END 'YELLOW'
					, CASE WHEN ABS(YIELD-RESULT_YIELD) > 0.03 THEN 1 ELSE 0 END 'RED'
					, ABS(YIELD-RESULT_YIELD) AS GAP
				FROM #TMP_SCP0049_YIELD_DATA A WITH(NOLOCK)

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

				WHERE 1=1
				AND (( @p_group			IS NULL OR @p_group			='') OR B.OPERATION_GROUP_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_group		, ',')))
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
					FROM #TMP_SCP0049_LINE_ASSIGN_DATA D WITH(NOLOCK)
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
				)
			)
			SELECT 
				DIVISION_ID
				, DIVISION_NAME
				, OPERATION_GROUP_ID
				, OPERATION_GROUP
				, SITE_ID
				, SITE_NAME
				, PLANT_ID
				, PLANT_NAME
				, CASE WHEN GREEN	> 0 THEN 'G_'+YYYYMM 
						WHEN RED	> 0 THEN 'R_'+YYYYMM
						WHEN YELLOW > 0 THEN 'Y_'+YYYYMM
					END AS YYYYMM
				, GREEN
				, YELLOW
				, RED
				, GAP
				, 'A_'+YYYYMM AS A_YYYYMM
			INTO #TMP_SCP0049_TARGET_ITEM
			FROM AA
		;


	END;

		

	-----------------------------------------------
	-- 달력 필드 생성
	-----------------------------------------------
	BEGIN
			SET @MQRY_SUM = '';

			IF @p_check_accuracy = 'N'
			
			BEGIN
			SELECT @MQRY_SUM = @MQRY_SUM+','+  CASE WHEN CHARINDEX('G_', YYYYMM) =1 THEN 'SUM(CASE WHEN R.YYYYMM = '''+YYYYMM+''' THEN R.GREEN  ELSE 0 END ) AS ' + YYYYMM
													WHEN CHARINDEX('Y_', YYYYMM) =1 THEN 'SUM(CASE WHEN R.YYYYMM = '''+YYYYMM+''' THEN R.YELLOW ELSE 0 END ) AS ' + YYYYMM
													WHEN CHARINDEX('R_', YYYYMM) =1 THEN 'SUM(CASE WHEN R.YYYYMM = '''+YYYYMM+''' THEN R.RED    ELSE 0 END ) AS ' + YYYYMM
													WHEN CHARINDEX('A_', YYYYMM) =1 THEN 'ISNULL(FORMAT((1-(SUM(CASE WHEN R.A_YYYYMM = '''+YYYYMM+''' THEN R.GAP ELSE 0 END )/SUM(CASE WHEN R.A_YYYYMM = '''+YYYYMM+''' THEN 1 ELSE 0 END)))*100, ''##0.##''), 0) AS ' + YYYYMM
										END +''+  CHAR(10)
			FROM ( 

					SELECT 'G_'+A.BASIS_YYYYMM  AS YYYYMM
							, A.BASIS_YYYYMM + '01'  AS SORT_ORDER_NO
					FROM [DBO].[SCM_SYS_CALENDAR_M] A
					WHERE A.BASIS_YYYYMM  >= IIF( @v_start_month > @v_start_result , @v_start_result , @v_start_month)
					AND A.BASIS_YYYYMM  <= @v_end_month
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME

					UNION ALL

					SELECT 'Y_'+A.BASIS_YYYYMM  AS YYYYMM
							, A.BASIS_YYYYMM + '05' AS SORT_ORDER_NO
					FROM [DBO].[SCM_SYS_CALENDAR_M] A
					WHERE A.BASIS_YYYYMM  >= IIF( @v_start_month > @v_start_result , @v_start_result , @v_start_month)
					AND A.BASIS_YYYYMM  <= @v_end_month
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME

					UNION ALL
				
					SELECT 'R_'+A.BASIS_YYYYMM  AS YYYYMM
							, A.BASIS_YYYYMM + '10' AS SORT_ORDER_NO
					FROM [DBO].[SCM_SYS_CALENDAR_M] A
					WHERE A.BASIS_YYYYMM  >= IIF( @v_start_month > @v_start_result , @v_start_result , @v_start_month)
					AND A.BASIS_YYYYMM  <= @v_end_month
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME

					UNION ALL

					SELECT 'A_'+A.BASIS_YYYYMM  AS YYYYMM
							, A.BASIS_YYYYMM + '15' AS SORT_ORDER_NO
					FROM [DBO].[SCM_SYS_CALENDAR_M] A
					WHERE A.BASIS_YYYYMM  >= IIF( @v_start_month > @v_start_result , @v_start_result , @v_start_month)
					AND A.BASIS_YYYYMM  <= @v_end_month
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME


			) AS A

			ORDER BY SORT_ORDER_NO
			;

			END

			ELSE -- Accuracy = Y
			
			BEGIN
			-- 10년
			SELECT TOP 120 @MQRY_SUM = @MQRY_SUM+','+  CASE WHEN CHARINDEX('A_', YYYYMM) =1 THEN 'ISNULL(FORMAT((1-(SUM(CASE WHEN R.A_YYYYMM = '''+YYYYMM+''' THEN R.GAP ELSE 0 END )/SUM(CASE WHEN R.A_YYYYMM = '''+YYYYMM+''' THEN 1 ELSE 0 END)))*100, ''##0.##''), 0) AS ' + YYYYMM
										END +''+  CHAR(10)

			FROM ( 

					SELECT 'A_'+A.BASIS_YYYYMM  AS YYYYMM
							, A.BASIS_YYYYMM + '01' AS SORT_ORDER_NO
					FROM [DBO].[SCM_SYS_CALENDAR_M] A
					WHERE A.BASIS_YYYYMM  >= IIF( @v_start_month > @v_start_result , @v_start_result , @v_start_month)
					AND A.BASIS_YYYYMM  <= @v_end_month
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME


			) AS A

			ORDER BY SORT_ORDER_NO
			;

			END

			PRINT @MQRY_SUM;
	END

	-----------------------------------------------
	-- PIVOT
	-----------------------------------------------
	BEGIN
		SET @MEXEC = '';

		SET @MEXEC = @MEXEC+'SELECT ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	IIF(GROUPING(DIVISION_ID)=1, N''TOTAL'', DIVISION_ID) AS DIVISION_ID ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, IIF(IIF(GROUPING(DIVISION_ID)=1, N''TOTAL'', DIVISION_ID)=N''TOTAL'', N''TOTAL'', MAX(DIVISION_NAME)) AS DIVISION_NAME ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, IIF(GROUPING(DIVISION_ID)=0 AND GROUPING(OPERATION_GROUP_ID)=1, N''Sub-Total'', OPERATION_GROUP_ID) AS OPERATION_GROUP_ID ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, IIF(IIF(GROUPING(DIVISION_ID)=0 AND GROUPING(OPERATION_GROUP_ID)=1, N''Sub-Total'', OPERATION_GROUP_ID)=N''Sub-Total'', N''Sub-Total'', IIF(ISNULL(OPERATION_GROUP_ID,'''')='''', '''', MAX(OPERATION_GROUP)) ) AS OPERATION_GROUP' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, IIF(GROUPING(DIVISION_ID)=0 AND GROUPING(OPERATION_GROUP_ID)=0 AND GROUPING(SITE_ID)=1, N''Sub-Total'', SITE_ID) AS SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, IIF(IIF(GROUPING(DIVISION_ID)=0 AND GROUPING(OPERATION_GROUP_ID)=0 AND GROUPING(SITE_ID)=1, N''Sub-Total'', SITE_ID)=N''Sub-Total'', N''Sub-Total'', IIF(ISNULL(SITE_ID,'''')='''', '''', MAX(SITE_NAME)) ) AS SITE_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, IIF(GROUPING(DIVISION_ID)=0 AND GROUPING(OPERATION_GROUP_ID)=0 AND GROUPING(SITE_ID)=0 AND GROUPING(PLANT_ID)=1, N''Sub-Total'', PLANT_ID) AS PLANT_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, IIF(IIF(GROUPING(DIVISION_ID)=0 AND GROUPING(OPERATION_GROUP_ID)=0 AND GROUPING(SITE_ID)=0 AND GROUPING(PLANT_ID)=1, N''Sub-Total'', PLANT_ID)=N''Sub-Total'', N''Sub-Total'', IIF(ISNULL(PLANT_ID,'''')='''', '''', MAX(PLANT_NAME)) ) PLANT_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'	' + @MQRY_SUM										  + CHAR(10);
		SET @MEXEC = @MEXEC+'	, FORMAT((1-( SUM(GAP)/SUM(R.GREEN + R.YELLOW + R.RED)))*100, ''##0.##'') AS ACCURACY' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, SUM(R.GREEN + R.YELLOW + R.RED) AS TOTAL' + CHAR(10);
		
		SET @MEXEC = @MEXEC+'FROM #TMP_SCP0049_TARGET_ITEM R' + CHAR(10);

		SET @MEXEC = @MEXEC+'GROUP BY	'										  + CHAR(10);
		SET @MEXEC = @MEXEC+'	DIVISION_ID	'										  + CHAR(10);
		SET @MEXEC = @MEXEC+'	,OPERATION_GROUP_ID'								 + CHAR(10);
		SET @MEXEC = @MEXEC+'	,SITE_ID	'										  + CHAR(10);
		SET @MEXEC = @MEXEC+'	,PLANT_ID	'										  + CHAR(10);
	
		SET @MEXEC = @MEXEC+'WITH ROLLUP'										  + CHAR(10);
		SET @MEXEC = @MEXEC+'ORDER BY GROUPING(DIVISION_ID) DESC, DIVISION_ID, (CASE WHEN OPERATION_GROUP_ID=''E'' THEN ''A'' WHEN OPERATION_GROUP_ID=''A'' THEN ''E'' ELSE OPERATION_GROUP_ID END), GROUPING(SITE_ID) DESC, SITE_ID, GROUPING(PLANT_ID) DESC'+ CHAR(10);

		EXEC(@MEXEC);
	END;
	
	-----------------------------------------------------------	
	-- DEBUG
	-----------------------------------------------------------
	IF( @debug_mode ='T')
		BEGIN				
			DECLARE @POS INT =1;
			DECLARE @LEN INT =LEN(@MEXEC);
			WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@MEXEC,@POS,4000);
					SET @POS = @POS+4000;
				END;
		END;

	------------------------------------------------------------
	--	임시테이블 삭제
	------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TMP_SCP0049_TARGET_ITEM') IS NOT NULL
		DROP TABLE #TMP_SCP0049_TARGET_ITEM
		;




END

