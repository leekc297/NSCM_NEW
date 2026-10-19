/*
 * Program ID   : DMF0020_GET_FUTUREPRICE_INFO     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 */
CREATE PROCEDURE [dbo].[DMF0082_POPUP_GET_FUTUREPRICE_INFO]
	@p_start_yyyymmdd	VARCHAR(10),
	@p_end_yyyymmdd	VARCHAR(10)
AS
BEGIN
	
    SET NOCOUNT ON;
		
	SELECT YYYYMMDD, SUBSTRING(YYYYMMDD,1,6) AS YYYYMM, DIVISION_ID, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
	FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK)
	WHERE
	YYYYMMDD >= @p_start_yyyymmdd AND YYYYMMDD <= @p_end_yyyymmdd
   
END
