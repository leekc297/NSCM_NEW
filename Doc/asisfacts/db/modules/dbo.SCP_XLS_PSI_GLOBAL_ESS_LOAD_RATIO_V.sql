
CREATE VIEW [dbo].[SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_V]
 AS

/*
 * Program ID   : SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_V
 * Description  : ESS 시물레이션 가동율 계산을 위한 VIEW
 * EXEC  : 
           SELECT * 
            FROM SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_V WITH (NOLOCK)
            ORDER BY OPERATION_GROUP DESC,FROM_SITE,OPERATION_ID,PROD_LINE, SORT_ORDER_NO, XLS_KEY1
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.09.04  KTH      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.12.03  KTH      TACT_TIME 조건변경(TACT_TIME값이 NULL이 아닌 가장 최근일자 값)
 * 2020.02.06  KTH      ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
 * 2020.02.21  KTH      PACK/CELL 분리 작업 반영으로 전체 로직 변경함.
 */

WITH SUB AS        
( 
  --SELECT 'P' AS OPERATION_GROUP, 'PACK_WORKING_TIME'  AS MEASURE, 'Working Time'  AS MEASURE_LABEL , '165' SORT_ORDER_NO UNION ALL
  SELECT 'P' AS OPERATION_GROUP, 'PACK_TOTAL_TIME'    AS MEASURE, 'Total Time'    AS MEASURE_LABEL , '166' SORT_ORDER_NO UNION ALL
  SELECT 'P' AS OPERATION_GROUP, 'PACK_PROD_LOAD'     AS MEASURE, 'Load Ratio(%)' AS MEASURE_LABEL , '170' SORT_ORDER_NO UNION ALL
  SELECT 'A' AS OPERATION_GROUP, 'CELL_PROD_LOAD'       AS MEASURE, 'Load Ratio(%)'         AS MEASURE_LABEL , '500' SORT_ORDER_NO
) 
      -- OSP가 아닌거나, OSP 이면서 Line Capa 비대상
      SELECT X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') AS FROM_SITE_DESCRIPTION
            ,X.ATTRIBUTE9 AS OPERATION_ID
            ,X.ITEM_ID
            ,X.NICK_NAME
            ,X.PROD_LINE
            ,(CASE WHEN X.OPERATION_GROUP ='A' THEN 0 ELSE Y.DAILY_CAPA_QTY END) AS DAILY_CAPA_QTY
            ,(CASE WHEN X.OPERATION_GROUP ='P' THEN (1440*60.0) / ISNULL(Y.DAILY_CAPA_QTY,1) 
                   WHEN X.OPERATION_GROUP ='A' THEN (SELECT TOP 1 TACT_TIME
                                                      FROM (
                                                            SELECT E.TACT_TIME 
                                                                  , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID,OPERATION_ID,SCM_SITE_ID,LINE_ID,ITEM_ID ORDER BY YYYYMMDD DESC) AS Rn
                                                                  ,DIVISION_ID,OPERATION_ID,SCM_SITE_ID,LINE_ID,ITEM_ID
                                                              FROM SCP_ANL_TACT_TIME E WITH(NOLOCK)	
                                                             WHERE X.DIVISION_ID  = E.DIVISION_ID 
                                                               AND X.ATTRIBUTE9   = E.OPERATION_ID 
				                                               AND X.FROM_SITE    = E.SCM_SITE_ID  
                                                               AND X.PROD_LINE    = E.LINE_ID 
                                                               AND X.ITEM_ID      = E.ITEM_ID
                                                               AND E.TACT_TIME    IS NOT NULL
                                                            ) Z
                                                      WHERE Z.Rn = 1
                                                      ) 
                  ELSE Y.DAILY_CAPA_QTY END) AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            ,X.SORT_ORDER_NO
            ,X.XLS_KEY1
           
            ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
            ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
            ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
            ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
            ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
            ,WQTY51,WQTY52

        FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
       LEFT OUTER  JOIN SCP_MST_OUTSOURCING_CAPA Y WITH (NOLOCK)
          ON X.DIVISION_ID = Y.DIVISION_ID
         AND X.ITEM_ID    = Y.ITEM_ID
         AND X.FROM_SITE  = Y.PLANT_SITE_ID
