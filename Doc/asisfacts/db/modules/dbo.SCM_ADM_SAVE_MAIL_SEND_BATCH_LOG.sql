
/*
 * Program ID   : SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG
 * Description  : MAIL 발송 BATCH LOG 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/07   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG]
   @v_use_type_code		NVARCHAR(10)
  ,@p_category_id	    int
  ,@p_segment1			NVARCHAR(150)
  ,@p_segment2			NVARCHAR(150) = NULL
  ,@p_segment3			NVARCHAR(150) = NULL
  ,@p_segment4			NVARCHAR(150) = NULL
  ,@p_segment5			NVARCHAR(150) = NULL
  ,@p_segment6			NVARCHAR(150) = NULL
  ,@p_segment7			NVARCHAR(150) = NULL
  ,@p_segment8			NVARCHAR(150) = NULL
  ,@p_segment9			NVARCHAR(150) = NULL
  ,@p_segment10			NVARCHAR(150) = NULL
  ,@p_send_pgm			NVARCHAR(150) = NULL
  ,@p_receiver_id		NVARCHAR(150) = NULL

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @dispatch_serial_no INT;

	BEGIN TRY

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = @p_category_id;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		BEGIN
			SET @dispatch_serial_no = NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_SMS_MAIL_SEND_LOG]

			INSERT INTO [dbo].[SCM_ADM_SMS_MAIL_SEND_LOG]
			    (DISPATCH_SERIAL_NO
				,USE_TYPE_CODE				
				,CATEGORY_ID								
				,SEGMENT1
				,SEGMENT2
				,SEGMENT3
				,SEGMENT4
				,SEGMENT5
				,SEGMENT6
				,SEGMENT7
				,SEGMENT8
				,SEGMENT9
				,SEGMENT10
				,SEND_DATE
				,SEND_MAIL_ERROR_LOG_DESC
				,RECEIVE_USER_ID
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
			) VALUES
			(
				@dispatch_serial_no
				,@v_use_type_code
				,@p_category_id
				,@p_segment1
				,@p_segment2
				,@p_segment3
				,@p_segment4
				,@p_segment5
				,@p_segment6
				,@p_segment7
				,@p_segment8
				,@p_segment9
				,@p_segment10
				,GETDATE()
				,@p_send_pgm
				,@p_receiver_id
				,'SYSTEM'
				,GETDATE()
				,'SYSTEM'
				,GETDATE()
			);
		END
		-- 결과코드, 결과 카운트 반환
			--SELECT  'S' AS result_code ;
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

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_category_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END

