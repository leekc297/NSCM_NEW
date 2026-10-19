/****************************************************************************************************
* Program ID  : SCP0054_GET_SHEET_CALENDAR                                                       
* Description : SCP0054 칼렌더 생성위한 프로시저                                                       
* Usage       : exec SCP0054_GET_SHEET_CALENDAR													
* Parameter   : @p_today_yyyymmdd='201712'                                                     
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2021/04/01  khj79	      [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - 최초작성
****************************************************************************************************/



CREATE PROCEDURE [dbo].[SCP0054_GET_SHEET_CALENDAR]
	@p_today_yyyymmdd  NVARCHAR(8)
	, @p_from_yyyymm NVARCHAR(6)
	, @p_to_yyyymm NVARCHAR(6)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_start_month NVARCHAR(6);
	DECLARE @v_end_month NVARCHAR(6);

	BEGIN
		SET @v_start_month =  CONVERT(CHAR(6) , @p_today_yyyymmdd);
		SET @v_end_month= @p_to_yyyymm;
	END
	
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

	  UNION ALL

	 SELECT 'Y_'+ A.CALENDAR_YYYY	AS COLUMN_NAME
		  , A.CALENDAR_YYYY			AS COLUMN_LABEL_NAME
		  , A.CALENDAR_YYYY			AS SMALL_CLASS_LABEL_NAME
		  , A.CALENDAR_YYYY			AS LARGE_CLASS_LABEL_NAME
		  , ''						AS DAY_CODE
		  , CALENDAR_YYYY + CONVERT(CHAR(6), '123132') AS SORT_ORDER_NO
	  FROM [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
	 WHERE A.CALENDAR_YYYY >= '9999'
	   AND A.CALENDAR_YYYY <= '9999'
	 GROUP BY A.CALENDAR_YYYY
	ORDER BY sort_order_no

END


