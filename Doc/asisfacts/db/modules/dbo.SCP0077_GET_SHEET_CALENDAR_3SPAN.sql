/****************************************************************************************************
* Date        In Charge    Description
*--------------------------------------------------------------------------------------------------
* 2021.11.12  khj79		   [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 최초작성
* 2022.09.02  LWY          PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Shipping result check 당주구간 일Bucket 추가 (당주)
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0077_GET_SHEET_CALENDAR_3SPAN]
	@p_plan_start_yyyymmdd  NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @v_start_yyyymmdd NVARCHAR(8) = CONVERT(NVARCHAR(8),DATEADD(DAY,- 7*4 , @p_plan_start_yyyymmdd ) ,112);
	DECLARE @v_end_yyyymmdd	 NVARCHAR(8) = CONVERT(NVARCHAR(8),DATEADD(DAY,7 -1 , @p_plan_start_yyyymmdd ) ,112);

	SELECT A.BASIS_YYYYMMDD						AS BASIS_YYYYMMDD
		 , A.WEEK_NAME							AS WEEK_NAME
		 , A.ISO_YYYYWW + CONVERT(CHAR(2), 31)	AS SORT_ORDER_NO
		 , CASE WHEN @p_plan_start_yyyymmdd = BASIS_YYYYMMDD THEN 1 ELSE 2 END SORT_ORDER_NO2
	  FROM [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
	 WHERE A.BASIS_YYYYMMDD >= @v_start_yyyymmdd
	   AND A.basis_yyyymmdd <= @v_end_yyyymmdd
	   and a.DAYOFWEEK = 'MON'
	 ORDER BY SORT_ORDER_NO2, SORT_ORDER_NO
	 ;

	 ------------------------------- Daily -----------------------------------------

	DECLARE @v_start_yyyymmdd_daily NVARCHAR(8) = CONVERT(NVARCHAR(8),DATEADD(DAY,0 , @p_plan_start_yyyymmdd ) ,112);
	DECLARE @v_end_yyyymmdd_daily	NVARCHAR(8) = CONVERT(NVARCHAR(8),DATEADD(DAY,7-1 , @p_plan_start_yyyymmdd ) ,112);

	SELECT 
	      @p_plan_start_yyyymmdd			AS BASIS_YYYYMMDD        
		, A.WEEK_NAME               AS WEEK_NAME        
		, A.CALENDAR_DAY            AS DAY_NAME
	    , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 3 ) AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @v_start_yyyymmdd_daily 
    AND    A.basis_yyyymmdd <= @v_end_yyyymmdd_daily 
    ORDER BY sort_order_no
	;

END

