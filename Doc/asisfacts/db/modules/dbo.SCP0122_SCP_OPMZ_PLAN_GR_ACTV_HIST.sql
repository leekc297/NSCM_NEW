

/*
 * Program ID   : SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST
 * Description  : SCP최적화계획그룹활동이력
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/29   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 
 */
CREATE PROCEDURE [dbo].[SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST]

	@p_prs_cd			NVARCHAR(MAX), 
	@p_plan_gr_id		NVARCHAR(MAX), 
	@p_actv_cd			NVARCHAR(MAX),
	@p_actv_seq			NVARCHAR(MAX), 
	@p_valid_yn			NVARCHAR(MAX),
	@p_created_by		NVARCHAR(MAX),
	@p_creation_date	DATETIME,
	@p_last_updated_by	NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST';
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
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_OPMZ_PLAN_GR_ACTV_H
				
				   BEGIN
					   INSERT INTO SCP_OPMZ_PLAN_GR_ACTV_H
							(
								history_seq, history_creation_date, OPMZ_PRS_CD, OPMZ_PLAN_GR_ID, OPMZ_ACTV_CD, OPMZ_ACTV_SEQ, VALID_YN, 
								created_by, creation_date, last_updated_by, last_update_date
							)
						VALUES(
								@n_history_seq, @d_event_date, @p_prs_cd, @p_plan_gr_id, @p_actv_cd, @p_actv_seq, @p_valid_yn, 
								@p_created_by, @p_creation_date, @p_last_updated_by, SYSDATETIME()
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





