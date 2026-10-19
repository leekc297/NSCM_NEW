
/*
 * Program ID   : SCM0010_SAVE_NOTICE_MASTER
 * Description  : NOTICE Master 저장(NOTICE_ID는 채번으로 저장)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/22   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[SCM0010_SAVE_NOTICE_MASTER]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_module 				NVARCHAR(MAX),
	@p_submodule 			NVARCHAR(MAX),
	@p_notice_id			NVARCHAR(MAX),
    @p_notice_desc 			NVARCHAR(MAX),
	@p_cycle_class_code 	NVARCHAR(MAX),
	@p_detail_class_code	NVARCHAR(MAX),
	@p_send_time_text		NVARCHAR(MAX),
    @p_active			    NVARCHAR(MAX),
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
	DECLARE @v_use_type				NVARCHAR(MAX);
	DECLARE @v_module			    NVARCHAR(MAX);
	DECLARE @v_submodule			NVARCHAR(MAX);
	DECLARE @v_notice_id			NVARCHAR(MAX);
	DECLARE @v_notice_desc			NVARCHAR(MAX);
	DECLARE @v_cycle_class_code		NVARCHAR(MAX);
	DECLARE @v_detail_class_code	NVARCHAR(MAX);
	DECLARE @v_send_time_text		NVARCHAR(MAX);
	DECLARE @v_active				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
    DECLARE @v_creation_date		NVARCHAR(MAX);
    DECLARE @v_last_updated_by      NVARCHAR(MAX); 
	DECLARE @V_sql_long_text		NVARCHAR(MAX); 
		
	SET @v_active_flag = NULL;
	SET @v_use_type = NULL;
	SET @v_module = NULL;
	SET @v_submodule = NULL;
	SET @v_notice_id = NULL;
	SET @v_notice_desc = NULL;	 
	SET @v_cycle_class_code = NULL;	 
	SET @v_detail_class_code = NULL;	 
	SET @v_send_time_text = NULL;	
	SET @v_active = NULL;
	SET @v_created_by		= NULL;
    SET @v_creation_date    = NULL;
    SET @v_last_updated_by  = NULL; 
	SET @V_sql_long_text	= NULL;


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0010_SAVE_NOTICE_MASTER';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @n_history_seq	INTEGER;

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
				SET @v_module = [dbo].[SCM_ARR_SPL_VAL](@p_module, @v_delimiter , @mst_loop_cnt) ;    				
				SET @v_submodule = [dbo].[SCM_ARR_SPL_VAL](@p_submodule, @v_delimiter , @mst_loop_cnt) ;    				
				SET @v_notice_id = [dbo].[SCM_ARR_SPL_VAL](@p_notice_id, @v_delimiter , @mst_loop_cnt) ; 				
				SET @v_notice_desc = [dbo].[SCM_ARR_SPL_VAL](@p_notice_desc, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_cycle_class_code = [dbo].[SCM_ARR_SPL_VAL](@p_cycle_class_code, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_detail_class_code = [dbo].[SCM_ARR_SPL_VAL](@p_detail_class_code, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_send_time_text = [dbo].[SCM_ARR_SPL_VAL](@p_send_time_text, @v_delimiter, @mst_loop_cnt) ; 	
				SET @v_active = [dbo].[SCM_ARR_SPL_VAL](@p_active, @v_delimiter, @mst_loop_cnt) ; 	
				SET @v_created_by        = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter , @mst_loop_cnt) ; 
			    SET @v_creation_date     = [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter , @mst_loop_cnt) ; 
                SET @v_last_updated_by   = [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter , @mst_loop_cnt) ; 
					
			END
			
			IF (ISNULL(@v_notice_id,'') = '')
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_ADM_NOTICE_MASTER
			ELSE
				SET @n_history_seq = @v_notice_id

			--HISTORY INSERT
			EXEC [PR_SCM_ADM_NOTICE_MASTER_HIST]
								 @v_module 
								,@v_submodule
								,@v_notice_id
								,@v_notice_desc
								,@v_cycle_class_code 
								,@v_detail_class_code 
								,@v_send_time_text 
								,@v_active
								,@V_sql_long_text
								,@v_created_by
								,@v_creation_date
								,@v_last_updated_by										
																
			 ;
			
			IF @mst_loop_cnt > 0 				
				IF @v_active_flag != 'D'
					BEGIN
						BEGIN       
			 
							MERGE INTO [SCM_ADM_NOTICE_MASTER] A
							USING (
									SELECT 
										 @n_history_seq as notice_id	
										,@v_module as module_code
										,@v_submodule as sub_module_code						
								  ) B
							ON(
										A.notice_id = B.notice_id
									AND A.module_code = B.module_code
									AND A.sub_module_code = B.sub_module_code						
							  )
							WHEN MATCHED THEN
								 UPDATE SET 
										notice_title		= @v_notice_desc
									   ,cycle_class_code	= @v_cycle_class_code
									   ,detail_class_code	= @v_detail_class_code
									   ,send_time_text		= @v_send_time_text
									   ,valid_yn			= @v_active
									   ,last_updated_by		= @v_last_updated_by
									   ,last_update_date	= sysdatetime()
					                
							WHEN NOT MATCHED THEN

								INSERT	(									   
										 notice_id,sub_module_code,module_code
										,notice_title,cycle_class_code,detail_class_code,send_time_text,valid_yn
										,created_by,creation_date,last_updated_by,last_update_date
										)
								VALUES  
										(
										 @n_history_seq , @v_submodule, @v_module
										,@v_notice_desc ,@v_cycle_class_code ,@v_detail_class_code ,@v_send_time_text ,@v_active
										,@v_created_by,SYSDATETIME(),@v_last_updated_by,SYSDATETIME()
										);
			
						END
					END
				ELSE IF @v_active_flag = 'D'
					BEGIN
						DELETE FROM SCM_ADM_NOTICE_MASTER
						WHERE module_code = @v_module
						  AND sub_module_code = @v_submodule
						  AND notice_id = @n_history_seq;

						/*해당 notice_ID로 등록되어 있는 메세지를 같이 삭제한다.*/
						DELETE FROM [dbo].[SCM_ADM_NOTICE_CONTENT_MASTER]
						WHERE notice_id = @n_history_seq;
					END
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







