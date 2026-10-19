CREATE FUNCTION [dbo].[FN_GET_ITEM_LINE_CAPA_WITH_OFF]
      (@p_division_id         nvarchar(50),
       @p_scm_site_id         nvarchar(50),
       @p_item_id             nvarchar(50),
       @p_line_id             nvarchar(50),
       @p_operation_id        nvarchar(50),
       @p_yyyymmdd            nvarchar(8))
      RETURNS NUMERIC(20,10)
AS
/*
 * Program ID   : FN_GET_ITEM_LINE_CAPA_WITH_OFF  
 * Description  : 특정사이트,특정일자,특정item,특정라인,특정공정코드에 해당하는 fp 일일 capa
 *                해당일자의 OFF CALENDAR의 OFFTIME을 고려하여, 가용CAPA를 조정하여 리턴
 * Parameter    :p_division_id,p_scm_site_id,p_item_id,p_line_id,p_operation_id,p_yyyymmdd
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.13   yydok         Initial Release 
 *
 */
BEGIN
  
  DECLARE @x_daily_capa               numeric(20,10) = 0;
  DECLARE @x_worktime_min             numeric(20,10) = 0;  
  DECLARE @x_daily_capa_with_off      numeric(20,10) = 0;
  
  SELECT @x_daily_capa =   [dbo].[FN_GET_ITEM_LINE_DAILY_CAPA]
                          (@p_division_id         ,
                           @p_scm_site_id         ,
                           @p_item_id             ,
                           @p_line_id             ,
                           @p_operation_id        ,
                           @p_yyyymmdd            );
                        
  SELECT @x_worktime_min = [dbo].[FN_GET_LINE_WORKTIME_MIN]
                          (@p_division_id         ,
                           @p_scm_site_id         ,
                           @p_line_id             ,
                           @p_operation_id        ,
                           @p_yyyymmdd            );                           
                           

  -- 실제 일생산가능수량 = 일생산가능수량 * ( 작업가능시간 / (24시간*60분))
  SET @x_daily_capa_with_off = isnull(@x_daily_capa,0) * ( @x_worktime_min / ( 24 * 60 ) );
   
  RETURN isnull(@x_daily_capa_with_off,0);

END
;
