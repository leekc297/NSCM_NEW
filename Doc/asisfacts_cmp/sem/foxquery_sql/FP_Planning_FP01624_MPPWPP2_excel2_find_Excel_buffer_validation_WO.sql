WITH _EQUIP AS (
          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, C.EQUIPMENT_ID, E.ITEM_ID
               , ROW_NUMBER( ) OVER( PARTITION BY E.ITEM_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID
                                     ORDER BY     E.ITEM_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, D.PRIORITY) AS EQU_NUM
          FROM   SCM_LINE_M A WITH(NOLOCK)
          INNER JOIN SCM_OPERATION_M B WITH(NOLOCK)
          ON     A.COMPANY_ID   = B.COMPANY_ID
          AND    A.DIVISION_ID  = B.DIVISION_ID
          AND    A.SITE_ID      = B.SITE_ID
          AND    A.OPERATION_ID = B.OPERATION_ID
          AND    B.ACTIVE_FLAG  = 'Y'
          INNER JOIN SCM_EQUIPMENT_M C WITH(NOLOCK)
          ON     A.COMPANY_ID   = C.COMPANY_ID
          AND    A.DIVISION_ID  = C.DIVISION_ID
          AND    A.SITE_ID      = C.SITE_ID
          AND    A.PLANT_ID     = C.PLANT_ID
          AND    A.FACTORY_ID   = C.FACTORY_ID
          AND    A.OPERATION_ID = C.OPERATION_ID
          AND    A.LINE_ID      = C.LINE_ID
          AND    A.ELECTRODE_TYPE = ISNULL(C.ELECTRODE_TYPE,'-')
          AND    C.EQUIPMENT_TYPE = 'M'
          AND    C.ACTIVE_FLAG  = 'Y'
          INNER JOIN (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PRIORITY, A.ITEM_ID
              FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)
              WHERE  A.ACTIVE_FLAG = 'Y'
              AND    A.MONTH = SUBSTRING(CONVERT(VARCHAR,dbo.SYSDATE1(),112), 1, 6)
              AND    A.PRIORITY < 9
          ) D
          ON     A.COMPANY_ID   = D.COMPANY_ID
          AND    A.DIVISION_ID  = D.DIVISION_ID
          AND    A.SITE_ID      = D.SITE_ID
          AND    A.PLANT_ID     = D.PLANT_ID
          AND    A.FACTORY_ID   = D.FACTORY_ID
          AND    A.OPERATION_ID = D.OPERATION_ID
          AND    A.LINE_ID      = D.LINE_ID
          AND    A.ELECTRODE_TYPE = D.ELECTRODE_TYPE
          INNER JOIN SCM_ITEM_M E WITH(NOLOCK)
          ON     D.COMPANY_ID   = E.COMPANY_ID
          AND    D.DIVISION_ID  = E.DIVISION_ID
          AND    D.SITE_ID      = E.SITE_ID
          AND    D.ITEM_ID      = E.ITEM_ID
          WHERE  A.ACTIVE_FLAG  = 'Y'
      )
      , _PLAN_GROUP AS (
          SELECT A.*
          FROM (
              SELECT A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE1 AS CONFIRM_AREA
                   , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, B.FACTORY_ID
                   , B.INSTANCE_TYPE
                   , D.OPERATION_ID
                   , E.LINE_ID
                   , MAX(E.MODEL_TYPE) AS PLAN_GROUP_ID
              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                   , FP_INSTANCE_FACTORY_M B WITH(NOLOCK)
                   , SCM_FACTORY_M C WITH(NOLOCK)
                   , SCM_OPERATION_M D WITH(NOLOCK)
                   , SCM_LINE_M E WITH(NOLOCK)
              WHERE  A.SEGMENT1         = B.INSTANCE_ID
              AND    B.FACTORY_ID       = C.FACTORY_ID
              AND    B.INSTANCE_TYPE    = D.INSTANCE_TYPE
              AND    C.COMPANY_ID       = D.COMPANY_ID
              AND    C.DIVISION_ID      = D.DIVISION_ID
              AND    C.SITE_ID          = D.SITE_ID
              AND    C.COMPANY_ID       = E.COMPANY_ID
              AND    C.DIVISION_ID      = E.DIVISION_ID
              AND    C.SITE_ID          = E.SITE_ID
              AND    C.PLANT_ID         = E.PLANT_ID
              AND    C.FACTORY_ID       = E.FACTORY_ID
              AND    D.OPERATION_ID     = E.OPERATION_ID
              AND    A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
              AND    A.ATTRIBUTE1       = 'PLAN GROUP'
              AND    A.SEGMENT1        != 'KR_CELL_M_P'
              AND    A.ACTIVE_FLAG      = 'Y'
              AND    B.ACTIVE_FLAG      = 'Y'
              AND    C.ACTIVE_FLAG      = 'Y'
              AND    D.ACTIVE_FLAG      = 'Y'
              AND    E.ACTIVE_FLAG      = 'Y'
              GROUP BY A.SEGMENT1, A.ATTRIBUTE1
                     , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, B.FACTORY_ID
                     , B.INSTANCE_TYPE
                     , D.OPERATION_ID
                     , E.LINE_ID
          ) A
          , SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)
          WHERE A.INSTANCE_ID      = B.SEGMENT1
          AND   A.PLAN_GROUP_ID    = B.SEGMENT2
          AND   B.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
          AND   B.ACTIVE_FLAG      = 'Y'
      )
      , INST_INFO AS (
          SELECT A.*
          FROM (
              SELECT A.*
                  , ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID
                                      ORDER BY     A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.INSTANCE_TYPE DESC, A.INSTANCE_ID ) AS ROW_NUM
              FROM (
                  SELECT * FROM _PLAN_GROUP
                  UNION ALL
                  SELECT A.*
                  FROM (
                      SELECT A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE1 AS CONFIRM_AREA
                           , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, B.FACTORY_ID
                           , B.INSTANCE_TYPE
                           , D.OPERATION_ID
                           , E.LINE_ID
                           , '-' AS PLAN_GROUP_ID
                      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                           , FP_INSTANCE_FACTORY_M B WITH(NOLOCK)
                           , SCM_FACTORY_M C WITH(NOLOCK)
                           , SCM_OPERATION_M D WITH(NOLOCK)
                           , SCM_LINE_M E WITH(NOLOCK)
                      WHERE  A.SEGMENT1         = B.INSTANCE_ID
                      AND    B.FACTORY_ID       = C.FACTORY_ID
                      AND    B.INSTANCE_TYPE    = D.INSTANCE_TYPE
                      AND    C.COMPANY_ID       = D.COMPANY_ID
                      AND    C.DIVISION_ID      = D.DIVISION_ID
                      AND    C.SITE_ID          = D.SITE_ID
                      AND    C.COMPANY_ID       = E.COMPANY_ID
                      AND    C.DIVISION_ID      = E.DIVISION_ID
                      AND    C.SITE_ID          = E.SITE_ID
                      AND    C.PLANT_ID         = E.PLANT_ID
                      AND    C.FACTORY_ID       = E.FACTORY_ID
                      AND    D.OPERATION_ID     = E.OPERATION_ID
                      AND    A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
                      AND    A.ATTRIBUTE1       = 'BUILDING'
                      AND    A.SEGMENT1        != 'KR_CELL_M_P'
                      AND    A.ACTIVE_FLAG      = 'Y'
                      AND    B.ACTIVE_FLAG      = 'Y'
                      AND    C.ACTIVE_FLAG      = 'Y'
                      AND    D.ACTIVE_FLAG      = 'Y'
                      AND    E.ACTIVE_FLAG      = 'Y'
                      GROUP BY A.SEGMENT1, A.ATTRIBUTE1
                             , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, B.FACTORY_ID
                             , B.INSTANCE_TYPE
                             , D.OPERATION_ID
                             , E.LINE_ID
                  ) A
                  WHERE NOT EXISTS (
                      SELECT 1
                      FROM   _PLAN_GROUP BB
                      WHERE  A.COMPANY_ID   = BB.COMPANY_ID
                      AND    A.DIVISION_ID  = BB.DIVISION_ID
                      AND    A.SITE_ID      = BB.SITE_ID
                      AND    A.PLANT_ID     = BB.PLANT_ID
                      AND    A.FACTORY_ID   = BB.FACTORY_ID
                      AND    A.OPERATION_ID = BB.OPERATION_ID
                      AND    A.LINE_ID      = BB.LINE_ID
                  )
              ) A
          ) A
          WHERE A.ROW_NUM = 1
      )
      SELECT A.*
            ,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END)
                  ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)
                  END AS _MSG
            ,CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID
      FROM (
          SELECT TT.*
                ,MSG1
                +(CASE WHEN (MSG1 = '')                                                                                                                                 THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '')                                                                                                                   THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                                                                                                     THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')                                                                                       THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '')                                                                         THEN MSG6 ELSE (CASE WHEN MSG6 = '' THEN '' ELSE ',' + MSG6 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = ''  AND MSG6 = '')                                                          THEN MSG7 ELSE (CASE WHEN MSG7 = '' THEN '' ELSE ',' + MSG7 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = ''  AND MSG6 = '' AND MSG7 = '')                                            THEN MSG8 ELSE (CASE WHEN MSG8 = '' THEN '' ELSE ',' + MSG8 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = ''  AND MSG6 = '' AND MSG7 = '' AND MSG8 = '')                              THEN MSG9 ELSE (CASE WHEN MSG9 = '' THEN '' ELSE ',' + MSG9 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = ''  AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '')                THEN MSG10 ELSE (CASE WHEN MSG10 = '' THEN '' ELSE ',' + MSG10 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = ''  AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '') THEN MSG11 ELSE (CASE WHEN MSG11 = '' THEN '' ELSE ',' + MSG11 END) END)
                + ' Not Found' AS __MSG
          FROM (
                SELECT DISTINCT 
                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                      ,A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET
                      ,(CASE WHEN A.EQUIPMENT_ID IS NOT NULL THEN A.EQUIPMENT_ID ELSE D.EQUIPMENT_ID END) AS EQUIPMENT_ID
                      ,CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.PLAN_QTY
                      ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                      ,CASE WHEN A.COMPANY_ID = '-' THEN 'Building' ELSE '' END AS MSG1
                      ,CASE WHEN E.OPERATION_ID IS NULL THEN 'Operation' ELSE '' END AS MSG2
                      ,CASE WHEN C.LINE_ID IS NULL THEN 'Line' ELSE '' END AS MSG3
                      --,(CASE WHEN A.EQUIPMENT_ID IS NOT NULL THEN (CASE WHEN H.EQUIPMENT_ID IS NULL THEN 'Equipment or Line Assign' ELSE '' END) ELSE '' END) AS MSG4
                      ,(CASE WHEN A.EQUIPMENT_ID IS NOT NULL THEN (CASE WHEN H.EQUIPMENT_ID IS NULL AND (A.INSTANCE_ID NOT LIKE '%CELL%' AND A.INSTANCE_ID NOT LIKE '%PACK%') THEN 'Equipment or Line Assign' ELSE '' END) ELSE '' END) AS MSG4 -- cell, pack exception.... 20220713
                      ,CASE WHEN I.MARKET IS NULL THEN 'Market' ELSE '' END AS MSG5
                      ,CASE WHEN F.PROD_TYPE IS NULL THEN 'Production Type' ELSE '' END AS MSG6
                      ,CASE WHEN G.LINE_ID IS NULL THEN 'Line Assign' ELSE '' END AS MSG7
                      ,'' AS MSG8
                      ,CASE WHEN DENSE_RANK() OVER(ORDER BY A.INSTANCE_ID)>1 THEN '[There are two or more instances of data.]' ELSE '' END MSG9
                      ,CASE WHEN B.ITEM_ID IS NULL THEN 'Item' ELSE '' END AS MSG10
                      ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG11
              				,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, (CASE WHEN A.EQUIPMENT_ID IS NOT NULL THEN A.EQUIPMENT_ID ELSE D.EQUIPMENT_ID END), A.ITEM_ID, A.PLAN_DATE, A.MARKET
              				                             ORDER BY     A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, (CASE WHEN A.EQUIPMENT_ID IS NOT NULL THEN A.EQUIPMENT_ID ELSE D.EQUIPMENT_ID END), A.ITEM_ID, A.PLAN_DATE, A.MARKET)>1 THEN 'Data Overlap'
              				      ELSE '' END AS MSG99
                FROM (
                    SELECT A.PLAN_WEEK, A.PLAN_REVISION
                          ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID
                          ,A.EQUIPMENT_ID, A.PRODUCTION_TYPE, A.ITEM_ID, A.PLAN_DATE, A.PLAN_QTY
                          ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                          ,B.INSTANCE_ID, A.MARKET
                    FROM (
                        SELECT A.PLAN_WEEK, A.PLAN_REVISION
                             , ISNULL(B.COMPANY_ID,'-') AS COMPANY_ID, ISNULL(B.DIVISION_ID,'-') AS DIVISION_ID, ISNULL(B.SITE_ID,'-') AS SITE_ID, ISNULL(B.PLANT_ID,'-') AS PLANT_ID, ISNULL(B.FACTORY_ID,'-') AS FACTORY_ID
                             , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.PRODUCTION_TYPE, A.ITEM_ID, A.PLAN_DATE, A.PLAN_QTY
                             , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                             , A.MARKET
                        FROM   BUF_MPP_WPP_BASE_PLAN_M A
                        LEFT OUTER JOIN  SCM_FACTORY_M B
                        ON  A.FACTORY_ID    = B.FACTORY_ID
                        AND B.ACTIVE_FLAG   = 'Y'
                        AND B.FACTORY_ID IN ('E1','E7','E8','EA','M1','M2','M3','M4','M5','M6','M7','M8')
                        WHERE A.JOB_USER_ID = @USER_ID
                    ) A
                    LEFT OUTER JOIN INST_INFO B
                    ON  A.COMPANY_ID    = B.COMPANY_ID
                    AND A.DIVISION_ID   = B.DIVISION_ID
                    AND A.SITE_ID       = B.SITE_ID
                    AND A.PLANT_ID      = B.PLANT_ID
                    AND A.FACTORY_ID    = B.FACTORY_ID
                    AND A.OPERATION_ID  = B.OPERATION_ID
                    AND A.LINE_ID       = B.LINE_ID
                ) A
                LEFT OUTER JOIN (
                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,  A.ITEM_ID
                    FROM   SCM_ITEM_M A, SCM_ITEM_CLASS_M IC
                    WHERE  A.ITEM_CLASS  = IC.CLASS_ID
                    AND    IC.USE_FLAG   = 'Y'
                    AND    A.ACTIVE_FLAG = 'Y'
                ) B
                ON  A.COMPANY_ID  = B.COMPANY_ID
                AND A.DIVISION_ID = B.DIVISION_ID
                AND A.SITE_ID     = B.SITE_ID
                AND A.ITEM_ID     = B.ITEM_ID
                LEFT OUTER JOIN (
                    SELECT A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID
                    FROM   SCM_LINE_M A
                    LEFT OUTER JOIN SCM_OPERATION_M B
                    ON     A.COMPANY_ID   = B.COMPANY_ID
                    AND    A.DIVISION_ID  = B.DIVISION_ID
                    AND    A.SITE_ID      = B.SITE_ID
                    AND    A.OPERATION_ID = B.OPERATION_ID
                    AND    B.ACTIVE_FLAG  = 'Y'
                    WHERE  A.ACTIVE_FLAG  = 'Y'
                    GROUP BY A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID
                ) C
                ON  A.FACTORY_ID    = C.FACTORY_ID
                AND A.OPERATION_ID  = C.OPERATION_ID
                AND A.LINE_ID       = C.LINE_ID
                LEFT OUTER JOIN (SELECT * FROM _EQUIP WHERE EQU_NUM = 1) D
                ON  A.FACTORY_ID   = D.FACTORY_ID
                AND A.OPERATION_ID = D.OPERATION_ID
                AND A.LINE_ID      = D.LINE_ID
                AND A.ITEM_ID      = D.ITEM_ID
                LEFT OUTER JOIN (
                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                    FROM   SCM_OPERATION_M A
                    WHERE  A.ACTIVE_FLAG = 'Y'
                ) E
                ON  A.COMPANY_ID   = E.COMPANY_ID
                AND A.DIVISION_ID  = E.DIVISION_ID
                AND A.SITE_ID      = E.SITE_ID
                AND A.OPERATION_ID = E.OPERATION_ID
                LEFT OUTER JOIN (
                    SELECT DISTINCT A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PROD_TYPE
                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                    WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
                    AND    A.ACTIVE_FLAG = 'Y'
                    /*
                    SELECT DISTINCT A.SEGMENT1 AS PROD_TYPE
                    FROM   SCM_SYS_LOOKUP_VALUE A
                    WHERE  A.LOOKUP_TYPE_CODE = 'DEMAND_TYPE'
                    AND    A.ACTIVE_FLAG = 'Y'
                    */
                ) F
                ON  A.PRODUCTION_TYPE = F.PROD_TYPE
                AND A.DIVISION_ID     = F.DIVISION_ID
                LEFT OUTER JOIN (
                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID
                    FROM   SCM_ITEM_LINE_ASSIGN_M A
                    WHERE  A.ACTIVE_FLAG = 'Y'
                ) G
                ON  A.COMPANY_ID   = G.COMPANY_ID
                AND A.DIVISION_ID  = G.DIVISION_ID
                AND A.SITE_ID      = G.SITE_ID
                AND A.PLANT_ID     = G.PLANT_ID
                AND A.FACTORY_ID   = G.FACTORY_ID
                AND A.ITEM_ID      = G.ITEM_ID
                AND A.OPERATION_ID = G.OPERATION_ID
                AND A.LINE_ID      = G.LINE_ID
                LEFT OUTER JOIN _EQUIP H
                ON  A.FACTORY_ID   = H.FACTORY_ID
                AND A.OPERATION_ID = H.OPERATION_ID
                AND A.LINE_ID      = H.LINE_ID
                AND A.EQUIPMENT_ID = H.EQUIPMENT_ID
                AND A.ITEM_ID      = H.ITEM_ID
                LEFT OUTER JOIN (
                    SELECT SEGMENT1 AS MARKET
                    FROM   SCM_SYS_LOOKUP_VALUE
                    WHERE  LOOKUP_TYPE_CODE = 'DEMAND_MARKET_TYPE'
                ) I
                ON  A.MARKET = I.MARKET
                LEFT OUTER JOIN (
                     SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID
                     FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)
                     WHERE  R.USER_ID   = @USER_ID
                     AND    R.SAVE_FLAG = 'Y'
                ) R
                ON   A.COMPANY_ID   = R.COMPANY_ID
                AND  A.DIVISION_ID  = R.DIVISION_ID
                AND  A.SITE_ID      = R.SITE_ID
                AND  A.PLANT_ID     = R.PLANT_ID
                AND  A.FACTORY_ID   = R.FACTORY_ID
                AND  A.OPERATION_ID = R.OPERATION_ID
                AND  A.LINE_ID      = R.LINE_ID
          ) TT
      ) A
      ORDER BY A.JOB_ORDER