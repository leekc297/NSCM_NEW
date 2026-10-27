-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PR_XIF_MAIL_TEST]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

					DECLARE @SUBJECT NVARCHAR(100) = '[ERROR] [LIVE] TEST'
					DECLARE @RECEIVE NVARCHAR(1000) = 'chkim.68@lgespartner.com'--kimseok@lgchem.com'		

					DECLARE @MSG NVARCHAR(MAX) =
												'<table width=800 border=1 style=border-collapse:collapse cellpadding=10>' +
												'	<tr>'                                                                  +
												'		<td>LIVE Procedure Name</td>'                                      +
												'		<td>TEST</td>'                                                     +
												'		<td>DTTM</td>'                                                     +
												'		<td>'+ CONVERT(NVARCHAR(20), GETDATE(), 120) +'</td>'              +
												'	</tr>'                                                                 +
												'	<tr>'                                                                  +
												'		<td colspan=4>'                                                    +
												'Error Message<br><br>TEST'                                                +
												'		</td>'                                                             +
												'	</tr>'                                                                 +
												'</table>'

					EXEC msdb.dbo.sp_send_dbmail
					@profile_name = 'FP_MAIL_TEST'
					, @recipients = @RECEIVE
					, @subject    = @SUBJECT
					, @body       = @MSG

END

