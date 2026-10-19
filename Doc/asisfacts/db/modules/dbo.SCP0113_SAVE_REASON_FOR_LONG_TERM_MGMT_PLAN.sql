/*
 * Program ID   : [SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN]
 * Description  : Save the reason for long term management plan
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/9/13    Haru			Adding new function for saving the reason for long term inventory 
 * 2024/10/23   TanVQ1			Update Logic allow save data without qty value
 * 2024/11/29   TanVQ1			New Field impu_dept_nm
 */

CREATE PROCEDURE [dbo].[SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN] 

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_plan_start_yyyymmdd	NVARCHAR(MAX),
	@p_plan_tp_cd			NVARCHAR(MAX),
	@p_data_tp_cd			NVARCHAR(MAX),
	@p_srce_tp_cd			NVARCHAR(MAX),
	@p_company_id			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_plant_id				NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_occr_rsn_cd			NVARCHAR(MAX),
	@p_occr_rsn_ctn			NVARCHAR(MAX),
	@p_exht_tp_cd			NVARCHAR(MAX),
	@p_exht_tp_ctn			NVARCHAR(MAX),
	@p_plan_yyyymm			NVARCHAR(MAX),
	@p_qty					NVARCHAR(MAX),
	@p_impu_dept_nm			NVARCHAR(MAX),
	@p_user_id				NVARCHAR(MAX)
AS

BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag			NVARCHAR(MAX);
	DECLARE @recv_plan_start_yyyymmdd	NVARCHAR(MAX);
	DECLARE @recv_plan_tp_cd			NVARCHAR(MAX);
	DECLARE @recv_data_tp_cd			NVARCHAR(MAX);
	DECLARE @recv_srce_tp_cd			NVARCHAR(MAX);
	DECLARE @recv_company_id			NVARCHAR(MAX);
	DECLARE @recv_division_id			NVARCHAR(MAX);
	DECLARE @recv_plant_id				NVARCHAR(MAX);
	DECLARE @recv_item_id				NVARCHAR(MAX);
	DECLARE @recv_occr_rsn_cd			NVARCHAR(MAX);
	DECLARE @recv_occr_rsn_ctn			NVARCHAR(MAX);
	DECLARE @recv_exht_tp_cd			NVARCHAR(MAX);
	DECLARE @recv_exht_tp_ctn			NVARCHAR(MAX);
	DECLARE @recv_plan_yyyymm			NVARCHAR(MAX);
	DECLARE @recv_qty					NVARCHAR(MAX);
	DECLARE @recv_impu_dept_nm			NVARCHAR(MAX);
	DECLARE @recv_user_id				NVARCHAR(MAX);

	SET @recv_active_flag = NULL;
	SET @recv_plan_start_yyyymmdd = NULL;
	SET @recv_plan_tp_cd = NULL;
	SET @recv_data_tp_cd = NULL;
	SET @recv_srce_tp_cd = NULL;
	SET @recv_company_id = NULL;
	SET @recv_division_id = NULL;
	SET @recv_plant_id = NULL;
	SET @recv_item_id = NULL;
	SET @recv_occr_rsn_cd = NULL;	 
	SET @recv_occr_rsn_ctn = NULL;	
	SET @recv_exht_tp_cd = NULL;	
	SET @recv_exht_tp_ctn = NULL;	
	SET @recv_plan_yyyymm = NULL;	
	SET @recv_qty = NULL;	
	SET @recv_impu_dept_nm = NULL;	
	SET @recv_user_id = NULL;
		
	SET @recv_active_flag = @p_active_flag;
	SET @recv_plan_start_yyyymmdd = @p_plan_start_yyyymmdd;
	SET @recv_plan_tp_cd = @p_plan_tp_cd;
	SET @recv_data_tp_cd = @p_data_tp_cd;
	SET @recv_srce_tp_cd = @p_srce_tp_cd;
	SET @recv_company_id = @p_company_id;
	SET @recv_division_id = @p_division_id;
	SET @recv_plant_id = @p_plant_id;
	SET @recv_item_id = @p_item_id;
	SET @recv_occr_rsn_cd = @p_occr_rsn_cd;	 
	SET @recv_occr_rsn_ctn = @p_occr_rsn_ctn;	
	SET @recv_exht_tp_cd = @p_exht_tp_cd;	
	SET @recv_exht_tp_ctn = @p_exht_tp_ctn;	
	SET @recv_plan_yyyymm = @p_plan_yyyymm;	
	SET @recv_qty = @p_qty;	
	SET @recv_impu_dept_nm = @p_impu_dept_nm;	
	SET @recv_user_id = @p_user_id;	
	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(MAX);
	DECLARE @v_plan_tp_cd			NVARCHAR(MAX);
	DECLARE @v_data_tp_cd			NVARCHAR(MAX);
	DECLARE @v_srce_tp_cd			NVARCHAR(MAX);
	DECLARE @v_company_id			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_plant_id				NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_occr_rsn_cd			NVARCHAR(MAX);
	DECLARE @v_occr_rsn_ctn			NVARCHAR(MAX);
	DECLARE @v_exht_tp_cd			NVARCHAR(MAX);
	DECLARE @v_exht_tp_ctn			NVARCHAR(MAX);
	DECLARE @v_plan_yyyymm			NVARCHAR(MAX);
	DECLARE @v_qty					numeric(30,8);
	DECLARE @v_user_id				NVARCHAR(MAX);
	DECLARE @v_impu_dept_nm			NVARCHAR(MAX);
	DECLARE @v_qty_item				NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_plan_start_yyyymmdd = NULL;
	SET @v_plan_tp_cd = NULL;


	SET @v_division_id = NULL;

	SET @v_item_id = NULL;
	SET @v_occr_rsn_cd = NULL;	 
	SET @v_occr_rsn_ctn = NULL;	
	SET @v_exht_tp_cd = NULL;	
	SET @v_exht_tp_ctn = NULL;	
	SET @v_plan_yyyymm = NULL;	 

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '|'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN';
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
		SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				
				SET @v_plan_start_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_plan_start_yyyymmdd, @v_delimiter , @mst_loop_cnt) ;    
				
				SET @v_plan_tp_cd = [dbo].[SCM_ARR_SPL_VAL](@p_plan_tp_cd, @v_delimiter , @mst_loop_cnt) ; 
				
				SET @v_data_tp_cd = [dbo].[SCM_ARR_SPL_VAL](@p_data_tp_cd, @v_delimiter , @mst_loop_cnt) ;    

				SET @v_srce_tp_cd = [dbo].[SCM_ARR_SPL_VAL](@p_srce_tp_cd, @v_delimiter , @mst_loop_cnt) ;    
				
				SET @v_company_id = [dbo].[SCM_ARR_SPL_VAL](@p_company_id, @v_delimiter , @mst_loop_cnt) ; 

				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 

				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ; 
				
				SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;    
				
				SET @v_occr_rsn_cd = [dbo].[SCM_ARR_SPL_VAL](@p_occr_rsn_cd, @v_delimiter , @mst_loop_cnt);
				
				SET @v_occr_rsn_ctn = [dbo].[SCM_ARR_SPL_VAL](@p_occr_rsn_ctn, @v_delimiter , @mst_loop_cnt) ;  

				SET @v_exht_tp_cd = [dbo].[SCM_ARR_SPL_VAL](@p_exht_tp_cd, @v_delimiter , @mst_loop_cnt);
				
				SET @v_exht_tp_ctn = [dbo].[SCM_ARR_SPL_VAL](@p_exht_tp_ctn, @v_delimiter, @mst_loop_cnt) ; 
				
				SET @v_plan_yyyymm = [dbo].[SCM_ARR_SPL_VAL](@p_plan_yyyymm, @v_delimiter, @mst_loop_cnt) ; 
				
				SET @v_qty_item	 = [dbo].[SCM_ARR_SPL_VAL](@p_qty, @v_delimiter, @mst_loop_cnt)
				IF  @v_qty_item	<> 'NULL' AND @v_qty_item	<> ''
					BEGIN
						SET @v_qty = CAST (@v_qty_item  AS numeric(30,8) ); 						
					END
				ELSE
					BEGIN
						SET @v_qty = null						
					END

				SET @v_impu_dept_nm = [dbo].[SCM_ARR_SPL_VAL](@p_impu_dept_nm, @v_delimiter, @mst_loop_cnt) ; 
				
				SET @v_user_id = [dbo].[SCM_ARR_SPL_VAL](@p_user_id, @v_delimiter, @mst_loop_cnt) ; 
				
						
			END
			
			IF @mst_loop_cnt > 0 
				BEGIN 		
					MERGE INTO [dbo].[SCP_ANL_LGTM_INV_MGMT_PLAN] A
					USING (
							SELECT 
								@v_plan_start_yyyymmdd		as plan_start_yyyymmdd,
								@v_plan_tp_cd				as plan_tp_cd,
								@v_division_id				as division_id, 
								@v_item_id					as item_id, 
								@v_plan_yyyymm				as plan_yyyymm,
								@v_data_tp_cd				as data_tp_cd,
								@v_srce_tp_cd				as srce_tp_cd,
								@v_plant_id					as plant_id,
								@v_company_id				as company_id
						  ) B
					ON(
							    A.plan_start_yyyymmdd		= B.plan_start_yyyymmdd
							AND A.plan_tp_cd				= B.plan_tp_cd
							AND A.division_id				= B.division_id
							AND A.item_id					= B.item_id
							AND A.plan_yyyymm				= B.plan_yyyymm
							AND A.data_tp_cd				= B.data_tp_cd
							AND A.srce_tp_cd				= B.srce_tp_cd
							AND A.plant_id					= B.plant_id
							AND A.company_id				= B.company_id
					  )			
					WHEN MATCHED AND (/*@v_qty = 0  OR */(@v_occr_rsn_cd = 'NULL' AND  @v_exht_tp_cd = 'NULL')) THEN	
							 DELETE
					WHEN MATCHED AND /*@v_qty <> 0  AND */ (@v_occr_rsn_cd <> 'NULL' AND  @v_exht_tp_cd <> 'NULL')THEN	
							 UPDATE SET 
										occr_rsn_ctn		= @v_occr_rsn_ctn
									   ,exht_tp_ctn			= @v_exht_tp_ctn 
									   ,qty					= @v_qty
									   ,last_updated_by		= @v_user_id
									   ,last_update_date	= sysdatetime()
									   ,occr_rsn_cd			= @v_occr_rsn_cd
									   ,exht_tp_cd			= @v_exht_tp_cd		
									   ,impu_dept_nm			= @v_impu_dept_nm
					WHEN NOT MATCHED AND @v_occr_rsn_cd <> 'NULL' AND  @v_exht_tp_cd <> 'NULL' /*AND @v_qty <> 0*/
					THEN  

						 INSERT ( plan_start_yyyymmdd
								  ,plan_tp_cd
								  ,data_tp_cd
								  ,srce_tp_cd
								  ,division_id
								  ,plant_id
								  ,item_id
								  ,occr_rsn_cd
								  ,occr_rsn_ctn
								  ,exht_tp_cd
								  ,exht_tp_ctn
								  ,plan_yyyymm
								  ,qty
								  ,created_by
								  ,create_date
								  ,last_updated_by
								  ,last_update_date
								  ,impu_dept_nm
								  ,company_id
								)
						 VALUES (   @v_plan_start_yyyymmdd
								   ,@v_plan_tp_cd
								   ,@v_data_tp_cd
								   ,@v_srce_tp_cd
								   ,@v_division_id 
								   ,@v_plant_id
								   ,@v_item_id
								   ,@v_occr_rsn_cd
								   ,@v_occr_rsn_ctn
								   ,@v_exht_tp_cd
								   ,@v_exht_tp_ctn
								   ,@v_plan_yyyymm
								   ,@v_qty
								   ,@v_user_id
								   ,sysdatetime()
								   ,@v_user_id
								   ,sysdatetime()
								   ,@v_impu_dept_nm
								   ,@v_company_id

								);
			  END



			ELSE    --단일 ROW 일때
			 
				BEGIN        
					SET @v_active_flag = @p_active_flag        
					SET @p_active_flag = NULL 

					SET @v_plan_start_yyyymmdd = @p_plan_start_yyyymmdd        
					SET @p_plan_start_yyyymmdd = NULL 				 

					SET @v_plan_tp_cd = @p_plan_tp_cd        
					SET @p_plan_tp_cd = NULL 					
				
					SET @v_data_tp_cd = @p_data_tp_cd   
					SET @p_data_tp_cd = NULL 

					SET @v_srce_tp_cd = @p_srce_tp_cd  
					SET @p_srce_tp_cd = NULL
				
					SET @v_company_id = @p_company_id
					SET @p_company_id = NULL

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

					SET @v_plan_yyyymm = @p_plan_yyyymm 
					SET @p_plan_yyyymm = NULL
															
					IF @p_qty <> 'NULL' AND @p_qty<> ''
						BEGIN
							SET @v_qty = CAST (@p_qty  AS numeric(30,8))
						END
					ELSE
						BEGIN
							SET @v_qty = 0
						END

					SET @v_impu_dept_nm = @p_impu_dept_nm
					SET @p_impu_dept_nm = NULL

					SET @v_user_id = @p_user_id 
					SET @p_user_id = NULL
					
					MERGE INTO [dbo].[SCP_ANL_LGTM_INV_MGMT_PLAN] A
					USING (
							SELECT 
								@v_plan_start_yyyymmdd		as plan_start_yyyymmdd,
								@v_plan_tp_cd				as plan_tp_cd,
								@v_division_id				as division_id, 
								@v_item_id					as item_id, 
								@v_plan_yyyymm				as plan_yyyymm,
								@v_data_tp_cd				as data_tp_cd,
								@v_srce_tp_cd				as srce_tp_cd,
								@v_plant_id					as plant_id,
								@v_company_id				as company_id
						  ) B
					ON(
							    A.plan_start_yyyymmdd		= B.plan_start_yyyymmdd
							AND A.plan_tp_cd				= B.plan_tp_cd
							AND A.division_id				= B.division_id
							AND A.item_id					= B.item_id
							AND A.plan_yyyymm				= B.plan_yyyymm
							AND A.data_tp_cd				= B.data_tp_cd
							AND A.srce_tp_cd				= B.srce_tp_cd
							AND A.plant_id					= B.plant_id
							AND A.company_id				= B.company_id
					  )	
					WHEN MATCHED AND (/*@v_qty = 0  OR */(@v_occr_rsn_cd = 'NULL' AND  @v_exht_tp_cd = 'NULL')) THEN	
							DELETE
					WHEN MATCHED AND /*@v_qty <> 0  AND*/ (@v_occr_rsn_cd <> 'NULL' AND  @v_exht_tp_cd <> 'NULL') THEN
						 UPDATE SET 
									occr_rsn_ctn		= @v_occr_rsn_ctn
								   ,exht_tp_ctn			= @v_exht_tp_ctn 
								   ,qty					= @v_qty
								   ,last_updated_by		= @v_user_id
								   ,last_update_date	= sysdatetime()
								   ,occr_rsn_cd			= @v_occr_rsn_cd
								   ,exht_tp_cd			= @v_exht_tp_cd								   
								  ,impu_dept_nm			= @v_impu_dept_nm
					    
					WHEN NOT MATCHED AND 
						( /*(@v_occr_rsn_cd <> 'NULL' AND  @v_exht_tp_cd <> 'NULL' AND @v_qty <> 0) OR */ 
						  (@v_occr_rsn_cd <> 'NULL' AND  @v_exht_tp_cd <> 'NULL'))
					THEN  

						INSERT ( plan_start_yyyymmdd
								  ,plan_tp_cd
								  ,data_tp_cd
								  ,srce_tp_cd
								  ,division_id
								  ,plant_id
								  ,item_id
								  ,occr_rsn_cd
								  ,occr_rsn_ctn
								  ,exht_tp_cd
								  ,exht_tp_ctn
								  ,plan_yyyymm
								  ,qty
								  ,created_by
								  ,create_date
								  ,last_updated_by
								  ,last_update_date
								  ,impu_dept_nm
								  ,company_id
								)
						 VALUES (   @v_plan_start_yyyymmdd
								   ,@v_plan_tp_cd
								   ,@v_data_tp_cd
								   ,@v_srce_tp_cd
								   ,@v_division_id 
								   ,@v_plant_id
								   ,@v_item_id
								   ,@v_occr_rsn_cd
								   ,@v_occr_rsn_ctn
								   ,@v_exht_tp_cd
								   ,@v_exht_tp_ctn
								   ,@v_plan_yyyymm
								   ,@v_qty
								   ,@v_user_id
								   ,sysdatetime()
								   ,@v_user_id
								   ,sysdatetime()
								   ,@v_impu_dept_nm
								   ,@v_company_id
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





