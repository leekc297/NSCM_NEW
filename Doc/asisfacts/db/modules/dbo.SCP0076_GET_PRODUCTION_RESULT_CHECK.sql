

/*
 * Program ID   : SCP0076_GET_PRODUCTION_RESULT_CHECK
 * Description  : 출하실적 점검 Report
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021.12.01   KDW			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 최초작성
 * 2021.12.29   khj79		[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 2021.12.28 : OSP_YN 추가
 * 2022.04.25   lwy		    [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - Shipping Result Check VOC 개선
 * 2022.12.19   hrkim		[PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 자동차 준수율/달성율 기준 변경 (FP Plan -> SCP Plan) 
 * 2022.12.20   hrkim		[PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회 Target Week 범위 처리 
 * 2023.05.12	hrkim		E20230503-000475 [소형SCM] GSCM Production Result Check 기능 개선 요청 
 *							- 전체 사업부 외주 packer 실적 추가 (외주 Packer명 참조 변경 (SCM_MST_SITE.SITE_DESCRIPTION))
 */
/*
 DECLARE	@return_value int
 EXEC	@return_value = [dbo].[SCP0076_GET_PRODUCTION_RESULT_CHECK]
		@p_plan_start_yyyymmdd = N'20211129',
		@p_division_id = N'81,40,82',
		@p_plant_id = N'A050,A010,A040,G388,G382,G451,G631,G634,G182,G184,G481,G671',
		@p_user_id = N'herokwon2',
		@debug_mode = N'F'

SELECT	'Return Value' = @return_value


DECLARE
	 @p_plan_start_yyyymmdd		NVARCHAR(8) = N'20211129'
	,@p_division_id				NVARCHAR(20)= N'81'
	,@p_plant_id				NVARCHAR(MAX)= N'A050,A010,A040,G388,G382,G451,G631,G634,G182,G184,G481,G671'
	,@p_user_id					NVARCHAR(100)=N'herokwon2'
	,@debug_mode				CHAR(1) = N'T'
*/
CREATE PROCEDURE [dbo].[SCP0076_GET_PRODUCTION_RESULT_CHECK]
	 @p_from_yyyymmdd			NVARCHAR(8)
	,@p_to_yyyymmdd				NVARCHAR(8)
	,@p_division_id				NVARCHAR(20)
	,@p_plant_id				NVARCHAR(MAX)
	,@p_user_id					NVARCHAR(100)
	,@debug_mode				CHAR(1) = ''
AS

