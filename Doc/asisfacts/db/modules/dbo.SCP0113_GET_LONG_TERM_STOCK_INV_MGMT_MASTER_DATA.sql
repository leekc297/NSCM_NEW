
/*
 * Program ID   : SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA
 * Description  : SCP0113 LONG-TERM STOCK Management Master Data
 * Program History
 *===================================================================================================
 * Date         In Charge			Description
 *===================================================================================================
 * 2024/09/13   Haru    Add new procedures to get Long-Term Stock Data for SCP0113 LONG-TERM STOCK Management Master Data
 */
CREATE PROCEDURE [dbo].[SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA]
	@p_lookup_type		NVARCHAR(100),		
	@p_segment1			NVARCHAR(100),
	@p_segment2			NVARCHAR(100),
	@debug_mode			NVARCHAR(1) = 'T'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA';
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
	
	SELECT Distinct ATTRIBUTE1 AS CODE
	FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE 1=1
	AND    LOOKUP_TYPE = @p_lookup_type
	AND    SEGMENT1    = @p_segment1
	AND    SEGMENT2    = @p_segment2
	
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count   = @@ROWCOUNT;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------

END

