/****************************************************************************************************
* Program ID  : SCP0049_GET_DAY_RANGE                                                       
* Description : SCP0049 조회 날짜 범위를 위한 프로시저                                                      
* Usage       : exec SCP0049_GET_DAY_RANGE													
* Parameter   : @p_created_by='test01' , @p_month = 6                                                    
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2020/09/01  khj79	      [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 기준정보
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0049_GET_DAY_RANGE]
	 @p_created_by	   NVARCHAR(30)
	,@p_month          INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_user_time_zone AS NVARCHAR(10);
	
	BEGIN
	    SELECT @v_user_time_zone = U.TIMEZONE
		  FROM [dbo].[TB_FX_User] U
		 WHERE U.UserID = @p_created_by;
	END

	BEGIN
		SELECT MIN(BASIS_YYYYMM) AS FROM_VALUE
			 , MAX(BASIS_YYYYMM) AS TO_VALUE
		  FROM [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) 
		 WHERE BASIS_YYYYMM >= CONVERT(CHAR(6), DATEADD(m, -6 , dbo.FN_MULTY_TIME(@v_user_time_zone)), 112) 
		   AND BASIS_YYYYMM <= CONVERT(CHAR(6), DATEADD(m, ( @p_month -1 ), dbo.FN_MULTY_TIME(@v_user_time_zone)), 112) 
	END

END
