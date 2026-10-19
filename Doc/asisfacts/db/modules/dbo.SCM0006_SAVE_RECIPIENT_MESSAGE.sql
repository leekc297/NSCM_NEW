/*
 * Program ID   : SCM0006_SAVE_RECIPIENT_MESSAGE
 * Description  : SMS/MAIL별 Category_ID별 메세지 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/20   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[SCM0006_SAVE_RECIPIENT_MESSAGE]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_use_type				NVARCHAR(MAX),
	@p_category_id			NVARCHAR(MAX),
	@p_language 			NVARCHAR(MAX),
	@p_title 				NVARCHAR(MAX),
    @p_content 				NVARCHAR(MAX),
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
	DECLARE @v_category_id			NVARCHAR(MAX);
	DECLARE @v_language			    NVARCHAR(MAX);
	DECLARE @v_title				NVARCHAR(MAX);	
	DECLARE @v_content				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
    DECLARE @v_creation_date		NVARCHAR(MAX);
    DECLARE @v_last_updated_by      NVARCHAR(MAX); 
		
	SET @v_active_flag = NULL;
	SET @v_use_type = NULL;
	SET @v_category_id = NULL;
	SET @v_language = NULL;
	SET @v_content = NULL;
	SET @v_created_by		= NULL;
    SET @v_creation_date    = NULL;
    SET @v_last_updated_by  = NULL; 


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0006_SAVE_RECIPIMENT_MESSAGE';
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
				SET @v_use_type = [dbo].[SCM_ARR_SPL_VAL](@p_use_type, @v_delimiter , @mst_loop_cnt) ; 		
				SET @v_category_id = [dbo].[SCM_ARR_SPL_VAL](@p_category_id, @v_delimiter , @mst_loop_cnt) ; 					
				SET @v_language = [dbo].[SCM_ARR_SPL_VAL](@p_language, @v_delimiter , @mst_loop_cnt) ;    				
				SET @v_title = [dbo].[SCM_ARR_SPL_VAL](@p_title, @v_delimiter , @mst_loop_cnt) ;  
				SET @v_content = [dbo].[SCM_ARR_SPL_VAL](@p_content, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_created_by        = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter , @mst_loop_cnt) ; 
			    SET @v_creation_date     = [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter , @mst_loop_cnt) ; 
                SET @v_last_updated_by   = [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter , @mst_loop_cnt) ; 
					
			END
			
			--HISTORY INSERT
			EXEC [PR_SCM_ADM_RECIPIENT_MESSAGE_HIST]
								 @v_use_type 
								,@v_category_id
								,@v_language 
								,@v_title
								,@v_content
								,@v_created_by
								,@v_creation_date
								,@v_last_updated_by				
			 ;
			
			IF @mst_loop_cnt > 0 
				IF @v_active_flag != 'D'				
					BEGIN  
						MERGE INTO [SCM_ADM_RECIPIENT_MESSAGE] A
						USING (
								SELECT 
									 @v_use_type as use_type_code
									,@v_category_id as category_id	
									,@v_language as language					
							  ) B
						ON(
									A.use_type_code  = B.use_type_code
								AND A.category_id = B.category_id
								AND A.language_code = B.language				
						  )
						WHEN MATCHED THEN
							 UPDATE SET 
									MAIL_TITLE		= @v_title
								   ,MESSAGE_CONTENT	= @v_content
								   ,last_updated_by		= @v_last_updated_by
								   ,last_update_date	= sysdatetime()
					                
						WHEN NOT MATCHED THEN

							INSERT	(									   
									 use_type_code,category_id,language_code,mail_title,message_content
									,created_by,creation_date,last_updated_by,last_update_date
									)
							VALUES  
									(
									 @v_use_type ,@v_category_id , @v_language, @v_title,@v_content
									,@v_created_by,SYSDATETIME(),@v_last_updated_by,SYSDATETIME()
									);
			
					END
				ELSE IF @v_active_flag = 'D'
					BEGIN
						DELETE FROM SCM_ADM_RECIPIENT_MESSAGE
						WHERE use_type_code = @v_use_type
						  AND category_id = @v_category_id
						  AND language_code = @v_language;
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






