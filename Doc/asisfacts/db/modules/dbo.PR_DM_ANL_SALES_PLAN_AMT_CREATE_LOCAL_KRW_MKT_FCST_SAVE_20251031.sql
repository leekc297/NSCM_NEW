
/*=====================================================================================================================================================
 * Program ID   : PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE
 * Description  : MKT FCST 화면에서 저장 시 호출하는 프로시져로, Sales Plan AMT Create ( Local/KRW ) 
 * Program History
 *=====================================================================================================================================================
 *	  Date		In Charge		Description
 *=====================================================================================================================================================
 * 2017.02.05	DWOK/KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.08.08					SALES_PLAN_CUTOFF  주석처리
 * 2018.08.16					DMF0003_SAVE_MKT_FCST 저장시 호출되는 프로시져
 * 2020.02.13	HWI1993 		자동차사업부 SALES AMT 메저를 RTF_SCP 기준으로 생성
 * 2020.03.09	KHSONG 			TMM_FCST ADD
 * 2020.05.07	KHSONG 			C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.08.06	hwi1993			[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
 * 2020.09.09	P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020.12.08	P.C.I			[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2024.12.10	KJJ				[PJ2024-50611] Catch Up 메저 삭제 금지
 * 2025.01.21	JSSBAE			[E20250122-000837]_Sales Plan 화면 MKT FCST AMT. 개선요청
 * 2025.02.11	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 SCM_FCST MEASURE 추가
 * 2025.06.10	KANG.H.J		[PJ2025-50017] [PJ2025-50188] 임시테이블 DROP 처리
 * 2025.09.03	JSSBAE			[E20250826-000546]_Sales Plan 계획구간 일부 매출 데이터 누락
 * 2025.09.15	JSSBAE			[E20250915-000105]_GSCM 시스템 DP 입력 오류
 * 2025.10.16	PARK.CHOYI		속도개선
 *===================================================================================================================================================*/
 
CREATE PROCEDURE [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE_20251031]
	-- Add the parameters for the stored procedure here
	--@p_division_id				NVARCHAR(MAX)		,
	--@p_CREATED_BY               NVARCHAR(MAX)	
AS
/*
	CREATE TABLE #results  (
             v_active_flag      NVARCHAR(01) NOT NULL
			,v_division_id      NVARCHAR(30) NOT NULL
			,v_project_code     NVARCHAR(50) NOT NULL
			,v_scm_site_id      NVARCHAR(30) NOT NULL
			,v_item_id          NVARCHAR(50) NOT NULL
			,v_dom_exp          NVARCHAR(03) NOT NULL
			,v_fcst_type        NVARCHAR(20) NOT NULL
			,v_incoterms        NVARCHAR(10) NOT NULL
			,v_measure          NVARCHAR(50) NOT NULL
			,v_plant_site_id    NVARCHAR(30) NOT NULL
			,v_yyyymmdd         NVARCHAR(08) NOT NULL
			,v_qty              NUMERIC(30,10) NOT NULL
			,v_created_by       NVARCHAR(150) NULL
                           )
*/
BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

/* [PJ2025-50017] 기준 변경 #T_MKT_FCST ==> #T2_MKT_FCST / #T_PRICE ==> #T2_PRICE
	CREATE TABLE #T_MKT_FCST (
	  DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, ITEM_ID			NVARCHAR(50)
	, DOM_EXP			NVARCHAR(3)
	, FCST_TYPE			NVARCHAR(20)
	, INCOTERMS			NVARCHAR(10)
	, MEASURE			NVARCHAR(50)
	, PLANT_SITE_ID		NVARCHAR(30)
	, YYYYMMDD			NVARCHAR(8)
	, QTY				NUMERIC(30,10)
	);
	
	INSERT INTO #T_MKT_FCST ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY )
	SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, C.MEASURE, A.V_PLANT_SITE_ID
		,  A.V_YYYYMMDD, C.QTY
	FROM #results A
	JOIN DM_PLN_MKT_FCST C WITH(NOLOCK)		ON A.V_DIVISION_ID = C.DIVISION_ID 
												AND A.V_PROJECT_CODE = C.PROJECT_CODE
												AND A.V_SCM_SITE_ID = C.SCM_SITE_ID
												AND A.V_ITEM_ID = C.ITEM_ID
												AND A.V_DOM_EXP = C.DOM_EXP
												AND A.V_FCST_TYPE = C.FCST_TYPE
												AND A.V_INCOTERMS	= C.INCOTERMS
												AND A.V_PLANT_SITE_ID = CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
												--AND C.QTY > 0

	CREATE TABLE #T_PRICE (
	  DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, PLANT_SITE_ID		NVARCHAR(30)
	, ITEM_ID			NVARCHAR(50)
	, YYYYMMDD			NVARCHAR(8)
	, CURRENCY			NVARCHAR(10)
	, MEASURE			NVARCHAR(50)
	, DOM_EXP			NVARCHAR(3)
	, FCST_TYPE			NVARCHAR(20)
	, INCOTERMS			NVARCHAR(10)
	, PRICE				NUMERIC(30,10)
	);
	
	INSERT INTO #T_PRICE ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CURRENCY, MEASURE, YYYYMMDD, PRICE )
	SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID
		, C.CURRENCY, C.MEASURE, A.V_YYYYMMDD, C.PRICE
	FROM #results A
	JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
	JOIN SCM_MST_FUTURE_PRICE C WITH(NOLOCK) ON A.V_DIVISION_ID = C.DIVISION_ID 
												AND A.V_PROJECT_CODE = C.PROJECT_CODE
												AND A.V_SCM_SITE_ID = C.SCM_SITE_ID
												AND A.V_ITEM_ID = C.ITEM_ID
												AND A.V_DOM_EXP = C.DOM_EXP
												AND A.V_FCST_TYPE = C.FCST_TYPE
												AND A.V_INCOTERMS	= C.INCOTERMS
												AND A.V_PLANT_SITE_ID = CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
												AND C.YYYYMMDD	= B.BASIS_START_DATE
												AND C.PRICE > 0
*/

	--====================================================================================================
	-- 스플릿관련 변수 (START)
	--====================================================================================================
	DECLARE	@recv_division_id	NVARCHAR(MAX);
	--SET @recv_division_id = @p_division_id;
	DECLARE	@v_delimiter		NVARCHAR(1);
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
    DECLARE @v_division_id		NVARCHAR(MAX);
	DECLARE @v_created_by		NVARCHAR(MAX);	
	--DECLARE @n_update_cnt		INT;
	
	SET	@recv_division_id	= NULL;		
	SET	@v_delimiter		= '^'  -- 데이터 구분자
	SET	@v_created_by		= ISNULL((SELECT MAX(v_created_by) FROM #results GROUP BY v_division_id),'SYSTEM')
	------------------------------------------------------------------------------------------------------
	-- [E20250915-000105]_당주 월요일 변수를 받아 처리한다. (START)
	------------------------------------------------------------------------------------------------------
	DECLARE @v_this_week_mon	NVARCHAR(8);
	SET		@v_this_week_mon = CONVERT(NVARCHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)	
	------------------------------------------------------------------------------------------------------
	-- [E20250915-000105]_당주 월요일 변수를 받아 처리한다. (END)
	------------------------------------------------------------------------------------------------------	
	------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] 소형 매출계획 동기화 개선 (START)
	------------------------------------------------------------------------------------------------------
	SELECT @v_division_id = MAX(v_division_id) FROM #results;
	------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] 소형 매출계획 동기화 개선 (END)
	------------------------------------------------------------------------------------------------------
	--====================================================================================================
	-- 스플릿관련 변수 (END)
	--====================================================================================================	
	
	--====================================================================================================
	-- LOG 용 변수 설정 (START)
	--====================================================================================================
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE_DEV'; -- (■park.choyi 2025.10.15) 운영 반영 전에 _DEV 삭제
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	--====================================================================================================
	-- LOG 용 변수 설정 (END)
	--====================================================================================================
	
	--====================================================================================================
	-- 시작 LOG  (START)
	--====================================================================================================
	SET @v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########';
	SET @v_description	= '';
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message	= NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--====================================================================================================


