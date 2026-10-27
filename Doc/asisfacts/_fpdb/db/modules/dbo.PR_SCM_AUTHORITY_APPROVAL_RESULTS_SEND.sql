
CREATE PROCEDURE [dbo].[PR_SCM_AUTHORITY_APPROVAL_RESULTS_SEND]

-- ================================================================================================
-- Program ID          : FP01888
-- Program Name        : PR_SCM_AUTHORITY_APPROVAL_RESULTS_SEND
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_AUTH_REQUEST_INFO_M
-- Destination Table   : XIF_IFS_SMS_DATA, SCM_SYS_LOOKUP_VALUE
--
-- Create(Update) Date : 2019.12.02
--						 2019.12.26 PIYONG 1.1
-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 SMS 전송 상태값 N 으로 설정
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_AUTHORITY_APPROVAL_RESULTS_SEND'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)


	DECLARE @TABLE_BODY            NVARCHAR(MAX)
	DECLARE @TABLE_CONTENTS        NVARCHAR(MAX) = ''
	DECLARE @MAIL_CONTENT          NVARCHAR(MAX)
	DECLARE @MAIL_TITLE            NVARCHAR(MAX)
	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)


	DECLARE @user_id					NVARCHAR(30)
	DECLARE @before_user_id				NVARCHAR(30) = ''
	DECLARE @menu_authority_id			NVARCHAR(30)
	DECLARE @before_menu_authority_id	NVARCHAR(30)
	DECLARE @instance_id				NVARCHAR(30)
	DECLARE @before_instance_id			NVARCHAR(30)
   	DECLARE @factory_id					NVARCHAR(150)
	DECLARE @before_factory_id			NVARCHAR(150)
	DECLARE @plan_group_id				NVARCHAR(30)
	DECLARE @before_plan_group_id		NVARCHAR(30)
	DECLARE @approval_flag				NVARCHAR(1)
	DECLARE @approval_result			NVARCHAR(30)

	DECLARE @release_notifiy_type		NVARCHAR(20)
	DECLARE @seq						NUMERIC(18, 0)
	DECLARE @description				NVARCHAR(200)


	DECLARE @menu_authority_cnt			NUMERIC(18, 0)
	DECLARE @instance_cnt				NUMERIC(18, 0)
	DECLARE @factory_cnt				NUMERIC(18, 0)
	DECLARE @plan_group_cnt				NUMERIC(18, 0)

	DECLARE @phone_num					NVARCHAR(20)
	DECLARE @msg						NVARCHAR(200)

	DECLARE @TEMP_INFO				TABLE (
											[USER_ID]				NVARCHAR(30)
											,[MENU_AUTHORITY_ID]	NVARCHAR(30)
											,[INSTANCE_ID]			NVARCHAR(30)
											,[FACTORY_ID]			NVARCHAR(30)
											,[PLAN_GROUP_ID]		NVARCHAR(30)
											,[APPROVAL_FLAG]		NVARCHAR(1)
											,[DESCRIPTION]			NVARCHAR(200)
										   )



	DECLARE CR_USER_AUTH CURSOR FOR
		SELECT [USER_ID]-- CASE WHEN [USER_ID] = 'TEST_03'THEN 'kimcd' ELSE  'piyong' END [USER_ID]
			   , [MENU_AUTHORITY_ID]
			   , [INSTANCE_ID]
   			   , [FACTORY_ID]
			   , [PLAN_GROUP_ID]
			   , [APPROVAL_FLAG]
			   , [RELEASE_NOTIFIY_TYPE]
			   , _SEQ AS SEQ
			   , [DESCRIPTION]
		  FROM FP_AUTH_REQUEST_INFO_M
		 WHERE RELEASE_APPLY_FLAG= 'N'	-- LOOK UP 등록 안된거
		   AND APPROVAL_FLAG != 'R'		-- 결제가 끝난거
		--   AND [USER_ID] IN ( 'TEST_03', 'TEST_04' )
		 ORDER BY [USER_ID]
			   ,_SEQ
			   , [MENU_AUTHORITY_ID]
			   , [INSTANCE_ID]
			   , [FACTORY_ID]
			   , [PLAN_GROUP_ID]
			   , [APPROVAL_FLAG]
			   , [RELEASE_NOTIFIY_TYPE]
			   , [DESCRIPTION]




	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================

			OPEN CR_USER_AUTH;
			FETCH NEXT FROM CR_USER_AUTH INTO @user_id
											  , @menu_authority_id
											  , @instance_id
   											  , @factory_id
											  , @plan_group_id
											  , @approval_flag
											  , @release_notifiy_type
											  , @seq
											  , @description
			;

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
					INSERT INTO @TEMP_INFO (
						[USER_ID]
						,[MENU_AUTHORITY_ID]
						,[INSTANCE_ID]
						,[FACTORY_ID]
						,[PLAN_GROUP_ID]
						,[APPROVAL_FLAG]
						,[DESCRIPTION]
					) VALUES (	
						@user_id
						,@menu_authority_id
						,@instance_id
						,@factory_id
						,@plan_group_id
						,@approval_flag
						,@description
					)

				IF @approval_flag = 'Y' AND @release_notifiy_type LIKE '%MAIL%'
					BEGIN

						MERGE INTO SCM_SYS_LOOKUP_VALUE A
						USING (
								SELECT @user_id+'@lgensol.com' AS [USER_ID]
								--SELECT 'lgda106@lgespartner.com' AS [USER_ID]
									   ,@instance_id AS [INSTANCE_ID]
									   ,@factory_id AS [FACTORY_ID]

							  ) B
						   ON (
								A.LOOKUP_TYPE_CODE	= 'SMS_ADDRESSEE'
								AND A.SEGMENT1		= 'PLAN_CONFIRM'
								AND A.SEGMENT3		= B.[FACTORY_ID]
								AND A.ATTRIBUTE2	= B.[INSTANCE_ID]
								AND A.ATTRIBUTE3	= B.[USER_ID]
							  )
							 WHEN MATCHED THEN
								UPDATE SET A.ACTIVE_FLAG		= 'N'--CASE WHEN @release_notifiy_type LIKE '%SMS%' THEN 'Y'ELSE 'N'END		--2019-12-26 PIYONG CHANGE

										   ,A.ATTRIBUTE4		= CASE WHEN @release_notifiy_type LIKE '%MAIL%' THEN 'Y'
																		   ELSE 'N'
																		   END
											
											,A.MODIFY_DATE		= GETDATE()
											,A.MODIFY_USER_ID	= 'PR_SCM_AUTHORITY_APPROVAL_RESULTS_SEND'
							 WHEN NOT MATCHED THEN
								INSERT (
									[LOOKUP_TYPE_CODE]
									,[SEGMENT1]
									,[SEGMENT2]
									,[SEGMENT3]
									,[SEGMENT4]
									,[SEGMENT5]
									,[ACTIVE_FLAG]
									,[CREATE_USER_ID]
									,[CREATE_DATE]
									,[MODIFY_USER_ID]
									,[MODIFY_DATE]
									,[ATTRIBUTE1]
									,[ATTRIBUTE2]
									,[ATTRIBUTE3]
									,[ATTRIBUTE4]
								) VALUES (
									'SMS_ADDRESSEE'
									,'PLAN_CONFIRM'
									,( 
									   SELECT MAX( CONVERT( NUMERIC, [SEGMENT2]) ) + 1
										 FROM SCM_SYS_LOOKUP_VALUE
										WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
										  AND SEGMENT1 = 'PLAN_CONFIRM'
									 )
									,@factory_id
									,'-'
									,'-'
									,'N'			-- CASE WHEN @release_notifiy_type LIKE '%SMS%' THEN 'Y' ELSE 'N' END		--2019-12-26 PIYONG CHANGE
									,'PR_SCM_AUTHORITY_APPROVAL_RESULTS_SEND'
									,GETDATE()
									,'PR_SCM_AUTHORITY_APPROVAL_RESULTS_SEND'
									,GETDATE()
									,NULL			--	[ATTRIBUTE1]	-- 전화번호
									,@instance_id	--	[ATTRIBUTE2]
									,B.[USER_ID]	--	[ATTRIBUTE3]	--MAIL
									,CASE WHEN @release_notifiy_type LIKE '%MAIL%' THEN 'Y' ELSE 'N' END
								)
						;

					END


				UPDATE FP_AUTH_REQUEST_INFO_M
				   SET RELEASE_APPLY_FLAG	= 'Y'
				 WHERE [USER_ID]			= @user_id
					AND [_SEQ]				= @seq
			  		AND [MENU_AUTHORITY_ID]	= @menu_authority_id
			   		AND [INSTANCE_ID]		= @instance_id
			   		AND [FACTORY_ID]		= @factory_id
			   		AND [PLAN_GROUP_ID]		= @plan_group_id
				;



				FETCH NEXT FROM CR_USER_AUTH INTO @user_id
												  , @menu_authority_id
												  , @instance_id
   												  , @factory_id
												  , @plan_group_id
												  , @approval_flag
												  , @release_notifiy_type
												  , @seq
 												  , @description
				;              

			END;

			CLOSE CR_USER_AUTH;
			DEALLOCATE CR_USER_AUTH;


			DECLARE CUR_MAIL CURSOR FOR
				SELECT [USER_ID]
					   ,[MENU_AUTHORITY_ID]
					   ,(SELECT SEGMENT2 FROM SCM_SYS_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID' AND SEGMENT1 = T.[INSTANCE_ID])  AS [INSTANCE_ID]
					   ,(SELECT CONCAT( FACTORY_NAME, ' ( ', FACTORY_ID, ' )' ) FROM SCM_FACTORY_M WHERE FACTORY_ID = T.[FACTORY_ID]) AS [FACTORY_ID]
					   ,[PLAN_GROUP_ID]
					   ,CASE WHEN [APPROVAL_FLAG] = 'Y' THEN 'Approval' ELSE 'Reject' END AS [APPROVAL_RESULT]
					   ,ISNULL([DESCRIPTION], '-') AS [DESCRIPTION]
					   ,COUNT(MENU_AUTHORITY_ID) OVER( PARTITION BY [USER_ID], [MENU_AUTHORITY_ID] ORDER BY [USER_ID], [MENU_AUTHORITY_ID] ) AS MENU_AUTHORITY_CNT
					   ,COUNT([FACTORY_ID]) OVER( PARTITION BY [USER_ID], [MENU_AUTHORITY_ID], [INSTANCE_ID]
													  ORDER BY [USER_ID], [MENU_AUTHORITY_ID], [INSTANCE_ID] ) AS INSTANCE_CNT
					   ,COUNT([FACTORY_ID]) OVER( PARTITION BY [USER_ID], [MENU_AUTHORITY_ID], [INSTANCE_ID], [FACTORY_ID]
													  ORDER BY [USER_ID], [MENU_AUTHORITY_ID], [INSTANCE_ID], [FACTORY_ID] ) AS FACTORY_CNT
					   ,COUNT([PLAN_GROUP_ID]) OVER( PARTITION BY [USER_ID], [MENU_AUTHORITY_ID], [INSTANCE_ID], [FACTORY_ID], [PLAN_GROUP_ID]
														 ORDER BY [USER_ID], [MENU_AUTHORITY_ID], [INSTANCE_ID], [FACTORY_ID], [PLAN_GROUP_ID] ) AS PLAN_GROUP_CNT
				  FROM @TEMP_INFO T
				  ORDER BY [USER_ID]
					   ,[MENU_AUTHORITY_ID]
					   ,[INSTANCE_ID]
					   ,[FACTORY_ID]
					   ,[PLAN_GROUP_ID]
					   ,[APPROVAL_FLAG]
						
			;


			SET @MAIL_TITLE = N'[Notification] FP System Authority Request Results'
			SET @MAIL_CONTENT = N''
			SET @MAIL_RECEIVER_LIST = ''
			SET @TABLE_CONTENTS = ''

			SET @before_menu_authority_id = ''
			SET @before_instance_id = ''
   			SET @before_factory_id = ''
			SET @before_plan_group_id = ''



			OPEN CUR_MAIL;
			FETCH NEXT FROM CUR_MAIL INTO @user_id
										  , @menu_authority_id
										  , @instance_id
   										  , @factory_id
										  , @plan_group_id
										  , @approval_result
 										  , @description
										  , @menu_authority_cnt
										  , @instance_cnt
										  , @factory_cnt
										  , @plan_group_cnt
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF @before_user_id = ''
						BEGIN
						 SET @before_user_id = @user_id
						END

					IF @before_plan_group_id = ''
						BEGIN
						 SET @before_plan_group_id = @plan_group_id
						END



					IF @user_id != @before_user_id
						BEGIN
							SET @TABLE_BODY = '  	<html>
								<head>
								<title>Untitled Document</title>
								<style>
   									* {margin:0;padding:0;}
   									body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
   									table {border-collapse:collapse;width:100%;}
   									table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
   									table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
   									table tbody th {border-left:1px solid #e1e1e1;text-align:left;padding:6px 8px;}
   									table tbody td {text-align:center;padding:6px 8px;}
   									table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;}
                                    .hori-table table thead td {text-align:center;padding:3px;}  
   									.hori-table table tbody td {text-align:center;padding:3px;}
   									.vertical-table, .hori-table {margin-bottom:20px;}
								</style>
								</head>
								<body>' +
								REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') --+ 'Report generated on : ' + CONVERT(VARCHAR(10), GETDATE(), 120)

   									+'<div class=''wrap''>
       									<div class=''hori-table''>
           									<table style=''border-top:2px solid #c8294b; width:1250px;''>
               									<thead>' 
													+'<tr>'
													+'	<th>Authority Type</th>'
													+'	<th>Instance</th>'
													+'	<th>Factory</th>'
													+'	<th>Plan Group</th>'
													+'	<th>Authority Status</th>'
													+'	<th>Description</th>'
													+'</tr>'
               									+'</thead>
               									<tbody>' + ISNULL(@TABLE_CONTENTS, '') + '</tbody>
											</table>
       									</div>
   									</div>
								</body>
								</html>'


							SET @MAIL_RECEIVER_LIST = @before_user_id+'@lgensol.com;'
							--SET @MAIL_RECEIVER_LIST = 'lgda106@lgespartner.com;'

							SET @before_user_id = @user_id;
							SET @before_menu_authority_id = ''
							SET @before_instance_id = ''
   							SET @before_factory_id = ''
							SET @before_plan_group_id = ''


							IF LEN(@TABLE_CONTENTS) > 0
								BEGIN

									IF @before_user_id = 'multishin'
									BEGIN
										EXEC msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
																 , @recipients             = @MAIL_RECEIVER_LIST
																 , @query_result_separator = ';'
																 , @subject                = @MAIL_TITLE
																 , @body                   = @TABLE_BODY
																 , @body_format            = 'html'

										
									END

									IF @before_user_id = 'hwanghg'
									BEGIN
										EXEC msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
																 , @recipients             = @MAIL_RECEIVER_LIST
																 , @query_result_separator = ';'
																 , @subject                = @MAIL_TITLE
																 , @body                   = @TABLE_BODY
																 , @body_format            = 'html'

										
									END

									--EXEC msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
									--							 , @recipients             = @MAIL_RECEIVER_LIST
									--							 , @query_result_separator = ';'
									--							 , @subject                = @MAIL_TITLE
									--							 , @body                   = @TABLE_BODY
									--							 , @body_format            = 'html'

									SET @TABLE_CONTENTS = '';
								 END
						END



	
					SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr>'

					IF @before_menu_authority_id != @menu_authority_id
						BEGIN
							SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@menu_authority_cnt AS nvarchar)+'''>'+@menu_authority_id+'</td>'
							SET @before_menu_authority_id = @menu_authority_id
						END

					IF @before_instance_id != @instance_id
						BEGIN
							SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td style="text-align:left;padding-left:10px;" ROWSPAN='''+CAST(@instance_cnt AS nvarchar)+'''>'+@instance_id+'</td>'
						END

					IF @before_factory_id != @factory_id AND @before_plan_group_id = @plan_group_id
						BEGIN
							SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td style="text-align:left;padding-left:10px;" ROWSPAN='''+CAST(@factory_cnt AS nvarchar)+'''>'+@factory_id+'</td>'
							SET @before_factory_id = @factory_id
						END
					ELSE IF @before_factory_id != @factory_id AND @before_plan_group_id != @plan_group_id
						BEGIN
							SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td style="text-align:left;padding-left:10px;" ROWSPAN='''+CAST(@factory_cnt AS nvarchar)+'''>'+@factory_id+'</td>'
							SET @before_factory_id = @factory_id
						END
					ELSE IF @before_instance_id != @instance_id AND @before_factory_id = @factory_id AND @before_plan_group_id != @plan_group_id
						BEGIN
							SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td style="text-align:left;padding-left:10px;">'+@factory_id+'</td>'
						END


					IF @before_instance_id != @instance_id				-- INSTANCE가 다르고 동은 같고 GROUP_ID가 다른데 1개 ROW를 데이터를 만들기 위해 위에서 변경 하지 않음
																		-- Assy-C/P(Nanjing-Mobile)   LGCNJ-Mobile #5 Building ( M7 )   Subminiature Cylindrical
																		-- Assy-EGL(Nanjing-Mobile)   LGCNJ-Mobile #5 Building ( M7 )   EGL 
						BEGIN											
							SET @before_instance_id = @instance_id
						END	


					IF @before_plan_group_id != @plan_group_id
						BEGIN
							SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@plan_group_cnt AS nvarchar)+'''>'+@plan_group_id+'</td>'
							SET @before_plan_group_id = @plan_group_id
						END
					ELSE
						BEGIN
							SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td>'+@plan_group_id+'</td>'
						END

					SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@approval_result+'</td>'
					SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td style="text-align:left;padding-left:10px;">'+@description+'</td>'


					SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'

					FETCH NEXT FROM CUR_MAIL INTO @user_id
												  , @menu_authority_id
												  , @instance_id
   												  , @factory_id
												  , @plan_group_id
												  , @approval_result
 												  , @description
												  , @menu_authority_cnt
												  , @instance_cnt
												  , @factory_cnt
												  , @plan_group_cnt
					;
				END;
			CLOSE CUR_MAIL;
			DEALLOCATE CUR_MAIL;


			IF LEN(@TABLE_CONTENTS) > 0
				BEGIN
					SET @TABLE_BODY = '  	<html>
								<head>
								<title>Untitled Document</title>
								<style>
   									* {margin:0;padding:0;}
   									body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
   									table {border-collapse:collapse;width:100%;}
   									table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
   									table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
   									table tbody th {border-left:1px solid #e1e1e1;text-align:left;padding:6px 8px;}
   									table tbody td {text-align:center;padding:6px 8px;}
   									table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;}
                                    .hori-table table thead td {text-align:center;padding:3px;}  
   									.hori-table table tbody td {text-align:center;padding:3px;}
   									.vertical-table, .hori-table {margin-bottom:20px;}
								</style>
								</head>
								<body>' +
								REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') --+ 'Report generated on : ' + CONVERT(VARCHAR(10), GETDATE(), 120)

   									+'<div class=''wrap''>
       									<div class=''hori-table''>
           									<table style=''border-top:2px solid #c8294b; width:1250px;''>
               									<thead>' 
													+'<tr>'
													+'	<th>Authority Type</th>'
													+'	<th>Instance</th>'
													+'	<th>Factory</th>'
													+'	<th>Plan Group</th>'
													+'	<th>Authority Status</th>'
													+'	<th>Description</th>'
													+'</tr>'
               									+'</thead>
               									<tbody>' + ISNULL(@TABLE_CONTENTS, '') + '</tbody>
											</table>
       									</div>
   									</div>
								</body>
								</html>'


					SET @MAIL_RECEIVER_LIST = @user_id+'@lgensol.com;'--+ISNULL( @MAIL_ADDR, '')
					--SET @MAIL_RECEIVER_LIST ='lgda106@lgespartner.com;'--+ISNULL( @MAIL_ADDR, '')

					--test
					if @user_id = 'hwanghg'
					begin
							EXEC msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
													, @recipients             = @MAIL_RECEIVER_LIST
													, @query_result_separator = ';'
													, @subject                = @MAIL_TITLE
													, @body                   = @TABLE_BODY
													, @body_format            = 'html'
					end

					if @user_id = 'multishin'
					begin
							EXEC msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
													, @recipients             = @MAIL_RECEIVER_LIST
													, @query_result_separator = ';'
													, @subject                = @MAIL_TITLE
													, @body                   = @TABLE_BODY
													, @body_format            = 'html'
					end

					--if @user_id = 'lgda106'
					--begin
					--		EXEC msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
					--								, @recipients             = @MAIL_RECEIVER_LIST
					--								, @query_result_separator = ';'
					--								, @subject                = @MAIL_TITLE
					--								, @body                   = @TABLE_BODY
					--								, @body_format            = 'html'
					--end

					--EXEC msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
					--								, @recipients             = @MAIL_RECEIVER_LIST
					--								, @query_result_separator = ';'
					--								, @subject                = @MAIL_TITLE
					--								, @body                   = @TABLE_BODY
					--								, @body_format            = 'html'

					SET @TABLE_CONTENTS = '';
				END


		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



