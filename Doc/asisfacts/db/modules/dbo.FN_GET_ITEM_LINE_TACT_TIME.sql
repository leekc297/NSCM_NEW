CREATE FUNCTION [dbo].[FN_GET_ITEM_LINE_TACT_TIME]
      (@p_division_id         nvarchar(50),
       @p_scm_site_id         nvarchar(50),
       @p_item_id             nvarchar(50),
       @p_line_id             nvarchar(50),
       @p_operation_id        nvarchar(50),
       @p_yyyymmdd            nvarchar(8))
      RETURNS NUMERIC(20,10)
AS
/*
 * Program ID   : FN_GET_ITEM_LINE_TACT_TIME  
 * Description  : 특정사이트,특정일자,특정item,특정라인,특정공정코드에 해당하는 fp TACT TIME
 * Parameter    :p_division_id,p_scm_site_id,p_item_id,p_line_id,p_operation_id,p_yyyymmdd
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.07   yydok         Initial Release 
 * 2018.02.21   yydok         계산식 오류수정
 * 2018.04.19   YYDOK         전극 TACT TIME은 LANE수로 나누어서 반영함.
 * 2018.05.04   YYDOK         라인 assign validation추가
 * 2020.03.12   KSG           PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time Table 변경
 */
BEGIN
  
  --DECLARE @x_daily_capa      numeric(20,10) ;
  DECLARE @x_tact_time       numeric(20,10) ;
  DECLARE @x_count           int = 0;  
  
    -- Line 정보가 없는 경우 평균으로 처리(활성화)
   IF (ISNULL(@p_line_id, '-') = '-')
      BEGIN
            SELECT @x_tact_time  = MAX(ISNULL(t.tact_time, 0)) 
              FROM scm_mst_tact_time_ver_h_v T WITH(NOLOCK)                
             WHERE 1=1
               AND T.DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE T.PLANT_ID+'%'
               AND T.OPERATION_ID   = @p_operation_id
              -- AND T.LINE_ID        = @p_line_id
               AND T.ITEM_ID        = @p_item_id
               AND T.MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
             GROUP BY T.DIVISION_ID
                     ,T.OPERATION_ID
                     --,T.LINE_ID
                     ,T.ITEM_ID
               ;   
               
             RETURN isnull(@x_tact_time,0);                  
      
      END
 
      BEGIN
            SELECT @x_tact_time  = MAX(ISNULL(t.tact_time, 0)) 
              FROM scm_mst_tact_time_ver_h_v T WITH(NOLOCK)
             WHERE 1=1
               AND T.DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE T.PLANT_ID+'%'
               AND T.OPERATION_ID   = @p_operation_id
               AND T.LINE_ID        = @p_line_id
               AND T.ITEM_ID        = @p_item_id
               AND T.MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
             GROUP BY T.DIVISION_ID
                     ,T.OPERATION_ID
                     ,T.LINE_ID
                     ,T.ITEM_ID
               ;     
      END

