
/*
 * Program ID   : PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST
 * Description  : NOTICE Message History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.22   ygkim      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST]

	@p_notice_id			NVARCHAR(MAX),
	@p_language 			NVARCHAR(MAX),
	@p_title 				NVARCHAR(MAX),
    @p_content 				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX),
	@p_creation_date		NVARCHAR(MAX),
	@p_last_updated_by		NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST';
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
				
			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_ADM_NOTICE_CONTENT_MASTER_H
				
				   BEGIN
					INSERT	INTO  SCM_ADM_NOTICE_CONTENT_MASTER_H(									   
								 history_seq,notice_id,language_code,notice_title,notice_content
								,created_by,creation_date,last_updated_by,last_update_date)
					VALUES  
								(
								 @n_history_seq, @p_notice_id , @p_language, @p_title,@p_content
								,@p_created_by,@p_creation_date,@p_last_updated_by,SYSDATETIME()
								);
				   END
			END

			SET @v_log_type = 'END';
				SET @v_log_message = '########## END of procedure ##########';
				SET @v_description = '';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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
		END CATCH;
	END;






