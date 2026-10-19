CREATE FUNCTION [dbo].[FN_GET_ITEM_LINE_PPM]
      (@p_division_id         nvarchar(50),
       @p_scm_site_id         nvarchar(50),
       @p_item_id             nvarchar(50),
       @p_line_id             nvarchar(50),
       @p_operation_id        nvarchar(50),
       @p_yyyymmdd            nvarchar(8))
      RETURNS NUMERIC(20,10)
AS
/*
 * Program ID   : FN_GET_ITEM_LINE_DAILY_CAPA  
 * Description  : 특정사이트,특정일자,특정item,특정라인,특정공정코드에 해당하는 fp 일일 capa를 
 *                PPM (분당생산수량)으로 환산해서 리턴
 * Parameter    :p_division_id,p_scm_site_id,p_item_id,p_line_id,p_operation_id,p_yyyymmdd
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.13   yydok         Initial Release 
 * 2020.03.12   KSG           PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time Table 변경
 *
 */
BEGIN

  DECLARE @x_ppm             numeric(20,10) = 0;
  DECLARE @x_daily_capa      numeric(20,10) = 0;
  DECLARE @x_tact_time       numeric(20,10) = 0;
  DECLARE @x_count           int = 0;  
  DECLARE @x_operation_group nvarchar(50);
  
  SET @x_operation_group = DBO.FN_GET_ITEM_OPERATION_GROUP(@p_division_id,@p_item_id);
  
  -- 예외구간에 해당되는 지 확인.  
  SELECT @x_count = COUNT(1)
    FROM scm_mst_tact_time_exct_ver_v WITH(NOLOCK)
   WHERE 1=1
     AND DIVISION_ID    = @p_division_id 
     AND @p_scm_site_id LIKE PLANT_ID+'%'
     AND OPERATION_ID   = @p_operation_id
     AND LINE_ID        = @p_line_id
     AND ITEM_ID        = @p_item_id
     AND START_TIME     <= CONVERT(DATETIME,@p_yyyymmdd,112)
     AND END_TIME       >= CONVERT(DATETIME,@p_yyyymmdd,112)
   ;
   
   IF (@x_count > 0 )
      BEGIN
            SELECT @x_tact_time  = tact_time,
                   @x_daily_capa = ROUND(daily_capa, 1)
              FROM scm_mst_tact_time_exct_ver_v WITH(NOLOCK)
             WHERE 1=1
               AND DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE PLANT_ID+'%'
               AND OPERATION_ID   = @p_operation_id --'A9000'
               AND LINE_ID        = @p_line_id      --'A1A03'
               AND ITEM_ID        = @p_item_id      --'ACLF1020U-A1'
               AND START_TIME     <= CONVERT(DATETIME,@p_yyyymmdd,112)
               AND END_TIME       >= CONVERT(DATETIME,@p_yyyymmdd,112)
               ;      
      
      END
   ELSE
      BEGIN
            SELECT @x_tact_time  = tact_time,
                   @x_daily_capa = ROUND(daily_capa, 1)
              FROM scm_mst_tact_time_ver_h_v WITH(NOLOCK)
             WHERE 1=1
               AND DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE PLANT_ID+'%'
               AND OPERATION_ID   = @p_operation_id
               AND LINE_ID        = @p_line_id
               AND ITEM_ID        = @p_item_id
               AND MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
               ;     
      END

/* -- PJ20209642  START
  -- 예외구간에 해당되는 지 확인.  
  SELECT @x_count = COUNT(1)
    FROM SCM_MST_TACT_TIME_EXCEPT_SN WITH(NOLOCK)
   WHERE 1=1
     AND DIVISION_ID    = @p_division_id 
     --AND 'A040-A' LIKE PLANT_ID+'%'
     AND @p_scm_site_id LIKE PLANT_ID+'%'
     AND OPERATION_ID   = @p_operation_id
     AND LINE_ID        = @p_line_id
     AND ITEM_ID        = @p_item_id
     AND START_TIME     <= CONVERT(DATETIME,@p_yyyymmdd,112)
     AND END_TIME       >= CONVERT(DATETIME,@p_yyyymmdd,112)
     AND ACTIVE_FLAG    = 'Y'
   ;
   
   IF (@x_count > 0 )
      BEGIN
            SELECT @x_tact_time  = TACT_TIME,
                   @x_daily_capa = ISNULL(DAILY_CAPA,0)
              FROM SCM_MST_TACT_TIME_EXCEPT_SN WITH(NOLOCK)
             WHERE 1=1
               AND DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE PLANT_ID+'%'
               AND OPERATION_ID   = @p_operation_id --'A9000'
               AND LINE_ID        = @p_line_id      --'A1A03'
               AND ITEM_ID        = @p_item_id      --'ACLF1020U-A1'
               AND START_TIME     <= CONVERT(DATETIME,@p_yyyymmdd,112)
               AND END_TIME       >= CONVERT(DATETIME,@p_yyyymmdd,112)
               AND ACTIVE_FLAG    = 'Y'
               ;      
      
      END
   ELSE
      BEGIN
            SELECT @x_tact_time  = TACT_TIME,
                   @x_daily_capa = ISNULL(DAILY_CAPA,0)
              FROM SCM_MST_TACT_TIME_SN WITH(NOLOCK)
             WHERE 1=1
               AND DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE PLANT_ID+'%'
               AND OPERATION_ID   = @p_operation_id
               AND LINE_ID        = @p_line_id
               AND ITEM_ID        = @p_item_id
               AND MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
               ;     
      END

   -- 전극공정은 TACT TIME으로 관리, 나머지 공정은 DAILY CAPA로 관리. 향후 바뀔수도 있음.
   -- 전극공정은 TACT TIME으로 DAILY CAPA로 환산
   IF (@x_operation_group = 'E' AND @x_tact_time > 0) 
      BEGIN
          SET @x_daily_capa =   ROUND((60 * 60 * 24) / @x_tact_time,1);
      
      END
*/    -- PJ20209642  END

  SET @x_ppm = @x_daily_capa / (24 * 60); --하루의 생산가능수량/ 하루를 분으로 계산 = 생산가능수량/ 분  

  RETURN isnull(@x_ppm,0);

END
;
