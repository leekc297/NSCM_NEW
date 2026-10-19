CREATE FUNCTION [dbo].[FN_GET_CALC_SHIP_FROZEN_DAY_CNT]  
      (@p_frozen_type        nvarchar(50)
      )
      RETURNS INT
AS  
/*  
 * Program ID   : FN_GET_CALC_SHIP_FROZEN_DAY_CNT    
 * Description  : 계산된 출하 확정 구간 조회 
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2024.05.02   hsbang20         Initial Release   
 */  
BEGIN  
    
	DECLARE @v_ship_frozen    int  = 0;    

	SELECT @v_ship_frozen = CASE WHEN LEFT(@p_frozen_type, 1) = 'W' THEN (CAST(RIGHT(@p_frozen_type, 1) AS INT) + 1) * 7
		                                                            ELSE CAST(SUBSTRING(@p_frozen_type, 2, LEN(@p_frozen_type) -1) AS INT)
						    END
      
	RETURN isnull(@v_ship_frozen,0);  
  
END  
;
