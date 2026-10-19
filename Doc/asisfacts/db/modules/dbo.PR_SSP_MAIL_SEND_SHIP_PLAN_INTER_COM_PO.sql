
/*
 * Program ID   : PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM_PO
 * Description  : SSP MAIL 발송 (PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM_PO)
                  JOB.SSP_MAIL_SEND_SHIP_PLAN_INTER_COM_PO에서 호출 10분단위 호출 후 법인별 시업시간 기준 수행 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/07/13	juhlee			[PJ20199555]  공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 
								 1. 발송 조건 : 
								   - PO 미생성 된 Confirm된 Plan 
								   - 현재일 ~ 현재일+3 (4일) 
								   - 법인간거래 : TO_SITE가 PLANT (PACKER ,Warranty 포함)     
								 2. 발송 주기 
								   - Daily  법인별(TO SITE 기준) 시업시간 + 6시간 에 발송 
								 3. 발송 대상(수신자)  
								   - 전극 : Shipment Requestor PIC에 등록된 user 
								   - 이외 : Look up 정보에 등록된 대상자 ( lookup명 :SHIP_PLAN_INTER_COM_MAIL_SEND ) 
											TO-SITE : ALL 설정 시 전극포함한 전체 수신
 * 2020/10/05	KIMYONGHO			'SHIP_PLAN_INTER_COM_MAIL_SEND' LOOKUP - FROM_SITE 추가
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM_PO]

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;


	DECLARE @v_company_id    NVARCHAR(30) = '';


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
	DECLARE @v_po_no  						    NVARCHAR(30);
	DECLARE @v_status  						    NVARCHAR(30);
	DECLARE @v_item_id							NVARCHAR(50);
	DECLARE @v_nick_name						NVARCHAR(50);
	DECLARE @v_from_site						NVARCHAR(30);
	DECLARE @v_from_site_description			NVARCHAR(100);
	DECLARE @v_to_site							NVARCHAR(30);
	DECLARE @v_to_site_description				NVARCHAR(100);
	DECLARE @v_shipment_qty						NVARCHAR(MAX);
	DECLARE @v_yyyymmdd							NVARCHAR(10);
	DECLARE @v_transport_mode					NVARCHAR(50);
	DECLARE @v_incoterms						NVARCHAR(10);
	DECLARE @v_lt_day							NVARCHAR(10);
	DECLARE @v_etd_date					        NVARCHAR(10);
	DECLARE @v_exp_ship_date			        NVARCHAR(10);
	DECLARE @v_eta_date					        NVARCHAR(10);
	DECLARE @v_model_pic						NVARCHAR(200);
	DECLARE @v_confirm_id						NVARCHAR(30);

	-- LOG 용 변수 설정
	DECLARE @v_program_name						NVARCHAR(150) = 'PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM_PO';
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


     -- 시업시간 추출 법인별 (TO_SITE 기준 법인) 
	-- 시업시간 + 6시간 후 메일 발송 
	-- 10분위 수행시 07:0 까지 일치여부 확인 	
	-- SEGMENT2 = 법인별 시업시간 
	-- [DBO].[FN_MULTY_TIME](SEGMENT3) 법인 현재 시간 
 	SELECT @v_company_id = STUFF(( SELECT ','+ TT.COMPANY_ID         
								FROM (
									SELECT SEGMENT4 AS COMPANY_ID
									FROM   SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)  
									WHERE  LOOKUP_TYPE = 'BASIS_START_TIME_PLANT' 
									AND    CONVERT(CHAR(8), [DBO].[FN_MULTY_TIME](SEGMENT3), 112) = CONVERT(CHAR(8), GETDATE(), 112) 
									-- 시업시간 + 6시간 =  법인 현재시간 
									AND    RIGHT('00' + CONVERT( NVARCHAR, CONVERT( NVARCHAR, SUBSTRING(CONVERT(CHAR(8), SEGMENT2, 8),1,2) ) + 6 ), 2) + SUBSTRING(CONVERT(CHAR(8), SEGMENT2, 8),3,2)
									      =  SUBSTRING(CONVERT(CHAR(8),  [DBO].[FN_MULTY_TIME](SEGMENT3), 8),1,4) -- 법인 현재시간 
									GROUP BY SEGMENT4 
								) TT  
								FOR XML PATH('')     
								), 1, 1, ''
								) ;


	--SET @v_company_id = 'C100';

    -- 시업시간과 일치하지 않으면 미수행 
    IF @v_company_id IS  NULL 
		BEGIN 
			RETURN  ; 
		END ;


	--임시Table 삭제-------------------------------------------------
	IF OBJECT_ID('tempdb..#TblSSPShip_Request_Mail') IS NOT NULL
			DROP TABLE #TblSSPShip_Request_Mail
	-----------------------------------------------------------------

	--메일 수신자별 Index Data Temp Table------------------------------------------------------------------
	SELECT 
		T0.*	   
	INTO #TblSSPShip_Request_Mail
	FROM 
	(

			SELECT DISTINCT
				   DENSE_RANK() OVER (ORDER BY X.MAIL_RECEIVER) AS Receiver_Num
			,      ROW_NUMBER() OVER (PARTITION BY X.MAIL_RECEIVER ORDER BY X.MAIL_RECEIVER, X.DIVISION_ID,X.COMPANY_ID, X.TO_SITE, X.ITEM_ID,X.YYYYMMDD , X.FROM_SITE,   X.TRANSPORT_MODE , X.INCOTERMS ) AS Data_Num 
			,      X.MAIL_RECEIVER
			,      X.COMPANY_ID
			,      X.DIVISION_ID 
			,      X.PO_NO
			,      X.STATUS 
			,      X.ITEM_ID 
			,      X.NICK_NAME
			,      X.FROM_SITE 
			,      X.FROM_SITE_DESCRIPTION 
			,      X.TO_SITE 
			,      X.TO_SITE_DESCRIPTION 
			,      X.QTY 
			,      X.YYYYMMDD
			,      X.TRANSPORT_MODE
			,      X.INCOTERMS
			,      X.LT_DAY
			,      X.ETD_DATE
			,      X.EXP_SHIP_DATE 
			,      X.ETA_DATE
			,      X.MODEL_PIC_USER_NAME
			,      X.CONFIRM_ID 	    
			FROM (
			        -- 전극 대상 - 수신자 : Shipment Requestor PIC(SSP_MST_MODEL_USER_EE) 
					SELECT EM.USER_ID          AS MAIL_RECEIVER 
					,      TS.COMPANY_ID       AS COMPANY_ID -- TO Site기준 
					,      C.DIVISION_ID       AS DIVISION_ID 
					,      C.ERP_SO_NO         AS PO_NO 
					,      'Confirm'           AS STATUS 
					,      C.ITEM_ID 
					,      [dbo].[FN_GET_ITEM_NICKNAME](C.DIVISION_ID, C.ITEM_ID) AS NICK_NAME 
					,      C.FROM_SITE 
					,      FS.SITE_DESCRIPTION  AS FROM_SITE_DESCRIPTION 
					,      C.TO_SITE 
					,      TS.SITE_DESCRIPTION  AS TO_SITE_DESCRIPTION 
					,      C.QTY 
					,      C.YYYYMMDD
					,      C.TRANSPORT_MODE
					,      C.INCOTERMS 
					,      C.CUSTOMER_LT     AS LT_DAY
					,      C.ETD_DATE
					,      [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](C.DIVISION_ID, C.BOD_ID, C.YYYYMMDD)     AS EXP_SHIP_DATE 
					,      C.ETA_DATE
					,      AM.USER_ID     AS MODEL_PIC_USER_ID -- 모델 담당자 
					,      AU.USERNAME +'('+ AM.USER_ID +')' AS MODEL_PIC_USER_NAME --  모델 담당자 
					,      C.CONFIRM_ID 
					,      C.BIZ_TYPE 
					,      C.ORIGIN_FROM_DIVISION_ID 
					,      C.ORIGIN_TO_DIVISION_ID 

					FROM   SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
						JOIN SCM_MST_SITE FS WITH(NOLOCK) 
						  ON FS.DIVISION_ID = C.ORIGIN_FROM_DIVISION_ID 
						 AND FS.SCM_SITE_ID = C.FROM_SITE 

						JOIN SCM_MST_SITE TS WITH(NOLOCK) 
						  ON TS.DIVISION_ID = C.ORIGIN_TO_DIVISION_ID 
						 AND TS.SCM_SITE_ID = C.TO_SITE 
						 AND TS.SITE_TYPE   = 'PLANT' -- 법인간거래 (PACKER ,Warranty 포함)  

						JOIN SSP_MST_MODEL_USER_EE EM WITH(NOLOCK) -- 전극 Requestor 담당자 (전극 메일 수신자) 
						  ON EM.DIVISION_ID = C.ORIGIN_TO_DIVISION_ID
						 AND EM.TO_SITE     = C.TO_SITE
						 AND EM.ITEM_ID     = C.ITEM_ID 
						 AND EM.VALID_YN    = 'Y' 

						LEFT OUTER JOIN SSP_MST_MODEL_USER AM WITH(NOLOCK)   -- 모델 담당자 
						  ON AM.DIVISION_ID = C.ORIGIN_FROM_DIVISION_ID
						 AND AM.FROM_SITE   = C.FROM_SITE
						 AND AM.ITEM_ID     = C.ITEM_ID 
						 AND AM.VALID_YN    = 'Y' 

						LEFT OUTER JOIN TB_FX_USER AU WITH(NOLOCK) 
						  ON AU.USERID = AM.USER_ID 
						 AND AU.USEYN = 'Y'

					WHERE  1=1 
					AND    C.CHANGE_TYPE ='C'
					AND    C.QTY > 0 
					AND    C.YYYYMMDD >= CONVERT(char(8), GETDATE(), 112)
					AND    C.YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, 3, GETDATE()) ,112)  
					AND    ISNULL(C.ERP_STATUS,'B') = 'B'  -- SO/PO 미 발행 대상: null, B ( ERP STATUS : A:SO/PO 생성 , B:SO/PO 취소, C:DO생성 , D:DO취소 )
					AND    C.BIZ_TYPE = 'E'

					UNION ALL 
			        -- 전극 포함 - (수신자 : lookup 등록 SHIP_PLAN_INTER_COM_MAIL_SEND ) 
					SELECT L.SEGMENT2          AS MAIL_RECEIVER 
					,      TS.COMPANY_ID       AS COMPANY_ID -- TO Site기준 
					,      C.DIVISION_ID       AS DIVISION_ID 
					,      C.ERP_SO_NO         AS PO_NO 
					,      'Confirm'           AS STATUS 
					,      C.ITEM_ID 
					,      [dbo].[FN_GET_ITEM_NICKNAME](C.DIVISION_ID, C.ITEM_ID) AS NICK_NAME 
					,      C.FROM_SITE 
					,      FS.SITE_DESCRIPTION  AS FROM_SITE_DESCRIPTION 
					,      C.TO_SITE 
					,      TS.SITE_DESCRIPTION  AS TO_SITE_DESCRIPTION  
					,      C.QTY 
					,      C.YYYYMMDD
					,      C.TRANSPORT_MODE
					,      C.INCOTERMS 
					,      C.CUSTOMER_LT   AS LT_DAY
					,      C.ETD_DATE
					,      [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](C.DIVISION_ID, C.BOD_ID, C.YYYYMMDD)     AS EXP_SHIP_DATE 
					,      C.ETA_DATE
					,      AM.USER_ID                         AS MODEL_PIC_USER_ID    --  모델 담당자 
					,      AU.USERNAME +'('+ AM.USER_ID +')'  AS MODEL_PIC_USER_NAME -- 모델 담당자 
					,      C.CONFIRM_ID 
					,      C.BIZ_TYPE 
					,      C.ORIGIN_FROM_DIVISION_ID 
					,      C.ORIGIN_TO_DIVISION_ID 

					FROM  SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
						JOIN SCM_MST_SITE FS WITH(NOLOCK) 
						  ON FS.DIVISION_ID = C.ORIGIN_FROM_DIVISION_ID 
						 AND FS.SCM_SITE_ID = C.FROM_SITE 

						JOIN SCM_MST_SITE TS WITH(NOLOCK) 
						  ON TS.DIVISION_ID = C.ORIGIN_TO_DIVISION_ID 
						 AND TS.SCM_SITE_ID = C.TO_SITE 
						 AND TS.SITE_TYPE   = 'PLANT' -- 법인간거래 (PACKER ,Warranty 포함)  

						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  -- lookup 등록 메일 수신자 
						  ON  L.LOOKUP_TYPE ='SHIP_PLAN_INTER_COM_MAIL_SEND'
						 AND  L.VALID_YN    ='Y'
						 AND  L.SEGMENT3    = CASE WHEN L.SEGMENT3 = 'ALL' THEN 'ALL' ELSE C.TO_SITE END -- ALL일경우 전체 대상 
						 --* 2020/10/05	KIMYONGHO			'SHIP_PLAN_INTER_COM_MAIL_SEND' LOOKUP - FROM_SITE 추가
						 AND  L.SEGMENT4    = CASE WHEN L.SEGMENT4 = 'ALL' THEN 'ALL' ELSE C.FROM_SITE END -- ALL일경우 전체 대상 
						LEFT OUTER JOIN SSP_MST_MODEL_USER AM WITH(NOLOCK)   -- 모델 담당자 
						  ON AM.DIVISION_ID = C.ORIGIN_FROM_DIVISION_ID
						 AND AM.FROM_SITE   = C.FROM_SITE
						 AND AM.ITEM_ID     = C.ITEM_ID 
						 AND AM.VALID_YN    = 'Y' 

						LEFT OUTER JOIN TB_FX_USER AU WITH(NOLOCK) 
						  ON AU.USERID = AM.USER_ID 
						 AND AU.USEYN = 'Y'


					WHERE  1=1 
					AND    C.CHANGE_TYPE ='C'
					AND    C.QTY > 0 
					AND    C.YYYYMMDD >= CONVERT(char(8), GETDATE(), 112)
					AND    C.YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, 3, GETDATE()) ,112)  
					AND    ISNULL(C.ERP_STATUS,'B') = 'B'  -- SO/PO 미 발행 대상: null, B ( ERP STATUS : A:SO/PO 생성 , B:SO/PO 취소, C:DO생성 , D:DO취소 )

			) X
			WHERE 1=1 
			AND   X.COMPANY_ID  IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_company_id,',') )  
		--	AND   X.MAIL_RECEIVER in ( 'juhlee' ,'kimkwanghee', 'kimbk1','kimyh8848')
		  
	) T0;


	--TEST
	--SELECT * FROM #TblSSPShip_Request_Mail;
	------------------------------------------------------------------------------------

	/********************************************************************************
	* MAIL TITLE
	********************************************************************************/
	SET @v_mail_title	 = N'[Notice] Inter-company trade PO requestment';
	/********************************************************************************/

	/********************************************************************************
	* HEAD CONT 
	********************************************************************************/		

	SET @v_head_cont = '';
	SET @v_head_cont = @v_head_cont+ '<tr>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Div' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'PO No' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Status' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Model' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Nick Name' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''110px''>' + 'From Site' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''120px''>' + 'To Site' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''85px''>' + 'Shipment Qty' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''85px''>' + 'Shipment Date' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''45px''>' + 'Trans Mode' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Incoterms' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'L/T(Day)' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''85px''>' + 'ETD' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''85px''>' + 'Expected Shipping Date' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''85px''>' + 'ETA' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Model PIC' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Confirm ID' + '</th>'
	SET @v_head_cont = @v_head_cont+ '</tr>'


	/********************************************************************************/

	/********************************************************************************
	* CONT 
	********************************************************************************/
	SET @v_body_text	 = 
	                      N'The shipment Plan for inter-company trade Items have been confirm as follows                     
                            But, The PO has not been created yet. Please check the shipment plan and create PO.                     
                            Thank you                               
                            Best regards 
								
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
							'<table style=''border-top:2px solid #c8294b; width:1600px;''>
								<thead>' + ISNULL(@v_head_cont,'') +'</thead> ';

			WHILE @v_mail_data_cnt > @v_mail_data_loop_cnt
			BEGIN
				SET @v_mail_data_loop_cnt = @v_mail_data_loop_cnt + 1;

				SELECT
					  @v_mail_receiver			= MAIL_RECEIVER
					, @v_division_id			= DIVISION_ID
					, @v_po_no			        = PO_NO
					, @v_status			        = STATUS
					, @v_item_id				= ITEM_ID
					, @v_nick_name				= NICK_NAME
					, @v_from_site				= FROM_SITE
					, @v_from_site_description	= FROM_SITE_DESCRIPTION
					, @v_to_site				= TO_SITE
					, @v_to_site_description	= TO_SITE_DESCRIPTION
					, @v_shipment_qty           = QTY 
					, @v_yyyymmdd				= SUBSTRING(YYYYMMDD, 0, 5) + '-' + SUBSTRING(YYYYMMDD, 5, 2) + '-' + SUBSTRING(YYYYMMDD, 7, 2)
					, @v_transport_mode			= TRANSPORT_MODE
					, @v_incoterms				= INCOTERMS
					, @v_lt_day                 = LT_DAY
					, @v_etd_date               = SUBSTRING(ETD_DATE     , 0, 5) + '-' + SUBSTRING(ETD_DATE     , 5, 2) + '-' + SUBSTRING(ETD_DATE     , 7, 2) 
					, @v_exp_ship_date          = SUBSTRING(EXP_SHIP_DATE, 0, 5) + '-' + SUBSTRING(EXP_SHIP_DATE, 5, 2) + '-' + SUBSTRING(EXP_SHIP_DATE, 7, 2)
					, @v_eta_date               = SUBSTRING(ETA_DATE     , 0, 5) + '-' + SUBSTRING(ETA_DATE     , 5, 2) + '-' + SUBSTRING(ETA_DATE     , 7, 2)
					, @v_model_pic              = MODEL_PIC_USER_NAME
					, @v_confirm_id             = CONFIRM_ID 
				FROM #TblSSPShip_Request_Mail WITH(NOLOCK)
				WHERE 1 = 1
				  AND Receiver_Num = @v_receiver_loop_cnt
				  AND Data_Num = @v_mail_data_loop_cnt;

		
				SET @v_body_cont = '';
				SET @v_body_cont = @v_body_cont+ '<tr>' + CHAR(13)
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_po_no,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_status,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_to_site_description,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(NVARCHAR, CAST(CONVERT(FLOAT, @v_shipment_qty) AS MONEY), 1), '.00', ''),''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_yyyymmdd,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_transport_mode,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_incoterms,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''right''>'  + REPLACE(ISNULL(@v_lt_day,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_etd_date ,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_exp_ship_date,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_eta_date ,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_model_pic,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_confirm_id,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '</tr>'

				SET @TABLE_BODY = @TABLE_BODY +  + ISNULL(@v_body_cont, '') + '' + char(13);
			
			END;		--메일 Data Loop End
			SET @TABLE_BODY = @TABLE_BODY + '</br></tbody> </div> </body> </html>';
			set @v_to_mail = 'jooyong026@lgespartner.com';--개발용
			EXEC msdb.dbo.sp_send_dbmail
				 @profile_name = 'GSCM_MAIL_PROD' --운영 
				--@profile_name = 'GSCM_MAIL_TEST'   -- 개발환경
				, @recipients = @v_to_mail
				, @subject    = @v_mail_title
				, @body       = @TABLE_BODY
				, @body_format = 'html';

			--MAIL 발송 LOG 저장
			EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL'
							,'-'
							,@v_program_name
							,@v_mail_title
							,@v_division_id
							,@v_from_site_description
							,@v_item_id
							,@v_nick_name
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
				@v_description,		    SYSDATETIME(),		SYSDATETIME(),			ERROR_PROCEDURE(),
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
				,@v_program_name
				,@v_mail_title
				,@v_division_id
				,@v_from_site_description
				,@v_item_id
				,@v_nick_name
				,''
				,''
				,''
				,''
				,'' --p_send_pgm
				,@v_to_mail;

			IF @@TRANCOUNT > 0
				COMMIT WORK;
		--	SET @p_log_messge = @v_error_message;
			return -1;
		END;
	END CATCH;
	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblSSPShip_Request_Mail') IS NOT NULL
		DROP TABLE #TblSSPShip_Request_Mail
	return 1;
END;
