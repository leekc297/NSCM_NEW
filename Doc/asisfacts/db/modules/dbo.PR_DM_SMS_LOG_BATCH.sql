
/*=====================================================================================================================================================================
 * Program ID   : PR_DM_SMS_LOG_BATCH
 * Program ID   : PR_DM_SMS_LOG_BATCH
 * Description  : 로그에 생성되는 내용으로 SMS 발송
 * Program History
 *=====================================================================================================================================================================
 *   Date       In Charge		Description
 *=====================================================================================================================================================================
 * 2025.08.25	JSSBAE			[E20250805-000632]_MKT FCST Cutoff 프로시저 모니터링용 SMS 발송
 *====================================================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_SMS_LOG_BATCH]
	@p_category_name	NVARCHAR(150)
  , @p_log_type			NVARCHAR(30) -- START/END/ERROR
  , @p_description		NVARCHAR(500)
  , @p_event_date		DATETIME
 AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
    
	BEGIN 	

PRINT 'PR_DM_SMS_LOG_BATCH'+ ': A001: ' + ' @p_category_name: ' + @p_category_name + ' @p_log_type: ' + @p_log_type + ' @p_description: '+ @p_description + convert(varchar(30), getdate(), 121);
		DECLARE @v_category_id			NVARCHAR(10);
		DECLARE @v_sms_desc				NVARCHAR(MAX);	
		
		SET @v_sms_desc = @p_description + '::' + @p_log_type + '::' ;

		SELECT @v_category_id = A.CATEGORY_ID
		FROM SCM_ADM_RECIPIENT_LIST A WITH(NOLOCK)
		WHERE A.CATEGORY_DESC = @p_category_name

        EXEC SCM_ADM_SMS_SEND_BATCH @v_category_id, @v_sms_desc;

PRINT 'PR_DM_SMS_LOG_BATCH'+ ': A003: ' + ' @v_category_id: ' + @v_category_id + ' @v_sms_desc: '+ @v_sms_desc + ' : '+ convert(varchar(30), getdate(), 121);

    END 
END
