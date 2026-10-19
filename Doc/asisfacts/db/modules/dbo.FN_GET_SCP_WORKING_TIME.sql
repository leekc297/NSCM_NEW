CREATE FUNCTION [dbo].[FN_GET_SCP_WORKING_TIME]
      (@p_division_id         nvarchar(50),
       @p_scm_site_id         nvarchar(50),
       @p_operation_id        nvarchar(50),
       @p_line_id             nvarchar(50),
       @p_yyyymmdd            nvarchar(8))
      RETURNS NUMERIC(20,10)
AS
/*
 * Program ID   : FN_GET_SCP_WORKING_TIME  
 * Description  : 특정사이트,특정일자,특정line의 working time min
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.14   yydok         Initial Release 
 * 2018.03.14   yydok         working time = calendar time - loss time
 * 2018.05.02   yydok         속도개선을 위해서 일자별 WORKTIME생성된 정보를 활용함(LOSS TIME이나 적용시간비율 등이 이미 감안된 정보임)
 */
BEGIN
  
  DECLARE @x_working_time_min  numeric(20,10) = 1440;


/*  
  DECLARE @x_loss_time_min     numeric(20,10) = 0;  
  
  -- calendar working time  
  select @x_working_time_min = isnull(working_time,1440) 
    from scp_mst_working_time with(nolock)
   where division_id   = @p_division_id
     and plant_site_id = @p_scm_site_id
     and operation_id  = @p_operation_id
     and line_id       = @p_line_id
     and yyyymmdd      = @p_yyyymmdd
     ;  
  -- loss time    
  select @x_loss_time_min = [dbo].[FN_GET_SCP_LOSS_TIME](@p_division_id,
                                                         @p_scm_site_id,
                                                         @p_operation_id,
                                                         @p_line_id,
                                                         @p_yyyymmdd);
                                                              
	
	-- real workable time = calendar working time - loss time 
	set @x_working_time_min = @x_working_time_min - @x_loss_time_min;		
*/	

SELECT @x_working_time_min = SUM(WORKING_TIME)
  FROM SCP_ANL_WORKING_TIME T WITH(NOLOCK)
 WHERE 1=1
   AND T.DIVISION_ID  = @p_division_id  --'81'
   AND T.SCM_SITE_ID  = @p_scm_site_id  --'A040-A'
   AND T.OPERATION_ID = @p_operation_id --'A9000'
   AND T.LINE_ID      = @p_line_id      --'A1A05'
   AND T.YYYYMMDD     = @p_yyyymmdd     --'20180430'
   ;
	
  RETURN isnull(@x_working_time_min,1440);

END
;
