CREATE PROCEDURE [dbo].[PR_UI_XPCOMMON_AMEND_ALERT_MAIL_SMS_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_UI_XPCOMMON_AMEND_ALERT_MAIL_SMS_SEND
-- Param               :
-- Batch Period        : 1 hour
-- Description         : PIC ALARM MAILING & TEXTING
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : FP_AMEND_MEMO_M
-- Destination Table   : 
--
-- Create Date		   : 2022.06.20


-- Author              : 
-- Version             : 1.0

-- ================================================================================================
-- PARAMETER

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_UI_XPCOMMON_AMEND_ALERT_MAIL_SMS_SEND'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()



	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	


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
			BEGIN
				DECLARE @ROWCOUNT				INTEGER
				SET @ROWCOUNT = @@ROWCOUNT
				DECLARE @TABLE_BODY            NVARCHAR(MAX)
				DECLARE @TABLE_CONTENTS        NVARCHAR(MAX) = ''
				--	DECLARE @TABLE_HEAD_CONTENT    NVARCHAR(MAX)
				DECLARE @MAIL_CONTENT          NVARCHAR(MAX)
				DECLARE @MAIL_TITLE            NVARCHAR(MAX)

				DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)

				DECLARE @INSTANCE_ID			NVARCHAR(20)
				DECLARE @MAIL_ADDR				NVARCHAR(MAX)

				--DECLARE @MONTH					NVARCHAR(10)
				--DECLARE @WEEK					NVARCHAR(10)
				DECLARE @DIVISION_ID			NVARCHAR(100)
				--DECLARE @INSTANCE_NAME			NVARCHAR(1000)
				DECLARE @MPP_SEND_YN			NVARCHAR(1)
				DECLARE @WPP_SEND_YN			NVARCHAR(1)

				DECLARE @PHONE_NUM	NVARCHAR(50)
				DECLARE @MAIL	NVARCHAR(MAX)
				DECLARE @USERNAME	NVARCHAR(50)
				DECLARE @DEPTNAME	NVARCHAR(50)
				DECLARE @MEMO NVARCHAR(500)
				DECLARE @ALARM_TIME DATETIME
				DECLARE @PIC_REF NVARCHAR(50)

				DECLARE @COMPANY_ID NVARCHAR(500)
				DECLARE @PLANT_ID NVARCHAR(500)
				DECLARE @FACTORY_ID NVARCHAR(500)
				DECLARE @OPERATION_ID NVARCHAR(500)
				DECLARE @LINE_ID NVARCHAR(500)
				DECLARE @ELECTROD_TYPE NVARCHAR(50)
				DECLARE @EQUIPMENT_ID NVARCHAR(50)
				DECLARE @SITE_ID NVARCHAR(50)

				DECLARE @PLAN_DATE NVARCHAR(50)
				DECLARE @MARKET NVARCHAR(50)
				DECLARE @PRODUCTION_TYPE NVARCHAR(50)

				DECLARE @TOP_ITEM_ID NVARCHAR(MAX)
				DECLARE @ITEM_ID NVARCHAR(MAX)

				DECLARE @ITEM_NAME NVARCHAR(MAX)
				DECLARE @NICK_NAME NVARCHAR(MAX)
				DECLARE @LINE_NAME NVARCHAR(MAX)

				DECLARE @ALARM_YN NVARCHAR(100)

				DECLARE @EMAIL_TITLE NVARCHAR(100)
				DECLARE @EMAIL_TEXT NVARCHAR(500)

				DECLARE @DEBUG NVARCHAR(MAX)
				DECLARE @GAP int
				DECLARE @NUM_CHECK int


											--	exec msdb.dbo.sp_send_dbmail @profile_name           =  'FP_MAIL_TEST'
											--					, @recipients             = 'chkim.68@lgespartner.com'   
											--					, @query_result_separator = ';'
											--					, @subject               = N'BATCH WORKING'--@EMAIL_TITLE
											--					, @body                   = N'BATCH WORKING'--@TABLE_BODY
											--					, @body_format            = 'html'

				        --SET @DEBUG = '---'
		--print @DEBUG
				DECLARE CUR_SMS_EMAIL CURSOR FOR

				-- MAKE CURSOR
   					SELECT DATEDIFF(hh, GetDate(),ALARM_TIME),M.ALARM_YN, M.PIC_REF,M.MEMO,M.ALARM_TIME,
					M.INSTANCE_ID, M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.FACTORY_ID, M.OPERATION_ID, M.LINE_ID, 
					M.ELECTRODE_TYPE, M.EQUIPMENT_ID, M.PLAN_DATE, M.MARKET, M.PRODUCTION_TYPE, 
					M.TOP_ITEM_ID, M.ITEM_ID,MAX(SM.ITEM_NAME),MAX(SM.NICK_NAME),MAX(LM.LINE_NAME)
					
					FROM FP_AMEND_MEMO_M M  WITH(NOLOCK)
					INNER JOIN FP_AMEND_PIC_ALARM A  WITH(NOLOCK) ON M.PIC_REF = A.PIC_REF AND ISNULL(M.PIC_REF,'') <> ''
					INNER JOIN SCM_ITEM_M SM WITH(NOLOCK)  ON M.ITEM_ID = SM.ITEM_ID AND ISNULL(M.ALARM_YN,'') <> 'Y'
					INNER JOIN SCM_LINE_M LM WITH(NOLOCK)  ON M.LINE_ID = LM.LINE_ID AND ISNULL(M.ALARM_YN,'') <> 'Y'
					--INNER JOIN SCM_ITEM_M SM ON M.ITEM_ID = SM.ITEM_ID
					WHERE 
					DATEDIFF(hh, GetDate(),M.ALARM_TIME) > -1000 AND 
					--ISNULL(CONVERT(CHAR(8), M.ALARM_TIME, 112),'') = CONVERT(CHAR(8), GetDate(), 112) AND 
					ISNULL(M.ALARM_YN,'') <> 'Y'
					GROUP BY M.PIC_REF,M.MEMO,M.ALARM_TIME,M.ALARM_YN,
					M.INSTANCE_ID, M.COMPANY_ID, M.DIVISION_ID, M.SITE_ID, M.PLANT_ID, M.FACTORY_ID, M.OPERATION_ID, M.LINE_ID, 
					M.ELECTRODE_TYPE, M.EQUIPMENT_ID, M.PLAN_DATE, M.MARKET, M.PRODUCTION_TYPE, 
					M.TOP_ITEM_ID, M.ITEM_ID
				-- END OF MAKE CURSOR

				-- OPEN CURSOR
				OPEN CUR_SMS_EMAIL;
				FETCH NEXT FROM CUR_SMS_EMAIL INTO @GAP,@ALARM_YN, @PIC_REF,@MEMO,@ALARM_TIME,
				@iNSTANCE_ID, @COMPANY_ID, @DIVISION_ID, @SITE_ID, @PLANT_ID, @FACTORY_ID, @OPERATION_ID, @LINE_ID, 
				@ELECTROD_TYPE, @EQUIPMENT_ID, @PLAN_DATE, @MARKET, @PRODUCTION_TYPE, 
				@TOP_ITEM_ID, @ITEM_ID,@ITEM_NAME,@NICK_NAME,@LINE_NAME					
				-- END OF OPEN CURSOR
					--FETCH NEXT FROM CUR_SMS_EMAIL INTO @MAIL,@PHONE_NUM,@DEPTNAME,@USERNAME,@MEMO,@ALARM_TIME,
					--@iNSTANCE_ID, @COMPANY_ID, @DIVISION_ID, @SITE_ID, @PLANT_ID, @FACTORY_ID, @OPERATION_ID, @LINE_ID, 
					--@ELECTROD_TYPE, @EQUIPMENT_ID, @PLAN_DATE, @MARKET, @PRODUCTION_TYPE, 
					--@TOP_ITEM_ID, @ITEM_ID					
					;
					
				-- ITERATE CURSOR
				WHILE (@@FETCH_STATUS = 0)
				BEGIN
					-- STUFF MAILING LIST					
					SELECT @MAIL = STUFF((SELECT ';' + EMAIL FROM FP_AMEND_PIC_ALARM WHERE PIC_REF = A.PIC_REF FOR XML PATH('')),1,1,'')  
					FROM FP_AMEND_PIC_ALARM A WITH(NOLOCK) WHERE PIC_REF = @PIC_REF
					GROUP BY A.PIC_REF 
					-- STUFF PHONE NUMER (ROW PHONE NUMBER
					SELECT @PHONE_NUM = STUFF((SELECT ';' + PHONE FROM FP_AMEND_PIC_ALARM WHERE PIC_REF = A.PIC_REF FOR XML PATH('')),1,1,'')  
					FROM FP_AMEND_PIC_ALARM A  WITH(NOLOCK) WHERE PIC_REF = @PIC_REF
					GROUP BY A.PIC_REF 

					--print @MAIL
					--print ISNULL(CONVERT(CHAR(8), @ALARM_TIME, 112),'')
					--print 'ALARM_TIME:' + ISNULL(CONVERT(CHAR(19), @ALARM_TIME, 120),'')
					--print 'CURRENT TIME:' + ISNULL(CONVERT(CHAR(19), GetDate(), 120),'')
					SET @ALARM_YN = ISNULL(@ALARM_YN,'N')
					-- CALCULATE TIME GAP
					--SELECT @GAP = DATEDIFF(hh, GetDate(),@ALARM_TIME)
					--print @GAP
					--print @PIC_REF
					--print @MEMO
					--print @PHONE_NUM
					-- 일주일, 1일, 4시간전 알람
					-- 이미 경과한 경우, 그사이 발생하지 않는 것으로 보고 알람을 때려준다.
					IF 
					((@GAP <= 24 * 7) AND (@GAP > 24) AND @ALARM_YN<>'W') --W는 이미 발송한 상태
					OR 
					((@GAP <= 24) AND (@GAP >4) AND @ALARM_YN<>'D')  -- D는 이미 발송한 상태
					OR
					((@GAP <= 4) AND @GAP > -24 * 7)-- AND @GAP >0) -- Y는 이미 발송한 상태
					BEGIN
					--print 'xxx' + @MAIL +'xxxx'
						--SET @MAIL = ''
						IF ISNULL(@MAIL,'') <> ''
						BEGIN

							SET @EMAIL_TITLE = N''
							SET @EMAIL_TEXT = N''
							--SET @EMAIL_TITLE += N'Prodcution alarm for ' + @item_id + ' of ' + @line_id + ' at ' +  ISNULL(CONVERT(CHAR(8), @ALARM_TIME, 112),'')+char(10)
							--SET @EMAIL_TITLE += @item_id + N' 모델 '+ISNULL(CONVERT(CHAR(8), @ALARM_TIME, 112),'')+ N' 시생산 예정 사전 알람'
							SET @EMAIL_TITLE += N'[일정알림]시생산/TEST('+ISNULL(CONVERT(CHAR(19), @ALARM_TIME, 120),'') + ')'
							--print @EMAIL_TITLE
							--SET @EMAIL_TEXT += N'Dear Mr(Ms) ' + @USERNAME + char(10)
							--SET @EMAIL_TEXT += 'We have a production schedule as follow' + char(10)+ char(10)
							--SET @EMAIL_TEXT += '----- PIC ALARM -----'+char(10)
							--SET @EMAIL_TEXT += @item_id + ' of ' +@top_item_id + '(' + @production_type + ')' +' at ' + @line_id + char(10)
							--SET @EMAIL_TEXT += '----- with following memo -----'+char(10)
							--SET @EMAIL_TEXT += @memo+ char(10)+ char(10)
							--SET @EMAIL_TEXT += '----- detail -----'+char(10)
							--SET @EMAIL_TEXT += 'MODEL:' + @top_item_id+ char(10)
							--SET @EMAIL_TEXT += 'MATERIAL:' + @item_id+ char(10)
							--SET @EMAIL_TEXT += 'INSTANCE:' + @instance_id+ char(10)
							--SET @EMAIL_TEXT += 'COMPNAY:' + @company_id+ char(10)
							--SET @EMAIL_TEXT += 'DIVISION:' + @division_id+ char(10)
							--SET @EMAIL_TEXT += 'SITE:' + @site_id+ char(10)
							--SET @EMAIL_TEXT += 'PLANT:' + @plant_id+ char(10)
							--SET @EMAIL_TEXT += 'BUILDING:' + @factory_id+ char(10)
							--SET @EMAIL_TEXT += 'OPERATION:' + @operation_id+ char(10)
							--SET @EMAIL_TEXT += 'ELECTROD TYPE:' + @electrod_type+ char(10)
							--SET @EMAIL_TEXT += 'EQUIPMENT:' + @EQUIPMENT_ID+ char(10)
							--SET @EMAIL_TEXT += 'PLANT DATE:' + @plan_date+ char(10)
							--SET @EMAIL_TEXT += 'MARKET:' + @market+ char(10)
							--SET @EMAIL_TEXT += 'PRODUCTION TYPE:' + @production_type

							SET @EMAIL_TEXT = N'해당 시생산/TEST 일정 알림은 FP 시스템에 등록된 기준으로 발송하며,'+char(10)
							SET @EMAIL_TEXT += N'실제 시점과 차이가 있을 수 있습니다'+char(10)
							SET @EMAIL_TEXT += N'실행에 문제없도록 유관 부서와 사전 점검 및 준비하여 진행 부탁드립니다'+char(10)
							SET @EMAIL_TEXT += N'(본 메일은 FP 시스템 등록 기준 1주전, 1일전, 4시간 전 발송합니다)' +char(10)+char(10)


							--SET @EMAIL_TEXT = N'요청하신 ' + @item_id+N'모 델의 시생산이 ' + ISNULL(CONVERT(CHAR(8), @ALARM_TIME, 112),'') +char(10)
							--SET @EMAIL_TEXT += N'로 예정되어 알려드립니다. 해당 일정에 반드시 참관하시기 바랍니다' +char(10)
							--SET @EMAIL_TEXT += N'(본 메일은 1주전, 1일전, 4시간 전 발송합니다)' +char(10)+char(10)
							SET @EMAIL_TEXT += N'메모:'+char(10) + @memo +char(10)+char(10)
							SET @EMAIL_TEXT += N'정보:'							   

							SET @TABLE_BODY = '<html>
							<head>
							<title>Untitled Document</title>
							</head>
							<body>' +
							REPLACE(ISNULL(@EMAIL_TEXT, ''), CHAR(10), '<br>') + N'
   								<div class=''wrap''>
       								<div class=''hori-table''>
           								<table style=''border-top:2px solid #c8294b;border-bottom:2px solid #c8294b; width:1020px;''>
               								<thead>' 
												+N'<tr>
													<th>Model</th>
													<th>Nick Name</th>
													<th>Material</th>
													<th>Line</th>
													<th>Sample Production Time</th>
												</tr>
											'
               								+N'</thead>
               								<tbody>
