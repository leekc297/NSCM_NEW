
CREATE PROCEDURE [dbo].[PR_SCM_PR_RUNNING_CHECK]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_PR_RUNNING_CHECK
-- Param               :
-- Batch Period        : 5 Min
-- Description         : SCM FP 운영 DB의 SCM_SITE_M의 조회 로그를 확인하여 SCM DB가 정상 작동중인지 판단함
--
-- Source System       : SCM FP
-- Destination System  : SMS
-- Source Table        : LGCE_INFDEV.dbo.XIF_LOG_HISTORY
-- Destination Table   : SMS
--
-- Create(Update) Date : 2025.05.07
-- Author              : 김진수
-- Version             : 1.0 init
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_PR_RUNNING_CHECK'
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
	DECLARE @v_target_proc_name NVARCHAR(100) = 'PR_SCM_PR_RUNNING_LOG'
    DECLARE @v_log_type         NVARCHAR(100) = 'END'
    
    DECLARE @LAST_RUNTIME       DATETIME
    DECLARE @PHONE_NUM			NVARCHAR(30)
    DECLARE @MAIL_ADDRESS		NVARCHAR(50)

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				
		--BEGIN TRAN
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

					DECLARE @SUBJECT NVARCHAR(100) = N'[ERROR] GSCM 운영 DB가 응답하지 않습니다.'
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
												'Error Message<br><br>' + N'GSCM 운영 DB의 응답시간이 5분 이상 지연되고 있습니다.'+
												'		</td>'                                                             +
												'	</tr>'                                                                 +
												'</table>'


					DECLARE CUR_MAIL_SMS CURSOR FOR
					 SELECT ATTRIBUTE1 AS PN
                           ,ATTRIBUTE3 AS MAIL_ADDRESS
			           FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
					  WHERE LOOKUP_TYPE_CODE	= 'SMS_ADDRESSEE'
					    AND SEGMENT1			= 'DB_ERROR'
					    AND ATTRIBUTE2		    = 'DB_PR'
                        AND ACTIVE_FLAG         = 'Y';

					OPEN CUR_MAIL_SMS;
					FETCH NEXT FROM CUR_MAIL_SMS INTO @PHONE_NUM
                                                     ,@MAIL_ADDRESS

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
                            -- 메일 전송
                        	EXEC msdb.dbo.sp_send_dbmail @profile_name = 'scmpi'
									, @recipients = @MAIL_ADDRESS
									, @subject    = @SUBJECT
									, @body       = @MSG

                            -- SMS 전송
                            EXEC "10.47.209.71,1433".LGCE_FPDEV_TR.DBO.PR_SCM_PR_RUNNING_SMS_SEND @PHONE_NUM
									
							FETCH NEXT FROM CUR_MAIL_SMS INTO @PHONE_NUM
                                                             ,@MAIL_ADDRESS
							;
						END;
					CLOSE CUR_MAIL_SMS;
					DEALLOCATE CUR_MAIL_SMS;

				END
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		--COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    --ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



