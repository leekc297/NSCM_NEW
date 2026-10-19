
/*=============================================================================================================
 * Program ID   : PR_SCM_MST_FUTURE_PRICE_CUTOFF
 * Description  : 
 * Program History
 *=============================================================================================================
 *    Date		In Charge		Description
 *=============================================================================================================
 * 2017.02.12 JHBAEK/KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.28 KHSONG			DW I/F 테이블 생성 Procedure 호출 추가 -> 임시주석처리됨
 * 2018.07.26 KHSONG			PR_DM_PLN_SALES_PLAN_CUTOFF에서 호출받으면서 parameter 추가
 * 2020.10.20 P.C.I				[C20201005-000282] 당주 월요일부터 Sales Price Cutoff
 * 2022.04.07 hwi1993			GM JV 작업
 * 2025.02.05 KANG.H.J			[PJ2025-50017] 소형 매출계획 동기화 개선
 * 2025.07.23 JSSBAE			[PJ2025-50188]_소형 매출계획 동기화 개선 고도화 [Sales Price Cutoff 개선]
 =============================================================================================================*/

CREATE PROCEDURE [dbo].[PR_SCM_MST_FUTURE_PRICE_CUTOFF]
	  @p_division_id			  NVARCHAR(30)   -- division_id 전달받음
	, @p_ver_type				  NVARCHAR(MAX)  -- 20180726 Sales Plan Weekly Cutoff Version Type
	, @p_created_by				  NVARCHAR(MAX)  -- 20180726
	, @sales_plan_ver_return_no	  NVARCHAR(MAX)  -- 20180726 Sales Plan Weekly Cutoff Version No
	, @mkt_plan_ver_return_no	  NVARCHAR(MAX)   = 'MKT_FCST'-- [PJ2025-50188]_SALE_PLAN CUTOFF 하는경우에는 MKT_FCST도 받는다
AS

BEGIN
    SET NOCOUNT ON; 

    DECLARE @v_program_name				NVARCHAR(150) = 'PR_SCM_MST_FUTURE_PRICE_CUTOFF';
    DECLARE @v_log_type					NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);
    DECLARE @d_event_date				DATETIME;
	DECLARE	@v_ver_return_no			NVARCHAR(100);	-- cut off Generated Number	
	DECLARE	@v_OK_description			NVARCHAR(1200);	-- cut off Generated Number	
	--[C20201005-000282] 당주 월요일부터 Sales Price Cutoff
    DECLARE @plan_start_yyyymmdd		NVARCHAR(8);
	SET		@plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)   -- 월요일
	
	-----------------------------------------------------------------------------------------------
	--[PJ2025-50188]_데이터가 실제로 필요한 것만 받기 위해 일자와, 메져를 변수에 담는다 (START)
    DECLARE @plan_to_yyyymm				NVARCHAR(6);	
	
