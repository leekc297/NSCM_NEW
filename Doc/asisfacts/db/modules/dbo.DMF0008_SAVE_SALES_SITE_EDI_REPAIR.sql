/*
 * Program ID  : [DMF0008_SAVE_SALES_SITE_EDI_REPAIR]
 * Description  : EDI GSCM MASTER DATA 정비
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.05	   kdmcc14		  []  EDI GSCM SALES SITE MASTER DATA 정비
 */

 /*
  EXEC DMF0008_SAVE_SALES_SITE_EDI_REPAIR @p_division_id='81', @p_end_customer='BMW', @p_soldto_customer='BMW'
	, @p_company_id='G480', @p_scm_site_id='BMW_AT_GRZ', @p_soldto_code='AT000003A', @p_shipto_code='AT000003A'
	, @p_vmi_yn='N', @p_valid_yn='Y', @p_cust_valid_yn='Y', @p_rep_yn='Y'
	, @p_country='AT', @p_city='ATGRZ', @p_ship_plan_auto='Y', @p_dept_id='58665472', @p_created_by='kdmcc14'
*/

----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DMF0008_SAVE_SALES_SITE_EDI_REPAIR]		
		@p_division_id					NVARCHAR(MAX),
		@p_end_customer				NVARCHAR(MAX),
		@p_soldto_customer			NVARCHAR(MAX),
		@p_company_id					NVARCHAR(MAX),
		@p_scm_site_id					NVARCHAR(MAX),
		@p_soldto_code					NVARCHAR(MAX),
		@p_shipto_code					NVARCHAR(MAX),
		@p_vmi_yn							NVARCHAR(MAX),
		@p_valid_yn						NVARCHAR(MAX),
		@p_cust_valid_yn					NVARCHAR(MAX),
		@p_rep_yn							NVARCHAR(MAX),
		@p_country						NVARCHAR(MAX),
		@p_city								NVARCHAR(MAX),
		@p_ship_plan_auto				NVARCHAR(MAX),
		@p_dept_id						NVARCHAR(MAX),
		@p_created_by					NVARCHAR(MAX)		


AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;
	
	DECLARE @v_DIVISION_ID				NVARCHAR(MAX);
	DECLARE @v_END_CUSTOMER			NVARCHAR(MAX);
	DECLARE @v_SOLDTO_CUSTOMER	NVARCHAR(MAX);
	DECLARE @v_COMPANY_ID				NVARCHAR(MAX);
	DECLARE @v_SCM_SITE_ID				NVARCHAR(MAX);
	DECLARE @v_SOLDTO_CODE			NVARCHAR(MAX);
	DECLARE @v_SHIPTO_CODE				NVARCHAR(MAX);		
	DECLARE @v_VMI_YN						NVARCHAR(MAX);
	DECLARE @v_VALID_YN					NVARCHAR(MAX);
	DECLARE @v_CUST_VALID_YN			NVARCHAR(MAX);
	DECLARE @v_REP_YN						NVARCHAR(MAX);
	DECLARE @v_COUNTRY					NVARCHAR(MAX);
	DECLARE @v_CITY							NVARCHAR(MAX);
	DECLARE @v_SHIP_PLAN_AUTO			NVARCHAR(MAX);
	DECLARE @v_DEPT_ID						NVARCHAR(MAX);
	DECLARE @v_CREATED_BY				NVARCHAR(MAX);	
	
	SET @v_DIVISION_ID				= NULL;
	SET @v_END_CUSTOMER			= NULL;
	SET @v_SOLDTO_CUSTOMER	= NULL;
	SET @v_COMPANY_ID				= NULL;
	SET @v_SCM_SITE_ID				= NULL;
	SET @v_SOLDTO_CODE			= NULL;
	SET @v_SHIPTO_CODE				= NULL;			
	SET @v_VMI_YN						= NULL;	
	SET @v_VALID_YN					= NULL;
	SET @v_CUST_VALID_YN			= NULL;
	SET @v_REP_YN						= NULL;
	SET @v_COUNTRY					= NULL;
	SET @v_CITY							= NULL;
	SET @v_SHIP_PLAN_AUTO			= NULL;
	SET @v_DEPT_ID						= NULL;
	SET @v_CREATED_BY				= NULL;		

	DECLARE @v_delimiter NVARCHAR(1);
	SET @v_delimiter = '^';

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name		NVARCHAR(150) = 'DMF0008_SAVE_SALES_SITE_EDI_REPAIR';
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

				SET @v_END_CUSTOMER = [dbo].[SCM_ARR_SPL_VAL](@p_end_customer, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_END_CUSTOMER

				SET @v_SOLDTO_CUSTOMER = [dbo].[SCM_ARR_SPL_VAL](@p_soldto_customer, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_SOLDTO_CUSTOMER

				SET @v_COMPANY_ID = [dbo].[SCM_ARR_SPL_VAL](@p_company_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_COMPANY_ID

				SET @v_SCM_SITE_ID = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_SCM_SITE_ID

				SET @v_SOLDTO_CODE = [dbo].[SCM_ARR_SPL_VAL](@p_soldto_code, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_SOLDTO_CODE
			    
				SET @v_SHIPTO_CODE = [dbo].[SCM_ARR_SPL_VAL](@p_shipto_code, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_SHIPTO_CODE
				
				SET @v_VMI_YN = [dbo].[SCM_ARR_SPL_VAL](@p_vmi_yn, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_VMI_YN

				SET @v_VALID_YN = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_VALID_YN

				SET @v_CUST_VALID_YN = [dbo].[SCM_ARR_SPL_VAL](@p_cust_valid_yn, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_CUST_VALID_YN
				
				SET @v_REP_YN = [dbo].[SCM_ARR_SPL_VAL](@p_rep_yn, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_REP_YN

				SET @v_COUNTRY = [dbo].[SCM_ARR_SPL_VAL](@p_country, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_COUNTRY

				SET @v_CITY = [dbo].[SCM_ARR_SPL_VAL](@p_city, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_CITY

				SET @v_SHIP_PLAN_AUTO = [dbo].[SCM_ARR_SPL_VAL](@p_ship_plan_auto, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_SHIP_PLAN_AUTO

				SET @v_DEPT_ID = [dbo].[SCM_ARR_SPL_VAL](@p_dept_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_DEPT_ID

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

			IF @v_SCM_SITE_ID = '' OR @v_SCM_SITE_ID IS NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'Sales Site 입력값을 확인하세요.'
					SET @v_description = N'Sales Site 입력값을 확인하세요.'
					goto err_rtn
				END

			IF @v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE IS NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'Sold-To 입력값을 확인하세요.'
					SET @v_description = N'Sold-To 입력값을 확인하세요.'
					goto err_rtn
				END

			IF @v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE IS NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'Rep Ship-To 입력값을 확인하세요.'
					SET @v_description = N'Rep Ship-To 입력값을 확인하세요.'
					goto err_rtn
				END

			IF @v_CUST_VALID_YN = '' OR @v_CUST_VALID_YN IS NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'Customer Active 입력값을 확인하세요.'
					SET @v_description = N'Customer Active 입력값을 확인하세요.'
					goto err_rtn
				END	
			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 end -----------------------------------------------

			--SCM_MST_SITE_HIST History 생성					
			BEGIN
				INSERT INTO SCM_MST_SITE_H
						( HISTORY_SEQ, DIVISION_ID, SCM_SITE_ID, PLANT_ID, OPERATION_GROUP, SITE_DESCRIPTION, SITE_TYPE, CITY, COUNTRY, DEPT_ID
						, VMI_YN, VALID_YN, NEW_YN, SITE_HRCY_ID, OSP_YN, SHIP_FROZEN, PROD_FROZEN, END_CUSTOMER, SOLDTO_CUSTOMER, FP_PLAN_PERIOD
						, BUILD_AHEAD, LOGISTIC_PLANT_ID, PACKER_ITEM_ID_SUFFIX, HQ_VENDOR_CODE, COMPANY_ID, SITE_ID, CREATED_BY, CREATION_DATE
						, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
						, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, HISTORY_CREATION_DATE )
				SELECT NEXT VALUE FOR SEQ1_SCM_MST_SITE_H, DIVISION_ID, SCM_SITE_ID, PLANT_ID, OPERATION_GROUP, SITE_DESCRIPTION, SITE_TYPE, @v_CITY, @v_COUNTRY, @v_DEPT_ID
						, @v_VMI_YN, @v_VALID_YN, NEW_YN, SITE_HRCY_ID, OSP_YN, SHIP_FROZEN, PROD_FROZEN, @v_END_CUSTOMER, @v_SOLDTO_CUSTOMER, FP_PLAN_PERIOD
						, BUILD_AHEAD, LOGISTIC_PLANT_ID, PACKER_ITEM_ID_SUFFIX, HQ_VENDOR_CODE, @v_COMPANY_ID, SITE_ID, @v_CREATED_BY, SYSDATETIME()
						, @v_CREATED_BY, SYSDATETIME(), ATTRIBUTE1, @v_SHIP_PLAN_AUTO, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
						, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, SYSDATETIME()
				FROM SCM_MST_SITE WITH(NOLOCK)
				WHERE DIVISION_ID = @v_DIVISION_ID
				AND SCM_SITE_ID = @v_SCM_SITE_ID          
			END
			
			--SCM_MST_SITE_CUSTOMER History 생성
			BEGIN
				EXEC	[dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]
							 @v_DIVISION_ID
							, @v_SCM_SITE_ID
							, @v_SOLDTO_CODE
							, @v_SHIPTO_CODE
							, @v_REP_YN
							, @v_CREATED_BY
							, @v_CUST_VALID_YN
			END

			IF @mst_loop_cnt > 0
				
				BEGIN

					--SCM_MST_SITE_CUSTOMER
					MERGE INTO [dbo].[SCM_MST_SITE_CUSTOMER] A
					USING ( 
								SELECT 
									@v_DIVISION_ID	AS DIVISION_ID, 
									@v_SCM_SITE_ID	AS SITE_ID,
									@v_SOLDTO_CODE AS SOLDTO_CODE,
									@v_SHIPTO_CODE AS SHIPTO_CODE
							) B
					ON(
								A.DIVISION_ID  = B.DIVISION_ID
							AND A.SCM_SITE_ID  = B.SITE_ID
							AND A.SOLDTO_CODE = B.SOLDTO_CODE
							AND A.SHIPTO_CODE = B.SHIPTO_CODE
					)
					WHEN MATCHED THEN
						UPDATE SET 									
								    REP_YN = ISNULL(@v_REP_YN, 'N')
								  , VALID_YN = ISNULL(@v_CUST_VALID_YN, 'N')
								  , LAST_UPDATED_BY = @v_CREATED_BY
								  , LAST_UPDATE_DATE = SYSDATETIME()

					WHEN NOT MATCHED THEN
						INSERT (  
									 DIVISION_ID
								   , SCM_SITE_ID
								   , SOLDTO_CODE
								   , SHIPTO_CODE
								   , REP_YN
								   , VALID_YN
								   , CREATED_BY
								   , CREATION_DATE
								   , LAST_UPDATED_BY
								   , LAST_UPDATE_DATE								  
								   )
						VALUES (   
									 @v_DIVISION_ID
								   , @v_SCM_SITE_ID
								   , @v_SOLDTO_CODE								   
								   , @v_SHIPTO_CODE
								   , ISNULL(@v_REP_YN, 'N')
								   , ISNULL(@v_CUST_VALID_YN, 'N')
								   , @v_CREATED_BY
								   , SYSDATETIME()
								   , @v_CREATED_BY
								   , SYSDATETIME()								   
								   );

					--SCM_MST_SITE				    
			 				
					--임시확인용
					SELECT @v_DIVISION_ID AS DIVISION_ID, @v_SCM_SITE_ID AS  SCM_SITE_ID, @v_SOLDTO_CODE AS SOLDTO_CODE, @v_SHIPTO_CODE AS SHIPTO_CODE, @v_VALID_YN AS VALID_YN

					MERGE INTO [dbo].[SCM_MST_SITE] A
					USING (
							SELECT 
								@v_DIVISION_ID	AS DIVISION_ID, 
								@v_SCM_SITE_ID	AS SITE_ID
							) B
					ON(
								A.DIVISION_ID  = B.DIVISION_ID
							AND A.SCM_SITE_ID  = B.SITE_ID

						)
					WHEN MATCHED THEN
						UPDATE SET
									CITY = @v_CITY
								  , COUNTRY = @v_COUNTRY
								  ,	DEPT_ID	= @v_DEPT_ID
								  ,	VMI_YN = ISNULL(@v_VMI_YN, 'N')
								  ,	VALID_YN = @v_VALID_YN
								  , END_CUSTOMER = @v_END_CUSTOMER
								  , SOLDTO_CUSTOMER = @v_SOLDTO_CUSTOMER
								  , COMPANY_ID = @v_COMPANY_ID
								  , ATTRIBUTE2 = @v_SHIP_PLAN_AUTO
								  , LAST_UPDATED_BY = @v_CREATED_BY
								  , LAST_UPDATE_DATE	= SYSDATETIME()

					WHEN NOT MATCHED THEN
						INSERT (  
								     DIVISION_ID								   
								   , SCM_SITE_ID
								   , SITE_DESCRIPTION
								   , SITE_TYPE
								   , END_CUSTOMER
								   , SOLDTO_CUSTOMER
								   , CITY
								   , COUNTRY
								   , DEPT_ID
								   , VMI_YN
								   , VALID_YN
								   , NEW_YN
								   , COMPANY_ID
								   , CREATED_BY
								   ,CREATION_DATE
								   ,LAST_UPDATED_BY
								   ,LAST_UPDATE_DATE
								   ,ATTRIBUTE2
								   )
						VALUES (   
									 @v_DIVISION_ID
								   , @v_SCM_SITE_ID	
								   , @v_SCM_SITE_ID	
								   , 'SALES'
								   , @v_END_CUSTOMER
								   , @v_SOLDTO_CUSTOMER
								   , @v_CITY
								   , @v_COUNTRY
								   , @v_DEPT_ID
								   , ISNULL(@v_VMI_YN, 'N')
								   , @v_VALID_YN
								   , 'Y'
								   , @v_COMPANY_ID
								   , @v_CREATED_BY
								   , SYSDATETIME()
								   , @v_CREATED_BY
								   , SYSDATETIME()
								   , @v_SHIP_PLAN_AUTO
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