BEGIN	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- PARAMETER -> 변수 설정
	DECLARE @v_from_yyyymmdd		NVARCHAR(8)	    = @p_from_yyyymmdd		-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  -- 조회 Target Week 범위 처리 
	DECLARE @v_to_yyyymmdd			NVARCHAR(8)	    = @p_to_yyyymmdd		-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  -- 조회 Target Week 범위 처리 
	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(8)		= @p_to_yyyymmdd		-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  -- 조회 Target Week 범위 처리 
	DECLARE @v_division_id			NVARCHAR(50)	= @p_division_id;
	DECLARE @v_plant_id				NVARCHAR(4000)	= @p_plant_id;
	DECLARE @v_user_id				NVARCHAR(100)	= @p_user_id;
	DECLARE @v_debug_mode			NVARCHAR(1)		= @debug_mode;
	
	DECLARE @v_program_id			NVARCHAR(10)	= 'SCP0076';
	DECLARE @v_sheet_name			NVARCHAR(50)	= 'Production Result Check';

	DECLARE @V_CNT_USR_COLUMN	int = 0;

	DECLARE @POS INT = 0;
	DECLARE @LEN INT = 0;

	SET @V_CNT_USR_COLUMN = (
								SELECT COUNT(1) 
								FROM SCM_MST_TITLESET_USER WITH(NOLOCK) 
								WHERE 1=1
								 AND PROGRAM_ID  =  @v_program_id
								 AND SHEET_NAME  =  @v_sheet_name
								 AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
								 AND USER_ID     =  @v_user_id
							  );
	DECLARE @V_INDEX INT = 0;

	DECLARE @mEXEC NVARCHAR(MAX);
	
	-- COLOMN 순서대로 조회
	DECLARE @COL NVARCHAR(100) = '';
	DECLARE @SORT_METHOD_CODE NVARCHAR(20) = '';

	DECLARE @v_plan_week_name	VARCHAR(10) = '';
	SELECT @v_plan_week_name = CALENDAR_YYYY + '-' +  WEEK_NAME  
	  FROM SCM_SYS_CALENDAR_M 
	 WHERE BASIS_YYYYMMDD = @v_plan_start_yyyymmdd
	;

	/********************************************************************************
	* 임시테이블만들기 - 조회 기준 데이터
	********************************************************************************/
	IF OBJECT_ID('tempdb..#tmp_SCP0076_STD') IS NOT NULL	
		DROP TABLE #tmp_SCP0076_STD;

	/*
		SELECT DISTINCT
			   DIVISION_ID
			 , CELL_TYPE_GR
			 , OPERATION_GROUP
			 , PLANT_ID
			 , MODEL_TYPE_GR
			 , ISNULL((SELECT OSP_YN 
						 FROM SCM_MST_SITE X1 WITH(NOLOCK)
						WHERE X1.DIVISION_ID	= A.DIVISION_ID
						  AND X1.PLANT_ID		= A.PLANT_ID
						  AND X1.VALID_YN		= 'Y'
						  AND X1.OSP_YN			= 'Y'
					),'N') AS OSP_YN
		  INTO #tmp_SCP0076_STD
		  FROM SCP_RPT_PRODUCTION A WITH(NOLOCK)
		 WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		   AND (( @v_division_id	IS NULL OR @v_division_id	='') OR A.DIVISION_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_division_id	, ',')))
		   AND (( @v_plant_id		IS NULL OR @v_plant_id		='') OR A.PLANT_ID  	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_plant_id		, ',')))

	SELECT DISTINCT
		    A.DIVISION_ID
		 ,  A.CELL_TYPE_GR
		 ,  A.OPERATION_GROUP
		 ,  A.PLANT_ID
		 ,  A.MODEL_TYPE_GR
		 , ISNULL((SELECT OSP_YN 
				     FROM SCM_MST_SITE X1 WITH(NOLOCK)
					WHERE X1.DIVISION_ID	= A.DIVISION_ID
					  AND X1.PLANT_ID		= A.PLANT_ID
					  AND X1.VALID_YN		= 'Y'
					  AND X1.OSP_YN			= 'Y'
				),'N') AS OSP_YN
         
		 , X1.COMPANY_ID
		 , V.ATTRIBUTE1 AS SCM_VENDOR_NAME  -- LWY

	  INTO #tmp_SCP0076_STD
	  FROM SCP_RPT_PRODUCTION A WITH(NOLOCK)
	  LEFT OUTER JOIN SCM_MST_SITE X1 WITH(NOLOCK)
	  LEFT OUTER JOIN SCM_MST_VENDOR V ON X1.PLANT_ID = V.VENDOR_CODE AND X1.COMPANY_ID = V.COMPANY_ID
	  ON  X1.DIVISION_ID	= A.DIVISION_ID
	  AND X1.PLANT_ID		= A.PLANT_ID
	  AND X1.VALID_YN		= 'Y'
	  AND X1.OSP_YN			= 'Y'

	 WHERE A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
	   AND (( @v_division_id	IS NULL OR @v_division_id	='') OR A.DIVISION_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_division_id	, ',')))
	   AND (( @v_plant_id		IS NULL OR @v_plant_id		='') OR A.PLANT_ID  	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_plant_id		, ',')))
	;

	*/

	--- 2022/12/20 변경 -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  -- 조회 Target Week 범위 처리 
	SELECT DISTINCT
		    A.DIVISION_ID
		 ,  D.DIVISION_NAME 
		 ,  A.CELL_TYPE_GR
		 ,  A.OPERATION_GROUP
		 ,  A.PLANT_ID
		 ,  CASE WHEN ISNULL(X1.OSP_YN, 'N') = 'N'
				 THEN (SELECT MAX(DESCRIPTION) 
						FROM SCM_PLANT_M_SN P WITH(NOLOCK) 
					   WHERE P.PLANT_ID = A.PLANT_ID)
				 WHEN ISNULL(V.ATTRIBUTE1, '') = ''	-- 2023.05.12 외주 packer명 참조 변경
				 THEN X1.SITE_DESCRIPTION 
				 ELSE V.ATTRIBUTE1  -- 외주 : SCM_VENDOR_NAME
			 END					AS PLANT_NAME 
		 ,  A.MODEL_TYPE_GR
		 , ISNULL(X1.OSP_YN, 'N')	AS OSP_YN
         , X1.COMPANY_ID
		 , V.ATTRIBUTE1				AS SCM_VENDOR_NAME  -- LWY
	  INTO #tmp_SCP0076_STD
	  FROM SCP_RPT_PRODUCTION A WITH(NOLOCK)
		   LEFT OUTER JOIN SCM_MST_DIVISION D WITH(NOLOCK)
				        ON D.DIVISION_ID  = A.DIVISION_ID
		   LEFT OUTER JOIN SCM_MST_SITE X1 WITH(NOLOCK)
					    ON X1.DIVISION_ID = A.DIVISION_ID
					   AND X1.PLANT_ID	  = A.PLANT_ID
					   AND X1.VALID_YN	  = 'Y'
					   AND X1.OSP_YN	  = 'Y'
		   LEFT OUTER JOIN SCM_MST_VENDOR V 
						ON V.COMPANY_ID  = X1.COMPANY_ID
					   AND V.VENDOR_CODE = X1.PLANT_ID

	 WHERE A.PLAN_START_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd  
	   AND (( @v_division_id	IS NULL OR @v_division_id	='') OR A.DIVISION_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_division_id	, ',')))
	   AND (( @v_plant_id		IS NULL OR @v_plant_id		='') OR A.PLANT_ID  	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_plant_id		, ',')))
	;


	/********************************************************************************
	* 임시테이블만들기 - DATA TABLE
	********************************************************************************/
	IF OBJECT_ID('tempdb..#tmp_SCP0076_DATA_OSP_YN') IS NOT NULL	
		DROP TABLE #tmp_SCP0076_DATA_OSP_YN;

	CREATE TABLE #tmp_SCP0076_DATA_OSP_YN
	(
		  PLAN_START_YYYYMMDD			VARCHAR(8)
		, PLAN_WEEK						VARCHAR(10)
		, DIVISION_ID					VARCHAR(10)
		, DIVISION_NAME					VARCHAR(100)	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  -- 조회 Target Week 범위 처리 
		, CELL_TYPE_GR					VARCHAR(10)
		, OPERATION_GROUP				VARCHAR(1)
		, OPERATION_GROUP_NAME			NVARCHAR(200)
		, PLANT_ID						NVARCHAR(30)
		, PLANT_NAME					NVARCHAR(200)	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  -- 조회 Target Week 범위 처리 
		, MODEL_TYPE_GR					NVARCHAR(100)

		, OSP_YN						NVARCHAR(1)
	    , COMPANY_ID 				    NVARCHAR(30)
		, SCM_VENDOR_NAME 				NVARCHAR(100)

		, PROD_PLAN_SCP					NUMERIC(20,10)
		, PROD_PLAN_FP					NUMERIC(20,10)
		, PROD_RESULT					NUMERIC(20,10)
		, PROD_RESULT_TOT				NUMERIC(20,10)
		, PROD_PLAN_SCP_CELL			NUMERIC(20,10)
		, PROD_PLAN_FP_CELL				NUMERIC(20,10)
		, PROD_RESULT_CELL				NUMERIC(20,10)
		, PROD_RESULT_TOT_CELL			NUMERIC(20,10)
		, PROD_PLAN_DEN					NUMERIC(20,10)	-- 2021.12.28 : OSP_YN 추가
		, PROD_PLAN_DEN_CELL			NUMERIC(20,10)	-- 2021.12.28 : OSP_YN 추가

		, REASON_CODE					NVARCHAR(30)
		, REASON_DESCRIPTION			NVARCHAR(300)
	)

	IF OBJECT_ID('tempdb..#tmp_SCP0076_DATA') IS NOT NULL	
		DROP TABLE #tmp_SCP0076_DATA;

	CREATE TABLE #tmp_SCP0076_DATA
	(
		  PLAN_START_YYYYMMDD			VARCHAR(8)
		, PLAN_WEEK						VARCHAR(10)
		, DIVISION_ID					VARCHAR(10)
		, DIVISION_NAME					VARCHAR(100)
		, CELL_TYPE_GR					VARCHAR(10)
		, OPERATION_GROUP				VARCHAR(1)
		, OPERATION_GROUP_NAME			NVARCHAR(200)
		, PLANT_ID						NVARCHAR(30)
		, PLANT_NAME					NVARCHAR(200)
		, MODEL_TYPE_GR					NVARCHAR(100)

		, PROD_PLAN_SCP					NUMERIC(20,10)
		, PROD_PLAN_FP					NUMERIC(20,10)
		, PROD_RESULT					NUMERIC(20,10)
		, PROD_RESULT_TOT				NUMERIC(20,10)
		, PROD_PLAN_SCP_CELL			NUMERIC(20,10)
		, PROD_PLAN_FP_CELL				NUMERIC(20,10)
		, PROD_RESULT_CELL				NUMERIC(20,10)
		, PROD_RESULT_TOT_CELL			NUMERIC(20,10)
		, PROD_PLAN_DEN					NUMERIC(20,10)	-- 2021.12.28 : OSP_YN 추가
		, PROD_PLAN_DEN_CELL			NUMERIC(20,10)	-- 2021.12.28 : OSP_YN 추가

		, CO_RATE						NUMERIC(20, 10) -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 
		, AC_RATE						NUMERIC(20, 10) -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리  
		, CO_RATE_CELL					NUMERIC(20, 10) -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리  
		, AC_RATE_CELL					NUMERIC(20, 10) -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 

		, REASON_CODE					NVARCHAR(30)
		, REASON_DESCRIPTION			NVARCHAR(300)
	)

	/********************************************************************************
	* 임시테이블만들기 - 선택 COLUMN
	********************************************************************************/  
 	IF OBJECT_ID('tempdb..#tmp_SCP0076_COLUMN') IS NOT NULL	
		DROP TABLE #tmp_SCP0076_COLUMN;

		SELECT A.COLUMN_NAME								AS COL
			 , ROW_NUMBER() OVER( ORDER BY ISNULL(B.SORT_ORDER_NO, A.SORT_ORDER_NO ) )	AS USER_SORT_ORDER_NO
			 , ISNULL(B.DATA_SORT_METHOD_CODE , A.DATA_SORT_METHOD_CODE ) AS DATA_SORT_METHOD_CODE
		  INTO #tmp_SCP0076_COLUMN
		  FROM SCM_MST_SHEET_COLUMNS A WITH(NOLOCK) 
		  
		  LEFT JOIN  SCM_MST_TITLESET_USER B WITH(NOLOCK) 
		    ON B.PROGRAM_ID  = A.PROGRAM_ID
		   AND B.SHEET_NAME  = A.SHEET_NAME
		   AND B.COLUMN_NAME = A.COLUMN_NAME
		   AND B.USER_ID	 = @v_user_id
		   AND B.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'

		 WHERE A.PROGRAM_ID	= @v_program_id
		   AND A.SHEET_NAME	= @v_sheet_name
		   AND A.VALID_YN		= 'Y'
		   AND A.VISIBLE_FLAG	= 'Y'
		   AND ISNULL(NULLIF(A.USER_SELECTABLE_FLAG,''),'Y') = 'Y'  -- COLUMN 설정 창에 보이는 것들만 조회
		   AND ( @V_CNT_USR_COLUMN = 0
					OR EXISTS (SELECT 1
							     FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
								WHERE PROGRAM_ID		= @v_program_id
								  AND SHEET_NAME		= @v_sheet_name
								  AND COLUMN_NAME		= A.COLUMN_NAME
								  AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
								  AND USER_ID			= @v_user_id
								)
				  )
			;
	
	/* 2022/12/20 아래 주석처리 [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 
	--insert into #tmp_SCP0076_COLUMN
	--select 'OSP_YN', (select max(user_sort_order_no) +1 from #tmp_SCP0076_COLUMN ), 'ASC'
	--union all
	--select 'COMPANY_ID', (select max(user_sort_order_no) +2 from #tmp_SCP0076_COLUMN ), 'ASC'
	--union all
	--select 'SCM_VENDOR_NAME', (select max(user_sort_order_no) +3 from #tmp_SCP0076_COLUMN ), 'ASC'
	--;
	*/

	SET @V_CNT_USR_COLUMN = (SELECT COUNT(1) FROM #tmp_SCP0076_COLUMN);

	/********************************************************************************
	* 임시테이블만들기 - 선택 COLUMN
	********************************************************************************/  
	INSERT INTO #tmp_SCP0076_DATA_OSP_YN

	SELECT A.PLAN_START_YYYYMMDD  -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 
		 , A.PLAN_WEEK			  -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 
		 , A.DIVISION_ID
		 , B.DIVISION_NAME		  -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  -- 조회 Target Week 범위 처리 
		 , A.CELL_TYPE_GR
		 , A.OPERATION_GROUP
		 , A.OPERATION_GROUP_NAME
		 , A.PLANT_ID
		 , B.PLANT_NAME			  -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  -- 조회 Target Week 범위 처리 
		 , A.MODEL_TYPE_GR
		 , B.OSP_YN
		 , B.COMPANY_ID
		 , B.SCM_VENDOR_NAME
		 --- START [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 
		 , SUM(PROD_PLAN_SCP		) AS PROD_PLAN_SCP		
		 , SUM(PROD_PLAN_FP			) AS PROD_PLAN_FP	
		 , SUM(PROD_RESULT			) AS PROD_RESULT				
		 , SUM(PROD_RESULT_TOT		) AS PROD_RESULT_TOT
		 , SUM(PROD_PLAN_SCP_CELL	) AS PROD_PLAN_SCP_CELL		
		 , SUM(PROD_PLAN_FP_CELL	) AS PROD_PLAN_FP_CELL	
		 , SUM(PROD_RESULT_CELL		) AS PROD_RESULT_CELL		
		 , SUM(PROD_RESULT_TOT_CELL	) AS PROD_RESULT_TOT_CELL	
		 , SUM(PROD_PLAN_SCP		) AS PROD_PLAN_DEN		
		 , SUM(PROD_PLAN_SCP_CELL	) AS PROD_PLAN_DEN_CELL
		 --- END   [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 
		 , MAX(REASON_CODE)			AS REASON_CODE
		 , MAX(REASON_DESCRIPTION)	AS REASON_DESCRIPTION
	 FROM SCP_RPT_PRODUCTION A WITH(NOLOCK)	

	 JOIN #tmp_SCP0076_STD	B							
	   ON A.DIVISION_ID		= B.DIVISION_ID 			
	  AND A.CELL_TYPE_GR	= B.CELL_TYPE_GR 			
	  AND A.OPERATION_GROUP	= B.OPERATION_GROUP 	
	  AND A.PLANT_ID		= B.PLANT_ID 				
	  AND A.MODEL_TYPE_GR	= B.MODEL_TYPE_GR

	WHERE A.PLAN_START_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd  --- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 
	  AND (( @v_division_id	IS NULL OR @v_division_id	='') OR A.DIVISION_ID	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_division_id	, ',')))
	  AND (( @v_plant_id	IS NULL OR @v_plant_id		='') OR A.PLANT_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_plant_id	, ',')))

	GROUP BY   A.PLAN_START_YYYYMMDD	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 
			 , A.PLAN_WEEK				-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
			 , A.DIVISION_ID
			 , B.DIVISION_NAME			-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리 
			 , A.CELL_TYPE_GR
			 , A.OPERATION_GROUP
			 , A.OPERATION_GROUP_NAME
			 , A.PLANT_ID
			 , B.PLANT_NAME				-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리  
			 , A.MODEL_TYPE_GR
			 , B.OSP_YN
			 , B.COMPANY_ID
			 , B.SCM_VENDOR_NAME
	;


	----------------------------------------------------------------------------------------------------------	
	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	-- 최종 임시 데이터 생성  
	----------------------------------------------------------------------------------------------------------	
	;WITH SELECTED_COLS_INFO AS ( 
		SELECT MAX(CASE WHEN COL = 'DIVISION_NAME'			THEN 'Y' ELSE NULL END) AS DIVISION
			  ,MAX(CASE WHEN COL = 'CELL_TYPE_GR'			THEN 'Y' ELSE NULL END) AS CELL_TYPE_GR
			  ,MAX(CASE WHEN COL = 'PLANT_NAME'				THEN 'Y' ELSE NULL END) AS PLANT
			  ,MAX(CASE WHEN COL = 'MODEL_TYPE_GR'			THEN 'Y' ELSE NULL END) AS MODEL_TYPE_GR
			  ,MAX(CASE WHEN COL = 'OPERATION_GROUP_NAME'	THEN 'Y' ELSE NULL END) AS OPERATION_GROUP
		 FROM #tmp_SCP0076_COLUMN
	)
	INSERT INTO #tmp_SCP0076_DATA 
	(	  PLAN_START_YYYYMMDD			
		, PLAN_WEEK		
		, DIVISION_ID					
		, DIVISION_NAME					
		, CELL_TYPE_GR					
		, OPERATION_GROUP				
		, OPERATION_GROUP_NAME			
		, PLANT_ID						
		, PLANT_NAME					
		, MODEL_TYPE_GR					
		, PROD_PLAN_SCP				
		, PROD_PLAN_FP				
		, PROD_RESULT				
		, PROD_RESULT_TOT			
		, PROD_PLAN_SCP_CELL		
		, PROD_PLAN_FP_CELL			
		, PROD_RESULT_CELL			
		, PROD_RESULT_TOT_CELL		
		, PROD_PLAN_DEN				
		, PROD_PLAN_DEN_CELL		
		, CO_RATE					
		, AC_RATE					 
		, CO_RATE_CELL				 
		, AC_RATE_CELL	
		, REASON_CODE
		, REASON_DESCRIPTION
	)
	SELECT									
		   A.PLAN_START_YYYYMMDD				
		 , A.PLAN_WEEK	
		 , CASE WHEN C.DIVISION = 'Y'			THEN A.DIVISION_ID			ELSE NULL END	AS DIVISION_ID
		 , CASE WHEN C.DIVISION = 'Y'			THEN A.DIVISION_NAME		ELSE NULL END	AS DIVISION_NAME
		 , CASE WHEN C.CELL_TYPE_GR = 'Y'		THEN A.CELL_TYPE_GR			ELSE NULL END	AS CELL_TYPE_GR
		 , CASE WHEN C.OPERATION_GROUP = 'Y'	THEN A.OPERATION_GROUP		ELSE NULL END	AS OPERATION_GROUP
		 , CASE WHEN C.OPERATION_GROUP = 'Y'	THEN A.OPERATION_GROUP_NAME	ELSE NULL END	AS OPERATION_GROUP_NAME
		 , CASE WHEN C.PLANT = 'Y'				THEN A.PLANT_ID				ELSE NULL END	AS PLANT_ID
		 , CASE WHEN C.PLANT = 'Y'				THEN A.PLANT_NAME			ELSE NULL END	AS PLANT_NAME
		 , CASE WHEN C.MODEL_TYPE_GR = 'Y'		THEN A.MODEL_TYPE_GR		ELSE NULL END	AS MODEL_TYPE_GR
		 , SUM(A.PROD_PLAN_SCP)							AS PROD_PLAN_SCP				
		 , SUM(A.PROD_PLAN_FP) 							AS PROD_PLAN_FP					
		 , SUM(A.PROD_RESULT)							AS PROD_RESULT					
		 , SUM(A.PROD_RESULT_TOT)						AS PROD_RESULT_TOT				
		 , SUM(A.PROD_PLAN_SCP_CELL)					AS PROD_PLAN_SCP_CELL 			
		 , SUM(A.PROD_PLAN_FP_CELL) 					AS PROD_PLAN_FP_CELL			
		 , SUM(A.PROD_RESULT_CELL) 						AS PROD_RESULT_CELL				
		 , SUM(A.PROD_RESULT_TOT_CELL)					AS PROD_RESULT_TOT_CELL			
		 , SUM(A.PROD_PLAN_DEN) 						AS PROD_PLAN_DEN				
		 , SUM(A.PROD_PLAN_DEN_CELL) 					AS PROD_PLAN_DEN_CELL			
		 , IIF(SUM(A.PROD_PLAN_DEN		)	= 0 , 1 ,  SUM(A.PROD_RESULT			)		/ SUM(A.PROD_PLAN_DEN		)		)   * 100 AS CO_RATE				
		 , IIF(SUM(A.PROD_PLAN_DEN		)	= 0 , 1 ,  SUM(A.PROD_RESULT_TOT		)		/ SUM(A.PROD_PLAN_DEN		)		)   * 100 AS AC_RATE				
		 , IIF(SUM(A.PROD_PLAN_DEN_CELL	)	= 0 , 1 ,  SUM(A.PROD_RESULT_CELL		)		/ SUM(A.PROD_PLAN_DEN_CELL)		)   * 100 AS CO_RATE_CELL			
		 , IIF(SUM(A.PROD_PLAN_DEN_CELL	)	= 0 , 1 ,  SUM(A.PROD_RESULT_TOT_CELL	)		/ SUM(A.PROD_PLAN_DEN_CELL)		)   * 100 AS AC_RATE_CELL			
		 , ISNULL(MAX(A.REASON_CODE),'-')				AS REASON_CODE					
		 , MAX(A.REASON_DESCRIPTION)					AS REASON_DESCRIPTION		
	  FROM #tmp_SCP0076_DATA_OSP_YN A WITH(NOLOCK)	
		   INNER JOIN SELECTED_COLS_INFO C
				   ON 1=1
	 WHERE 1=1
	 GROUP BY A.PLAN_START_YYYYMMDD				
			, A.PLAN_WEEK
			, CASE WHEN C.DIVISION = 'Y'			THEN A.DIVISION_ID			ELSE NULL END
			, CASE WHEN C.DIVISION = 'Y'			THEN A.DIVISION_NAME		ELSE NULL END
			, CASE WHEN C.CELL_TYPE_GR = 'Y'		THEN A.CELL_TYPE_GR			ELSE NULL END
			, CASE WHEN C.PLANT = 'Y'				THEN A.PLANT_ID				ELSE NULL END
			, CASE WHEN C.PLANT = 'Y'				THEN A.PLANT_NAME			ELSE NULL END
			, CASE WHEN C.MODEL_TYPE_GR = 'Y'		THEN A.MODEL_TYPE_GR		ELSE NULL END
			, CASE WHEN C.OPERATION_GROUP = 'Y'		THEN A.OPERATION_GROUP		ELSE NULL END
			, CASE WHEN C.OPERATION_GROUP = 'Y'		THEN A.OPERATION_GROUP_NAME	ELSE NULL END

	-----------------------------------------------------------------------------------------------------------
	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	-- 지표 week case 다이나믹 쿼리 조합 
	-----------------------------------------------------------------------------------------------------------
	DECLARE @v_query_ww_case			NVARCHAR(MAX) = '';
	DECLARE @v_order_by				    NVARCHAR(4000) = '';

 	IF OBJECT_ID('tempdb..#tmp_ww_list') IS NOT NULL	
		DROP TABLE #tmp_ww_list;

	 select yyyyww
		  , min(yyyymmdd) as plan_start_yyyymmdd 
		  , row_number() over (order by yyyyww) as rn 
	  into #tmp_ww_list
	  from scm_mst_bucket with(nolock)
	where 1=1
	  and yyyymmdd between @v_from_yyyymmdd and @v_to_yyyymmdd
	group by yyyyww


	;with  ww_case_list as (
		SELECT  
			   '   ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_SCP				ELSE NUll END), 0)		AS "'+  concat('PROD_PLAN_SCP_'			,B.yyyyww) + '" ' + CHAR(10)
			 + ' , ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_FP				ELSE NUll END), 0)		AS "'+  concat('PROD_PLAN_FP_'			,B.yyyyww) + '" ' + CHAR(10)
			 + ' , ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_RESULT				ELSE NUll END), 0)		AS "'+  concat('PROD_RESULT_'			,B.yyyyww) + '" ' + CHAR(10)
			 + ' , ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_RESULT_TOT			ELSE NUll END), 0)		AS "'+  concat('PROD_RESULT_TOT_'		,B.yyyyww) + '" ' + CHAR(10)
			 + ' , ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_SCP_CELL		ELSE NUll END), 0)		AS "'+  concat('PROD_PLAN_SCP_CELL_'	,B.yyyyww) + '" ' + CHAR(10)
			 + ' , ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_FP_CELL			ELSE NUll END), 0)		AS "'+  concat('PROD_PLAN_FP_CELL_'		,B.yyyyww) + '" ' + CHAR(10)
			 + ' , ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_RESULT_CELL			ELSE NUll END), 0)		AS "'+  concat('PROD_RESULT_CELL_'		,B.yyyyww) + '" ' + CHAR(10)
			 + ' , ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_RESULT_TOT_CELL		ELSE NUll END), 0)		AS "'+  concat('PROD_RESULT_TOT_CELL_'	,B.yyyyww) + '" ' + CHAR(10)
			 + ' , ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_DEN				ELSE NUll END), 0)		AS "'+  concat('PROD_PLAN_DEN_'			,B.yyyyww) + '" ' + CHAR(10)
			 + ' , ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_DEN_CELL		ELSE NUll END), 0)		AS "'+  concat('PROD_PLAN_DEN_CELL_'	,B.yyyyww) + '" ' + CHAR(10)
			 + ' , CASE WHEN ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_DEN		ELSE NUll END), 0) = 0 ' +  CHAR(10)
			 + '		THEN 100 ELSE '+ CHAR(10)
			 + '		ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN CO_RATE					ELSE NUll END), 0)	END	AS "'+  concat('CO_RATE_'		,B.yyyyww) + '" ' + CHAR(10)
			 + ' , CASE WHEN ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_DEN		ELSE NUll END), 0) = 0 ' +  CHAR(10)
			 + '		THEN 100 ELSE '+ CHAR(10)
			 + '		ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN AC_RATE					ELSE NUll END), 0)	END	AS "'+  concat('AC_RATE_'		,B.yyyyww) + '" ' + CHAR(10)
			 + ' , CASE WHEN ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_DEN_CELL		ELSE NUll END), 0) = 0 ' +  CHAR(10)
			 + '		THEN 100 ELSE '+ CHAR(10)
			 + '		ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN CO_RATE_CELL					ELSE NUll END), 0)	END	AS "'+  concat('CO_RATE_CELL_'		,B.yyyyww) + '" ' + CHAR(10)
			 + ' , CASE WHEN ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN PROD_PLAN_DEN_CELL		ELSE NUll END), 0) = 0 ' +  CHAR(10)
			 + '		THEN 100 ELSE '+ CHAR(10)
			 + '		ISNULL(MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN AC_RATE_CELL					ELSE NUll END), 0)	END	AS "'+  concat('AC_RATE_CELL_'		,B.yyyyww) + '" ' + CHAR(10)
			 + ' , MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN REASON_CODE				ELSE NUll END)					AS "'+  concat('REASON_CODE_'			,B.yyyyww) + '" ' + CHAR(10)
			 + ' , MAX(CASE WHEN plan_start_yyyymmdd = '''+ B.plan_start_yyyymmdd   + ''' THEN REASON_DESCRIPTION		ELSE NUll END)					AS "'+  concat('REASON_DESCRIPTION_'	,B.yyyyww) + '" ' + CHAR(10)
			   as cols 
		  FROM #tmp_ww_list b
	 ) 
	select @v_query_ww_case = 
								STUFF(( SELECT ',' +  cols
								FROM ww_case_list 
								  WHERE 1=1
								FOR XML PATH('')), 1, 1,'')

	-----------------------------------------------------------------------------------------------------------
	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	-- ORDER BY 구분  
	-----------------------------------------------------------------------------------------------------------
	;WITH SELECTED_COLS AS (
		SELECT USER_SORT_ORDER_NO
			  ,COL
			  ,DATA_SORT_METHOD_CODE
			  ,COL + '	' + DATA_SORT_METHOD_CODE + '	' + CHAR(10) AS COL_ORDER 
		  FROM #tmp_SCP0076_COLUMN
	)
	SELECT @v_order_by = 	 	STUFF(( SELECT ',' +  COL_ORDER
								FROM SELECTED_COLS 
								  WHERE 1=1
								  ORDER BY USER_SORT_ORDER_NO
								FOR XML PATH('') ), 1, 1,'')

	/********************************************************************************
	* 데이터 생성 - 과거 주차의 준수율 , 달성율
	*              자동차 준수율			: 실적   / 계획(RESULT		/ PROD_PLAN_SSP)
	*              자동차 달성율			: 총실적 / 계획(RESULT)TOT	/ PROD_PLAN_SSP)
	*              소형,ESS,전극 준수율	: 실적   / 계획(RESULT		/ PROD_PLAN_SCP)
	*              소형,ESS,전극 달성율	: 총실적 / 계획(RESULT)TOT	/ PROD_PLAN_SCP)
	********************************************************************************/
	SET @mEXEC = '';
	SET @MEXEC = @MEXEC+'	SELECT															' + CHAR(10);
	SET @MEXEC = @MEXEC+'		  '''+ @v_plan_start_yyyymmdd+ '''	AS PLAN_START_YYYYMMDD ,' + CHAR(10);
	SET @MEXEC = @MEXEC+'		  '''+ @v_plan_week_name+ '''		AS PLAN_WEEK 			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		 , DIVISION_ID												' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , DIVISION_NAME											' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , CELL_TYPE_GR												' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , OPERATION_GROUP											' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , OPERATION_GROUP_NAME										' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , PLANT_ID													' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , PLANT_NAME												' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , MODEL_TYPE_GR											' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 ,' +@v_query_ww_case + '									' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리   
	SET @MEXEC = @MEXEC+'		 , MAX(CASE WHEN PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + ''' THEN REASON_CODE			ELSE NULL END)			AS REASON_CODE					' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , MAX(CASE WHEN PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + ''' THEN REASON_DESCRIPTION	ELSE NULL END)			AS REASON_DESCRIPTION			' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'	  FROM #tmp_SCP0076_DATA A										' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'	 GROUP BY 														' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		   DIVISION_ID												' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , DIVISION_NAME											' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , CELL_TYPE_GR												' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , OPERATION_GROUP											' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , OPERATION_GROUP_NAME										' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , PLANT_ID													' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , PLANT_NAME												' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		 , MODEL_TYPE_GR											' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'	  ORDER BY 														' + CHAR(10); 	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리
	SET @MEXEC = @MEXEC+'		   ' + @v_order_by											  + CHAR(10);  	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  - 조회 Target Week 범위 처리

	EXEC (@mEXEC);

	-- DEBUG QRY 출력
	---------------------------------------------------------	
	IF( @debug_mode ='T')
	BEGIN				
		SET @POS =1;
		SET @LEN =LEN(@MEXEC);
		WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@MEXEC,@POS,4000);
				SET @POS = @POS+4000;
			END;
	END;

	/********************************************************************************
	* 수정 여부 조회(전체 컬럼 조회 시 수정 가능)
	********************************************************************************/
	SELECT ( CASE WHEN COUNT(1) > 0 THEN 'N' ELSE 'Y' END ) AS IS_EDITABLE
	  FROM (
			SELECT A.COLUMN_NAME
			  FROM SCM_MST_SHEET_COLUMNS A WITH(NOLOCK) 
			 WHERE A.PROGRAM_ID	= @v_program_id
			   AND A.SHEET_NAME	= @v_sheet_name
			   AND A.VALID_YN		= 'Y'
			   AND A.VISIBLE_FLAG	= 'Y'
			EXCEPT 
			SELECT COL
			  FROM #tmp_SCP0076_COLUMN
			) A
	;
END