/* -- PJ20209642  START
  -- 전극공정은 TACT TIME으로 관리, 나머지 공정은 DAILY CAPA로 관리. 향후 바뀔수도 있음.
  -- 전극아닌공정은 DAILY CAPA를 TACT TIME으로 환산하고 LANE숫자로 나누어야 함.

     -- Line 정보가 없는 경우 평균으로 처리(활성화)
   IF (ISNULL(@p_line_id, '-') = '-')
      BEGIN
            SELECT @x_tact_time  =          CASE WHEN DBO.FN_GET_ITEM_OPERATION_GROUP(t.division_id,t.item_id) <> 'E' THEN
                                                 IIF( SUM(ISNULL(t.daily_capa,0)) = 0 , 0, (ROUND((60 * 60 * 24)/SUM(ISNULL(t.daily_capa,0)),3) )/COUNT(1)) -- 셀, 팩일때
                                                    --전극일때
                                                 WHEN MAX(ISNULL(l.lane_qty, 0)) = 0 THEN MAX(ISNULL(t.tact_time, 0))
                                                 ELSE MAX(ISNULL(t.tact_time, 0)) / MAX(ISNULL(l.lane_qty, 0))
                                           END 
              FROM SCM_MST_TACT_TIME_SN T WITH(NOLOCK)
                   INNER JOIN dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                                         ON     t.division_id  = op.division_id
                                         AND    t.company_id   = op.company_id
                                         AND    t.site_id      = op.site_id
                                         AND    t.operation_id = op.operation_id

                   LEFT OUTER JOIN dbo.scm_mst_item_lane_m_sn l WITH(NOLOCK)
                                         ON     t.division_id  = l.division_id
                                         AND    t.company_id   = l.company_id
                                         AND    t.site_id      = l.site_id
                                         AND    t.plant_id     = l.plant_id
                                         AND    t.factory_id   = l.factory_id
                                         AND    t.item_id      = l.item_id
                  ,SCM_MST_ITEM_LINE_ASSIGN_SN  A WITH(NOLOCK)                                         
             WHERE 1=1
               AND T.DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE T.PLANT_ID+'%'
               AND T.OPERATION_ID   = @p_operation_id
              -- AND T.LINE_ID        = @p_line_id
               AND T.ITEM_ID        = @p_item_id
               AND T.MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
               AND T.DIVISION_ID    = A.DIVISION_ID
               AND T.OPERATION_ID   = A.OPERATION_ID
               AND T.ITEM_ID        = A.ITEM_ID
               AND T.LINE_ID        = A.LINE_ID
               AND T.MONTH          = A.MONTH
               AND A.ACTIVE_FLAG    ='Y'
               AND A.PRIORITY       NOT IN ( 0, 9 )                
             GROUP BY T.DIVISION_ID
                     ,T.OPERATION_ID
                     --,T.LINE_ID
                     ,T.ITEM_ID
               ;   
               
             RETURN isnull(@x_tact_time,0);                  
      
      END
 
      BEGIN
            SELECT @x_tact_time  =     CASE WHEN DBO.FN_GET_ITEM_OPERATION_GROUP(t.division_id,t.item_id) <> 'E' THEN
                                                 IIF( SUM(ISNULL(t.daily_capa,0)) = 0 , 0, ROUND((60 * 60 * 24)/MAX(ISNULL(t.daily_capa,0)),3) ) -- 셀, 팩일때
                                                    --전극일때
                                            WHEN MAX(ISNULL(l.lane_qty, 0)) = 0 THEN MAX(ISNULL(t.tact_time, 0))
                                            ELSE MAX(ISNULL(t.tact_time, 0)) / MAX(ISNULL(l.lane_qty, 0))
                                        END 

              FROM SCM_MST_TACT_TIME_SN T WITH(NOLOCK)
                   LEFT OUTER JOIN dbo.scm_mst_item_lane_m_sn l WITH(NOLOCK)
                                         ON     t.division_id  = l.division_id
                                         AND    t.company_id   = l.company_id
                                         AND    t.site_id      = l.site_id
                                         AND    t.plant_id     = l.plant_id
                                         AND    t.factory_id   = l.factory_id
                                         AND    t.item_id      = l.item_id
                  ,SCM_MST_ITEM_LINE_ASSIGN_SN  A WITH(NOLOCK)
             WHERE 1=1
               AND T.DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE T.PLANT_ID+'%'
               AND T.OPERATION_ID   = @p_operation_id
               AND T.LINE_ID        = @p_line_id
               AND T.ITEM_ID        = @p_item_id
               AND T.MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
               AND T.DIVISION_ID    = A.DIVISION_ID
               AND T.OPERATION_ID   = A.OPERATION_ID
               AND T.ITEM_ID        = A.ITEM_ID
               AND T.LINE_ID        = A.LINE_ID
               AND T.MONTH          = A.MONTH
               AND A.ACTIVE_FLAG    ='Y'
               AND A.PRIORITY       NOT IN ( 0, 9 )               
             GROUP BY T.DIVISION_ID
                     ,T.OPERATION_ID
                     ,T.LINE_ID
                     ,T.ITEM_ID
               ;     
      END
*/ -- PJ20209642  END
   
  RETURN isnull(@x_tact_time,0);

END
;
