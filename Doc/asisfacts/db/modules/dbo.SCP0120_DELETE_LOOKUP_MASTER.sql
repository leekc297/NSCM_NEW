
/*
 * Program ID   : SCP0120_DELETE_LOOKUP_MASTER
 * Description  : Constraint Mgmt Lookup Type 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025/04/17   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 */
CREATE PROCEDURE [dbo].[SCP0120_DELETE_LOOKUP_MASTER]

	-- Add the parameters for the stored procedure here
	@LOOKUP_TYPE	NVARCHAR(200)

AS

BEGIN

	SET NOCOUNT ON;
	DECLARE @v_cnt INT;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0120_DELETE_LOOKUP_TYPE';
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
			SELECT @v_cnt = COUNT(*)
			FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
			WHERE LOOKUP_TYPE = @LOOKUP_TYPE
		END

		--LOOKUP VALUE가 있으면 그 값도 같이 삭제
		IF @v_cnt > 0
			BEGIN
				DELETE FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = @LOOKUP_TYPE
			END

		BEGIN
			DELETE FROM  SCP_OPMZ_LOOKUP_MASTER WHERE LOOKUP_TYPE = @LOOKUP_TYPE
		END			

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code ;

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






