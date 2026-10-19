/****************************************************************************************************
* Date        In Charge			Description
*--------------------------------------------------------------------------------------------------
* 2022.12.12  vadabi3			Create : [SCP0076] 조회 기간 Combo) Plan Date Week List 					
****************************************************************************************************/
CREATE PROCEDURE [dbo].[SCP0076_GET_SHEET_CALENDAR_3SPAN]
	@p_plan_start_yyyymmdd  NVARCHAR(8)
   ,@p_plan_end_yyyymmdd  NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;

	 -------------------------------------------------------------------------
	 -- UP_FX_GetCommonDataList_SCP > PlanDate_REPORT 참고
	 -------------------------------------------------------------------------
                 SELECT BASIS_YYYYMMDD
				      , WEEK_NAME
					  , ISO_YYYYWW
					  , ISO_YYYYWW + CONVERT(CHAR(2), 31)	AS SORT_ORDER_NO
					  , DATE_FULL_NAME +' ('+ WEEK_NAME + ')' AS NAME--CALENDAR_YYYY +'-'+ WEEK_NAME AS NAME
				   FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
				  WHERE 1 = 1 
				    AND DAYOFWEEK = 'MON'
					AND BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
	                AND BASIS_YYYYMMDD <= @p_plan_end_yyyymmdd
               ORDER BY BASIS_YYYYMMDD 

END
