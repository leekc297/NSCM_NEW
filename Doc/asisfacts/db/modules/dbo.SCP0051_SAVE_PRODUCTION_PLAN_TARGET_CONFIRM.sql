
/*
 * Program ID   : SCP0051_SAVE_PRODUCTION_PLAN_CONFIRM
 * Description  : PRODUCTION PLAN TARTGET CONFIRM
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020-10-07   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 */

 
CREATE PROCEDURE [dbo].[SCP0051_SAVE_PRODUCTION_PLAN_TARGET_CONFIRM]
	 @p_target_id			NVARCHAR(MAX)
	,@p_confirm_user_id		NVARCHAR(MAX)
	,@debug_mode			NVARCHAR(20) ='F'
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0051_SAVE_PRODUCTION_PLAN_TARGET_CONFIRM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		-- 긴급 TARGET CONFIRM 정보 수정
		UPDATE SCP_ANL_PRODUCTION_PLAN_TARGET
		   SET CONFIRM_YN = 'Y'
		     , CONFIRM_USER_ID = @p_confirm_user_id
		     , CONFIRM_DATE = SYSDATETIME()
		 WHERE 1 = 1
		   AND TARGET_ID  IN (SELECT token FROM dbo.String_Split(@p_target_id  ,@v_delimiter) ) 

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code ;

	END TRY

	BEGIN CATCH 

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END

