

/*
 * Program ID   : SCM0006_SAVE_RECIPIENT_MASTER_U
 * Description  : MAIL SET MASTER SQL LONG TEXT UPDATE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/30   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[SCM0006_SAVE_RECIPIENT_MASTER_U]
  @p_use_type			NVARCHAR(MAX),
  @p_module				NVARCHAR(MAX),
  @p_submodule			NVARCHAR(MAX),    
  @p_category_id		NVARCHAR(MAX),
  @p_sql				NVARCHAR(MAX),
  @p_last_updated_by	NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0006_SAVE_RECIPIENT_MASTER_U';
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

		UPDATE SCM_ADM_RECIPIENT_LIST
		   SET SQL_LONG_TEXT = @p_sql
		      ,LAST_UPDATED_BY = @p_last_updated_by
			  ,LAST_UPDATE_DATE = GETDATE()
	    WHERE USE_TYPE_CODE = @p_use_type
		  AND MODULE_CODE = @p_module
		  AND SUB_MODULE_CODE = @p_submodule
		  AND CATEGORY_ID = @p_category_id

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;
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
   ;
END

