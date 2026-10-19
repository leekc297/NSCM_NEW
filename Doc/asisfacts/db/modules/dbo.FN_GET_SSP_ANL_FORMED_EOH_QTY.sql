CREATE FUNCTION [dbo].[FN_GET_SSP_ANL_FORMED_EOH_QTY]
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
 * Program ID   : v  
 * Description  : SSP ENGINE OUTPUT 기준의 PLANT SITE 활성화완료 EOH QTY
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.14   yydok         Initial Release 
 * 2018.04.19   YYDOK         활성화완료 수량의 STOCK TYPE = FORMED, CHARING
 */
BEGIN
  
  DECLARE @x_qty  numeric(20,10) = 0;
   

select @x_qty = PSI_EOH_QTY
  from ssp_pln_plant_onhand with(nolock)
 where division_id               = @p_division_id
   and stock_type                IN ('FORMED','CHARING') --활성화완료
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
