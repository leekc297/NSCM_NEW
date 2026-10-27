
-- ================================================================================================
-- Program ID          : FPBatchLog
-- Program Name        : PR_XIF_LOG
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : 
-- Destination Table   : 
--
-- Create Date		   : 2016.07.29
-- Update Date		   : 2017.09.20 1.1 piyong 메일 수신 대상자 변경
--						 2020.04.23 1.2 piyong 

-- Author              : 김 석
-- Version             : 1.0
--						 1.1
--						 1.2 ENGINE_RUN 오류 일 경우 SMS 수신자 추가 수신


-- ================================================================================================

CREATE   PROCEDURE [dbo].[PR_XIF_LOG]

   @p_proc_name  NVARCHAR(150),
   @p_table_name NVARCHAR(150),
   @p_log_type   NVARCHAR(30),
   @p_log_count  INT,
   @p_log_code   NVARCHAR(30),
   @p_message    NVARCHAR(MAX),
   @p_descr      NVARCHAR(MAX),
   @p_event_dttm DATETIME

AS

	DECLARE @PHONE_NUM			NVARCHAR(30)

    BEGIN

		BEGIN TRY
		
			
			IF @p_proc_name <> 'PR_XIF_DW_WIP_HISTORY_R'
				BEGIN

					DECLARE @SUBJECT NVARCHAR(100) = '[ERROR] [LIVE] ' + @p_proc_name + ''
					DECLARE @RECEIVE NVARCHAR(1000) = 'kimcd@lgespartner.com;leejsthira2@lgespartner.com;yschoithira@lgespartner.com;crjung@lgespartner.com'		

					DECLARE @MSG NVARCHAR(MAX) =
												'<table width=800 border=1px style=border-collapse:collapse>'     +
												'	<tr>' +
												'		<td>LIVE Procedure Name</td>'                                                        +
												'		<td>'+ @p_proc_name +'</td>'                                       +
												'		<td>DTTM</td>'                                                     +
												'		<td>'+ CONVERT(NVARCHAR(20), GETDATE(), 120) +'</td>'              +
												'	</tr>'                                                                 +
												'	<tr>'                                                                  +
												'		<td colspan=4>'                                                    +
												'Error Message<br><br>'+ @p_descr                                          +
												'		</td>'                                                             +
												'	</tr>'                                                                 +
												'</table>'

					IF @p_log_type = 'ERROR'
						BEGIN
							/*
							EXEC msdb.dbo.sp_send_dbmail @profile_name = 'FP_MAIL'
														 , @recipients = @RECEIVE
														 , @subject    = @SUBJECT
														 , @body       = @MSG
							*/

							DECLARE CUR_SMS CURSOR FOR
								SELECT ATTRIBUTE1 AS PN
								  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
								 WHERE LOOKUP_TYPE_CODE	= 'SMS_ADDRESSEE'
								   AND SEGMENT1			= 'ERROR'
								   --AND ATTRIBUTE2		IN ( 'IF' )
								   AND ATTRIBUTE2  IN ( CASE WHEN @p_proc_name LIKE '%ENGINE_RUN%' THEN 'ENGINE' END , 'IF')	-- 2020-04-23 PIYONG CHANGE
								   AND ACTIVE_FLAG = 'Y'
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
												,SUBSTRING(@p_proc_name + N'    '+@p_descr, 1, 80 )
											)
									
											FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
											;
										END;
									CLOSE CUR_SMS;
									DEALLOCATE CUR_SMS;

						END

				END
			
		

	  INSERT [dbo].[SY_XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
       VALUES (
              @p_proc_name, 
              @p_table_name, 
              @p_log_type, 
              @p_log_count, 
              @p_log_code, 
              @p_message, 
              @p_descr,
			  SYSDATETIME())


       IF @@TRANCOUNT > 0 COMMIT WORK

      END TRY

      BEGIN CATCH

         BEGIN



            INSERT dbo.[SY_XIF_LOG_HISTORY](
               PROC_NAME, 
               TABLE_NAME, 
               LOG_TYPE, 
               LOG_COUNT, 
               LOG_CODE, 
               MESSAGE, 
               DESCR,
			   EVENT_DTTM)
               VALUES (
                  ERROR_PROCEDURE(), 
                  'INF_LOG_HISTORY', 
                  'ERROR', 
                  NULL, 
                  'E9999', 
                  NULL, 
                  ERROR_MESSAGE(),
				  SYSDATETIME())


            IF @@TRANCOUNT > 0 COMMIT WORK



         END

      END CATCH

   END



