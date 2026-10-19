/*
 * Program ID   : [SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN]
 * Description  : Save data SCP0115 Policy Inv Management
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/10/14   TanVQ1			Adding new function for saving data for SCP0115 Policy Inv Management
 * 2025/01/02	TanVQ1			Table dbo.SCP_ANL_LGTM_PCY_INV_MGMT_PLAN schema changed
 */
-- EXEC [SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN] 'INSERT_EXCEL', '', '20250307', 'S', '81', 'WA00', 'ERCA00068AA', 'OCCR_RSN_50', '니치아 정책재고', 'EXHT_TP_03', 'GEM사 판매', '20250415', '253400', '', 'victory25'
CREATE PROCEDURE [dbo].[SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN] 

	-- Add the parameters for the stored procedure here	
	@p_active_flag			NVARCHAR(MAX),
	@p_request_no			NVARCHAR(MAX),
	@p_plan_start_yyyymmdd	NVARCHAR(MAX),
	@p_plan_tp_cd			NVARCHAR(MAX),
	@p_company_id			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_plant_id				NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_occr_rsn_cd			NVARCHAR(MAX),
	@p_occr_rsn_ctn			NVARCHAR(MAX),
	@p_exht_tp_cd			NVARCHAR(MAX),
	@p_exht_tp_ctn			NVARCHAR(MAX),
	@p_plan_yyyymmdd		NVARCHAR(MAX),
	@p_qty					NVARCHAR(MAX),
	@p_supplier_code		NVARCHAR(MAX),
	@p_user_id				NVARCHAR(MAX)
AS

BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_request_no			NVARCHAR(MAX);
	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(MAX);
	DECLARE @v_plan_tp_cd			NVARCHAR(MAX)
	DECLARE @v_company_id			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_plant_id				NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_occr_rsn_cd			NVARCHAR(MAX);
	DECLARE @v_occr_rsn_ctn			NVARCHAR(MAX);
	DECLARE @v_exht_tp_cd			NVARCHAR(MAX);
	DECLARE @v_exht_tp_ctn			NVARCHAR(MAX);
	DECLARE @v_plan_yyyymmdd			NVARCHAR(MAX);
	DECLARE @v_qty					numeric(30,8);
	DECLARE @v_user_id				NVARCHAR(MAX);
	DECLARE @v_supplier_code		NVARCHAR(MAX);
	DECLARE @v_qty_item				NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_request_no = NULL;
	SET @v_plan_start_yyyymmdd = NULL;
	SET @v_plan_tp_cd = NULL;
	SET @v_company_id = NULL;
	SET @v_division_id = NULL;
	SET @v_item_id = NULL;
	SET @v_occr_rsn_cd = NULL;	 
	SET @v_occr_rsn_ctn = NULL;	
	SET @v_exht_tp_cd = NULL;	
	SET @v_exht_tp_ctn = NULL;	
	SET @v_supplier_code = NULL;
	SET @v_plan_yyyymmdd = NULL;	 

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '|'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0115_SAVE_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	-- 트렌젝션 시작
	BEGIN TRAN;
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	

		BEGIN TRY

	    -- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		--SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@p_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;  
			
				SET @v_plan_start_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_plan_start_yyyymmdd, @v_delimiter , @mst_loop_cnt) ;    
				
				SET @v_plan_tp_cd = [dbo].[SCM_ARR_SPL_VAL](@p_plan_tp_cd, @v_delimiter , @mst_loop_cnt) ; 		

				SET @v_company_id = [dbo].[SCM_ARR_SPL_VAL](@p_company_id, @v_delimiter , @mst_loop_cnt) ; 
				
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 

				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ; 
				
				SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;    
				
				SET @v_occr_rsn_cd = [dbo].[SCM_ARR_SPL_VAL](@p_occr_rsn_cd, @v_delimiter , @mst_loop_cnt);
				
				SET @v_occr_rsn_ctn = [dbo].[SCM_ARR_SPL_VAL](@p_occr_rsn_ctn, @v_delimiter , @mst_loop_cnt) ;  

				SET @v_exht_tp_cd = [dbo].[SCM_ARR_SPL_VAL](@p_exht_tp_cd, @v_delimiter , @mst_loop_cnt);
				
				SET @v_exht_tp_ctn = [dbo].[SCM_ARR_SPL_VAL](@p_exht_tp_ctn, @v_delimiter, @mst_loop_cnt) ; 
				
				SET @v_plan_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_plan_yyyymmdd, @v_delimiter, @mst_loop_cnt) ; 
				
				SET @v_qty_item	 = [dbo].[SCM_ARR_SPL_VAL](@p_qty, @v_delimiter, @mst_loop_cnt)
				IF  @v_qty_item	<> 'NULL' AND @v_qty_item	<> ''
					BEGIN
						SET @v_qty = CAST (@v_qty_item  AS numeric(30,8) ); 						
					END
				ELSE
					BEGIN
						SET @v_qty = 0						
					END

				SET @v_supplier_code = [dbo].[SCM_ARR_SPL_VAL](@p_supplier_code, @v_delimiter , @mst_loop_cnt) ; 				 

				SET @v_user_id = [dbo].[SCM_ARR_SPL_VAL](@p_user_id, @v_delimiter, @mst_loop_cnt) ; 
				
				SET @v_request_no = [dbo].[SCM_ARR_SPL_VAL](@p_request_no, @v_delimiter , @mst_loop_cnt) ; 
				
				SELECT @v_request_no;

				IF @v_request_no = 'NULL' OR @v_request_no = '' OR len(@v_request_no) <= 1 
					BEGIN
						SET @v_request_no = @v_plan_start_yyyymmdd+'-'+ CAST( NEXT VALUE FOR SEQ1_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN AS NVARCHAR);	
					END
				--
						
			END

			IF @mst_loop_cnt > 0 
				BEGIN 		
							MERGE INTO [dbo].[SCP_ANL_LGTM_PCY_INV_MGMT_PLAN] A
							USING (
									SELECT 
										@v_request_no				as request_no,
										@v_plan_start_yyyymmdd		as plan_start_yyyymmdd
										--@v_plan_tp_cd				as plan_tp_cd,
										--@v_division_id				as division_id, 
										--@v_item_id					as item_id, 
										--@v_plan_yyyymmdd			as plan_yyyymmdd,
										--@v_plant_id					as plant_id,
										--@v_occr_rsn_cd 				as occr_rsn_cd,
										--@v_exht_tp_cd				as exht_tp_cd
							) B
							ON(
										A.request_no				= B.request_no
									AND	A.plan_start_yyyymmdd		= B.plan_start_yyyymmdd
									--AND A.plan_tp_cd				= B.plan_tp_cd
									--AND A.division_id				= B.division_id
									--AND A.item_id					= B.item_id
									--AND A.plan_yyyymmdd				= B.plan_yyyymmdd
									--AND A.plant_id					= B.plant_id
									--AND A.occr_rsn_cd				= B.occr_rsn_cd
									--AND A.exht_tp_cd				= B.exht_tp_cd
							  )			
							--WHEN MATCHED AND  @v_active_flag = 'D' THEN
							--		DELETE
							WHEN MATCHED 
							--AND  @v_active_flag <> 'D'
							THEN
									 UPDATE SET 
												occr_rsn_ctn		= @v_occr_rsn_ctn
											   ,exht_tp_ctn			= @v_exht_tp_ctn 
											   ,qty					= @v_qty
											   ,last_updated_by		= @v_user_id
											   ,last_update_date	= sysdatetime()
											   ,occr_rsn_cd			= @v_occr_rsn_cd
											   ,exht_tp_cd			= @v_exht_tp_cd		
											   ,plan_tp_cd			= @v_plan_tp_cd
											   ,company_id			= @v_company_id
											   ,division_id			= @v_division_id
											   ,item_id				= @v_item_id
											   ,plan_yyyymmdd		= @v_plan_yyyymmdd
											   ,plant_id			= @v_plant_id
							WHEN NOT MATCHED THEN
								 INSERT ( request_no
										  ,plan_start_yyyymmdd
										  ,plan_tp_cd
										  ,company_id
										  ,division_id
										  ,plant_id
										  ,item_id
										  ,occr_rsn_cd
										  ,occr_rsn_ctn
										  ,exht_tp_cd
										  ,exht_tp_ctn
										  ,plan_yyyymmdd
										  ,qty
										  ,supplier_code
										  ,created_by
										  ,create_date
										  ,last_updated_by
										  ,last_update_date
										)
								 VALUES (   @v_request_no --@v_plan_start_yyyymmdd + '-' + CAST(ISNULL( (SELECT MAX(CAST(SUBSTRING(request_no, CHARINDEX('-', request_no) + 1, LEN(request_no)) AS INT))FROM [dbo].[SCP_ANL_LGTM_PCY_INV_MGMT_PLAN]), 0) + 1 AS NVARCHAR)
										   ,@v_plan_start_yyyymmdd
										   ,@v_plan_tp_cd
										   ,@v_division_id 
										   ,@v_company_id
										   ,@v_plant_id
										   ,@v_item_id
										   ,@v_occr_rsn_cd
										   ,@v_occr_rsn_ctn
										   ,@v_exht_tp_cd
										   ,@v_exht_tp_ctn
										   ,@v_plan_yyyymmdd
										   ,@v_qty
										   ,@v_supplier_code
										   ,@v_user_id
										   ,sysdatetime()
										   ,@v_user_id
										   ,sysdatetime()
										);
					  END
				



			ELSE    --단일 ROW 일때
			 
				BEGIN      
				print 1;
					SET @v_active_flag = @p_active_flag        
					SET @p_active_flag = NULL 

					SET @v_plan_start_yyyymmdd = @p_plan_start_yyyymmdd        
					SET @p_plan_start_yyyymmdd = NULL 				 

					SET @v_plan_tp_cd = @p_plan_tp_cd        
					SET @p_plan_tp_cd = NULL 			

					SET @v_company_id = @p_company_id
					SET @p_company_id = NULL
					
					SET @v_division_id = @p_division_id
					SET @p_division_id = NULL

					SET @v_division_id = @p_division_id        
					SET @p_division_id = NULL     

					SET @v_plant_id = @p_plant_id
					SET @p_plant_id = NULL
					
					SET @v_item_id = @p_item_id        
					SET @p_item_id = NULL    

					SET @v_occr_rsn_cd = @p_occr_rsn_cd		
					SET @p_occr_rsn_cd = NULL

					SET @v_occr_rsn_ctn = @p_occr_rsn_ctn 
					SET @p_occr_rsn_ctn = NULL

					SET @v_exht_tp_cd = @p_exht_tp_cd					
					SET @p_exht_tp_cd = NULL

					SET @v_exht_tp_ctn = @p_exht_tp_ctn 
					SET @p_exht_tp_ctn = NULL

					SET @v_plan_yyyymmdd = @p_plan_yyyymmdd
					SET @p_plan_yyyymmdd = NULL
															
					IF @p_qty <> 'NULL' AND @p_qty<> ''
						BEGIN
							SET @v_qty = CAST (@p_qty  AS numeric(30,8))
						END
					ELSE
						BEGIN
							SET @v_qty = 0
						END

					SET @v_supplier_code = @p_supplier_code
					SET @p_supplier_code = NULL

					SET @v_user_id = @p_user_id 
					SET @p_user_id = NULL

					SET @v_request_no = @p_request_no     
					IF @v_request_no = 'NULL' OR @v_request_no = ' ' OR len(@v_request_no) = 0
						BEGIN
							SET @v_request_no = @p_plan_start_yyyymmdd+'-'+ CAST( NEXT VALUE FOR SEQ1_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN AS NVARCHAR);							
						END
					SET @p_request_no = NULL 


							MERGE INTO [dbo].[SCP_ANL_LGTM_PCY_INV_MGMT_PLAN] A
							USING (
									SELECT 
										@v_request_no				as request_no,
										@v_plan_start_yyyymmdd		as plan_start_yyyymmdd
										--@v_plan_tp_cd				as plan_tp_cd,
										--@v_division_id				as division_id, 
										--@v_item_id					as item_id, 
										--@v_plan_yyyymmdd			as plan_yyyymmdd,
										--@v_plant_id					as plant_id,
										--@v_occr_rsn_cd 				as occr_rsn_cd,
										--@v_exht_tp_cd				as exht_tp_cd
							) B
							ON(
										A.request_no				= B.request_no
									AND	A.plan_start_yyyymmdd		= B.plan_start_yyyymmdd
									--AND A.plan_tp_cd				= B.plan_tp_cd
									--AND A.division_id				= B.division_id
									--AND A.item_id					= B.item_id
									--AND A.plan_yyyymmdd				= B.plan_yyyymmdd
									--AND A.plant_id					= B.plant_id
									--AND A.occr_rsn_cd				= B.occr_rsn_cd
									--AND A.exht_tp_cd				= B.exht_tp_cd
							  )			
							--WHEN MATCHED AND  @v_active_flag = 'D' THEN
							--		DELETE
							WHEN MATCHED --AND  @v_active_flag <> 'D' 
							THEN
									 UPDATE SET 
												occr_rsn_ctn		= @v_occr_rsn_ctn
											   ,exht_tp_ctn			= @v_exht_tp_ctn 
											   ,qty					= @v_qty
											   ,last_updated_by		= @v_user_id
											   ,last_update_date	= sysdatetime()
											   ,occr_rsn_cd			= @v_occr_rsn_cd
											   ,exht_tp_cd			= @v_exht_tp_cd		
											   ,plan_tp_cd			= @v_plan_tp_cd
											   ,company_id			= @v_company_id
											   ,division_id			= @v_division_id
											   ,item_id				= @v_item_id
											   ,plan_yyyymmdd		= @v_plan_yyyymmdd
											   ,plant_id			= @v_plant_id
							WHEN NOT MATCHED THEN
								 INSERT ( request_no
										  ,plan_start_yyyymmdd
										  ,plan_tp_cd
										  ,company_id
										  ,division_id
										  ,plant_id
										  ,item_id
										  ,occr_rsn_cd
										  ,occr_rsn_ctn
										  ,exht_tp_cd
										  ,exht_tp_ctn
										  ,plan_yyyymmdd
										  ,qty
										  ,supplier_code
										  ,created_by
										  ,create_date
										  ,last_updated_by
										  ,last_update_date
										)
								 VALUES (  --@v_request_no-- 
											@v_plan_start_yyyymmdd + '-' + CAST(ISNULL( (SELECT MAX(CAST(SUBSTRING(request_no, CHARINDEX('-', request_no) + 1, LEN(request_no)) AS INT))FROM [dbo].[SCP_ANL_LGTM_PCY_INV_MGMT_PLAN]), 0) + 1 AS NVARCHAR)
										   ,@v_plan_start_yyyymmdd
										   ,@v_plan_tp_cd
										   ,@v_company_id
										   ,@v_division_id 
										   ,@v_plant_id
										   ,@v_item_id
										   ,@v_occr_rsn_cd
										   ,@v_occr_rsn_ctn
										   ,@v_exht_tp_cd
										   ,@v_exht_tp_ctn
										   ,@v_plan_yyyymmdd
										   ,@v_qty
										   ,@v_supplier_code
										   ,@v_user_id
										   ,sysdatetime()
										   ,@v_user_id
										   ,sysdatetime()
										);
					  END
			END		

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			COMMIT TRAN;

			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code;

		END TRY

		BEGIN CATCH
		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;
		END CATCH;
	END;





