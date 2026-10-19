CREATE FUNCTION [dbo].[FN_GET_LINE_WORKTIME_MIN]
      (@p_division_id         nvarchar(50),
       @p_scm_site_id         nvarchar(50),
       @p_line_id             nvarchar(50),
       @p_operation_id        nvarchar(50),
       @p_yyyymmdd            nvarchar(8))
      RETURNS NUMERIC(20,10)
AS
/*
 * Program ID   : FN_GET_LINE_WORKTIME_MIN  
 * Description  : 특정사이트,특정일자,특정라인,특정공정코드에 해당하는 라인의 실제작업가능시간(단위:분)
 *                 ( 복수개의 장비댓수, 장비별 OFF CALENDAR반영 )
 * Parameter    :p_division_id,p_scm_site_id,p_line_id,p_operation_id,p_yyyymmdd
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.13   yydok         Initial Release 
 *
 */
BEGIN

  DECLARE @x_worktime_min                numeric(20,10) = 0;
  DECLARE @x_equip_count                 int = 0; 
  DECLARE @x_equip_offtime_min           int = 0;   
   
  SELECT @x_equip_count = COUNT(1)
    FROM SCM_MST_EQUIPMENT_SN  A WITH(NOLOCK)
   WHERE 1=1
     AND DIVISION_ID         = @p_division_id
     AND @p_scm_site_id      LIKE PLANT_ID+'%'
     AND OPERATION_ID        = @p_operation_id
     AND LINE_ID             = @p_line_id
     AND ACTIVE_FLAG         = 'Y'
     AND NOT EXISTS ( SELECT 'X' 
                        FROM SCM_MST_EQUIPMENT_EXCEPT_SN B WITH(NOLOCK)
                       WHERE 1=1
                         AND B.DIVISION_ID   = A.DIVISION_ID
                         AND B.PLANT_ID      = A.PLANT_ID
                         AND B.EQUIPMENT_ID  = A.EQUIPMENT_ID
                         AND B.START_TIME     <= CONVERT(DATETIME,@p_yyyymmdd,112)
                         AND B.END_TIME       >= CONVERT(DATETIME,@p_yyyymmdd,112)
                         AND B.ACTIVE_FLAG    = 'Y' )
       ;
  


   
   IF (@x_equip_count >= 1 )
      BEGIN

          /*
           * EQUIPMENTS의 OFF TIME MINUTES SUM
           */
           SELECT @x_equip_offtime_min = OFF_TIME_MINUTE
             FROM SCM_MST_OFF_CALENDAR_V
            WHERE DIVISION_ID         = @p_division_id --'81'
              -- AND 'A040-A' LIKE PLANT_ID+'%'
              AND @p_scm_site_id      LIKE PLANT_ID+'%'
              AND OPERATION_ID        = @p_operation_id  -- 'A8000'
              AND LINE_ID             = @p_line_id       --'A1A02'
              AND OFF_DAY             = @p_yyyymmdd      --'20170212'
              ;    

          SET @x_worktime_min = ( ( @x_equip_count * 24 * 60 ) - @x_equip_offtime_min ) / @x_equip_count;

      
      END
   ELSE
      -- 장비가 없음.
      BEGIN
            SET @x_worktime_min = 0;     
      END



  RETURN isnull(@x_worktime_min,0);

END
;
