/****************************************************************************************************
* Program ID  : SCP0052_GET_SHEET_CALENDAR                                                       
* Description : SCP0052 칼렌더 생성위한 프로시저                                                       
* Usage       : exec SCP0052_GET_SHEET_CALENDAR													
* Parameter   : @p_today_yyyymmdd='201712'                                                     
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2021/02/02  khj79	      [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 기준정보
* ex)
* EXEC SCP0052_GET_SHEET_CALENDAR @p_today_yyyymm ='20180122'
****************************************************************************************************/



create PROCEDURE [dbo].[SCP0052_GET_SHEET_CALENDAR]
	@p_today_yyyymmdd  NVARCHAR(8)
	, @p_from_yyyymm NVARCHAR(6)
	, @p_to_yyyymm NVARCHAR(6)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_start_day NVARCHAR(8);
	DECLARE @v_end_day NVARCHAR(8);

	DECLARE @v_start_month NVARCHAR(6);
	DECLARE @v_end_month NVARCHAR(6);

	SET @v_start_month = @p_from_yyyymm ;
	SET @v_end_month= @p_to_yyyymm;

	 SELECT 'M_' + A.BASIS_YYYYMM	AS COLUMN_NAME
		  , A.MONTH_NAME			AS COLUMN_LABEL_NAME
		  , A.MONTH_NAME			AS SMALL_CLASS_LABEL_NAME
		  , A.MONTH_NAME			AS LARGE_CLASS_LABEL_NAME
		  , ''						AS DAY_CODE
		  , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
	   FROM [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	  WHERE A.BASIS_YYYYMM >= @v_start_month
		AND A.BASIS_YYYYMM <= @v_end_month
	  GROUP BY A.BASIS_YYYYMM
			 , A.MONTH_NAME

END
