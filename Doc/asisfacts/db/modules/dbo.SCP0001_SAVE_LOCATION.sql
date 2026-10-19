/*
 * Program ID   : SCP0001_SAVE_LOCATION
 * Description  : LOCATION 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/07   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022/07/25   leejeongil     ERP 재고표기를 위한 SSP Storage 속성 추가 @p_ssp_storage_id 
 *
 */
CREATE PROCEDURE [dbo].[SCP0001_SAVE_LOCATION]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_location_seq			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_scm_site_id 			NVARCHAR(MAX),
	@p_plant_id 			NVARCHAR(MAX),
	@p_location_code		NVARCHAR(MAX),
	@p_location_description	NVARCHAR(MAX),
	@p_factory_id			NVARCHAR(MAX),
	@p_operation_id			NVARCHAR(MAX),
	@p_electrode_type		NVARCHAR(MAX),
	@p_storage_id			NVARCHAR(MAX),
	@p_ssp_storage_id		NVARCHAR(MAX),
	@p_valid_yn			    NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX),
	@p_creation_date		NVARCHAR(MAX),
	@p_last_updated_by		NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_location_seq			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_scm_site_id 			NVARCHAR(MAX);
	DECLARE @v_plant_id 			NVARCHAR(MAX);
	DECLARE @v_location_code		NVARCHAR(MAX);
	DECLARE @v_location_description	NVARCHAR(MAX);
	DECLARE @v_factory_id			NVARCHAR(MAX);
	DECLARE @v_operation_id			NVARCHAR(MAX);
	DECLARE @v_electrode_type		NVARCHAR(MAX);
	DECLARE @v_storage_id			NVARCHAR(MAX);
	DECLARE @v_ssp_storage_id		NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @v_creation_date		DATETIME;
	DECLARE @v_last_updated_by		NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_location_seq = NULL;
	SET @v_division_id = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_plant_id = NULL;
	SET @v_location_code = NULL;
	SET @v_location_description = NULL;
	SET @v_factory_id = NULL;	 
	SET @v_operation_id = NULL;	 
	SET @v_electrode_type = NULL;	 
	SET @v_storage_id = NULL;
	SET @v_ssp_storage_id = NULL;
	SET @v_valid_yn = NULL;	
	SET @v_created_by = NULL;	  
	SET @v_creation_date = NULL;
	SET @v_last_updated_by = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0001_SAVE_LOCATION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

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
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
			 
			 

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_scm_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_location_code = [dbo].[SCM_ARR_SPL_VAL](@p_location_code, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_location_description = [dbo].[SCM_ARR_SPL_VAL](@p_location_description, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_factory_id = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_operation_id = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_electrode_type = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_storage_id = [dbo].[SCM_ARR_SPL_VAL](@p_storage_id, @v_delimiter, @mst_loop_cnt) ;
				SET @v_ssp_storage_id = [dbo].[SCM_ARR_SPL_VAL](@p_ssp_storage_id, @v_delimiter, @mst_loop_cnt) ;
				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter, @mst_loop_cnt) ; 	
				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_creation_date = CONVERT(DATETIME, [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter, @mst_loop_cnt) , 120);
				SET @v_last_updated_by = [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_location_seq = [dbo].[SCM_ARR_SPL_VAL](@p_location_seq, @v_delimiter , @mst_loop_cnt) ;  
			END

			IF ( @v_location_seq = null or isnull(@v_location_seq,'') ='' )
			    SET @v_location_seq = NEXT VALUE FOR SEQ1_SCM_MST_LOCATION;
		   --HISTORY INSERT
		   
			EXEC [PR_SCM_MST_LOCATION_HIST]
										 @v_location_seq
										,@v_division_id
										,@v_location_code
										,@v_location_description
										,@v_scm_site_id
										,@v_plant_id
										,@v_factory_id
										,@v_operation_id
										,@v_storage_id
										,@v_ssp_storage_id
										,@v_electrode_type
										,@v_valid_yn
										,@v_created_by
										,@v_creation_date
										,@v_last_updated_by
															
			 ;
			
			IF @mst_loop_cnt > 0 
			
			BEGIN
		
			MERGE INTO [SCM_MST_LOCATION] A
			USING (
					SELECT 
						    @v_location_seq as location_seq		
					) B
			ON(
						A.location_seq = B.location_seq
				)
			WHEN MATCHED THEN
					UPDATE SET 
					     location_code = @v_location_code
 						,location_description = @v_location_description
						,scm_site_id          = @v_scm_site_id
						,plant_id             = @v_plant_id
						,factory_id           = @v_factory_id
						,operation_id	      = @v_operation_id
						,storage_id	          = @v_storage_id
						,attribute2           = @v_ssp_storage_id
						,valid_yn			  = @v_valid_yn
						,electrode_type	      = @v_electrode_type
						,last_updated_by	  = @v_last_updated_by
						,last_update_date	  = sysdatetime()
					                
			WHEN NOT MATCHED THEN
			INSERT	(		
						 location_seq, division_id, location_code,
						 location_description, scm_site_id, plant_id,
						 factory_id, operation_id, storage_id, electrode_type, valid_yn,
						 created_by, creation_date, last_updated_by, last_update_date,
						 attribute2
					)
			VALUES  (
					 	@v_location_seq ,@v_division_id, @v_location_code, 
						@v_location_description ,@v_scm_site_id ,@v_plant_id,
						@v_factory_id, @v_operation_id, @v_storage_id, @v_electrode_type, @v_valid_yn,
					    @v_created_by, SYSDATETIME(), @v_created_by, SYSDATETIME(),
						@v_ssp_storage_id
					);
	
			END
			--ELSE -- 단일 row
			 
			--BEGIN   

			-- IF ( @v_location_seq = null or @v_location_seq ='' )
			--    SET @v_location_seq = NEXT VALUE FOR SEQ1_SCM_MST_LOCATION;
   --          ELSE
			--    SET @v_location_seq = @p_location_seq;
			--	SET @p_location_seq = NULL;

			--	SET @v_active_flag = @p_active_flag        
			--	SET @p_active_flag = NULL       
			--	SET @v_division_id = @p_division_id        
			--	SET @p_division_id = NULL      
			--	SET @v_plant_id = @p_plant_id        
			--	SET @p_plant_id = NULL    
			--	SET @v_scm_site_id = @p_scm_site_id        
			--	SET @p_scm_site_id = NULL  
			--	SET @v_location_code = @p_location_code        
			--	SET @p_location_code = NULL  
			--	SET @v_location_description = @p_location_description        
			--	SET @p_location_description = NULL  
			--	SET @v_factory_id = @p_factory_id        
			--	SET @p_factory_id = NULL  
			--	SET @v_operation_id = @p_operation_id        
			--	SET @p_operation_id = NULL  
			--	SET @v_electrode_type = @p_electrode_type        
			--	SET @p_electrode_type = NULL  
			--	SET @v_storage_id = @p_storage_id        
			--	SET @p_storage_id = NULL  
			--	SET @v_created_by = @p_created_by
			--	SET @p_created_by = NULL
			--	SET @v_creation_date = @p_creation_date
			--	SET @p_creation_date = NULL					
			--	SET @v_last_updated_by = @p_last_updated_by
			--	SET @p_last_updated_by = NULL
						
			--	MERGE INTO [SCM_MST_LOCATION] A
			--	USING (
			--			SELECT 
			--				 @v_location_seq as location_seq
			--				--	@v_location_code as location_code
			--				--	@v_division_id as division_id					
			--			) B
			--	ON(
			--				 A.location_seq = B.location_seq
			--			--	A.location_code  = B.location_code
			--			--AND A.division_id  = B.division_id
						
			--		)
			--	WHEN MATCHED THEN
			--			UPDATE SET 
 		--				 location_description = @v_location_description
			--			,scm_site_id          = @v_scm_site_id
			--			,plant_id             = @v_plant_id
			--			,factory_id           = @v_factory_id
			--			,operation_id	      = @v_operation_id
			--			,storage_id	          = @v_storage_id
			--			,electrode_type	      = @v_electrode_type
			--			,last_updated_by	  = @v_last_updated_by
			--			,last_update_date	  = sysdatetime()
					                
			--	WHEN NOT MATCHED THEN

			--	INSERT	(		
			--				 location_seq, division_id, location_code,
			--				 location_description, scm_site_id, plant_id,
			--				 factory_id, operation_id, storage_id, electrode_type,
			--				 created_by, creation_date, last_updated_by, last_update_date
			--			)
			--	VALUES  (
			--		 		@v_location_seq ,@v_division_id, @v_location_code, 
			--				@v_location_description ,@v_scm_site_id ,@v_plant_id,
			--				@v_factory_id, @v_operation_id, @v_storage_id, @v_electrode_type
			--			   ,@v_created_by, SYSDATETIME(), @v_created_by, SYSDATETIME()
			--			);

			--	END	
			END

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;
		
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

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END