PRINT ( @v_program_name + ' A001: ' + 'DIVISION_ID: '+ @p_division_id + ' / VERSION_TYPE: ' + @p_ver_type + ' / VERSION_NO: ' + @sales_plan_ver_return_no + ' / VERSION_NO: ' + @mkt_plan_ver_return_no  )	
	--=============================================================================================
	-- TEMP TABLE DROP 
	--=============================================================================================	
	IF OBJECT_ID (N'tempdb..#TEMP_USE_MEASURE', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_USE_MEASURE;

	IF OBJECT_ID (N'tempdb..#TEMP_USE_MEASURE', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_MKT_FCST_DATA;
	--=============================================================================================
	-- 사업부별 사용하는 메져 TEMP 테이블에 데이터 적재
	--=============================================================================================	
	SELECT SEGMENT3 AS MEASURE 
	INTO #TEMP_USE_MEASURE
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	WHERE LOOKUP_TYPE = 'CUTOFF_USE_MEASURE'
	AND SEGMENT1 = 'SALES_PRICE'
	AND SEGMENT2 = @p_division_id;

	--[PJ2025-50188]_데이터가 실제로 필요한 것만 받기 위해 일자와, 메져를 변수에 담는다 (END)
	-----------------------------------------------------------------------------------------------
	--=============================================================================================
	-- 시작 LOG  (START)
	--=============================================================================================
	SET @v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########';
	SET @v_description	= '';
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	SET @v_log_message	= NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--=============================================================================================
	-- 시작 LOG  (END)
	--=============================================================================================	
	--=============================================================================================
	-- 트랜잭션 (START)
	--=============================================================================================
	BEGIN TRANSACTION PR_SCM_MST_FUTURE_PRICE_CUTOFF;
	-----------------------------------------------------------------------------------------------
		BEGIN TRY
	-----------------------------------------------------------------------------------------------	
		-----------------------------------------------------------------------------------------------
		-- [PJ2025-50188]_삭제는 SP_W든 SP_D든 MF_D든 MF_W든 동일하게 진행하므로 공통 먼저 하도록 순서 변경 (START) 
		--=============================================================================================
 		-- CUTOFF 데이터 삭제 진행 
		--=============================================================================================
		BEGIN
PRINT ( @v_program_name + ' A002: ' + 'DIVISION_ID: '+ @p_division_id + ' / VERSION_TYPE: ' + @p_ver_type + ' / VERSION_NO: ' + @sales_plan_ver_return_no + ' / VERSION_NO: ' + @mkt_plan_ver_return_no  )	
			-----------------------------------------------------------------------------------------------
			-- 1). INSERT전 중복체크 후 삭제
			-----------------------------------------------------------------------------------------------
			-----------------------------------------------------------------------------------------------
			-- SCM_MST_FUTURE_PRICE_C 삭제
			-----------------------------------------------------------------------------------------------
			DELETE FROM SCM_MST_FUTURE_PRICE_C 
			WHERE DIVISION_ID = @p_division_id
			AND   VERSION_NO  = @sales_plan_ver_return_no
			AND   CUTOFF_TYPE = @p_ver_type
			AND   YYYYMMDD   >= @plan_start_yyyymmdd --[C20201005-000282] 당주 월요일부터 Sales Price Cutoff
			-----------------------------------------------------------------------------------------------
			-- DM_PLN_CFM_SELLING_PRICE_C CUTOFF
			-----------------------------------------------------------------------------------------------
			DELETE FROM DM_PLN_CFM_SELLING_PRICE_C 
			WHERE DIVISION_ID = @p_division_id
			AND	  VERSION_NO  = @sales_plan_ver_return_no
			AND	  CUTOFF_TYPE = @p_ver_type
			AND	  YYYYMMDD   >= @plan_start_yyyymmdd 

		END
		-- [PJ2025-50188]_삭제는 SP_W든 SP_D든 MF_D든 MF_W든 동일하게 진행하므로 공통 먼저 하도록 순서 변경 (END) 
		-----------------------------------------------------------------------------------------------		
		-----------------------------------------------------------------------------------------------
		-- [PJ2025-50188]_VERSION_TYPE이 S로 시작하는 경우 DM_PLN_SALES_PLAN_C 테이블로 CUTOFF (START)
		--IF LEFT(@p_ver_type, 1) = 'S'
		IF LEFT(@p_ver_type, 2) = 'SP'		-- [PJ2025-50188]_VERSION_TYPE이 SP_W / SF_W를 구분하기 위해서 SP로 변경 (2025.07.28. 강현준)
		BEGIN
PRINT ( @v_program_name + ' A003: ' + 'DIVISION_ID: '+ @p_division_id + ' / VERSION_TYPE: ' + @p_ver_type + ' / VERSION_NO: ' + @sales_plan_ver_return_no + ' / VERSION_NO: ' + @mkt_plan_ver_return_no  )	

			/* 20180726 version 추출 필요없음 주석처리
				-- version no 추출
				EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]
							@p_division_id
						,@p_version_description
						,@p_ver_type
						,@p_created_by
						,@v_ver_return_no  OUTPUT
						,@v_OK_description OUTPUT
			*/			
			
			--------------------------------------------------------------------------------------------
			--CUTOFF된 MKT FCST 데이터에서 지정한 메져로 데이터를 추출한다.
			--------------------------------------------------------------------------------------------
			SELECT T.DIVISION_ID, T.PROJECT_CODE, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, MAX(T.YYYYMMDD) AS YYYYMMDD
			INTO #TEMP_MKT_FCST_DATA
			FROM (	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
					FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A WITH(NOLOCK)
					INNER JOIN #TEMP_USE_MEASURE TM ON A.MEASURE = TM.MEASURE
					WHERE DIVISION_ID = @p_division_id
					AND   VERSION_NO  = @mkt_plan_ver_return_no
					AND   YYYYMMDD   >= @plan_start_yyyymmdd
					UNION ALL
					SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
					FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
					INNER JOIN #TEMP_USE_MEASURE TM ON A.MEASURE = TM.MEASURE
					WHERE DIVISION_ID = @p_division_id
					AND   VERSION_NO  = @mkt_plan_ver_return_no
					AND   YYYYMMDD   >= @plan_start_yyyymmdd
				) T
			GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, T.CELL_PROD_SITE_ID, T.PLANT_SITE_ID

PRINT ( @v_program_name + ' A004: ' + 'DIVISION_ID: '+ @p_division_id + ' / VERSION_TYPE: ' + @p_ver_type + ' / VERSION_NO: ' + @sales_plan_ver_return_no + ' / VERSION_NO: ' + @mkt_plan_ver_return_no  )	
			--------------------------------------------------------------------------------------------
			--실제 SALES PLAN CUTOFF에 존재하는 데이터 중 SALES PRICE를 사용하는 메져의 MAX날짜를 구해 TO날짜로 설정한다.
			--월까지만 구하는 이유는, 데이터가 존재하는 월의 데이터까지는 모두 가져오기 위해서 (화면에서 월 평균값을 보여줌)
			--------------------------------------------------------------------------------------------
			SELECT @plan_to_yyyymm = LEFT(MAX(A.YYYYMMDD),6) 
			FROM  #TEMP_MKT_FCST_DATA A WITH(NOLOCK)

			--------------------------------------------------------------------------------------------
			-- 2). INSERT 작업
			--------------------------------------------------------------------------------------------
