/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024/05/17  KJJ         이동계획 판가 - DISPLAY_SEQ로 정렬 추가
 * 2025.01.13	KJJ			[PJ2024-50611] Sales Price 로직 수정 - 별도 룩업이 아니라 해당화면의 메저에서 가져오게 변경 - 수정중
 */
CREATE PROCEDURE [dbo].[DMF0020_GET_MEASURE_COUNTINFO]
AS
BEGIN
	
    SET NOCOUNT ON;
	
	SELECT  
	column_label_name as LOOKUP_CODE
	,column_label_name as DESCRIPTION
	, 99 AS DISPLAY_ALL
	,sort_order_no as DISPLAY_SEQ
	FROM  SCM_MST_SHEET_MEASURE WITH(NOLOCK)
	WHERE  PROGRAM_ID = 'DMF0020' 
	AND SHEET_NAME = 'Sales Price'
	AND VALID_YN = 'Y'
	ORDER BY SORT_ORDER_NO

	/*
	SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 [DESCRIPTION], 99 AS DISPLAY_ALL,DISPLAY_SEQ
	FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) 
	WHERE VALID_YN = 'Y'
	AND SEGMENT1 <> 'LOC'
	AND LOOKUP_TYPE = 'FUTUREMEASURE'
	UNION ALL
	SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 [DESCRIPTION], 99 AS DISPLAY_ALL,DISPLAY_SEQ
	FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) 
	WHERE VALID_YN = 'Y'
	AND SEGMENT1 = 'LOC'
	AND LOOKUP_TYPE = 'FUTUREMEASURE'
    order by DISPLAY_SEQ
	*/
END