PRINT 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE : A00A--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	--====================================================================================================
	-- [PJ2025-50188] 임시테이블 DROP 처리 (START)
	--====================================================================================================
	BEGIN
		IF OBJECT_ID('tempdb..#T2_MKT_FCST') IS NOT NULL
			DROP TABLE  #T2_MKT_FCST;         
		IF OBJECT_ID('tempdb..#T2_PRICE') IS NOT NULL
			DROP TABLE  #T2_PRICE;          
		IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL
			DROP TABLE  #SALES_PLAN_TEMP  
		------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_속도개선 (START)
		------------------------------------------------------------------------------------------------------
		-- (■park.choyi 2025.10.15) 임시테이블 #TEMP_MKT_FCST, #TEMP_PRICE, #TEMP_DISTINCT_PRICE 삭제
		/*
		IF OBJECT_ID('tempdb..#TEMP_MKT_FCST') IS NOT NULL
			DROP TABLE  #TEMP_MKT_FCST  
		IF OBJECT_ID('tempdb..#TEMP_PRICE') IS NOT NULL
			DROP TABLE  #TEMP_PRICE  	
		IF OBJECT_ID('tempdb..#TEMP_DISTINCT_PRICE') IS NOT NULL
			DROP TABLE  #TEMP_DISTINCT_PRICE  			*/
			
		-- (■park.choyi 2025.10.15) #RESULTS_KEY, #SALES_PLAN_TEMP_KEY 추가
		IF OBJECT_ID('tempdb..#RESULTS_KEY') IS NOT NULL
			DROP TABLE  #RESULTS_KEY  
		IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP_KEY') IS NOT NULL
			DROP TABLE  #SALES_PLAN_TEMP_KEY  
						
		------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_속도개선 (END)
		------------------------------------------------------------------------------------------------------
	END				   	
	--====================================================================================================
	-- [PJ2025-50188] 임시테이블 DROP 처리 (END)
	--====================================================================================================	
	--====================================================================================================
	-- [PJ2025-50188] 임시테이블 CREATE 처리 (START)
	--====================================================================================================
	------------------------------------------------------------------------------------------------------
	-- [E20250915-000105]_속도개선 (START)
	------------------------------------------------------------------------------------------------------
	-- (■park.choyi 2025.10.15) 임시테이블 #TEMP_MKT_FCST 삭제
	/*CREATE TABLE #TEMP_MKT_FCST (		
	  DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, ITEM_ID			NVARCHAR(50)
	, DOM_EXP			NVARCHAR(3)
	, FCST_TYPE			NVARCHAR(20)
	, INCOTERMS			NVARCHAR(10)
	, MEASURE			NVARCHAR(50)
	, PLANT_SITE_ID		NVARCHAR(30)
	, CELL_PROD_SITE_ID	NVARCHAR(30)		
	, YYYYMMDD			NVARCHAR(8)
	, QTY				NUMERIC(30,10)
	, CREATED_BY		NVARCHAR(150)
	, CREATION_DATE		DATETIME
	, BASIS_START_DATE	NVARCHAR(8));	*/
	------------------------------------------------------------------------------------------------------
	-- [E20250915-000105]_속도개선 (END)
	------------------------------------------------------------------------------------------------------

	CREATE TABLE #T2_MKT_FCST (				-- [PJ2025-50017] #T2_MKT_FCST는 CELL_PROD_SITE_ID 까지 포함
	  DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, ITEM_ID			NVARCHAR(50)
	, DOM_EXP			NVARCHAR(3)
	, FCST_TYPE			NVARCHAR(20)
	, INCOTERMS			NVARCHAR(10)
	, MEASURE			NVARCHAR(50)
	, PLANT_SITE_ID		NVARCHAR(30)
	, CELL_PROD_SITE_ID	NVARCHAR(30)		-- [PJ2025-50017] 추가
	, YYYYMMDD			NVARCHAR(8)
	, QTY				NUMERIC(30,10)
	, CREATED_BY		NVARCHAR(150)
	, CREATION_DATE		DATETIME
	, BASIS_START_DATE	NVARCHAR(8)			-- [E20250915-000105]_Sales Price와 매핑할 수 있도록 MKT FCST일자 기준으로 해당 주차의 월요일을 구함
	);	
	
	------------------------------------------------------------------------------------------------------
	-- [E20250915-000105]_속도개선 (START)
	------------------------------------------------------------------------------------------------------
	-- (■park.choyi 2025.10.15) 임시테이블 #TEMP_PRICE, #TEMP_DISTINCT_PRICE 삭제
	/*
	CREATE TABLE #TEMP_PRICE (			
	  DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, PLANT_SITE_ID		NVARCHAR(30)
	, CELL_PROD_SITE_ID	NVARCHAR(30)		
	, ITEM_ID			NVARCHAR(50)
	, YYYYMMDD			NVARCHAR(8)
	, CURRENCY			NVARCHAR(10)
	, MEASURE			NVARCHAR(50)
	, DOM_EXP			NVARCHAR(3)
	, FCST_TYPE			NVARCHAR(20)
	, INCOTERMS			NVARCHAR(10)
	, PRICE				NUMERIC(20,10)
	, CREATED_BY		NVARCHAR(150)
	, CREATION_DATE		DATETIME) ;
	
	
	CREATE TABLE #TEMP_DISTINCT_PRICE (				
	  DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, PLANT_SITE_ID		NVARCHAR(30)
	, CELL_PROD_SITE_ID	NVARCHAR(30)		
	, ITEM_ID			NVARCHAR(50)
	, YYYYMMDD			NVARCHAR(8)
	, CURRENCY			NVARCHAR(10)
	, MEASURE			NVARCHAR(50)
	, DOM_EXP			NVARCHAR(3)
	, FCST_TYPE			NVARCHAR(20)
	, INCOTERMS			NVARCHAR(10)
	, PRICE				NUMERIC(20,10)
	, CREATED_BY		NVARCHAR(150)
	, CREATION_DATE		DATETIME );
	*/
	------------------------------------------------------------------------------------------------------
	-- [E20250915-000105]_속도개선 (END)
	------------------------------------------------------------------------------------------------------

	CREATE TABLE #T2_PRICE (				-- [PJ2025-50017] #T2_PRICE는 CELL_PROD_SITE_ID 까지 포함
	  DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, PLANT_SITE_ID		NVARCHAR(30)
	, CELL_PROD_SITE_ID	NVARCHAR(30)		-- [PJ2025-50017] 추가
	, ITEM_ID			NVARCHAR(50)
	, YYYYMMDD			NVARCHAR(8)
	, CURRENCY			NVARCHAR(10)
	, MEASURE			NVARCHAR(50)
	, DOM_EXP			NVARCHAR(3)
	, FCST_TYPE			NVARCHAR(20)
	, INCOTERMS			NVARCHAR(10)
	, PRICE				NUMERIC(20,10)
	, CREATED_BY		NVARCHAR(150)
	, CREATION_DATE		DATETIME
	);

	--====================================================================================================
	-- [PJ2025-50188] 임시테이블 CREATE 처리 (END)
	--====================================================================================================	
	   	
	-- (■park.choyi 2025.10.15) #RESULTS_KEY 생성
	CREATE TABLE #RESULTS_KEY (
	 v_division_id      NVARCHAR(30) NOT NULL
	,v_project_code     NVARCHAR(50) NOT NULL
	,v_scm_site_id      NVARCHAR(30) NOT NULL
	,v_item_id          NVARCHAR(50) NOT NULL
	,v_dom_exp          NVARCHAR(03) NOT NULL
	,v_fcst_type        NVARCHAR(20) NOT NULL
	,v_incoterms        NVARCHAR(10) NOT NULL
	,v_plant_site_id	NVARCHAR(30) NOT NULL
	,v_min_yyyymmdd     NVARCHAR(08) NOT NULL
	,v_max_yyyymmdd     NVARCHAR(08) NOT NULL
	);


	-- [PJ2025-50017] 40 사업부는 DM_PLN_CFM_MKT_DEMAND_PLAN, DM_PLN_CFM_SELLING_PRICE 기반 데이터 생성
	-- [PJ2025-50017] 40 외 사업부는 DM_PLN_MKT_FCST, SCM_MST_FUTURE_PRICE 기반 데이터 생성. (단 CELL_PROD_SITE_ID는 '-'로 처리) START
	IF (@v_division_id = '40')
	BEGIN
	
		SELECT @n_log_count = COUNT(*)
		FROM #RESULTS WITH(NOLOCK)
		;
				
		SET @v_log_type		= 'ING'; --[C20200909-000203] LOG 표준화 적용
		SET @v_log_message	= 'step - 01 - INSERT #RESULTS  ';
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

		-- (■park.choyi 2025.10.15) #RESULTS_KEY 데이터 생성
		-- #RESULTS 에 들어오는 데이터는 MKT_FCST, SCM_FCST, LOC 메져이므로 MEASURE를 제외한 Sales Plan 테이블을 동기화 하기 위한 MIN, MAX YYYYMMDD 기준의 데이터만 필요 함 
		-- AS-IS : 데이터를 가져올때 YYYYMMDD에 대한 기준이 없음, Measure 조건도 없음, 그러다보니 Join 중복데이터가 발생 함
		-- TO-BE : Measure, YYYYMMDD 를 제외한 Key 값 기준으로 #RESULTS_KEY 임시테이블 생성( MIN, MAX YYYYMMDD )
		INSERT INTO #RESULTS_KEY
		SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID,V_ITEM_ID ,V_DOM_EXP ,V_FCST_TYPE ,V_INCOTERMS, V_PLANT_SITE_ID
				, D_MIN.BASIS_START_DATE
				, D_MAX.BASIS_END_DATE
		FROM (SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID,V_ITEM_ID ,V_DOM_EXP ,V_FCST_TYPE ,V_INCOTERMS, V_PLANT_SITE_ID
					, MIN(V_YYYYMMDD) AS MIN_DATE
					, MAX(V_YYYYMMDD) AS MAX_DATE 
				FROM #RESULTS 
				GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID,V_ITEM_ID ,V_DOM_EXP ,V_FCST_TYPE ,V_INCOTERMS, V_PLANT_SITE_ID ) A
		JOIN SCM_SYS_CALENDAR_M D_MIN WITH(NOLOCK) ON D_MIN.BASIS_YYYYMMDD = A.MIN_DATE
		JOIN SCM_SYS_CALENDAR_M D_MAX WITH(NOLOCK) ON D_MAX.BASIS_YYYYMMDD = A.MAX_DATE
		;

		SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인
				
		SET @v_log_type		= 'ING'; --[C20200909-000203] LOG 표준화 적용
		SET @v_log_message	= 'step - 01 - 01- INSERT #RESULTS_KEY  ';
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		


PRINT 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE : A00B--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
		--------------------------------------------------------------------------------------------------------
		-- DM_PLN_CFM_MKT_DEMAND_PLAN과 받아온 MKT FCST 정보를 JOIN하여 TEMP TABLE 생성 (START)
		--------------------------------------------------------------------------------------------------------
		--INSERT INTO #T2_MKT_FCST -- [E20250915-000105]_TEMP 테이블 변경
		INSERT INTO #T2_MKT_FCST --#TEMP_MKT_FCST -- (■park.choyi 2025.10.15) #T2_MKT_FCST (최종) 테이블로 변경 
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, BASIS_START_DATE )	-- [E20250915-000105]_당주 월요일 변수를 신규 생성
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, C.MEASURE, A.V_PLANT_SITE_ID, C.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			 , C.YYYYMMDD, C.QTY, @v_created_by, GETDATE()
			 , D.BASIS_START_DATE -- [E20250915-000105]_당주 월요일 변수를 신규 생성
		FROM #RESULTS_KEY A --#results A -- (■park.choyi 2025.10.15) #RESULTS_KEY 테이블로 변경 
		JOIN DM_PLN_CFM_MKT_DEMAND_PLAN C WITH(NOLOCK)	
		  ON A.V_DIVISION_ID	= C.DIVISION_ID 
		 AND A.V_PROJECT_CODE	= C.PROJECT_CODE
		 AND A.V_SCM_SITE_ID	= C.SCM_SITE_ID
		 AND A.V_ITEM_ID		= C.ITEM_ID
		 AND A.V_DOM_EXP		= C.DOM_EXP
		 AND A.V_FCST_TYPE		= C.FCST_TYPE
		 AND A.V_INCOTERMS		= C.INCOTERMS
		 AND A.V_PLANT_SITE_ID	= CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
		 --AND A.V_CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID	-- [PJ2025-50017] 중요(results에 V_CELL_PROD_SITE_ID 없음)
		 --AND C.QTY > 0
		JOIN SCM_SYS_CALENDAR_M D WITH(NOLOCK)
		  ON D.BASIS_YYYYMMDD = C.YYYYMMDD
		WHERE C.MEASURE IN ('MKT_FCST', 'SCM_FCST', 'RTF_SYS_RP') -- (■park.choyi 2025.10.15) 필수 Measure 조건 추가
		AND   C.YYYYMMDD BETWEEN A.v_min_yyyymmdd AND A.v_max_yyyymmdd -- (■park.choyi 2025.10.15) MIN, MAX YYYYMMDD 조건 추가
		AND   D.BASIS_YYYYMMDD BETWEEN A.v_min_yyyymmdd AND A.v_max_yyyymmdd -- (■park.choyi 2025.10.15) MIN, MAX YYYYMMDD 조건 추가
		AND   C.QTY <> 0 -- (■park.choyi 2025.10.15) 0 제외

		
		SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인
		SET @v_log_message	= 'step - 01 -02 - INSERT #T2_MKT_FCST  ';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--------------------------------------------------------------------------------------------------------
		-- DM_PLN_CFM_MKT_DEMAND_PLAN과 받아온 정보를 JOIN하여 TEMP TABLE 생성 (END)
		--------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_속도개선 TEMP로 1차로 담고, 2차로 월요일 이후이며, 0이 아닌데이터만 추출 (START)
		--------------------------------------------------------------------------------------------------------		
		-- (■park.choyi 2025.10.15) 기간, 0 조건 적용되고 중복데이터 없으므로 아래 쿼리 삭제
		/*
		INSERT INTO #T2_MKT_FCST ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, BASIS_START_DATE )
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, BASIS_START_DATE 
		FROM #TEMP_MKT_FCST WITH(NOLOCK)
		WHERE YYYYMMDD >= @v_this_week_mon
		AND QTY <> 0*/
		--------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_속도개선 TEMP로 1차로 담고, 2차로 월요일 이후이며, 0이 아닌데이터만 추출 (END)
		--------------------------------------------------------------------------------------------------------
