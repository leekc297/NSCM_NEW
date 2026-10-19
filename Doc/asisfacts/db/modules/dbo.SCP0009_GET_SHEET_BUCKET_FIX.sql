
/****************************************************************************************************
* Program ID  : SCP0009_GET_SHEET_BUCKET_FIX                                                       
* Description : BUCKET에 따른 header 고정을 위한 division별 데이터 조회 
* Usage       : exec SCP0009_GET_SHEET_BUCKET_FIX													
* Parameter   : @p_division_id='40'                                                     
*               @p_plan_start_yyyymmdd='20180806'                                                         
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2018/08/10  YHW			Initial Release  
* ex)
* EXEC SCP0009_GET_SHEET_BUCKET_FIX @p_division_id ='40' , @p_plan_start_yyyymmdd='20180806'
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0009_GET_SHEET_BUCKET_FIX]
	@p_division_id NVARCHAR(30),
    @p_plan_start_yyyymmdd    NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
    select BASIS_YYYYMM AS BASIS_MONTH, 
			BASIS_YYYYMM+ISO_WEEK AS BASIS_WEEK, --week_name, BASIS_YYYYMMDD
			BASIS_END_DATE AS BASIS_DAY,
			week_name,
			ISO_WEEK
	from SCM_SYS_CALENDAR_M a
	JOIN SCM_MST_DIVISION B
		ON B.DIVISION_ID=@p_division_id
	where A.BASIS_YYYYMMDD = convert(nvarchar(8),dateadd(DD, ((B.DAILY_PLAN_PERIOD * 7) - 1), @p_plan_start_yyyymmdd),112)

END

