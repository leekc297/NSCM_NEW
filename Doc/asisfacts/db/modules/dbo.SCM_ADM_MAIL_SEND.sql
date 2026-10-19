/*
 * Program ID   : SCM_ADM_MAIL_SEND
 * Description  : MAIL 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/21   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE procedure [dbo].[SCM_ADM_MAIL_SEND]

	-- Add the parameters for the stored procedure here
	@p_to_mail				NVARCHAR(MAX),
	@p_subject				NVARCHAR(1000),
	@p_body_contents		NVARCHAR(MAX),
	@p_html_yn				NVARCHAR(1)

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_ADM_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_to_mail      NVARCHAR(MAX);

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		BEGIN
			SET @v_to_mail = ''
			SET @v_to_mail = @p_to_mail
			IF(@p_html_yn = 'Y')
				BEGIN
					EXEC msdb.dbo.sp_send_dbmail
						@profile_name = 'GSCM_MAIL_PROD' 
						, @recipients = @p_to_mail
						, @subject    = @p_subject
						, @body       = @p_body_contents
						, @body_format = 'html'
				END
			ELSE
				BEGIN
					EXEC msdb.dbo.sp_send_dbmail
						@profile_name = 'GSCM_MAIL_PROD' 
						, @recipients = @v_to_mail
						, @subject    = @p_subject
						, @body       = @p_body_contents
				END
			

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END
	END TRY

		BEGIN CATCH
		  BEGIN

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
			  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END
	   	  
