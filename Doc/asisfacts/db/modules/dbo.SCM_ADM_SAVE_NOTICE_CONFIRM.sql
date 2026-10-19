
/*
 * Program ID   : SCM_ADM_SAVE_NOTICE_CONFIRM
 * Description  : 공지 사항 확인
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/26   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[SCM_ADM_SAVE_NOTICE_CONFIRM]

	-- Add the parameters for the stored procedure here
	@p_notice_id				int,
	@p_user_id					NVARCHAR(150)
AS

BEGIN

	SET NOCOUNT ON;
	
	DECLARE @v_Count		int;
	DECLARE @d_date   DATETIME;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_ADM_SAVE_NOTICE_CONFIRM';
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
		
		SET @d_date = SYSDATETIME();
		--HISTORY INSERT
		EXEC [PR_SCM_ADM_NOTICE_CONFIRM_HIST]
										@p_notice_id			
										,@p_user_id		
										,@p_user_id			
										,@d_date	
										,@p_user_id      	
										;
		
		SET @v_Count = (SELECT COUNT(*) FROM SCM_ADM_NOTICE_CONFIRM A WHERE A.NOTICE_ID = @p_notice_id AND A.USER_ID = @p_user_id)

		IF(@v_Count = 0)
			BEGIN
				INSERT INTO SCM_ADM_NOTICE_CONFIRM
						(
							notice_id, user_id,
							created_by, creation_date,last_updated_by, last_update_date
						)
					VALUES(
							@p_notice_id, @p_user_id,
							@p_user_id, @d_date, @p_user_id, @d_date
						)
				;
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







