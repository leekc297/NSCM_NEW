/****************************************************************************************************/
/* Program ID  : DMF0000_GET_EXCHANGE_POPUP_DATA		                                            */
/* Description : 사용자 환율 관리 프로그램 (개발기준, Sales Price,Sales Plan,Fcst&Price에서 사용)	*/
/* Usage       : Procedure 작성 시 참조하세요!														*/
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE 참고해서 만듬                                            */
/* 2025.04.24       dsiol		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율 관리 프로그램 */
/* EXEC [DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE] '20250401','20260401'							    */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8)
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT   MIN(BASIS_START_DATE) AS BASIS_START_DATE, CALENDAR_YYYY, CALENDAR_MONTH
	FROM [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
	WHERE
	BASIS_YYYYMMDD >= @p_start_yyyymmdd AND BASIS_YYYYMMDD <= @p_end_yyyymmdd
	GROUP BY CALENDAR_YYYY, CALENDAR_MONTH
	ORDER BY BASIS_START_DATE

END
