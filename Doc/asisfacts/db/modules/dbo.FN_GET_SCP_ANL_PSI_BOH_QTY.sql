CREATE FUNCTION [dbo].[FN_GET_SCP_ANL_PSI_BOH_QTY]  
      (@p_division_id         nvarchar(50),  
       @p_plan_start_yyyymmdd nvarchar(8),  
       @p_plan_type           nvarchar(10),  
       @p_plan_seq            int,  
       @p_scm_site_id         nvarchar(50),  
       @p_item_id             nvarchar(50) 
      )
      RETURNS NUMERIC(20,10)  
AS  
/*  
 * Program ID   : FN_GET_SCP_ANL_PSI_BOH_QTY    
 * Description  : SCP ENGINE OUTPUT 기준의 PLANT SITE BOH QTY (생산PSI화면전용) 
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.05.01   yydok         Initial Release   
 */  
BEGIN  
    
  DECLARE @x_boh_qty    numeric(20,10) = 0;    

   begin  
  
        select @x_boh_qty = sum(isnull(psi_boh_qty,0))  
          from scp_pln_plant_onhand with(nolock)  
         where division_id               = @p_division_id  
           and stock_type    NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING')   --셀 특성완료이전 제외 
           and plan_start_yyyymmdd       = @p_plan_start_yyyymmdd  
           and plan_type                 = @p_plan_type  
           and seq                       = @p_plan_seq  
           and site_id                   = @p_scm_site_id  
           and item_id                   = @p_item_id  
           and yyyymmdd                  = @p_plan_start_yyyymmdd 
           ;  
  
      
   end  
     
  
      
  RETURN isnull(@x_boh_qty,0);  
  
END  
;