--         AND X.PROD_LINE  = Y.LINE_ID
        INNER JOIN SCM_MST_SITE S WITH (NOLOCK)        -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
                ON S.DIVISION_ID              = X.DIVISION_ID
               AND S.SCM_SITE_ID              = X.FROM_SITE
               AND (S.OSP_YN = 'N'
			        OR (S.OSP_YN = 'Y' AND ISNULL(S.ATTRIBUTE1, 'N') IN ('N',''))
				   )
       WHERE 0 = 0
         AND X.MEASURE IN ('PACK_PROD','CELL_PROD'
                          ,'SEMI_PACK_PROD_CELL'
                          --,'PACK_CELL_BOH'
                          --,'PACK_CELL_EOH_TOTAL'
                          --,'PACK_CELL_EOH'

                          --,'SEMI_SHIP_PLAN'
                          ,'CELL_BOH'
                          ,'CELL_EOH'
                          ,'CELL_SHIP_PLAN_TOTAL'
                          ,'CELL_CHAR_PLAN'
                          ,'CELL_CHAR_AVAILABLE'
                          ,'CELL_FORM_PROGRESS'
                          ,'CELL_FORM_HOLD'
                          ,'CELL_FOR_FORM_END'
                          ,'CELL_PROD_FORM_END'

                          )


      -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정 : OSP 이면서 Line Capa 대상
      UNION
         SELECT  X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') AS FROM_SITE_DESCRIPTION
            ,X.ATTRIBUTE9 AS OPERATION_ID
            ,X.ITEM_ID
            ,X.NICK_NAME
            ,X.PROD_LINE
            ,(CASE WHEN X.OPERATION_GROUP ='A' THEN 0 ELSE Y.DAILY_CAPACITY END) AS DAILY_CAPA_QTY
            ,(CASE WHEN X.OPERATION_GROUP ='P' THEN Y.TACT_TIME
                   WHEN X.OPERATION_GROUP ='A' THEN Y.TACT_TIME
                  ELSE Y.DAILY_CAPACITY END) AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            ,X.SORT_ORDER_NO
            ,X.XLS_KEY1
            
            ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
            ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
            ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
            ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
            ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
            ,WQTY51,WQTY52
        FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
        INNER JOIN SCP_MST_TACT_TIME_OSP Y WITH (NOLOCK)  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
                ON X.DIVISION_ID = Y.DIVISION_ID
               AND X.ITEM_ID    = Y.ITEM_ID
               AND X.FROM_SITE  = Y.PLANT_SITE_ID
               AND X.PROD_LINE  = Y.LINE_ID
        INNER JOIN SCM_MST_SITE S WITH (NOLOCK)
                ON S.DIVISION_ID              = X.DIVISION_ID
               AND S.SCM_SITE_ID              = X.FROM_SITE
               AND S.OSP_YN                   = 'Y'
               AND ISNULL(S.ATTRIBUTE1, 'N')  = 'Y'
       WHERE 0 = 0
         AND X.MEASURE IN ('PACK_PROD','CELL_PROD'
                          ,'PACK_TACT_TIME'--,'CELL_TACT_TIME'
                          )
UNION 
-- CELL_TACT_TIME
SELECT  X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') AS FROM_SITE_DESCRIPTION
            ,X.ATTRIBUTE9 AS OPERATION_ID
            ,X.ITEM_ID
            ,X.NICK_NAME
            ,X.PROD_LINE
            , 0 AS DAILY_CAPA_QTY
            , 0 AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            ,X.SORT_ORDER_NO
            ,X.XLS_KEY1
            
            ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
            ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
            ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
            ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
            ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
            ,WQTY51,WQTY52
        FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
        WHERE 0 = 0
         AND X.MEASURE IN ('CELL_TACT_TIME')
    UNION 
