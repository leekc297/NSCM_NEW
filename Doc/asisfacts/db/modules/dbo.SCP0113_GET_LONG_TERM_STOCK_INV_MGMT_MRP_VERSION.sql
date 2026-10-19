


/*
 * Program ID   : [SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION]
 * Description  : [SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION]
 * Program History
 *===================================================================================================
 * Date         In Charge			Description
 *===================================================================================================
 * 2025/02/05   OIJ				Add new procedures to get MRP Version for SCP0113 LONG-TERM STOCK Management create plan popup
 * 2026/02/26   YMH				[E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경.
 */
CREATE PROCEDURE [dbo].[SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION]

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION';
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
	
	-- [E20260211-001073] MRP->SCM 버전체계 변경으로 인해 버전체계정보를 날짜정보로 변경.
	SELECT DISTINCT LEFT(VRSN_ID,8) AS [CODE],  LEFT(VRSN_ID,8) AS [NAME]  FROM XIF_MRP_TB_RS_ITEM_CONSUM_R_SN WITH(NOLOCK)
	WHERE CONVERT(NVARCHAR(6), IF_RCV_DATE, 112) >= CONVERT(NVARCHAR(8), DATEADD(DAY, -60, GETDATE()), 112)
	AND ISDATE(LEFT(VRSN_ID,8)) = 1
	--AND PLAN_TYP = 'SCP'
	ORDER BY CODE DESC
	
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count   = @@ROWCOUNT;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------


END

