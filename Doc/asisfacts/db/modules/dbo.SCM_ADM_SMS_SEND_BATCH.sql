
/*
 * Program ID   : SCM_ADM_SMS_SEND_BATCH
 * Description  : SMS 발송 BATCH
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/14   hwyoon         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/21   hwyoon         Plan Type 파라미터 추가(송신 메세지에 파라미터 내용 삽입)
 * 2018/09/28   ygkim          발신자 01099999999로 변경
 * 2019/06/19	hwyoon         문자발송 시 모듈 별 표시 추가
 * 2024/11/30	kimcd          PJ20249346 SCP 개선과제 이행 : 야간 주말에 speed call 대표 전화로 SMS 전송
 */
CREATE PROCEDURE [dbo].[SCM_ADM_SMS_SEND_BATCH]

	-- Add the parameters for the stored procedure here
	@p_category_id				int,
	@p_plan_type				NVARCHAR(MAX) = ''

AS

BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_result			NVARCHAR(MAX);
	DECLARE @v_message_content  NVARCHAR(4000);
	DECLARE @v_sms_phone		NVARCHAR(50);
	DECLARE @v_sms_send_phone	NVARCHAR(50);
	DECLARE @v_use_type_code    NVARCHAR(10);
	DECLARE @v_module_code		NVARCHAR(30);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_ADM_SMS_SEND_BATCH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name = '#TblSmsSendBatch')
		   DROP TABLE #TblSmsSendBatch
 
	CREATE TABLE #TblSmsSendBatch (
			 message_content	NVARCHAR(4000),
			 sms_phone			NVARCHAR(50),
			 use_type_code		NVARCHAR(10),
			 module_code		NVARCHAR(30)
	);

	SET @v_result = ''
	SET @v_result = @v_result+'        SELECT b.message_content '+CHAR(10)
	SET @v_result = @v_result+'              ,c.sms_phone '+CHAR(10)
	SET @v_result = @v_result+'              ,a.use_type_code '+CHAR(10)
	SET @v_result = @v_result+'              ,a.module_code '+CHAR(30)
	SET @v_result = @v_result+'          FROM SCM_ADM_RECIPIENT_LIST a '+CHAR(10)
	SET @v_result = @v_result+'         INNER JOIN SCM_ADM_RECIPIENT_MESSAGE b '+CHAR(10)
	SET @v_result = @v_result+'            ON a.CATEGORY_ID = b.CATEGORY_ID  '+CHAR(10)
	SET @v_result = @v_result+'         INNER JOIN SCM_ADM_RECIPIENT_SMS_ASSIGN c WITH(NOLOCK)  '+CHAR(10)
	SET @v_result = @v_result+'            ON a.CATEGORY_ID = c.CATEGORY_ID '+CHAR(10)
	SET @v_result = @v_result+'         WHERE a.CATEGORY_ID =' +convert(nvarchar,@p_category_id)+CHAR(10)
	SET @v_result = @v_result+'              AND a.VALID_YN = ''Y'' '+CHAR(10)

	INSERT INTO #TblSmsSendBatch
	exec (@v_result)
	
	DECLARE CUR_SEND CURSOR FOR
	SELECT * FROM #TblSmsSendBatch


	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		OPEN CUR_SEND;
		FETCH NEXT FROM CUR_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code;


		WHILE @@FETCH_STATUS = 0
			BEGIN
				
				BEGIN
					IF ISNULL(@p_plan_type,'') != ''
						SET @v_message_content = '[' +@v_module_code+ ']'+@p_plan_type+' '+@v_message_content
				END
