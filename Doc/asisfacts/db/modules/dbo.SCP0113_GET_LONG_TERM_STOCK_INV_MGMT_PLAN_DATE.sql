
/*
 * Program ID   : SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE
 * Description  : SCP0113 LONG-TERM STOCK Management PLAN DATE
 * Program History
 *===================================================================================================
 * Date         In Charge			Description
 *===================================================================================================
 * 2024/09/13   Quoc Tan (tanvq1)	Add new procedures to get Plan Date for SCP0113 LONG-TERM STOCK Management
 */
CREATE PROCEDURE [dbo].[SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE]

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########'; 
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  
	
	SELECT DISTINCT  PLAN_START_YYYYMMDD AS [CODE], 
	FORMAT(CONVERT(DATE, CAST(CAST(PLAN_START_YYYYMMDD AS CHAR(8)) AS DATE), 112), 'yyyy-MM-dd') + ' (W' + CAST(DATEPART(WEEK, CONVERT(DATE, CAST(CAST(PLAN_START_YYYYMMDD AS CHAR(8)) AS DATE), 112)) AS VARCHAR) + ')' AS [NAME]
	FROM   SCM_LGTM_INV_PSI_SUMMARY
	WHERE  1=1
	AND   CONVERT(DATETIME, PLAN_START_YYYYMMDD ) >= GETDATE() - 365
	Order By CODE desc
	;
	
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count   = @@ROWCOUNT;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------

END

