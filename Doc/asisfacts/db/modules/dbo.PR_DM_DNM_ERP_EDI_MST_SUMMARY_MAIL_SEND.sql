/****************************************************************************************************/  
/*    
 * Program ID   : PR_DM_DNM_ERP_EDI_MST_SUMMARY_MAIL_SEND    
 * Description   : EDI ERP정비 데이터 메일 발송 - 매일 08시00분 발송  
 * PARAMETER  : N/A  
 * Program History    
 *===================================================================================================    
 *   Date       In Charge      Description    
 *===================================================================================================  
 * 2023.07.03 kdmcc14  [EDI 프로젝트] EDI ERP정비 데이터 메일 발송 요청 건  
 */   
 /****************************************************************************************************/  
     
CREATE PROCEDURE [dbo].[PR_DM_DNM_ERP_EDI_MST_SUMMARY_MAIL_SEND]
AS  
SET NOCOUNT ON  
  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
    SET NOCOUNT ON;  
  
 -----------------------------------------------------------------------------------------------------------------------------------------  
 -- STEP 01. LOG 저장 (변수 생성 및 실행)   
 -----------------------------------------------------------------------------------------------------------------------------------------  
  
 -- LOG 용 변수 설정  
DECLARE @v_program_name		NVARCHAR(150) = 'PR_DM_DNM_ERP_EDI_MST_SUMMARY_MAIL_SEND';  
DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...  
DECLARE @n_log_count			INTEGER = 0;  
DECLARE @v_log_message		NVARCHAR(1000);  
DECLARE @v_description			NVARCHAR(500);  
DECLARE @d_event_date			DATETIME;  
  
 -- 시작 LOG  
SET @v_log_type = 'START';  
SET @v_log_message = '##### Start of procedure #####';  
SET @v_description = N'EDI ERP정비 데이터 메일 발송';  
SET @d_event_date = SYSDATETIME();  

EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
  
