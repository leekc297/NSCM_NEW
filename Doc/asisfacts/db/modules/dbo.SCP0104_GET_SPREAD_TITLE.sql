
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_GET_SPREAD_TITLE
 * Description  : CAPA NEW 날짜 타이틀 리턴 (SCP0104, SCP0105, SCP0106, SCP0107, SCP0108 공통)   
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2023/10/12   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 */

--CREATE PROCEDURE [dbo].[SCP0104_GET_SPREAD_TITLE]
CREATE PROCEDURE [dbo].[SCP0104_GET_SPREAD_TITLE]
	  @p_from_yyyymm		NVARCHAR(6)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_from_yyyymm			NVARCHAR(4)		    = N'202403';
	--DECLARE @p_program_id			NVARCHAR(100)		= N'SCP0106';
	--DECLARE @p_sheet_name			NVARCHAR(100)		= N'CURRENT';


	SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@p_from_yyyymm, @p_program_id, @p_sheet_name) A
    ORDER BY SORT_ORDER_NO;
END
