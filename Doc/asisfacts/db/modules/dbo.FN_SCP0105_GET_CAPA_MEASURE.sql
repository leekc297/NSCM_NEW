
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : FN_SCP0105_GET_CAPA_MEASURE
 * Description  : CAPA Report별 Measure 리턴
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/03/04   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 */

--CREATE FUNCTION [dbo].[FN_SCP0105_GET_CAPA_MEASURE]
CREATE FUNCTION [dbo].[FN_SCP0105_GET_CAPA_MEASURE]
(
	  @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
)
RETURNS @TBL_RES TABLE
--DECLARE @TBL_RES TABLE
(
      MEASURE	                NVARCHAR(400)
    , MEASURE_NAME	            NVARCHAR(300)
    , SORT_ORDER_NO	            INT
)
AS
BEGIN
	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0105';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'MAIN';



    DECLARE @TBL_1 TABLE
    (
		  MEASURE				    NVARCHAR(400)
		, MEASURE_NAME				NVARCHAR(300)
		, SORT_ORDER_NO				INT	
    )
    
	INSERT INTO @TBL_1
    SELECT    COLUMN_NAME           AS MEASURE	
            , COLUMN_LABEL_NAME     AS MEASURE_NAME
            , SORT_ORDER_NO
    FROM    SCM_MST_SHEET_MEASURE WITH(NOLOCK)
    WHERE   1=1
        AND PROGRAM_ID  = @p_program_Id
        AND SHEET_NAME  = @p_sheet_name
        AND VALID_YN = 'Y';


--TESTING : NOK
--select * from @TBL_1;--return;

	INSERT INTO @TBL_RES
	SELECT	*
	FROM	@TBL_1

--TESTING : NOK
--select * from @TBL_RES order by VER_SEQ;

    RETURN;
END
