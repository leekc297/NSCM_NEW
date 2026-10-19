
CREATE FUNCTION [dbo].[FN_GET_SSP_ANL_BOH_QTY]  
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
 * Program ID   : FN_GET_SSP_ANL_BOH_QTY    
 * Description  : SSP ENGINE OUTPUT 기준의 PLANT SITE BOH QTY  
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.03.14   yydok         Initial Release   
 * 2018.03.15   yydok         plant site boh외에 sales site boh도 포함하여 조회하도록 변경  
 * 2018.05.17   yydok         FOR_STOCKPLAN 제외처리
 * 2018.06.14   LTW           SCP -> SSP 변환 생성
 *
 */  
BEGIN  
    
  DECLARE @x_boh_qty    numeric(20,10) = 0;  
  DECLARE @x_site_type  nvarchar(100)  = '';  
     
  
select @x_site_type = site_type  
  from scm_mst_site     s with(nolock)  
 where 1=1  
   and s.division_id    = @p_division_id  
   and s.scm_site_id    = @p_scm_site_id  
   ;  
   
if @x_site_type = 'PLANT'  
   begin  
  
        select @x_boh_qty = sum(isnull(psi_boh_qty,0))  
          from ssp_pln_plant_onhand with(nolock)  
         where division_id               = @p_division_id  
           and stock_type    NOT IN ( 'FOR_STOCKPLAN','FORMING','FORMED','CHARING','CHAR','A_MOVE_WH','A_OUT_WH')   --셀 활성화진행중 이후 특성,창고재고 제외 
           and plan_start_yyyymmdd       = @p_plan_start_yyyymmdd  
           and plan_type                 = @p_plan_type  
           and seq                       = @p_plan_seq  
           and site_id                   = @p_scm_site_id  
           and item_id                   = @p_item_id  
           and yyyymmdd                  = @p_yyyymmdd  
           ;  
  
      
   end  
else  
   begin  
  
        
        select @x_boh_qty = sum(isnull(psi_boh_qty,0))  
          from ssp_pln_sales_onhand with(nolock)  
         where division_id               = @p_division_id  
           and plan_start_yyyymmdd       = @p_plan_start_yyyymmdd  
           and plan_type                 = @p_plan_type  
           and seq                       = @p_plan_seq  
           and site_id                   = @p_scm_site_id  
           and item_id                   = @p_item_id  
           and yyyymmdd                  = @p_yyyymmdd  
           ;  
      
   end       
  
      
  RETURN isnull(@x_boh_qty,0);  
  
END  
;
