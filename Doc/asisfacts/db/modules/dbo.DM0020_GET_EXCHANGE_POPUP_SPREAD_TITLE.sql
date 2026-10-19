/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/04/01  JYE		     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
create PROCEDURE [dbo].[DM0020_GET_EXCHANGE_POPUP_SPREAD_TITLE]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8)
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT   MIN(BASIS_START_DATE) AS BASIS_START_DATE, CALENDAR_YYYY, CALENDAR_MONTH
	FROM [dbo].[SCM_SYS_CALENDAR_M]
	WHERE
	BASIS_YYYYMMDD >= @p_start_yyyymmdd AND BASIS_YYYYMMDD <= @p_end_yyyymmdd
	GROUP BY CALENDAR_YYYY, CALENDAR_MONTH
	ORDER BY BASIS_START_DATE

END