PRINT ( @v_program_name + ' A005: ' + 'DIVISION_ID: '+ @p_division_id + ' / VERSION_TYPE: ' + @p_ver_type + ' / VERSION_NO: ' + @sales_plan_ver_return_no + ' / VERSION_NO: ' + @mkt_plan_ver_return_no  + ' / MAX_PLAN_TO_YYYYMM: ' + @plan_to_yyyymm  )	
			--------------------------------------------------------------------------------------------
			-- SCM_MST_FUTURE_PRICE_C TABLE INSERT
			--------------------------------------------------------------------------------------------
			INSERT INTO SCM_MST_FUTURE_PRICE_C 
			( DIVISION_ID, VERSION_NO
			, CUTOFF_TYPE, CUTOFF_YYYYMMDD
			, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP
			, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
			, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			-----------------------------------------------------------------------------------------------
			--[PJ2025-50188]_JOIN문을 사용해야 함으로, 어디에 속한 컬럼인지 ALIAS를 모두 적는다. (START)
			SELECT @p_division_id, @sales_plan_ver_return_no  -- sales plan Weekly Cufoff에서 수행된 version no 를 저장  20180726
				 , @p_ver_type AS CUTOFF_TYPE, CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP
				 , A.FCST_TYPE, A.INCOTERMS, A.PRICE, A.CREATED_BY, A.CREATION_DATE, @p_created_by AS LAST_UPDATED_BY
				 , GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
				 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10 
			FROM SCM_MST_FUTURE_PRICE A WITH(NOLOCK)			
			--[PJ2025-50188]_JOIN문을 사용해야 함으로, 어디에 속한 컬럼인지 ALIAS를 모두 적는다. (END)
			-----------------------------------------------------------------------------------------------
			--[PJ2025-50188]_SALES PLAN_C에서 실제로 사용할 데이터만 가지고 오도록 한다. (START)
			INNER JOIN ( SELECT SC.DIVISION_ID, SC.PROJECT_CODE, SC.SCM_SITE_ID, SC.ITEM_ID, SC.DOM_EXP, SC.FCST_TYPE, SC.INCOTERMS, SC.PLANT_SITE_ID
						 FROM #TEMP_MKT_FCST_DATA SC WITH(NOLOCK)
						 GROUP BY SC.DIVISION_ID, SC.PROJECT_CODE, SC.SCM_SITE_ID, SC.ITEM_ID, SC.DOM_EXP, SC.FCST_TYPE, SC.INCOTERMS, SC.PLANT_SITE_ID ) B
					ON A.DIVISION_ID	= B.DIVISION_ID
				   AND A.PROJECT_CODE	= B.PROJECT_CODE
				   AND A.SCM_SITE_ID	= B.SCM_SITE_ID
				   AND A.ITEM_ID		= B.ITEM_ID
				   AND A.DOM_EXP		= B.DOM_EXP
				   AND A.FCST_TYPE		= B.FCST_TYPE
				   AND A.INCOTERMS		= B.INCOTERMS
				   AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID		
			--[PJ2025-50188]_SALES PLAN_C에서 실제로 사용할 데이터만 가지고 오도록 한다. (END)	
			-----------------------------------------------------------------------------------------------
			WHERE A.DIVISION_ID		   = @p_division_id
			AND   A.YYYYMMDD		  >= @plan_start_yyyymmdd --[C20201005-000282] 당주 월요일부터 Sales Price Cutoff			
			AND   LEFT(A.YYYYMMDD, 6) < @plan_to_yyyymm --[PJ2025-50188]_소형 매출계획 동기화 개선 TO 날짜를 설정한다.

			--------------------------------------------------------------------------------------------
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 START			
			IF @p_division_id = '40' -- [PJ2025-50188]_40 사업부만 사용하는 테이블로, 40 사업부만 실행하도록 IF문으로 구분함
			BEGIN
PRINT ( @v_program_name + ' A006: ' + 'DIVISION_ID: '+ @p_division_id + ' / VERSION_TYPE: ' + @p_ver_type + ' / VERSION_NO: ' + @sales_plan_ver_return_no + ' / VERSION_NO: ' + @mkt_plan_ver_return_no  )	
				--------------------------------------------------------------------------------------------
				-- DM_PLN_CFM_SELLING_PRICE_C TABLE INSERT
				--------------------------------------------------------------------------------------------			
				INSERT INTO DM_PLN_CFM_SELLING_PRICE_C
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE
				, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER
				, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP
				, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE
				, LAST_UPDATED_BY, LAST_UPDATE_DATE	)
				-----------------------------------------------------------------------------------------------
				--[PJ2025-50188]_JOIN문을 사용해야 함으로, 어디에 속한 컬럼인지 ALIAS를 모두 적는다. (START)
				SELECT A.DIVISION_ID, @sales_plan_ver_return_no AS VERSION_NO, @p_ver_type AS CUTOFF_TYPE
					 , CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)	AS CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.END_CUSTOMER 
					 , A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP
					 , A.FCST_TYPE, A.INCOTERMS, A.PRICE, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE
					 , @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
				FROM DM_PLN_CFM_SELLING_PRICE A WITH(NOLOCK)
				--[PJ2025-50188]_JOIN문을 사용해야 함으로, 어디에 속한 컬럼인지 ALIAS를 모두 적는다. (END)
				-----------------------------------------------------------------------------------------------
				--[PJ2025-50188]_SALES PLAN_C에서 실제로 사용할 데이터만 가지고 오도록 한다. (START)
				INNER JOIN ( SELECT SC.DIVISION_ID, SC.PROJECT_CODE, SC.SCM_SITE_ID, SC.ITEM_ID, SC.DOM_EXP, SC.FCST_TYPE, SC.INCOTERMS, SC.PLANT_SITE_ID, SC.CELL_PROD_SITE_ID
							 FROM #TEMP_MKT_FCST_DATA SC WITH(NOLOCK)
							 GROUP BY SC.DIVISION_ID, SC.PROJECT_CODE, SC.SCM_SITE_ID, SC.ITEM_ID, SC.DOM_EXP, SC.FCST_TYPE, SC.INCOTERMS, SC.PLANT_SITE_ID, SC.CELL_PROD_SITE_ID ) B
						ON A.DIVISION_ID		= B.DIVISION_ID
					   AND A.PROJECT_CODE		= B.PROJECT_CODE
					   AND A.SCM_SITE_ID		= B.SCM_SITE_ID
					   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
					   AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID
					   AND A.ITEM_ID			= B.ITEM_ID
					   AND A.DOM_EXP			= B.DOM_EXP
					   AND A.FCST_TYPE			= B.FCST_TYPE
					   AND A.INCOTERMS			= B.INCOTERMS	
				--[PJ2025-50188]_SALES PLAN_C에서 실제로 사용할 데이터만 가지고 오도록 한다. (END)	
				-----------------------------------------------------------------------------------------------
				WHERE A.DIVISION_ID			 = @p_division_id
				AND   A.YYYYMMDD			>= @plan_start_yyyymmdd 		
				AND   LEFT(A.YYYYMMDD, 6)   <= @plan_to_yyyymm --[PJ2025-50188]_소형 매출계획 동기화 개선 TO 날짜를 설정한다.
			END
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 END
			--------------------------------------------------------------------------------------------	
		END
		-----------------------------------------------------------------------------------------------		
		-- [PJ2025-50188]_VERSION_TYPE이 S가 아니고 40 사업부인 경우 MKT FCST CUTOFF (START)
		ELSE
		BEGIN
			IF @p_division_id = '40'
			BEGIN 	
