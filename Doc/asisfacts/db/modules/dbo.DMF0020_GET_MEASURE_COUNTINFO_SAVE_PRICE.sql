/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/04  kuniid         [C20210127-000163] GSCM Sales Price 일괄입력 기능 개선 요청
 * 2025.01.13	KJJ			[PJ2024-50611] Sales Price 로직 수정 - 별도 룩업이 아니라 해당화면의 메저에서 가져오게 변경 - 수정중
 
 */
CREATE PROCEDURE [dbo].[DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE]
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT  
	column_label_name as LOOKUP_CODE
	,column_label_name as DESCRIPTION
	, 99 AS DISPLAY_ALL
	FROM  SCM_MST_SHEET_MEASURE WITH(NOLOCK)
	WHERE  PROGRAM_ID = 'DMF0020' 
	AND SHEET_NAME = 'Sales Price'
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
