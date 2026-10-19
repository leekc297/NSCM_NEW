

/*  
 * Program ID   : PR_DM_UNLOGIN_MAIL_SEND  
 * Description  : 3개월 미접속자 권한을 회수 메일 발송 
 * PARAMETER    : N/A
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================
 * 2023/10/19   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 -  3개월 미접속자 권한을 회수 메일 발송 
 */  


CREATE PROC [dbo].[PR_DM_UNLOGIN_MAIL_SEND]
AS
SET NOCOUNT ON


--FP의 PR_SCM_DECOMMISSION_AUTHORITY 참고
/*

scm쪽 관련 테이블

SELECT TOP (1000) [UserID]
      ,[LogInTime]
      ,[LogOutTime]
      ,[CnntCode]
      ,[SN]
      ,[PushKey]
  FROM [LGCE_SCMDEV].[dbo].[TB_FX_UserConnect]
  WHERE USERID = 'kjj0070'



  SELECT *
  FROM [LGCE_SCMDEV].[dbo].[TB_FX_UserConnectLog]
  WHERE USERID = 'kjj0070'
*/


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_UNLOGIN_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @dispatch_serial_no INT;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

BEGIN TRY
	
		------------------------------------------------------------------------------------------------------
		-- 대상 추출
		------------------------------------------------------------------------------------------------------
		/*SELECT USERID + '@lgensol.com' MAIL_ADDR FROM TB_FX_USER
		WHERE USEYN = 'Y'
		AND LASTLOGINDATETIME IS NOT NULL
		GROUP BY USERID
		HAVING MAX(LASTLOGINDATETIME) < DATEADD(DAY, -83, GETDATE())
		*/
		------------------------------------------------------------------------------------------------------
		-- 메일발송 시작
		------------------------------------------------------------------------------------------------------

			DECLARE @TABLE_BODY			NVARCHAR(MAX)
				, @v_body_contents	NVARCHAR(MAX)
				, @v_head_cont		NVARCHAR(MAX)
				, @v_body_cont		NVARCHAR(MAX)
				, @v_to_mail		NVARCHAR(150)
				, @v_mail_title		NVARCHAR(100)
				, @V_OWNER			NVARCHAR(100)
				, @V_OWNER_TYPE		CHAR(3)
				, @V_LIKE_STRING	NVARCHAR(100)
				, @v_cnt int
				, @v_i int

			DECLARE   @C_DEPT_NAME_KO	NVARCHAR(150)
					, @C_END_CUSTOMER	NVARCHAR(100)
					, @C_SCM_SITE_ID	NVARCHAR(200)
					, @C_PROJECT_CODE	NVARCHAR(50)
					, @C_PROJECT_NAME	NVARCHAR(200)
					, @C_ITEM_ID		NVARCHAR(50)
					, @C_OWNER			NVARCHAR(100)

		
		DECLARE @V_DELTIME  NVARCHAR(100)
			-----------------------------
		SET @v_mail_title = N'SCM 시스템 장기 미접속 알림'  

	DECLARE @CUR_MAIL_ADDR NVARCHAR(100)

	DECLARE CUR CURSOR FOR
		SELECT
		USERID + '@lgensol.com' MAIL_ADDR 
		,CONVERT(VARCHAR(10), DATEADD(DAY, 91, LASTLOGINDATETIME), 120) DELTIME
		FROM TB_FX_USER WITH(NOLOCK)
		WHERE USEYN = 'Y'
		AND LASTLOGINDATETIME IS NOT NULL
		AND (LASTLOGINDATETIME <= DATEADD(DAY, -83, GETDATE()) AND LASTLOGINDATETIME >= DATEADD(DAY, -90, GETDATE()))

	OPEN CUR 
	FETCH NEXT FROM CUR INTO       
	@CUR_MAIL_ADDR, @V_DELTIME

	WHILE @@FETCH_STATUS = 0
	BEGIN

			SET @v_body_contents = N'안녕하세요. </br> '
										+ N'SCM 시스템 장기 미접속 안내메일입니다. </br> '
										+ N'시스템 미접속 3개월 이후에는 권한이 삭제됩니다.</br>'
										+ N'참고 하시기 바랍니다. </br> '
										+ N'권한 삭제 일자 : ' + @V_DELTIME + N' </br> '

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

	EXEC SCM_ADM_MAIL_SEND
			@CUR_MAIL_ADDR 
		, @v_mail_title -- @v_mail_title 
		, @TABLE_BODY
		, 'Y'--html 여부

	FETCH NEXT FROM CUR INTO
	@CUR_MAIL_ADDR, @V_DELTIME
	END

	CLOSE CUR
	DEALLOCATE CUR



END TRY
			
BEGIN CATCH

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END CATCH

	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



