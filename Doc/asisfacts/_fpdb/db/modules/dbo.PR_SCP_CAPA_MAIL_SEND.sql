
/*
 * Program ID   : SCP0049
 * Description  : SCP MAIL 발송 (Master < Supply Master < Capa ( NewModel Popup 요청)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/03/26   khj79      최초작성
 */


CREATE PROCEDURE [dbo].[PR_SCP_CAPA_MAIL_SEND]

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'

	DECLARE @v_mail_title		NVARCHAR(100);
	DECLARE @v_mail_la_title	NVARCHAR(100);
	DECLARE @v_mail_ty_title	NVARCHAR(100);
	DECLARE @v_head_cont		NVARCHAR(MAX);
	DECLARE @v_body_cont		NVARCHAR(MAX);
	DECLARE @v_body_text		NVARCHAR(MAX);
	DECLARE @v_body_la_text		NVARCHAR(MAX);
	DECLARE @v_body_ty_text		NVARCHAR(MAX);
	DECLARE @v_to_mail			NVARCHAR(MAX);
	DECLARE @TABLE_BODY			NVARCHAR(MAX);
	DECLARE @v_category_cont	NVARCHAR(100);

	-- mail 전송을 위한 변수 설정
	DECLARE @v_division_id		NVARCHAR(30);
	DECLARE @v_company_id		NVARCHAR(30);
	DECLARE @v_site_id			NVARCHAR(30);
	DECLARE @v_plant_id			NVARCHAR(30);
	DECLARE @v_factory_id		NVARCHAR(30);
	DECLARE @v_operation_id		NVARCHAR(30);
	DECLARE @v_line_id			NVARCHAR(30);
	DECLARE @v_electrode_type	NVARCHAR(30);
	DECLARE @v_item_id			NVARCHAR(30);
	DECLARE @v_lane_qty			NVARCHAR(30);
	DECLARE @v_loss_code		NVARCHAR(30);
	DECLARE @v_send_user_id		NVARCHAR(100);
	DECLARE @v_recv_user_id		NVARCHAR(100);
	DECLARE @v_recv_user_cnt	INTEGER = 0;
	DECLARE @v_recv_rank		INTEGER = 0;
	DECLARE @v_send_complete	INTEGER = 0;

	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_CAPA_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @sysdate            DATETIME2 = GETDATE();
	DECLARE @v_master_id        nvarchar(30)
	DECLARE @v_plan_id          nvarchar(30)
	DECLARE @v_descr            nvarchar(250)
	
	-- 제목과 , 문구 구분 없음
	--SET @v_mail_la_title	 = '[Request]Line Assign Update Request';
	--SET @v_mail_ty_title	 = '[Request]Tacttime/Yield Update Request';

	--SET @v_body_la_text	 = 'Please check and update Line assign data as below Line & Model.
							
	--						';

	--SET @v_body_ty_text	 = 'Please check and update Tacttime/Yield data as below Line & Model.
							
	--						';

	SET @v_mail_title	 = '[Request]Line Assign/Tacttime(DailyCapa)/Yield Update Request';

	SET @v_body_text	 = 'Please check and update Line Assign/Tacttime(DailyCapa)/Yield data as below Line & Model.
							
							';
	SET @v_master_id  = 'SCP_CAPA'
	SET @v_plan_id    = 'MAIL_' + CONVERT(nvarchar, GETDATE(), 112)


	SET @n_log_count = @n_log_count + 1
	SET @sysdate = GETDATE()

	EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_program_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

	BEGIN TRY

		/********************************************************************************
		* HEAD CONT 
		********************************************************************************/		
		SET @v_head_cont = '';
		SET @v_head_cont = @v_head_cont+ '<tr>'
		SET @v_head_cont = @v_head_cont+ '<th width=''160px''>' + 'Level1' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th width=''40px''>' + 'Div' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th width=''50px''>' + 'Site' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th width=''50px''>' + 'Plant' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th width=''70px''>' + 'Building' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th width=''70px''>' + 'Line' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th width=''70px''>' + 'Operation' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th width=''80px''>' + 'Electrode' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th >' + 'Material' + '</th>'
		SET @v_head_cont = @v_head_cont+ '</tr>'
	
	
		SET @v_body_cont = ''

		-- 전송 데이터 확인
		DECLARE tableCursor cursor FOR
		SELECT DIVISION_ID
			 , COMPANY_ID
			 , SITE_ID
			 , PLANT_ID
			 , FACTORY_ID
			 , LINE_ID
			 , ELECTRODE_TYPE
			 , OPERATION_ID
			 , ITEM_ID
			 , LANE_QTY
			 , LOSS_CODE
			 , SEND_USER_ID
			 , RECV_USER_ID
			 --, SUM(1) OVER(PARTITION BY LINE_ID , OPERATION_ID ,ELECTRODE_TYPE , RECV_USER_ID ) AS RECV_USER_CNT
			 --, RANK() OVER(PARTITION BY LINE_ID , OPERATION_ID ,ELECTRODE_TYPE , RECV_USER_ID ORDER BY ITEM_ID DESC) AS RECV_USER_RANK
			 , SUM(1) OVER(PARTITION BY LINE_ID , OPERATION_ID ,ELECTRODE_TYPE,RECV_USER_ID ) AS RECV_USER_CNT
			 , RANK() OVER(PARTITION BY LINE_ID , OPERATION_ID ,ELECTRODE_TYPE,RECV_USER_ID ORDER BY LOSS_CODE , ITEM_ID DESC) AS RECV_USER_RANK
		FROM (
				SELECT DISTINCT 
					   DIVISION_ID
					 , COMPANY_ID
					 , SITE_ID
					 , PLANT_ID
					 , FACTORY_ID
					 , LINE_ID
					 , ELECTRODE_TYPE
					 , OPERATION_ID
					 , ITEM_ID
					 , LANE_QTY
					 , LOSS_CODE
					 , SEND_USER_ID
					 , RECV_USER_ID
				  FROM SCM_CAPA_MAIL_SEND_H WITH(NOLOCK)
				 WHERE ISNULL(MAIL_SEND_YN,'N')  = 'N'
				) T
		 ORDER BY RECV_USER_ID
		;

		OPEN tableCursor
		FETCH NEXT FROM tableCursor INTO @v_division_id,@v_company_id  , @v_site_id , @v_plant_id , @v_factory_id , @v_line_id , @v_electrode_type
			, @v_operation_id , @v_item_id , @v_lane_qty , @v_loss_code , @v_send_user_id , @v_recv_user_id , @v_recv_user_cnt , @v_recv_rank
		
		
		WHILE @@FETCH_STATUS = 0
		BEGIN

			--SET @v_to_mail = @v_recv_user_id+'@lgensol.com';
			set @v_to_mail = 'khj79' + '@lgespartner.com';
			--set @v_to_mail = 'hseokjang' + '@lgensol.com';
			

			--IF @v_loss_code = 'LA001'
			--BEGIN
			--	SET @v_mail_title = @v_mail_la_title;
			--	SET @v_body_text = @v_body_la_text;
			--END
			--ELSE
			--BEGIN
			--	SET @v_mail_title = @v_mail_ty_title;
			--	SET @v_body_text = @v_body_ty_text;
			--END

			-- category(Level1) 설정
			IF @v_loss_code = 'LA001'
			BEGIN
				SET @v_category_cont = 'LINE ASSIGN';
			END
			ELSE IF @v_loss_code = 'LA002'
			BEGIN
				SET @v_category_cont = 'TACT TIME(DAILY CAPA)';
			END
			ELSE IF @v_loss_code = 'LA003'
			BEGIN
				SET @v_category_cont = 'YIELD';
			END

			SET @v_body_cont = @v_body_cont+ '<tr>'
			SET @v_body_cont = @v_body_cont+ '<td><b>' + REPLACE(ISNULL(@v_category_cont,''), CHAR(10),' ') + '</b></td>'
			SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>'
			SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_site_id,''), CHAR(10),' ') + '</td>'
			SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_plant_id,''), CHAR(10),' ') + '</td>'
			SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_factory_id,''), CHAR(10),' ') + '</td>'
			SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_line_id,''), CHAR(10),' ') + '</td>'
			SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_operation_id,''), CHAR(10),' ') + '</td>'
			SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_electrode_type,''), CHAR(10),' ') + '</td>'
			SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '</td>'
			SET @v_body_cont = @v_body_cont+ '</tr>'

			
			IF(@v_recv_user_cnt = @v_recv_rank) 
			BEGIN

				IF (@v_send_complete % 10 = 0)  -- 10건씩 DELAY
				BEGIN
					WAITFOR DELAY '00:00:05' -- FIVE seconds
				END

				SET @TABLE_BODY = ''
				SET @TABLE_BODY = ' <html>
										<head>
										<title>Untitled Document</title>
										<style>
											* {margin:0;padding:0;}
											body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
											table {border-collapse:collapse;width:790px;}
											table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
											table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
											table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
											table tbody td {padding:6px 8px;font-size:12px}
											table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
											.hori-table table thead td {text-align:center;padding:3px;}  
											.hori-table table tbody td {text-align:center;padding:3px;}
											.vertical-table, .hori-table {margin-bottom:20px;}
										</style>
										</head>
										<body>' +'</br>'+
												'<b>' + REPLACE(ISNULL(@v_body_text, ''), CHAR(10), '<br>') + '</b>' +

												'<b>   From :   ' + REPLACE(ISNULL(@v_send_user_id, ''), CHAR(10), '<br>') + '</b>' +
												--'<b>   to :   ' + REPLACE(ISNULL(@v_recv_user_id, ''), CHAR(10), '<br>') + '</b>' +
												'<br>'+
												'<br>'+
												'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
											'<table style=''border-top:2px solid #c8294b; width=790px;''>
											<thead>' + ISNULL(@v_head_cont,'') +'</thead>
											<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
											</div>
										</body>
								</html>'

				-- 운영 : GSCM_MAIL_PROD
				--PRINT @TABLE_BODY
				--PRINT @v_body_cont
				
				EXEC msdb.dbo.sp_send_dbmail
						@profile_name = 'GSCM_MAIL_TEST' 
						, @recipients = @v_to_mail
						, @subject    = @v_mail_title
						, @body       = @TABLE_BODY
						, @body_format = 'html'


				-- 메일 본문 내용 초기화
				SET @v_body_cont = '';

				DECLARE @v_mail_grp_id INTEGER = 0;

				SELECT @v_mail_grp_id = ISNULL(MAX(MAIL_GRP_ID),0) + 1
				  FROM SCM_CAPA_MAIL_SEND_H WITH(NOLOCK)
				;

				-- 전송 메일 update
				UPDATE SCM_CAPA_MAIL_SEND_H
				   SET MAIL_SEND_YN = 'Y'
					 , MAIL_SEND_TIME = SYSDATETIME()
					 , MAIL_GRP_ID = @v_mail_grp_id
				 WHERE LINE_ID			= @v_line_id
				   AND ELECTRODE_TYPE	= @v_electrode_type
				   AND OPERATION_ID		= @v_operation_id
				   --AND LOSS_CODE		= @v_loss_code
				   AND RECV_USER_ID		= @v_recv_user_id
				   AND ISNULL(MAIL_SEND_YN,'N') = 'N'

			END

			SET @v_send_complete = @v_send_complete + 1

			FETCH NEXT FROM tableCursor INTO @v_division_id,@v_company_id  , @v_site_id , @v_plant_id , @v_factory_id , @v_line_id , @v_electrode_type
			, @v_operation_id , @v_item_id , @v_lane_qty ,@v_loss_code ,  @v_send_user_id , @v_recv_user_id , @v_recv_user_cnt , @v_recv_rank

		END;

		-- 결과 코드 반환
		--SELECT  'S' AS result_code

		-- Cursor 종료
		CLOSE tableCursor
		DEALLOCATE tableCursor

	END TRY

	BEGIN CATCH
		BEGIN

		 -- Cursor 종료
		CLOSE tableCursor
		DEALLOCATE tableCursor

		SET @v_descr = ERROR_MESSAGE();
		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_program_name, null, 'ERROR', null, NULL, null,@v_descr

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;

		BEGIN
			DECLARE @v_error_message NVARCHAR(1000);
			SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);
		
		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END	
	END CATCH;

	EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_program_name, null, 'END', 999999, null, '############### End of procedure ###############', null
END
