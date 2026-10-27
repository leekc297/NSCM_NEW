
CREATE PROCEDURE [dbo].[PR_SCM_QA_RUNNING_CHECK]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_QA_RUNNING_CHECK
-- Param               :
-- Batch Period        : 5 Min
-- Description         : QA DB의 SCM_SITE_M을 조회함으로써 DB가 정상 작동중인지 판단하기 위함
--
-- Source System       : SCM DEV
-- Destination System  : SMS
-- Source Table        : LGCE_INFDEV.dbo.XIF_LOG_HISTORY
-- Destination Table   : SMS
--
-- Create(Update) Date : 2024.02.29
-- Author              : 김진수
-- Version             : 1.0 init
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_QA_RUNNING_CHECK'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @v_target_proc_name NVARCHAR(100) = 'PR_SCM_QA_RUNNING_LOG'
    DECLARE @v_log_type         NVARCHAR(100) = 'END'
    
    DECLARE @LAST_RUNTIME       DATETIME
    DECLARE @PHONE_NUM			NVARCHAR(30)

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		
		 SELECT TOP 1 @LAST_RUNTIME = EVENT_DTTM
         FROM [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY]
         WHERE PROC_NAME = @v_target_proc_name
         AND   LOG_TYPE  = @v_log_type
         ORDER BY EVENT_DTTM DESC

         IF DATEDIFF(SECOND, @LAST_RUNTIME, GETDATE()) > 300
				BEGIN

					DECLARE @SUBJECT NVARCHAR(100) = N'[ERROR] [DEV] QA DB가 응답하지 않습니다.'
					DECLARE @RECEIVE NVARCHAR(1000) = 'kimcd@lgespartner.com;real23@lgespartner.com;blueeos@lgespartner.com;crjung@lgespartner.com;philsu.park@lgespartner.com;park.choyi@lgespartner.com;'
					DECLARE @MSG NVARCHAR(MAX) =
												'<table width=800 border=1px style=border-collapse:collapse>'     +
												'	<tr>' +
												'		<td>DEV Procedure Name</td>'                                                        +
												'		<td>'+ @v_proc_name +'</td>'                                       +
												'		<td>DTTM</td>'                                                     +
												'		<td>'+ CONVERT(NVARCHAR(20), GETDATE(), 120) +'</td>'              +
												'	</tr>'                                                                 +
												'	<tr>'                                                                  +
												'		<td colspan=4>'                                                    +
												'Error Message<br><br>' + N'QA DB의 응답시간이 5분 이상 지연되고 있습니다.'+
												'		</td>'                                                             +
												'	</tr>'                                                                 +
												'</table>'

					EXEC msdb.dbo.sp_send_dbmail @profile_name = 'FP_MAIL_TEST'
													, @recipients = @RECEIVE
													, @subject    = @SUBJECT
													, @body       = @MSG


					DECLARE CUR_SMS CURSOR FOR
						SELECT ATTRIBUTE1 AS PN
							FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
							WHERE LOOKUP_TYPE_CODE	= 'SMS_ADDRESSEE'
							AND SEGMENT1			= 'DB_ERROR'
							AND ATTRIBUTE2		    = 'DB_QA'

						;

					OPEN CUR_SMS;
					FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
							INSERT INTO [SY_XIF_IFS_SMS_DATA] (
								[IF_TYPE]
								,[IF_ID]
								,[IF_INS_DATE]
								,[IF_FLAG]
								,[IF_SND_DATE]
								,[TR_SENDSTAT]
								,[TR_MSGTYPE]
								,[TR_PHONE]
								,[TR_CALLBACK]
								,[TR_MSG]
							) VALUES (
								'S'
								,'OFP0_OSMS_SMS'
								,GETDATE()
								,'N'
								,NULL
								,'0'
								,'0'
								,@PHONE_NUM
								,@PHONE_NUM
								,SUBSTRING(@v_proc_name + N'QA DB의 응답시간이 5분 이상 지연되고 있습니다.', 1, 80 )
							)
									
							FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
							;
						END;
					CLOSE CUR_SMS;
					DEALLOCATE CUR_SMS;

				END

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



