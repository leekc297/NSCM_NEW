/****************************************************************************************************
* Program ID  : SSP0016_GET_SHEET_HOLIDAY_CALENDAR                                                       
* Description : SSP 휴일 설정을 위한 달력
* Usage       : exec SCP_GET_SHEET_CALENDAR_3SPAN
* Parameter   : @p_division_id = '40'
				@p_from_site = 'A010'
				@p_start_yyyymmdd='20190601'                                                     
*               @p_end_yyyymmdd='20190730'                                                         
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2019/06/14  cmTheJ			Initial Release  
* ex)
* EXEC SSP0016_GET_SHEET_HOLIDAY_CALENDAR @p_sivision_id = '40', @p_from_site = 'A010-A', @p_start_yyyymmdd ='20190701' , @p_end_yyyymmdd='20190831'
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SSP0016_GET_SHEET_HOLIDAY_CALENDAR]
	@p_sivision_id	   NVARCHAR(60),
	@p_from_site	   NVARCHAR(60),
	@p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		T0.YYYYMMDD,
		T0.DAYWEEK_STATE
	FROM
	(
		SELECT 
			B.YYYYMMDD,
			B.WORKDAY_YN AS DAYWEEK_STATE
		FROM SCM_MST_SITE  A WITH(NOLOCK)
		INNER JOIN SSP_MST_SHIP_CALENDAR B WITH(NOLOCK)
			ON A.DIVISION_ID = B.DIVISION_ID AND A.COMPANY_ID = B.COMPANY_ID
		WHERE 1 = 1
		AND A.DIVISION_ID = @p_sivision_id
		AND A.SITE_TYPE = 'PLANT'
		AND A.SCM_SITE_ID = @p_from_site
		AND B.YYYYMMDD >= @p_start_yyyymmdd
		AND B.YYYYMMDD <= @p_end_yyyymmdd
	) T0
	WHERE T0.DAYWEEK_STATE = 'N'
	ORDER BY T0.YYYYMMDD;
	
END
