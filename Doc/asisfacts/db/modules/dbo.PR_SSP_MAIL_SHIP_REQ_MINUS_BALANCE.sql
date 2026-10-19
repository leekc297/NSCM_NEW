
/*
 * Program ID   : PR_SSP_SHIP_REQ_MINUS_BALANCE_MAIL_SEND
 * Description  : SSP MAIL 발송 (Ship_Req_Minus_Balance_Mail_Send)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/06/12	mcTheJ			[CSR ID:4016810] [요청] SSP Planning Horizen 연장에 따른 Shipment Request Logic 변경
								- Balance 음수일 때 메일
								- Shipment Request 마이너스 재고(Balance)에 대한 조정기간별 메일 발송
 * 2019/06.21	mcTheJ			profile name 수정, mail log  title 추가
--Exec PR_SSP_SHIP_REQ_MINUS_BALANCE_MAIL_SEND;
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE]
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_mail_title						NVARCHAR(100);
	DECLARE @v_head_cont						NVARCHAR(MAX);
	DECLARE @v_body_cont						NVARCHAR(MAX);
	DECLARE @v_body_text						NVARCHAR(MAX);
	DECLARE @v_to_mail							NVARCHAR(MAX);
	DECLARE @v_to_mail_back						NVARCHAR(MAX);
	DECLARE @TABLE_BODY							NVARCHAR(MAX);
	DECLARE @v_month_name						NVARCHAR(10);

	DECLARE @v_mail_receiver					NVARCHAR(600);
	DECLARE @v_division_id						NVARCHAR(30);
	DECLARE @v_from_site						NVARCHAR(30);
	DECLARE @v_from_site_description			NVARCHAR(MAX);
	DECLARE @v_item_id							NVARCHAR(50);
	DECLARE @v_nick_name						NVARCHAR(50);
	DECLARE @v_requestor						NVARCHAR(MAX);
	DECLARE @v_to_site							NVARCHAR(30);
	DECLARE @v_to_site_description				NVARCHAR(MAX);
	DECLARE @v_end_customer						NVARCHAR(MAX);
	DECLARE @v_fcst_type						NVARCHAR(MAX);
	DECLARE @v_incoterms						NVARCHAR(10);
	DECLARE @v_transport_mode					NVARCHAR(50);
	DECLARE @v_yyyymmdd							NVARCHAR(10);
	DECLARE @v_qty								NVARCHAR(MAX);
	
	-- LOG 용 변수 설정
	DECLARE @v_program_name						NVARCHAR(150) = 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE';
	DECLARE @v_log_type							NVARCHAR(30); -- START/END/ERROR/...
	DECLARE @n_log_count						INTEGER = 0;
	DECLARE @v_log_message						NVARCHAR(1000);
	DECLARE @v_description						NVARCHAR(500);
	DECLARE @d_event_date						DATETIME;

	--계산용 변수
	DECLARE @v_receiver_cnt						INT = 0;	--총 수신자 명
	DECLARE @v_mail_data_cnt					INT = 0;	--메일 Data 총 건수
	DECLARE @v_receiver_loop_cnt				INT = 0;	--수신자 비교 변수
	DECLARE @v_mail_data_loop_cnt				INT = 0;	--메일 Data 비교 변수
	DECLARE @v_datechk							INT = 0;	--조정기간 Data 체크 건수
	DECLARE @v_mail_cnt_chk						INT = 0;	--메일 View에 Data 있는지 체크 건수
	DECLARE @mailSendCnt						INT = 0;
	DECLARE @v_tmp_receiver						NVARCHAR(MAX) = '' --수신자 임시 변수

	--임시Table 삭제-------------------------------------------------
	IF OBJECT_ID('tempdb..#TblSSPShip_Request_Mail') IS NOT NULL
			DROP TABLE #TblSSPShip_Request_Mail
	-----------------------------------------------------------------

	--S : 현재 일자-----------------------------------------------------------
	DECLARE @v_Now_Date		 NVARCHAR(8);
	SET @v_now_date = Convert(NVARCHAR(8), GetDate(), 112);

	--------------------------------------------------------------------------

	--Confirm 기간------------------------------------------------------------
	DECLARE @v_confirm_start_date	NVARCHAR(10);
	--------------------------------------------------------------------------

	--현재 날짜에 대한 조정기간인지 체크---------------------------------------
	SELECT 
		@v_datechk = COUNT(*), @v_confirm_start_date = MAX(T.CONFIRM_START_DATE)
	FROM 
	(
		SELECT MAX(PLAN_START_YYYYMMDD) AS PLAN_START_YYYYMMDD, CONFIRM_START_DATE
		FROM SSP_MST_SHIP_REQ
		WHERE 1 = 1
		  AND CUTOFF_FLAG = 'Y'
		  AND CONFIRM_FLAG = 'N'
		  AND @v_now_date BETWEEN REQ_START_DATE AND REQ_END_DATE
		GROUP BY CONFIRM_START_DATE
	) T;
	----------------------------------------------------------------------------
	--현재일자가 조정기간이 아니면 Return
	IF @v_datechk = 0
	BEGIN
		RETURN;
	END;
	--------------------------------------
	--메일 발송에 필요한 영문 월명 찾기
	SET @v_month_name = (SELECT TOP 1 MONTH_FULL_NAME FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE 1 = 1 AND BASIS_YYYYMMDD = @v_confirm_start_date);
	--------------------------------------


	--메일 View에 Data 있는지 체크
	SELECT 
		@v_mail_cnt_chk = COUNT(*)
	FROM SSP_MAIL_SHIP_REQ_MINUS_BALANCE_V WITH(NOLOCK)
	WHERE 1 = 1
    ;

	IF @v_mail_cnt_chk = 0
	BEGIN
		RETURN;
	END;
	------------------------------

	--메일 수신자별 Index Data Temp Table------------------------------------------------------------------
	SELECT 
		T0.*	   
	INTO #TblSSPShip_Request_Mail
	FROM 
	(
		SELECT
			DENSE_RANK() OVER (ORDER BY MAIL_RECEIVER) AS Receiver_Num,
			ROW_NUMBER() OVER (PARTITION BY MAIL_RECEIVER ORDER BY MAIL_RECEIVER, DIVISION_ID, FROM_SITE, ITEM_ID , REQUESTOR, TO_SITE, END_CUSTOMER, FCST_TYPE, INCOTERMS, TRANSPORT_MODE ,YYYYMMDD) AS Data_Num,
			*
		FROM SSP_MAIL_SHIP_REQ_MINUS_BALANCE_V WITH(NOLOCK)

	) T0;
	------------------------------------------------------------------------------------

	/********************************************************************************
	* MAIL TITLE
	********************************************************************************/
	SET @v_mail_title	 = '[Notice]Insufficient stock for ' + @v_month_name + '(next month) shipping request(will be deleted soon)';
	/********************************************************************************/

	/********************************************************************************
	* HEAD CONT 
	********************************************************************************/		
	SET @v_head_cont = '';
	SET @v_head_cont = @v_head_cont+ '<tr>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Div' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''100px''>' + 'From Site' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Model' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Nick Name' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Requestor' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'To Site*' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'End Customer*' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'FCST Type*' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Incoterms*' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Trans Mode*' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''100px''>' + 'Date' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''90px''>' + 'Qty' + '</th>'
	SET @v_head_cont = @v_head_cont+ '</tr>'
	/********************************************************************************/

	/********************************************************************************
	* CONT 
	********************************************************************************/
	SET @v_body_text	 = 'Dear all,
								
							Your ' + @v_month_name + '(next month) shipment requests can not be shipped out because of insufficient stock level.
							If we still have negative value for below model till cut-off date of request, all the shipment request will be deleted from the system.
								
							Please refer to below table and kindly ask you to check your next month request before cut-off date.
								
							Thank you.
							Best regards.
								
							';
	SET @v_body_cont = ''
	/********************************************************************************/

	SELECT 
		@v_receiver_cnt = MAX(Receiver_Num)
	FROM #TblSSPShip_Request_Mail WITH(NOLOCK);

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--Loop 시작
		WHILE @v_receiver_cnt > @v_receiver_loop_cnt
		BEGIN
			IF @mailSendCnt=10
			BEGIN
				WAITFOR DELAY '00:00:05' -- FIVE seconds
				SET @mailSendCnt = 0;	-- 10건 전송시마다 5초의 딜레이를 준 후 건수 초기화
			END;
			SET @v_receiver_loop_cnt = @v_receiver_loop_cnt + 1;

			SET @v_mail_data_loop_cnt = 0;

			SELECT 
				@v_tmp_receiver = MAIL_RECEIVER, @v_mail_data_cnt = MAX(Data_Num) 
			FROM #TblSSPShip_Request_Mail WITH(NOLOCK) 
			WHERE Receiver_Num = @v_receiver_loop_cnt
			GROUP BY MAIL_RECEIVER;
	
			SET @v_to_mail = @v_tmp_receiver+'@lgensol.com';
			--SET @v_to_mail = 'kahonmalu@lgensol.com';

			SET @TABLE_BODY = ''
			SET @TABLE_BODY = ' 
			<html>
				<head>
					<title>Untitled Document</title>
					<meta charset="UTF-8">
					<style>
						* {margin:0;padding:0;}
						body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
						table {border-collapse:collapse;width:100%;}
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
						'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">' +   
							'<table style=''border-top:2px solid #c8294b; width:1200px;''>
								<thead>' + ISNULL(@v_head_cont,'') +'</thead> ';

			WHILE @v_mail_data_cnt > @v_mail_data_loop_cnt
			BEGIN
				SET @v_mail_data_loop_cnt = @v_mail_data_loop_cnt + 1;
				SELECT
					@v_mail_receiver			= MAIL_RECEIVER
					, @v_division_id			= DIVISION_ID
					, @v_from_site				= FROM_SITE
					, @v_from_site_description	= FROM_SITE_DESCRIPTION
					, @v_item_id				= ITEM_ID
					, @v_nick_name				= NICK_NAME
					, @v_requestor				= REQUESTOR			
					, @v_to_site				= TO_SITE
					, @v_to_site_description	= TO_SITE_DESCRIPTION
					, @v_end_customer			= END_CUSTOMER
					, @v_fcst_type				= FCST_TYPE
					, @v_incoterms				= INCOTERMS
					, @v_transport_mode			= TRANSPORT_MODE
					, @v_yyyymmdd				= SUBSTRING(YYYYMMDD, 0, 5) + '-' + SUBSTRING(YYYYMMDD, 5, 2) + '-' + SUBSTRING(YYYYMMDD, 7, 2)
					, @v_qty					= QTY
				FROM #TblSSPShip_Request_Mail WITH(NOLOCK)
				WHERE 1 = 1
				  AND Receiver_Num = @v_receiver_loop_cnt
				  AND Data_Num = @v_mail_data_loop_cnt;
		
				SET @v_body_cont = '';
				SET @v_body_cont = @v_body_cont+ '<tr>' + CHAR(13)
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_requestor,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_to_site_description,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_end_customer,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_fcst_type,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_incoterms,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_transport_mode,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_yyyymmdd,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(NVARCHAR, CAST(CONVERT(FLOAT, @v_qty) AS MONEY), 1), '.00', ''),''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '</tr>'

				SET @TABLE_BODY = @TABLE_BODY +  + ISNULL(@v_body_cont, '') + '' + char(13);
			
			END;		--메일 Data Loop End
			SET @TABLE_BODY = @TABLE_BODY + '</tbody> </div> </body> </html>';
			set @v_to_mail = 'jooyong026@lgespartner.com';--개발용
			EXEC msdb.dbo.sp_send_dbmail
				@profile_name = 'GSCM_MAIL_PROD' 
				, @recipients = @v_to_mail
				, @subject    = @v_mail_title
				, @body       = @TABLE_BODY
				, @body_format = 'html';

			--MAIL 발송 LOG 저장
			EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL'
							,'-'
							,@v_mail_title
							,@v_division_id
							,@v_from_site_description
							,@v_item_id
							,@v_nick_name
							,''
							,''
							,''
							,''
							,''
							,'' --p_send_pgm
							,@v_to_mail;
		
			SET @mailSendCnt = @mailSendCnt + 1;
		END;			--수신자 Loop End
		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END TRY
	BEGIN CATCH
		BEGIN

			SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());

			INSERT INTO scm_sys_log_batch 
			(
				program_name,			log_type,			log_count,				log_message,
				description,			event_date,			creation_date,			created_by,
				last_update_date,		last_updated_by
			)
			VALUES 
			(
				ERROR_PROCEDURE(),		'ERROR',			NULL,					ERROR_MESSAGE(),
				@v_description,			SYSDATETIME(),		SYSDATETIME(),			ERROR_PROCEDURE(),
				SYSDATETIME(),			ERROR_PROCEDURE()
			);

			IF @@TRANCOUNT > 0
				COMMIT WORK;
		END;
		BEGIN
			DECLARE @v_error_message NVARCHAR(1000);
			SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);

			--MAIL 발송 LOG 저장
			EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL'
				,'-'
				,@v_mail_title
				,@v_division_id
				,@v_from_site_description
				,@v_item_id
				,@v_nick_name
				,''
				,''
				,''
				,''
				,''
				,'' --p_send_pgm
				,@v_to_mail;

			IF @@TRANCOUNT > 0
				COMMIT WORK;
		END;
	END CATCH;
	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblSSPShip_Request_Mail') IS NOT NULL
		DROP TABLE #TblSSPShip_Request_Mail
END;
