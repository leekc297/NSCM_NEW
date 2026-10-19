

/*=====================================================================================================================================================
 * Program ID   : PR_DM_PLN_CFM_TO_MKT_FCST 
 * Description  : 
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 2025-01-23	KANG.H.J		[PJ2025-50017] [소형매출동기화] Cell_Prod_Site 기반으로 데이터 생성 - 최초 개발
 * 2025-01-23	KANG.H.J		[PJ2025-50188] [소형매출동기화] 기준수요 반영
 * 2025-05-20	KANG.H.J		[PJ2025-50017] #SEND_TARGET_DATA에 CELL_PROD_SITE_ID 추가
 * 2025-11-04	JSSBAE			[E20251021-000634]_FCST&PRICE MGMT SALES PLAN 데이터 동기화 속도개선
 * 2025-12-29	JSSBAE			[E20251223-000672]_Sales Price 동기화 배치 생성 요청
 * 2026-03-09	JSSBAE			[E20260309-000271]_DMF0082 UI Sales Price 저장 로직 개선
*===================================================================================================================================================*/
--EXEC PR_DM_PLN_CFM_TO_MKT_FCST '81'
CREATE PROCEDURE [dbo].[PR_DM_PLN_CFM_TO_MKT_FCST]
	 @p_created_by			NVARCHAR(MAX)	 
AS
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
	
	--=====================================================================================================================================================
	-- LOG 용 변수 설정 (START)
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_CFM_TO_MKT_FCST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	-- LOG 용 변수 설정 (END)
	--=====================================================================================================================================================

PRINT @v_program_name + ' : A001--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	
	--=====================================================================================================================================================
	-- 프로시져 사용 변수 설정  (START)
    DECLARE @v_division_id					NVARCHAR(30);
    DECLARE @v_created_by					NVARCHAR(100);
	--[E20251223-000672]_변수 사용시 규칙에 맞게 변경 원소스 주석처리 후 변수명 변경 (START)
    --DECLARE @plan_start_yyyymmdd			NVARCHAR(8);
    DECLARE @v_plan_start_yyyymmdd			NVARCHAR(8);
	
 	--SET @plan_start_yyyymmdd	= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 월요일	
 	SET @v_plan_start_yyyymmdd	= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 월요일	
	--[E20251223-000672]_변수 사용시 규칙에 맞게 변경 원소스 주석처리 후 변수명 변경 (END)

	--SET @p_created_by			= RTRIM(@p_created_by    ) + '^';
	--SET @v_created_by			= LEFT(@P_created_by, CASE WHEN PATINDEX('%^%', @P_created_by) > 1 THEN PATINDEX('%^%', @P_created_by) ELSE 100 END -1)
	SET @v_division_id			= '40'
	-- 프로시져 사용 변수 설정  (END)
	--=====================================================================================================================================================	
PRINT @v_program_name + ' : A002--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	
	--=====================================================================================================================================================	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '@p_created_by : ' + @p_created_by ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      
	-- 시작 LOG  (END)
	--=====================================================================================================================================================