PRINT ( @v_program_name + ' A007: ' + 'DIVISION_ID: '+ @p_division_id + ' / VERSION_TYPE: ' + @p_ver_type + ' / VERSION_NO: ' + @sales_plan_ver_return_no + ' / VERSION_NO: ' + @mkt_plan_ver_return_no  )	
				--------------------------------------------------------------------------------------------
				--실제 SALES PLAN CUTOFF에 존재하는 데이터 중 SALES PRICE를 사용하는 메져의 MAX날짜를 구해 TO날짜로 설정한다.
				--월까지만 구하는 이유는, 데이터가 존재하는 월의 데이터까지는 모두 가져오기 위해서 (화면에서 월 평균값을 보여줌)
				--------------------------------------------------------------------------------------------
				SELECT @plan_to_yyyymm = LEFT(MAX(A.YYYYMMDD),6) 
				FROM  DM_PLN_CFM_MKT_DEMAND_PLAN_C A WITH(NOLOCK)
				INNER JOIN #TEMP_USE_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE A.DIVISION_ID = @p_division_id
				AND   A.VERSION_NO  = @sales_plan_ver_return_no
				AND   A.CUTOFF_TYPE = @p_ver_type
				AND   A.YYYYMMDD   >= @plan_start_yyyymmdd

				--------------------------------------------------------------------------------------------
				-- 2). INSERT 작업
				--------------------------------------------------------------------------------------------