-- WORKING TIME
    SELECT  DISTINCT X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') AS FROM_SITE_DESCRIPTION
            ,X.ATTRIBUTE9 AS OPERATION_ID
            ,'-' AS ITEM_ID
            ,'-' AS NICK_NAME
            ,X.PROD_LINE
            ,NULL AS DAILY_CAPA_QTY
            ,NULL AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            , 0 AS CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            ,MAX(X.SORT_ORDER_NO)
            ,'88888' AS XLS_KEY1
            
            ,MAX(WQTY01),MAX(WQTY02),MAX(WQTY03),MAX(WQTY04),MAX(WQTY05),MAX(WQTY06),MAX(WQTY07),MAX(WQTY08),MAX(WQTY09),MAX(WQTY10)
            ,MAX(WQTY11),MAX(WQTY12),MAX(WQTY13),MAX(WQTY14),MAX(WQTY15),MAX(WQTY16),MAX(WQTY17),MAX(WQTY18),MAX(WQTY19),MAX(WQTY20)
            ,MAX(WQTY21),MAX(WQTY22),MAX(WQTY23),MAX(WQTY24),MAX(WQTY25),MAX(WQTY26),MAX(WQTY27),MAX(WQTY28),MAX(WQTY29),MAX(WQTY30)
            ,MAX(WQTY31),MAX(WQTY32),MAX(WQTY33),MAX(WQTY34),MAX(WQTY35),MAX(WQTY36),MAX(WQTY37),MAX(WQTY38),MAX(WQTY39),MAX(WQTY40)
            ,MAX(WQTY41),MAX(WQTY42),MAX(WQTY43),MAX(WQTY44),MAX(WQTY45),MAX(WQTY46),MAX(WQTY47),MAX(WQTY48),MAX(WQTY49),MAX(WQTY50)
            ,MAX(WQTY51),MAX(WQTY52)
        FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
        --INNER JOIN SCP_MST_TACT_TIME_OSP Y WITH (NOLOCK)  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
        --        ON X.DIVISION_ID = Y.DIVISION_ID
        --       AND X.ITEM_ID    = Y.ITEM_ID
        --       AND X.FROM_SITE  = Y.PLANT_SITE_ID
        --       AND X.PROD_LINE  = Y.LINE_ID
        --INNER JOIN SCM_MST_SITE S WITH (NOLOCK)
        --        ON S.DIVISION_ID              = X.DIVISION_ID
        --       AND S.SCM_SITE_ID              = X.FROM_SITE
        --       AND S.OSP_YN                   = 'Y'
        --       AND ISNULL(S.ATTRIBUTE1, 'N')  = 'Y'
       WHERE 0 = 0
         AND X.MEASURE IN ('PACK_WORKING_TIME','CELL_WORKING_TIME')
          GROUP BY X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
           -- ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') 
            ,X.ATTRIBUTE9 
            --,'-' AS ITEM_ID
            --,'-' AS NICK_NAME
            ,X.PROD_LINE
            --,NULL AS DAILY_CAPA_QTY
            --,NULL AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            --,X.SORT_ORDER_NO
            --,X.XLS_KEY1
 UNION
        -- PACK_PROD_TOTAL
         SELECT  X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') AS FROM_SITE_DESCRIPTION
            ,X.ATTRIBUTE9 AS OPERATION_ID
            ,X.ITEM_ID
            ,X.NICK_NAME
            ,'Total' AS PROD_LINE
             ,NULL AS DAILY_CAPA_QTY
            ,NULL AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            ,MAX(X.SORT_ORDER_NO)
            ,MAX(X.XLS_KEY1)
            ,SUM(WQTY01),SUM(WQTY02),SUM(WQTY03),SUM(WQTY04),SUM(WQTY05),SUM(WQTY06),SUM(WQTY07),SUM(WQTY08),SUM(WQTY09),SUM(WQTY10)
            ,SUM(WQTY11),SUM(WQTY12),SUM(WQTY13),SUM(WQTY14),SUM(WQTY15),SUM(WQTY16),SUM(WQTY17),SUM(WQTY18),SUM(WQTY19),SUM(WQTY20)
            ,SUM(WQTY21),SUM(WQTY22),SUM(WQTY23),SUM(WQTY24),SUM(WQTY25),SUM(WQTY26),SUM(WQTY27),SUM(WQTY28),SUM(WQTY29),SUM(WQTY30)
            ,SUM(WQTY31),SUM(WQTY32),SUM(WQTY33),SUM(WQTY34),SUM(WQTY35),SUM(WQTY36),SUM(WQTY37),SUM(WQTY38),SUM(WQTY39),SUM(WQTY40)
            ,SUM(WQTY41),SUM(WQTY42),SUM(WQTY43),SUM(WQTY44),SUM(WQTY45),SUM(WQTY46),SUM(WQTY47),SUM(WQTY48),SUM(WQTY49),SUM(WQTY50)
            ,SUM(WQTY51),SUM(WQTY52)
        FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
        INNER JOIN SCP_MST_TACT_TIME_OSP Y WITH (NOLOCK)  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
                ON X.DIVISION_ID = Y.DIVISION_ID
               AND X.ITEM_ID    = Y.ITEM_ID
               AND X.FROM_SITE  = Y.PLANT_SITE_ID
               AND X.PROD_LINE  = Y.LINE_ID
        INNER JOIN SCM_MST_SITE S WITH (NOLOCK)
                ON S.DIVISION_ID              = X.DIVISION_ID
               AND S.SCM_SITE_ID              = X.FROM_SITE
               AND S.OSP_YN                   = 'Y'
               AND ISNULL(S.ATTRIBUTE1, 'N')  = 'Y'
       WHERE 0 = 0
         AND X.MEASURE IN ('PACK_PROD_TOTAL')
          GROUP BY X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,X.ATTRIBUTE9 
            ,X.ITEM_ID
            ,X.NICK_NAME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL

UNION
        -- PACK_PROD_LOAD_TOTAL
         SELECT  DISTINCT X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') AS FROM_SITE_DESCRIPTION
            ,X.ATTRIBUTE9 AS OPERATION_ID
            ,'-' AS ITEM_ID
            ,'-' AS NICK_NAME
            ,'Total' AS PROD_LINE
            ,NULL AS DAILY_CAPA_QTY
            ,NULL AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,0 AS CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            ,MAX(X.SORT_ORDER_NO)
            ,8888 AS XLS_KEY1
            ,SUM(WQTY01),SUM(WQTY02),SUM(WQTY03),SUM(WQTY04),SUM(WQTY05),SUM(WQTY06),SUM(WQTY07),SUM(WQTY08),SUM(WQTY09),SUM(WQTY10)
            ,SUM(WQTY11),SUM(WQTY12),SUM(WQTY13),SUM(WQTY14),SUM(WQTY15),SUM(WQTY16),SUM(WQTY17),SUM(WQTY18),SUM(WQTY19),SUM(WQTY20)
            ,SUM(WQTY21),SUM(WQTY22),SUM(WQTY23),SUM(WQTY24),SUM(WQTY25),SUM(WQTY26),SUM(WQTY27),SUM(WQTY28),SUM(WQTY29),SUM(WQTY30)
            ,SUM(WQTY31),SUM(WQTY32),SUM(WQTY33),SUM(WQTY34),SUM(WQTY35),SUM(WQTY36),SUM(WQTY37),SUM(WQTY38),SUM(WQTY39),SUM(WQTY40)
            ,SUM(WQTY41),SUM(WQTY42),SUM(WQTY43),SUM(WQTY44),SUM(WQTY45),SUM(WQTY46),SUM(WQTY47),SUM(WQTY48),SUM(WQTY49),SUM(WQTY50)
            ,SUM(WQTY51),SUM(WQTY52)
        FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
        INNER JOIN SCP_MST_TACT_TIME_OSP Y WITH (NOLOCK)  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
                ON X.DIVISION_ID = Y.DIVISION_ID
               AND X.ITEM_ID    = Y.ITEM_ID
               AND X.FROM_SITE  = Y.PLANT_SITE_ID
               AND X.PROD_LINE  = Y.LINE_ID
        INNER JOIN SCM_MST_SITE S WITH (NOLOCK)
                ON S.DIVISION_ID              = X.DIVISION_ID
               AND S.SCM_SITE_ID              = X.FROM_SITE
               AND S.OSP_YN                   = 'Y'
               AND ISNULL(S.ATTRIBUTE1, 'N')  = 'Y'
       WHERE 0 = 0
         AND X.MEASURE IN ('PACK_PROD_LOAD_TOTAL')
          GROUP BY X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            ,X.ATTRIBUTE9 