PRINT 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE : A00C--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

		--------------------------------------------------------------------------------------------------------
		-- DM_PLN_CFM_SELLING_PRICE과 받아온 정보를 JOIN하여 TEMP TABLE 생성 (START)
		--------------------------------------------------------------------------------------------------------
		--INSERT INTO #T2_PRICE  -- [E20250915-000105]_TEMP 테이블 변경
		INSERT INTO #T2_PRICE --#TEMP_PRICE -- (■park.choyi 2025.10.15) #T2_MKT_FCST (최종) 테이블로 변경 
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		, CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE )	
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID, C.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			 , C.CURRENCY, C.MEASURE, C.YYYYMMDD, C.PRICE, @v_created_by, GETDATE()
		FROM #RESULTS_KEY A --#results A -- (■park.choyi 2025.10.15) #RESULTS_KEY 테이블로 변경 
		------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- [E20250826-000546]_지울때는 일자가 없는데, INSERT 하는 구간에만 일자를 조건으로 걸게되어, FCSTPRICE MGMT화면에서 MKT FCST, SALES PRICE를 저장하는 경우, 데이터 누락되는 현상 발생 날짜 조건 주석처리 (START)
		--JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
		-- [E20250826-000546]_지울때는 일자가 없는데, INSERT 하는 구간에만 일자를 조건으로 걸게되어, FCSTPRICE MGMT화면에서 MKT FCST, SALES PRICE를 저장하는 경우, 데이터 누락되는 현상 발생 날짜 조건 주석처리 (END)
		------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		JOIN DM_PLN_CFM_SELLING_PRICE C WITH(NOLOCK) 
		  ON A.V_DIVISION_ID	= C.DIVISION_ID 
		 AND A.V_PROJECT_CODE	= C.PROJECT_CODE
		 AND A.V_SCM_SITE_ID	= C.SCM_SITE_ID
		 AND A.V_ITEM_ID		= C.ITEM_ID
		 AND A.V_DOM_EXP		= C.DOM_EXP
		 AND A.V_FCST_TYPE		= C.FCST_TYPE
		 AND A.V_INCOTERMS		= C.INCOTERMS
		 AND A.V_PLANT_SITE_ID	= CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
		 --AND A.V_CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID		-- [PJ2025-50017] 중요(results에 V_CELL_PROD_SITE_ID 없음)
		 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
		 -- [E20250826-000546]_지울때는 일자가 없는데, INSERT 하는 구간에만 일자를 조건으로 걸게되어, FCSTPRICE MGMT화면에서 MKT FCST, SALES PRICE를 저장하는 경우, 데이터 누락되는 현상 발생 날짜 조건 주석처리 (START)
		 --AND C.YYYYMMDD			= B.BASIS_START_DATE
		 -- [E20250826-000546]_지울때는 일자가 없는데, INSERT 하는 구간에만 일자를 조건으로 걸게되어, FCSTPRICE MGMT화면에서 MKT FCST, SALES PRICE를 저장하는 경우, 데이터 누락되는 현상 발생 날짜 조건 주석처리 (END)
		 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
		 WHERE C.PRICE > 0
		--------------------------------------------------------------------------------------------------------
		-- DM_PLN_CFM_SELLING_PRICE과 받아온 정보를 JOIN하여 TEMP TABLE 생성 (END)
		--------------------------------------------------------------------------------------------------------
		AND   C.YYYYMMDD BETWEEN A.v_min_yyyymmdd AND A.v_max_yyyymmdd -- (■park.choyi 2025.10.15) MIN, MAX YYYYMMDD 조건 추가

		--------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_속도개선 TEMP로 1차로 담고, 2차로 월요일 이후이며, 0이 아닌데이터만 추출 (START)
		--------------------------------------------------------------------------------------------------------		
		-- (■park.choyi 2025.10.15) 기간, 0 조건 적용하고 중복 데이터 없으므로 아래 쿼리 삭제
		/*
		INSERT INTO #T2_PRICE ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE )
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE
		FROM #TEMP_PRICE WITH(NOLOCK)
		WHERE YYYYMMDD >= @v_this_week_mon
		AND PRICE > 0		
		
		INSERT INTO #TEMP_DISTINCT_PRICE ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY )
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY
		FROM #T2_PRICE WITH(NOLOCK)
		GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY
		*/
		--------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_속도개선 TEMP로 1차로 담고, 2차로 월요일 이후이며, 0이 아닌데이터만 추출 (END)
		--------------------------------------------------------------------------------------------------------

		SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인
		SET @v_log_message	= 'step - 01 -03 - INSERT #T2_PRICE  ';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		


PRINT 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE : A00D--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	END
	ELSE
	BEGIN

		INSERT INTO #T2_MKT_FCST ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE )		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, C.MEASURE, A.V_PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID								-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			,  C.YYYYMMDD, C.QTY
			, @v_created_by, GETDATE()
		FROM #results A
		JOIN DM_PLN_MKT_FCST C WITH(NOLOCK)		ON A.V_DIVISION_ID = C.DIVISION_ID 
												AND A.V_PROJECT_CODE = C.PROJECT_CODE
												AND A.V_SCM_SITE_ID = C.SCM_SITE_ID
												AND A.V_ITEM_ID = C.ITEM_ID
												AND A.V_DOM_EXP = C.DOM_EXP
												AND A.V_FCST_TYPE = C.FCST_TYPE
												AND A.V_INCOTERMS	= C.INCOTERMS
												AND A.V_PLANT_SITE_ID = CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
												--AND C.QTY > 0

		INSERT INTO #T2_PRICE 
		( 
			  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
			, CELL_PROD_SITE_ID						-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, CURRENCY, MEASURE, YYYYMMDD, PRICE 
			, CREATED_BY, CREATION_DATE
		)
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID
			, '-'		AS CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, C.CURRENCY, C.MEASURE, C.YYYYMMDD, C.PRICE
			, @v_created_by, GETDATE()
		FROM #results A
		JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
		JOIN SCM_MST_FUTURE_PRICE C WITH(NOLOCK) ON A.V_DIVISION_ID = C.DIVISION_ID 
													AND A.V_PROJECT_CODE = C.PROJECT_CODE
													AND A.V_SCM_SITE_ID = C.SCM_SITE_ID
													AND A.V_ITEM_ID = C.ITEM_ID
													AND A.V_DOM_EXP = C.DOM_EXP
													AND A.V_FCST_TYPE = C.FCST_TYPE
													AND A.V_INCOTERMS	= C.INCOTERMS
													AND A.V_PLANT_SITE_ID = CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
													AND C.YYYYMMDD	= B.BASIS_START_DATE
													AND C.PRICE > 0
	END
	-- [PJ2025-50017] 40 외 사업부는 DM_PLN_MKT_FCST, SCM_MST_FUTURE_PRICE 기반 데이터 생성. (단 CELL_PROD_SITE_ID는 '-'로 처리) END
	
	-- 트랜잭션 (START)
	--BEGIN TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW;
	------------------------------------------------------------------------------------------------------	
	BEGIN TRY
	------------------------------------------------------------------------------------------------------			
		-- 확인용
		--SELECT '#results'
		--SELECT * FROM #results
		------------------------------------------------------------------------------------------------------	
		-- MULTI & SINGLE ROW (START)
		------------------------------------------------------------------------------------------------------	
		BEGIN			
			--====================================================================================================
			-- 저장진행중 STEP-01-LOG  (START)
			--====================================================================================================
			SET @v_log_type		= 'ING'; --[C20200909-000203] LOG 표준화 적용
			SET @v_log_message	= 'step - 010 - Delete dm_pln_sales_plan ';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL       
			--====================================================================================================
			-- 저장진행중 STEP-01-LOG  (END)
			--====================================================================================================			
			--====================================================================================================
			-- 기존 정보 삭제 (START)
			--====================================================================================================
			-- (■park.choyi 2025.10.15) 해당 프로시저에서 필요없는 DELETE 작업이라고 판단되어 삭제
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_EXIST 문이 시간이 오래걸려, JOIN문으로 변경한다. 원소스 주석처리 후 작성 (START) 
			------------------------------------------------------------------------------------------------------
			--DELETE FROM DM_PLN_SALES_PLAN
			/*
			DELETE A
			FROM DM_PLN_SALES_PLAN A
			INNER JOIN #results B
					ON A.DIVISION_ID	= B.v_DIVISION_ID
				   AND A.PROJECT_CODE	= B.v_project_code
				   AND A.SCM_SITE_ID	= B.v_SCM_SITE_ID
				   AND A.ITEM_ID		= B.v_item_id
				   AND A.DOM_EXP		= B.v_dom_exp
				   AND A.FCST_TYPE		= B.v_fcst_type
				   AND A.INCOTERMS		= B.v_incoterms
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_EXIST 문이 시간이 오래걸려, JOIN문으로 변경한다. 원소스 주석처리 후 작성 (END) 
			------------------------------------------------------------------------------------------------------
			--where yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
			------------------------------------------------------------------------------------------------------
			--where yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
			WHERE A.YYYYMMDD >= @v_this_week_mon 
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
			------------------------------------------------------------------------------------------------------
			--and division_id = @v_division_id
			-- MKT/금형비처럼 사람이 넣은것 삭제.	
			--AND A.ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID ) 	-- [E20250915-000105]_이미 검증된 데이터이므로, 해당 조건문 주석처리
			------------------------------------------------------------------------------------------------------				   
			-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
			------------------------------------------------------------------------------------------------------	
			AND ( SELECT COUNT(1)
				    FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
					   , DM_PLN_SALES_PLAN B WITH(NOLOCK)
				   WHERE A.SALES_PLAN_ADJUST_YN = 'N'
				     AND A.PROJECT_CODE		= B.PROJECT_CODE
				     AND A.ITEM_ID			= B.ITEM_ID
				     AND A.DIVISION_ID		= B.DIVISION_ID
				     AND A.SCM_SITE_ID		= B.SCM_SITE_ID
				     AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF')
					 ------------------------------------------------------------------------------------------------------
					 -- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
					 ------------------------------------------------------------------------------------------------------
				     --and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
				     AND B.YYYYMMDD			>= @v_this_week_mon */
					 ------------------------------------------------------------------------------------------------------
					 -- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
					 ------------------------------------------------------------------------------------------------------
					 ------------------------------------------------------------------------------------------------------
					 -- [E20250915-000105]_이미 위에서 한 작업을 이중으로 하고 있어서 주석처리 (START)
					 ------------------------------------------------------------------------------------------------------
					 /*
				     AND A.DIVISION_ID		= DM_PLN_SALES_PLAN.DIVISION_ID
				     AND A.PROJECT_CODE		= DM_PLN_SALES_PLAN.PROJECT_CODE
				     AND A.SCM_SITE_ID		= DM_PLN_SALES_PLAN.SCM_SITE_ID
				     AND A.ITEM_ID			= DM_PLN_SALES_PLAN.ITEM_ID 
					 */					 
					 ------------------------------------------------------------------------------------------------------
					 -- [E20250915-000105]_이미 위에서 한 작업을 이중으로 하고 있어서 주석처리 (END)
					 ------------------------------------------------------------------------------------------------------
					 -- (■park.choyi 2025.10.15) 해당 프로시저에서 필요없는 DELETE 작업이라고 판단되어 삭제. DELETE 구문 주석처리하면서 포함 됨 
					 --) = 0
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_EXIST 문이 시간이 오래걸려, JOIN문으로 변경한다. 원소스 주석 (START) 
			------------------------------------------------------------------------------------------------------
			/*
			and exists ( select v_division_id from #results  
						 where 1=1
						 and DIVISION_ID	= v_DIVISION_ID
						 and project_code	= v_project_code
						 and SCM_SITE_ID	= v_SCM_SITE_ID
						 and item_id		= v_item_id
						 and dom_exp		= v_dom_exp
						 and fcst_type		= v_fcst_type
						 and incoterms		= v_incoterms )
			*/
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_EXIST 문이 시간이 오래걸려, JOIN문으로 변경한다. 원소스 주석 (END) 
			------------------------------------------------------------------------------------------------------
			-- (■park.choyi 2025.10.15) 해당 프로시저에서 필요없는 DELETE 작업이라고 판단되어 삭제. DELETE 구문 주석처리하면서 포함 됨 
			--AND MEASURE NOT IN ('CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up') --[PJ2024-50611] Catch Up 메저 삭제 금지 
			--====================================================================================================
			-- 기존 정보 삭제 (END)
			--====================================================================================================
