
/*
 * Program ID   : [SCP0113_GET_LGTM_PLAN_EDIT_PERIOD]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2024/12/20   Haru				Create new procedure to get PLAN_EDIT_PERIOD 
 */

CREATE PROCEDURE [dbo].[SCP0113_GET_LGTM_PLAN_EDIT_PERIOD] 

	-- Add the parameters for the stored procedure here
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_GET_LGTM_PLAN_EDIT_PERIOD';
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
	

	SELECT  Top 1 SEGMENT1 EDIT_PERIOD
	FROM   SCM_ADM_LOOKUP_MASTER_DETAIL SAD
	WHERE  LOOKUP_TYPE = 'SCM_LGTM_PLAN_EDIT_PERIOD' AND VALID_YN = 'Y'
	;
	
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count   = @@ROWCOUNT;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------

	
END;