PRINT '@v_message_content: ' + @v_message_content

				SET @v_sms_send_phone = ''
				SET @v_sms_send_phone = '01099999999'

				INSERT INTO XIF_IFS_SMS_DATA_SN
				(IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, TR_SENDSTAT, TR_MSGTYPE, TR_PHONE, TR_CALLBACK, TR_MSG)
				VALUES 
				('S', 'OFP0_OSMS_SMS', GETDATE(), 'N', '0', '0', @v_sms_phone, @v_sms_send_phone, @v_message_content)

				--SMS 발송 LOG 저장
				EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG @v_use_type_code
								,@p_category_id
								,@v_sms_phone
								,@v_message_content
								,''
								,''
								,''
								,''
								,''
								,''
								,''
								,''
								,'' --p_send_pgm
								,@v_sms_phone;


				FETCH NEXT FROM CUR_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code

			END

		CLOSE CUR_SEND;
		DEALLOCATE CUR_SEND;

		IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name = '#TblSmsSendBatch')
		   DROP TABLE #TblSmsSendBatch
		--DROP TABLE #TblSmsSendBatch

--------------------------------------------------------------------------------------------
-- 2024-11-30	kimcd PJ20249346 SCP 개선과제 이행 : 야간 주말에 speed call 대표 전화로 SMS 전송 시작
        DECLARE @WEEKDAY INTEGER = DATEPART(WEEKDAY, GETDATE());
	    DECLARE @LHOUR   INTEGER = DATEPART(HOUR, GETDATE());

        IF  @WEEKDAY IN  (1,7)  OR @LHOUR < 9 OR @LHOUR > 18 
            BEGIN 
	            DECLARE CUR_SPEED_CALL_SEND CURSOR FOR
                    SELECT ATTRIBUTE1    AS MESSAGE_CONTENT
	                      ,ATTRIBUTE2    AS SMS_PHONE
				          ,ATTRIBUTE3    AS USE_TYPE_CODE
					      ,ATTRIBUTE4    AS MODULE_CODE
	                FROM   [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] AMD WITH(NOLOCK)
	                WHERE  AMD.[LOOKUP_TYPE] = 'SPEED_CALL_CATEGORY_ID'
				    AND    AMD.VALID_YN      = 'Y'
				    AND    AMD.SEGMENT1      = CONVERT(NVARCHAR,@p_category_id);
		
		        OPEN CUR_SPEED_CALL_SEND;
		        FETCH NEXT FROM CUR_SPEED_CALL_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code;

		        WHILE @@FETCH_STATUS = 0
			    BEGIN
				    BEGIN
					    IF ISNULL(@p_plan_type,'') != ''
						    SET @v_message_content = '[' +@v_module_code+ ']'+@p_plan_type+' '+@v_message_content
				    END

				    SET @v_sms_send_phone = ''
				    SET @v_sms_send_phone = '01099999999'

				    INSERT INTO XIF_IFS_SMS_DATA_SN
				    (IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, TR_SENDSTAT, TR_MSGTYPE, TR_PHONE, TR_CALLBACK, TR_MSG)
				    VALUES 
				    ('S', 'OFP0_OSMS_SMS', GETDATE(), 'N', '0', '0', @v_sms_phone, @v_sms_send_phone, @v_message_content)

				    --SMS 발송 LOG 저장
				    EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG @v_use_type_code
				    				,@p_category_id
				    				,@v_sms_phone
				    				,@v_message_content
				    				,''
				    				,''
				    				,''
				    				,''
				    				,''
				    				,''
				    				,''
				    				,''
				    				,'' --p_send_pgm
				    				,@v_sms_phone;


				    FETCH NEXT FROM CUR_SPEED_CALL_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code

			    END;

		        CLOSE CUR_SPEED_CALL_SEND;
		        DEALLOCATE CUR_SPEED_CALL_SEND;
		    END;
-- 2024-11-30	kimcd PJ20249346 SCP 개선과제 이행 : 야간 주말에 speed call 대표 전화로 SMS 전송 종료
--------------------------------------------------------------------------------------------

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		CLOSE CUR_SEND;
		DEALLOCATE CUR_SEND;
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

		BEGIN
			DECLARE @v_error_message NVARCHAR(1000);
			SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);

			--MAIL 발송 LOG 저장
				EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'ERROR'
				              ,@p_category_id
							  ,'MAIN ERROR' 
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,@v_error_message --p_send_pgm
							  ,'';
		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END
		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;

END