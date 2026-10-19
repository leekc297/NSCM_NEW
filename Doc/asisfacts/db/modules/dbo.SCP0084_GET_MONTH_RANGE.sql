/****************************************************************************************************
* Program ID  : SCP0084_GET_DAY_RANGE                                                       
* Description : SCP0084 조회 월 범위를 위한 프로시저                                                      
* Usage       :
* Parameter   :
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2021/11/25  KMJ	      Initial Release - [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
* 2023/10/25  vadabi3	  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 -  조회 기간 변경
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0084_GET_MONTH_RANGE]
	@p_month          INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN

		/*
		SELECT DISTINCT 
			MIN(BASIS_YYYYMM) AS MIN_YYYYMM
			, MAX(BASIS_YYYYMM) AS MAX_YYYYMM
		FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		WHERE BASIS_DATE <= DATEADD(MONTH, -1, GETDATE()) -- MAX 이전 달까지만
		AND BASIS_DATE >= DATEADD(MONTH, -@p_month, GETDATE()) 
		;

	   SELECT MIN(yyyymm) AS MIN_YYYYMM
			, MAX(yyyymm) AS MAX_YYYYMM
		FROM SCP_ANL_MONTH_END_STOCK_R WITH(NOLOCK)
		*/

		
		SELECT MIN(yyyymm) AS MIN_YYYYMM
			 , MAX(yyyymm) AS MAX_YYYYMM
		FROM SCP_ANL_LONG_TERM_STOCK WITH(NOLOCK)


	END

END
