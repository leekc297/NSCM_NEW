
/*



	DECLARE  @p_plan_start_yyyymmdd_A	NVARCHAR(8) = '20220207'
			, @p_plan_start_yyyymmdd_B	NVARCHAR(8) = '20220124'
			, @p_plan_type_A			NVARCHAR(10) = 'FN'
			, @p_plan_type_B			NVARCHAR(10) = 'MA'
			, @p_seq_A					NVARCHAR(10) = '1'
			, @p_seq_B					NVARCHAR(10) = '1'
			, @p_division_id			NVARCHAR(20) = '82'
			, @p_biz_type				NVARCHAR(10) ='P'
			, @p_team_id				NVARCHAR(4000)  = ''
			, @p_project_code			NVARCHAR(1000) = ''
			, @p_item_id				NVARCHAR(MAX) = ''
			, @p_electype				NVARCHAR(100)	= ''
			, @p_measure_list			NVARCHAR(100) = 'MKT_FCST,ALLOCATION'
			, @p_from_yyyymmdd			NVARCHAR(8) = '20220124'
			, @p_to_yyyymmdd			NVARCHAR(8) = '20220510'
			, @p_user_id				NVARCHAR(100) = 'khj79'
			, @debug_mode				CHAR(1) = 'T'

*/

 /*
 * Program ID   : SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL
 * Description  : RTF Analysis Report POPUP
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/02/14   khj79		Initial PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 최초작성
 * 2022/02/14   khj79		from , to 날짜 설정
 * 2022/02/15   khj79		기준 테이블 생성
 * 2022.05.13   LSC			PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2022.05.31   vadabi3     Measure 구분 없이 조회 되는 이슈 조치
 * 2022.05.31   vadabi3     p_measure_list = PROD_PLAN_ENGINE / MODEL_INVENTORY 조회 안 되는 이슈 조치
 * 2023.04.10   LWY         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 ====================================================================================================
 */

