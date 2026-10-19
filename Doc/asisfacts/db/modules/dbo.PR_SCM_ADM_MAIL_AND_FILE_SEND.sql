
/*
 * Program ID   : PR_SCM_ADM_MAIL_AND_FILE_SEND
 * Description  : MAIL 발송 (파일첨부)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.17   sclee.lee      PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - Initial Release
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_ADM_MAIL_AND_FILE_SEND]
	@p_to_mail				NVARCHAR(MAX),
	@p_subject				NVARCHAR(1000),
	@p_body_contents		NVARCHAR(MAX),
	@p_file_attachments     NVARCHAR(MAX)   -- 여러 파일을 첨부할 경우 A;B;C 형식으로 표시
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name   NVARCHAR(150) = 'PR_SCM_ADM_MAIL_AND_FILE_SEND';
    DECLARE @v_log_type       NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count      INTEGER = 0;
    DECLARE @v_log_message    NVARCHAR(1000);
    DECLARE @v_description    NVARCHAR(500);
    DECLARE @d_event_date     DATETIME;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
		BEGIN
			set @p_to_mail = 'jooyong026@lgespartner.com';--개발용
            EXEC msdb.dbo.sp_send_dbmail
                @profile_name       = 'GSCM_MAIL_PROD' 
                , @recipients       = @p_to_mail
                , @subject          = @p_subject
                , @body             = @p_body_contents
                , @file_attachments = @p_file_attachments;			
            

			
			-- MAIL 발송 LOG 저장
			EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
				 'MAIL'			    --@v_use_type_code	
				,'-'				--@p_category_id	
				,@p_subject         --@p_segment1		
				,@p_body_contents   --@p_segment2		
				,@p_file_attachments--@p_segment3		
				,''                 --@p_segment4		
				,''                 --@p_segment5		
				,''                 --@p_segment6		
				,''                 --@p_segment7		
				,''                 --@p_segment8		
				,''                 --@p_segment9		
				,''                 --@p_segment10		
				,@v_program_name    --@p_send_pgm		
				,@p_to_mail			--@p_receiver_id	



			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = CONCAT('recipients : ', @p_to_mail);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
	END TRY

	BEGIN CATCH

		SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());

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
			   ,@v_description
			   ,SYSDATETIME()
			   ,SYSDATETIME()
			   ,ERROR_PROCEDURE()
			   ,SYSDATETIME()
			   ,ERROR_PROCEDURE());
	
		IF @@TRANCOUNT > 0
		BEGIN
		    COMMIT WORK;
		END
	
	    -- error코드, errror 메시지 반환
	    SELECT 'F' AS result_code;
	    SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END
