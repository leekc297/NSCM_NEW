
/*
 * Program ID   : DMF0042_GET_EXCHANGE_PRICE
 * Description  : Biz Plan 에서 사용되는 환율 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/10   JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[DMF0042_GET_EXCHANGE_PRICE]
  @p_start_yyyymmdd NVARCHAR(10),
  @p_end_yyyymmdd NVARCHAR(10)
AS
BEGIN
	
  SET NOCOUNT ON;
  
	SELECT YYYYMMDD, SUBSTRING(YYYYMMDD,1,6) AS YYYYMM, DIVISION_ID, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
	FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK)
	WHERE
	YYYYMMDD >= @p_start_yyyymmdd AND YYYYMMDD <= @p_end_yyyymmdd

END

