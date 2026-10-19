
/*=====================================================================================================================================================
 * Program ID   : PR_DM_PLN_CFM_TO_MKT_FCST_ALL 
 * Description  : FcstPrice MGMT화면 전체데이터 동기화
				  DM_PLN_CFM_MKT_DEMAND_PLAN -> DM_PLN_MKT_FCST
				  DM_PLN_CFM_SELLING_PRICE	 -> SCM_MST_FUTURE_PRICE
				  해당 작업 후 DAILY CUTOFF 배치 실행하도록 배치셋팅 
				  (만약, 해당 작업 후 DAILY CUTOFF 프로시져 수행하지 않는다면, SALES PLAN 동기화 따로 실행해줘야함)
 * Program History
 *=====================================================================================================================================================
 *	Date		In Charge		Description
 *=====================================================================================================================================================
 * 2025-12-29	JSSBAE			[E20251224-000842]_81사업부 FCST&PRICE MGMT UI Setup 공수 산정
*===================================================================================================================================================*/
--EXEC PR_DM_PLN_CFM_TO_MKT_FCST_ALL '40'

CREATE PROCEDURE [dbo].[PR_DM_PLN_CFM_TO_MKT_FCST_ALL]
	 @p_division			NVARCHAR(MAX)	 
AS

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
	
	--=====================================================================================================================================================
	-- LOG 용 변수 설정 (START)

    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_CFM_TO_MKT_FCST_ALL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- LOG 용 변수 설정 (END)
	--=====================================================================================================================================================	
	--=====================================================================================================================================================
	-- 프로시져 사용 변수 설정 (START)

    DECLARE @v_plan_start_yyyymmdd	NVARCHAR(8);
    DECLARE @v_created_by			NVARCHAR(100);

 	SET		@v_plan_start_yyyymmdd	= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);   -- 월요일
	SET		@v_created_by			= N'BATCH_CFM_TO_ALL';

	-- 프로시져 사용 변수 설정 (END)
	--=====================================================================================================================================================	
	--=====================================================================================================================================================
	-- 시작 LOG  (START)

	SET @v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########';
	SET @v_description	= '@p_created_by : ' + @v_created_by;
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message	= NULL      

	-- 시작 LOG  (END)
	--=====================================================================================================================================================		
	--=====================================================================================================================================================
	-- TEMP 테이블 DROP (START)
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 데이터 DM_PLN_MKT_FCST 기준 테이블 데이터로 임시 테이블 생성
	IF OBJECT_ID (N'tempdb..#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-- DM_PLN_CFM_SELLING_PRICE 테이블 데이터 SCM_MST_FUTURE_PRICE 기준 테이블 데이터로 임시 테이블 생성
	IF OBJECT_ID (N'tempdb..#TEMP_DM_PLN_CFM_SELLING_PRICE', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_PLN_CFM_SELLING_PRICE
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-- TEMP 테이블 DROP  (END)
	--=====================================================================================================================================================
	
	--=====================================================================================================================================================
	-- 트랜잭션 (START)

	BEGIN TRANSACTION PR_DM_PLN_CFM_TO_MKT_FCST_ALL
	BEGIN TRY	
		BEGIN

			--=============================================================================================================================================
			-- 1. DM_PLN_CFM_MKT_DEMAND_PLAN 기준으로 DM_PLN_MKT_FCST 데이터 동기화 (START)
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 1). DM_PLN_CFM_MKT_DEMAND_PLAN테이블 데이터를 DM_PLN_MKT_FCST 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]에 INSERT (START)

			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
				 , SUM(A.QTY) AS QTY
			  INTO #TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN
			  FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
			 WHERE A.DIVISION_ID = @p_division
			   AND A.MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ')		-- [PJ2025-50188] 기준수요 포함
			   AND A.YYYYMMDD >= @v_plan_start_yyyymmdd
			 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD

			-- 1). DM_PLN_CFM_MKT_DEMAND_PLAN테이블 데이터를 DM_PLN_MKT_FCST 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]에 INSERT (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------	
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 2). 당주 월요일 이후 DM_PLN_MKT_FCST 데이터를 삭제한다 (START)

			DELETE FROM DM_PLN_MKT_FCST 
			 WHERE DIVISION_ID = @p_division
			   AND YYYYMMDD	  >= @v_plan_start_yyyymmdd
			   AND MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ');	

			-- 2). 당주 월요일 이후 DM_PLN_MKT_FCST 데이터를 삭제한다 (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------	
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]데이터로 -> MKT FCST 데이터를 적재한다 (START)

			INSERT INTO DM_PLN_MKT_FCST
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
			, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE	)
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
				 , A.QTY, @v_created_by, GETDATE(), @v_created_by, GETDATE()
			  FROM #TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN A

			-- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]데이터로 -> MKT FCST 데이터를 적재한다 (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------	
			-- 1. DM_PLN_CFM_MKT_DEMAND_PLAN 기준으로 DM_PLN_MKT_FCST 데이터 동기화 (END)
			--=============================================================================================================================================	
			
			--=============================================================================================================================================
			-- 2. DM_PLN_CFM_SELLING_PRICE 기준으로 SCM_MST_FUTURE_PRICE 데이터 동기화 (START)	
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 1). DM_PLN_CFM_SELLING_PRICE테이블 데이터를 SCM_MST_FUTURE_PRICE 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]에 INSERT (START)
			-- 데이터가 하나 이상인 경우가 존재할 수 있고, CURRENCY가 중복될수있으니, 가장 마지막 수정한 데이터 기반으로 평균값으로 저장한다.

			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, AVG(A.PRICE) AS PRICE
			INTO #TEMP_DM_PLN_CFM_SELLING_PRICE
			FROM DM_PLN_CFM_SELLING_PRICE A WITH(NOLOCK)
			INNER JOIN (SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, CURRENCY, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, DOM_EXP
						FROM ( SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, CURRENCY, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, DOM_EXP
									, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, DOM_EXP
											  ORDER BY LAST_UPDATE_DATE DESC) AS ROW_NUM
								FROM DM_PLN_CFM_SELLING_PRICE WITH(NOLOCK)
								WHERE DIVISION_ID = @p_division
								AND MEASURE = 'LOC'
								AND YYYYMMDD >= @v_plan_start_yyyymmdd
								GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, CURRENCY, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, DOM_EXP, LAST_UPDATE_DATE ) A
						WHERE ROW_NUM = 1) B
					 ON A.DIVISION_ID = B.DIVISION_ID
					AND A.PROJECT_CODE = B.PROJECT_CODE
					AND A.END_CUSTOMER = B.END_CUSTOMER
					AND A.SCM_SITE_ID = B.SCM_SITE_ID
					AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
					AND A.ITEM_ID = B.ITEM_ID
					AND A.DOM_EXP = B.DOM_EXP
					AND A.FCST_TYPE = B.FCST_TYPE
					AND A.INCOTERMS = B.INCOTERMS
					AND A.CURRENCY = B.CURRENCY
			WHERE A.DIVISION_ID = @p_division
			AND A.YYYYMMDD >= @v_plan_start_yyyymmdd
			AND A.MEASURE IN ('LOC', 'KRW', 'USD')
			GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS

			-- 1). DM_PLN_CFM_SELLING_PRICE테이블 데이터를 SCM_MST_FUTURE_PRICE 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]에 INSERT (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 2). 당주 월요일 이후 SCM_MST_FUTURE_PRICE 데이터를 삭제한다 (START)

			DELETE FROM SCM_MST_FUTURE_PRICE 
			 WHERE DIVISION_ID = @p_division
			   AND YYYYMMDD	  >= @v_plan_start_yyyymmdd

			-- 2). 당주 월요일 이후 SCM_MST_FUTURE_PRICE 데이터를 삭제한다 (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------			
			-----------------------------------------------------------------------------------------------------------------------------------------------
			-- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]데이터로 -> SCM_MST_FUTURE_PRICE 데이터를 적재한다 (START)

			INSERT INTO SCM_MST_FUTURE_PRICE
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE
			, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE
				 , A.INCOTERMS, A.PRICE, @v_created_by, GETDATE(), @v_created_by, GETDATE()
			  FROM #TEMP_DM_PLN_CFM_SELLING_PRICE A

			-- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]데이터로 -> SCM_MST_FUTURE_PRICE 데이터를 적재한다 (END)
			-----------------------------------------------------------------------------------------------------------------------------------------------	
			-- 2. DM_PLN_CFM_SELLING_PRICE 기준으로 SCM_MST_FUTURE_PRICE 데이터 동기화 (END)	
			--=============================================================================================================================================

		END
    COMMIT;
	END TRY

	-- 트랜잭션 (END)
	--=====================================================================================================================================================
	--=====================================================================================================================================================
	-- 오류 발생시 TRANSACTION 롤백 및 로그적재 (START)

    BEGIN CATCH
		ROLLBACK TRANSACTION PR_DM_PLN_CFM_TO_MKT_FCST_ALL;
		
		---------------------------------------------------------------------------------------------------------------------------------------------------
		-- ERROR LOG VALUE SAVE (START)

		SET @v_log_type		= 'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- ERROR LOG VALUE SAVE (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------

    END CATCH;

	-- 오류 발생시 TRANSACTION 롤백 및 로그적재 (END)
	--=====================================================================================================================================================	
	--=====================================================================================================================================================
    -- 종료 LOG (START)

    SET @v_log_type		= 'END';
    SET @v_log_message	= '########## END of procedure ##########';
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    -- 종료 LOG (END)
	--=====================================================================================================================================================


