
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
 *===================================================================================================================================================*/
 
CREATE PROCEDURE [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE_20250916]
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


	-- CUTOFF 변수 설정

	-- 스플릿관련 변수
	DECLARE @recv_division_id	NVARCHAR(MAX);
	SET		@recv_division_id = NULL;		
	--SET @recv_division_id = @p_division_id;
	DECLARE @v_delimiter			NVARCHAR(1)
	SET		@v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
    DECLARE @v_division_id      NVARCHAR(MAX);
	DECLARE @v_created_by       NVARCHAR(MAX);

	--20250915 JSSBAE (START)
	DECLARE @v_this_week_mon	NVARCHAR(8);
	SET		@v_this_week_mon = CONVERT(NVARCHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)	
	--20250915 JSSBAE (END)

	SET @v_created_by = ISNULL((SELECT MAX(v_created_by) FROM #results GROUP BY v_division_id),'SYSTEM')

	-- [PJ2025-50017] 소형 매출계획 동기화 개선 Start
	SELECT @v_division_id = MAX(v_division_id) FROM #results;

	-- [PJ2025-50188] 임시테이블 DROP 처리 Start
	BEGIN
		IF OBJECT_ID('tempdb..#T2_MKT_FCST') IS NOT NULL
			DROP TABLE  #T2_MKT_FCST;         
		IF OBJECT_ID('tempdb..#T2_PRICE') IS NOT NULL
			DROP TABLE  #T2_PRICE;          
	END
	-- [PJ2025-50188] 임시테이블 DROP 처리 End

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
	, BASIS_START_DATE	NVARCHAR(8)			--20250915 JSSBAE
	);	

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
	
	   	  
	-- [PJ2025-50017] 40 사업부는 DM_PLN_CFM_MKT_DEMAND_PLAN, DM_PLN_CFM_SELLING_PRICE 기반 데이터 생성
	-- [PJ2025-50017] 40 외 사업부는 DM_PLN_MKT_FCST, SCM_MST_FUTURE_PRICE 기반 데이터 생성. (단 CELL_PROD_SITE_ID는 '-'로 처리) START
	IF (@v_division_id = '40')
	BEGIN

		INSERT INTO #T2_MKT_FCST ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, BASIS_START_DATE --20250915 JSSBAE 
		)	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, C.MEASURE, A.V_PLANT_SITE_ID, C.CELL_PROD_SITE_ID								-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			,  C.YYYYMMDD, C.QTY
			, @v_created_by, GETDATE(), D.BASIS_START_DATE --20250915 JSSBAE
		FROM #results A
		JOIN DM_PLN_CFM_MKT_DEMAND_PLAN C WITH(NOLOCK)	ON A.V_DIVISION_ID = C.DIVISION_ID 
														AND A.V_PROJECT_CODE = C.PROJECT_CODE
														AND A.V_SCM_SITE_ID = C.SCM_SITE_ID
														AND A.V_ITEM_ID = C.ITEM_ID
														AND A.V_DOM_EXP = C.DOM_EXP
														AND A.V_FCST_TYPE = C.FCST_TYPE
														AND A.V_INCOTERMS	= C.INCOTERMS
														AND A.V_PLANT_SITE_ID = CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
														--AND A.V_CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID		-- [PJ2025-50017] 중요(results에 V_CELL_PROD_SITE_ID 없음)
														--AND C.QTY > 0
		JOIN SCM_SYS_CALENDAR_M D WITH(NOLOCK)
		  ON D.BASIS_YYYYMMDD = C.YYYYMMDD

		INSERT INTO #T2_PRICE ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE  )	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID, C.CELL_PROD_SITE_ID													-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			, C.CURRENCY, C.MEASURE, C.YYYYMMDD, C.PRICE
			, @v_created_by, GETDATE()
		FROM #results A
		------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- [E20250826-000546]_지울때는 일자가 없는데, INSERT 하는 구간에만 일자를 조건으로 걸게되어, FCSTPRICE MGMT화면에서 MKT FCST, SALES PRICE를 저장하는 경우, 데이터 누락되는 현상 발생 날짜 조건 주석처리 (START)
		--JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
		-- [E20250826-000546]_지울때는 일자가 없는데, INSERT 하는 구간에만 일자를 조건으로 걸게되어, FCSTPRICE MGMT화면에서 MKT FCST, SALES PRICE를 저장하는 경우, 데이터 누락되는 현상 발생 날짜 조건 주석처리 (END)
		------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		JOIN DM_PLN_CFM_SELLING_PRICE C WITH(NOLOCK) ON A.V_DIVISION_ID		= C.DIVISION_ID 
													AND A.V_PROJECT_CODE	= C.PROJECT_CODE
													AND A.V_SCM_SITE_ID		= C.SCM_SITE_ID
													AND A.V_ITEM_ID			= C.ITEM_ID
													AND A.V_DOM_EXP			= C.DOM_EXP
													AND A.V_FCST_TYPE		= C.FCST_TYPE
													AND A.V_INCOTERMS		= C.INCOTERMS
													AND A.V_PLANT_SITE_ID	= CASE WHEN A.V_DIVISION_ID = '81' THEN C.PLANT_SITE_ID ELSE A.V_PLANT_SITE_ID END
														--AND A.V_CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID		-- [PJ2025-50017] 중요(results에 V_CELL_PROD_SITE_ID 없음)
													------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
													-- [E20250826-000546]_지울때는 일자가 없는데, INSERT 하는 구간에만 일자를 조건으로 걸게되어, FCSTPRICE MGMT화면에서 MKT FCST, SALES PRICE를 저장하는 경우, 데이터 누락되는 현상 발생 날짜 조건 주석처리 (START)
													--AND C.YYYYMMDD			= B.BASIS_START_DATE
													-- [E20250826-000546]_지울때는 일자가 없는데, INSERT 하는 구간에만 일자를 조건으로 걸게되어, FCSTPRICE MGMT화면에서 MKT FCST, SALES PRICE를 저장하는 경우, 데이터 누락되는 현상 발생 날짜 조건 주석처리 (END)
													------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
													AND C.PRICE > 0
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

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		--BEGIN TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		
          -- 확인용
		  --SELECT '#results'
		  --SELECT * FROM #results
		  /*----------------------------- MULTI & SINGLE ROW START -------------------------------------------------------------*/
		    BEGIN
				
				
		SET @v_log_type = 'ING'; --[C20200909-000203] LOG 표준화 적용
		SET @v_log_message = 'step - 010 - Delete dm_pln_sales_plan ';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL       

   				-- 기존 정보 삭제
				delete dbo.dm_pln_sales_plan
				-- where yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
				 --where yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) --20250915 JSSBAE
				 where yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
				   --and division_id = @v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id ) 
				   
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   --and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) --20250915 JSSBAE
							   and yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
							   and a.division_id    = dm_pln_sales_plan.division_id
							   and a.project_code   = dm_pln_sales_plan.project_code
							   and a.scm_site_id    = dm_pln_sales_plan.scm_site_id
							   and a.item_id        = dm_pln_sales_plan.item_id
				       ) = 0
					and exists (select v_division_id  
									from #results  where 1=1
										and DIVISION_ID		= v_DIVISION_ID
										and project_code	= v_project_code
										and SCM_SITE_ID		= v_SCM_SITE_ID
										and item_id			= v_item_id
										and dom_exp			= v_dom_exp
										and fcst_type		= v_fcst_type
										and incoterms		= v_incoterms
										)
				     AND MEASURE NOT IN ('CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up') --[PJ2024-50611] Catch Up 메저 삭제 금지    
				                  
                -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산.
				delete dbo.dm_pln_sales_plan
				 --where yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) --20250915 JSSBAE
				 where yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
				   --and division_id = @v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   and MEASURE in ( 'MKT_FCST','CUST_FCST', 'RTF' ,'RTF_SYS_RP','TMM_FCST', 'SCM_FCST')  -- 20180417 modify skh -- 20200309 KHSONG TMM_FCST ADD --[PJ2025-50017] SCM_FCST 추가
					and exists (select v_division_id  
									from #results  where 1=1
										and DIVISION_ID		= v_DIVISION_ID
										and project_code	= v_project_code
										and SCM_SITE_ID		= v_SCM_SITE_ID
										and item_id			= v_item_id
										and dom_exp			= v_dom_exp
										and fcst_type		= v_fcst_type
										and incoterms		= v_incoterms
										)
				;
									   				            

				IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL
					BEGIN 
						DROP TABLE  #SALES_PLAN_TEMP          
					END 
			  	SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
					,PLANT_SITE_ID
					,CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					,YYYYMMDD,CURRENCY,QTY
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				INTO #SALES_PLAN_TEMP  
				FROM dbo.dm_pln_sales_plan WITH(NOLOCK) 
				where division_id = 'x';

				
				
		SET @v_log_type = 'ING';
		SET @v_log_message = 'step - 02 - Insert #SALES_PLAN_TEMP ';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL     

				-- 신규 정보 추가

				-- Temp 테이블에 저장
				INSERT INTO #SALES_PLAN_TEMP
				(
					 DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
					,PLANT_SITE_ID
					,CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					,YYYYMMDD,CURRENCY,QTY
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				)
				-- MKT FCST 값을 update 함.
				select   distinct
				         w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,w.MEASURE
						,w.PLANT_SITE_ID
						,w.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,w.YYYYMMDD
						,si.CURRENCY
						,w.QTY
						,isnull(w.CREATED_BY,'SYSTEM')
						,w.CREATION_DATE
						--,w.LAST_UPDATED_BY				--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE				--[2018-03-15][수정]
						,@v_created_by					    --[2018-03-15][수정][입력받은 매개변수로 처리]		
						,GETDATE()							--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from #T2_MKT_FCST w  WITH(NOLOCK)
					left outer join #T2_PRICE si WITH(NOLOCK)
					on ( 1=1
						and w.DIVISION_ID   = si.DIVISION_ID
						and w.PROJECT_CODE  = si.PROJECT_CODE
						and w.SCM_SITE_ID   = si.SCM_SITE_ID
						and w.ITEM_ID       = si.ITEM_ID
						and w.DOM_EXP       = si.dom_exp
						and w.fcst_type     = si.fcst_type
						and w.INCOTERMS     = si.INCOTERMS
						and w.plant_site_id = si.plant_site_id
						and w.cell_prod_site_id = si.cell_prod_site_id		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						AND W.BASIS_START_DATE = SI.YYYYMMDD			--20250915 JSSBAE
						-- and w.yyyymmdd      = si.yyyymmdd
						--and ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd --20250915 JSSBAE
					)
					where w.measure in ('MKT_FCST','CUST_FCST' ,'TMM_FCST', 'SCM_FCST')  -- 20180417 modify skh -- 20200309 KHSONG TMM_FCST ADD --[PJ2025-50017] SCM_FCST 추가
					--and w.division_id = @v_division_id
					-- and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
					--and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)--20250915 JSSBAE
					and w.yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
					--20250915 JSSBAE (START)
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
					--20250915 JSSBAE (END)
				UNION ALL 
				-- RTF 값을 update 함.
				select   distinct
				         w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,w.MEASURE
						,w.PLANT_SITE_ID
						,w.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,w.YYYYMMDD
						,si.CURRENCY
						,w.QTY
						,w.CREATED_BY
						,w.CREATION_DATE
						--,w.LAST_UPDATED_BY				--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE				--[2018-03-15][수정]
						,@v_created_by					    --[2018-03-15][수정][입력받은 매개변수로 처리]		
						,GETDATE()							--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from #T2_MKT_FCST w WITH(NOLOCK)
					left outer join #T2_PRICE si WITH(NOLOCK)
					on ( 1=1
						and w.DIVISION_ID   = si.DIVISION_ID
						and w.PROJECT_CODE  = si.PROJECT_CODE
						and w.SCM_SITE_ID   = si.SCM_SITE_ID
						and w.ITEM_ID       = si.ITEM_ID
						and w.DOM_EXP       = si.dom_exp
						and w.fcst_type     = si.fcst_type
						and w.INCOTERMS     = si.INCOTERMS
						and w.plant_site_id = si.plant_site_id
						and w.cell_prod_site_id = si.cell_prod_site_id			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						-- and w.yyyymmdd      = si.yyyymmdd
						--and ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd --20250915 JSSBAE
						AND W.BASIS_START_DATE = SI.YYYYMMDD			--20250915 JSSBAE
					)
					where w.measure IN ('RTF','RTF_SYS_RP') --20200507 KHSONG C20200507-000035
					--and w.division_id = @v_division_id
					-- and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
					--and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)--20250915 JSSBAE
					and w.yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
					--20250915 JSSBAE (START)
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
					--20250915 JSSBAE (END)
				UNION ALL 
				-- KRW 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID 
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_KRW' MEASURE
						,w.PLANT_SITE_ID
						,w.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,w.YYYYMMDD
						,fp.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
						--,w.CREATED_BY						--[2018-03-15][수정]
						--,w.CREATION_DATE					--[2018-03-15][수정]
						--,w.LAST_UPDATED_BY				--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE				--[2018-03-15][수정]
						,@v_created_by						--[2018-03-15][수정]
						,GETDATE()							--[2018-03-15][수정]
						,'SYSTEM'						--[2018-03-15][수정]
						,GETDATE()							--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from #T2_MKT_FCST w  WITH(NOLOCK)
					left outer join #T2_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						and FP.cell_prod_site_id = w.cell_prod_site_id		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						-- AND FP.YYYYMMDD = CASE WHEN SUBSTRING(W.YYYYMMDD, 7,2) = '01' then w.YYYYMMDD else   convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  end
						--AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd ) --20250915 JSSBAE
						AND FP.YYYYMMDD = W.BASIS_START_DATE --20250915 JSSBAE
						--AND FP.YYYYMMDD = convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  
						AND FP.MEASURE = 'KRW' 
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
					--where w.measure = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
					--where w.measure = CASE WHEN W.DIVISION_ID in ('81','40') THEN 'RTF_SYS_RP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
					where w.measure = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
					--and w.division_id = @v_division_id
				--	and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)   
					--and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)--20250915 JSSBAE
					and w.yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   --and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) --20250915 JSSBAE
							   and yyyymmdd >=  @v_this_week_mon --20250915 JSSBAE
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) = 0
					--20250915 JSSBAE (START)
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
					--20250915 JSSBAE (END)
				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_LOC' MEASURE
						,w.PLANT_SITE_ID
						,w.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,w.YYYYMMDD
						,FP.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
						--,w.CREATED_BY							--[2018-03-15][수정]
						--,w.CREATION_DATE						--[2018-03-15][수정]
						--,w.LAST_UPDATED_BY					--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE					--[2018-03-15][수정]
						,@v_created_by							--[2018-03-15][수정]
						,GETDATE()								--[2018-03-15][수정]
						,'SYSTEM'    							--[2018-03-15][수정]
						,GETDATE()								--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1	
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from #T2_MKT_FCST w  WITH(NOLOCK)
					left outer join #T2_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						and FP.cell_prod_site_id = w.cell_prod_site_id		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						--AND FP.YYYYMMDD = CASE WHEN SUBSTRING(W.YYYYMMDD, 7,2) = '01' then w.YYYYMMDD else   convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  end
						--AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )--20250915 JSSBAE
						AND FP.YYYYMMDD = W.BASIS_START_DATE --20250915 JSSBAE
						--AND FP.YYYYMMDD = convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  
						AND FP.MEASURE = 'LOC' 
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
					--where w.measure = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
					--where w.measure = CASE WHEN W.DIVISION_ID in ('81','40') THEN 'RTF_SYS_RP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
					where w.measure = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
					--and w.division_id = @v_division_id
				--	and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)   
				    --and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) --20250915 JSSBAE  
				    and w.yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   --and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) --20250915 JSSBAE  
							   and yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) = 0
					--20250915 JSSBAE (START)
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
					--20250915 JSSBAE (END)
				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_USD' MEASURE
						,w.PLANT_SITE_ID
						,w.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,w.YYYYMMDD
						,FP.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
						--,w.CREATED_BY								--[2018-03-15][수정]
						--,w.CREATION_DATE							--[2018-03-15][수정]
						--,w.LAST_UPDATED_BY						--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE						--[2018-03-15][수정]
						,@v_created_by								--[2018-03-15][수정]
						,GETDATE()									--[2018-03-15][수정]
						,'SYSTEM'    							--[2018-03-15][수정]
						,GETDATE()								--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from #T2_MKT_FCST w  WITH(NOLOCK)
					left outer join #T2_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						and FP.cell_prod_site_id = w.cell_prod_site_id		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						--AND FP.YYYYMMDD = CASE WHEN SUBSTRING(W.YYYYMMDD, 7,2) = '01' then w.YYYYMMDD else   convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  end
						--AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )--20250915 JSSBAE
						AND FP.YYYYMMDD = W.BASIS_START_DATE --20250915 JSSBAE
						--AND FP.YYYYMMDD = convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  
						AND FP.MEASURE = 'USD' 
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
					--where w.measure = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
					--where w.measure = CASE WHEN W.DIVISION_ID in ('81','40') THEN 'RTF_SYS_RP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
					where w.measure = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
					--and w.division_id = @v_division_id
				--	and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)    
				   --and w.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) --20250915 JSSBAE  
				   and w.yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   --and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  --20250915 JSSBAE  
							   and yyyymmdd >= @v_this_week_mon --20250915 JSSBAE
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) = 0
					--20250915 JSSBAE (START)
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
					--20250915 JSSBAE (END)
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
					, @V_CREATED_BY, GETDATE(), 'SYSTEM', GETDATE()		
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
				UNION ALL				
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID 
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						, CASE WHEN FP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW' 
								WHEN FP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
								END AS MEASURE
						,w.PLANT_SITE_ID
						,w.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,w.YYYYMMDD
						,fp.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						, CASE WHEN FP.MEASURE = 'KRW' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								WHEN FP.MEASURE = 'LOC' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								END AS QTY
						, @V_CREATED_BY, GETDATE(), 'SYSTEM', GETDATE()		
						, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
					from #T2_MKT_FCST w  WITH(NOLOCK)
					inner join #T2_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						and FP.cell_prod_site_id = w.cell_prod_site_id		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						--AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )--20250915 JSSBAE
						AND FP.YYYYMMDD = W.BASIS_START_DATE --20250915 JSSBAE
						AND FP.MEASURE IN ( 'LOC', 'KRW')
					   )
					where w.measure = 'MKT_FCST'
					--20250915 JSSBAE (START)
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
					--20250915 JSSBAE (END)
					; 
				--[E20250122-000837]_Sales Plan 화면 MKT FCST AMT. 개선요청 원소스 주석처리 END

		SET @v_log_type = 'ING';
		SET @v_log_message = 'step - 03 - Delete ';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL     

				-- 테이블의 중복제거
				   BEGIN
					   DELETE 
					   FROM dbo.dm_pln_sales_plan 
					   WHERE exists(
								SELECT B.DIVISION_ID 
								  FROM #SALES_PLAN_TEMP B WITH(NOLOCK)
								 where 1=1
								   and dm_pln_sales_plan.DIVISION_ID    =  B.DIVISION_ID  
								   and dm_pln_sales_plan.PROJECT_CODE   =  B.PROJECT_CODE                          
								   and dm_pln_sales_plan.SCM_SITE_ID    =  B.SCM_SITE_ID                           
								   and dm_pln_sales_plan.ITEM_ID        =  B.ITEM_ID                               
								   and dm_pln_sales_plan.DOM_EXP        =  B.DOM_EXP                               
								   and dm_pln_sales_plan.FCST_TYPE      =  B.FCST_TYPE                             
								   and dm_pln_sales_plan.INCOTERMS      =  B.INCOTERMS                             
								   and dm_pln_sales_plan.MEASURE        =  B.MEASURE                               
								   and dm_pln_sales_plan.PLANT_SITE_ID  =  B.PLANT_SITE_ID                         
								   and dm_pln_sales_plan.CELL_PROD_SITE_ID  =  B.CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가                     
								   and dm_pln_sales_plan.YYYYMMDD       =  B.YYYYMMDD                              
							  )
					and exists (select v_division_id  
									from #results  where 1=1
										and DIVISION_ID		= v_DIVISION_ID
										and project_code	= v_project_code
										and SCM_SITE_ID		= v_SCM_SITE_ID
										and item_id			= v_item_id
										and dom_exp			= v_dom_exp
										and fcst_type		= v_fcst_type
										and incoterms		= v_incoterms
										)
				   END
				   
		SET @v_log_type = 'ING';
		SET @v_log_message = 'step - 04 - Insert dm_pln_sales_plan ';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL 
		
		


				INSERT  INTO  dbo.dm_pln_sales_plan 
				(	 DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
					,PLANT_SITE_ID,CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					,YYYYMMDD,CURRENCY,QTY
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				)
				SELECT distinct 
					   DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
					  ,PLANT_SITE_ID,CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,YYYYMMDD,CURRENCY,QTY
					  ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,SYSDATETIME() as LAST_UPDATE_DATE
					  ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					  ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM #SALES_PLAN_TEMP WITH(NOLOCK) 

		    END
          /*----------------------------- MULTI & SINGLE ROW END ---------------------------------------------------------------*/

			-- [PJ2025-50188] 임시테이블 DROP 처리 Start
			BEGIN
				IF OBJECT_ID('tempdb..#T2_MKT_FCST') IS NOT NULL
					DROP TABLE  #T2_MKT_FCST;         
				IF OBJECT_ID('tempdb..#T2_PRICE') IS NOT NULL
					DROP TABLE  #T2_PRICE;          
			END
			-- [PJ2025-50188] 임시테이블 DROP 처리 End

     -- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
    --  COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    IF @v_log_message IS NULL
		BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END

	-- 트랜잭션 (END)
	ERR_RTN:
	IF @v_log_type = 'INVALID'
		begin
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end

  END;