<tr>
<td style=''text-align:center''>'+ ISNULL(@top_item_id,'') +'</td>
<td style=''text-align:center''>'+ ISNULL(@nick_name,'') + ' </td>
<td style=''text-align:center''>'+ ISNULL(@item_name,'') +'('+ISNULL(@item_id,'') + ') </td>
<td style=''text-align:center''>' +ISNULL(@line_name,'') + '('+ ISNULL(@line_id,'') +') </td>
<td style=''text-align:center''>' + ISNULL(CONVERT(CHAR(19), @ALARM_TIME, 120),'') + '</td>
</tr>
' + ISNULL(@TABLE_CONTENTS, '') + '</tbody>
										</table>
       								</div>
   								</div>
							</body>
							</html>'

							--print @EMAIL_TITLE
							--print @EMAIL_TEXT
				--print @TABLE_BODY
							SET @MAIL_RECEIVER_LIST = @MAIL--'chkim.68@lgespartner.com'         
							SET @MAIL_RECEIVER_LIST +=';chkim.68@lgespartner.com'   
							--SET @TABLE_BODY = ''
							IF LEN(@TABLE_BODY) > 0
							BEGIN

												DECLARE @SUBJECT NVARCHAR(100) = @EMAIL_TITLE--N'XXXX 모델 #월#일 시생산 예정 사전 알람'--@EMAIL_TITLE[ERROR] [LIVE] TEST'
							--DECLARE @RECEIVE NVARCHAR(1000) = 'chkim.68@lgespartner.com'--kimseok@lgchem.com'		
										--SET @MAIL_RECEIVER_LIST = 'chkim.68@lgespartner.com'

								exec msdb.dbo.sp_send_dbmail @profile_name           =  'FP_MAIL_TEST'
																, @recipients             = @MAIL_RECEIVER_LIST
																, @query_result_separator = ';'
																, @subject                = @EMAIL_TITLE
																, @body                   = @TABLE_BODY
																, @body_format            = 'html'
								SET @EMAIL_TITLE = N'발송결과:'+@EMAIL_TITLE 
								SET @TABLE_BODY = 'To:' +@MAIL_RECEIVER_LIST + char(10) + @TABLE_BODY
								exec msdb.dbo.sp_send_dbmail @profile_name           =  'FP_MAIL_TEST'
																, @recipients             = 'chkim.68@lgespartner.com'   
																, @query_result_separator = ';'
																, @subject                = @EMAIL_TITLE
																, @body                   = @TABLE_BODY
																, @body_format            = 'html'
																--print @EMAIL_TITLE
																--print @TABLE_BODY
							--print 'send mail to :' + @MAIL_RECEIVER_LIST
							END
						END

						--SET @PHONE_NUM = '010-7506-6732'
						IF ISNULL(@PHONE_NUM,'')<> ''
						BEGIN

						SET @EMAIL_TEXT = N'요청하신 ' + @item_id+N' 모델의 시생산이 ' + ISNULL(CONVERT(CHAR(19), @ALARM_TIME, 120),'') 
						+N'로 예정되어 알려드립니다. 해당 일정에 반드시 참관하시기 바랍니다'+char(10)
						--print @EMAIL_TEXT

						IF @instance_id LIKE 'CN%' BEGIN

						INSERT INTO [SY_XIF_IFS_SMS_DATA]
							(
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
							)	
							SELECT 								   
							'S'	-- [IF_TYPE]
							,'OFP0_OSMS_SMS'	--,[IF_ID]
							,GETDATE()	--,[IF_INS_DATE]
							,'N'	--,[IF_FLAG]
							,NULL	--,[IF_SND_DATE]
							,'0'	--,[TR_SENDSTAT]
							,'0'	--,[TR_MSGTYPE]
							,REPLACE(PHONE,'-','') 	--,[TR_PHONE]
							,REPLACE(PHONE,'-','')	--,[TR_CALLBACK]
							,@EMAIL_TEXT	--,[TR_MSG]								   
							FROM FP_AMEND_PIC_ALARM  WITH(NOLOCK)
							WHERE 
								PIC_REF = @PIC_REF AND
								ISNULL(PHONE,'') <> '' AND
								ISNUMERIC(ISNULL(REPLACE(PHONE,'-',''),'')) = 1 AND
								LEN(ISNULL(PHONE,'')) > 9							   
							--print 'SEND SMS to ' + @PHONE_NUM 

						END
						END ELSE IF @instance_id LIKE 'KR%' BEGIN
								IF LEN ( @EMAIL_TEXT ) >= 80
								BEGIN
									-- INSERT INTO [LGCE_INF].[dbo].[XIF_IFS_MMS_DATA] (-- 운영
									INSERT INTO [LGCE_INFDEV].[dbo].[XIF_IFS_MMS_DATA] (-- 개발
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
									)
									--VALUES (
									--	'S'
									--	,'OFP0_OSMS_MMS'
									--	,GETDATE()
									--	,'N'
									--	,NULL
									--	, N'시생산 일정알림' 
									--	,@PHONE_NUM
									--	,@PHONE_NUM
									--	,'0'
									--	,GETDATE()
									--	,@EMAIL_TEXT
									--)
																SELECT 								   
							'S'	-- [IF_TYPE]
							,'OFP0_OSMS_MMS'	--,[IF_ID]
							,GETDATE()	--,[IF_INS_DATE]
							,'N'	--,[IF_FLAG]
							,NULL	--,[IF_SND_DATE]
							, N'시생산 일정알림' 
							,REPLACE(PHONE,'-','') 	--,[TR_PHONE]
							,'0'
							,GETDATE()
							,REPLACE(PHONE,'-','')	--,[TR_CALLBACK]
							,@EMAIL_TEXT	--,[TR_MSG]								   
							FROM FP_AMEND_PIC_ALARM  WITH(NOLOCK)
							WHERE 
								PIC_REF = @PIC_REF AND
								ISNULL(PHONE,'') <> '' AND
								ISNUMERIC(ISNULL(REPLACE(PHONE,'-',''),'')) = 1 AND
								LEN(ISNULL(PHONE,'')) > 9				
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
									) 
									--VALUES (
									--	'S'
									--	,'OFP0_OSMS_SMS'
									--	,GETDATE()
									--	,'N'
									--	,NULL
									--	,'0'
									--	,'0'
									--	,@PHONE_NUM
									--	,@PHONE_NUM
									--	,@EMAIL_TEXT
									--)

							SELECT 								   
							'S'	-- [IF_TYPE]
							,'OFP0_OSMS_MMS'	--,[IF_ID]
							,GETDATE()	--,[IF_INS_DATE]
							,'N'	--,[IF_FLAG]
							,NULL	--,[IF_SND_DATE]
							,'0'
							,'0'
							,REPLACE(PHONE,'-','') 	--,[TR_PHONE]
							,REPLACE(PHONE,'-','')	--,[TR_CALLBACK]
							,@EMAIL_TEXT	--,[TR_MSG]								   
							FROM FP_AMEND_PIC_ALARM  WITH(NOLOCK)
							WHERE 
								PIC_REF = @PIC_REF AND
								ISNULL(PHONE,'') <> '' AND
								ISNUMERIC(ISNULL(REPLACE(PHONE,'-',''),'')) = 1 AND
								LEN(ISNULL(PHONE,'')) > 9				
								END
						END

						-- 모두 보냈으므로 알람 완료로 변경
						IF ((@GAP <= 24 * 7) AND (@GAP > 24)) BEGIN
							UPDATE FP_AMEND_MEMO_M SET ALARM_YN = 'W',LAST_ALARM=GetDate()  WHERE PIC_REF = @PIC_REF
						END ELSE IF ((@GAP <= 24) AND (@GAP >4))  BEGIN
							UPDATE FP_AMEND_MEMO_M SET ALARM_YN = 'D',LAST_ALARM=GetDate()    WHERE PIC_REF = @PIC_REF
						END ELSE IF ((@GAP <= 4) AND @GAP > -24 * 7) BEGIN -- AND @GAP >0 BEGIN
							UPDATE FP_AMEND_MEMO_M SET ALARM_YN = 'Y',LAST_ALARM=GetDate()    WHERE PIC_REF = @PIC_REF
						END

					END -- END OF GAP

					FETCH NEXT FROM CUR_SMS_EMAIL INTO @GAP,@ALARM_YN, @PIC_REF,@MEMO,@ALARM_TIME,
			@iNSTANCE_ID, @COMPANY_ID, @DIVISION_ID, @SITE_ID, @PLANT_ID, @FACTORY_ID, @OPERATION_ID, @LINE_ID, 
			@ELECTROD_TYPE, @EQUIPMENT_ID, @PLAN_DATE, @MARKET, @PRODUCTION_TYPE, 
			@TOP_ITEM_ID, @ITEM_ID	,@ITEM_NAME,@NICK_NAME,@LINE_NAME
			--		FETCH NEXT FROM CUR_SMS_EMAIL INTO @MAIL,@PHONE_NUM,@DEPTNAME,@USERNAME,@MEMO,@ALARM_TIME,
			--@iNSTANCE_ID, @COMPANY_ID, @DIVISION_ID, @SITE_ID, @PLANT_ID, @FACTORY_ID, @OPERATION_ID, @LINE_ID, 
			--@ELECTROD_TYPE, @EQUIPMENT_ID, @PLAN_DATE, @MARKET, @PRODUCTION_TYPE, 
			--@TOP_ITEM_ID, @ITEM_ID	
			;
				END;

					CLOSE CUR_SMS_EMAIL;
					DEALLOCATE CUR_SMS_EMAIL;
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
