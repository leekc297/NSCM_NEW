CREATE FUNCTION [dbo].[FN_GET_ITEM_LINE_DAILY_CAPA]
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
 * Description  : 특정사이트,특정일자,특정item,특정라인,특정공정코드에 해당하는 fp 일일 capa
 * Parameter    :p_division_id,p_scm_site_id,p_item_id,p_line_id,p_operation_id,p_yyyymmdd
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.07   yydok         Initial Release 
 * 2018.08.27   YYDOK         FP 예외구간 고려제외, 전극LANE수 고려
 * 2020.03.12   KSG           PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time Table 변경
 * 2022.06.16   sclee.lee     PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 */
BEGIN
  
  DECLARE @x_daily_capa      numeric(20,10) = 0;

            -- PJ20216891
            SELECT @x_daily_capa = ROUND(MAX(ISNULL(A.daily_capa, 0)), 1) -- Lane 수는 View에서 고려되어 있음  
			  FROM (
                    SELECT ISNULL(T.daily_capa, 0) daily_capa
                      FROM scm_mst_tact_time_ver_h_v T WITH(NOLOCK)
                     WHERE 1=1
                       AND T.DIVISION_ID    = @p_division_id
                       AND @p_scm_site_id LIKE T.PLANT_ID+'%'
                       AND T.OPERATION_ID   = @p_operation_id
                       AND T.LINE_ID        = @p_line_id
                       AND T.ITEM_ID        = @p_item_id
                       AND T.MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
                       AND T.OPERATION_ID   IN ( 
                                                 SELECT DISTINCT b.segment4
                                                   FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                  WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                    AND b.valid_yn    = 'Y'
                                                    AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                               )
			        
                     UNION ALL
			        
                    SELECT ISNULL(T.daily_capa, 0) daily_capa
                      FROM scm_mst_tact_time_ver_h_v T WITH(NOLOCK)
                     WHERE 1=1
                       AND T.DIVISION_ID    = @p_division_id
                       AND @p_scm_site_id LIKE T.PLANT_ID+'%'
                       AND T.OPERATION_ID   = 'P5000'
                       AND T.LINE_ID        = @p_line_id
                       AND T.ITEM_ID        = @p_item_id
                       AND T.MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
                       AND EXISTS           ( 
                                             SELECT 1
                                               FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
                                              INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
                                              WHERE A.ITEM_ID = T.ITEM_ID
                                                AND A.IS_YN = 'Y'
                                            )
                   ) A

/*
            SELECT @x_daily_capa = ROUND(MAX(ISNULL(T.daily_capa, 0)), 1) -- Lane 수는 View에서 고려되어 있음
              FROM scm_mst_tact_time_ver_h_v T WITH(NOLOCK)
             WHERE 1=1
               AND T.DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE T.PLANT_ID+'%'
               AND T.OPERATION_ID   = @p_operation_id
               AND T.LINE_ID        = @p_line_id
               AND T.ITEM_ID        = @p_item_id
               AND T.MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
               AND T.OPERATION_ID   IN ( 
                                         SELECT DISTINCT b.segment4
                                           FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
                                          WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                            AND b.valid_yn    = 'Y'
                                            AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                        )

             GROUP BY T.DIVISION_ID
                    , T.PLANT_SITE_ID
                    , T.ITEM_ID
                    , T.OPERATION_ID
                    , T.LINE_ID
                    , T.MONTH;
*/

/* -- J20209642 주석 START
               SELECT @x_daily_capa =
                      (CASE WHEN DBO.FN_GET_ITEM_OPERATION_GROUP(t.division_id,t.item_id) <> 'E' THEN
                                                 MAX(t.daily_capa) -- 셀, 팩일때
                                                    --전극일때
                                            WHEN MAX(ISNULL(l.lane_qty, 0)) = 0 THEN ROUND((60 * 60 * 24) / MAX(ISNULL(t.tact_time, 0)),1)
                                            ELSE ROUND((60 * 60 * 24) /  (MAX(ISNULL(t.tact_time, 0)) / MAX(ISNULL(l.lane_qty, 0))) ,1)
                      END )   
              FROM SCM_MST_TACT_TIME_SN T WITH(NOLOCK)
                   LEFT OUTER JOIN dbo.scm_mst_item_lane_m_sn l WITH(NOLOCK)
                                         ON     t.division_id  = l.division_id
                                         AND    t.company_id   = l.company_id
                                         AND    t.site_id      = l.site_id
                                         AND    t.plant_id     = l.plant_id
                                         AND    t.factory_id   = l.factory_id
                                         AND    t.item_id      = l.item_id
             WHERE 1=1
               AND T.DIVISION_ID    = @p_division_id
               AND @p_scm_site_id LIKE T.PLANT_ID+'%'
               AND T.OPERATION_ID   = @p_operation_id
               AND T.LINE_ID        = @p_line_id
               AND T.ITEM_ID        = @p_item_id
               AND T.MONTH          = SUBSTRING(@p_yyyymmdd,1,6)
               AND T.OPERATION_ID   IN ( 
                                         SELECT DISTINCT b.segment4
                                           FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
                                          WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                            AND b.valid_yn    = 'Y'
                                            AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                        )

             GROUP BY T.DIVISION_ID
                    , T.PLANT_ID
                    , T.ITEM_ID
                    , T.OPERATION_ID
                    , T.LINE_ID
                    ,T.DAILY_CAPA;
   */-- PJ20209642 주석 END

  RETURN isnull(@x_daily_capa,0);

END
;
