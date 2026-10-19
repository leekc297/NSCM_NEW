CREATE FUNCTION [dbo].[FN_GET_SSP_ANL_SHIP_FROZEN]  
      (@p_division_id         nvarchar(50),  
       @p_from_site             nvarchar(50) 
      )
      RETURNS INT
AS  
/*  
 * Program ID   : FN_GET_SSP_ANL_SHIP_FROZEN    
 * Description  : 출하 확정 구간 조회 
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.08.20   LJH         Initial Release   
 */  
BEGIN  
    
  DECLARE @v_ship_frozen    int  = 0;    

   begin  
  
        select @v_ship_frozen = ship_frozen
          from SCM_MST_SITE  with(nolock)  
         where division_id = @p_division_id  
           and scm_site_id = @p_from_site  
           and valid_yn    = 'Y'
           ;  
   end  
     
 
      
  RETURN isnull(@v_ship_frozen,0);  
  
END  
;
