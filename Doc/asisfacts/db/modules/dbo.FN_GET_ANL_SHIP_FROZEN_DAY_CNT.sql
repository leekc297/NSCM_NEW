CREATE FUNCTION [dbo].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT]  
      (@p_app_type				nvarchar(50), --SCP, SSP 
	   @p_division_id			nvarchar(50),  
       @p_from_site				nvarchar(50),
	   @p_plan_start_yyyymmdd   NVARCHAR(8)
      )
      RETURNS INT
AS  
/*  
 * Program ID   : FN_GET_ANL_SHIP_FROZEN_DAY_CNT    
 * Description  : 시스템별 출하 확정 구간 조회
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2024.05.02   hsbang20         Initial Release   
 */  
BEGIN  
    
	DECLARE @v_ship_frozen    int  = 0;    
	DECLARE @v_week_day       int  = 0;    
	
	IF (@p_app_type = 'SCP')
	BEGIN
		SELECT @v_ship_frozen = SHIP_FROZEN
          FROM dbo.SCM_MST_SITE  WITH(NOLOCK)  
         WHERE DIVISION_ID = @p_division_id  
           AND SCM_SITE_ID = @p_from_site  
           AND VALID_YN    = 'Y'
           ;  
	END
	ELSE --SSP
	BEGIN 
		SELECT @v_week_day = (CASE DATEPART(WEEKDAY, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) WHEN 2 THEN 0 --월
																									 WHEN 3 THEN 1 --화
																									 WHEN 4 THEN 2 --수
																									 WHEN 5 THEN 3 --목
																									 WHEN 6 THEN 4 --금
																									 WHEN 7 THEN 5 --토
																									 WHEN 1 THEN 6 --일
							  END)
		;
		SELECT @v_ship_frozen = CASE WHEN LEFT(ATTRIBUTE6, 1) = 'W' THEN (CAST(RIGHT(ATTRIBUTE6, 1) AS INT) + 1) * 7 - @v_week_day
																	ELSE CAST(SHIP_FROZEN AS INT)
								END

         FROM dbo.SCM_MST_SITE  WITH(NOLOCK)  
         WHERE DIVISION_ID = @p_division_id  
           AND SCM_SITE_ID = @p_from_site  
           AND VALID_YN    = 'Y'
           ;  
	END  
      
	RETURN isnull(@v_ship_frozen,0);  
  
END  
;
