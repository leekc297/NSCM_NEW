CREATE FUNCTION [dbo].[FN_GET_SITE_BOH_QTY]
      (@p_division_id         nvarchar(50),
       @p_scm_site_id         nvarchar(50),
       @p_item_id             nvarchar(50),
       @p_cutoff_yyyymmdd     nvarchar(8))
      RETURNS NUMERIC(20,10)
AS
/*
 * Program ID   : FN_GET_SITE_BOH_QTY  
 * Description  : 특정사이트,특정일자,특정item의 ERP양품재고수량
 *                사전에 site item 및 재고location 기준정보가 등록된 것에 대해서만 수량포함됨
 * Parameter    :p_division_id,p_scm_site_id,p_item_id,p_yyyymmdd
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.05   yydok         Initial Release 
 * 2018.03.06   yydok         qty -> scm_qty로 변경
 */
BEGIN
  
  DECLARE @x_boh_qty numeric(20,10) = 0;
   
  select @x_boh_qty = sum(scm_qty) 
    from [dbo].[SCM_DNM_STOCK_V]
   where DIVISION_ID = @p_division_id
     and SCM_SITE_ID = @p_scm_site_id
     and cutoff_date = convert(datetime,@p_cutoff_yyyymmdd,112)
     and item_id     = @p_item_id;  
	
  RETURN isnull(@x_boh_qty,0);

END
;
