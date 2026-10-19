
/*
 * Program ID   : PR_SCP_MST_FORMATION_HIST
 * Description  : Formation Master History 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018.03		KYH				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2109.04.08	hwyoon			[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2019/04/11	AYJ				SSP_MODIFY_YIELD 컬럼 추가	
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_FORMATION_HIST]
	 @p_division_id				NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_Lf_Formation			NVARCHAR(MAX)
	, @p_Add_LT_Formation		NVARCHAR(MAX)
	, @p_formation_yield		NVARCHAR(MAX)
	, @p_char_yield				NVARCHAR(MAX)
	, @p_formation_total_yield	NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_creation_date			DATETIME
	, @p_user_modify_yield		NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[PR_SCP_MST_FORMATION_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		--BEGIN TRY

				-- 시작 LOG
			--SET @v_log_type = 'START';
			--SET @v_log_message = '########## Start of procedure ##########';
			--SET @v_description = '';
			--SET @d_event_date = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			--declare
			--	@v_loss_time_min int = convert(int , @p_loss_time_min) ,
			--	@v_setup_loss_time_min int = convert(int , @p_setup_loss_time_min)

			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_FORMATION_H

				BEGIN
				INSERT	INTO  SCP_MST_FORMATION_H (
					history_seq, 
					division_id, 
					plant_site_id, 
					ITEM_ID ,
					LT_FORMATION ,
					FORMATION_YIELD ,
					CHAR_YIELD,
					FORMATION_TOTAL_YIELD,
					created_by, 
					creation_date,
					last_updated_by, 
					last_update_date, 
					HISTORY_CREATION_DATE ,
					ATTRIBUTE1,
					SSP_MODIFY_YIELD
					)
				VALUES  (
					@n_history_seq,
					@p_division_id, 
					@p_plant_site_id, 
					@p_item_id		,
					@p_Lf_Formation	,
					CASE WHEN ISNULL(@p_formation_yield,'')='' THEN null ELSE (convert(float , @p_formation_yield) / 100) end,
					CASE WHEN ISNULL(@p_char_yield,'')='' THEN null ELSE (convert(float , @p_char_yield) / 100) end,
					CASE WHEN ISNULL(@p_formation_total_yield,'')='' THEN null ELSE (convert(float , @p_formation_total_yield) / 100) end,
					@p_created_by , 
					@p_creation_date, 
					@p_last_updated_by,	
					SYSDATETIME() ,
					SYSDATETIME() ,
					@p_Add_LT_Formation ,
					CASE WHEN ISNULL(@p_user_modify_yield,'')='' THEN null ELSE (convert(float , @p_user_modify_yield) / 100) end
				);
				END
			END

			--SET @v_log_type = 'END';
			--	SET @v_log_message = '########## END of procedure ##########';
			--	SET @v_description = '';
			--	SET @d_event_date = SYSDATETIME();
			--	EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--END TRY

		--BEGIN CATCH
		  --BEGIN
			--INSERT INTO scm_sys_log_batch (program_name
			--							  ,log_type
			--							  ,log_count
			--							  ,log_message
			--							  ,description
			--							  ,event_date
			--							  ,creation_date
			--							  ,created_by
			--							  ,last_update_date
			--							  ,last_updated_by)
			--VALUES (ERROR_PROCEDURE()
			--	   ,'ERROR'
			--	   ,NULL
			--	   ,ERROR_MESSAGE()
			--	   ,NULL
			--	   ,SYSDATETIME()
			--	   ,SYSDATETIME()
			--	   ,ERROR_PROCEDURE()
			--	   ,SYSDATETIME()
			--	   ,ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			  --COMMIT WORK;
		  --END;
		--END CATCH;
	END;


