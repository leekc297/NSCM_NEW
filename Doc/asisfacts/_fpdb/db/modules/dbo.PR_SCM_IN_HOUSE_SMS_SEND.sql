CREATE PROCEDURE [dbo].[PR_SCM_IN_HOUSE_SMS_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_IN_HOUSE_SMS_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : 계획 CONIRM시 SMS 발송
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SY_XIF_IFS_SMS_NJ_DATA(한국), SY_XIF_IFS_SMS_DATA (중국)
-- Destination Table   : 
--
-- Create Date		   : 2018.09.11
-- Update Date		   : 

-- Author              : 
-- Version             : 1.0

-- ================================================================================================
-- PARAMETER
@instance_id    NVARCHAR(100) = 'KR_PACK',
@plan_id	    NVARCHAR(100) = '20180913-01',
@type		    NVARCHAR(100) = 'REQUEST'
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_IN_HOUSE_SMS_SEND'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_message   NVARCHAR(max)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @PHONE_NUM				NVARCHAR(30)

	
	
	SET @ROWCOUNT = @@ROWCOUNT

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

			DECLARE CUR_SMS CURSOR FOR
				SELECT ATTRIBUTE1 AS PN
				  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
				 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
				   AND SEGMENT1 = 'IN_HOUSE_PLAN_'+@type
				   AND ACTIVE_FLAG = 'Y'
				   AND ATTRIBUTE2 = @instance_id
			;

			DECLARE CUR_SMS_PI CURSOR FOR
				SELECT ATTRIBUTE1 AS PN
					FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
					WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
					AND SEGMENT1 = 'ELECTRODE_PI'
					AND ACTIVE_FLAG = 'Y'
			;

			SET @v_message = @instance_id+'    '+@plan_id;

			OPEN CUR_SMS;
			FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					IF @instance_id LIKE 'CN%'
						BEGIN

							INSERT INTO SY_XIF_IFS_SMS_NJ_DATA (
									[IF_TYPE]
									,[IF_ID]
									,[IF_INS_DATE]
									,[IF_FLAG]
									,[IF_SND_DATE]
									,[INTIME]
									,[USERCODE]
									,[REQTIME]
									,[REQNAME]
									,[REQPHONE]
									,[CALLNAME]
									,[COUNTRY]
									,[CALLPHONE]
									,[SUBJECT]
									,[MSG]
									,[SMS_TYPE]
									,[KIND]
								) VALUES (
									'S'
									,'OFP0_CSPC_SMS_NJ'
									,GETDATE()
									,'N'
									,GETDATE()
									,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) + REPLACE(CONVERT(CHAR(8), CURRENT_TIMESTAMP, 108),':','')
									,'lgecom3'
									,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) + REPLACE(CONVERT(CHAR(8), CURRENT_TIMESTAMP, 108),':','')
									,'PIYONG'
									,@PHONE_NUM
									,NULL --CALLNAME
									,'86'
									,@PHONE_NUM
									,'Plan release.'
									,(
									  SELECT SEGMENT2
										FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
									   WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @instance_id
									  ) + ' is in-house '+@type+' plan released'
									,'FP'
									,'I'
								)
						END
					ELSE IF @instance_id LIKE 'KR%'
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
								,( SELECT SEGMENT2
									 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
									WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									  AND ACTIVE_FLAG = 'Y'
									  AND SEGMENT1 = @instance_id
											) + ' is in-house '+@type+' plan released' 
							)
						END

					FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
					;

				END;

			CLOSE CUR_SMS;
			DEALLOCATE CUR_SMS;

			OPEN CUR_SMS_PI;
			FETCH NEXT FROM CUR_SMS_PI INTO @PHONE_NUM
			;

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
						,( SELECT SEGMENT2
							 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
							WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							  AND ACTIVE_FLAG = 'Y'
							  AND SEGMENT1 = @instance_id
											) + 'is in-house '+@type+' plan released'
					)

					FETCH NEXT FROM CUR_SMS_PI INTO @PHONE_NUM
					;

				END;

			CLOSE CUR_SMS_PI;
			DEALLOCATE CUR_SMS_PI;
					
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
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, @v_message, @v_descr, @sysdate

	END CATCH

END