BEGIN TRY  
   
	-----------------------------------------------------------------------------------------------------------------------------------------  
	-- STEP 02. 임시테이블 / 변수 생성   
	-----------------------------------------------------------------------------------------------------------------------------------------  
	IF OBJECT_ID (N'tempdb..#T_EDI_MST_SUMMARY', N'U')			IS NOT NULL  DROP TABLE #T_EDI_MST_SUMMARY
	IF OBJECT_ID (N'tempdb..#T_MAIL_ADDR', N'U')					IS NOT NULL	DROP TABLE #T_MAIL_ADDR
  	
	DECLARE @V_SCNT  INT = 1;  
	DECLARE @V_TCNT  INT = 1;  


	-----------------------------------------------------------------------------------------------------------------------------------------  
	-- STEP 03. EDI MASTER 정비 데이터 조회  
	-----------------------------------------------------------------------------------------------------------------------------------------
	BEGIN
		SELECT X.DIVISION_ID, X.EDI_SENDER_NAME, X.ERP_MASTER_DATA, X.GSCM_MASTER_DATA, X.SUCCESS
		INTO #T_EDI_MST_SUMMARY
		FROM (
					SELECT A.DIVISION_ID
							 , A.SENDER_NAME AS EDI_SENDER_NAME
							 , SUM(CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_ERP' THEN 1
											  ELSE 0 END) AS ERP_MASTER_DATA
							 , SUM(CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_GSCM' THEN 1
											  ELSE 0 END) AS GSCM_MASTER_DATA
							 , SUM(CASE WHEN A.STATUS_CODE = 'S' AND A.ERP_STATUS = '' THEN 1
											  ELSE 0 END) AS SUCCESS
					FROM (
							SELECT A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT, A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
										, A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS--, CREATE_DATE
										, A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS			  
							FROM DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK) 
							LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
							ON A.DIVISION_ID = B.DIVISION_ID
								AND A.SCM_SITE_ID = B.SCM_SITE_ID
								AND B.SITE_TYPE	 = 'SALES'
								AND B.VALID_YN		= 'Y'					
							WHERE A.CREATE_DATE >= '20230101'
							AND A.DIVISION_ID LIKE '81%'
							AND A.SENDER_NAME <> 'LUCID'
							GROUP BY A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT, A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
											, A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
											, A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS) A
					GROUP BY A.DIVISION_ID, A.SENDER_NAME) X
		WHERE (X.ERP_MASTER_DATA <> 0 OR X.GSCM_MASTER_DATA <> 0)
		ORDER BY X.DIVISION_ID, X.EDI_SENDER_NAME
	END

	-----------------------------------------------------------------------------------------------------------------------------------------  
	-- STEP 04. 메일발송 대상 (Lookup : EDI_MST_MAIL_ADDR)   
	-----------------------------------------------------------------------------------------------------------------------------------------
	BEGIN
		SELECT A.SEGMENT1, ROW_NUMBER() OVER ( ORDER BY SEGMENT1 ) AS SEQ  
		INTO #T_MAIL_ADDR  
		FROM (  
					SELECT A.SEGMENT1  
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)  
					WHERE A.LOOKUP_TYPE = 'EDI_MST_MAIL_ADDR'  
					AND A.VALID_YN = 'Y' 
					AND REPLACE(SEGMENT2, '-', '') = ''	  
				 ) A

		SELECT @V_TCNT = COUNT(*) FROM #T_MAIL_ADDR  
		DECLARE @V_MAIL_ADDR_LIST VARCHAR(MAX) = '';  

	END

	-----------------------------------------------------------------------------------------------------------------------------------------  
	-- STEP 05. 메일발송 - 전송대상만큼 반복 (헤더, 본문)   
	----------------------------------------------------------------------------------------------------------------------------------------- 
	BEGIN

		DECLARE @TABLE_BODY					NVARCHAR(MAX)  
					, @v_body_contents				NVARCHAR(MAX)  
					, @v_head_cont					NVARCHAR(MAX)  
					, @v_body_cont					NVARCHAR(MAX)  
					, @v_mail_title						NVARCHAR(150)  
					, @V_OWNER						NVARCHAR(100)  
  
		DECLARE @C_DIVISION_ID				NVARCHAR(150)  
					, @C_EDI_SENDER_NAME		NVARCHAR(150)
					, @C_ERP_MASTER_DATA		NVARCHAR(30)
					, @C_GSCM_MASTER_DATA  NVARCHAR(50)
					, @C_SUCCESS					NVARCHAR(50)

		------------------------------------------------------------------------------------------------------  
		-- STEP 05-1. 테이블 HEADER   
		------------------------------------------------------------------------------------------------------  
		SET @v_mail_title = N'[EDI Master Data Report] 입니다.'  
		SET @v_body_contents = N'[EDI Master Data Report] </br> '
										+ N'안녕하세요. GSCM.DM 입니다. </br> '
										+ N'아래와 같이 EDI Master Data 정비 현황을 전달 드립니다. </br> '
										+ N'고객 수요를 놓치는 일이 없도록 ERP와 GSCM에서 Master Data를 정비/관리 부탁 드립니다. </br></br>'
										+ N'[EDI Master Summary] </br>'

		SET @v_head_cont = N'<TR>  
											<TH>Div</TH>
											<TH>EDI Sender Name</TH>
											<TH>ERP Master Data 정비필요</TH>
											<TH>GSCM Master Data 정비필요</TH>
											<TH>정상</TH>											
										</TR>'

		------------------------------------------------------------------------------------------------------  
		-- STEP 05-2. 테이블 반복 내용  
		------------------------------------------------------------------------------------------------------  
		WHILE ( @V_SCNT <= @V_TCNT )	    	
			BEGIN				
    
				SET @V_OWNER = '';  
				SET @v_body_cont = '';
			
				SELECT @V_OWNER = SEGMENT1 FROM #T_MAIL_ADDR 
				WHERE SEQ = @V_SCNT  
      
				-- 본문내용 생성  
				DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
				SELECT * FROM #T_EDI_MST_SUMMARY			
				ORDER BY DIVISION_ID, EDI_SENDER_NAME
  
				OPEN CUR_SEND;  
				FETCH NEXT FROM CUR_SEND INTO @C_DIVISION_ID, @C_EDI_SENDER_NAME, @C_ERP_MASTER_DATA
																  , @C_GSCM_MASTER_DATA, @C_SUCCESS															  

				WHILE @@FETCH_STATUS = 0						
					BEGIN  

						SET @v_body_cont = @v_body_cont+ N'<TR>'  
						SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_DIVISION_ID, '') + N'</TD>'
						SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_EDI_SENDER_NAME, '') + N'</TD>'   
						SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_ERP_MASTER_DATA, '') + N'</TD>'   
						SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_GSCM_MASTER_DATA, '') + N'</TD>'   
						SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_SUCCESS, '') + N'</TD>'   		
						SET @v_body_cont = @v_body_cont+ N'</TR>'  
																  
						FETCH NEXT FROM CUR_SEND INTO @C_DIVISION_ID, @C_EDI_SENDER_NAME, @C_ERP_MASTER_DATA
																		  , @C_GSCM_MASTER_DATA, @C_SUCCESS		

					END						
   
				CLOSE CUR_SEND;  
				DEALLOCATE CUR_SEND;

				SET @TABLE_BODY = N' <html>  
														<head>  
															<title>Untitled Document</title>  
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
														<body></br><b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), N'<br>') + N'</b>'  
															+ N'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'  
															+ N'<table style=''border-top:2px solid #c8294b; width:1450px;''>  
															<thead>' + ISNULL(@v_head_cont,'') + N'</thead>  
															<tbody>' + ISNULL(@v_body_cont, '') + N'</tbody>  
															</div>  
														</body>  
												   </html>';  

				------------------------------------------------------------------------------------------------------  
				-- STEP 05-3. Mail 전송  
				------------------------------------------------------------------------------------------------------  
				EXEC SCM_ADM_MAIL_SEND @V_OWNER, @v_mail_title, @TABLE_BODY, 'Y'  
  
				IF ( @V_SCNT % 5 IN ( 0, 5 ))
					BEGIN  
						WAITFOR DELAY '00:00:30'  
					END

				SET @V_SCNT = @V_SCNT + 1;

			END

	END

END TRY  
   
BEGIN CATCH  
  
  --IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_SEND')
  --  BEGIN
  --      CLOSE CUR_SEND;
  --      DEALLOCATE CUR_SEND;
  --  END

/*
	EXEC PR_DM_DNM_ERP_EDI_MST_SUMMARY_MAIL_SEND
*/


  SET @v_log_type = 'ERROR';  
  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());  
  SET @d_event_date = SYSDATETIME();  
    
  SELECT @v_log_message   
  
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
END CATCH  
  
   
 -- 종료 LOG  
 SET @v_log_type = 'END';  
 SET @v_log_message = '##### END of procedure #####';  
 SET @v_description = N'EDI ERP정비 데이터 메일 발송';  
 SET @d_event_date = SYSDATETIME();  
 EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
  
  
  
