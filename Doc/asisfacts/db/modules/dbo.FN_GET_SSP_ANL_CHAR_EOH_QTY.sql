
CREATE FUNCTION [dbo].[FN_GET_SSP_ANL_CHAR_EOH_QTY]  
      (@p_division_id         nvarchar(50),  
       @p_plan_start_yyyymmdd nvarchar(8),  
       @p_plan_type           nvarchar(10),  
       @p_plan_seq            int,  
       @p_scm_site_id         nvarchar(50),  
       @p_item_id             nvarchar(50),  
       @p_yyyymmdd            nvarchar(8))  
      RETURNS NUMERIC(20,10)  
AS  
/*  
 * Program ID   : FN_GET_SSP_ANL_CHAR_EOH_QTY    
 * Description  : SSP ENGINE OUTPUT 기준의 PLANT SITE 특성완료 EOH QTY  
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.03.27   yydok         Initial Release 
 * 2018.04.19   yydok         특성완료재고에 대한 stock_type추가반영  'A_MOVE_WH','OUT_WH'
 */  
BEGIN  
    
  DECLARE @x_qty  numeric(20,10) = 0;  
     
  
select @x_qty = SUM(ISNULL(psi_eoh_qty,0))  
  from ssp_pln_plant_onhand with(nolock)  
 where division_id               = @p_division_id  
   and stock_type                IN ('CHAR','A_MOVE_WH','A_OUT_WH') --특성완료재고  
   and plan_start_yyyymmdd       = @p_plan_start_yyyymmdd  
   and plan_type                 = @p_plan_type  
   and seq                       = @p_plan_seq  
   and site_id                   = @p_scm_site_id  
   and item_id                   = @p_item_id  
   and yyyymmdd                  = @p_yyyymmdd  
   ;  
      
  RETURN isnull(@x_qty,0);  
  
END  
;
