WITH WO_DATA AS (
          SELECT DISTINCT
                 MO.[COMPANY_ID]
                ,MO.[DIVISION_ID]
                ,MO.[SITE_ID]
                ,MO.[PLANT_ID]
                ,MO.[FACTORY_ID]
                ,MO.[PRODUCTION_TYPE]
                ,MO.[ITEM_ID]
                ,MO.[OPERATION_ID]
                ,MO.[LINE_ID]
                ,MO.[EQUIPMENT_ID]
                ,MO.MARKET
                ,CONVERT(VARCHAR, MO.[PLAN_DATE], 112) AS PLAN_DATE
          FROM  (
                SELECT MO.[COMPANY_ID]
                      ,MO.[DIVISION_ID]
                      ,MO.[SITE_ID]
                      ,MO.[PLANT_ID]
                      ,MO.[FACTORY_ID]
                      ,MO.[PLAN_WEEK]
                      ,MO.[PLAN_REVISION]
                      ,MAX(MO.[INSTANCE_ID])  AS INSTANCE_ID
                      ,MAX(MO.[PLAN_ID])      AS PLAN_ID
                      ,MO.[PRODUCTION_TYPE]
                      ,MAX(MO.[ORDER_TYPE])   AS ORDER_TYPE
                      ,MAX(MO.[WORK_ORDER_SPL_ID])  AS WORK_ORDER_SPL_ID
                      ,MAX(MO.[WORK_ORDER_ID]) AS WORK_ORDER_ID
                      ,MO.[ITEM_ID]
                      ,MO.[OPERATION_ID]
                      ,MO.[LINE_ID]
                      ,MAX(MO.[ELECTRODE_TYPE]) AS  ELECTRODE_TYPE
                      ,MO.[EQUIPMENT_ID]
                      ,MAX(MO.[LANE_QTY]) AS   LANE_QTY
                      ,MO.[PLAN_DATE]
                      ,SUM(MO.REMAIN_QTY)  AS REMAIN_QTY
                      ,MO.MARKET
                FROM   [FP_MANUAL_WORK_ORDER_H]  MO WITH(NOLOCK)
                WHERE  MO.[CUTOFF_DATE]     = CONVERT(DATE, GETDATE())
                AND    MO.[PLAN_TYPE]       = 'ROLLING'
                AND    MO.[OPERATION_ID] NOT IN ('E1000','E2500')
                AND    MO.[PLAN_REVISION]  != '-'
                GROUP BY MO.[COMPANY_ID]
                       ,MO.[DIVISION_ID]
                       ,MO.[SITE_ID]
                       ,MO.[PLANT_ID]
                       ,MO.[FACTORY_ID]
                       ,MO.[PLAN_WEEK]
                       ,MO.[PLAN_REVISION]
                       ,MO.[PRODUCTION_TYPE]
                       ,MO.[ITEM_ID]
                       ,MO.[OPERATION_ID]
                       ,MO.[LINE_ID]
                       ,MO.[EQUIPMENT_ID]
                       ,MO.[PLAN_DATE]
                       ,MO.MARKET
          ) MO
          LEFT OUTER JOIN [FP_MPP_WPP_BASE_PLAN_M]  WBP WITH(NOLOCK)
          ON     MO.[COMPANY_ID]      = WBP.[COMPANY_ID]
          AND    MO.[DIVISION_ID]     = WBP.[DIVISION_ID]
          AND    MO.[SITE_ID]         = WBP.[SITE_ID]
          AND    MO.[PLANT_ID]        = WBP.[PLANT_ID]
          AND    MO.[FACTORY_ID]      = WBP.[FACTORY_ID]
          AND    MO.[PLAN_WEEK]       = WBP.[PLAN_WEEK]
          AND    MO.[PLAN_REVISION]   = WBP.[PLAN_REVISION]
          AND    MO.[PRODUCTION_TYPE] = WBP.[PRODUCTION_TYPE]
          AND    MO.[ITEM_ID]         = WBP.[ITEM_ID]
          AND    MO.[OPERATION_ID]    = WBP.[OPERATION_ID]
          AND    MO.[LINE_ID]         = WBP.[LINE_ID]
          AND    MO.[EQUIPMENT_ID]    = WBP.[EQUIPMENT_ID]
          AND    MO.[PLAN_DATE]       = WBP.[PLAN_DATE]
          AND    MO.MARKET            = WBP.MARKET
          WHERE  ABS(MO.REMAIN_QTY - ISNULL(WBP.PLAN_QTY,0)) > 1
      )
      SELECT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
            ,A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID
            ,A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE
            ,A.MARKET
            @LIST_BUCKET 
      FROM (
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
              ,A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID
              ,A.ITEM_ID, ISNULL(B.NICK_NAME,'-') AS NICK_NAME, A.PRODUCTION_TYPE
              ,CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE
              ,SUM(A.REMAIN_QTY) AS QTY
              ,(CASE WHEN C.COMPANY_ID IS NULL THEN 'N' ELSE 'Y' END) AS IS_NOMATCH
              ,A.MARKET
        FROM   FP_MANUAL_WORK_ORDER_H A
        LEFT OUTER JOIN SCM_ITEM_M B
        ON     A.COMPANY_ID   = B.COMPANY_ID
        AND    A.DIVISION_ID  = B.DIVISION_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        LEFT OUTER JOIN WO_DATA C
        ON     A.COMPANY_ID   = C.COMPANY_ID
        AND    A.DIVISION_ID  = C.DIVISION_ID
        AND    A.SITE_ID      = C.SITE_ID
        AND    A.PLANT_ID     = C.PLANT_ID
        AND    A.FACTORY_ID   = C.FACTORY_ID
        AND    A.OPERATION_ID = C.OPERATION_ID
        AND    A.LINE_ID      = C.LINE_ID
        AND    A.EQUIPMENT_ID = C.EQUIPMENT_ID
        AND    A.ITEM_ID      = C.ITEM_ID
        AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) = C.PLAN_DATE
        AND    A.MARKET       = C.MARKET
        WHERE  CONVERT(VARCHAR, A.CUTOFF_DATE, 112) = @BUCKET_FROM
        AND    A.PLAN_TYPE    = @PLAN_TYPE
        AND    A.OPERATION_ID NOT IN ('E1000','E2500')
        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
                ,A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID
                ,A.ITEM_ID, ISNULL(B.NICK_NAME,'-'), A.PRODUCTION_TYPE
                ,CONVERT(VARCHAR, A.PLAN_DATE, 112), C.COMPANY_ID
                ,A.MARKET
      ) A
      GROUP BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
              ,A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID
              ,A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE
              ,A.MARKET
      ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
              ,A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID
              ,A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE
              ,A.MARKET