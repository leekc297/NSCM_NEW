
CREATE FUNCTION [dbo].[FN_GET_SSP_ANL_LINE_LOAD_MIN]
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
 * Program ID   : FN_GET_SSP_ANL_LINE_LOAD_MIN  
 * Description  : 특정사이트,특정일자,특정라인 생산계획수량의 TOTAL LOAD(AMEND기준)
 *                ITEM PROD QTY * TACT TIME / 60 SEC 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.14   yydok         Initial Release 
 * 2018.05.02   YYDOK         화면용 일자별 TACT TIME생성된 것을 사용함(속도문제)
 */
BEGIN
  
  DECLARE @x_total_load_min   numeric(20,10) = 0;


    select @x_total_load_min = round(sum(qty * tact_time)/60,0)
      from 
      (
        select P.division_id,
               P.scm_site_id,
               P.item_id,
               P.line_id,
               P.operation_id,
               P.yyyymmdd,
               P.qty,
           /*  [dbo].[FN_GET_ITEM_LINE_TACT_TIME]  --FP TACT TIME
               (P.division_id,
                P.scm_site_id,
                P.item_id,
                P.line_id,
                P.operation_id,
                P.yyyymmdd)  as tact_time, */
                T.TACT_TIME AS TACT_TIME
          from ssp_anl_production_plan p with(nolock)
               LEFT OUTER JOIN SCP_ANL_TACT_TIME T WITH(NOLOCK)
                           ON P.DIVISION_ID   = T.DIVISION_ID
                          AND P.SCM_SITE_ID   = T.SCM_SITE_ID
                          AND P.ITEM_ID       = T.ITEM_ID
                          AND P.OPERATION_ID  = T.OPERATION_ID
                          AND P.LINE_ID       = T.LINE_ID
                          AND P.YYYYMMDD      = T.YYYYMMDD
         where 1=1
           and P.division_id          = @p_division_id
           and P.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
           and P.plan_type            = @p_plan_type
           and P.seq                  = @p_plan_seq
           and P.scm_site_id          = @p_scm_site_id
           and P.line_id              = @p_line_id
           and P.operation_id         = @p_operation_id
           and P.yyyymmdd             = @p_yyyymmdd
           and P.measure              = upper('PROD_PLAN_AMEND')
        ) a
       ;
   
  RETURN isnull(@x_total_load_min,0);

END
;
