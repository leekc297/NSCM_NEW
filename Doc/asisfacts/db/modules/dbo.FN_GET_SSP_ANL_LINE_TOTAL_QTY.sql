
CREATE FUNCTION [dbo].[FN_GET_SSP_ANL_LINE_TOTAL_QTY]
      (@p_division_id         nvarchar(50),
       @p_plan_start_yyyymmdd nvarchar(8),
       @p_plan_type           nvarchar(10),
       @p_plan_seq            int,
       @p_scm_site_id         nvarchar(50),
       @p_line_id             nvarchar(50),
       @p_operation_id        nvarchar(50),
       @p_yyyymmdd            nvarchar(8))
      RETURNS NUMERIC(20,10)
AS
/*
 * Program ID   : FN_GET_SSP_ANL_LINE_TOTAL_QTY  
 * Description  : 특정사이트,특정일자,특정라인 생산계획수량의 합계(AMEND기준)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.14   yydok         Initial Release 
 */
BEGIN
  
  DECLARE @x_total_qty   numeric(20,10) = 0;

/* 
select sum(isnull(qty,0)) 
  from ssp_anl_production_plan with(nolock)
 where 1=1
   and division_id          = '81'
   and plan_start_yyyymmdd  = '20180226' 
   and plan_type            = 'PR'
   and seq                  = 24
   and scm_site_id          = 'A040-A'
   and line_id              = 'A1A02'
   and operation_id         = 'A9000'
   and yyyymmdd             = '20180226'
   and measure              = upper('PROD_PlAN_AMEND')
;
*/

    select @x_total_qty = sum(isnull(qty,0)) 
      from ssp_anl_production_plan with(nolock)
     where 1=1
       and division_id          = @p_division_id
       and plan_start_yyyymmdd  = @p_plan_start_yyyymmdd 
       and plan_type            = @p_plan_type
       and seq                  = @p_plan_seq
       and scm_site_id          = @p_scm_site_id
       and line_id              = @p_line_id
       and operation_id         = @p_operation_id
       and yyyymmdd             = @p_yyyymmdd
       and measure              = upper('PROD_PLAN_AMEND')
    ;
   
  RETURN isnull(@x_total_qty,0);

END
;
