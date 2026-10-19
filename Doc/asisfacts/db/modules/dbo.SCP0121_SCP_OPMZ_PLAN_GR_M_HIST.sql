

/*
 * Program ID   : SCP0121_SCP_OPMZ_PLAN_GR_M_HIST
 * Description  : SCP 최적화계획그룹 이력 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/28   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/05   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Target 대상, Onwer 정보 추가
 * 
 */
CREATE PROCEDURE [dbo].[SCP0121_SCP_OPMZ_PLAN_GR_M_HIST]

	@p_plan_gr_id		NVARCHAR(MAX), 
	@p_plan_gr_name		NVARCHAR(MAX), 
	@p_plan_gr_desc		NVARCHAR(MAX), 
	@p_tgt_divs_cd		NVARCHAR(MAX), 
	@p_owner			NVARCHAR(MAX), 
	@p_owner_name		NVARCHAR(MAX), 
	@p_division_id		NVARCHAR(MAX),
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
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0121_SCP_OPMZ_PLAN_GR_M_HIST';
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
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_OPMZ_PLAN_GR_H
				
				   BEGIN
					   INSERT INTO SCP_OPMZ_PLAN_GR_H
							(
								history_seq, history_creation_date, OPMZ_PLAN_GR_ID, OPMZ_PLAN_GR_NAME, OPMZ_PLAN_GR_DESC, OPMZ_TGT_DIVS_CD, DIVISION_ID, OWNR_LST_CTN, VALID_YN, 
								ATTRIBUTE1, created_by, creation_date, last_updated_by, last_update_date
							)
						VALUES(
								@n_history_seq, @d_event_date, @p_plan_gr_id, @p_plan_gr_name, @p_plan_gr_desc, @p_tgt_divs_cd, @p_division_id, @p_owner, @p_valid_yn,
								@p_owner_name, @p_created_by, @p_creation_date, @p_last_updated_by, SYSDATETIME()
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





