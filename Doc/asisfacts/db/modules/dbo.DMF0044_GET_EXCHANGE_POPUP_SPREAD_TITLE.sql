/****************************************************************************************************/
/* Program ID  : DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE                                            */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/03/23  P.C.I        Initial Release [prepare] Sales Report Exchange Rate Popup              */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE]
    @p_year  NVARCHAR(4)
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT MIN(BASIS_START_DATE) AS BASIS_START_DATE, CALENDAR_YYYY, CALENDAR_MONTH
	FROM   [dbo].[SCM_SYS_CALENDAR_M] with (nolock)
	WHERE  CALENDAR_YYYY = @p_year
	GROUP BY CALENDAR_YYYY, CALENDAR_MONTH
	ORDER BY BASIS_START_DATE

END

