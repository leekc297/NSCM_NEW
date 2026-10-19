
/*
 * Program ID   : SCP0116_GET_GLOBAL_PSI_REPORT
 * Description  : GLOBAL PSI 조회
 * Program History
 *================================================================================================================================================
 *   Date       In Charge                           Description
 *================================================================================================================================================
 * 2024/11/19   Haru								Clone from SCP0100
========================================================================================================================================================== */
CREATE PROCEDURE [dbo].[SCP0116_GET_GLOBAL_PSI_REPORT]
	  @p_from_yyyymmdd			NVARCHAR(8)
	, @p_to_yyyymmdd			NVARCHAR(8)
	, @p_division_id            NVARCHAR(30)
	, @p_item_id				NVARCHAR(MAX)
	, @p_nick_name				NVARCHAR(MAX)
	, @p_from_site				NVARCHAR(MAX)
	, @p_to_site				NVARCHAR(MAX)
	, @p_plan_start_yyyymmdd	NVARCHAR(8)
	, @p_plan_type				NVARCHAR(50)
	, @p_user_id				NVARCHAR(MAX)
	, @p_bucket				    NVARCHAR(10)
	, @p_cell_group			    NVARCHAR(MAX)
	, @p_project			    NVARCHAR(MAX)
	, @p_search_level			NVARCHAR(MAX)
	, @p_chk_cell_qty			NVARCHAR(1)
	, @p_chk_as			        NVARCHAR(1)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	--DECLARE @p_from_yyyymmdd		NVARCHAR(8)		= N'20240101';
	--DECLARE @p_to_yyyymmdd			NVARCHAR(8)		= N'20250112';
	--DECLARE @p_division_id          NVARCHAR(30)	= N'81';
	--DECLARE @p_item_id				NVARCHAR(MAX)	= N'';
	--DECLARE @p_nick_name			NVARCHAR(MAX)	= N'';
	--DECLARE @p_from_site			NVARCHAR(MAX)	= N'';
	--DECLARE @p_to_site				NVARCHAR(MAX)	= N'';
	--DECLARE @p_plan_start_yyyymmdd	NVARCHAR(8)		= N'20240115';
	--DECLARE @p_plan_type			NVARCHAR(50)	= N'FN';
	--DECLARE @p_user_id				NVARCHAR(MAX)	= N'iamarock';
	--DECLARE @p_bucket				NVARCHAR(10)	= N'WEEKLY';
	----DECLARE @p_bucket				NVARCHAR(10)	= N'MONTHLY';
	--DECLARE @p_cell_group			NVARCHAR(MAX)	= N'';
	--DECLARE @p_project			    NVARCHAR(MAX)	= N'';
	--DECLARE @p_search_level			NVARCHAR(MAX)	= N'CELL_GROUP';
	--DECLARE @p_chk_cell_qty			NVARCHAR(1)		= N'Y';
	--DECLARE @p_chk_as			    NVARCHAR(1)		= N'N';
	--DECLARE @debug_mode				NVARCHAR(1)		= N'F';


	DECLARE @p_program_id			NVARCHAR(MAX)	= N'SCP0116'
	DECLARE @p_sheet_name			NVARCHAR(MAX)	= N'Global PSI Report'


	IF @p_bucket = 'WEEKLY'
	BEGIN
		EXEC SCP0116_GET_GLOBAL_PSI_REPORT_WW_DATAONLY
			  @p_from_yyyymmdd
			, @p_to_yyyymmdd
			, @p_division_id
			, @p_item_id
			, @p_nick_name
			, @p_from_site
			, @p_to_site
			, @p_plan_start_yyyymmdd
			, @p_plan_type
			, @p_user_id
			, @p_bucket
			, @p_cell_group
			, @p_project
			, @p_search_level
			, @p_chk_cell_qty
			, @p_chk_as
			, @debug_mode;
	END
	ELSE IF @p_bucket = 'MONTHLY'
	BEGIN
		EXEC SCP0116_GET_GLOBAL_PSI_REPORT_MM_DATAONLY
			  @p_from_yyyymmdd
			, @p_to_yyyymmdd
			, @p_division_id
			, @p_item_id
			, @p_nick_name
			, @p_from_site
			, @p_to_site
			, @p_plan_start_yyyymmdd
			, @p_plan_type
			, @p_user_id
			, @p_bucket
			, @p_cell_group
			, @p_project
			, @p_search_level
			, @p_chk_cell_qty
			, @p_chk_as
			, @debug_mode;
	END
END

