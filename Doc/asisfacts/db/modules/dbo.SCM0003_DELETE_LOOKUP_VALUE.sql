/*
 * Program ID   : SCM0003_DELETE_LOOKUP_VALUE
 * Description  : Lookup Type 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/07   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[SCM0003_DELETE_LOOKUP_VALUE]

	-- Add the parameters for the stored procedure here
	@LOOKUP_TYPE		NVARCHAR(200),
	@SEGMENT1_KEY		NVARCHAR(100),
	@SEGMENT2_KEY		NVARCHAR(100),
	@SEGMENT3_KEY		NVARCHAR(100),
	@SEGMENT4_KEY		NVARCHAR(100),
	@SEGMENT5_KEY		NVARCHAR(100)

AS

BEGIN

	SET NOCOUNT ON;
	DECLARE @v_cnt INT;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0003_DELETE_LOOKUP_VALUE';
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
			DELETE FROM [SCM_ADM_LOOKUP_VALUES_T] 
			WHERE LOOKUP_TYPE = @LOOKUP_TYPE
			  AND SEGMENT1 = @SEGMENT1_KEY
			  AND SEGMENT2 = @SEGMENT2_KEY
			  AND SEGMENT3 = @SEGMENT3_KEY
			  AND SEGMENT4 = @SEGMENT4_KEY
			  AND SEGMENT5 = @SEGMENT5_KEY;
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







