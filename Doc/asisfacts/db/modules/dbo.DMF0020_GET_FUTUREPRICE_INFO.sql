/*
 * Program ID   : DMF0020_GET_FUTUREPRICE_INFO     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 
 */
create PROCEDURE [dbo].[DMF0020_GET_FUTUREPRICE_INFO]
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
