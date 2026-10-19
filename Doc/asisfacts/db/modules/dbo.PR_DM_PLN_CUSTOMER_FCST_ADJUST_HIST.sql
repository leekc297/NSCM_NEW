
/*
 * Program ID   : PR_DM_PLN_CUSTOMER_FCST_ADJUST_HIST
 * Description  : Customer FCST Adjust History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 12. 11    DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUSTOMER_FCST_ADJUST_HIST]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_plan_week			NVARCHAR(MAX),
	@p_customer_code		NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_measure_group		NVARCHAR(MAX),
	@p_measure				NVARCHAR(MAX),
	@p_valid_yn				NVARCHAR(MAX),
	@p_customer_psi			NVARCHAR(MAX),
	@p_upload_uom			NVARCHAR(MAX),
	@p_upload_bucket_type	NVARCHAR(MAX),
	@p_summary_bucket_type	NVARCHAR(MAX),
	@p_summary_bucket_value	NVARCHAR(MAX),
	@p_edi_fcst_yn			NVARCHAR(MAX),
	@p_ver_description		NVARCHAR(MAX),
	@p_ver_type				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
	--@p_success_yn			NVARCHAR(1) OUTPUT

AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_plan_week			NVARCHAR(MAX);
	DECLARE @v_customer_code		NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_measure_group		NVARCHAR(MAX);
	DECLARE @v_measure				NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_customer_psi			NVARCHAR(MAX);
	DECLARE @v_upload_uom			NVARCHAR(MAX);
	DECLARE @v_upload_bucket_type	NVARCHAR(MAX);
	DECLARE @v_summary_bucket_type	NVARCHAR(MAX);
	DECLARE @v_summary_bucket_value	NVARCHAR(MAX);
	DECLARE @v_edi_fcst_yn			NVARCHAR(MAX);
	DECLARE @v_ver_description		NVARCHAR(MAX);
	DECLARE @v_ver_type				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE	@v_ver_return_no		NVARCHAR(100);	-- cut off Generated Number	
	DECLARE @n_history_seq			INTEGER;

	-- recv init
	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_plan_week = NULL;
	SET @v_customer_code = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_measure_group = NULL;	 
	SET @v_measure = NULL;
	SET @v_valid_yn = NULL;	 
	SET @v_customer_psi = NULL;	 
	SET @v_upload_uom = NULL;	
	SET @v_upload_bucket_type = NULL;	
	SET @v_summary_bucket_type = NULL;	
	SET @v_summary_bucket_value = NULL;	
	SET @v_edi_fcst_yn = NULL;	  
	SET @v_ver_description = NULL;	  
	SET @v_ver_type = NULL;	  
	SET @v_created_by = NULL;
	
	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_CUSTOMER_FCST_ADJUST_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)


		-- 트랜잭션 (START)
		BEGIN TRANSACTION CUSTOMER_FCST_ADJUST_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
	

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		SELECT @max_loop_cnt;
		
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt


		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			SELECT @mst_loop_cnt,'@mst_loop_cnt'		


			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				SELECT @v_active_flag
					  
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				SELECT @v_division_id

				SET @v_plan_week = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week, @v_delimiter , @mst_loop_cnt) ; 
				SELECT @v_plan_week
	
				SET @v_customer_code = [dbo].[SCM_ARR_SPL_VAL](@p_customer_code, @v_delimiter , @mst_loop_cnt) ;    
				SELECT @v_customer_code

				SET @v_scm_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				SELECT @v_scm_site_id

				SET @v_measure = [dbo].[SCM_ARR_SPL_VAL](@p_measure, @v_delimiter , @mst_loop_cnt) ; 
				SELECT @v_measure

				SET @v_measure_group = [dbo].[SCM_ARR_SPL_VAL](@p_measure_group, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_measure_group

				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_valid_yn

				SET @v_customer_psi = [dbo].[SCM_ARR_SPL_VAL](@p_customer_psi, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_customer_psi

				SET @v_upload_uom = [dbo].[SCM_ARR_SPL_VAL](@p_upload_uom, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_upload_uom

				SET @v_upload_bucket_type = [dbo].[SCM_ARR_SPL_VAL](@p_upload_bucket_type, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_upload_bucket_type

				SET @v_summary_bucket_type = [dbo].[SCM_ARR_SPL_VAL](@p_summary_bucket_type, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_summary_bucket_type

				SET @v_summary_bucket_value = [dbo].[SCM_ARR_SPL_VAL](@p_summary_bucket_value, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_summary_bucket_value

				SET @v_edi_fcst_yn = [dbo].[SCM_ARR_SPL_VAL](@p_edi_fcst_yn, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_edi_fcst_yn
								
				SET @v_ver_description = [dbo].[SCM_ARR_SPL_VAL](@p_ver_description, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_ver_description

				SET @v_ver_type = [dbo].[SCM_ARR_SPL_VAL](@p_ver_type, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_ver_type

				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_created_by
						
			END


			--EXEC [dbo].[pr_dm_pln_mkt_fcst_hist]
			--													 @v_division_id
			--													,@v_project_code
			--													,@v_scm_site_id
			--													,@v_item_id
			--													,@v_dom_exp
			--													,@v_fcst_type
			--													,@v_incoterms
			--													,@v_measure
			--													,@v_yyyymmdd
			--													,@v_qty
			--													,@v_created_by

			--HISTORY INSERT

			--EXEC [dbo].[pr_dm_pln_mkt_fcst_hist]
			--													 @v_division_id
			--													,@v_project_code
			--													,@v_scm_site_id
			--													,@v_item_id
			--													,@v_dom_exp
			--													,@v_fcst_type
			--													,@v_incoterms
			--													,@v_measure
			--													,@v_yyyymmdd
			--													,@v_qty
			--													,@v_created_by
			--[dbo].[DM_MST_CUSTOMER_FCST_C]
			--[dbo].[DM_MST_CUSTOMER_FCST_H]
			--[dbo].[DM_MST_CUSTOMER_FCST]

			-- MASTER UPDATE	





			IF @mst_loop_cnt > 0 


			--[dbo].[DM_MST_CUSTOMER_FCST_C]
			--[dbo].[DM_MST_CUSTOMER_FCST_H]
			--[dbo].[DM_MST_CUSTOMER_FCST]

			-- CUT_OFF generating and INSERT
			BEGIN

				BEGIN	
							
					EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
					@v_division_id,
					@v_ver_description,
					@v_ver_type,
					@v_created_by,
					@v_ver_return_no  OUTPUT,
					@v_OK_description OUTPUT

					SELECT @v_ver_return_no; --Output;
					SELECT @v_OK_description;
			

					INSERT INTO  [dbo].[DM_MST_CUSTOMER_FCST_C]
					(  
							 division_id
							,version_no
							,cutoff_type
							,cutoff_date
							,plan_week
							,customer_code
							,scm_site_id
							,summary_bucket_value
							,measure_group
							,measure
							,valid_yn
							,customer_psi
							,upload_uom
							,upload_bucket_type
							,summary_bucket_type
							,edi_fcst_yn
							,upload_user_id
							,created_by
							,creation_date
							,last_updated_by
							,last_update_date
					)
					VALUES (   
							 @v_division_id
							,@v_ver_return_no
							,@v_ver_type
							,sysdatetime()
							,@v_plan_week
							,@v_customer_code
							,@v_scm_site_id
							,@v_summary_bucket_value
							,@v_measure_group
							,@v_measure
							,@v_valid_yn
							,@v_customer_psi
							,@v_upload_uom
							,@v_upload_bucket_type
							,@v_summary_bucket_type
							,@v_edi_fcst_yn
							,@v_created_by
							,@v_created_by
							,sysdatetime()
							,@v_created_by
							,sysdatetime()
						);

				END			

					
				BEGIN    
					SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_MST_CUSTOMER_FCST_H
					BEGIN
						
						--[2018-03-19][수정]
						--MERGE INTO [dbo].[DM_MST_CUSTOMER_FCST_H] A
						--USING (
						--		SELECT 
						--			@v_division_id			as division_id, 
						--			@v_plan_week			as plan_week,
						--			@v_customer_code		as customer_code,
						--			@v_scm_site_id			as scm_site_id,
						--			@v_summary_bucket_value	as summary_bucket_value,
						--			@v_measure_group		as measure_group 
						--	  ) B
						--ON(
						--			A.division_id			= B.division_id
						--		AND A.plan_week				= B.plan_week
						--		AND A.customer_code			= B.customer_code
						--		AND A.scm_site_id			= B.scm_site_id
						--		AND A.summary_bucket_value	= B.summary_bucket_value
						--		AND A.measure_group			= B.measure_group
						--)


						----WHEN MATCHED THEN
						--	--UPDATE SET
						--	--			 last_updated_by = @p_created_by
						--	--			,last_update_date = sysdatetime()
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--				 division_id
						--				,history_seq
						--				,plan_week
						--				,customer_code
						--				,scm_site_id
						--				,summary_bucket_value
						--				,measure_group
						--				,measure
						--				,valid_yn
						--				,customer_psi
						--				,upload_uom
						--				,upload_bucket_type
						--				,summary_bucket_type
						--				,edi_fcst_yn
						--				,upload_user_id
						--				,created_by
						--				,creation_date
						--				,last_updated_by
						--				,last_update_date
						--			  )
						--	VALUES  
						--			  (
						--				 @v_division_id 
						--				,@n_history_seq
						--				,@v_plan_week 
						--				,@v_customer_code
						--				,@v_scm_site_id
						--				,@v_summary_bucket_value
						--				,@v_measure_group
						--				,@v_measure
						--				,@v_valid_yn 
						--				,@v_customer_psi
						--				,@v_upload_uom
						--				,@v_upload_bucket_type
						--				,@v_summary_bucket_type
						--				,@v_edi_fcst_yn
						--				,@v_created_by
						--				,@v_created_by
						--				,sysdatetime()
						--				,@v_created_by
						--				,sysdatetime()
						--			  );

							INSERT	INTO  [dbo].[DM_MST_CUSTOMER_FCST_H]
							(									   
										 division_id
										,history_seq
										,plan_week
										,customer_code
										,scm_site_id
										,summary_bucket_value
										,measure_group
										,measure
										,valid_yn
										,customer_psi
										,upload_uom
										,upload_bucket_type
										,summary_bucket_type
										,edi_fcst_yn
										,upload_user_id
										,created_by
										,creation_date
										,last_updated_by
										,last_update_date
							)
							VALUES  
							(
										 @v_division_id 
										,@n_history_seq
										,@v_plan_week 
										,@v_customer_code
										,@v_scm_site_id
										,@v_summary_bucket_value
										,@v_measure_group
										,@v_measure
										,@v_valid_yn 
										,@v_customer_psi
										,@v_upload_uom
										,@v_upload_bucket_type
										,@v_summary_bucket_type
										,@v_edi_fcst_yn
										,@v_created_by
										,@v_created_by
										,sysdatetime()
										,@v_created_by
										,sysdatetime()
						   );
					END

				END


				BEGIN       

					-- recv init
			 
					MERGE INTO [dbo].[DM_MST_CUSTOMER_FCST] A
					USING (
								SELECT 
									@v_division_id			as division_id, 
									@v_plan_week			as plan_week,
									@v_customer_code		as customer_code,
									@v_scm_site_id			as scm_site_id,
									@v_summary_bucket_value	as summary_bucket_value,
									@v_measure_group		as measure_group 
							  ) B
						ON(
									A.division_id			= B.division_id
								AND A.plan_week				= B.plan_week
								AND A.customer_code			= B.customer_code
								AND A.scm_site_id			= B.scm_site_id
								AND A.summary_bucket_value	= B.summary_bucket_value
								AND A.measure_group			= B.measure_group
						)

					WHEN MATCHED THEN
						 UPDATE SET 
									 division_id			= @v_division_id
									,plan_week				= @v_plan_week
									,customer_code			= @v_customer_code
									,scm_site_id			= @v_scm_site_id 
									,summary_bucket_value	= @v_summary_bucket_value
									,measure_group			= @v_measure_group 
									,measure				= @v_measure
									,valid_yn				= @v_valid_yn
									,customer_psi			= @v_customer_psi
									,upload_uom				= @v_upload_uom
									,upload_bucket_type		= @v_upload_bucket_type
									,summary_bucket_type	= @v_summary_bucket_type
									,edi_fcst_yn			= @v_edi_fcst_yn		--CONVERT(INT,  CAST(@v_qty AS NVARCHAR(10)))
									,upload_user_id			= @v_created_by
									,last_updated_by		= @v_created_by
									,last_update_date		= sysdatetime()
					                
					WHEN NOT MATCHED THEN

						 INSERT (  
								     division_id
									,plan_week
									,customer_code
									,scm_site_id
									,summary_bucket_value
									,measure_group
									,measure
									,valid_yn
									,customer_psi
									,upload_uom
									,upload_bucket_type
									,summary_bucket_type
									,edi_fcst_yn
									,upload_user_id
									,created_by
									,creation_date
									,last_updated_by
									,last_update_date
								)
						 VALUES (   
									 @v_division_id
									,@v_plan_week
									,@v_customer_code
									,@v_scm_site_id
									,@v_summary_bucket_value
									,@v_measure_group
									,@v_measure
									,@v_valid_yn
									,@v_customer_psi
									,@v_upload_uom
									,@v_upload_bucket_type
									,@v_summary_bucket_type
									,@v_edi_fcst_yn
									,@v_created_by
									,@v_created_by
									,sysdatetime()
									,@v_created_by
									,sysdatetime()
								);

					END
			  
			END


			ELSE    --단일 ROW 일때
						 
				BEGIN       
		
			 
					SET @v_active_flag = @p_active_flag        
					SET @p_active_flag = NULL       
					SET @v_division_id = @p_division_id        
					SET @p_division_id = NULL      
					SET @v_plan_week = @p_plan_week        
					SET @p_plan_week = NULL  
					SET @v_customer_code = @p_customer_code        
					SET @p_customer_code = NULL    
					SET @v_scm_site_id = @p_scm_site_id        
					SET @p_scm_site_id = NULL  
					SET @v_summary_bucket_value = @p_summary_bucket_value        
					SET @p_summary_bucket_value = NULL  
					SET @v_measure_group = @p_measure_group       
					SET @p_measure_group = NULL  
					SET @v_measure = @p_measure        
					SET @p_measure = NULL  
					SET @v_valid_yn = @p_valid_yn        
					SET @p_valid_yn = NULL  
					SET @v_customer_psi = @p_customer_psi    
					SET @p_customer_psi = NULL  
					SET @v_upload_uom = @p_upload_uom      
					SET @p_upload_uom = NULL
					SET @v_upload_bucket_type = @p_upload_bucket_type        
					SET @p_upload_bucket_type = NULL  
					SET @v_summary_bucket_type = @p_summary_bucket_type       
					SET @p_summary_bucket_type = NULL  
					SET @v_edi_fcst_yn = @p_edi_fcst_yn       
					SET @p_edi_fcst_yn = NULL  
					SET @v_ver_description = @p_ver_description       
					SET @p_ver_description = NULL  
					SET @v_ver_type = @p_ver_type       
					SET @p_ver_type = NULL  
					SET @v_created_by = @p_created_by
					SET @p_created_by = NULL

			--[dbo].[DM_MST_CUSTOMER_FCST_C]
			--[dbo].[DM_MST_CUSTOMER_FCST_H]
			--[dbo].[DM_MST_CUSTOMER_FCST]



			-- CUT_OFF generating and INSERT

			BEGIN


				BEGIN			

				
					EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
					@v_division_id,
					@v_ver_description,
					@v_ver_type,
					@v_created_by,
					@v_ver_return_no  OUTPUT,
					@v_OK_description OUTPUT

					SELECT  @v_ver_return_no; --Output;
					SELECT @v_OK_description;
			
					INSERT INTO  [dbo].[DM_MST_CUSTOMER_FCST_C]
					(  
							 division_id
							,version_no
							,cutoff_type
							,cutoff_date
							,plan_week
							,customer_code
							,scm_site_id
							,summary_bucket_value
							,measure_group
							,measure
							,valid_yn
							,customer_psi
							,upload_uom
							,upload_bucket_type
							,summary_bucket_type
							,edi_fcst_yn
							,upload_user_id
							,created_by
							,creation_date
							,last_updated_by
							,last_update_date
					)
					VALUES (   
							 @v_division_id
							,@v_ver_return_no
							,@v_ver_type
							,sysdatetime()
							,@v_plan_week
							,@v_customer_code
							,@v_scm_site_id
							,@v_summary_bucket_value
							,@v_measure_group
							,@v_measure
							,@v_valid_yn
							,@v_customer_psi
							,@v_upload_uom
							,@v_upload_bucket_type
							,@v_summary_bucket_type
							,@v_edi_fcst_yn
							,@v_created_by
							,@v_created_by
							,sysdatetime()
							,@v_created_by
							,sysdatetime()
						);

				END			

					
				BEGIN    
					SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_MST_CUSTOMER_FCST_H
					BEGIN

						--[2018-03-19][수정]	
						--MERGE INTO [dbo].[DM_MST_CUSTOMER_FCST_H] A
						--USING (
						--		SELECT 
						--			@v_division_id			as division_id, 
						--			@v_plan_week			as plan_week,
						--			@v_customer_code		as customer_code,
						--			@v_scm_site_id			as scm_site_id,
						--			@v_summary_bucket_value	as summary_bucket_value,
						--			@v_measure_group		as measure_group 
						--	  ) B
						--ON(
						--			A.division_id			= B.division_id
						--		AND A.plan_week				= B.plan_week
						--		AND A.customer_code			= B.customer_code
						--		AND A.scm_site_id			= B.scm_site_id
						--		AND A.summary_bucket_value	= B.summary_bucket_value
						--		AND A.measure_group			= B.measure_group
						--)


						----WHEN MATCHED THEN
						--	--UPDATE SET
						--	--			 last_updated_by = @p_created_by
						--	--			,last_update_date = sysdatetime()
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--				 division_id
						--				,history_seq
						--				,plan_week
						--				,customer_code
						--				,scm_site_id
						--				,summary_bucket_value
						--				,measure_group
						--				,measure
						--				,valid_yn
						--				,customer_psi
						--				,upload_uom
						--				,upload_bucket_type
						--				,summary_bucket_type
						--				,edi_fcst_yn
						--				,upload_user_id
						--				,created_by
						--				,creation_date
						--				,last_updated_by
						--				,last_update_date
						--			  )
						--	VALUES  
						--			  (
						--				 @v_division_id 
						--				,@n_history_seq
						--				,@v_plan_week 
						--				,@v_customer_code
						--				,@v_scm_site_id
						--				,@v_summary_bucket_value
						--				,@v_measure_group
						--				,@v_measure
						--				,@v_valid_yn 
						--				,@v_customer_psi
						--				,@v_upload_uom
						--				,@v_upload_bucket_type
						--				,@v_summary_bucket_type
						--				,@v_edi_fcst_yn
						--				,@v_created_by
						--				,@v_created_by
						--				,sysdatetime()
						--				,@v_created_by
						--				,sysdatetime()
						--			  );

							INSERT	INTO  [dbo].[DM_MST_CUSTOMER_FCST_H]
							(									   
										 division_id
										,history_seq
										,plan_week
										,customer_code
										,scm_site_id
										,summary_bucket_value
										,measure_group
										,measure
										,valid_yn
										,customer_psi
										,upload_uom
										,upload_bucket_type
										,summary_bucket_type
										,edi_fcst_yn
										,upload_user_id
										,created_by
										,creation_date
										,last_updated_by
										,last_update_date
							)
							VALUES  
							(
										 @v_division_id 
										,@n_history_seq
										,@v_plan_week 
										,@v_customer_code
										,@v_scm_site_id
										,@v_summary_bucket_value
										,@v_measure_group
										,@v_measure
										,@v_valid_yn 
										,@v_customer_psi
										,@v_upload_uom
										,@v_upload_bucket_type
										,@v_summary_bucket_type
										,@v_edi_fcst_yn
										,@v_created_by
										,@v_created_by
										,sysdatetime()
										,@v_created_by
										,sysdatetime()
						   );
					END
				END


				BEGIN       

					-- recv init
			 
					MERGE INTO [dbo].[DM_MST_CUSTOMER_FCST] A
					USING (
								SELECT 
									@v_division_id			as division_id, 
									@v_plan_week			as plan_week,
									@v_customer_code		as customer_code,
									@v_scm_site_id			as scm_site_id,
									@v_summary_bucket_value	as summary_bucket_value,
									@v_measure_group		as measure_group 
							  ) B
						ON(
									A.division_id			= B.division_id
								AND A.plan_week				= B.plan_week
								AND A.customer_code			= B.customer_code
								AND A.scm_site_id			= B.scm_site_id
								AND A.summary_bucket_value	= B.summary_bucket_value
								AND A.measure_group			= B.measure_group
						)

					WHEN MATCHED THEN
						 UPDATE SET 
									 division_id			= @v_division_id
									,plan_week				= @v_plan_week
									,customer_code			= @v_customer_code
									,scm_site_id			= @v_scm_site_id 
									,summary_bucket_value	= @v_summary_bucket_value
									,measure_group			= @v_measure_group 
									,measure				= @v_measure
									,valid_yn				= @v_valid_yn
									,customer_psi			= @v_customer_psi
									,upload_uom				= @v_upload_uom
									,upload_bucket_type		= @v_upload_bucket_type
									,summary_bucket_type	= @v_summary_bucket_type
									,edi_fcst_yn			= @v_edi_fcst_yn		--CONVERT(INT,  CAST(@v_qty AS NVARCHAR(10)))
									,upload_user_id			= @v_created_by
									,last_updated_by		= @v_created_by
									,last_update_date		= sysdatetime()
					                
					WHEN NOT MATCHED THEN

						 INSERT (  
								     division_id
									,plan_week
									,customer_code
									,scm_site_id
									,summary_bucket_value
									,measure_group
									,measure
									,valid_yn
									,customer_psi
									,upload_uom
									,upload_bucket_type
									,summary_bucket_type
									,edi_fcst_yn
									,upload_user_id
									,created_by
									,creation_date
									,last_updated_by
									,last_update_date
								)
						 VALUES (   
									 @v_division_id
									,@v_plan_week
									,@v_customer_code
									,@v_scm_site_id
									,@v_summary_bucket_value
									,@v_measure_group
									,@v_measure
									,@v_valid_yn
									,@v_customer_psi
									,@v_upload_uom
									,@v_upload_bucket_type
									,@v_summary_bucket_type
									,@v_edi_fcst_yn
									,@v_created_by
									,@v_created_by
									,sysdatetime()
									,@v_created_by
									,sysdatetime()
								);

					END
				END

			END
		END


		COMMIT WORK ;	

		END TRY
		
	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  CUSTOMER_FCST_ADJUST_HIST;

	-- ERROR LOG
	SET @v_log_type = 'ERROR';
	SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
	SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
	SET @d_event_date = SYSDATETIME();
	SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	  
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