UNION
        -- 'PACK_BOH','PACK_EOH','PACK_DIO'
         SELECT  X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') AS FROM_SITE_DESCRIPTION
            ,X.ATTRIBUTE9 AS OPERATION_ID
            ,X.ITEM_ID
            ,X.NICK_NAME
            ,'Total2' AS PROD_LINE
            ,NULL AS DAILY_CAPA_QTY
            ,NULL AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            ,MAX(X.SORT_ORDER_NO)
            ,MAX(XLS_KEY1)
            ,SUM(WQTY01),SUM(WQTY02),SUM(WQTY03),SUM(WQTY04),SUM(WQTY05),SUM(WQTY06),SUM(WQTY07),SUM(WQTY08),SUM(WQTY09),SUM(WQTY10)
            ,SUM(WQTY11),SUM(WQTY12),SUM(WQTY13),SUM(WQTY14),SUM(WQTY15),SUM(WQTY16),SUM(WQTY17),SUM(WQTY18),SUM(WQTY19),SUM(WQTY20)
            ,SUM(WQTY21),SUM(WQTY22),SUM(WQTY23),SUM(WQTY24),SUM(WQTY25),SUM(WQTY26),SUM(WQTY27),SUM(WQTY28),SUM(WQTY29),SUM(WQTY30)
            ,SUM(WQTY31),SUM(WQTY32),SUM(WQTY33),SUM(WQTY34),SUM(WQTY35),SUM(WQTY36),SUM(WQTY37),SUM(WQTY38),SUM(WQTY39),SUM(WQTY40)
            ,SUM(WQTY41),SUM(WQTY42),SUM(WQTY43),SUM(WQTY44),SUM(WQTY45),SUM(WQTY46),SUM(WQTY47),SUM(WQTY48),SUM(WQTY49),SUM(WQTY50)
            ,SUM(WQTY51),SUM(WQTY52)
        FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
        --INNER JOIN SCP_MST_TACT_TIME_OSP Y WITH (NOLOCK)  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
        --        ON X.DIVISION_ID = Y.DIVISION_ID
        --       AND X.ITEM_ID    = Y.ITEM_ID
        --       AND X.FROM_SITE  = Y.PLANT_SITE_ID
        --       AND X.PROD_LINE  = Y.LINE_ID
        INNER JOIN SCM_MST_SITE S WITH (NOLOCK)
                ON S.DIVISION_ID              = X.DIVISION_ID
               AND S.SCM_SITE_ID              = X.FROM_SITE
               AND S.OSP_YN                   = 'Y'
               AND ISNULL(S.ATTRIBUTE1, 'N')  = 'Y'
       WHERE 0 = 0
         AND X.MEASURE IN ('PACK_BOH','PACK_EOH','PACK_DIO')
          GROUP BY X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,X.ATTRIBUTE9 
            ,X.ITEM_ID
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.NICK_NAME
            ,X.MEASURE
            ,X.MEASURE_LABEL
    UNION 

      SELECT DISTINCT 
             X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') AS FROM_SITE_DESCRIPTION
            ,X.ATTRIBUTE9 AS OPERATION_ID
            ,'-' AS ITEM_ID
            ,'-' AS NICK_NAME
            ,X.PROD_LINE
            ,0 AS DAILY_CAPA_QTY
            ,0 AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,0 AS CELL_QTY_PACK
            ,SUB.MEASURE
            ,SUB.MEASURE_LABEL
            ,SUB.SORT_ORDER_NO
            ,99999 AS XLS_KEY1
           
            ,0 AS WQTY01,0 AS WQTY02,0 AS WQTY03,0 AS WQTY04,0 AS WQTY05,0 AS WQTY06,0 AS WQTY07,0 AS WQTY08,0 AS WQTY09,0 AS WQTY10
            ,0 AS WQTY11,0 AS WQTY12,0 AS WQTY13,0 AS WQTY14,0 AS WQTY15,0 AS WQTY16,0 AS WQTY17,0 AS WQTY18,0 AS WQTY19,0 AS WQTY20
            ,0 AS WQTY21,0 AS WQTY22,0 AS WQTY23,0 AS WQTY24,0 AS WQTY25,0 AS WQTY26,0 AS WQTY27,0 AS WQTY28,0 AS WQTY29,0 AS WQTY30
            ,0 AS WQTY31,0 AS WQTY32,0 AS WQTY33,0 AS WQTY34,0 AS WQTY35,0 AS WQTY36,0 AS WQTY37,0 AS WQTY38,0 AS WQTY39,0 AS WQTY40
            ,0 AS WQTY41,0 AS WQTY42,0 AS WQTY43,0 AS WQTY44,0 AS WQTY45,0 AS WQTY46,0 AS WQTY47,0 AS WQTY48,0 AS WQTY49,0 AS WQTY50
            ,0 AS WQTY51,0 AS WQTY52
        FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
        --LEFT OUTER  JOIN SCP_MST_OUTSOURCING_CAPA Y WITH (NOLOCK)
        --  ON X.DIVISION_ID  = Y.DIVISION_ID
        -- AND X.ITEM_ID      = Y.ITEM_ID
        -- AND X.FROM_SITE    = Y.PLANT_SITE_ID
        CROSS APPLY SUB  WITH (NOLOCK)
        WHERE X.OPERATION_GROUP = SUB.OPERATION_GROUP
          AND X.MEASURE IN ('PACK_PROD'
                            ,'CELL_PROD'
                          )