PRINT ( @v_program_name + ' A008: ' + 'DIVISION_ID: '+ @p_division_id + ' / VERSION_TYPE: ' + @p_ver_type + ' / VERSION_NO: ' + @sales_plan_ver_return_no + ' / VERSION_NO: ' + @mkt_plan_ver_return_no  )	
				--------------------------------------------------------------------------------------------
				-- DM_PLN_CFM_SELLING_PRICE_C TABLE INSERT
				--------------------------------------------------------------------------------------------			
				INSERT INTO DM_PLN_CFM_SELLING_PRICE_C
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE
				, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER
				, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP
				, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE
				, LAST_UPDATED_BY, LAST_UPDATE_DATE	)
				SELECT A.DIVISION_ID, @sales_plan_ver_return_no AS VERSION_NO, @p_ver_type AS CUTOFF_TYPE
					 , CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)	AS CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.END_CUSTOMER 
					 , A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP
					 , A.FCST_TYPE, A.INCOTERMS, A.PRICE, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE
					 , @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
				FROM DM_PLN_CFM_SELLING_PRICE A WITH(NOLOCK)
				INNER JOIN ( SELECT MC.DIVISION_ID, MC.VERSION_NO, MC.CUTOFF_TYPE, MC.CUTOFF_YYYYMMDD, MC.PROJECT_CODE, MC.END_CUSTOMER
								  , MC.SCM_SITE_ID, MC.ITEM_ID, MC.DOM_EXP, MC.FCST_TYPE, MC.INCOTERMS, MC.PLANT_SITE_ID, MC.CELL_PROD_SITE_ID
							 FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C MC WITH(NOLOCK)
							 INNER JOIN #TEMP_USE_MEASURE TM ON MC.MEASURE = TM.MEASURE
							 WHERE MC.DIVISION_ID = @p_division_id
							 AND   MC.VERSION_NO  = @sales_plan_ver_return_no
							 AND   MC.CUTOFF_TYPE = @p_ver_type
							 AND   MC.YYYYMMDD   >= @plan_start_yyyymmdd
							 GROUP BY MC.DIVISION_ID, MC.VERSION_NO, MC.CUTOFF_TYPE, MC.CUTOFF_YYYYMMDD, MC.PROJECT_CODE, MC.END_CUSTOMER
								  , MC.SCM_SITE_ID, MC.ITEM_ID, MC.DOM_EXP, MC.FCST_TYPE, MC.INCOTERMS, MC.PLANT_SITE_ID, MC.CELL_PROD_SITE_ID ) B
						ON A.DIVISION_ID		= B.DIVISION_ID
					   AND A.PROJECT_CODE		= B.PROJECT_CODE
					   AND A.END_CUSTOMER		= B.END_CUSTOMER
					   AND A.SCM_SITE_ID		= B.SCM_SITE_ID
					   AND A.ITEM_ID			= B.ITEM_ID
					   AND A.DOM_EXP			= B.DOM_EXP
					   AND A.FCST_TYPE			= B.FCST_TYPE
					   AND A.INCOTERMS			= B.INCOTERMS	
					   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
					   AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID
				WHERE A.DIVISION_ID			 = @p_division_id
				AND   A.YYYYMMDD			>= @plan_start_yyyymmdd 		
				AND   LEFT(A.YYYYMMDD, 6)   <= @plan_to_yyyymm 
			END
		-- [PJ2025-50188]_VERSION_TYPE이 S가 아니고 40 사업부인 경우 MKT FCST CUTOFF (END)
		-----------------------------------------------------------------------------------------------		
		END

		--------------------------------------------------------------------------------------------
		-- 20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가
		--EXEC [dbo].PR_DM_TO_XIF_SCM_MST_FUTURE_PRICE_C @p_division_id, @v_ver_return_no
		--------------------------------------------------------------------------------------------		
		--==========================================================================================
 		-- CUTOFF DATA INSERT (END)
		--==========================================================================================
		
	--=============================================================================================
	-- 트랜잭션 (COMMIT)
	--=============================================================================================
		COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	
	
	--=============================================================================================
	-- 트랜잭션 (ERROR)
	--=============================================================================================
    BEGIN CATCH
	--------------------------------------------------------------	
		-- ROLLBACK
		ROLLBACK TRANSACTION PR_SCM_MST_FUTURE_PRICE_CUTOFF;

		SET @v_log_type		= 'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	
	
	--=============================================================================================
	-- 종료 LOG  (START)
	--=============================================================================================
	-- 수행결과 성공여부 DISPLAY
	IF @v_log_message IS NULL
		SELECT 'success'

    SET @v_log_type		= 'END';
    SET @v_log_message	= '########## END of procedure ##########';
    SET @v_description	= '';
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--=============================================================================================
	-- 종료 LOG  (END)
	--=============================================================================================
END;
