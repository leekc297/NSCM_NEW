/****************************************************************************************************
* Program ID  : SCP0049_GET_SHEET_CALENDAR_3SPAN                                                       
* Description : SCP0049 칼렌더 생성위한 프로시저                                                       
* Usage       : exec SCP0049_GET_SHEET_CALENDAR_POPUP													
* Parameter   : @p_today_yyyymmdd='201712'                                                     
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2020/08/12  khj79	      [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 기준정보
* 2021/07/08  khj79       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 2년(24+5) 조회 변경
* 2021/07/22  khj79       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 3년(36+5) 조회 변경
* ex)
* EXEC SCP0049_GET_SHEET_CALENDAR_POPUP @p_today_yyyymm ='20180122'
****************************************************************************************************/




CREATE PROCEDURE [dbo].[SCP0049_GET_SHEET_CALENDAR_POPUP]
	@p_today_yyyymm  NVARCHAR(6)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @p_next_yyyy NVARCHAR(4);


	SET @p_next_yyyy =  CONVERT(NVARCHAR(4), DATEADD(yy,1, @p_today_yyyymm + '01' ),112 )

	 SELECT 'M_' + A.BASIS_YYYYMM	AS COLUMN_NAME
		  , A.MONTH_NAME			AS COLUMN_LABEL_NAME
		  , A.MONTH_NAME			AS SMALL_CLASS_LABEL_NAME
		  , A.MONTH_NAME			AS LARGE_CLASS_LABEL_NAME
		  , ''						AS DAY_CODE
		  , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
	   FROM [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	    WHERE A.BASIS_YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MM,0 , @p_today_yyyymm + '01' ) , 112)
		  AND A.BASIS_YYYYMM <= CONVERT(NVARCHAR(6), DATEADD(MM,41, @p_today_yyyymm + '01' ) , 112)  -- 2년(36+5) 조회 변경(29-> 41)
	  GROUP BY A.BASIS_YYYYMM
			 , A.MONTH_NAME
	ORDER BY sort_order_no

END


