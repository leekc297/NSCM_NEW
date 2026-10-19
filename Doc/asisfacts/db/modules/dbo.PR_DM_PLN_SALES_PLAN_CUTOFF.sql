





---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : PR_DM_PLN_SALES_PLAN_CUTOFF
 * Description  : 매주 화요일에 Weekly cutoff 수행(40, 82 : 00시, 81 : 04시)
 * Program History
 *===================================================================================================
 *   Date       In Charge              Description
 *===================================================================================================
 * 2017. 02. 05    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가 (20180703 임시 주석처리함)
 * 20180726 KHSONG PR_SCM_MST_FUTURE_PRICE_CUTOFF 호출 추가
 * 20180806 KHSONG PR_DM_MST_EXCHANGE_RATE_CUTOFF 호출 추가
 * 20191113 KYH Companyid 추가
 * 20200709 P.C.I   [PJ20200138] Sales Plan Weekly Cutoff 분리
                    [40] 화요일 : Sales Price Weekly Cutoff, Exchange Rate Weekly Cutoff/금요일 : Sales Plan Cutoff Weekly Version 
                    [81] 화요일 : Sales Price Weekly Cutoff, Exchange Rate Weekly Cutoff/목요일 : Sales Plan Cutoff Weekly Version 
                    [82] 금요일 : Sales Plan Weekly Cutoff Version, Sales Price Weekly Cutoff, Exchange Rate Weekly Cutoff
 * 20200722 P.C.I   [PJ20200138] Sales Plan Cutoff 생성시 Sales Price, Exchange Rate Cutoff 동시 생성 - Weekly Cutoff 제외
 * 2020/09/09	P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2022.04.07	hwi1993     GM JV 작업
 * 2025.01.21	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리 
 * 2025.03.18	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선. 
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_SALES_PLAN_CUTOFF]

	-- Add the parameters for the stored procedure here
      @p_division_id          NVARCHAR(30)    -- division_id 전달받음
	, @p_version_description  NVARCHAR(MAX)  -- description 전달받음
	, @p_ver_type			  NVARCHAR(MAX)
	, @p_created_by			  NVARCHAR(MAX)
AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_SALES_PLAN_CUTOFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_ver_description		NVARCHAR(MAX);
	DECLARE @v_ver_type				NVARCHAR(MAX);
	DECLARE @v_rolling_type			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);

	DECLARE	@v_ver_return_no		NVARCHAR(100);	-- cut off Generated Number	
	DECLARE @v_plan_week			NVARCHAR(MAX);
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	

	SET @v_division_id		 = NULL;	
	SET @v_ver_description	 = NULL;	
	SET @v_ver_type			 = NULL;	
	SET @v_rolling_type		 = NULL;	
	SET @v_created_by		 = NULL;	

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION PR_DM_PLN_SALES_PLAN_CUTOFF;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
			
			--[PJ20200138] SP_W 의 Created_by는 'WITHOUT_SP_W'로 설정하여 화면에서 구분
			/*
			IF @p_ver_type = 'SP_W' AND @p_division_id IN ('40','81')
			BEGIN
				SET @p_created_by = 'WITHOUT_SP_W'
			END
			*/


		   SET @v_division_id = @p_division_id;
		   SET @p_version_description =
			 CASE
				 WHEN (@p_ver_type = 'SP_M') THEN @p_version_description
				 WHEN (@p_ver_type = 'SP_D') THEN 'SALES_PLAN DAILY CUTOFF'
				 WHEN (@p_ver_type = 'SP_W') THEN 'SALES_PLAN WEEKLY CUTOFF'
			 END

			EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
			 @v_division_id
			,@p_version_description --'DM_PLN_SALES_PLAN DAILY CUTOFF',  -- @v_ver_description
			,@p_ver_type
			,@p_created_by
			,@v_ver_return_no  OUTPUT
			,@v_OK_description OUTPUT
					
			--[PJ20200138] Weekly Cutoff는 화요일에 수행하지 않음
			--IF @p_ver_type <> 'SP_W'
			BEGIN

			-- 1. [DM_PLN_SALES_PLAN] -> [DM_PLN_SALES_PLAN_C]
				BEGIN
					INSERT INTO [dbo].DM_PLN_SALES_PLAN_C 
					(
					 DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
					,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY				--[PJ2025-50017] CELL_PROD_SITE_ID 추가
					,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
					SELECT 
						 DIVISION_ID
						,@v_ver_return_no AS VERSION_NO --VERSION_NO
						,@p_ver_type AS CUTOFF_TYPE      -- CUTOFF_TYPE
						,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD  -- CUTOFF_YYYYMMDD
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID
						,CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						,YYYYMMDD
						,isnull(CURRENCY,'')  -- 20180319 skh modify
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,@p_created_by AS LAST_UPDATED_BY
						,GETDATE()
						,ATTRIBUTE1
						,ATTRIBUTE2
						,ATTRIBUTE3
						,ATTRIBUTE4
						,ATTRIBUTE5
						,ATTRIBUTE6
						,ATTRIBUTE7
						,ATTRIBUTE8
						,ATTRIBUTE9
						,ATTRIBUTE10
					FROM [dbo].DM_PLN_SALES_PLAN A WITH(NOLOCK)
					  WHERE DIVISION_ID = @v_division_id
					   AND [YYYYMMDD]	>=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 금주 월요일 이후

					AND A.FCST_TYPE NOT IN (SELECT DISTINCT SEGMENT2 
													FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
													WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
														AND VALID_YN = 'Y'  
														AND SEGMENT1 = A.DIVISION_ID)
					AND  A.ITEM_ID NOT IN (SELECT DISTINCT SEGMENT3 
												FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
												WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
													AND VALID_YN = 'Y'  
													AND SEGMENT1 = A.DIVISION_ID) 
					AND A.MEASURE NOT IN
					(
						SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
						WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
						AND VALID_YN = 'Y'
					)

					--[PJ2024-50611] 기타매출, Catch Up 테이블 분리
					INSERT INTO [dbo].DM_PLN_SALES_ETC_PLAN_C
					(
					 DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,REMARK_TEXT
					,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
					--,CELL_PROD_SITE_ID									--[PJ2025-50017] CELL_PROD_SITE_ID 추가
					,YYYYMMDD,CURRENCY,QTY,CREATED_BY				
					,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
					SELECT 
						 DIVISION_ID
						,@v_ver_return_no AS VERSION_NO --VERSION_NO
						,@p_ver_type AS CUTOFF_TYPE      -- CUTOFF_TYPE
						,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD  -- CUTOFF_YYYYMMDD
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,REMARK_TEXT
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID
						--,CELL_PROD_SITE_ID							--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						,YYYYMMDD
						,isnull(CURRENCY,'')  -- 20180319 skh modify
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,@p_created_by AS LAST_UPDATED_BY
						,GETDATE()
						,ATTRIBUTE1
						,ATTRIBUTE2
						,ATTRIBUTE3
						,ATTRIBUTE4
						,ATTRIBUTE5
						,ATTRIBUTE6
						,ATTRIBUTE7
						,ATTRIBUTE8
						,ATTRIBUTE9
						,ATTRIBUTE10
					FROM [dbo].DM_PLN_SALES_ETC_PLAN A WITH(NOLOCK)
					  WHERE DIVISION_ID = @v_division_id
					   AND [YYYYMMDD]	>=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 금주 월요일 이후

					--[PJ2024-50611] 기타매출, Catch Up 테이블 분리

				END



			-- 1. [DM_PLN_SALES_PLAN_RESULT] -> [DM_PLN_SALES_PLAN_RESULT_C]
			--[2018-03-28][추가][DM_PLN_SALES_PLAN_REULT_C CUTOFF]
			/* DM_PLN_SALES_PLAN_REULT_C CUTOFF DATA INSERT */
				BEGIN
					INSERT INTO [dbo].DM_PLN_SALES_PLAN_RESULT_C 
					(
					 DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
					,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY
					,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10, COMPANY_ID
					,CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					)
					SELECT 
						 DIVISION_ID
						,@v_ver_return_no AS VERSION_NO --VERSION_NO
						,@p_ver_type AS CUTOFF_TYPE      -- CUTOFF_TYPE
						,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD  -- CUTOFF_YYYYMMDD
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID
						,YYYYMMDD
						,isnull(CURRENCY,'')  -- 20180319 skh modify
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,@p_created_by AS LAST_UPDATED_BY
						,GETDATE()
						,ATTRIBUTE1
						,ATTRIBUTE2
						,ATTRIBUTE3
						,ATTRIBUTE4
						,ATTRIBUTE5
						,ATTRIBUTE6
						,ATTRIBUTE7
						,ATTRIBUTE8
						,ATTRIBUTE9
						,ATTRIBUTE10
						,COMPANY_ID
						,CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM [dbo].DM_PLN_SALES_PLAN_RESULT WITH(NOLOCK)
				   WHERE DIVISION_ID = @v_division_id
					 AND [YYYYMMDD]	<   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)			-- [2018-03-28][추가][금주 월요일 이전]
					 AND [YYYYMMDD]	>=  CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 최근 1년치
				END
			--SELECT @p_division_id AS '@p_division_id',@v_division_id AS '@v_division_id',@v_ver_return_no AS '@v_ver_return_no'
			--END
		--------------------------------------------------------------------------- 20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가
		--EXEC [dbo].PR_DM_TO_XIF_DM_PLN_SALES_PLAN_C @v_division_id, @v_ver_return_no
		---------------------------------------------------------------------------
		
			--[PJ20200138] Sales Price Weekly Cutoff, Exchange Rate Weekly Cutoff 는 Sales Plan Weekly Cutoff 생성시 수행(PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE)
			--IF @p_ver_type <> 'SP_W'
			--BEGIN
			------------------------------------------------------------------------ 20180726 KHSONG PR_SCM_MST_FUTURE_PRICE_CUTOFF 호출 추가 (S) 
				EXEC	[dbo].[PR_SCM_MST_FUTURE_PRICE_CUTOFF]	
						 @v_division_id
						,@p_ver_type
						,@p_created_by
						,@v_ver_return_no
						;
				------------------------------------------------------------------------ 20180726 KHSONG PR_SCM_MST_FUTURE_PRICE_CUTOFF 호출 추가 (E) 

				------------------------------------------------------------------------ 20180806 KHSONG PR_DM_MST_EXCHANGE_RATE_CUTOFF 호출 추가 (S) 
				EXEC	[dbo].[PR_DM_MST_EXCHANGE_RATE_CUTOFF]	
						 @v_division_id
						,@p_ver_type
						,@p_created_by
						,@v_ver_return_no
						;
			------------------------------------------------------------------------ 20180806 KHSONG PR_DM_MST_EXCHANGE_RATE_CUTOFF 호출 추가 (E) 
			END
  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
      -- ROLLBACK
	  -- 트랜잭션 (END)
	  ROLLBACK TRANSACTION PR_DM_PLN_SALES_PLAN_CUTOFF;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END;
