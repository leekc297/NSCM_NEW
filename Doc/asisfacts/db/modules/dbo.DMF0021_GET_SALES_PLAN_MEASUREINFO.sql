/*
 * Program ID   : DMF0021_GET_SALES_PLAN_MEASUREINFO     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15	JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024.11.15	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
							룩업에 등록된 메저 가져옴(DM_SALES_PLAN_MEASURE)


 EXEC DMF0021_GET_SALES_PLAN_MEASUREINFO
 */
CREATE PROCEDURE [dbo].[DMF0021_GET_SALES_PLAN_MEASUREINFO]
AS
BEGIN
	
    SET NOCOUNT ON;
	
	SELECT 
		SEGMENT1 AS CODE
		,SEGMENT2 AS NAME
		,DISPLAY_SEQ
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_MEASURE'
	AND VALID_YN = 'Y'
	ORDER BY DISPLAY_SEQ

	--[PJ2024-50611]기존 쿼리 주석처리
	/*
	SELECT  COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME, SORT_ORDER_NO AS DISPLAY_SEQ
	FROM     SCM_MST_SHEET_MEASURE WITH(NOLOCK)
	WHERE  
	PROGRAM_ID = 'DMF1007' AND SHEET_NAME = 'Sales Plan'
	*/
   
END