PRINT @v_program_name + ' : A002--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

 			--====================================================================================================
			-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산. (START)
			--====================================================================================================	
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_EXIST 문이 시간이 오래걸려, JOIN문으로 변경한다. 원소스 주석처리 후 작성 (START) 
			------------------------------------------------------------------------------------------------------
			--DELETE FROM DM_PLN_SALES_PLAN
			-- (■park.choyi 2025.10.15) 해당 프로시저에서 필요없는 DELETE 작업이라고 판단되어 삭제(마지막에 #SALES_PLAN_TEMP 기준으로  DM_PLN_SALES_PLAN 삭제 함)
			/*
			DELETE A
			FROM DM_PLN_SALES_PLAN A
			INNER JOIN #RESULTS_KEY B --#results B -- (■park.choyi 2025.10.15) #RESULTS_KEY 테이블로 변경 
					ON A.DIVISION_ID	= B.v_DIVISION_ID
				   AND A.PROJECT_CODE	= B.v_project_code
				   AND A.SCM_SITE_ID	= B.v_SCM_SITE_ID
				   AND A.ITEM_ID		= B.v_item_id
				   AND A.DOM_EXP		= B.v_dom_exp
				   AND A.FCST_TYPE		= B.v_fcst_type
				   AND A.INCOTERMS		= B.v_incoterms
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
			------------------------------------------------------------------------------------------------------
			--where yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
			WHERE A.YYYYMMDD BETWEEN B.v_min_yyyymmdd AND B.v_max_yyyymmdd -- (■park.choyi 2025.10.15) MIN, MAX YYYYMMDD 조건으로 변경 -->= @v_this_week_mon 
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
			------------------------------------------------------------------------------------------------------
			--and division_id = @v_division_id
			------------------------------------------------------------------------------------------------------	
			-- MKT/금형비처럼 사람이 넣은것 삭제.
			------------------------------------------------------------------------------------------------------	
			--AND A.ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID ) 	-- [E20250915-000105]_이미 검증된 데이터이므로, 해당 조건문 주석처리
			AND A.MEASURE IN ( 'MKT_FCST','CUST_FCST', 'RTF' ,'RTF_SYS_RP','TMM_FCST', 'SCM_FCST')  -- 20180417 modify skh -- 20200309 KHSONG TMM_FCST ADD --[PJ2025-50017] SCM_FCST 추가
			*/
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_EXIST 문이 시간이 오래걸려, JOIN문으로 변경한다. 원소스 주석 (START) 
			------------------------------------------------------------------------------------------------------
			/*
			and exists ( select v_division_id from #results  
						 where 1=1
						 and DIVISION_ID	= v_DIVISION_ID
						 and project_code	= v_project_code
						 and SCM_SITE_ID	= v_SCM_SITE_ID
						 and item_id		= v_item_id
						 and dom_exp		= v_dom_exp
						 and fcst_type		= v_fcst_type
						 and incoterms		= v_incoterms )	;
			*/
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_EXIST 문이 시간이 오래걸려, JOIN문으로 변경한다. 원소스 주석 (END) 
			------------------------------------------------------------------------------------------------------
			--====================================================================================================
			-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산. (END)
			--====================================================================================================
PRINT @v_program_name + ' : A003--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
									   				            
			--====================================================================================================
			-- DM_PLN_SALES_PLAN용 TEMP TABLE 생성 (START)
			--====================================================================================================
						
			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
				 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			  INTO #SALES_PLAN_TEMP  
			  FROM DM_PLN_SALES_PLAN WITH(NOLOCK) 
			 WHERE DIVISION_ID = 'x';

			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인		
			--====================================================================================================
			-- DM_PLN_SALES_PLAN용 TEMP TABLE 생성 (END)
			--====================================================================================================
PRINT @v_program_name + ' : A004--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
			--====================================================================================================
			-- 저장진행중 STEP-02-LOG  (START)
			--====================================================================================================
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'step - 02 - Insert #SALES_PLAN_TEMP ';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL     
			--====================================================================================================
			-- 저장진행중 STEP-02-LOG (END)
			--====================================================================================================			
			
PRINT @v_program_name + ' : A005--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
			--====================================================================================================
			-- Temp 테이블에 저장  (START)
			--====================================================================================================
			INSERT INTO #SALES_PLAN_TEMP
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )			
			------------------------------------------------------------------------------------------------------	
			-- MKT FCST 값을 UPDATE 함.
			------------------------------------------------------------------------------------------------------	
			SELECT -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 DISTINCT 삭제 -- DISTINCT 
			                W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						  , W.YYYYMMDD, SI.CURRENCY, W.QTY
						  , ISNULL(W.CREATED_BY, 'SYSTEM')
						  , W.CREATION_DATE	--,w.LAST_UPDATED_BY --[2018-03-15][수정]--,w.LAST_UPDATE_DATE--[2018-03-15][수정]
						  , @v_created_by	--[2018-03-15][수정][입력받은 매개변수로 처리]		
						  , GETDATE()		--[2018-03-15][수정]
						  , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5
						  , NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			  --FROM #T2_MKT_FCST W WITH(NOLOCK) -- [E20250915-000105]_애초에 데이터를 가지고 오는 방식으로 변경 
			  FROM (SELECT * FROM #T2_MKT_FCST WITH(NOLOCK) WHERE MEASURE IN ('MKT_FCST','CUST_FCST' ,'TMM_FCST', 'SCM_FCST')) W -- (■park.choyi 2025.10.15) 'CUST_FCST' ,'TMM_FCST' 삭제, 'RTF_SYS_RP' 추가
			  --LEFT OUTER JOIN #T2_PRICE SI WITH(NOLOCK) -- [E20250915-000105]_테이블 변경 GROUP BY한 데이터를 기준으로 가져옴
			  LEFT OUTER JOIN (SELECT * FROM #T2_PRICE WITH(NOLOCK) WHERE MEASURE IN ('LOC')) SI -- #TEMP_DISTINCT_PRICE SI WITH(NOLOCK) -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 #T2_PRICE 로 변경. LOC Measure 조건 추가
						   ON ( 1 = 1
						  AND W.DIVISION_ID			= SI.DIVISION_ID
						  AND W.PROJECT_CODE		= SI.PROJECT_CODE
						  AND W.SCM_SITE_ID			= SI.SCM_SITE_ID
						  AND W.ITEM_ID				= SI.ITEM_ID
						  AND W.DOM_EXP				= SI.DOM_EXP
						  AND W.FCST_TYPE			= SI.FCST_TYPE
						  AND W.INCOTERMS			= SI.INCOTERMS
						  AND W.PLANT_SITE_ID		= SI.PLANT_SITE_ID
						  AND W.CELL_PROD_SITE_ID	= SI.CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						  --AND W.YYYYMMDD			= SI.YYYYMMDD						  
						  AND W.BASIS_START_DATE	= SI.YYYYMMDD -- (■park.choyi 2025.10.15) MIN, MAX 가 적용된 YYYYMMDD 조건 추가
						  ------------------------------------------------------------------------------------------------------
						  -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (START)
						  ------------------------------------------------------------------------------------------------------
						  --AND ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD ) = SI.YYYYMMDD 
						  --AND W.BASIS_START_DATE	= SI.YYYYMMDD -- [E20250915-000105]_해당 쿼리에서는 CURRENCY만 가지고 오기때문에, 날짜 필요없음 주석처리
						  ------------------------------------------------------------------------------------------------------
						  -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (END)
						  ------------------------------------------------------------------------------------------------------
						   )							  
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리 (START)
			  ------------------------------------------------------------------------------------------------------
			  --WHERE W.MEASURE IN ('MKT_FCST','CUST_FCST' ,'TMM_FCST', 'SCM_FCST')  -- 20180417 modify skh -- 20200309 KHSONG TMM_FCST ADD --[PJ2025-50017] SCM_FCST 추가
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리 (END)
			  ------------------------------------------------------------------------------------------------------
			  --AND W.DIVISION_ID = @v_division_id
			  --AND W.YYYYMMDD >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
			  ------------------------------------------------------------------------------------------------------
			  --AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
			  --AND W.YYYYMMDD >= @v_this_week_mon -- [E20250915-000105]_이미TEMP에 담을때 당주 월요일 이후 데이터부터 담도록 수정
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
			  ------------------------------------------------------------------------------------------------------
			  --AND W.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )-- [E20250915-000105]_이미 검증된 데이터이므로, 해당 조건문 주석처리
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (START)
			  ------------------------------------------------------------------------------------------------------
				/*
				and exists (select v_division_id  
								from #results  where 1=1
									and W.DIVISION_ID		= v_DIVISION_ID
									and W.project_code		= v_project_code
									and W.SCM_SITE_ID		= v_SCM_SITE_ID
									and W.item_id			= v_item_id
									and W.dom_exp			= v_dom_exp
									and W.fcst_type			= v_fcst_type
									and W.incoterms			= v_incoterms
									)*/
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (END)
			  ------------------------------------------------------------------------------------------------------			  
			  
			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인	
			--====================================================================================================
			-- 저장진행중 STEP-02-01-LOG  (START) -- [E20250915-000105]_로그추가
			--====================================================================================================
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'step - 02-01 - Insert #SALES_PLAN_TEMP MKT_FCST, SCM_FCST, RTF_SYS_RP  저장';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL     
			--====================================================================================================
			-- 저장진행중 STEP-02-01-LOG (END)  -- [E20250915-000105]_로그추가
			--====================================================================================================			
			
			-- (■park.choyi 2025.10.15) 위 INSERT INTO #SALES_PLAN_TEMP 에서 처리하므로 주석처리
			/*
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_나눠서 저장하도록 수정 (START)
			------------------------------------------------------------------------------------------------------			  
			INSERT INTO #SALES_PLAN_TEMP
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )		
			------------------------------------------------------------------------------------------------------	
			-- RTF 값을 UPDATE 함.
			------------------------------------------------------------------------------------------------------	
			SELECT -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 DISTINCT 삭제 -- DISTINCT 
			                W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						  , W.YYYYMMDD, SI.CURRENCY, W.QTY
						  , W.CREATED_BY
						  , W.CREATION_DATE--,w.LAST_UPDATED_BY --[2018-03-15][수정]--,w.LAST_UPDATE_DATE	--[2018-03-15][수정]
						  , @v_created_by	--[2018-03-15][수정][입력받은 매개변수로 처리]		
						  , GETDATE()		--[2018-03-15][수정]
						  , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5
						  , NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			  --FROM #T2_MKT_FCST w WITH(NOLOCK) -- [E20250915-000105]_테이블 변경 GROUP BY한 데이터를 기준으로 가져옴
			  FROM (SELECT * FROM #T2_MKT_FCST WITH(NOLOCK) WHERE MEASURE IN ('RTF','RTF_SYS_RP')) W 
			  --LEFT OUTER JOIN #T2_PRICE SI WITH(NOLOCK) -- [E20250915-000105]_테이블 변경 GROUP BY한 데이터를 기준으로 가져옴
			  LEFT OUTER JOIN (SELECT * FROM #T2_PRICE WITH(NOLOCK) WHERE MEASURE IN ('LOC')) SI -- #TEMP_DISTINCT_PRICE SI WITH(NOLOCK) -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 #T2_PRICE 로 변경. LOC Measure 조건 추가
						   ON ( 1=1
						  AND W.DIVISION_ID			= SI.DIVISION_ID
						  AND W.PROJECT_CODE		= SI.PROJECT_CODE
						  AND W.SCM_SITE_ID			= SI.SCM_SITE_ID
						  AND W.ITEM_ID				= SI.ITEM_ID
						  AND W.DOM_EXP				= SI.DOM_EXP
						  AND W.FCST_TYPE			= SI.FCST_TYPE
						  AND W.INCOTERMS			= SI.INCOTERMS
						  AND W.PLANT_SITE_ID		= SI.PLANT_SITE_ID
						  AND W.CELL_PROD_SITE_ID	= SI.CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						  --AND W.YYYYMMDD			= SI.YYYYMMDD
						  AND W.BASIS_START_DATE	= SI.YYYYMMDD -- (■park.choyi 2025.10.15) MIN, MAX 가 적용된 YYYYMMDD 조건 추가
						  ------------------------------------------------------------------------------------------------------
						  -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (START)
						  ------------------------------------------------------------------------------------------------------
						  --AND ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD ) = SI.YYYYMMDD 
						  --AND W.BASIS_START_DATE = SI.YYYYMMDD	-- [E20250915-000105]_이미TEMP에 담을때 당주 월요일 이후 데이터부터 담도록 수정	
						  ------------------------------------------------------------------------------------------------------
						  -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (END)
						  ------------------------------------------------------------------------------------------------------
							)
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리 (START)
			  ------------------------------------------------------------------------------------------------------
			  --WHERE W.MEASURE IN ('RTF','RTF_SYS_RP') --20200507 KHSONG C20200507-000035
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리 (END)
			  ------------------------------------------------------------------------------------------------------
			  --AND W.DIVISION_ID = @v_division_id
			  --AND W.YYYYMMDD >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
			  ------------------------------------------------------------------------------------------------------
			  --AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
			  --AND W.YYYYMMDD >= @v_this_week_mon -- [E20250915-000105]_이미TEMP에 담을때 당주 월요일 이후 데이터부터 담도록 수정
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
			  ------------------------------------------------------------------------------------------------------
			  --AND W.ITEM_ID IN  ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )-- [E20250915-000105]_이미 검증된 데이터이므로, 해당 조건문 주석처리
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (START)
			  ------------------------------------------------------------------------------------------------------
			  */
				/*
				and exists (select v_division_id  
								from #results  where 1=1
									and W.DIVISION_ID		= v_DIVISION_ID
									and W.project_code		= v_project_code
									and W.SCM_SITE_ID		= v_SCM_SITE_ID
									and W.item_id			= v_item_id
									and W.dom_exp			= v_dom_exp
									and W.fcst_type			= v_fcst_type
									and W.incoterms			= v_incoterms
									)*/
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (END)
			  ------------------------------------------------------------------------------------------------------
			 /*
			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인	
			--====================================================================================================
			-- 저장진행중 STEP-02-02-LOG  (START) -- [E20250915-000105]_로그추가
			--====================================================================================================
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'step - 02-02 - Insert #SALES_PLAN_TEMP RTF, RTF_SYS_RP 저장';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL     
			--====================================================================================================
			-- 저장진행중 STEP-02-01-LOG (END)  -- [E20250915-000105]_로그추가
			--====================================================================================================	
			*/
			INSERT INTO #SALES_PLAN_TEMP
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )		
			------------------------------------------------------------------------------------------------------	
			-- KRW 값을 계산
			------------------------------------------------------------------------------------------------------	
			SELECT -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 DISTINCT 삭제 -- DISTINCT 
			       W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'SalesAmt_KRW' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , W.YYYYMMDD, FP.CURRENCY --,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
				 , CAST(STR(W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
				 --,w.CREATED_BY --[2018-03-15][수정] --,w.CREATION_DATE --[2018-03-15][수정] --,w.LAST_UPDATED_BY --[2018-03-15][수정] --,w.LAST_UPDATE_DATE--[2018-03-15][수정]
				 , @v_created_by	--[2018-03-15][수정]
				 , GETDATE()		--[2018-03-15][수정]
				 , 'SYSTEM'			--[2018-03-15][수정]
				 , GETDATE()		--[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5
				 , NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			 --FROM #T2_MKT_FCST W WITH(NOLOCK) -- [E20250915-000105]_테이블에서 RTF_SYS_RP 메져만 가지고 오도록 수정
			 FROM (SELECT * FROM #T2_MKT_FCST WITH(NOLOCK) WHERE MEASURE = 'RTF_SYS_RP') W 
			 --LEFT OUTER JOIN #T2_PRICE FP WITH(NOLOCK) -- [E20250915-000105]_테이블에서 KRW 메져만 가지고 오도록 수정, SALES PRICE가 존재하는 데이터만 생성하면 되므로 INNER JOIN으로 변경
			 INNER JOIN (SELECT * FROM #T2_PRICE WITH(NOLOCK) WHERE MEASURE = 'KRW' ) FP 
						  ON (	FP.DIVISION_ID			= W.DIVISION_ID
						 AND	FP.PROJECT_CODE			= W.PROJECT_CODE
						 AND	FP.SCM_SITE_ID			= W.SCM_SITE_ID
						 AND	FP.ITEM_ID				= W.ITEM_ID
						 AND	FP.DOM_EXP				= W.DOM_EXP
						 AND	FP.FCST_TYPE			= W.FCST_TYPE
						 AND	FP.INCOTERMS			= W.INCOTERMS
						 AND	FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
						 AND	FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						 --AND FP.YYYYMMDD = CASE WHEN SUBSTRING(W.YYYYMMDD, 7,2) = '01' then w.YYYYMMDD else   convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  end
						 ------------------------------------------------------------------------------------------------------
						 -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (START)
						 ------------------------------------------------------------------------------------------------------					
						 --AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd ) 
						 AND FP.YYYYMMDD = W.BASIS_START_DATE 				
						 ------------------------------------------------------------------------------------------------------
						 -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (END)
						 ------------------------------------------------------------------------------------------------------		
						 --AND FP.YYYYMMDD = convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  
						 --AND FP.MEASURE = 'KRW' -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리
							)
			/*
			left outer join dbo.SCM_MST_SITE_ITEM si WITH(NOLOCK)
			on ( 1=1
			and w.DIVISION_ID = si.DIVISION_ID
			and w.PROJECT_CODE = si.PROJECT_CODE
			and w.SCM_SITE_ID = si.SCM_SITE_ID
			and w.ITEM_ID = si.ITEM_ID
			)
			*/
			--WHERE W.MEASURE = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
			--WHERE W.MEASURE = CASE WHEN W.DIVISION_ID in ('81','40') THEN 'RTF_SYS_RP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
			--WHERE W.MEASURE = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용 -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리
			--AND W.DIVISION_ID = @v_division_id
			--AND w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112) 
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
			------------------------------------------------------------------------------------------------------
			--AND w.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
			--AND W.YYYYMMDD >= @v_this_week_mon -- [E20250915-000105]_이미TEMP에 담을때 당주 월요일 이후 데이터부터 담도록 수정
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
			------------------------------------------------------------------------------------------------------
			--AND W.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )-- [E20250915-000105]_이미 검증된 데이터이므로, 해당 조건문 주석처리
			------------------------------------------------------------------------------------------------------	
			-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
			------------------------------------------------------------------------------------------------------	
			AND ( SELECT COUNT(1)
				    FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
					   , DM_PLN_SALES_PLAN B WITH(NOLOCK)
				   WHERE A.SALES_PLAN_ADJUST_YN = 'N'
				     AND A.ITEM_ID		= B.ITEM_ID
				     AND A.DIVISION_ID	= B.DIVISION_ID
				     AND A.PROJECT_CODE	= B.PROJECT_CODE
				     AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					 AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF')
					 ------------------------------------------------------------------------------------------------------
					 -- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
					 ------------------------------------------------------------------------------------------------------
					 --AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
					 AND B.YYYYMMDD		>= @v_this_week_mon
					 ------------------------------------------------------------------------------------------------------
					 -- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
					 ------------------------------------------------------------------------------------------------------
					 AND A.DIVISION_ID  = W.DIVISION_ID
					 AND A.PROJECT_CODE = W.PROJECT_CODE
					 AND A.SCM_SITE_ID  = W.SCM_SITE_ID
					 AND A.ITEM_ID      = W.ITEM_ID	) = 0
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (START)
			  ------------------------------------------------------------------------------------------------------
			  /*
				and exists (select v_division_id  
								from #results  where 1=1
									and W.DIVISION_ID		= v_DIVISION_ID
									and W.project_code		= v_project_code
									and W.SCM_SITE_ID		= v_SCM_SITE_ID
									and W.item_id			= v_item_id
									and W.dom_exp			= v_dom_exp
									and W.fcst_type			= v_fcst_type
									and W.incoterms			= v_incoterms
									)*/
			  ------------------------------------------------------------------------------------------------------
			  -- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (END)
			  ------------------------------------------------------------------------------------------------------		

			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인		  
			--====================================================================================================
			-- 저장진행중 STEP-02-03-LOG  (START) -- [E20250915-000105]_로그추가
			--====================================================================================================
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'step - 02-03 - Insert #SALES_PLAN_TEMP SalesAmt_KRW 저장';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL     
			--====================================================================================================
			-- 저장진행중 STEP-02-01-LOG (END)  -- [E20250915-000105]_로그추가
			--====================================================================================================	

			INSERT INTO #SALES_PLAN_TEMP
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )		
			------------------------------------------------------------------------------------------------------	
			-- LOC 값을 계산
			------------------------------------------------------------------------------------------------------	
			SELECT -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 DISTINCT 삭제 -- DISTINCT 
			       W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'SalesAmt_LOC' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , W.YYYYMMDD, FP.CURRENCY --,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
				 , CAST(STR(W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
				 --,w.CREATED_BY --[2018-03-15][수정] --,w.CREATION_DATE --[2018-03-15][수정] --,w.LAST_UPDATED_BY --[2018-03-15][수정]	--,w.LAST_UPDATE_DATE --[2018-03-15][수정]
				 , @v_created_by	--[2018-03-15][수정]
				 , GETDATE()		--[2018-03-15][수정]
				 , 'SYSTEM'			--[2018-03-15][수정]
				 , GETDATE()		--[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5
				 , NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			  --FROM #T2_MKT_FCST W WITH(NOLOCK) -- [E20250915-000105]_테이블에서 RTF_SYS_RP 메져만 가지고 오도록 수정
			  FROM (SELECT * FROM #T2_MKT_FCST WITH(NOLOCK) WHERE MEASURE = 'RTF_SYS_RP') W 
			 --LEFT OUTER JOIN #T2_PRICE FP WITH(NOLOCK) -- [E20250915-000105]_테이블에서 LOC 메져만 가지고 오도록 수정, SALES PRICE가 존재하는 데이터만 생성하면 되므로 INNER JOIN으로 변경
			 INNER JOIN (SELECT * FROM #T2_PRICE WITH(NOLOCK) WHERE MEASURE = 'LOC' ) FP 
						   ON ( FP.DIVISION_ID			= W.DIVISION_ID
						  AND	FP.PROJECT_CODE			= W.PROJECT_CODE
						  AND	FP.SCM_SITE_ID			= W.SCM_SITE_ID
						  AND	FP.ITEM_ID				= W.ITEM_ID
						  AND	FP.DOM_EXP				= W.DOM_EXP
						  AND	FP.FCST_TYPE			= W.FCST_TYPE
						  AND	FP.INCOTERMS			= W.INCOTERMS
						  AND	FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
						  AND	FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						  --AND FP.YYYYMMDD = CASE WHEN SUBSTRING(W.YYYYMMDD, 7,2) = '01' then w.YYYYMMDD else   convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  end
						  ------------------------------------------------------------------------------------------------------
						  -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (START)
						  ------------------------------------------------------------------------------------------------------
						  --AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )
						  AND	FP.YYYYMMDD = W.BASIS_START_DATE 					 
						  ------------------------------------------------------------------------------------------------------
						  -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (END)
						  ------------------------------------------------------------------------------------------------------
						  --AND FP.YYYYMMDD = convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  
						  --AND	FP.MEASURE = 'LOC' -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리
								)
			/*
			left outer join dbo.SCM_MST_SITE_ITEM si WITH(NOLOCK)
			on ( 1=1
			and w.DIVISION_ID = si.DIVISION_ID
			and w.PROJECT_CODE = si.PROJECT_CODE
			and w.SCM_SITE_ID = si.SCM_SITE_ID
			and w.ITEM_ID = si.ITEM_ID
			)
			*/
			--WHERE W.MEASURE = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
			--WHERE W.MEASURE = CASE WHEN W.DIVISION_ID in ('81','40') THEN 'RTF_SYS_RP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
			--WHERE W.MEASURE = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용 -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리
			--AND W.DIVISION_ID = @v_division_id
			--AND W.YYYYMMDD >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)   
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
			------------------------------------------------------------------------------------------------------
			--AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)   
			--AND W.YYYYMMDD >= @v_this_week_mon -- [E20250915-000105]_이미TEMP에 담을때 당주 월요일 이후 데이터부터 담도록 수정
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
			------------------------------------------------------------------------------------------------------
			--AND W.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )-- [E20250915-000105]_이미 검증된 데이터이므로, 해당 조건문 주석처리
			------------------------------------------------------------------------------------------------------	
			-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
			------------------------------------------------------------------------------------------------------	
			AND ( SELECT COUNT(1)
				   FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
					  , DM_PLN_SALES_PLAN B WITH(NOLOCK)
				   WHERE A.SALES_PLAN_ADJUST_YN ='N'
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF')
					------------------------------------------------------------------------------------------------------
					-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
					------------------------------------------------------------------------------------------------------
					--AND yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
					AND B.YYYYMMDD		>= @v_this_week_mon 			
					------------------------------------------------------------------------------------------------------
					-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
					------------------------------------------------------------------------------------------------------
					AND A.DIVISION_ID    = W.DIVISION_ID
					AND A.PROJECT_CODE   = W.PROJECT_CODE
					AND A.SCM_SITE_ID    = W.SCM_SITE_ID
					AND A.ITEM_ID        = W.ITEM_ID ) = 0						  
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (START)
			------------------------------------------------------------------------------------------------------
			/*
			and exists (select v_division_id  
							from #results  where 1=1
								and W.DIVISION_ID		= v_DIVISION_ID
								and W.project_code		= v_project_code
								and W.SCM_SITE_ID		= v_SCM_SITE_ID
								and W.item_id			= v_item_id
								and W.dom_exp			= v_dom_exp
								and W.fcst_type			= v_fcst_type
								and W.incoterms			= v_incoterms
								)*/
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (END)
			------------------------------------------------------------------------------------------------------
			
			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인		  
			--====================================================================================================
			-- 저장진행중 STEP-02-04-LOG  (START) -- [E20250915-000105]_로그추가
			--====================================================================================================
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'step - 02-04 - Insert #SALES_PLAN_TEMP SalesAmt_LOC 저장';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL     
			--====================================================================================================
			-- 저장진행중 STEP-02-04-LOG (END)  -- [E20250915-000105]_로그추가
			--====================================================================================================	
			
			INSERT INTO #SALES_PLAN_TEMP
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )		
			------------------------------------------------------------------------------------------------------	
			-- LOC 값을 계산
			------------------------------------------------------------------------------------------------------	
			SELECT -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 DISTINCT 삭제 -- DISTINCT 
			       W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'SalesAmt_USD' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , W.YYYYMMDD, FP.CURRENCY --,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
				 , CAST(STR(W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
				 --,w.CREATED_BY --[2018-03-15][수정] --,w.CREATION_DATE --[2018-03-15][수정] --,w.LAST_UPDATED_BY --[2018-03-15][수정]	--,w.LAST_UPDATE_DATE --[2018-03-15][수정]
				 , @v_created_by	--[2018-03-15][수정]
				 , GETDATE()		--[2018-03-15][수정]
				 , 'SYSTEM'			--[2018-03-15][수정]
				 , GETDATE()		--[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5
				 , NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			--FROM #T2_MKT_FCST W WITH(NOLOCK) -- [E20250915-000105]_테이블에서 RTF_SYS_RP 메져만 가지고 오도록 수정
			 FROM (SELECT * FROM #T2_MKT_FCST WITH(NOLOCK) WHERE MEASURE = 'RTF_SYS_RP') W 
		    --LEFT OUTER JOIN #T2_PRICE FP WITH(NOLOCK) -- [E20250915-000105]_테이블에서 LOC 메져만 가지고 오도록 수정, SALES PRICE가 존재하는 데이터만 생성하면 되므로 INNER JOIN으로 변경
			  INNER JOIN  (SELECT * FROM #T2_PRICE WITH(NOLOCK) WHERE MEASURE = 'USD') FP
						 ON (FP.DIVISION_ID			= W.DIVISION_ID
						AND	 FP.PROJECT_CODE		= W.PROJECT_CODE
						AND	 FP.SCM_SITE_ID			= W.SCM_SITE_ID
						AND	 FP.ITEM_ID				= W.ITEM_ID
						AND	 FP.DOM_EXP				= W.DOM_EXP
						AND	 FP.FCST_TYPE			= W.FCST_TYPE
						AND	 FP.INCOTERMS			= W.INCOTERMS
						AND	 FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
						AND	 FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						--AND FP.YYYYMMDD = CASE WHEN SUBSTRING(W.YYYYMMDD, 7,2) = '01' then w.YYYYMMDD else   convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  end
						------------------------------------------------------------------------------------------------------
						-- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (START)
						------------------------------------------------------------------------------------------------------
						--AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
						AND FP.YYYYMMDD				= W.BASIS_START_DATE 
						------------------------------------------------------------------------------------------------------
						-- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (END)
						------------------------------------------------------------------------------------------------------
						--AND FP.YYYYMMDD = convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  
						--AND FP.MEASURE				= 'USD' -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리
							)
            /*  
			left outer join dbo.SCM_MST_SITE_ITEM si WITH(NOLOCK)
			on ( 1=1
			and w.DIVISION_ID = si.DIVISION_ID
			and w.PROJECT_CODE = si.PROJECT_CODE
			and w.SCM_SITE_ID = si.SCM_SITE_ID
			and w.ITEM_ID = si.ITEM_ID
			)
			*/
			--WHERE W.MEASURE = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
			--WHERE W.MEASURE = CASE WHEN W.DIVISION_ID in ('81','40') THEN 'RTF_SYS_RP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
			--WHERE W.MEASURE = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용 -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리
			--AND W.DIVISION_ID = @v_division_id
			--AND W.YYYYMMDD >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)    
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
			------------------------------------------------------------------------------------------------------
			--AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
			--AND W.YYYYMMDD >= @v_this_week_mon  -- [E20250915-000105]_이미TEMP에 담을때 당주 월요일 이후 데이터부터 담도록 수정
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
			------------------------------------------------------------------------------------------------------
			--AND W.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )-- [E20250915-000105]_이미 검증된 데이터이므로, 해당 조건문 주석처리
			------------------------------------------------------------------------------------------------------	
			-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
			------------------------------------------------------------------------------------------------------	
			AND ( SELECT COUNT(1)
				  FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
				  	 , DM_PLN_SALES_PLAN B WITH(NOLOCK)
				  WHERE A.SALES_PLAN_ADJUST_YN  = 'N'
				    AND A.ITEM_ID		= b.ITEM_ID
				    AND A.DIVISION_ID	= b.DIVISION_ID
				    AND A.PROJECT_CODE	= b.PROJECT_CODE
				    AND A.SCM_SITE_ID	= b.SCM_SITE_ID
				    AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF')					
					------------------------------------------------------------------------------------------------------
					-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (START)
					------------------------------------------------------------------------------------------------------
				    --AND yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
				    AND B.YYYYMMDD		>= @v_this_week_mon 
					------------------------------------------------------------------------------------------------------
					-- [E20250915-000105]_당주 월요일 변수를 사용하도록 수정 원소스 주석처리 (END)
					------------------------------------------------------------------------------------------------------
				    AND A.DIVISION_ID   = W.DIVISION_ID
				    AND A.PROJECT_CODE  = W.PROJECT_CODE
				    AND A.SCM_SITE_ID   = W.SCM_SITE_ID
				    AND A.ITEM_ID       = W.ITEM_ID ) = 0
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (START)
			------------------------------------------------------------------------------------------------------
			/*
			and exists (select v_division_id  
							from #results  where 1=1
								and W.DIVISION_ID		= v_DIVISION_ID
								and W.project_code		= v_project_code
								and W.SCM_SITE_ID		= v_SCM_SITE_ID
								and W.item_id			= v_item_id
								and W.dom_exp			= v_dom_exp
								and W.fcst_type			= v_fcst_type
								and W.incoterms			= v_incoterms
								)*/
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (END)
			------------------------------------------------------------------------------------------------------
			
			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인	
			--====================================================================================================
			-- 저장진행중 STEP-02-05-LOG  (START) -- [E20250915-000105]_로그추가
			--====================================================================================================
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'step - 02-05 - Insert #SALES_PLAN_TEMP SalesAmt_USD 저장';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL     
			--====================================================================================================
			-- 저장진행중 STEP-02-05-LOG (END)  -- [E20250915-000105]_로그추가
			--====================================================================================================				


			--[E20250122-000837]_Sales Plan 화면 MKT FCST AMT. 개선요청 원소스 주석처리 START
			/*  MKT FCST에서 저장한 대상 ITEM의 정보를 바라보고, MKT FCST 데이터를 생성하는데, MKT FCST Amt.(KRW), MKT FCST Amt.(LOC) 
			(일자도 MKT FCST에서 저장한 대상의 날짜만 생성) 현재는 MKT FCST Amt.(KRW), MKT FCST Amt.(LOC)가 가장 마지막에 변경된 데이터만 생성되었던 상황*/
			/* 
			UNION ALL
			-- 소형 MKT_FCST_AMT 추가
			SELECT   A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP
				, A.V_FCST_TYPE, A.V_INCOTERMS
				, 'MKT_AMT_' + P.MEASURE AS  MEASURE
				, A.V_PLANT_SITE_ID, A.V_YYYYMMDD, P.CURRENCY
				, CAST( A.V_QTY * P.PRICE AS NUMERIC(30, 10))
				, @v_created_by, GETDATE(), 'SYSTEM', GETDATE()		
				, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
			FROM #results A  WITH(NOLOCK)
			JOIN #T_PRICE P  WITH(NOLOCK)
			ON     P.DIVISION_ID    = A.V_DIVISION_ID
				AND P.PROJECT_CODE  = A.V_PROJECT_CODE
				AND P.SCM_SITE_ID   = A.V_SCM_SITE_ID
				AND P.ITEM_ID       = A.V_ITEM_ID
				AND P.DOM_EXP       = A.V_DOM_EXP
				AND P.FCST_TYPE     = A.V_FCST_TYPE
				AND P.INCOTERMS     = A.V_INCOTERMS
				AND P.PLANT_SITE_ID = A.V_PLANT_SITE_ID
				AND P.YYYYMMDD		= A.V_YYYYMMDD
				AND P.MEASURE		IN ( 'KRW','LOC' ) 
			WHERE A.V_MEASURE = 'MKT_FCST'
			AND A.V_DIVISION_ID = '40'
			AND A.V_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			*/

			INSERT INTO #SALES_PLAN_TEMP
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )		
			SELECT -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 DISTINCT 삭제 -- DISTINCT 
			       W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
				 , 'MKT_AMT_LOC' AS MEASURE
				 , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , W.YYYYMMDD, FP.CURRENCY	--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
				 , CAST(STR(W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) AS QTY
				 , @v_created_by, GETDATE(), 'SYSTEM', GETDATE()		
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5
				 , NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			--FROM #T2_MKT_FCST W WITH(NOLOCK) -- [E20250915-000105]_테이블에서 MKT_FCST 메져만 가지고 오도록 수정
			 FROM (SELECT * FROM #T2_MKT_FCST WITH(NOLOCK) WHERE MEASURE = 'MKT_FCST') W 
		    --INNER JOIN #T2_PRICE FP WITH(NOLOCK) -- [E20250915-000105]_테이블에서 LOC 메져만 가지고 오도록 수정, SALES PRICE가 존재하는 데이터만 생성하면 되므로 INNER JOIN으로 변경
			  INNER JOIN  (SELECT * FROM #T2_PRICE WITH(NOLOCK) WHERE MEASURE = 'LOC' ) FP
			--INNER JOIN  (SELECT * FROM DM_PLN_CFM_SELLING_PRICE WITH(NOLOCK) WHERE MEASURE = 'LOC' AND YYYYMMDD >= @v_this_week_mon) FP
				   ON ( FP.DIVISION_ID			= W.DIVISION_ID
				  AND	FP.PROJECT_CODE			= W.PROJECT_CODE
				  AND	FP.SCM_SITE_ID			= W.SCM_SITE_ID
				  AND	FP.ITEM_ID				= W.ITEM_ID
				  AND	FP.DOM_EXP				= W.DOM_EXP
				  AND	FP.FCST_TYPE			= W.FCST_TYPE
				  AND	FP.INCOTERMS			= W.INCOTERMS
				  AND	FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
				  AND	FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				  ------------------------------------------------------------------------------------------------------
				  -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (START)
				  ------------------------------------------------------------------------------------------------------
				  --AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
				  AND   FP.YYYYMMDD = W.BASIS_START_DATE 
				  ------------------------------------------------------------------------------------------------------
				  -- [E20250915-000105]_TEMP테이블에 이미 매핑된 값으로 사용하도록 수정 원소스 주석처리 (END)
				  ------------------------------------------------------------------------------------------------------
				  --AND   FP.MEASURE IN ( 'LOC', 'KRW') -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리
				  ) 
			--WHERE W.MEASURE = 'MKT_FCST' -- [E20250915-000105]_데이터 조회시 미리 조회한 데이터를 기반으로 JOIN하도록 상단에 추가 하단 쿼리문 주석처리
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (START)
			------------------------------------------------------------------------------------------------------
			/*
			and exists (select v_division_id  
							from #results  where 1=1
								and W.DIVISION_ID		= v_DIVISION_ID
								and W.project_code		= v_project_code
								and W.SCM_SITE_ID		= v_SCM_SITE_ID
								and W.item_id			= v_item_id
								and W.dom_exp			= v_dom_exp
								and W.fcst_type			= v_fcst_type
								and W.incoterms			= v_incoterms
								)*/
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_이미 #results 데이터 기반으로 생성한 부분임으로 불필요한 로직으로 판단하여 주석처리한다 (END)
			------------------------------------------------------------------------------------------------------
			; 
			--[E20250122-000837]_Sales Plan 화면 MKT FCST AMT. 개선요청 원소스 주석처리 END		
			
			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인	
			--====================================================================================================
			-- 저장진행중 STEP-02-06-LOG  (START) -- [E20250915-000105]_로그추가
			--====================================================================================================
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'step - 02-06 - Insert #SALES_PLAN_TEMP MKT_AMT_LOC 저장';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL     
			--====================================================================================================
			-- 저장진행중 STEP-02-06-LOG (END)  -- [E20250915-000105]_로그추가
			--====================================================================================================			
			
			INSERT INTO #SALES_PLAN_TEMP
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )		
			SELECT -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 DISTINCT 삭제 -- DISTINCT 
			       W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
				 , 'MKT_AMT_KRW' AS MEASURE
				 , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID	
				 , W.YYYYMMDD, FP.CURRENCY	
				 , CAST(STR(W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) AS QTY
				 , @v_created_by, GETDATE(), 'SYSTEM', GETDATE()		
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5
				 , NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			 FROM (SELECT * FROM #T2_MKT_FCST WITH(NOLOCK) WHERE MEASURE = 'MKT_FCST') W 
			  INNER JOIN  (SELECT * FROM #T2_PRICE WITH(NOLOCK) WHERE MEASURE = 'KRW' ) FP
			  --INNER JOIN  (SELECT * FROM DM_PLN_CFM_SELLING_PRICE WITH(NOLOCK) WHERE MEASURE = 'KRW' AND YYYYMMDD >= @v_this_week_mon) FP
				   ON ( FP.DIVISION_ID			= W.DIVISION_ID
				  AND	FP.PROJECT_CODE			= W.PROJECT_CODE
				  AND	FP.SCM_SITE_ID			= W.SCM_SITE_ID
				  AND	FP.ITEM_ID				= W.ITEM_ID
				  AND	FP.DOM_EXP				= W.DOM_EXP
				  AND	FP.FCST_TYPE			= W.FCST_TYPE
				  AND	FP.INCOTERMS			= W.INCOTERMS
				  AND	FP.PLANT_SITE_ID		= W.PLANT_SITE_ID
				  AND	FP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID		
				  AND   FP.YYYYMMDD				= W.BASIS_START_DATE 
					  ) 
					  
			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인	
			--====================================================================================================
			-- 저장진행중 STEP-02-07-LOG  (START) -- [E20250915-000105]_로그추가
			--====================================================================================================
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'step - 02-07 - Insert #SALES_PLAN_TEMP MKT_AMT_KRW 저장';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL     
			--====================================================================================================
			-- 저장진행중 STEP-02-07-LOG (END)  -- [E20250915-000105]_로그추가
			--====================================================================================================		
			------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_나눠서 저장하도록 수정 (END)
			------------------------------------------------------------------------------------------------------		
			DECLARE @v_int_count				INT
			SELECT @v_int_count = COUNT(1) FROM #SALES_PLAN_TEMP
PRINT @v_program_name + ' : A007--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
			--====================================================================================================
			-- 저장진행중 STEP-02-08-LOG  (START)
			--====================================================================================================		
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'step - 02-07 - #SALES_PLAN_TEMP COUNT';
			SET @n_log_count	= @v_int_count;
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL 
			--====================================================================================================
			-- 저장진행중 STEP-02-08-LOG (END)
			--====================================================================================================	
			--====================================================================================================
			-- 테이블의 중복제거 (START)
			--====================================================================================================
			BEGIN
				------------------------------------------------------------------------------------------------------
				-- [E20250915-000105]_EXIST 문이 시간이 오래걸려, JOIN문으로 변경한다. 원소스 주석처리 후 작성 (START) 
				------------------------------------------------------------------------------------------------------
				/*
				DELETE FROM DM_PLN_SALES_PLAN 
				WHERE EXISTS ( SELECT B.DIVISION_ID 
								 FROM #SALES_PLAN_TEMP B WITH(NOLOCK)
								WHERE 1=1
								  AND DM_PLN_SALES_PLAN.DIVISION_ID			= B.DIVISION_ID  
								  AND DM_PLN_SALES_PLAN.PROJECT_CODE		= B.PROJECT_CODE                          
								  AND DM_PLN_SALES_PLAN.SCM_SITE_ID			= B.SCM_SITE_ID                           
								  AND DM_PLN_SALES_PLAN.ITEM_ID				= B.ITEM_ID                               
								  AND DM_PLN_SALES_PLAN.DOM_EXP				= B.DOM_EXP                               
								  AND DM_PLN_SALES_PLAN.FCST_TYPE			= B.FCST_TYPE                             
								  AND DM_PLN_SALES_PLAN.INCOTERMS			= B.INCOTERMS                             
								  AND DM_PLN_SALES_PLAN.MEASURE				= B.MEASURE                               
								  AND DM_PLN_SALES_PLAN.PLANT_SITE_ID		= B.PLANT_SITE_ID                         
								  AND DM_PLN_SALES_PLAN.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가                     
								  AND DM_PLN_SALES_PLAN.YYYYMMDD			= B.YYYYMMDD )
				AND EXISTS ( SELECT v_division_id  
							   FROM #results  
							  WHERE 1=1
							    AND DIVISION_ID		= v_DIVISION_ID
							    AND PROJECT_CODE	= v_project_code
							    AND SCM_SITE_ID		= v_SCM_SITE_ID
							    AND ITEM_ID			= v_item_id
							    AND DOM_EXP			= v_dom_exp
							    AND FCST_TYPE		= v_fcst_type
							    AND INCOTERMS		= v_incoterms ) */
				
				
				-- (■park.choyi 2025.10.15) #SALES_PLAN_TEMP_KEY 테이블, 데이터 생성 START
				
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,
					FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID,
					MIN(YYYYMMDD) AS V_MIN_YYYYMMDD,
					MAX(YYYYMMDD) AS V_MAX_YYYYMMDD
				INTO #SALES_PLAN_TEMP_KEY  -- YYYYMMDD 를 제외한 Key 값 기준의 MIN, MAX YYYYMMDD 테이블 생성
				FROM #SALES_PLAN_TEMP
				GROUP BY  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,
					FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID;
										
				DELETE A
				FROM DM_PLN_SALES_PLAN A
				INNER JOIN #SALES_PLAN_TEMP_KEY C WITH(NOLOCK) -- #SALES_PLAN_TEMP B WITH(NOLOCK) -- (■park.choyi 2025.10.15) YYYYMMDD 는 MIN, MAX YYYYMMDD 적용
						ON A.DIVISION_ID		= C.DIVISION_ID
					   AND A.PROJECT_CODE		= C.PROJECT_CODE
					   AND A.SCM_SITE_ID		= C.SCM_SITE_ID
					   AND A.ITEM_ID			= C.ITEM_ID
					   AND A.DOM_EXP			= C.DOM_EXP
					   AND A.FCST_TYPE			= C.FCST_TYPE
					   AND A.INCOTERMS			= C.INCOTERMS
					   AND A.MEASURE			= C.MEASURE
					   AND A.PLANT_SITE_ID		= C.PLANT_SITE_ID
					   AND A.CELL_PROD_SITE_ID	= C.CELL_PROD_SITE_ID
				WHERE A.YYYYMMDD BETWEEN C.v_min_yyyymmdd AND C.v_max_yyyymmdd -- 누락되는 YYYYMMDD가 존재할 수 있으므로 MIN, MAX YYYYMMDD 기간의 데이터를 모두 삭제 
								
				-- (■park.choyi 2025.10.15) #SALES_PLAN_TEMP_KEY 테이블, 데이터 생성 END


			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인		
			
			END
			--====================================================================================================
			-- 테이블의 중복제거 (END)
			--====================================================================================================
PRINT @v_program_name + ' : A008--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
				   
			--====================================================================================================
			-- 저장진행중 STEP-03-LOG  (START)
			--====================================================================================================					   
			SET @v_log_type		= 'ING';
			SET @v_log_message	= 'step - 03 - DELETE dm_pln_sales_plan ';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL 
			--====================================================================================================
			-- 저장진행중 STEP-04-LOG  (END)
			--====================================================================================================	
PRINT @v_program_name + ' : A009--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
		
			--====================================================================================================
			-- TEMP TABLE -> SALES PLAN TABLE에 데이터 적재  (START)
			--====================================================================================================

			INSERT INTO DM_PLN_SALES_PLAN 
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, SYSDATETIME() AS LAST_UPDATE_DATE
				 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			  FROM #SALES_PLAN_TEMP WITH(NOLOCK) 
			  -- (■park.choyi 2025.10.15) 중복데이터가 제거되었으므로 GROUP BY 삭제
			  /*
			 GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				 */

			SET @n_log_count = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인
			--====================================================================================================
			-- TEMP TABLE -> SALES PLAN TABLE에 데이터 적재  (END)
			--====================================================================================================
PRINT @v_program_name + ' : A010--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
			--====================================================================================================
			-- 저장진행중 STEP-04-LOG  (START)
			--====================================================================================================					   
			SET @v_log_type		= 'ING';
			SET @v_log_message	= 'step - 04 - Insert dm_pln_sales_plan ';
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message	= NULL 
			--====================================================================================================
			-- 저장진행중 STEP-04-LOG  (END)
			--====================================================================================================	
		    END
			------------------------------------------------------------------------------------------------------	
			-- MULTI & SINGLE ROW END 
			------------------------------------------------------------------------------------------------------		
			--====================================================================================================
			-- [PJ2025-50188] 임시테이블 DROP 처리 (START)
			--====================================================================================================
			BEGIN
				IF OBJECT_ID('tempdb..#T2_MKT_FCST') IS NOT NULL
					DROP TABLE  #T2_MKT_FCST;         
				IF OBJECT_ID('tempdb..#T2_PRICE') IS NOT NULL
					DROP TABLE  #T2_PRICE;          
				IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL
					DROP TABLE  #SALES_PLAN_TEMP  					
			END				   	
			--====================================================================================================
			-- [PJ2025-50188] 임시테이블 DROP 처리 (END)
			--====================================================================================================

    -- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
    --  COMMIT WORK;
	
	------------------------------------------------------------------------------------------------------	
		END TRY
	------------------------------------------------------------------------------------------------------	
	
	------------------------------------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------		
	-- 트랜잭션 (START)
	------------------------------------------------------------------------------------------------------	
	--ROLLBACK TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW;
	
		--====================================================================================================
		-- ERROR LOG VALUE SAVE
		--====================================================================================================
		  SET @v_log_type		= 'ERROR';
		  SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		  SET @v_description	= 'ERROR_LINE : ' + STR(ERROR_LINE());
		  SET @d_event_date		= SYSDATETIME();

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
		  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  
	------------------------------------------------------------------------------------------------------		
	-- 트랜잭션 (END)
	------------------------------------------------------------------------------------------------------	

	------------------------------------------------------------------------------------------------------
    END CATCH;
	------------------------------------------------------------------------------------------------------
	
	--====================================================================================================
	-- 종료 LOG  (START)
	--====================================================================================================  
    IF @v_log_message IS NULL
	BEGIN
		SET @v_log_type		= 'END';
		SET @v_log_message	= '########## END of procedure ##########';
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END
	--====================================================================================================
	-- 종료 LOG  (END)
	--====================================================================================================  
	
	--====================================================================================================
	-- 트랜잭션 (START)
	--====================================================================================================  
	ERR_RTN:
	IF @v_log_type = 'INVALID'
	BEGIN
		SET @v_log_message	= '########## END of procedure ##########';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END
	--====================================================================================================
	-- 트랜잭션 (END)
	--====================================================================================================  

  END;



