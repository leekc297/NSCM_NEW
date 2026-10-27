CREATE PROCEDURE [dbo].[PR_SCM_CONFIRM_SMS_SEND]

-- ================================================================================================
-- Program ID          : FP02721
-- Program Name        : PR_SCM_CONFIRM_SMS_SEND
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
-- Update Date		   : 2019.03.08 1.1 PIYONG
--						 2019.12.24 1.2 PIYONG
--						 2020.04.07 1.3 PIYONG C20200405-000011
--                       2021.06.04 1.4 kimcd

-- Author              : 
-- Version             : 1.0
--						 1.1 동별 송신 처리
--						 1.2 전화 번호 없는 사람 제외 처리
--						 1.3 한국 발송 시 문자 길이 80 이상시 MMS로 발송 C20200405-000011
--                       1.4 2021-06-04 kimcd PI인원 중에 메일 제외 요청이 있어 대상 제외 로직 추가
-- ================================================================================================
-- PARAMETER
@instance_id    NVARCHAR(100) = 'KR_PACK',
@plan_id	    NVARCHAR(100) = 'KR_PACK-20180913-99',
@factory_id		NVARCHAR(100) = 'E5'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_CONFIRM_SMS_SEND'
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
	DECLARE @MSG					NVARCHAR(2000)			-- 2020-04-07 PIYONG ADD

	
	
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
				   AND SEGMENT1 = 'PLAN_CONFIRM'
				   AND ACTIVE_FLAG = 'Y'
				   AND ATTRIBUTE2 = @instance_id
				   AND (SEGMENT3 = '-' OR SEGMENT3 = @factory_id)			-- 2019-03-08 PIYONG ADD
				   AND ATTRIBUTE1 IS NOT NULL								-- 2019-12-24 PIYONG ADD
			;

			DECLARE CUR_SMS_PI CURSOR FOR
				SELECT ATTRIBUTE1 AS PN
				 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
				WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
				  AND SEGMENT1 = 'ELECTRODE_PI'
				  AND ACTIVE_FLAG = 'Y'
  				  AND ISNULL(ATTRIBUTE5,'Y') != 'N' -- 2021-06-04 kimcd SMS 제외 요청자 제거
			;

			SET @v_message = @instance_id+'    '+@plan_id;

			--------------------------------------------------------------------------------------------------------------------------------
			-- 2020-04-07 PIYONG ADD C20200405-000011
			SET @MSG = ( SELECT SEGMENT2
							FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
							WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							AND ACTIVE_FLAG = 'Y'
							AND SEGMENT1 = @instance_id
						) + N' is plan released. Reason : ' + ISNULL( (
																		SELECT ISNULL(D.[DESCRIPTION],ISNULL(M.[DESCRIPTION], '') )
																			FROM (
																				SELECT [INSTANCE_ID],
																						[RELEASE_PLAN_ID],
																						[DESCRIPTION]
																					FROM [SCM_FP_PLAN_DETAIL_H]
																					WHERE [INSTANCE_ID] = @instance_id
																					AND [RELEASE_PLAN_ID] = @plan_id
																					AND FACTORY_ID = @factory_id
																				UNION ALL
																				SELECT [INSTANCE_ID],
																						[RELEASE_PLAN_ID],
																						[DESCRIPTION]
																					FROM [SCM_FP_PLAN_GROUP_DETAIL_H]
																					WHERE [INSTANCE_ID] = @instance_id
																					AND [RELEASE_PLAN_ID] = @plan_id
																					AND PLAN_GROUP_ID = @factory_id
																				) D
																			RIGHT OUTER JOIN [SCM_FP_PLAN_H] M
																						ON M.[INSTANCE_ID] = D.[INSTANCE_ID]
																						AND M.[PLAN_ID] = D.[RELEASE_PLAN_ID]
																						AND M.[CONFIRM_FLAG] = 'Y'
																			WHERE M.[INSTANCE_ID] = @instance_id
																			AND M.[PLAN_ID] = @plan_id
																										), '' )

			-- 2020-04-07 PIYONG ADD END
			--------------------------------------------------------------------------------------------------------------------------------


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
									,'PIYONG'
									,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) + REPLACE(CONVERT(CHAR(8), CURRENT_TIMESTAMP, 108),':','')
									,'PIYONG'
									,@PHONE_NUM
									,NULL --CALLNAME
									,'86'
									,@PHONE_NUM
									,'Plan release.'
									,@MSG				-- 2020-04-07 PIYONG ADD
									/*
									,(
									  SELECT SEGMENT2
										FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
									   WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
										 AND ACTIVE_FLAG = 'Y'
										 AND SEGMENT1 = @instance_id
									  ) + N' is plan released. Reason : ' + ISNULL( (
																					  SELECT ISNULL(D.[DESCRIPTION],ISNULL(M.[DESCRIPTION], '') )
																						FROM (   
																								SELECT [INSTANCE_ID],
																									   [RELEASE_PLAN_ID],
																									   [DESCRIPTION]
																								  FROM [SCM_FP_PLAN_DETAIL_H]
																								 WHERE [INSTANCE_ID] = @instance_id
																								   AND [RELEASE_PLAN_ID] = @plan_id
																								   AND FACTORY_ID = @factory_id
																								UNION ALL
																								SELECT [INSTANCE_ID],
																									   [RELEASE_PLAN_ID],
																									   [DESCRIPTION]
																								  FROM [SCM_FP_PLAN_GROUP_DETAIL_H]
																								 WHERE [INSTANCE_ID] = @instance_id
																								   AND [RELEASE_PLAN_ID] = @plan_id
																								   AND PLAN_GROUP_ID = @factory_id
																							 ) D
																						 RIGHT OUTER JOIN [SCM_FP_PLAN_H] M
																									   ON M.[INSTANCE_ID] = D.[INSTANCE_ID]
																									  AND M.[PLAN_ID] = D.[RELEASE_PLAN_ID]
																									  AND M.[CONFIRM_FLAG] = 'Y'
																						 WHERE M.[INSTANCE_ID] = @instance_id
																						   AND M.[PLAN_ID] = @plan_id
																											), '' )
									*/
									,'FP'
									,'I'
							)
						END
					ELSE IF @instance_id LIKE 'KR%'
						BEGIN
							--------------------------------------------------------------------------------------------------------------------------------
							-- 2020-04-07 PIYONG ADD C20200405-000011

							IF LEN ( @MSG ) >= 80
								BEGIN
									INSERT INTO [LGCE_INFDEV].[dbo].[XIF_IFS_MMS_DATA] (
										[IF_TYPE]
										,[IF_ID]
										,[IF_INS_DATE]
										,[IF_FLAG]
										,[IF_SND_DATE]
										,[SUBJECT]
										,[PHONE]
										,[CALLBACK]
										,[STATUS]
										,[REQDATE]
										,[MSG]
									) VALUES (
										'S'
										,'OFP0_OSMS_MMS'
										,GETDATE()
										,'N'
										,NULL
										,( SELECT SEGMENT2 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
											WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
											  AND ACTIVE_FLAG = 'Y'
											  AND SEGMENT1 = @instance_id
											) + N' is plan released.' 
										,@PHONE_NUM
										,@PHONE_NUM
										,'0'
										,GETDATE()
										,@MSG
									)
								END
							ELSE
								BEGIN

							-- 2020-04-07 PIYONG ADD END
							--------------------------------------------------------------------------------------------------------------------------------

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
										,@MSG
									)
								END
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
					IF @instance_id LIKE 'KR%' AND LEN ( @MSG ) >= 80 -- 2020-04-07 PIYONG ADD  C20200405-000011 
						BEGIN
							INSERT INTO [LGCE_INFDEV].[dbo].[XIF_IFS_MMS_DATA] (
								[IF_TYPE]
								,[IF_ID]
								,[IF_INS_DATE]
								,[IF_FLAG]
								,[IF_SND_DATE]
								,[SUBJECT]
								,[PHONE]
								,[CALLBACK]
								,[STATUS]
								,[REQDATE]
								,[MSG]
							) VALUES (
								'S'
								,'OFP0_OSMS_MMS'
								,GETDATE()
								,'N'
								,NULL
								,( SELECT SEGMENT2 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
									WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
										AND ACTIVE_FLAG = 'Y'
										AND SEGMENT1 = @instance_id
									) + N' is plan released.' 
								,@PHONE_NUM
								,@PHONE_NUM
								,'0'
								,GETDATE()
								,@MSG
							)
						END
					ELSE
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
								,SUBSTRING(@MSG,1,80) -- 2020-04-07 PIYONG ADD
								/*					-- 2020-04-07 PIYONG DEL
								,SUBSTRING( ( SELECT SEGMENT2
												FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
											   WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												AND ACTIVE_FLAG = 'Y'
												AND SEGMENT1 = @instance_id
											) + N' is plan released. Reason : ' + (SELECT ISNULL([DESCRIPTION], '') 
																					 FROM [SCM_FP_PLAN_H]
																					WHERE [CONFIRM_FLAG] = 'Y'
																					  AND [INSTANCE_ID] = @instance_id
																					  AND [PLAN_ID] = @plan_id
																													), 1, 80 )
								*/
							)
						END

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
