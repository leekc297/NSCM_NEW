/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 */
CREATE PROCEDURE [dbo].[DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE]
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT  
	--column_label_name as LOOKUP_CODE
	--,column_label_name as DESCRIPTION
	COLUMN_NAME AS LOOKUP_CODE
	,COLUMN_NAME AS DESCRIPTION
	, 99 AS DISPLAY_ALL
	FROM  SCM_MST_SHEET_MEASURE WITH(NOLOCK)
	WHERE  PROGRAM_ID = 'DMF0082' 
	AND SHEET_NAME = 'FcstNPrice'
	AND VALID_YN = 'Y'
	AND column_name = 'LOC'

	----SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 [DESCRIPTION], 99 AS DISPLAY_ALL
	----FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) 
	----WHERE VALID_YN = 'Y'
	----AND SEGMENT1 <> 'LOC'
	----AND LOOKUP_TYPE = 'FUTUREMEASURE'
	----UNION ALL

	/*
	 SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 [DESCRIPTION], 99 AS DISPLAY_ALL  
	 FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)   
	 WHERE VALID_YN = 'Y'  
	 AND SEGMENT1 = 'LOC'  
	 AND LOOKUP_TYPE = 'FUTUREMEASURE' 
   */
END
