

/*
 * Program ID   : SCM0007_SAVE_RECIPIENT_SMS_GROUP
 * Description  : SMS 수신자 리스트 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/11   hwyoon   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[SCM0007_SAVE_RECIPIENT_SMS_GROUP]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_sms_group_name		NVARCHAR(MAX),
	@p_sms_phone			NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX),
	@p_creation_date		NVARCHAR(MAX),
	@p_last_updated_by		NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_sms_group_name	    NVARCHAR(MAX);
	DECLARE @v_sms_phone			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
    DECLARE @v_creation_date		NVARCHAR(MAX);
    DECLARE @v_last_updated_by      NVARCHAR(MAX); 
		
	SET @v_active_flag = NULL;
	SET @v_sms_group_name = NULL;
	SET @v_sms_phone = NULL;
	SET @v_created_by		= NULL;
    SET @v_creation_date    = NULL;
    SET @v_last_updated_by  = NULL; 


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0007_SAVE_RECIPIENT_SMS_GROUP';
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
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_sms_group_name	 = [dbo].[SCM_ARR_SPL_VAL](@p_sms_group_name, @v_delimiter , @mst_loop_cnt) ;
				SET @v_sms_phone		 = [dbo].[SCM_ARR_SPL_VAL](@p_sms_phone, @v_delimiter , @mst_loop_cnt) ;
				SET @v_created_by        = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter , @mst_loop_cnt) ; 
			    SET @v_creation_date     = [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter , @mst_loop_cnt) ; 
                SET @v_last_updated_by   = [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter , @mst_loop_cnt) ; 
					
			END
						
			IF @mst_loop_cnt > 0 
				IF @v_active_flag != 'D'				
					BEGIN  
						MERGE INTO [SCM_ADM_RECIPIENT_SMS_GROUP] A
						USING (
								SELECT 
									@v_sms_group_name as sms_group_name	
									,@v_sms_phone as sms_phone					
							  ) B
						ON(
									A.sms_group_name = B.sms_group_name
								AND A.sms_phone = B.sms_phone				
						  )
						WHEN MATCHED THEN
							 UPDATE SET 
								    last_updated_by		= @v_last_updated_by
								   ,last_update_date	= sysdatetime()
					                
						WHEN NOT MATCHED THEN

							INSERT	(									   
									 sms_group_name,sms_phone
									,created_by,creation_date,last_updated_by,last_update_date
									)
							VALUES  
									(
									 @v_sms_group_name , @v_sms_phone
									,@v_created_by,SYSDATETIME(),@v_last_updated_by,SYSDATETIME()
									);
			
					END
				ELSE IF @v_active_flag = 'D'
					BEGIN
						DELETE FROM [SCM_ADM_RECIPIENT_SMS_GROUP]
						WHERE sms_group_name = @v_sms_group_name
						  AND sms_phone = @v_sms_phone;
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



