CREATE FUNCTION [dbo].[FN_GET_SCP_LOSS_TIME]
      (@p_division_id         nvarchar(50),
       @p_scm_site_id         nvarchar(50),
       @p_operation_id        nvarchar(50),
       @p_line_id             nvarchar(50),
       @p_yyyymmdd            nvarchar(8))
      RETURNS NUMERIC(20,10)
AS
/*
 * Program ID   : FN_GET_SCP_LOSS_TIME  
 * Description  : 특정사이트,특정일자,특정라인,특정공정코드에 해당하는 LOSS TIME MIN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.14   yydok         Initial Release 
 * 2018.04.10   yydok         add setup loss time
 */
BEGIN
  
  DECLARE @x_loss_time_min   numeric(20,10) = 0;
  DECLARE @x_count           int = 0;  
 

 
      -- 예외구간에 해당되는 지 확인.  
      SELECT @x_count = count(1)
        FROM scp_mst_loss_time_except with(nolock)
      WHERE 1=1
         AND division_id     = @p_division_id
         AND plant_site_id   = @p_scm_site_id
         AND operation_id    = @p_operation_id
         AND line_id         = @p_line_id
         AND loss_start_date <= CONVERT(DATETIME,@p_yyyymmdd,112)
         AND loss_end_date   >= CONVERT(DATETIME,@p_yyyymmdd,112)
       ;
   
       IF (@x_count > 0 )
          BEGIN
              SELECT top 1 @x_loss_time_min = isnull(loss_time_min,0)+isnull(setup_loss_time_min,0)
                FROM scp_mst_loss_time_except with(nolock)
              WHERE 1=1
                 AND division_id     = @p_division_id
                 AND plant_site_id   = @p_scm_site_id
                 AND operation_id    = @p_operation_id
                 AND line_id         = @p_line_id
                 AND loss_start_date <= CONVERT(DATETIME,@p_yyyymmdd,112)
                 AND loss_end_date   >= CONVERT(DATETIME,@p_yyyymmdd,112)
               ;     
      
          END
       ELSE
          BEGIN
              SELECT top 1 @x_loss_time_min = isnull(loss_time_min,0)+isnull(setup_loss_time_min,0)
                FROM scp_mst_loss_time with(nolock)
              WHERE 1=1
                 AND division_id     = @p_division_id
                 AND plant_site_id   = @p_scm_site_id
                 AND operation_id    = @p_operation_id
                 AND line_id         = @p_line_id
               ;   
          END
   
  RETURN isnull(@x_loss_time_min,0);

END
;
