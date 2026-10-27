-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_SCM_AUTHORITY_REQUEST_MAIL_SEND]
@p_user_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_AUTHORITY_REQUEST_MAIL_SEND'
	DECLARE @v_table_name     nvarchar(100)
	DECLARE @v_message        nvarchar(250)
	DECLARE @v_descr          nvarchar(250)
	DECLARE @n_row_count      Integer  = 0
	DECLARE @n_log_count      Integer  = 0
	DECLARE @v_log_code       nvarchar(10)
	DECLARE @sysdate          DATETIME2 = GETDATE()

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @v_user_id	nvarchar(150);
	DECLARE @v_user_name nvarchar(500);

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	
	SET @n_log_count = @n_log_count + 1
	SET @sysdate = GETDATE()
	EXEC PR_LOG_PROCESS @sysdate, '', '', @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null


	BEGIN TRY				

		BEGIN TRAN
			
			SET @v_user_id = @p_user_id;
			
			SELECT @v_user_name = USER_NAME + '(' + USER_ID + ')' 
			FROM SY_SCM_MST_SSO_USER_INFO
			WHERE 1=1
			AND USER_ID = @v_user_id
			;

			DECLARE @SUBJECT NVARCHAR(100) = '[REQUEST] FP System Authority Request'
					
			DECLARE @MSG NVARCHAR(MAX) =
										'<table width=800 border=1 style=border-collapse:collapse cellpadding=10>' +
										'	<tr>'                                                                  +
										'		<td>Authority Type</td>'                                      +
										'		<td>REQUEST</td>'                                                     +
										'		<td>DTTM</td>'                                                     +
										'		<td>'+ CONVERT(NVARCHAR(20), GETDATE(), 120) +'</td>'              +
										'	</tr>'                                                                 +
										'	<tr>'                                                                  +
										'		<td colspan=4>'                                                    +
										' Request User :: '+ @v_user_name +
										'		</td>'                                                             +
										'	</tr>'                                                                 +
										'</table>'
			--print @MSG
			BEGIN
					DECLARE CUR_MAIL CURSOR FOR
						SELECT ATTRIBUTE1 AS MAIL_ADDRESS
							FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
							WHERE LOOKUP_TYPE_CODE = 'EXPR_USER'
							AND ACTIVE_FLAG = 'Y'  
							--AND SEGMENT3 LIKE  '%PI%'
							AND ATTRIBUTE2 = 'Y'
							;

					OPEN CUR_MAIL;

					DECLARE @MAIL_ADDRESS	nvarchar(150);

					FETCH NEXT FROM CUR_MAIL INTO @MAIL_ADDRESS
					;
						WHILE (@@FETCH_STATUS = 0)
							BEGIN
								EXEC msdb.dbo.sp_send_dbmail
								@profile_name = 'FP_MAIL_TEST'
								, @recipients = @MAIL_ADDRESS
								, @subject    = @SUBJECT
								, @body       = @MSG

								FETCH NEXT FROM CUR_MAIL INTO @MAIL_ADDRESS;
							END

					CLOSE CUR_MAIL;
					DEALLOCATE CUR_MAIL;
			END

		COMMIT TRAN

	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_LOG_PROCESS @sysdate, '', '', @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
		COMMIT;

	END CATCH

	EXEC PR_LOG_PROCESS @sysdate, '', '', @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null
END

