/*
 * Program ID  : [DMF0008_SAVE_EDI_MST_REPAIR]
 * Description  : EDI GSCM MASTER DATA 정비
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.05	   kdmcc14		  []  EDI GSCM MASTER DATA 정비
 */

 /*
  EXEC DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR @p_division_id='81', @p_project_code='A15PA7001'
		, @p_scm_site_id='PSA_FR_VSL', @p_item_id='APPSAPHEV-B1-D02', @p_currency='EUR'
		, @p_kwh='', @p_cell_per_car='84', @p_cell_per_module='14', @p_liability_period='0'
		, @p_valid_yn='Y', @p_bpms_exist='Y', @p_sales_company='G480', @p_sales_plant='G481'
		, @p_module_variant='', @p_incoterms='FCA', @p_created_by='kdmcc14'
*/

----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR]
		@p_division_id					NVARCHAR(MAX),
		@p_project_code					NVARCHAR(MAX),
		@p_scm_site_id					NVARCHAR(MAX),
		@p_item_id							NVARCHAR(MAX),
		@p_currency						NVARCHAR(MAX),
		@p_kwh								NVARCHAR(MAX),	--ATTRIBUTE8
		@p_cell_per_car					NVARCHAR(MAX),
		@p_cell_per_module				NVARCHAR(MAX),
		@p_liability_period				NVARCHAR(MAX),
		@p_valid_yn						NVARCHAR(MAX),
		@p_bpms_exist					NVARCHAR(MAX),
		@p_sales_company				NVARCHAR(MAX),
		@p_sales_plant					NVARCHAR(MAX),				
		@p_module_variant				NVARCHAR(MAX),	--ATTRIBUTE2
		@p_incoterms						NVARCHAR(MAX),	--ATTRIBUTE6		
		@p_created_by					NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;
	
	DECLARE @v_DIVISION_ID				NVARCHAR(MAX);
	DECLARE @v_PROJECT_CODE			NVARCHAR(MAX);
	DECLARE @v_SCM_SITE_ID				NVARCHAR(MAX);
	DECLARE @v_ITEM_ID						NVARCHAR(MAX);
	DECLARE @v_CURRENCY					NVARCHAR(MAX);
	DECLARE @v_KWH							NVARCHAR(MAX);
	DECLARE @v_CELL_PER_CAR				NVARCHAR(MAX);
	DECLARE @v_CELL_PER_MODULE		NVARCHAR(MAX);		
	DECLARE @v_LIABILITY_PERIOD			NVARCHAR(MAX);
	DECLARE @v_VALID_YN					NVARCHAR(MAX);
	DECLARE @v_BPMS_EXIST					NVARCHAR(MAX);
	DECLARE @v_SALES_COMPANY			NVARCHAR(MAX);
	DECLARE @v_SALES_PLANT				NVARCHAR(MAX);	
	DECLARE @v_MODULE_VARIANT		NVARCHAR(MAX);
	DECLARE @v_INCOTERMS				NVARCHAR(MAX);
	--DECLARE @v_KWH							NVARCHAR(MAX);	
	DECLARE @v_CREATED_BY				NVARCHAR(MAX);
	
	SET @v_DIVISION_ID				= NULL;
	SET @v_PROJECT_CODE			= NULL;
	SET @v_SCM_SITE_ID				= NULL;
	SET @v_ITEM_ID						= NULL;	
	SET @v_CURRENCY					= NULL;
	SET @v_KWH							= NULL;
	SET @v_CELL_PER_CAR				= NULL;			
	SET @v_CELL_PER_MODULE		= NULL;	
	SET @v_LIABILITY_PERIOD			= NULL;
	SET @v_VALID_YN					= NULL;
	SET @v_BPMS_EXIST				= NULL;
	SET @v_SALES_COMPANY			= NULL;
	SET @v_SALES_PLANT				= NULL;	
	SET @v_MODULE_VARIANT		= NULL;
	SET @v_INCOTERMS				= NULL;
	SET @v_CREATED_BY				= NULL;		
	

	DECLARE @v_delimiter NVARCHAR(1);
	SET @v_delimiter = '^';

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name		NVARCHAR(150) = 'DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 시작 LOG  (END)
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN SAVE_SALES_SITE_EDI;
	
	BEGIN TRY
	
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_division_id, @v_delimiter);    
		WHILE LEN(@p_division_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
						
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN			
					  
				SET @v_DIVISION_ID = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_DIVISION_ID

				SET @v_PROJECT_CODE = [dbo].[SCM_ARR_SPL_VAL](@p_project_code, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_PROJECT_CODE

				SET @v_SCM_SITE_ID = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_SCM_SITE_ID

				SET @v_ITEM_ID = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_ITEM_ID

				SET @v_CURRENCY = [dbo].[SCM_ARR_SPL_VAL](@p_currency, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_CURRENCY

				SET @v_KWH = [dbo].[SCM_ARR_SPL_VAL](@p_kwh, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_KWH

				SET @v_CELL_PER_CAR = [dbo].[SCM_ARR_SPL_VAL](@p_cell_per_car, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_CELL_PER_CAR

				SET @v_CELL_PER_MODULE	 = [dbo].[SCM_ARR_SPL_VAL](@p_cell_per_module, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_CELL_PER_MODULE	
			    
				SET @v_LIABILITY_PERIOD = [dbo].[SCM_ARR_SPL_VAL](@p_liability_period, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_LIABILITY_PERIOD

				SET @v_VALID_YN = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_VALID_YN
				
				SET @v_BPMS_EXIST = [dbo].[SCM_ARR_SPL_VAL](@p_bpms_exist, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_BPMS_EXIST				

				SET @v_SALES_COMPANY = [dbo].[SCM_ARR_SPL_VAL](@p_sales_company, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_SALES_COMPANY
				
				SET @v_SALES_PLANT = [dbo].[SCM_ARR_SPL_VAL](@p_sales_plant, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_SALES_PLANT

				SET @v_MODULE_VARIANT = [dbo].[SCM_ARR_SPL_VAL](@p_module_variant, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_MODULE_VARIANT

				SET @v_INCOTERMS = [dbo].[SCM_ARR_SPL_VAL](@p_incoterms, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_INCOTERMS

				SET @v_created_by = @p_created_by
								
			END

			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start -----------------------------------------------
			IF @v_VALID_YN = '' OR @v_VALID_YN IS NULL 				
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'필수 입력값을 확인하세요.'
					SET @v_description = N'필수 입력값을 확인하세요.'
					goto err_rtn
				END

			IF @v_DIVISION_ID = '' OR @v_DIVISION_ID IS NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'Div 입력값을 확인하세요.'
					SET @v_description = N'Div 입력값을 확인하세요.'
					goto err_rtn
				END

			IF @v_PROJECT_CODE = '' OR @v_PROJECT_CODE IS NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'Project Code 입력값을 확인하세요.'
					SET @v_description = N'Project Code 입력값을 확인하세요.'
					goto err_rtn
				END

			IF @v_SCM_SITE_ID = '' OR @v_SCM_SITE_ID IS NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'Sales Site 입력값을 확인하세요.'
					SET @v_description = N'Sales Site 입력값을 확인하세요.'
					goto err_rtn
				END			

			IF @v_ITEM_ID = '' OR @v_ITEM_ID IS NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'Model 입력값을 확인하세요.'
					SET @v_description = N'Model 입력값을 확인하세요.'
					goto err_rtn
				END
			
			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 end -----------------------------------------------

			--SCM_MST_SITE_ITEM_H History 생성					
			BEGIN		
				INSERT INTO [dbo].[SCM_MST_SITE_ITEM_H]
						( DIVISION_ID ,HISTORY_SEQ, PROJECT_CODE ,SCM_SITE_ID, ITEM_ID
						, CURRENCY, CELL_PER_CAR, CELL_PER_MODULE, LIABILITY_PERIOD
						, SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID, VALID_YN, BPMS_EXIST
						, CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION, ROUTE  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
						, SALES_COMPANY, SALES_PLANT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4
						, REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8
						, EDI_LT, SCP_VMI_LT, PARTIAL_PLAN_YN )		   
				SELECT DIVISION_ID, NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_H, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						, @v_CURRENCY, @v_CELL_PER_CAR, @v_CELL_PER_MODULE, @v_LIABILITY_PERIOD
						, SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID, @v_VALID_YN, @v_BPMS_EXIST
						, CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION, ROUTE  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
						, @v_SALES_COMPANY, @v_SALES_PLANT, @v_CREATED_BY, SYSDATETIME(), @v_CREATED_BY, SYSDATETIME()
						, ATTRIBUTE1, @v_MODULE_VARIANT, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, @v_INCOTERMS, ATTRIBUTE7, @v_KWH, ATTRIBUTE9, ATTRIBUTE10
						, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4
						, REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7, REPORT_GROUP8
						, EDI_LT, SCP_VMI_LT, PARTIAL_PLAN_YN
				FROM SCM_MST_SITE_ITEM WITH(NOLOCK) 
				WHERE DIVISION_ID = @v_DIVISION_ID
				AND PROJECT_CODE = @v_PROJECT_CODE
				AND SCM_SITE_ID = @v_SCM_SITE_ID
				AND ITEM_ID = @v_ITEM_ID
			END

			IF @mst_loop_cnt > 0
				
				BEGIN
					
					--SCM_MST_SITE_ITEM					
					MERGE INTO [dbo].[SCM_MST_SITE_ITEM] A
					USING (
							SELECT 
								@v_DIVISION_ID	AS DIVISION_ID, 
								@v_PROJECT_CODE AS PROJECT_CODE,
								@v_SCM_SITE_ID	AS SCM_SITE_ID,
								@v_ITEM_ID AS ITEM_ID
							) B
					ON(
								A.DIVISION_ID  = B.DIVISION_ID
							AND A.PROJECT_CODE = B.PROJECT_CODE
							AND A.SCM_SITE_ID  = B.SCM_SITE_ID
							AND A.ITEM_ID = B.ITEM_ID

						)
					WHEN MATCHED THEN
						UPDATE SET
									CURRENCY = @v_CURRENCY
								  , CELL_PER_CAR = (CASE WHEN @v_CELL_PER_CAR = 0 THEN NULL WHEN @v_CELL_PER_CAR = '' THEN NULL ELSE @v_CELL_PER_CAR END)
								  ,	CELL_PER_MODULE	= (CASE WHEN @v_CELL_PER_MODULE = 0 THEN NULL WHEN @v_CELL_PER_MODULE = '' THEN NULL ELSE @v_CELL_PER_MODULE END)
								  ,	LIABILITY_PERIOD = @v_LIABILITY_PERIOD
								  ,	VALID_YN = @v_VALID_YN
								  , BPMS_EXIST = @v_BPMS_EXIST
								  , SALES_COMPANY = @v_SALES_COMPANY
								  , SALES_PLANT = @v_SALES_PLANT
								  , ATTRIBUTE2 = @v_MODULE_VARIANT
								  , ATTRIBUTE6 = @v_INCOTERMS
								  , ATTRIBUTE8 = @v_KWH
								  , LAST_UPDATED_BY = @v_CREATED_BY
								  , LAST_UPDATE_DATE	= SYSDATETIME()

					WHEN NOT MATCHED THEN
						INSERT (  
								     DIVISION_ID
								   , PROJECT_CODE
								   , SCM_SITE_ID								   
								   , ITEM_ID
								   , CURRENCY
								   , CELL_PER_CAR
								   , CELL_PER_MODULE
								   , LIABILITY_PERIOD
								   , VALID_YN
								   , BPMS_EXIST
								   , SALES_COMPANY
								   , SALES_PLANT								   
								   , CREATED_BY
								   , CREATION_DATE
								   , LAST_UPDATED_BY
								   , LAST_UPDATE_DATE								   
								   , ATTRIBUTE2
								   , ATTRIBUTE6
								   , ATTRIBUTE8
								   )
						VALUES (   
									 @v_DIVISION_ID
								   , @v_PROJECT_CODE		
								   , @v_SCM_SITE_ID
								   , @v_ITEM_ID
								   , @v_CURRENCY
								   , (CASE WHEN @v_CELL_PER_CAR = 0 THEN NULL WHEN @v_CELL_PER_CAR = '' THEN NULL ELSE @v_CELL_PER_CAR END)
								   , (CASE WHEN @v_CELL_PER_MODULE = 0 THEN NULL WHEN @v_CELL_PER_MODULE = '' THEN NULL ELSE @v_CELL_PER_MODULE END)
								   , @v_LIABILITY_PERIOD
								   , @v_VALID_YN
								   , @v_BPMS_EXIST
								   , @v_SALES_COMPANY
								   , @v_SALES_PLANT								   
								   , @v_CREATED_BY
								   , SYSDATETIME()
								   , @v_CREATED_BY
								   , SYSDATETIME()
								   , @v_MODULE_VARIANT
								   , @v_INCOTERMS
								   , @v_KWH
								   );
					
				END

		END
				
/*
  EXEC DMF0008_SAVE_SALES_SITE_EDI_REPAIR @p_division_id='81', @p_end_customer='BMW', @p_soldto_customer='BMW'
	, @p_company_id='G480', @p_scm_site_id='BMW_AT_GRZ', @p_soldto_code='AT000003A', @p_shipto_code='AT000003A'
	, @p_vmi_yn='N', @p_valid_yn='Y', @p_cust_valid_yn='Y', @p_rep_yn='Y'
	, @p_country='AT', @p_city='ATGRZ', @p_ship_plan_auto='Y', @p_dept_id='58665472', @p_created_by='kdmcc14'

  EXEC DMF0008_SAVE_SALES_SITE_EDI_REPAIR @p_division_id='81^81', @p_end_customer='BMW^BMW', @p_soldto_customer='BMW^BMW'
	, @p_company_id='G480^G480', @p_scm_site_id='BMW_AT_GRZ^BMW_AT_SER', @p_soldto_code='AT000003A^DE000272', @p_shipto_code='AT000003A^ATH000024'
	, @p_vmi_yn='N^N', @p_valid_yn='Y^Y', @p_cust_valid_yn='Y^Y', @p_rep_yn='Y^Y'
	, @p_country='AT^AT', @p_city='ATGRZ^ATSER', @p_ship_plan_auto='Y^Y', @p_dept_id='58665472^58665472', @p_created_by='kdmcc14'

 */			
	
		COMMIT;	

	END TRY

				
	BEGIN CATCH
		
		ROLLBACK TRAN SAVE_SALES_SITE_EDI ;	

		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

    END CATCH;

	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;						

-- 트랜잭션 (END)
err_rtn:
	IF @v_log_type = 'INVALID'
		BEGIN
			ROLLBACK TRAN SAVE_SALES_SITE_EDI;
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;			
		END
