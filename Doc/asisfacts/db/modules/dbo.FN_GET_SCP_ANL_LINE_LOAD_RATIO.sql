CREATE FUNCTION [dbo].[FN_GET_SCP_ANL_LINE_LOAD_RATIO]
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
 * Program ID   : FN_GET_SCP_ANL_LINE_LOAD_RATIO  
 * Description  : 특정사이트,특정일자,특정라인 생산계획수량의 TOTAL RATIO(AMEND기준)
 *                LINE LOAD MIN/LINE WORK TIME MIN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.14   yydok         Initial Release 
 * 2018.05.02   yydok         속도개선을 위해서 일자별 생성된 정보를 활용함(WORK TIME,TACT TIME) 
 */
BEGIN
  
  DECLARE @x_load_ratio        numeric(20,10) = 0;
  DECLARE @x_working_time_min  numeric(20,10) = 0;
  DECLARE @x_total_load_min    numeric(20,10) = 0;    


/*
  select @x_working_time_min = [dbo].[FN_GET_SCP_WORKING_TIME](@p_division_id,
                                                               @p_scm_site_id,
                                                               @p_operation_id,
                                                               @p_line_id,
                                                               @p_yyyymmdd);

  if (@x_working_time_min = 0 or @x_working_time_min is null)
      begin set @x_working_time_min = 1.0; end
  
  select @x_total_load_min = [dbo].[FN_GET_SCP_ANL_LINE_LOAD_MIN](@p_division_id,
                                                                  @p_plan_start_yyyymmdd,
                                                                  @p_plan_type,
                                                                  @p_plan_seq,
                                                                  @p_scm_site_id,
                                                                  @p_line_id,
                                                                  @p_operation_id,
                                                                  @p_yyyymmdd);
  
  set  @x_load_ratio =  isnull( @x_total_load_min,0) / @x_working_time_min;    
*/                                                            
     
    select      @x_total_load_min   = sum(a.qty * (a.tact_time/60)),
                @x_working_time_min = min(a.working_time_min)

      from 
      (
        select P.division_id,
               P.scm_site_id,
               P.item_id,
               P.line_id,
               P.operation_id,
               P.yyyymmdd,
               P.qty,
               T.TACT_TIME AS TACT_TIME,
               isnull(w.working_time,0) as working_time_min
          from scp_anl_production_plan p with(nolock)
               LEFT OUTER JOIN SCP_ANL_TACT_TIME T WITH(NOLOCK)
                           ON t.DIVISION_ID   = p.DIVISION_ID
                          AND t.SCM_SITE_ID   = p.SCM_SITE_ID
                          AND t.ITEM_ID       = p.ITEM_ID
                          AND t.OPERATION_ID  = p.OPERATION_ID
                          AND t.LINE_ID       = p.LINE_ID
                          AND t.YYYYMMDD      = p.YYYYMMDD
               LEFT OUTER JOIN SCP_ANL_WORKING_TIME w WITH(NOLOCK)
                           ON w.DIVISION_ID  = P.DIVISION_ID
                          AND w.SCM_SITE_ID  = P.SCM_SITE_ID
                          AND w.OPERATION_ID = P.OPERATION_ID
                          AND w.LINE_ID      = P.LINE_ID
                          AND w.YYYYMMDD     = P.YYYYMMDD
         where 1=1
           and P.division_id          = @p_division_id
           and P.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
           and P.plan_type            = @p_plan_type
           and P.seq                  = @p_plan_seq
           and P.scm_site_id          = @p_scm_site_id
           and P.line_id              = @p_line_id
           and P.operation_id         = @p_operation_id
           and P.yyyymmdd             = @p_yyyymmdd
           and P.measure              = upper('PROD_PlAN_AMEND')
        ) a;
              
  if ( @x_working_time_min = 0 )
     begin 
         set @x_load_ratio =1;
     end
  else
     begin
         set @x_load_ratio = ( @x_total_load_min / @x_working_time_min ); 
     end             
                                                                     
  RETURN isnull(@x_load_ratio,0);

END
;
