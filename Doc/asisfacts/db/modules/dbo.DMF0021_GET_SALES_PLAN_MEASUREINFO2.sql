/*
 * Program ID   : DMF0021_GET_SALES_PLAN_MEASUREINFO2
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 
 */
create PROCEDURE [dbo].[DMF0021_GET_SALES_PLAN_MEASUREINFO2]
AS
BEGIN
	
    SET NOCOUNT ON;
		
	SELECT  COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME, SORT_ORDER_NO AS DISPLAY_SEQ
	FROM     SCM_MST_SHEET_MEASURE WITH(NOLOCK)
	WHERE  
	PROGRAM_ID = 'DMF1007' AND SHEET_NAME = 'Sales Plan'
	AND COLUMN_NAME LIKE 'SalesAmt%'
	ORDER BY SORT_ORDER_NO
   
END
