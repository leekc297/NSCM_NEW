/*
 * Program ID   : DMF0020_GET_WEEKDATA     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 
 */
CREATE PROCEDURE [dbo].[DMF0082_POPUP_GET_WEEKDATA]
	@p_yyyymmdd           VARCHAR(10)
AS
BEGIN
	
    SET NOCOUNT ON;
		
	SELECT TOP 7 BASIS_START_DATE, BASIS_YYYYMMDD
	FROM [dbo].[SCM_SYS_CALENDAR_M]
	WHERE
	BASIS_YYYYMMDD <= @p_yyyymmdd
	ORDER BY BASIS_YYYYMMDD DESC
   
END