CREATE PROCEDURE [dbo].[SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL]
	 @p_plan_start_yyyymmdd_A	NVARCHAR(8)
	,@p_plan_start_yyyymmdd_B	NVARCHAR(8)
	,@p_plan_type_A				NVARCHAR(10)
	,@p_plan_type_B				NVARCHAR(10)
	,@p_seq_A					NVARCHAR(10)
	,@p_seq_B					NVARCHAR(10)
	,@p_division_id				NVARCHAR(20)
	,@p_biz_type				NVARCHAR(20)
	,@p_project_code			NVARCHAR(20)
	,@p_item_id					NVARCHAR(1000)
	,@p_electype				NVARCHAR(100)=''
	,@p_measure_list			NVARCHAR(1000)
	,@p_from_yyyymmdd			NVARCHAR(8)
	,@p_to_yyyymmdd				NVARCHAR(8)
	,@p_version_id				NVARCHAR(max)
	,@p_user_id					NVARCHAR(100)
	,@debug_mode				CHAR(1)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- PARAMETER -> 변수 설정
	DECLARE @v_plan_start_yyyymmdd_A	NVARCHAR(8)		= @p_plan_start_yyyymmdd_A;
	DECLARE @v_plan_start_yyyymmdd_B	NVARCHAR(8)		= @p_plan_start_yyyymmdd_A;
	DECLARE @v_division_id				NVARCHAR(50)	= @p_division_id;
	DECLARE @v_user_id					NVARCHAR(100)	= @p_user_id;
	DECLARE @v_debug_mode				NVARCHAR(1)		= @debug_mode;
	
	DECLARE @v_program_id				NVARCHAR(10)	= 'SCP0079';
	DECLARE @v_sheet_name				NVARCHAR(50)	= 'RTF Analysis Main';

	-- debug 변수 설정
	DECLARE @POS INT = 0;
	DECLARE @LEN INT = 0;

	DECLARE @V_INDEX INT = 0;

	DECLARE @mEXEC NVARCHAR(MAX); -- DYNAMIC QUERY 변수 설정

	
	-- COLOMN 순서대로 조회
	DECLARE @COL NVARCHAR(100) = '';
	DECLARE @SORT_METHOD_CODE NVARCHAR(20) = '';

	DECLARE @v_RSLT_FLAG_A		NVARCHAR(1) = 'Y';
	DECLARE @v_RSLT_FLAG_B		NVARCHAR(1) = 'Y';
	DECLARE @v_from_yyyymmdd_A	NVARCHAR(8);
	DECLARE @v_to_yyyymmdd_A	NVARCHAR(8);
	DECLARE @v_from_result_A	NVARCHAR(8);
	DECLARE @v_to_result_A		NVARCHAR(8);

	DECLARE @v_from_yyyymmdd_B	NVARCHAR(8);
	DECLARE @v_to_yyyymmdd_B	NVARCHAR(8);
	DECLARE @v_from_result_B	NVARCHAR(8);
	DECLARE @v_to_result_B		NVARCHAR(8);
	DECLARE @v_min_yyyymmdd_A   NVARCHAR(8); -- 이력(HIST) 테이블 조회 날짜 설정
	DECLARE @v_min_yyyymmdd_B   NVARCHAR(8); -- 이력(HIST) 테이블 조회 날짜 설정
	DECLARE @v_measure_list	    NVARCHAR(1000) -- 20220531 추가


	SET @v_measure_list =  @p_measure_list;
	if @p_measure_list = 'PROD_PLAN_ENGINE' or @p_measure_list = 'MODEL_INVENTORY'
	begin
		SET @v_measure_list =  '';
	end

	SET @v_from_yyyymmdd_A = '';
	SET @v_to_yyyymmdd_A   = '';
	SET @v_from_result_A   = '';
	SET @v_to_result_A     = '';


	/* VERSION A 의 날짜 설정 */
	SELECT @v_from_yyyymmdd_A = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK) 
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd_A

	SELECT @v_from_result_A = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK) 
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd; 

	SELECT @v_to_result_A = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK) 
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_to_yyyymmdd; 
  
	 IF @v_from_yyyymmdd_A > @v_from_result_A
		  BEGIN -- 실적 보여줌		  
		  SET @v_to_yyyymmdd_A   = @p_to_yyyymmdd;
		  SET @v_to_result_A     = @v_from_yyyymmdd_A;
		  END;
	  ELSE IF @v_from_yyyymmdd_A <= @v_from_result_A
		  BEGIN -- 실적 없음
		  
		  SET @v_RSLT_FLAG_A = 'N';  -- 2021/07/21 // 계획만 조회
		  
		  SET @v_to_yyyymmdd_A		= @p_to_yyyymmdd;
		  SET @v_from_result_A		= CONVERT(CHAR(8), DATEADD(MM, 6, convert(datetime,@v_plan_start_yyyymmdd_A)), 112);
		  SET @v_to_result_A		= CONVERT(CHAR(8), DATEADD(MM, -6, convert(datetime,@v_plan_start_yyyymmdd_A)), 112)
		  END;
	  ELSE IF @v_from_yyyymmdd_A > @v_to_result_A
		  BEGIN
		  SET @v_from_yyyymmdd_A	= CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@v_plan_start_yyyymmdd_A)), 112);
		  SET @v_to_yyyymmdd_A		= CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@v_plan_start_yyyymmdd_A)), 112);
		  SET @v_from_result_A		= @p_from_yyyymmdd;
		  SET @v_to_result_A		= @p_to_yyyymmdd;
		  END;
	  ELSE IF @v_from_yyyymmdd_A = @v_to_result_A
		  BEGIN
		  SET @v_to_yyyymmdd_A	= @v_from_yyyymmdd_A;
		  SET @v_from_result_A	= @p_from_yyyymmdd;
		  SET @v_to_result_A	= @p_to_yyyymmdd;
		  END;
	
	/* VERSION A 의 날짜 설정 */
	SELECT @v_from_yyyymmdd_A = C.BASIS_START_DATE
	  FROM [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK) 
	 WHERE C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd_A;

	SELECT @v_from_result_A = C.BASIS_START_DATE
	  FROM [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK) 
	 WHERE C.BASIS_YYYYMMDD = @p_from_yyyymmdd; 

	SELECT @v_to_result_A = C.BASIS_START_DATE
	  FROM [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK) 
	 WHERE C.BASIS_YYYYMMDD = @p_to_yyyymmdd; 
  
	IF @v_from_yyyymmdd_A > @v_from_result_A
	BEGIN -- 실적 보여줌		  
		SET @v_to_yyyymmdd_A   = @p_to_yyyymmdd;
		SET @v_to_result_A     = @v_from_yyyymmdd_A;
	END;
	ELSE IF @v_from_yyyymmdd_A <= @v_from_result_A
	BEGIN -- 실적 없음
		  
		SET @v_RSLT_FLAG_A = 'N';  -- 2021/07/21 // 계획만 조회
		  
		SET @v_to_yyyymmdd_A	= @p_to_yyyymmdd;
		SET @v_from_result_A	= CONVERT(CHAR(8), DATEADD(MM,  6, convert(datetime,@p_plan_start_yyyymmdd_A)), 112);
		SET @v_to_result_A		= CONVERT(CHAR(8), DATEADD(MM, -6, convert(datetime,@p_plan_start_yyyymmdd_A)), 112);
	END;
	ELSE IF @v_from_yyyymmdd_A > @v_to_result_A
	BEGIN
		SET @v_from_yyyymmdd_A	= CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd_A)), 112);
		SET @v_to_yyyymmdd_A	= CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd_A)), 112);
		SET @v_from_result_A	= @p_from_yyyymmdd;
		SET @v_to_result_A		= @p_to_yyyymmdd;
	END;
	ELSE IF @v_from_yyyymmdd_A = @v_to_result_A
	BEGIN
		SET @v_to_yyyymmdd_A	= @v_from_yyyymmdd_A;
		SET @v_from_result_A	= @p_from_yyyymmdd;
		SET @v_to_result_A		= @p_to_yyyymmdd;
	END;
	
	-- VERSION B 의 날짜 설정
	SELECT @v_from_yyyymmdd_B = C.BASIS_START_DATE
	  FROM [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK) 
	 WHERE 1 = 1
	   AND C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd_B;

	SELECT @v_from_result_B = C.BASIS_START_DATE
	  FROM [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK) 
	 WHERE C.BASIS_YYYYMMDD = @p_from_yyyymmdd; 

	SELECT @v_to_result_B = C.BASIS_START_DATE
	  FROM [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK) 
	 WHERE C.BASIS_YYYYMMDD = @p_to_yyyymmdd; 
  
	 IF @v_from_yyyymmdd_B > @v_from_result_B
		  BEGIN -- 실적 보여줌		  
		  SET @v_to_yyyymmdd_B		= @p_to_yyyymmdd;
		  SET @v_to_result_B		= @v_from_yyyymmdd_B;
		  END;
	  ELSE IF @v_from_yyyymmdd_B <= @v_from_result_B
		  BEGIN -- 실적 없음
		  
		  SET @v_RSLT_FLAG_B = 'N';  -- 2021/07/21 // 계획만 조회
		  
		  SET @v_to_yyyymmdd_B		= @p_to_yyyymmdd;
		  SET @v_from_result_B		= CONVERT(CHAR(8), DATEADD(MM,  6, convert(datetime,@p_plan_start_yyyymmdd_B)), 112);
		  SET @v_to_result_B		= CONVERT(CHAR(8), DATEADD(MM, -6, convert(datetime,@p_plan_start_yyyymmdd_B)), 112);
		  END;
	  ELSE IF @v_from_yyyymmdd_B > @v_to_result_B
		  BEGIN
		  SET @v_from_yyyymmdd_B	= CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd_B)), 112);
		  SET @v_to_yyyymmdd_B		= CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd_B)), 112);
		  SET @v_from_result_B		= @p_from_yyyymmdd;
		  SET @v_to_result_B		= @p_to_yyyymmdd;
		  END;
	  ELSE IF @v_from_yyyymmdd_B = @v_to_result_B
		  BEGIN
		  SET @v_to_yyyymmdd_B		= @v_from_yyyymmdd_B;
		  SET @v_from_result_B		= @p_from_yyyymmdd;
		  SET @v_to_result_B		= @p_to_yyyymmdd;
		  END;

	IF @debug_mode ='T'
		BEGIN
			PRINT '----------------------------------';
			PRINT 'v_from_yyyymmdd_A	=' +@v_from_yyyymmdd_A;
			PRINT 'v_to_yyyymmdd_A		=' +@v_to_yyyymmdd_A;
			PRINT 'v_from_result_A		=' +@v_from_result_A;
			PRINT 'v_to_result_A		=' +@v_to_result_A	;
			PRINT 'v_RSLT_FLAG_A		=' +@v_RSLT_FLAG_A	;
			PRINT '----------------------------------';
			PRINT 'v_from_yyyymmdd_B	=' +@v_from_yyyymmdd_B;
			PRINT 'v_to_yyyymmdd_B		=' +@v_to_yyyymmdd_B;
			PRINT 'v_from_result_B		=' +@v_from_result_B;
			PRINT 'v_to_result_B		=' +@v_to_result_B	;
			PRINT 'v_RSLT_FLAG_B		=' +@v_RSLT_FLAG_B	;
			PRINT '----------------------------------';
		END;

	-- 실적 날짜 설정
	DECLARE @v_real_from_result	NVARCHAR(8) = '';
	DECLARE @v_real_to_result	NVARCHAR(8) = '';
	IF ( @v_RSLT_FLAG_A = 'Y' AND @v_RSLT_FLAG_B = 'Y')
	BEGIN
		SET @v_real_from_result = IIF(@v_from_result_A	> @v_from_result_B	, @v_from_result_B , @v_from_result_A);
		SET @v_real_to_result	= IIF(@v_to_result_A	> @v_to_result_B	, @v_to_result_A	, @v_to_result_B);
	END
	ELSE IF ( @v_RSLT_FLAG_A = 'Y' AND @v_RSLT_FLAG_B = 'N')
	BEGIN
		SET @v_real_from_result = @v_from_result_A;
		SET @v_real_to_result	= @v_to_result_A
	END
	ELSE IF ( @v_RSLT_FLAG_A = 'N' AND @v_RSLT_FLAG_B = 'Y')
	BEGIN
		SET @v_real_from_result = @v_from_result_B;
		SET @v_real_to_result	= @v_to_result_B
	END

	IF @debug_mode ='T'
		BEGIN
			PRINT '----------------------------------';
			PRINT 'v_real_from_result	=' +@v_real_from_result;
			PRINT 'v_real_to_result		=' +@v_real_to_result;
		END

	SELECT @v_min_yyyymmdd_A = MIN_YYYYMMDD FROM [dbo].[FN_GET_SCP_PLAN_MIN_DATE](@v_program_id, @p_division_id, @p_plan_type_A, @p_biz_type, @p_seq_A);
	SELECT @v_min_yyyymmdd_A = MIN_YYYYMMDD FROM [dbo].[FN_GET_SCP_PLAN_MIN_DATE](@v_program_id, @p_division_id, @p_plan_type_B, @p_biz_type, @p_seq_B);

	/********************************************************************************
	* MEASURE DATA 생성
	********************************************************************************/
	IF OBJECT_ID('tempdb..#tmp_SCP0079_MEASURE') IS NOT NULL
		DROP TABLE #tmp_SCP0079_MEASURE;

	SELECT COLUMN_NAME
		 , COLUMN_LABEL_NAME
		 , SORT_ORDER_NO
		 , ATTRIBUTE3		AS MEASURE_COLOR
	  INTO #tmp_SCP0079_MEASURE
	  FROM SCM_MST_SHEET_MEASURE A WITH(NOLOCK)
	 WHERE PROGRAM_ID	= @v_program_id
	   AND SHEET_NAME	= @v_sheet_name
	   AND VALID_YN		= 'Y'

	/********************************************************************************
	* 임시테이블만들기 - 조회 기준 데이터
	********************************************************************************/
	IF OBJECT_ID('tempdb..#tmp_SCP0079_FG_VER_A') IS NOT NULL
		DROP TABLE #tmp_SCP0079_FG_VER_A;
	
	SELECT A.PLAN_START_YYYYMMDD
		 , A.PLAN_TYPE
		 , A.SEQ
		 , A.DIVISION_ID
		 , A.BIZ_TYPE
		 , A.PROJECT_CODE
		 , A.ITEM_ID
		 , A.TO_SITE
		 , A.FROM_SITE
		 , A.INCOTERMS
		 , A.BOD_ID
		 , A.MEASURE
		 , A.PLAN_START_YYYYMMDD		AS VERSION_ID
		 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
		 , SUM(A.QTY)					AS QTY
		 , 'FG'							AS DATA_GUBUN
		 , 1							AS DATA_GUBUN_ORDER
	  INTO #tmp_SCP0079_FG_VER_A
	  FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
	  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
	    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
     WHERE PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_A
	   AND PLAN_TYPE			= @p_plan_type_A
       AND SEQ					= @p_seq_A
       AND DIVISION_ID			= @p_division_id
	   AND MEASURE IN ('MKT_FCST','ALLOCATION','WH_IN','SHIP_REQ','SHIP_PLAN')
	   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
	   --AND (( @p_measure_list	IS NULL OR @p_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_measure_list	, ',')))
	   AND YYYYMMDD >= @v_from_yyyymmdd_A
	   AND YYYYMMDD <= @v_to_yyyymmdd_A
	   AND YYYYMMDD <= @v_to_yyyymmdd_A

	 GROUP BY A.PLAN_START_YYYYMMDD
		 , A.PLAN_TYPE
		 , A.SEQ
		 , A.DIVISION_ID
		 , A.BIZ_TYPE
		 , A.PROJECT_CODE
		 , A.ITEM_ID
		 , A.TO_SITE
		 , A.INCOTERMS
		 , A.FROM_SITE
		 , A.BOD_ID
		 , A.MEASURE
		 , (B.BASIS_YYYYMM + B.ISO_WEEK )
	;

	IF OBJECT_ID('tempdb..#tmp_SCP0079_FG_VER_B') IS NOT NULL
		DROP TABLE #tmp_SCP0079_FG_VER_B;


	SELECT A.PLAN_START_YYYYMMDD
		 , A.PLAN_TYPE
		 , A.SEQ
		 , A.DIVISION_ID
		 , A.BIZ_TYPE
		 , A.PROJECT_CODE
		 , A.ITEM_ID
		 , A.TO_SITE
		 , A.FROM_SITE
		 , A.INCOTERMS
		 , A.BOD_ID
		 , A.MEASURE
		 , A.PLAN_START_YYYYMMDD		AS VERSION_ID
		 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
		 , SUM(A.QTY)					AS QTY
		 , 'FG'							AS DATA_GUBUN
		 , 3							AS DATA_GUBUN_ORDER
	  INTO #tmp_SCP0079_FG_VER_B
	  FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
	  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
	    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
     WHERE PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_B
	   AND PLAN_TYPE			= @p_plan_type_B
       AND SEQ					= @p_seq_B
       AND DIVISION_ID			= @p_division_id
	   AND MEASURE IN ('MKT_FCST','ALLOCATION','WH_IN','SHIP_REQ','SHIP_PLAN')
	   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
	   AND (( @v_measure_list	IS NULL OR @v_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_measure_list	, ',')))
	   AND YYYYMMDD >= @v_from_yyyymmdd_B
	   AND YYYYMMDD <= @v_to_yyyymmdd_B

	 GROUP BY A.PLAN_START_YYYYMMDD
		 , A.PLAN_TYPE
		 , A.SEQ
		 , A.DIVISION_ID
		 , A.BIZ_TYPE
		 , A.PROJECT_CODE
		 , A.ITEM_ID
		 , A.TO_SITE
		 , A.INCOTERMS
		 , A.FROM_SITE
		 , A.BOD_ID
		 , A.MEASURE
		 , (B.BASIS_YYYYMM + B.ISO_WEEK )
	;


	/********************************************************************************
	* PLAN(Pack Plan) TABLE 생성
	*		MEASURE    : PROD_PLAN_ENGINE
	*		원본 테이블 : SCP_ANL_PRODUCTION_PLAN
	*		결과 테이블 : #tmp_SCP0079_PLAN_VER_A, #tmp_SCP0079_PLAN_VER_B
	********************************************************************************/
	BEGIN
		IF OBJECT_ID('tempdb..#tmp_SCP0079_PLAN_VER_A') IS NOT NULL
			DROP TABLE #tmp_SCP0079_PLAN_VER_A;

		SELECT A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP			AS BIZ_TYPE
			 , '-'							AS PROJECT_CODE
			 , A.ITEM_ID
			 , 'TOTAL'						AS TO_SITE
			 , 'TOTAL'						AS FROM_SITE			
			 , '-'							AS INCOTERMS
			 , '-'							AS BOD_ID
			 , A.MEASURE					AS MEAUSRE
			 , A.PLAN_START_YYYYMMDD		AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
			 , SUM(A.QTY)					AS QTY
			 , 'PROD'						AS DATA_GUBUN
			 , 2							AS DATA_GUBUN_ORDER
		  INTO #tmp_SCP0079_PLAN_VER_A
		  FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
		    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
		  JOIN ( SELECT DISTINCT
					    DIVISION_ID
					  , BIZ_TYPE
					  , ITEM_ID
					  , YYYYMMDD
				   FROM #tmp_SCP0079_FG_VER_A
				) C
			ON A.DIVISION_ID		= C.DIVISION_ID
		   AND A.OPERATION_GROUP	= C.BIZ_TYPE
		   AND A.ITEM_ID			= C.ITEM_ID
		   AND C.YYYYMMDD			= B.BASIS_YYYYMM + B.ISO_WEEK
		  
		 WHERE A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_A
		   AND A.PLAN_TYPE				= @p_plan_type_A
		   AND A.SEQ					= @p_seq_A
		   AND A.DIVISION_ID			= @p_division_id
		   AND A.MEASURE				= 'PROD_PLAN_ENGINE'
		   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
		   AND (( @v_measure_list	IS NULL OR @v_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_measure_list	, ',')))
	       AND A.YYYYMMDD >= @v_from_yyyymmdd_A
		   AND A.YYYYMMDD <= @v_to_yyyymmdd_A

		 GROUP BY A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP
			 , A.ITEM_ID
			 , A.ORIGIN_DIVISION_ID
			 , A.MEASURE
			 , (B.BASIS_YYYYMM + B.ISO_WEEK )
		;


		IF OBJECT_ID('tempdb..#tmp_SCP0079_PLAN_VER_B') IS NOT NULL
			DROP TABLE #tmp_SCP0079_PLAN_VER_B;

		SELECT A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP			AS BIZ_TYPE
			 , '-'							AS PROJECT_CODE
			 , A.ITEM_ID
			 , 'TOTAL'						AS TO_SITE
			 , 'TOTAL'						AS FROM_SITE			
			 , '-'							AS INCOTERMS
			 , '-'							AS BOD_ID
			 , A.MEASURE					AS MEAUSRE
			 , A.PLAN_START_YYYYMMDD		AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
			 , SUM(A.QTY)					AS QTY
			 , 'PROD'						AS DATA_GUBUN
			 , 2							AS DATA_GUBUN_ORDER
		  INTO #tmp_SCP0079_PLAN_VER_B
		  FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
		    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
		  JOIN ( SELECT DISTINCT
					    DIVISION_ID
					  , BIZ_TYPE
					  , ITEM_ID
					  , YYYYMMDD 
				   FROM #tmp_SCP0079_FG_VER_B
				) C
			ON A.DIVISION_ID		= C.DIVISION_ID
		   AND A.OPERATION_GROUP	= C.BIZ_TYPE
		   AND A.ITEM_ID			= C.ITEM_ID
		   AND C.YYYYMMDD			= B.BASIS_YYYYMM + B.ISO_WEEK
		 WHERE A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_B
		   AND A.PLAN_TYPE				= @p_plan_type_B
		   AND A.SEQ					= @p_seq_B
		   AND A.DIVISION_ID			= @p_division_id
		   AND A.MEASURE				= 'PROD_PLAN_ENGINE'
		   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
		   --AND (( @p_measure_list	IS NULL OR @p_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_measure_list	, ',')))
		   AND A.YYYYMMDD >= @v_from_yyyymmdd_B
		   AND A.YYYYMMDD <= @v_to_yyyymmdd_B

		 GROUP BY A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP
			 , A.ITEM_ID
			 , A.ORIGIN_DIVISION_ID
			 , A.MEASURE
			 , (B.BASIS_YYYYMM + B.ISO_WEEK )
		;
	END --//PLAN(Pack Plan) TABLE 생성



	/********************************************************************************
	* PLAN(GLOBAL) TABLE 생성 : 20220531 추가
	*		MEASURE    : MODEL_INVENTORY
	*		원본 테이블 : SCP_ANL_PSI_GLOBAL
	*		결과 테이블 : #tmp_SCP0079_PLAN_VER_A, #tmp_SCP0079_PLAN_VER_B
	********************************************************************************/
	BEGIN
		IF OBJECT_ID('tempdb..#tmp_SCP0079_PLAN_VER_AA') IS NOT NULL
			DROP TABLE #tmp_SCP0079_PLAN_VER_AA;

		SELECT A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP			AS BIZ_TYPE
			 , '-'							AS PROJECT_CODE
			 , A.ITEM_ID
			 , 'TOTAL'						AS TO_SITE
			 , 'TOTAL'						AS FROM_SITE			
			 , '-'							AS INCOTERMS
			 , '-'							AS BOD_ID
			 , A.MEASURE					AS MEAUSRE
			 , A.PLAN_START_YYYYMMDD		AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
			 , SUM(A.QTY)					AS QTY
			 , 'PROD'						AS DATA_GUBUN
			 , 2							AS DATA_GUBUN_ORDER
		  INTO #tmp_SCP0079_PLAN_VER_AA
		  FROM SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
		    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
		  JOIN ( SELECT DISTINCT
					    DIVISION_ID
					  , BIZ_TYPE
					  , ITEM_ID
					  , YYYYMMDD
				   FROM #tmp_SCP0079_FG_VER_A
				) C
			ON A.DIVISION_ID		= C.DIVISION_ID
		   AND A.OPERATION_GROUP	= C.BIZ_TYPE
		   AND A.ITEM_ID			= C.ITEM_ID
		   AND C.YYYYMMDD			= B.BASIS_YYYYMM + B.ISO_WEEK
		  
		 WHERE A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_A
		   AND A.PLAN_TYPE				= @p_plan_type_A
		   AND A.SEQ					= @p_seq_A
		   AND A.DIVISION_ID			= @p_division_id
		   AND A.MEASURE				= 'MODEL_INVENTORY'
		   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
		   AND (( @p_measure_list	IS NULL OR @p_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_measure_list	, ',')))
		   AND A.YYYYMMDD >= @v_from_yyyymmdd_A
		   AND A.YYYYMMDD <= @v_to_yyyymmdd_A

		 GROUP BY A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP
			 , A.ITEM_ID
			 --, A.ORIGIN_DIVISION_ID
			 , A.MEASURE
			 , (B.BASIS_YYYYMM + B.ISO_WEEK )
		;


		IF OBJECT_ID('tempdb..#tmp_SCP0079_PLAN_VER_BB') IS NOT NULL
			DROP TABLE #tmp_SCP0079_PLAN_VER_BB;

		SELECT A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP			AS BIZ_TYPE
			 , '-'							AS PROJECT_CODE
			 , A.ITEM_ID
			 , 'TOTAL'						AS TO_SITE
			 , 'TOTAL'						AS FROM_SITE			
			 , '-'							AS INCOTERMS
			 , '-'							AS BOD_ID
			 , A.MEASURE					AS MEAUSRE
			 , A.PLAN_START_YYYYMMDD		AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
			 , SUM(A.QTY)					AS QTY
			 , 'PROD'						AS DATA_GUBUN
			 , 2							AS DATA_GUBUN_ORDER
		  INTO #tmp_SCP0079_PLAN_VER_BB
		  FROM SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
		    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
		  JOIN ( SELECT DISTINCT
					    DIVISION_ID
					  , BIZ_TYPE
					  , ITEM_ID
					  , YYYYMMDD 
				   FROM #tmp_SCP0079_FG_VER_B
				) C
			ON A.DIVISION_ID		= C.DIVISION_ID
		   AND A.OPERATION_GROUP	= C.BIZ_TYPE
		   AND A.ITEM_ID			= C.ITEM_ID
		   AND C.YYYYMMDD			= B.BASIS_YYYYMM + B.ISO_WEEK
		 WHERE A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_B
		   AND A.PLAN_TYPE				= @p_plan_type_B
		   AND A.SEQ					= @p_seq_B
		   AND A.DIVISION_ID			= @p_division_id
		   AND A.MEASURE				= 'MODEL_INVENTORY'
		   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
		   AND (( @p_measure_list	IS NULL OR @p_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_measure_list	, ',')))
		   AND A.YYYYMMDD >= @v_from_yyyymmdd_B
		   AND A.YYYYMMDD <= @v_to_yyyymmdd_B

		 GROUP BY A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP
			 , A.ITEM_ID
			 --, A.ORIGIN_DIVISION_ID
			 , A.MEASURE
			 , (B.BASIS_YYYYMM + B.ISO_WEEK )
		;


	END --//PLAN(GLOBAL) TABLE 생성



	/********************************************************************************
	* 실적 임시 테이블 생성
	*			RTF(ALLOCATION , SHIP_PLAN) 생성
	********************************************************************************/
	IF(@v_RSLT_FLAG_A = 'Y' OR @v_RSLT_FLAG_B = 'Y')
	BEGIN
		BEGIN
			IF OBJECT_ID('tempdb..#tmp_SCP0079_PLAN_RESULT') IS NOT NULL
				DROP TABLE #tmp_SCP0079_PLAN_RESULT;


			WITH RESULT_ERP_C_EXIST AS 
			(
				-- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
				SELECT E.DIVISION_ID			AS DIVISION_ID
					 , E.CONFIRM_ID				AS CONFIRM_ID
					 , E.ORDER_NO				AS ERP_SO_NO 
					 , E.EXFACTORY_DATE			AS YYYYMMDD
					 , E.TRANSPORT_MODE			AS TRANSPORT_MODE
					 , E.INCOTERMS				AS INCOTERMS
					 , E.ETA_DATE				AS ETA_DATE
					 , E.ETD_DATE				AS ETD_DATE
					 , E.PROJECT_CODE			AS PROJECT_CODE
					 , SUM(E.EXFACTORY_QTY )	AS RESULT_QTY
				  FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
				   AND L.VALID_YN = 'Y'
				   AND L.SEGMENT1    = E.SSP_TYPE

				 WHERE 1=1
				   AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
				   AND E.CONFIRM_ID LIKE 'C%'
				   AND E.EXFACTORY_DATE	 >= convert(datetime, @v_real_from_result)
				   AND E.EXFACTORY_DATE	 < convert(datetime, @v_real_to_result )
				
				 GROUP BY E.DIVISION_ID 
						, E.CONFIRM_ID
						, E.ORDER_NO
						, E.EXFACTORY_DATE
						, E.TRANSPORT_MODE
						, E.INCOTERMS		
						, E.ETA_DATE		
						, E.ETD_DATE
						, E.PROJECT_CODE
		)
			, RESULT_ERP_C_NON AS 
			(
				-- ERP 출하실적에서 CONFIRM_ID 없는 실적 
				SELECT  E.DIVISION_ID             AS DIVISION_ID
					  , '-'                       AS CONFIRM_ID
					  , E.ORDER_NO				  AS ERP_SO_NO 
					  , E.FROM_SCM_SITE_ID        AS FROM_SITE
					  , ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     AS TO_SITE   
					  , E.ITEM_ID                 AS ITEM_ID
					  , E.EXFACTORY_DATE          AS YYYYMMDD
					  , E.TRANSPORT_MODE		  AS TRANSPORT_MODE
					  , E.INCOTERMS				  AS INCOTERMS
					  ,	E.ETA_DATE				  AS ETA_DATE
					  ,	E.ETD_DATE				  AS ETD_DATE
					  , E.PROJECT_CODE            AS PROJECT_CODE
					  , SUM(E.EXFACTORY_QTY )     AS QTY  
				FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
				  ON F.ITEM_ID = E.ITEM_ID 
				 AND F.DIVISION_ID = E.DIVISION_ID
				JOIN SCM_MST_SITE FS WITH(NOLOCK)
				  ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
				 AND FS.DIVISION_ID = E.DIVISION_ID
				LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
				  ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
				  AND L3.SEGMENT1    = E.DIVISION_ID 
				  AND L3.SEGMENT2    = E.SOLDTO_CODE
				  AND L3.SEGMENT3    = E.SHIPTO_CODE					    
				WHERE 1=1
				  AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
				  AND ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
				  AND E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외
				  AND E.STORAGE_ID NOT IN (SELECT SEGMENT1 
											 FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
											WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
											  AND VALID_YN = 'Y'
										  )	-- 사외 창고 제외 LOOKUP 관리
				  AND E.ORDER_TYPE_CODE NOT IN (SELECT SEGMENT1 
												  FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
												 WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE'
												   AND VALID_YN = 'Y'
												)	-- ERP오더타입 제외 LOOKUP 관리

				  AND E.EXFACTORY_DATE	 >= convert(datetime, @v_real_from_result)
				  AND E.EXFACTORY_DATE	 < convert(datetime, @v_real_to_result )

				GROUP BY E.DIVISION_ID
						, E.ORDER_NO
						, E.FROM_SCM_SITE_ID
						, ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) 
						, E.ITEM_ID
						, E.EXFACTORY_DATE
						, E.TRANSPORT_MODE
						, E.INCOTERMS
						, E.ETA_DATE
						, E.ETD_DATE
						, E.PROJECT_CODE
			)
			-- 20220106 PJ20209643 소형 OSP Pack Item 처리
			, PLAN_SSP AS  
			(   -- SSP출하계획 ( confirm된 계획) 
				SELECT C.DIVISION_ID    AS DIVISION_ID
					 , C.ERP_SO_NO      AS ERP_SO_NO
					 , C.CONFIRM_ID     AS CONFIRM_ID 
					 , CASE WHEN ISNULL(fi.packer_plan_item_id, '') = '' THEN C.ITEM_ID
					 		ELSE fi.packer_plan_item_id
						END item_id
					 , C.FROM_SITE      AS FROM_SITE 
					 , C.TO_SITE        AS TO_SITE 
					 , CASE WHEN C.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')
					 		ELSE ISNULL(TS.END_CUSTOMER,'-')
					    END				AS END_CUSTOMER  
					 , C.QTY			AS QTY 
					 , C.YYYYMMDD		AS YYYYMMDD 
					 , C.TRANSPORT_MODE	AS TRANSPORT_MODE
					 , C.INCOTERMS		AS INCOTERMS
					 , C.BOD_ID			AS BOD_ID
					 , NULL				AS SHIP_TYPE
				  FROM [DBO].[SSP_ANL_SHIP_CONFIRM] C WITH(NOLOCK)	--SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
				  LEFT JOIN [dbo].[SCM_MST_SITE_ITEM] SI WITH(NOLOCK)	--SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
				    ON SI.DIVISION_ID	= C.DIVISION_ID
				   AND SI.ITEM_ID		= C.ITEM_ID 
				   AND SI.SCM_SITE_ID	= C.TO_SITE
				   AND SI.PROJECT_CODE	= C.PROJECT_CODE 
 				  LEFT JOIN [dbo].[SCM_MST_SITE] TS WITH(NOLOCK)	--SCM_MST_SITE TS WITH(NOLOCK) 
					ON TS.DIVISION_ID	= C.DIVISION_ID
				   AND TS.SCM_SITE_ID	= C.TO_SITE

				  LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
					ON C.division_id	= fi.division_id
				   AND C.item_id		= fi.item_id 
				   AND fi.division_id = '40' 
				 WHERE CHANGE_TYPE = 'C'
				   AND QTY > 0
				   AND C.BIZ_TYPE = @p_biz_type 
				   AND C.DIVISION_ID = @p_division_id
					AND C.YYYYMMDD >=	@v_real_from_result
					AND C.YYYYMMDD <	@v_real_to_result
			)

			SELECT X.DIVISION_ID
				 , MS.COMPANY_ID	AS COMPANY_ID
				 , L.SEGMENT2		AS TYPE 
				 , X.ERP_SO_NO
				 , X.CONFIRM_ID 
				 , X.ITEM_ID 
				 , DBO.FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
				 , X.FROM_SITE		AS FROM_SITE 
				 , X.TO_SITE		AS TO_SITE
				 , X.QTY 
				 , X.YYYYMMDD		AS YYYYMMDD 
				 --, X.TRANSPORT_MODE
				 , X.INCOTERMS
				 , X.BOD_ID
				 , X.SHIP_TYPE
				 , X.PROJECT_CODE

			INTO #tmp_SCP0079_PLAN_RESULT

			FROM (
					--CONFIRM_ID ,날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 
					SELECT P.DIVISION_ID		AS DIVISION_ID
						 , 'E'					AS TYPE
						 , R.ERP_SO_NO			AS ERP_SO_NO
						 , R.CONFIRM_ID			AS CONFIRM_ID 
						 , P.ITEM_ID			AS ITEM_ID
						 , P.FROM_SITE			AS FROM_SITE 
						 , P.TO_SITE			AS TO_SITE
						 , SUM(R.RESULT_QTY)	AS QTY 
						 , R.YYYYMMDD			AS YYYYMMDD
						 --, R.TRANSPORT_MODE  AS TRANSPORT_MODE
						 , R.INCOTERMS			AS INCOTERMS
						 , P.BOD_ID				AS BOD_ID
						 , NULL					AS SHIP_TYPE
						 , R.PROJECT_CODE		AS PROJECT_CODE
					  FROM PLAN_SSP P 
					  JOIN RESULT_ERP_C_EXIST R 
					    ON R.DIVISION_ID	= P.DIVISION_ID
					   AND R.CONFIRM_ID		= P.CONFIRM_ID
					   AND R.YYYYMMDD		= P.YYYYMMDD

					 GROUP BY P.DIVISION_ID
							, R.ERP_SO_NO
							, P.FROM_SITE
							, P.TO_SITE
							, P.ITEM_ID
							--, R.TRANSPORT_MODE
							, R.INCOTERMS
							, P.BOD_ID
							, R.YYYYMMDD 
							, R.CONFIRM_ID
							, R.PROJECT_CODE

					UNION ALL 

					--CONFIRM_ID ,기준으로 날짜가 다른 계획정보의 FROM, TO SITE기준으로 실적 집계
					SELECT P.DIVISION_ID		AS DIVISION_ID
						 , 'E'					AS TYPE 
						 , R.ERP_SO_NO			AS ERP_SO_NO
						 , R.CONFIRM_ID			AS CONFIRM_ID 
						 , P.ITEM_ID			AS ITEM_ID 
						 , P.FROM_SITE			AS FROM_SITE 
						 , P.TO_SITE			AS TO_SITE 
						 , SUM(R.RESULT_QTY)	AS QTY 
						 , R.YYYYMMDD			AS YYYYMMDD 
						 --, R.TRANSPORT_MODE  AS TRANSPORT_MODE
						 , R.INCOTERMS			AS INCOTERMS
						 , P.BOD_ID				AS BOD_ID
						 , NULL					AS SHIP_TYPE
						 , R.PROJECT_CODE		AS PROJECT_CODE
					  FROM PLAN_SSP P 
					  JOIN RESULT_ERP_C_EXIST R 
						ON R.DIVISION_ID	= P.DIVISION_ID 
					   AND R.CONFIRM_ID		= P.CONFIRM_ID 
					   AND R.YYYYMMDD		<> P.YYYYMMDD 
					 GROUP BY P.DIVISION_ID
							, R.ERP_SO_NO
							, P.FROM_SITE
							, P.TO_SITE 
							, P.ITEM_ID 
							--, R.TRANSPORT_MODE
							, R.INCOTERMS
							, P.BOD_ID
							, R.YYYYMMDD 
							, R.CONFIRM_ID
							, R.PROJECT_CODE

					UNION ALL 

					--CONFIRM_ID 없는 실적 
					SELECT R.DIVISION_ID	AS DIVISION_ID
						 , 'E'				AS TYPE 
						 , R.ERP_SO_NO		AS ERP_SO_NO
						 , NULL				AS CONFIRM_ID 
						 , R.ITEM_ID		AS ITEM_ID 
						 , R.FROM_SITE		AS FROM_SITE 
						 , R.TO_SITE		AS TO_SITE 
						 , R.QTY			AS QTY 
						 , R.YYYYMMDD		AS YYYYMMDD 
						 --, R.TRANSPORT_MODE	AS TRANSPORT_MODE
						 , R.INCOTERMS		AS INCOTERMS
						 , MB.BOD_ID		AS BOD_ID
						 , NULL				AS SHIP_TYPE
						 , R.PROJECT_CODE	AS PROJECT_CODE
					  FROM RESULT_ERP_C_NON R
					  JOIN SCP_MST_BOD_V AS MB
					    ON R.DIVISION_ID	= MB.DIVISION_ID
					   AND R.FROM_SITE		= MB.FROM_SITE
					   AND R.TO_SITE		= MB.TO_SITE
					   AND R.INCOTERMS		= MB.INCOTERMS
					   AND R.TRANSPORT_MODE	= MB.TRANSPORT_MODE
				) X
			JOIN SCM_MST_SITE MS WITH(NOLOCK) 
			  ON MS.DIVISION_ID = X.DIVISION_ID 
			 AND MS.SCM_SITE_ID = X.FROM_SITE  
			 AND MS.OPERATION_GROUP <> 'E'
		
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
			  ON L.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE' -- LOOKUP에 등록된 공정만 
			 AND L.SEGMENT1 = X.TYPE 
			 AND L.VALID_YN = 'Y'
			LEFT JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
			  ON  M.DIVISION_ID		= X.DIVISION_ID 
			 AND M.FROM_SITE		= X.FROM_SITE 
			 AND M.ITEM_ID			= X.ITEM_ID 
			 AND M.VALID_YN			= 'Y'
			WHERE 1=1
			  AND X.DIVISION_ID = @p_division_id
			  AND X.TYPE = 'E'  -- Result(ERP)
		END

		BEGIN
			IF OBJECT_ID('tempdb..#tmp_SCP0079_RTF_RESULT') IS NOT NULL
				DROP TABLE #tmp_SCP0079_RTF_RESULT;

			SELECT DIVISION_ID
				 , SCM_SITE_ID		AS TO_SITE
				 , PROJECT_CODE
				 , ITEM_ID
				 , INCOTERMS
				 , YYYYMMDD
				 , QTY
			  INTO #tmp_SCP0079_RTF_RESULT
			  FROM DM_PLN_MKT_FCST_RESULT WITH(NOLOCK)
			 WHERE DIVISION_ID = @P_DIVISION_ID
			   AND YYYYMMDD >= @v_real_from_result
			   AND YYYYMMDD <  @v_real_to_result	-- 금주월요일 이전 ( 계획구간 데이터는 안들어있음 )
			   AND MEASURE = 'RTF_SYS_RP'
			   AND QTY <> 0
		END

	END


	/********************************************************************************
	* 실적 TABLE 생성
	********************************************************************************/
	-- 실적 데이터
	IF(@v_RSLT_FLAG_A = 'Y' )
	BEGIN 

		INSERT INTO #tmp_SCP0079_FG_VER_A
		SELECT @p_plan_start_yyyymmdd_A		AS PLAN_START_YYYYMMDD
			 , @p_plan_type_A				AS PLAN_TYPE
			 , @p_seq_A						AS SEQ
			 , DIVISION_ID
			 , @p_biz_type
			 , A.PROJECT_CODE
			 , A.ITEM_ID
			 , A.TO_SITE
			 , A.FROM_SITE
			 , A.INCOTERMS
			 , A.BOD_ID
			 , 'SHIP_PLAN'					AS MEASURE
			 , @p_plan_start_yyyymmdd_A		AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK 	AS YYYYMMDD
			 , SUM(QTY)						AS QTY
			 , 'FG'							AS DATA_GUBUN
			 , 1							AS DATA_GUBUN_ORDER
		  FROM #tmp_SCP0079_PLAN_RESULT A
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
			ON A.YYYYMMDD	= B.BASIS_YYYYMMDD

		  JOIN (SELECT DISTINCT ITEM_ID , PROJECT_CODE
				  FROM #tmp_SCP0079_FG_VER_A
				) C
			ON A.ITEM_ID		= C.ITEM_ID
		   AND A.PROJECT_CODE	= C.PROJECT_CODE
		 WHERE A.YYYYMMDD		>= @v_from_result_A
		   AND A.YYYYMMDD		<  @v_to_result_A
		 GROUP BY A.DIVISION_ID
				, A.PROJECT_CODE
				, A.ITEM_ID
				, A.TO_SITE
				, A.FROM_SITE
				, A.INCOTERMS
				, A.BOD_ID
				, B.BASIS_YYYYMM + B.ISO_WEEK
		;

		INSERT INTO #tmp_SCP0079_FG_VER_A
		SELECT @p_plan_start_yyyymmdd_A		AS PLAN_START_YYYYMMDD
			 , @p_plan_type_A				AS PLAN_TYPE
			 , @p_seq_A						AS SEQ
			 , DIVISION_ID
			 , @p_biz_type
			 , A.PROJECT_CODE
			 , A.ITEM_ID
			 , A.TO_SITE
			 , '-'							AS FROM_SITE
			 , A.INCOTERMS
			 , '-'							AS BOD_ID
			 , 'ALLOCATION'					AS MEASURE
			 , @p_plan_start_yyyymmdd_A		AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK 	AS YYYYMMDD
			 , SUM(QTY)						AS QTY
			 , 'FG'							AS DATA_GUBUN
			 , 1							AS DATA_GUBUN_ORDER
		  FROM #tmp_SCP0079_RTF_RESULT A
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
			ON A.YYYYMMDD	= B.BASIS_YYYYMMDD

		  JOIN (SELECT DISTINCT ITEM_ID , PROJECT_CODE
				  FROM #tmp_SCP0079_FG_VER_A
				) C
			ON A.ITEM_ID		= C.ITEM_ID
		   AND A.PROJECT_CODE	= C.PROJECT_CODE
		 WHERE A.YYYYMMDD		>= @v_from_result_A
		   AND A.YYYYMMDD		<  @v_to_result_A
		 GROUP BY A.DIVISION_ID
				, A.PROJECT_CODE
				, A.ITEM_ID
				, A.TO_SITE
				, A.INCOTERMS
				, B.BASIS_YYYYMM + B.ISO_WEEK
		;
	END
	
	IF(@v_RSLT_FLAG_B = 'Y')
	BEGIN
		INSERT INTO #tmp_SCP0079_FG_VER_B
		SELECT @p_plan_start_yyyymmdd_A		AS PLAN_START_YYYYMMDD
			 , @p_plan_type_A				AS PLAN_TYPE
			 , @p_seq_A						AS SEQ
			 , DIVISION_ID
			 , @p_biz_type
			 , A.PROJECT_CODE
			 , A.ITEM_ID
			 , A.TO_SITE
			 , A.FROM_SITE
			 , A.INCOTERMS
			 , A.BOD_ID
			 , 'SHIP_PLAN'					AS MEASURE
			 , @p_plan_start_yyyymmdd_A		AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK 	AS YYYYMMDD
			 , SUM(QTY)						AS QTY
			 , 'FG'							AS DATA_GUBUN
			 , 3							AS DATA_GUBUN_ORDER
		  FROM #tmp_SCP0079_PLAN_RESULT A
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
			ON A.YYYYMMDD	= B.BASIS_YYYYMMDD

		  JOIN (SELECT DISTINCT ITEM_ID , PROJECT_CODE
				  FROM #tmp_SCP0079_FG_VER_B
				) C
			ON A.ITEM_ID		= C.ITEM_ID
		   AND A.PROJECT_CODE	= C.PROJECT_CODE
		 WHERE A.YYYYMMDD		>= @v_from_result_B
		   AND A.YYYYMMDD		<  @v_to_result_B
		 GROUP BY A.DIVISION_ID
				, A.PROJECT_CODE
				, A.ITEM_ID
				, A.TO_SITE
				, A.FROM_SITE
				, A.INCOTERMS
				, A.BOD_ID
				, B.BASIS_YYYYMM + B.ISO_WEEK
		;

		INSERT INTO #tmp_SCP0079_FG_VER_B
		SELECT @p_plan_start_yyyymmdd_A		AS PLAN_START_YYYYMMDD
			 , @p_plan_type_A				AS PLAN_TYPE
			 , @p_seq_A						AS SEQ
			 , DIVISION_ID
			 , @p_biz_type
			 , A.PROJECT_CODE
			 , A.ITEM_ID
			 , A.TO_SITE
			 , '-'							AS FROM_SITE
			 , A.INCOTERMS
			 , '-'							AS BOD_ID
			 , 'ALLOCATION'					AS MEASURE
			 , @p_plan_start_yyyymmdd_A		AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK 	AS YYYYMMDD
			 , SUM(QTY)						AS QTY
			 , 'FG'							AS DATA_GUBUN
			 , 3							AS DATA_GUBUN_ORDER
		  FROM #tmp_SCP0079_RTF_RESULT A
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
			ON A.YYYYMMDD	= B.BASIS_YYYYMMDD

		  JOIN (SELECT DISTINCT ITEM_ID , PROJECT_CODE
				  FROM #tmp_SCP0079_FG_VER_B
				) C
			ON A.ITEM_ID		= C.ITEM_ID
		   AND A.PROJECT_CODE	= C.PROJECT_CODE
		 WHERE A.YYYYMMDD		>= @v_from_result_B
		   AND A.YYYYMMDD		<  @v_to_result_B
		 GROUP BY A.DIVISION_ID
				, A.PROJECT_CODE
				, A.ITEM_ID
				, A.TO_SITE
				, A.INCOTERMS
				, B.BASIS_YYYYMM + B.ISO_WEEK
		;
	END





	

    /********************************************************************************
	* 20220613 GAP > PLAN(Pack Plan) TABLE 생성
	*		MEASURE    : PROD_PLAN_ENGINE
	*		원본 테이블 : SCP_ANL_PRODUCTION_PLAN
	*		결과 테이블 : #tmp_SCP0079_PLAN_VER_A, #tmp_SCP0079_PLAN_VER_B
	********************************************************************************/
    BEGIN
		INSERT INTO #tmp_SCP0079_PLAN_VER_A
		SELECT 'GAP' AS PLAN_START_YYYYMMDD
			 , 'GAP' AS PLAN_TYPE
			 , 99999 AS SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP			AS BIZ_TYPE
			 , '-'							AS PROJECT_CODE
			 , A.ITEM_ID
			 , 'TOTAL'						AS TO_SITE
			 , 'TOTAL'						AS FROM_SITE	
			 , '-'							AS INCOTERMS
			 , '-'							AS BOD_ID
			 , A.MEASURE					AS MEAUSRE
			 , 'GAP'           		        AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
			 , SUM(A.QTY)					AS QTY
			 , 'GAP'						AS DATA_GUBUN
			 , 50							AS DATA_GUBUN_ORDER
		  FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
		    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
		  JOIN ( SELECT DISTINCT
					    DIVISION_ID
					  , BIZ_TYPE
					  , ITEM_ID
					  , YYYYMMDD
				   FROM #tmp_SCP0079_FG_VER_A
				) C
			ON A.DIVISION_ID		= C.DIVISION_ID
		   AND A.OPERATION_GROUP	= C.BIZ_TYPE
		   AND A.ITEM_ID			= C.ITEM_ID
		   AND C.YYYYMMDD			= B.BASIS_YYYYMM + B.ISO_WEEK
		  
		 WHERE A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_A
		   AND A.PLAN_TYPE				= @p_plan_type_A
		   AND A.SEQ					= @p_seq_A
		   AND A.DIVISION_ID			= @p_division_id
		   AND A.MEASURE				= 'PROD_PLAN_ENGINE'
		   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
		   AND (( @v_measure_list	IS NULL OR @v_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_measure_list	, ',')))
	       AND A.YYYYMMDD >= @v_from_yyyymmdd_A
		   AND A.YYYYMMDD <= @v_to_yyyymmdd_A

		 GROUP BY A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP
			 , A.ITEM_ID
			 , A.ORIGIN_DIVISION_ID
			 , A.MEASURE
			 , (B.BASIS_YYYYMM + B.ISO_WEEK )
		;


		INSERT INTO #tmp_SCP0079_PLAN_VER_B
		SELECT 'GAP' AS PLAN_START_YYYYMMDD
			 , 'GAP' AS PLAN_TYPE
			 , 99999 AS SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP			AS BIZ_TYPE
			 , '-'							AS PROJECT_CODE
			 , A.ITEM_ID
			 , 'TOTAL'						AS TO_SITE
			 , 'TOTAL'						AS FROM_SITE	
			 , '-'							AS INCOTERMS
			 , '-'							AS BOD_ID
			 , A.MEASURE					AS MEAUSRE
			 , 'GAP'           		        AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
			 , SUM(A.QTY)					AS QTY
			 , 'GAP'						AS DATA_GUBUN
			 , 51							AS DATA_GUBUN_ORDER
		  FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
		    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
		  JOIN ( SELECT DISTINCT
					    DIVISION_ID
					  , BIZ_TYPE
					  , ITEM_ID
					  , YYYYMMDD 
				   FROM #tmp_SCP0079_FG_VER_B
				) C
			ON A.DIVISION_ID		= C.DIVISION_ID
		   AND A.OPERATION_GROUP	= C.BIZ_TYPE
		   AND A.ITEM_ID			= C.ITEM_ID
		   AND C.YYYYMMDD			= B.BASIS_YYYYMM + B.ISO_WEEK
		 WHERE A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_B
		   AND A.PLAN_TYPE				= @p_plan_type_B
		   AND A.SEQ					= @p_seq_B
		   AND A.DIVISION_ID			= @p_division_id
		   AND A.MEASURE				= 'PROD_PLAN_ENGINE'
		   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
		   --AND (( @p_measure_list	IS NULL OR @p_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_measure_list	, ',')))
		   AND A.YYYYMMDD >= @v_from_yyyymmdd_B
		   AND A.YYYYMMDD <= @v_to_yyyymmdd_B

		 GROUP BY A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP
			 , A.ITEM_ID
			 , A.ORIGIN_DIVISION_ID
			 , A.MEASURE
			 , (B.BASIS_YYYYMM + B.ISO_WEEK )
		;
	END --//PLAN(Pack Plan) TABLE 생성








	/********************************************************************************
	* 20220613 GAP > Pack Inv.(EOH) TABLE 생성
	*		MEASURE    : MODEL_INVENTORY
	*		원본 테이블 : SCP_ANL_PSI_GLOBAL
	*		결과 테이블 : #tmp_SCP0079_GLOBAL_VER_A, #tmp_SCP0079_GLOBAL_VER_B
	********************************************************************************/
	BEGIN
		INSERT INTO #tmp_SCP0079_PLAN_VER_AA
		SELECT 'GAP' AS PLAN_START_YYYYMMDD
			 , 'GAP' AS PLAN_TYPE
			 , 99999 AS SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP			AS BIZ_TYPE
			 , '-'							AS PROJECT_CODE
			 , A.ITEM_ID
			 , 'TOTAL'						AS TO_SITE
			 , 'TOTAL'						AS FROM_SITE
			 , '-'							AS INCOTERMS
			 , '-'							AS BOD_ID			 
			 , MEASURE
			 , 'GAP'						AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
			 , SUM(A.QTY)					AS QTY
			 , 'GAP'						AS DATA_GUBUN
			 , 52							AS DATA_GUBUN_ORDER
		  FROM SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
		    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
		  JOIN ( SELECT DISTINCT
					    DIVISION_ID
					  , BIZ_TYPE
					  , ITEM_ID
					  , YYYYMMDD
				   FROM #tmp_SCP0079_FG_VER_A
				) C
			ON A.DIVISION_ID		= C.DIVISION_ID
		   AND A.OPERATION_GROUP	= C.BIZ_TYPE
		   AND A.ITEM_ID			= C.ITEM_ID
		   AND C.YYYYMMDD			= B.BASIS_YYYYMM + B.ISO_WEEK
		  
		 WHERE A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_A
		   AND A.PLAN_TYPE				= @p_plan_type_A
		   AND A.SEQ					= @p_seq_A
		   AND A.DIVISION_ID			= @p_division_id
		   AND A.MEASURE				= 'MODEL_INVENTORY'
		   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
		   AND (( @p_measure_list	IS NULL OR @p_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_measure_list	, ',')))
		   AND A.YYYYMMDD >= @v_from_yyyymmdd_A
		   AND A.YYYYMMDD <= @v_to_yyyymmdd_A

		 GROUP BY A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP
			 , A.ITEM_ID
			 --, A.ORIGIN_DIVISION_ID
			 , A.MEASURE
			 , (B.BASIS_YYYYMM + B.ISO_WEEK )
		;


		INSERT INTO #tmp_SCP0079_PLAN_VER_BB
		SELECT 'GAP' AS PLAN_START_YYYYMMDD
			 , 'GAP' AS PLAN_TYPE
			 , 99999 AS SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP			AS BIZ_TYPE
			 , '-'							AS PROJECT_CODE
			 , A.ITEM_ID
			 , 'TOTAL'						AS TO_SITE
			 , 'TOTAL'						AS FROM_SITE
			 , '-'							AS INCOTERMS
			 , '-'							AS BOD_ID			 
			 , MEASURE
			 , 'GAP'						AS VERSION_ID
			 , B.BASIS_YYYYMM + B.ISO_WEEK	AS YYYYMMDD
			 , SUM(A.QTY)					AS QTY
			 , 'GAP'						AS DATA_GUBUN
			 , 53							AS DATA_GUBUN_ORDER
		  FROM SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)
		  JOIN SCM_SYS_CALENDAR_M B	WITH(NOLOCK)
		    ON A.YYYYMMDD		= B.BASIS_YYYYMMDD
		  JOIN ( SELECT DISTINCT
					    DIVISION_ID
					  , BIZ_TYPE
					  , ITEM_ID
					  , YYYYMMDD 
				   FROM #tmp_SCP0079_FG_VER_B
				) C
			ON A.DIVISION_ID		= C.DIVISION_ID
		   AND A.OPERATION_GROUP	= C.BIZ_TYPE
		   AND A.ITEM_ID			= C.ITEM_ID
		   AND C.YYYYMMDD			= B.BASIS_YYYYMM + B.ISO_WEEK
		 WHERE A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd_B
		   AND A.PLAN_TYPE				= @p_plan_type_B
		   AND A.SEQ					= @p_seq_B
		   AND A.DIVISION_ID			= @p_division_id
		   AND A.MEASURE				= 'MODEL_INVENTORY'
		   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID	= @p_item_id )
		   AND (( @p_measure_list	IS NULL OR @p_measure_list	='') OR A.MEASURE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_measure_list	, ',')))
		   AND A.YYYYMMDD >= @v_from_yyyymmdd_B
		   AND A.YYYYMMDD <= @v_to_yyyymmdd_B

		 GROUP BY A.PLAN_START_YYYYMMDD
			 , A.PLAN_TYPE
			 , A.SEQ
			 , A.DIVISION_ID
			 , A.OPERATION_GROUP
			 , A.ITEM_ID
			 --, A.ORIGIN_DIVISION_ID
			 , A.MEASURE
			 , (B.BASIS_YYYYMM + B.ISO_WEEK )
		;

	END




















	IF OBJECT_ID('tempdb..#tmp_SCP0079_FG_GAP') IS NOT NULL
		DROP TABLE #tmp_SCP0079_FG_GAP;
		
	SELECT 'GAP'	AS PLAN_START_YYYYMMDD
		 , 'GAP'	AS PLAN_TYPE
		 , 99999	AS SEQ
		 , A.DIVISION_ID
		 , A.BIZ_TYPE
		 , A.PROJECT_CODE
		 , A.ITEM_ID
		 , A.TO_SITE
		 , A.FROM_SITE
		 , A.INCOTERMS
		 , A.BOD_ID
		 , A.MEASURE
		 , 'GAP'			AS VERSION_ID
		 , A.YYYYMMDD
		 , (A.QTY - B.QTY)	AS QTY
		 , 'GAP'			AS DATA_GUBUN
		 , 5				AS DATA_GUBUN_ORDER
	  INTO #tmp_SCP0079_FG_GAP
	  FROM #tmp_SCP0079_FG_VER_A A
	  FULL OUTER JOIN #tmp_SCP0079_FG_VER_B B
	    ON A.DIVISION_ID	= B.DIVISION_ID
	   AND A.BIZ_TYPE		= B.BIZ_TYPE
	   AND A.PROJECT_CODE	= B.PROJECT_CODE
	   AND A.ITEM_ID		= B.ITEM_ID
	   AND A.TO_SITE		= B.TO_SITE
	   AND A.FROM_SITE		= B.FROM_SITE
	   AND A.INCOTERMS		= B.INCOTERMS
	   AND A.BOD_ID			= B.BOD_ID
	   AND A.MEASURE		= B.MEASURE
	   AND A.YYYYMMDD		= B.YYYYMMDD
	;

	/********************************************************************************
	* 데이터 합치기
	********************************************************************************/

	IF OBJECT_ID('tempdb..#tmp_SCP0079_FG_PIVOT') IS NOT NULL
		DROP TABLE #tmp_SCP0079_FG_PIVOT;

	SELECT * 
	  INTO #tmp_SCP0079_FG_PIVOT
	  FROM #tmp_SCP0079_FG_VER_A
	 UNION ALL
	SELECT * FROM #tmp_SCP0079_FG_VER_B
	 UNION ALL
	SELECT * FROM #tmp_SCP0079_FG_GAP
	 UNION ALL
	SELECT * FROM #tmp_SCP0079_PLAN_VER_A
	 UNION ALL
	SELECT * FROM #tmp_SCP0079_PLAN_VER_B
	 UNION ALL
	SELECT * FROM #tmp_SCP0079_PLAN_VER_AA
	 UNION ALL
	SELECT * FROM #tmp_SCP0079_PLAN_VER_BB

	;

	BEGIN
		DECLARE @mQry_sum NVARCHAR(MAX);
		DECLARE @mDAY_QTY NVARCHAR(MAX);
		DECLARE @mQry_field NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성
		SET @mDAY_QTY='QTY';
		SET @mQry_sum = '';
		SET @mQry_field = '';


		SELECT TOP 1000 
				--@mQry_field = @mQry_field + ', ISNULL(' + yyyymmdd + ', 0) AS ' + yyyymmdd
				@mQry_field = @mQry_field + ', ' + yyyymmdd    
				, @mQry_sum = @mQry_sum+','+ 
		
				CASE WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN YYYYMMDD=RIGHT('''+yyyymmdd+''',8) THEN convert(numeric(15,2),'+@mDAY_QTY+')  ELSE 0 END   ) AS ' + yyyymmdd END +''+CHAR(10)
		  FROM (
				SELECT 'W_'+A.BASIS_YYYYMM + A.ISO_WEEK				AS YYYYMMDD
					 , A.BASIS_START_DATE + CONVERT(CHAR(2), 21)	AS SORT_ORDER_NO
				  FROM SCM_SYS_CALENDAR_M A
				 WHERE A.BASIS_YYYYMMDD >= @p_from_yyyymmdd
				   AND A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
				GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
				) AS A
			ORDER BY SORT_ORDER_NO  ;


	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'	SELECT																			' + CHAR(10);
	SET @mEXEC = @mEXEC+'			A.PLAN_START_YYYYMMDD													' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.PLAN_TYPE																' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.SEQ																	' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.VERSION_ID															' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.DIVISION_ID															' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.BIZ_TYPE																' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , dbo.FN_GET_LOOKUP_CODE_DESC(''BIZ_TYPE'', BIZ_TYPE) AS BIZ_TYPE_NAME	' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  ,(SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'')						' + CHAR(10);
	SET @mEXEC = @mEXEC+'			  FROM SCM_MST_ITEM_SN x WITH(NOLOCK)									' + CHAR(10);
	SET @mEXEC = @mEXEC+'			 WHERE X.ITEM_ID = A.ITEM_ID)	AS NICK_NAME							' + CHAR(10);
	-- FROM_YYYYMM 변경 필요 함
	SET @mEXEC = @mEXEC+' 		  , CAST( ROUND( dbo.FN_GET_SCP_ANL_BOH_QTY(A.DIVISION_ID ,A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.TO_SITE , A.ITEM_ID,'+@p_from_yyyymmdd + ') , 1) as int) as boh '+CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.PROJECT_CODE										' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , ISNULL(B.PROJECT_NAME, ''-'') PROJECT_NAME			' + CHAR(10);
	IF @p_division_id NOT IN ('EE','EE_UC')
		SET @mEXEC = @mEXEC+'	  , ISNULL(CASE WHEN A.DIVISION_ID <> ''40'' AND A.DIVISION_ID <> ''82'' THEN B.PROJECT_OWNER ELSE F.USER_NAME_EN END, ''-'') AS PROJECT_OWNER				' + CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'	  , ISNULL(CASE WHEN A.ORIGIN_TO_DIVISION_ID <> ''40'' AND A.DIVISION_ID <> ''82'' THEN B.PROJECT_OWNER ELSE F.USER_NAME_EN END, ''-'') AS PROJECT_OWNER	' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , CASE WHEN c.ITEM_TYPE IS NULL OR c.ITEM_TYPE = '''' THEN ''-'' ELSE dbo.FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', c.ITEM_TYPE) END ITEM_TYPE			' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , ISNULL(G.DEPT_NAME_KO, ''-'') DEPT_NAME_KO	' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.ITEM_ID									' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.TO_SITE									' + CHAR(10);
	IF @p_division_id NOT IN ('EE','EE_UC')
		SET @mEXEC = @mEXEC+'	  , (SELECT TOP 1 SITE_DESCRIPTION FROM SCM_MST_SITE WHERE SCM_SITE_ID = A.TO_SITE2) TO_SITE_NAME ' + CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+' 	  , TO_SITE AS TO_SITE_NAME								' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.INCOTERMS											' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , ISNULL(K.TRANSPORT_MODE,''-'')	AS TRANSPORT_MODE	' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , ISNULL(K.LT_TOTAL,''-'')		AS LT_DAY			' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.FROM_SITE											' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , ISNULL((SELECT TOP 1 SITE_DESCRIPTION from SCM_MST_SITE WHERE SCM_SITE_ID = A.FROM_SITE),''-'') FROM_SITE_NAME ' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.BOD_ID									' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.MEASURE									' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.DATA_GUBUN								' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , A.DATA_GUBUN_ORDER							' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , M.COLUMN_LABEL_NAME	AS MEASURE_LABEL		' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  , M.MEASURE_COLOR								' + CHAR(10);
	SET @mEXEC = @mEXEC+		  @mQry_field
	SET @mEXEC = @mEXEC+'	   FROM (									' + CHAR(10);
	SET @mEXEC = @mEXEC+'				SELECT	PLAN_START_YYYYMMDD		' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , PLAN_TYPE				' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , SEQ						' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , VERSION_ID				' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , DIVISION_ID				' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , BIZ_TYPE				' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , PROJECT_CODE			' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , ITEM_ID					' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , TO_SITE					' + CHAR(10);
	-- EE 를 위해 필요한 컬럼
	SET @mEXEC = @mEXEC+'					  , CASE WHEN RIGHT(TO_SITE,2) = ''-S'' THEN LEFT(TO_SITE , LEN(TO_SITE) - 2) ELSE TO_SITE END TO_SITE2	' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , INCOTERMS				' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , FROM_SITE				' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , BOD_ID					' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , MEASURE					' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , DATA_GUBUN				' + CHAR(10);
	SET @mEXEC = @mEXEC+'					  , DATA_GUBUN_ORDER		' + CHAR(10);
	SET @mEXEC = @mEXEC+					   @mQry_sum
	SET @mEXEC = @mEXEC+'				   FROM #tmp_SCP0079_FG_PIVOT	' + CHAR(10);
	SET @mEXEC = @mEXEC+'				  GROUP BY PLAN_START_YYYYMMDD	' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, PLAN_TYPE				' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, SEQ					' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, VERSION_ID			' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, DIVISION_ID			' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, BIZ_TYPE				' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, PROJECT_CODE			' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, ITEM_ID				' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, TO_SITE				' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, INCOTERMS				' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, FROM_SITE				' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, BOD_ID				' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, MEASURE				' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, DATA_GUBUN			' + CHAR(10);
	SET @mEXEC = @mEXEC+'						, DATA_GUBUN_ORDER		' + CHAR(10);
	SET @mEXEC = @mEXEC+'			) A									' + CHAR(10);

	SET @mEXEC = @mEXEC+'		JOIN #tmp_SCP0079_MEASURE M									' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  ON A.MEASURE	= M.COLUMN_NAME								' + CHAR(10);
	--  PROJECT 조인
	SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN (SELECT DIVISION_ID							' + CHAR(10);
	SET @mEXEC = @mEXEC+'						 , PROJECT_CODE								' + CHAR(10);
	SET @mEXEC = @mEXEC+'						 , PROJECT_NAME								' + CHAR(10);
	SET @mEXEC = @mEXEC+'						 , PROJECT_OWNER							' + CHAR(10);
	SET @mEXEC = @mEXEC+'						 , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE ORDER BY PROJECT_VER_SEQ ASC ) NUMS	'+CHAR(10);
	SET @mEXEC = @mEXEC+'					  FROM SCM_MST_PROJECT WITH(NOLOCK)				' + CHAR(10);
	SET @mEXEC = @mEXEC+'					) B  											' + CHAR(10);
	SET @mEXEC = @mEXEC+'		  ON A.PROJECT_CODE	= B.PROJECT_CODE 			' + CHAR(10);	
		SET @mEXEC = @mEXEC+'	 AND B.NUMS=1									' + CHAR(10);
	IF @p_division_id NOT IN ('EE','EE_UC')
		SET @mEXEC = @mEXEC+'	 AND A.DIVISION_ID	= B.DIVISION_ID 			' + CHAR(10);
	ELSE
		SET @MEXEC = @MEXEC+'	 AND A.ORIGIN_TO_DIVISION_ID = B.DIVISION_ID 	' + CHAR(10);
	-- PROJECT 조인 끝
	-- PROJECT OWNER 조인
	SET @mEXEC = @mEXEC+'	LEFT JOIN SCM_MST_SITE_ITEM E 						' + CHAR(10);
	--IF @p_division_id NOT IN ('EE','EE_UC')
	IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
	BEGIN
		SET @mEXEC = @mEXEC+'   ON E.DIVISION_ID	= A.DIVISION_ID 			' + CHAR(10);
		SET @mEXEC = @mEXEC+'  AND E.SCM_SITE_ID	= A.TO_SITE					' + CHAR(10);
	END
	ELSE
	BEGIN
		SET @mEXEC = @mEXEC+'   ON E.DIVISION_ID	= A.ORIGIN_TO_DIVISION_ID 	' + CHAR(10);
		SET @mEXEC = @mEXEC+'  AND E.SCM_SITE_ID	= A.TO_SITE2				' + CHAR(10);
	END
	SET @mEXEC = @mEXEC+'	   AND E.PROJECT_CODE	= A.PROJECT_CODE 			' + CHAR(10);
	SET @mEXEC = @mEXEC+'	   AND E.ITEM_ID		= A.ITEM_ID 				' + CHAR(10);
	SET @mEXEC = @mEXEC+'	   AND E.VALID_YN		=''Y'' 						' + CHAR(10);

	SET @mEXEC = @mEXEC+'	LEFT JOIN SCM_MST_SSO_USER_INFO F WITH(NOLOCK) 		' + CHAR(10);
	SET @mEXEC = @mEXEC+'	  ON SUBSTRING( E.OWNER, 0, CASE WHEN CHARINDEX('','',E.OWNER) = 0 THEN LEN(E.OWNER)+1 ELSE CHARINDEX('','',E.OWNER) END ) = F.USER_ID 	'+CHAR(10);
	-- PROJECT OWNER 조인

	-- ITEM TYPE 조인
	SET @mEXEC = @mEXEC+'   LEFT JOIN (SELECT DIVISION_ID									' + CHAR(10);
	SET @mEXEC = @mEXEC+'					, ITEM_ID										' + CHAR(10);
	SET @mEXEC = @mEXEC+'					, ITEM_NAME										' + CHAR(10);
	SET @mEXEC = @mEXEC+'					, NICK_NAME										' + CHAR(10);
	SET @mEXEC = @mEXEC+'					, ITEM_TYPE										' + CHAR(10);
	SET @mEXEC = @mEXEC+'					, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, ITEM_ID ORDER BY  CASE ITEM_TYPE WHEN ''P'' THEN 999 WHEN ''H'' THEN 888 WHEN ''R'' THEN 777  WHEN ''Q'' THEN 666 ELSE 0 END  DESC ) NUMS																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'				 FROM SCM_MST_ITEM_SN WITH(NOLOCK)					' + CHAR(10);
	SET @mEXEC = @mEXEC+'				) c  on a.item_id=c.item_id							'+CHAR(10);

	--IF @p_division_id NOT IN ('EE','EE_UC')
	IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
		SET @mEXEC = @mEXEC+'		AND A.DIVISION_ID=C.DIVISION_ID							'+CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'		AND A.ORIGIN_TO_DIVISION_ID=C.DIVISION_ID				'+CHAR(10);
	SET @mEXEC = @mEXEC+'				     and c.nums=1									'+CHAR(10);
	-- ITEM TYPE 조인 끝

	-- DEPT NAME 조인
	SET @mEXEC = @mEXEC+'	LEFT JOIN SCM_MST_SITE D 						'+CHAR(10);
	--IF @p_division_id NOT IN ('EE','EE_UC')
	IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
	BEGIN
		SET @mEXEC = @mEXEC+'	   ON D.DIVISION_ID	= A.DIVISION_ID 		'+CHAR(10);
		SET @mEXEC = @mEXEC+'	  AND D.SCM_SITE_ID	= A.TO_SITE 			'+CHAR(10);
	END
	ELSE
	BEGIN
		SET @mEXEC = @mEXEC+'	   ON D.DIVISION_ID	= A.ORIGIN_TO_DIVISION_ID 	'+CHAR(10);
		SET @mEXEC = @mEXEC+'	  AND D.SCM_SITE_ID	= A.TO_SITE2				'+CHAR(10);
	END
	SET @mEXEC = @mEXEC+'		  AND D.VALID_YN       = ''Y'' 					'+CHAR(10);

	SET @mEXEC = @mEXEC+'	LEFT JOIN SCM_MST_SSO_DEPT_INFO G WITH(NOLOCK) 		'+CHAR(10);
	--IF @p_division_id NOT IN ('EE','EE_UC')
	IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
		SET @mEXEC = @mEXEC+'	   ON  CASE WHEN A.DIVISION_ID = ''40'' THEN F.DEPT_ID ELSE D.DEPT_ID END  = G.DEPT_ID 				'+CHAR(10);
	ELSE 
		SET @mEXEC = @mEXEC+'	   ON  CASE WHEN A.ORIGIN_TO_DIVISION_ID = ''40'' THEN F.DEPT_ID ELSE D.DEPT_ID END  = G.DEPT_ID 	'+CHAR(10);
	-- DEPT NAME 조인 끝

	-- TRANS PORT MODE , LT_DAY 조인
	SET @mEXEC = @mEXEC+'	LEFT JOIN SCP_MST_BOD_V K			'+CHAR(10);
	SET @mEXEC = @mEXEC+'	  ON A.BOD_ID		= K.BOD_ID 		'+CHAR(10);
	
	-- 20220530 @p_measure_list 조회
	SET @mEXEC = @mEXEC+'	  WHERE A.MEASURE = '''+ @p_measure_list +'''		'+CHAR(10);
	-- 20220613 version_id 조회
	SET @mEXEC = @mEXEC+'	  AND A.VERSION_ID = '''+ @p_version_id +'''		'+CHAR(10);
	--SET @mEXEC = @mEXEC+'	  ORDER BY ITEM_ID ,VERSION_ID , TO_SITE , M.SORT_ORDER_NO	' + CHAR(10);
	SET @mEXEC = @mEXEC+'	  ORDER BY A.DIVISION_ID, A.BIZ_TYPE, A.ITEM_ID, A.TO_SITE,A.INCOTERMS, A.DATA_GUBUN_ORDER, G.DEPT_NAME_KO, A.VERSION_ID, M.SORT_ORDER_NO		' + CHAR(10);




	--DEBUG QRY 출력
	---------------------------------------------------------
	IF( @debug_mode ='T')
	BEGIN
		SET @POS =1;
		SET @LEN = LEN(@mEXEC);
		WHILE @POS <= @LEN
		BEGIN
			PRINT SUBSTRING(@mEXEC,@POS,4000);
			SET @POS = @POS+4000;
		END;
	END;
	---------------------------------------------------------

	EXEC (@mEXEC);

	END
END


  
