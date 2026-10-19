
/*
 * Program ID   : [PR_SSP_MAIL_SEND_DELEGATE]
 * Description  : DELEGATE MAIL 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/15	mcTheJ			[CSR ID:4044806] Model PIC 담당자 위임 기능 추가
 *
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SEND_DELEGATE]
	@p_type					char(1)
	, @p_divisionid			NVARCHAR(MAX)
	, @p_delegator			NVARCHAR(MAX)
	, @p_delegatee			NVARCHAR(MAX)
	, @p_from_date			NVARCHAR(10)
	, @p_to_date			NVARCHAR(10)
	, @p_language			 NVARCHAR(MAX) = 'KO'
	, @p_html_yn			NVARCHAR(1)

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	DECLARE	@v_title			NVARCHAR(MAX);
	DECLARE	@v_t_title			NVARCHAR(MAX);
	DECLARE	@v_contents			NVARCHAR(MAX);
	DECLARE @TABLE_BODY			NVARCHAR(MAX);

	DECLARE @v_delegator_mail NVARCHAR(MAX);
	DECLARE @v_delegatee_mail NVARCHAR(MAX);

	DECLARE @v_delegator NVARCHAR(MAX);
	DECLARE @v_delegatee NVARCHAR(MAX);
	
	DECLARE @v_from_date NVARCHAR(10);
	DECLARE @v_to_date NVARCHAR(10);
	DECLARE @v_ps NVARCHAR(30);
	
	DECLARE @v_division_id          NVARCHAR(MAX);
	SET @v_division_id = NULL;
	DECLARE @v_mail_division_id          NVARCHAR(MAX);
	SET @v_mail_division_id = '';


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_MAIL_SEND_DELEGATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_to_mail      NVARCHAR(150);

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		SET @v_delegator_mail = @p_delegator + '@lgensol.com';
		SET @v_delegatee_mail = @p_delegatee + '@lgensol.com';
		
		SET @v_delegator = (SELECT TOP 1 CASE @p_language WHEN 'KO' THEN UserName ELSE UserName_E END + '(' + @p_delegator + ')' FROM TB_FX_USER WHERE 1 = 1 AND UserID = @p_delegator AND UseYN = 'Y');
		SET @v_delegatee = (SELECT TOP 1 CASE @p_language WHEN 'KO' THEN UserName ELSE UserName_E END + '(' + @p_delegatee + ')' FROM TB_FX_USER WHERE 1 = 1 AND UserID = @p_delegatee AND UseYN = 'Y');

		SET @v_from_date = substring(@p_from_date, 0, 5) + '-' + substring(@p_from_date, 5, 2) + '-' + substring(@p_from_date, 7, 2)
		SET @v_to_date = substring(@p_to_date, 0, 5) + '-' + substring(@p_to_date, 5, 2) + '-' + substring(@p_to_date, 7, 2)
		SET @v_ps = N'(본 메일은 발신전용으로서 회신시 수신이 불가합니다.)';

		IF @p_type = 'S'
		BEGIN
			SET @v_title = '[SSP] Approval Delegation';
			SET @v_contents = @p_delegator + ' delegated approval to ' + @p_delegatee;
		END
		ELSE
		BEGIN
			SET @v_title = '[SSP] Canceled Approval Delegation';
			SET @v_contents = @p_delegator + ' has canceled approval  delegation to ' + @p_delegatee;
		END

		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_divisionid, @v_delimiter);    

		WHILE LEN(@p_divisionid) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN			
				SET @v_division_id         = dbo.SCM_ARR_SPL_VAL(@p_divisionid        , @v_delimiter, @mst_loop_cnt );
			END;

			IF @max_loop_cnt = @mst_loop_cnt
			BEGIN
				SET @v_mail_division_id  = @v_mail_division_id + @v_division_id ;
			END
			ELSE
			BEGIN
				SET @v_mail_division_id  = @v_mail_division_id + @v_division_id + ', ';
			END;
			
		END;

		SET @TABLE_BODY = ''
		SET @TABLE_BODY = N'
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
				<body>'+
					'<b>'+
					'<br></br>' +
					'<p>' + ISNULL(@v_contents, '') + '<br>' +
					'- Division : ' + ISNULL(@v_mail_division_id, '') + '<br>' +
					'- Delegator : ' + ISNULL(@v_delegator, '') + '<br>' +
					'- Delegatee : ' + ISNULL(@v_delegatee, '') + '<br>' +
					'- Period : ' + @v_from_date + ' ~ ' + @v_to_date + ' (GMT&#43;09:00) Seoul<br></p>' +
					'<br></br>' +
					'<p>After accessing the SCM system, check the path below.<br>'+
					'* SCM > Master> Shipping Master> Delegate<br></p></b>'+
				'</body></html>';

		BEGIN

		--select @v_title, @v_contents, @v_delegator, @v_delegatee, @v_from_date, @v_to_date, @v_mail_division_id, @max_loop_cnt, @TABLE_BODY;
		set @v_delegator_mail = 'jooyong026@lgespartner.com';--개발용
		set @v_delegatee_mail = 'jooyong026@lgespartner.com';--개발용
			--위임자 메일 전송
			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'GSCM_MAIL_PROD' 
			, @recipients = @v_delegator_mail
			, @subject    = @v_title
			, @body       = @TABLE_BODY
			, @body_format = 'html';
			
			--수임자 메일 전송
			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'GSCM_MAIL_PROD' 
			, @recipients = @v_delegatee_mail
			, @subject    = @v_title
			, @body       = @TABLE_BODY
			, @body_format = 'html';
			
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END
	END TRY

		BEGIN CATCH
		  BEGIN

		  	SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());

			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,@v_description
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END