UNION 
SELECT X.DIVISION_ID
            ,X.PLAN_START_YYYYMMDD
            ,X.PLAN_TYPE
            ,X.SEQ
            ,X.OPERATION_GROUP
            ,X.OPERATION_GROUP_NAME
            --,(CASE WHEN X.MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH_TOTAL','PACK_CELL_EOH') THEN 'A' ELSE X.OPERATION_GROUP END ) AS OPERATION_GROUP
            --,(CASE WHEN X.MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH_TOTAL','PACK_CELL_EOH') THEN 'CELL' ELSE X.OPERATION_GROUP_NAME END ) AS OPERATION_GROUP_NAME
            ,X.FROM_SITE
            ,ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE) , '-') AS FROM_SITE_DESCRIPTION
            ,X.ATTRIBUTE9 AS OPERATION_ID
            ,X.ITEM_ID
            ,X.NICK_NAME
            --,X.PROD_LINE
            ,'Total3' AS PROD_LINE
            ,NULL AS DAILY_CAPA_QTY
            ,NULL AS TACT_TIME
            ,X.FROM_BOH_QTY
            ,X.YIELD
            ,X.LT_DAY
            ,X.CELL_QTY_PACK
            ,X.MEASURE
            ,X.MEASURE_LABEL
            ,X.SORT_ORDER_NO
            ,'9999' AS XLS_KEY1
           -- ,(CASE WHEN X.MEASURE IN ('PACK_CELL_EOH_TOTAL') THEN '999' ELSE X.XLS_KEY1 END ) AS XLS_KEY1
            ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
            ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
            ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
            ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
            ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
            ,WQTY51,WQTY52

        FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
       WHERE 0 = 0
         AND X.MEASURE IN ('SEMI_PACK_PROD_CELL'
                          ,'PACK_CELL_BOH'
                          ,'PACK_CELL_EOH_TOTAL'
                          ,'PACK_CELL_EOH'
                          ,'SEMI_SHIP_PLAN'
                          )