PRINT @v_program_name + ' : A003--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	
	--=====================================================================================================================================================
	-- TEMP 테이블 DROP (START)
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 데이터 DM_PLN_MKT_FCST 기준 테이블 데이터로 임시 테이블 존재 여부 확인 후 DROP
	IF OBJECT_ID (N'tempdb..#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-- DM_PLN_CFM_SELLING_PRICE 테이블 데이터 SCM_MST_FUTURE_PRICE 기준 테이블 데이터로 임시 테이블 존재 여부 확인 후 DROP
	IF OBJECT_ID (N'tempdb..#TEMP_DM_PLN_CFM_SELLING_PRICE', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_PLN_CFM_SELLING_PRICE
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-- #SEND_TARGET_DATA 기준 테이블 데이터로 임시 테이블 존재 여부 확인 후 DROP & CREATE
	IF OBJECT_ID (N'tempdb..#SEND_TARGET_DATA', N'U') IS NOT NULL 
		DROP TABLE #SEND_TARGET_DATA

	CREATE TABLE #SEND_TARGET_DATA  
	( DIVISION_ID		NVARCHAR(30) NOT NULL
	, PROJECT_CODE		NVARCHAR(50) NOT NULL
	, SCM_SITE_ID		NVARCHAR(30) NOT NULL
	, ITEM_ID			NVARCHAR(50) NOT NULL
	, DOM_EXP			NVARCHAR(03) NOT NULL
	, FCST_TYPE			NVARCHAR(20) NOT NULL
	, INCOTERMS			NVARCHAR(10) NOT NULL
	, PLANT_SITE_ID		NVARCHAR(30) NOT NULL
	, CELL_PROD_SITE_ID NVARCHAR(30) NULL
	, VMI_YN			NVARCHAR(01) NULL)
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-- #results 기준 테이블 데이터로 임시 테이블 존재 여부 확인 후 DROP & CREATE	
	IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL 		
		DROP TABLE #results

	CREATE TABLE #results 
	( v_division_id		NVARCHAR(30) NOT NULL
	, v_project_code	NVARCHAR(50) NOT NULL
	, v_scm_site_id		NVARCHAR(30) NOT NULL
	, v_item_id			NVARCHAR(50) NOT NULL
	, v_dom_exp			NVARCHAR(03) NOT NULL
	, v_fcst_type		NVARCHAR(20) NOT NULL
	, v_incoterms		NVARCHAR(10) NOT NULL
	, v_measure			NVARCHAR(50) NOT NULL
	, v_plant_site_id	NVARCHAR(30) NOT NULL
	, v_yyyymmdd		NVARCHAR(08) NOT NULL
	, v_created_by		NVARCHAR(150) NULL )

	-- TEMP 테이블 DROP  (END)
	--=====================================================================================================================================================	

	--=====================================================================================================================================================
	-- 트랜잭션 (START)
	BEGIN TRANSACTION PR_DM_PLN_CFM_TO_MKT_FCST;
	BEGIN TRY
		BEGIN
			-- [E20251223-000672]_굳이 TEMP로 계속 담아 작업을 하지 않아도됨. 간략하게 진행하기 위해 원소스 주석 후 생성한다 (START)
			/*
			SELECT ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				,   MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, CURRENCY, QTY_PRICE, CREATED_BY
			into #results_MKT_FCST
			FROM #T_MAIN  with(nolock)
			WHERE DIVISION_ID	= @v_division_id
			AND   MEASURE		IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ')			-- [PJ2025-50188] 기준수요 포함
			AND   YYYYMMDD		>= @plan_start_yyyymmdd
			;


			-- [PJ2025-50017] 기존 테이블에 아직 업데이트 안되어 있으므로 임시테이블을 통해 업데이트 처리함.
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
				,  A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
				,  A.YYYYMMDD, A.QTY
			INTO #temp_DM_PLN_CFM_MKT_DEMAND_PLAN
			FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
			INNER JOIN (
						SELECT DISTINCT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
									,   MEASURE, PLANT_SITE_ID		-- CELL_PROD_SITE_ID, YYYYMMDD 와 무관하게 모두 가져옴.
						FROM 	#results_MKT_FCST  WITH(NOLOCK)
						GROUP BY	DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
								,   MEASURE, PLANT_SITE_ID
			) B
			ON  A.DIVISION_ID		= B.DIVISION_ID
			AND A.PROJECT_CODE		= B.PROJECT_CODE
			AND A.END_CUSTOMER		= B.END_CUSTOMER
			AND A.SCM_SITE_ID		= B.SCM_SITE_ID
			AND A.ITEM_ID			= B.ITEM_ID
			AND A.DOM_EXP			= B.DOM_EXP
			AND A.FCST_TYPE			= B.FCST_TYPE
			AND A.INCOTERMS			= B.INCOTERMS
			AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
			AND A.MEASURE			= B.MEASURE
			--AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			--AND A.YYYYMMDD			= B.YYYYMMDD
			WHERE A.DIVISION_ID = @v_division_id
			AND   A.MEASURE		IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ')		-- [PJ2025-50188] 기준수요 포함
			AND   A.YYYYMMDD	>= @plan_start_yyyymmdd
			;


			UPDATE A
			SET A.QTY = B.QTY_PRICE
			FROM #temp_DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
			INNER JOIN (
						SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
							,   MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID,YYYYMMDD, QTY_PRICE 
						FROM 	#results_MKT_FCST  WITH(NOLOCK)
			) B
			ON  A.DIVISION_ID		= B.DIVISION_ID
			AND A.PROJECT_CODE		= B.PROJECT_CODE
			AND A.END_CUSTOMER		= B.END_CUSTOMER
			AND A.SCM_SITE_ID		= B.SCM_SITE_ID
			AND A.ITEM_ID			= B.ITEM_ID
			AND A.DOM_EXP			= B.DOM_EXP
			AND A.FCST_TYPE			= B.FCST_TYPE
			AND A.INCOTERMS			= B.INCOTERMS
			AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
			AND A.MEASURE			= B.MEASURE
			AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			AND A.YYYYMMDD			= B.YYYYMMDD
			WHERE A.DIVISION_ID = @v_division_id
			AND   A.MEASURE		IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ')		-- [PJ2025-50188] 기준수요 포함
			AND   A.YYYYMMDD	>= @plan_start_yyyymmdd		

			SELECT ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				,   MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, CURRENCY, QTY_PRICE, CREATED_BY
			into #results_FUTURE_PRICE
			FROM #T_MAIN A with(nolock)
			INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK)
			ON  A.YYYYMMDD = B.BASIS_YYYYMMDD
			WHERE A.DIVISION_ID = @v_division_id
			AND   A.YYYYMMDD >= @plan_start_yyyymmdd
			AND   A.MEASURE IN ('LOC', 'KRW', 'USD')
			AND    (B.DAYOFWEEK = 'MON' OR B.CALENDAR_DAY = '01')		-- [PJ2025-50017]  월요일 또는 월초		WHERE A.DIVISION_ID	= @v_division_id
			AND   A.YYYYMMDD	>= @plan_start_yyyymmdd
			;

			-- [PJ2025-50017] 기존 테이블에 아직 업데이트 안되어 있으므로 임시테이블을 통해 업데이트 처리함.
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
				,  A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
				,  A.PRICE
			INTO #temp_DM_PLN_CFM_SELLING_PRICE
			FROM DM_PLN_CFM_SELLING_PRICE A WITH(NOLOCK)
			INNER JOIN (
						SELECT DISTINCT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
									,   MEASURE, PLANT_SITE_ID		-- CURRENCY, CELL_PROD_SITE_ID, YYYYMMDD 와 무관하게 모두 가져옴.
						FROM 	#results_FUTURE_PRICE  WITH(NOLOCK)
						GROUP BY	DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
								,   MEASURE, PLANT_SITE_ID
			) B
			ON  A.DIVISION_ID		= B.DIVISION_ID
			AND A.PROJECT_CODE		= B.PROJECT_CODE
			AND A.END_CUSTOMER		= B.END_CUSTOMER
			AND A.SCM_SITE_ID		= B.SCM_SITE_ID
			AND A.ITEM_ID			= B.ITEM_ID
			AND A.DOM_EXP			= B.DOM_EXP
			AND A.FCST_TYPE			= B.FCST_TYPE
			AND A.INCOTERMS			= B.INCOTERMS
			AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
			AND A.MEASURE			= B.MEASURE
			--AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			--AND A.YYYYMMDD			= B.YYYYMMDD
			WHERE A.DIVISION_ID = @v_division_id
			AND   A.MEASURE IN ('LOC', 'KRW', 'USD')
			AND   A.YYYYMMDD		>= @plan_start_yyyymmdd
			;
			
			UPDATE A
			SET		A.PRICE		= B.QTY_PRICE
				,	A.CURRENCY	= B.CURRENCY 
			FROM #temp_DM_PLN_CFM_SELLING_PRICE A WITH(NOLOCK)
			INNER JOIN (
						SELECT  DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
							,   MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE  
						FROM 	#results_FUTURE_PRICE  WITH(NOLOCK)
			) B
			ON  A.DIVISION_ID		= B.DIVISION_ID
			AND A.PROJECT_CODE		= B.PROJECT_CODE
			AND A.END_CUSTOMER		= B.END_CUSTOMER
			AND A.SCM_SITE_ID		= B.SCM_SITE_ID
			AND A.ITEM_ID			= B.ITEM_ID
			AND A.DOM_EXP			= B.DOM_EXP
			AND A.FCST_TYPE			= B.FCST_TYPE
			AND A.INCOTERMS			= B.INCOTERMS
			AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
			AND A.MEASURE			= B.MEASURE
			AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			AND A.YYYYMMDD			= B.YYYYMMDD
			WHERE A.DIVISION_ID = @v_division_id
			AND   A.MEASURE IN ('LOC', 'KRW', 'USD')
			AND   A.YYYYMMDD	>= @plan_start_yyyymmdd

			-- [PJ2025-50017] DM_PLN_MKT_FCST는YYYYMMDD 까지 모두 지우고 INSERT 할 것.
			-- 단, SCM_MST_FUTURE_PRICE는 물동이 없는 구간도 있고, 이 부분은 다시 생성되기가 어렵기 때문에 지우지 않고 현재단가에서 업데이트 함.
			DELETE A 
			FROM DM_PLN_MKT_FCST A	WITH(NOLOCK)
			INNER JOIN (
						SELECT DISTINCT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
									,   MEASURE, PLANT_SITE_ID		-- CELL_PROD_SITE_ID, YYYYMMDD 와 무관하게 모두 삭제.
						FROM 	#results_MKT_FCST  WITH(NOLOCK)
						GROUP BY	DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
								,   MEASURE, PLANT_SITE_ID
			) B
			ON	A.DIVISION_ID		= B.DIVISION_ID
			AND A.PROJECT_CODE		= B.END_CUSTOMER
			AND A.SCM_SITE_ID		= B.SCM_SITE_ID
			AND A.ITEM_ID			= B.ITEM_ID
			AND A.DOM_EXP			= B.DOM_EXP
			AND A.FCST_TYPE			= B.FCST_TYPE
			AND A.INCOTERMS			= B.INCOTERMS
			AND A.MEASURE			= B.MEASURE
			AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
			--AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID	/* CELL_PROD_SITE_ID와 관계없이 삭제함.*/
			--AND A.YYYYMMDD			= B.YYYYMMDD		/* 모든 날짜에 대해서 삭제함.*/
			WHERE A.DIVISION_ID	= @v_division_id
			AND   A.MEASURE		IN ('MKT_FCST','SCM_FCST','VMI_IN_REQ')			-- [PJ2025-50188] 기준수요 포함
			AND   A.YYYYMMDD	>= @plan_start_yyyymmdd
		   
			-- [PJ2025-50017] 사용자가 변경한 데이터를 Cell_Prod_Site_ID와 관계없이 SUM하여  iNSERT
			MERGE INTO DM_PLN_MKT_FCST A
			USING (
					SELECT A.DIVISION_ID
						,  A.END_CUSTOMER	AS PROJECT_CODE
						,  A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						,  A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
						,  SUM(A.QTY)		AS SUM_QTY
						,  @v_created_by	AS LAST_UPDATED_BY
						,  GETDATE()		AS LAST_UPDATE_DATE
					FROM  #temp_DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.MEASURE		IN ( 'MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ')	-- [PJ2025-50188] 기준수요 포함
					AND   A.YYYYMMDD	>= @plan_start_yyyymmdd
					GROUP BY A.DIVISION_ID
						,  A.END_CUSTOMER	
						,  A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						,  A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
			) B
			ON  (
						A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.DOM_EXP		= B.DOM_EXP
					AND A.FCST_TYPE		= B.FCST_TYPE
					AND A.INCOTERMS		= B.INCOTERMS
					AND	A.MEASURE		= B.MEASURE
					AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
					AND A.YYYYMMDD		= B.YYYYMMDD
			)
			WHEN MATCHED THEN
				UPDATE SET A.QTY				= B.SUM_QTY
						,  A.LAST_UPDATED_BY	= B.LAST_UPDATED_BY	 
						,  A.LAST_UPDATE_DATE	= B.LAST_UPDATE_DATE
			WHEN NOT MATCHED THEN
				INSERT (
   						   DIVISION_ID
						 , PROJECT_CODE
						 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
						 , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
						 , QTY 
						 , CREATED_BY, CREATION_DATE
						 , LAST_UPDATED_BY, LAST_UPDATE_DATE
				)
				VALUES (
						   B.DIVISION_ID
						 , B.PROJECT_CODE
						 , B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE
						 , B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.YYYYMMDD
						 , B.SUM_QTY 
						 , @v_created_by, GETDATE()
						 , B.LAST_UPDATED_BY, B.LAST_UPDATE_DATE
				)
			;
			
			-- [PJ2025-50017] 사용자가 변경한 데이터를 Cell_Prod_Site_ID와 관계없이 물동가중평균하여 iNSERT
			-- [PJ2025-50017] 0단계 : PRICE를 0으로 변경한 단가는 FUTURE_PRICE에서 삭제함. AMT도 같이 삭제함.
			DELETE A
			FROM SCM_MST_FUTURE_PRICE A
			INNER JOIN (
						SELECT  DIVISION_ID
							,   END_CUSTOMER				AS PROJECT_CODE
							,   SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
							,   MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY
						FROM 	#results_FUTURE_PRICE  WITH(NOLOCK)
						WHERE  QTY_PRICE = 0
						GROUP BY DIVISION_ID
							,   END_CUSTOMER				
							,   SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
							,   MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY
			) Z
			ON	A.DIVISION_ID		= Z.DIVISION_ID
			AND A.PROJECT_CODE		= Z.PROJECT_CODE
			AND A.SCM_SITE_ID		= Z.SCM_SITE_ID
			AND A.PLANT_SITE_ID		= Z.PLANT_SITE_ID
			AND A.ITEM_ID			= Z.ITEM_ID
			AND A.YYYYMMDD			= Z.YYYYMMDD
			AND A.CURRENCY			= Z.CURRENCY
			AND A.DOM_EXP			= Z.DOM_EXP
			AND A.FCST_TYPE			= Z.FCST_TYPE
			AND A.INCOTERMS			= Z.INCOTERMS
			WHERE 1=1
			AND   Z.MEASURE IN ('LOC', 'KRW', 'USD')
			;

			DELETE A
			FROM DM_PLN_SALES_PLAN A
			INNER JOIN (
						SELECT  DIVISION_ID
							,   END_CUSTOMER				AS PROJECT_CODE
							,   SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
							,   MEASURE, PLANT_SITE_ID, YYYYMMDD
						FROM 	#results_FUTURE_PRICE  WITH(NOLOCK)
						WHERE  QTY_PRICE = 0
						GROUP BY DIVISION_ID
							,   END_CUSTOMER				
							,   SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
							,   MEASURE, PLANT_SITE_ID, YYYYMMDD
			) Z
			ON	A.DIVISION_ID		= Z.DIVISION_ID
			AND A.PROJECT_CODE		= Z.PROJECT_CODE
			AND A.SCM_SITE_ID		= Z.SCM_SITE_ID
			AND A.PLANT_SITE_ID		= Z.PLANT_SITE_ID
			AND A.ITEM_ID			= Z.ITEM_ID
			AND A.YYYYMMDD			= Z.YYYYMMDD
			AND A.DOM_EXP			= Z.DOM_EXP
			AND A.FCST_TYPE			= Z.FCST_TYPE
			AND A.INCOTERMS			= Z.INCOTERMS
			AND A.MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
			WHERE  1=1
			AND   Z.MEASURE IN ('LOC', 'KRW', 'USD')
			;

			-- [PJ2025-50017] 1단계 : 물동이 없는 경우를 대비하여 단순평균 우선 적용함 (물동이 없는 경우는 아래와 같이 정의되어야 함.)
			MERGE INTO SCM_MST_FUTURE_PRICE A
			USING (
				SELECT    A.DIVISION_ID
						, A.PROJECT_CODE
						, A.END_CUSTOMER 
						, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
						, B.BASIS_START_DATE		AS YYYYMMDD
						, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME
						, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						, AVG(A.PRICE)				AS AVG_PRICE
						,  @v_created_by			AS LAST_UPDATED_BY
						,  GETDATE()				AS LAST_UPDATE_DATE
				FROM #temp_DM_PLN_CFM_SELLING_PRICE A WITH(NOLOCK)
				INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK)
				ON  A.YYYYMMDD = B.BASIS_YYYYMMDD
				WHERE A.DIVISION_ID = @v_division_id
				--AND   A.ITEM_ID = 'MCP498170C10-M04'
				--AND   A.SCM_SITE_ID = 'Nexcon_CN_NJG'
				AND   A.YYYYMMDD >= @plan_start_yyyymmdd
				AND   A.MEASURE IN ('LOC', 'KRW', 'USD')
				AND    (B.DAYOFWEEK = 'MON' OR B.CALENDAR_DAY = '01')		-- 월요일 또는 월초
				AND   A.PRICE	<> 0
				GROUP BY A.DIVISION_ID
						, A.PROJECT_CODE
						, A.END_CUSTOMER 
						, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
						, B.BASIS_START_DATE
						, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME
						, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
			) B
			ON (	A.DIVISION_ID		= B.DIVISION_ID
				AND A.PROJECT_CODE		= B.END_CUSTOMER
				AND A.SCM_SITE_ID		= B.SCM_SITE_ID
				AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
				AND A.ITEM_ID			= B.ITEM_ID
				AND A.YYYYMMDD			= B.YYYYMMDD
				AND A.CURRENCY			= B.CURRENCY
				AND A.MEASURE			= B.MEASURE
				AND A.DOM_EXP			= B.DOM_EXP
				AND A.FCST_TYPE			= B.FCST_TYPE
				AND A.INCOTERMS			= B.INCOTERMS
			)
			WHEN MATCHED THEN
				UPDATE SET A.PRICE				= B.AVG_PRICE
						,  A.LAST_UPDATED_BY	= B.LAST_UPDATED_BY	 
						,  A.LAST_UPDATE_DATE	= B.LAST_UPDATE_DATE
			WHEN NOT MATCHED THEN
				INSERT (
   							  DIVISION_ID
							, PROJECT_CODE
							, SCM_SITE_ID, PLANT_SITE_ID
							, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE
							, DOM_EXP, FCST_TYPE, INCOTERMS
							, PRICE 
							, CREATED_BY, CREATION_DATE
							, LAST_UPDATED_BY, LAST_UPDATE_DATE
				)
				VALUES (
							B.DIVISION_ID
							, B.PROJECT_CODE
							, B.SCM_SITE_ID, B.PLANT_SITE_ID
							, B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE
							, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS
							, B.AVG_PRICE 
							, @v_created_by, GETDATE()
							, B.LAST_UPDATED_BY, B.LAST_UPDATE_DATE
				)
			;

			-- [PJ2025-50017] 2단계 : 가중이동평균 (물동이 있는 경우는 아래와 같이 정의됨.)
			MERGE INTO SCM_MST_FUTURE_PRICE A
			USING (
					SELECT A.DIVISION_ID
						,  A.END_CUSTOMER			AS PROJECT_CODE
						,  A.SCM_SITE_ID, A.PLANT_SITE_ID 
						,  A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE
						,  A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						,  SUM(A.WEIGHTED_PRICE)	AS WEIGHTED_AVG_PRICE
						,  @v_created_by			AS LAST_UPDATED_BY
						,  GETDATE()				AS LAST_UPDATE_DATE
					FROM (
						SELECT A.DIVISION_ID
							 , A.PROJECT_CODE
							 , A.END_CUSTOMER 
							 , A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
							 , A.CELL_PROD_SITE_ID
							 , A.PRICE
							 , B.SUM_QTY
							 -- [PJ2025-50017] SUM_QTY가 0은 건수로 나누어서 합산해야 함.
							 , CASE WHEN SUM(B.SUM_QTY) OVER(PARTITION BY B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, A.YYYYMMDD, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME, A.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS) = 0 THEN
										cast( STR( A.PRICE/COUNT(B.SUM_QTY) OVER(PARTITION BY B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, A.YYYYMMDD, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME, A.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS) , 20, 5 ) as numeric(30, 10)) 	
									ELSE 
										cast( STR( A.PRICE*B.SUM_QTY/SUM(B.SUM_QTY) OVER(PARTITION BY B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, A.YYYYMMDD, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME, A.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS) , 20, 5 ) as numeric(30, 10)) 
							   END				AS WEIGHTED_PRICE					
						FROM  (
								-- [PJ2025-50017] 단가 변경 케아스
								SELECT    A.DIVISION_ID
										, A.PROJECT_CODE
										, A.END_CUSTOMER 
										, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
										, B.BASIS_START_DATE						AS YYYYMMDD
										, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME
										, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
										, A.CELL_PROD_SITE_ID
										, A.PRICE
								FROM #temp_DM_PLN_CFM_SELLING_PRICE A WITH(NOLOCK)
								INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK)
								ON  A.YYYYMMDD = B.BASIS_YYYYMMDD
								WHERE DIVISION_ID = @v_division_id
								AND   A.YYYYMMDD >= @plan_start_yyyymmdd
								AND    (DAYOFWEEK = 'MON' OR CALENDAR_DAY = '01')		-- [PJ2025-50017] 월요일 또는 월초
								UNION 
								/* 물량 변경 케아스*/
								SELECT A.DIVISION_ID
									, A.PROJECT_CODE
									, A.END_CUSTOMER 
									, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
									, A.YYYYMMDD
									, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME
									, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
									, A.CELL_PROD_SITE_ID
									, A.PRICE
								FROM (
										SELECT    A.DIVISION_ID
												, A.PROJECT_CODE
												, A.END_CUSTOMER 
												, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
												, B.BASIS_START_DATE						AS YYYYMMDD
												, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME
												, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
												, A.CELL_PROD_SITE_ID
												, A.PRICE
										FROM DM_PLN_CFM_SELLING_PRICE A WITH(NOLOCK)
										INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK)
										ON  A.YYYYMMDD = B.BASIS_YYYYMMDD
										WHERE DIVISION_ID = @v_division_id
										AND   A.YYYYMMDD >= @plan_start_yyyymmdd
										AND    (DAYOFWEEK = 'MON' OR CALENDAR_DAY = '01')		-- [PJ2025-50017] 월요일 또는 월초
									) A
									INNER JOIN 
									(
										SELECT DISTINCT 
											  A.DIVISION_ID
											, A.PROJECT_CODE
											, A.END_CUSTOMER 
											, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
											, B.BASIS_START_DATE						AS YYYYMMDD
											, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME
											, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
										FROM #temp_DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
										INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK)
										ON  A.YYYYMMDD = B.BASIS_YYYYMMDD
										WHERE DIVISION_ID = @v_division_id
										AND   A.YYYYMMDD >= @plan_start_yyyymmdd
										GROUP BY 										  
											  A.DIVISION_ID
											, A.PROJECT_CODE
											, A.END_CUSTOMER 
											, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
											, B.BASIS_START_DATE						
											, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME
											, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
									) B
									ON	A.DIVISION_ID		= B.DIVISION_ID
									AND A.PROJECT_CODE		= B.PROJECT_CODE
									AND A.END_CUSTOMER		= B.END_CUSTOMER
									AND A.SCM_SITE_ID		= B.SCM_SITE_ID
									AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
									AND A.ITEM_ID			= B.ITEM_ID
									AND A.YYYYMMDD			= B.YYYYMMDD
									AND A.ISO_YYYYWW		= B.ISO_YYYYWW
									AND A.PARTIAL_WEEK_NAME	= B.PARTIAL_WEEK_NAME
									AND A.DOM_EXP			= B.DOM_EXP
									AND A.FCST_TYPE			= B.FCST_TYPE
									AND A.INCOTERMS			= B.INCOTERMS
							) A 
							INNER JOIN (
									-- [PJ2025-50017] 가중이동평균을 구하기 위한 CELL_PROD_SITE_ID 별로 주별 물량 합
										SELECT    A.DIVISION_ID
												, A.PROJECT_CODE
												, A.END_CUSTOMER 
												, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
												, B.BASIS_START_DATE						AS YYYYMMDD
												, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME
												, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
												, A.CELL_PROD_SITE_ID
												, SUM(A.QTY)				AS SUM_QTY
										FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)			-- [PJ2025-50017] 중요: UI에서 정의된 수량을 기반으로 분배기준 정의
										INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK)
										ON  A.YYYYMMDD = B.BASIS_YYYYMMDD
										WHERE A.DIVISION_ID = @v_division_id
										--AND   A.ITEM_ID = 'MIF519664A11'
										--AND   A.SCM_SITE_ID = 'NT_CN_HUI'
										AND   A.YYYYMMDD >= @plan_start_yyyymmdd
										AND   A.MEASURE IN ('MKT_FCST')							-- [PJ2025-50017] 수량 비율은 MKT_FCST 기준으로 분배됨. (물량가중평균의 기준은 MKT_FCST 임.
										GROUP BY A.DIVISION_ID
												, A.PROJECT_CODE
												, A.END_CUSTOMER 
												, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
												, B.BASIS_START_DATE
												, B.ISO_YYYYWW, B.PARTIAL_WEEK_NAME
												, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
												, A.CELL_PROD_SITE_ID
							) B
							ON  A.DIVISION_ID		= B.DIVISION_ID
							AND A.PROJECT_CODE		= B.PROJECT_CODE
							AND A.END_CUSTOMER		= B.END_CUSTOMER
							AND A.SCM_SITE_ID		= B.SCM_SITE_ID
							AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
							AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.ISO_YYYYWW		= B.ISO_YYYYWW
							AND A.PARTIAL_WEEK_NAME	= B.PARTIAL_WEEK_NAME
							AND A.DOM_EXP			= B.DOM_EXP
							AND A.FCST_TYPE			= B.FCST_TYPE
							AND A.INCOTERMS			= B.INCOTERMS
							--AND A.MEASURE			= B.MEASURE
							--AND A.MEASURE			= 'LOC'		
							AND B.MEASURE			= 'MKT_FCST'	
					) A
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.YYYYMMDD	>= @plan_start_yyyymmdd
					GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
				) B
			ON  (
						A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.DOM_EXP		= B.DOM_EXP
					AND A.FCST_TYPE		= B.FCST_TYPE
					AND A.INCOTERMS		= B.INCOTERMS
					AND	A.MEASURE		= B.MEASURE
					AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
					AND A.CURRENCY		= B.CURRENCY
					AND A.YYYYMMDD		= B.YYYYMMDD
			)
			WHEN MATCHED THEN
				UPDATE SET A.PRICE				= B.WEIGHTED_AVG_PRICE
						,  A.LAST_UPDATED_BY	= B.LAST_UPDATED_BY	 
						,  A.LAST_UPDATE_DATE	= B.LAST_UPDATE_DATE
			WHEN NOT MATCHED THEN
				INSERT (
   						   DIVISION_ID
						 , PROJECT_CODE
						 , SCM_SITE_ID, PLANT_SITE_ID
						 , ITEM_ID, YYYYMMDD, CURRENCY, MEASURE
						 , DOM_EXP, FCST_TYPE, INCOTERMS
						 , PRICE 
						 , CREATED_BY, CREATION_DATE
						 , LAST_UPDATED_BY, LAST_UPDATE_DATE
				)
				VALUES (
						   B.DIVISION_ID
						 , B.PROJECT_CODE
						 , B.SCM_SITE_ID, B.PLANT_SITE_ID
						 , B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE
						 , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS
						 , B.WEIGHTED_AVG_PRICE 
						 , @v_created_by, GETDATE()
						 , B.LAST_UPDATED_BY, B.LAST_UPDATE_DATE
				)
			;*/

			--=============================================================================================================================================
			-- 1. 받아온 데이터 기준으로 DM_PLN_MKT_FCST 데이터 동기화 (START)
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 1). #T_MAIN 테이블 데이터를 DM_PLN_MKT_FCST 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]에 INSERT (START)

			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
				   --[E20260309-000271]_ISNULL처리 추가 (START)
				   --, SUM(QTY_PRICE) AS QTY --[E20260309-000271]_원소스 주석처리
				   , SUM(ISNULL(QTY_PRICE, 0)) AS QTY --[E20260309-000271]_ISNULL처리 추가
				   --[E20260309-000271]_ISNULL처리 추가 (END)
			INTO #TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN
			FROM #T_MAIN WITH(NOLOCK)
			WHERE DIVISION_ID	= @v_division_id
			AND   MEASURE		IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ')			-- [PJ2025-50188] 기준수요 포함
			AND   YYYYMMDD		>= @v_plan_start_yyyymmdd
			GROUP BY  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID;
			
			-- 1). #T_MAIN 테이블 데이터를 DM_PLN_MKT_FCST 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]에 INSERT(END)
			-----------------------------------------------------------------------------------------------------------------------------------------------	
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 2). 당주 월요일 이후 TEMP 테이블에 적재된 데이터와 동일한 DM_PLN_MKT_FCST 데이터를 삭제한다 (START)
			
			DELETE A
			  FROM DM_PLN_MKT_FCST A
			 INNER JOIN #TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN B
					 ON A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.DOM_EXP		= B.DOM_EXP
					AND A.FCST_TYPE		= B.FCST_TYPE
					AND A.INCOTERMS		= B.INCOTERMS
					AND A.MEASURE		= B.MEASURE
					AND A.YYYYMMDD		= B.YYYYMMDD
					AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
			 WHERE A.DIVISION_ID = @v_division_id
			   AND A.YYYYMMDD   >= @v_plan_start_yyyymmdd
			   AND A.MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ');	

			-- 2). 당주 월요일 이후 TEMP 테이블에 적재된 데이터와 동일한 DM_PLN_MKT_FCST 데이터를 삭제한다 (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]데이터로 -> MKT FCST 데이터를 적재한다 (START)
			
			INSERT INTO DM_PLN_MKT_FCST
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
			, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE	)
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
				 , A.QTY, @p_created_by, GETDATE(), @p_created_by,  GETDATE()
			  FROM #TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN A
			  
			-- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]데이터로 -> MKT FCST 데이터를 적재한다 (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------	
			-- 1. 받아온 데이터 기준으로 DM_PLN_MKT_FCST 데이터 동기화 (END)
			--=============================================================================================================================================	
			--=============================================================================================================================================
			-- 2. 받아온 데이터 기준으로 SCM_MST_FUTURE_PRICE 데이터 동기화 (START)	
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 1). #T_MAIN 테이블 데이터를 DM_PLN_CFM_SELLING_PRICE 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]에 INSERT (START)
			-- 데이터가 하나 이상인 경우가 존재할 수 있으므로, 평균값으로 저장한다.

			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE
				 , A.INCOTERMS				 
				 --[E20260309-000271]_ISNULL처리 추가 (START)
				 --, AVG(A.QTY_PRICE) AS PRICE--[E20260309-000271]_원소스 주석처리
				 , AVG(ISNULL(A.QTY_PRICE,0)) AS PRICE
				 --[E20260309-000271]_ISNULL처리 추가 (END)
			  INTO #TEMP_DM_PLN_CFM_SELLING_PRICE
			  FROM #T_MAIN A WITH(NOLOCK)
			 WHERE A.DIVISION_ID = @v_division_id
			   AND A.MEASURE IN ('LOC', 'KRW', 'USD')
			   AND A.YYYYMMDD >= @v_plan_start_yyyymmdd
			 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE
					, A.INCOTERMS ;

			-- 1). DM_PLN_CFM_SELLING_PRICE테이블 데이터를 SCM_MST_FUTURE_PRICE 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]에 INSERT (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 2). 당주 월요일 이후 TEMP 테이블에 적재된 데이터와 동일한 SCM_MST_FUTURE_PRICE 데이터를 삭제한다 (START)
			
			DELETE A
			  FROM SCM_MST_FUTURE_PRICE A
			 INNER JOIN #TEMP_DM_PLN_CFM_SELLING_PRICE B
					 ON A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.YYYYMMDD		= B.YYYYMMDD
					AND A.MEASURE		= B.MEASURE
					AND A.DOM_EXP		= B.DOM_EXP
					AND A.FCST_TYPE		= B.FCST_TYPE
					AND A.INCOTERMS		= B.INCOTERMS
			 WHERE A.DIVISION_ID = @v_division_id
			   AND A.YYYYMMDD   >= @v_plan_start_yyyymmdd
			   AND A.MEASURE IN ('LOC', 'KRW', 'USD');

			-- 2). 당주 월요일 이후 TEMP 테이블에 적재된 데이터와 동일한 SCM_MST_FUTURE_PRICE 데이터를 삭제한다 (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]데이터로 -> SCM_MST_FUTURE_PRICE 데이터를 적재한다 (START)

			INSERT INTO SCM_MST_FUTURE_PRICE
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE
			, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE
				 , A.INCOTERMS, A.PRICE, @p_created_by, GETDATE(), @p_created_by, GETDATE()
			  FROM #TEMP_DM_PLN_CFM_SELLING_PRICE A

			-- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]데이터로 -> SCM_MST_FUTURE_PRICE 데이터를 적재한다 (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------	
			-- 2. DM_PLN_CFM_SELLING_PRICE 기준으로 SCM_MST_FUTURE_PRICE 데이터 동기화 (END)	
			--=============================================================================================================================================
			-- [E20251223-000672]_굳이 TEMP로 계속 담아 작업을 하지 않아도됨. 간략하게 진행하기 위해 원소스 주석 후 생성한다 (END)

			BEGIN
			-- [PJ2025-50017] MKT_FCST 수정으로 DM_PLN_MKT_FCST의 BALANCE 데이터 재생성			
				-- [E20251223-000672]_DROP, TEMP 테이블은 가장 상단으로 이동한다 (START)
				/*
				IF OBJECT_ID (N'tempdb..#SEND_TARGET_DATA', N'U') IS NOT NULL 
					DROP TABLE #SEND_TARGET_DATA

				CREATE TABLE #SEND_TARGET_DATA  
				( DIVISION_ID		NVARCHAR(30) NOT NULL
				, PROJECT_CODE		NVARCHAR(50) NOT NULL
				, SCM_SITE_ID		NVARCHAR(30) NOT NULL
				, ITEM_ID			NVARCHAR(50) NOT NULL
				, DOM_EXP			NVARCHAR(03) NOT NULL
				, FCST_TYPE			NVARCHAR(20) NOT NULL
				, INCOTERMS			NVARCHAR(10) NOT NULL
				, PLANT_SITE_ID		NVARCHAR(30) NOT NULL
				, CELL_PROD_SITE_ID NVARCHAR(30) NULL
				, VMI_YN			NVARCHAR(01) NULL)*/
				-- [E20251223-000672]_DROP, TEMP 테이블은 가장 상단으로 이동한다 (END)
				
			-- [E20251223-000672]_해당 변수의 사용이유를 모르겠으니 주석처리 
			--DECLARE @c_division_id         NVARCHAR(MAX);

				INSERT INTO #SEND_TARGET_DATA
				( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, VMI_YN )
				SELECT DIVISION_ID, END_CUSTOMER AS PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, 'N' -- vmi_yn 초기값
				  -- [E20251223-000672]_굳이 TEMP로 담을 필요 없이, 전달받은 데이터를 사용한다. TEMP 주석 후 전달받은 TABLE 사용하도록 수정(START)
				  -- FROM  #results_MKT_FCST 
				  FROM #T_MAIN 
				  -- [E20251223-000672]_굳이 TEMP로 담을 필요 없이, 전달받은 데이터를 사용한다. TEMP 주석 후 전달받은 TABLE 사용하도록 수정(END)
				 WHERE MEASURE IN ('MKT_FCST','VMI_IN_REQ')
				 GROUP BY DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID


				IF (SELECT ISNULL(COUNT(1),0) FROM #SEND_TARGET_DATA) > 0 
				BEGIN
					-- [E20251223-000672]_해당 변수의 사용이유를 모르겠으니 주석처리 
					--SET @c_division_id = (SELECT TOP 1 DIVISION_ID FROM #SEND_TARGET_DATA)
					--EXEC PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE @c_division_id, @p_plan_id = 'CALL'
					EXEC PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE @v_division_id, @p_plan_id = 'CALL'					
				END
			END
			BEGIN
				-- [E20251223-000672]_DROP, TEMP 테이블은 가장 상단으로 이동한다 (START)
				/*
				-- [PJ2025-50017] MKT_FCST 수정으로 DM_PLN_MKT_FCST의 MKT_AMT 데이터 업데이트
				IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL 		
					DROP TABLE #results

				CREATE TABLE #results 
				( v_division_id		NVARCHAR(30) NOT NULL
				, v_project_code	NVARCHAR(50) NOT NULL
				, v_scm_site_id		NVARCHAR(30) NOT NULL
				, v_item_id			NVARCHAR(50) NOT NULL
				, v_dom_exp			NVARCHAR(03) NOT NULL
				, v_fcst_type		NVARCHAR(20) NOT NULL
				, v_incoterms		NVARCHAR(10) NOT NULL
				, v_measure			NVARCHAR(50) NOT NULL
				, v_plant_site_id	NVARCHAR(30) NOT NULL
				, v_yyyymmdd		NVARCHAR(08) NOT NULL
				, v_created_by		NVARCHAR(150) NULL )
				*/
				-- [E20251223-000672]_DROP, TEMP 테이블은 가장 상단으로 이동한다 (END)

				INSERT INTO #results
				( V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD, V_CREATED_BY )
				SELECT DIVISION_ID, END_CUSTOMER AS PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, @v_created_by AS CREATED_BY
				-- [E20251223-000672]_굳이 TEMP로 담을 필요 없이, 전달받은 데이터를 사용한다. TEMP 주석 후 전달받은 TABLE 사용하도록 수정(START)
				--FROM  #results_MKT_FCST 
				  FROM #T_MAIN 
				-- [E20251223-000672]_굳이 TEMP로 담을 필요 없이, 전달받은 데이터를 사용한다. TEMP 주석 후 전달받은 TABLE 사용하도록 수정(END)
				 WHERE DIVISION_ID	= @v_division_id
				   AND MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ', 'LOC', 'KRW', 'USD') -- [E20251223-000672]_'LOC', 'KRW', 'USD'메져를 추가하여 한번에 조회한다
				   AND YYYYMMDD	>= @v_plan_start_yyyymmdd
				 GROUP BY DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
				-- [E20251223-000672]_굳이 해당 부분으로 담을 필요 없이, 한번에 전달받은 TEMP 테이블에서 담는다. 필요없는 부분 주석처리 (START)
				/*
				UNION
				SELECT DISTINCT
						 DIVISION_ID
					   , END_CUSTOMER	AS PROJECT_CODE
					   , SCM_SITE_ID
					   , ITEM_ID
					   , DOM_EXP
					   , FCST_TYPE
					   , INCOTERMS
					   , MEASURE
					   , PLANT_SITE_ID
					   , YYYYMMDD
					   , @v_created_by		AS CREATED_BY
				FROM  #results_FUTURE_PRICE 
				WHERE DIVISION_ID	= @v_division_id
				AND   MEASURE IN ('LOC', 'KRW', 'USD')
				AND   YYYYMMDD		>= @v_plan_start_yyyymmdd
				GROUP BY DIVISION_ID
					   , END_CUSTOMER	
					   , SCM_SITE_ID
					   , ITEM_ID
					   , DOM_EXP
					   , FCST_TYPE
					   , INCOTERMS
					   , MEASURE
					   , PLANT_SITE_ID
					   , YYYYMMDD
				*/
				-- [E20251223-000672]_굳이 해당 부분으로 담을 필요 없이, 한번에 전달받은 TEMP 테이블에서 담는다. 필요없는 부분 주석처리 (END)
			--[E20251021-000634]_주석처리한 부분 주석 삭제
			IF (SELECT ISNULL(COUNT(1),0) FROM #results where v_DIVISION_ID = '40') > 0
			BEGIN
				EXEC dbo.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE 
			END
		END
		---------------------------------------------------------------------------------------------------------------------------------------------------
		-- [E20251223-000672]_작업이 모두 종료되었으므로, 사용했던 모든 TEMP 테이블 종료 시 DROP 작업 진행 (START)

		IF OBJECT_ID (N'tempdb..#T_MAIN', N'U') IS NOT NULL 
			DROP TABLE #T_MAIN;

		IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL 
			DROP TABLE #results;
	
		IF OBJECT_ID (N'tempdb..#SEND_TARGET_DATA', N'U') IS NOT NULL 
			DROP TABLE #SEND_TARGET_DATA;
			
		IF OBJECT_ID (N'tempdb..#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN', N'U') IS NOT NULL 
			DROP TABLE #TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN
				
		IF OBJECT_ID (N'tempdb..#TEMP_DM_PLN_CFM_SELLING_PRICE', N'U') IS NOT NULL 
			DROP TABLE #TEMP_DM_PLN_CFM_SELLING_PRICE

		-- [E20251223-000672]_작업이 모두 종료되었으므로, 사용했던 모든 TEMP 테이블 종료 시 DROP 작업 진행 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------
	END
    COMMIT;
	END TRY
	-- 트랜잭션 (END)
	--=====================================================================================================================================================
	--=====================================================================================================================================================
	-- 오류 발생시 TRANSACTION 롤백 및 로그적재 (START)

    BEGIN CATCH
		---------------------------------------------------------------------------------------------------------------------------------------------------
		-- ERROR LOG VALUE SAVE (START)
		--[E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (START)
		BEGIN --[E20260309-000271]_BEGIN / END 추가
			--ROLLBACK TRANSACTION PR_DM_PLN_CFM_TO_MKT_FCST;  --[E20260309-000271]_원소스주석처리
			ROLLBACK
			--[E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (END)

			SET @v_log_type		= 'ERROR';
			SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description	= 'ERROR_LINE : ' + STR(ERROR_LINE());
			SET @d_event_date	= SYSDATETIME();
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END  --[E20260309-000271]_BEGIN / END 추가
		-- ERROR LOG VALUE SAVE (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------
		
    END CATCH;

	-- 오류 발생시 TRANSACTION 롤백 및 로그적재 (END)
	--=====================================================================================================================================================		
	--=====================================================================================================================================================
    -- 종료 LOG (START)
    SET @v_log_type			= 'END';
    SET @v_log_message		= '########## END of procedure ##########';
	--SET @v_description = '@p_division_id : ' + @p_division_id ;
    SET @d_event_date		= SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    -- 종료 LOG (END)
	--=====================================================================================================================================================


