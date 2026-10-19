/*
 * Program ID   : PR_SCM_MST_SITE_ITEM_PRIORITY_HIST
 * Description  : Site Item Priority History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.11   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCM_MST_SITE_ITEM_PRIORITY_HIST]
	@p_priority_seq			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_project_code			NVARCHAR(MAX),
	@p_scm_site_id 			NVARCHAR(MAX),
	@p_plant_site_id		NVARCHAR(MAX),
	@p_item_id 				NVARCHAR(MAX),
	@p_priority				NVARCHAR(MAX),
	@p_from_yyyymmdd		NVARCHAR(MAX),
	@p_to_yyyymmdd			NVARCHAR(MAX),
	@p_valid_yn				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX),
	@p_creation_date		NVARCHAR(MAX),
	@p_last_updated_by		NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_SITE_ITEM_PRIORITY_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	--	BEGIN TRY

			--	-- 시작 LOG
			--SET @v_log_type = 'START';
			--SET @v_log_message = '########## Start of procedure ##########';
			--SET @v_description = '';
			--SET @d_event_date = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		   
				
			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_PRIORITY_H
				
				   BEGIN
					INSERT	INTO  SCM_MST_SITE_ITEM_PRIORITY_H (									   
								 history_seq ,priority_seq,division_id ,project_code ,SALES_SITE_ID,PLANT_SITE_ID
								,item_id ,priority ,from_yyyymmdd ,to_yyyymmdd ,valid_yn
								,created_by ,creation_date ,last_updated_by ,last_update_date ,history_creation_date)
					VALUES  
								(
								 @n_history_seq ,@p_priority_seq,@p_division_id,@p_project_code, @p_scm_site_id,@p_plant_site_id
								,@p_item_id,@p_priority ,@p_from_yyyymmdd ,@p_to_yyyymmdd ,@p_valid_yn
								,@p_created_by,@p_creation_date,@p_last_updated_by,SYSDATETIME(),SYSDATETIME()
								);
				   END
			END

			--SET @v_log_type = 'END';
			--	SET @v_log_message = '########## END of procedure ##########';
			--	SET @v_description = '';
			--	SET @d_event_date = SYSDATETIME();
			--	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--END TRY

		--BEGIN CATCH
		--  BEGIN
		--	INSERT INTO scm_sys_log_batch (program_name
		--								  ,log_type
		--								  ,log_count
		--								  ,log_message
		--								  ,description
		--								  ,event_date
		--								  ,creation_date
		--								  ,created_by
		--								  ,last_update_date
		--								  ,last_updated_by)
		--	VALUES (ERROR_PROCEDURE()
		--		   ,'ERROR'
		--		   ,NULL
		--		   ,ERROR_MESSAGE()
		--		   ,NULL
		--		   ,SYSDATETIME()
		--		   ,SYSDATETIME()
		--		   ,ERROR_PROCEDURE()
		--		   ,SYSDATETIME()
		--		   ,ERROR_PROCEDURE());

		--	--IF @@TRANCOUNT > 0
		--	--  COMMIT WORK;
		--  END;
		--END CATCH;
	END;





