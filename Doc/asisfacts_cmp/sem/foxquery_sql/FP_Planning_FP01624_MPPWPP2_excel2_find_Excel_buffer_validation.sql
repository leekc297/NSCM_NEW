WITH _EQP AS (
          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, ISNULL(C.EQUIPMENT_ID,'-') AS EQUIPMENT_ID
               , MAX(CASE WHEN B.OPERATION_GROUP_ID = 'E' THEN 'Y' ELSE 'N' END) AS IS_ELEC
          FROM   SCM_LINE_M A WITH(NOLOCK)
          LEFT OUTER JOIN SCM_OPERATION_M B WITH(NOLOCK)
          ON     A.COMPANY_ID   = B.COMPANY_ID
          AND    A.DIVISION_ID  = B.DIVISION_ID
          AND    A.SITE_ID      = B.SITE_ID
          AND    A.OPERATION_ID = B.OPERATION_ID
          AND    B.ACTIVE_FLAG  = 'Y'
          LEFT OUTER JOIN SCM_EQUIPMENT_M C WITH(NOLOCK)
          ON     A.COMPANY_ID   = C.COMPANY_ID
          AND    A.DIVISION_ID  = C.DIVISION_ID
          AND    A.SITE_ID      = C.SITE_ID
          AND    A.PLANT_ID     = C.PLANT_ID
          AND    A.FACTORY_ID   = C.FACTORY_ID
          AND    A.OPERATION_ID = C.OPERATION_ID
          AND    A.LINE_ID      = C.LINE_ID
          AND    C.ACTIVE_FLAG  = 'Y'
          WHERE  A.ACTIVE_FLAG  = 'Y'
          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, ISNULL(C.EQUIPMENT_ID,'-')
      )
      SELECT A.*
            ,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END)
                  ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)
                  END AS _MSG
            ,CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID
      FROM (
          SELECT TT.*
                ,MSG1
                +(CASE WHEN (MSG1 = '')                                                                                                                 THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '')                                                                                                   THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                                                                                     THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')                                                                       THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '')                                                         THEN MSG6 ELSE (CASE WHEN MSG6 = '' THEN '' ELSE ',' + MSG6 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '')                                           THEN MSG7 ELSE (CASE WHEN MSG7 = '' THEN '' ELSE ',' + MSG7 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '')                             THEN MSG8 ELSE (CASE WHEN MSG8 = '' THEN '' ELSE ',' + MSG8 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '')               THEN MSG9 ELSE (CASE WHEN MSG9 = '' THEN '' ELSE ',' + MSG9 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '') THEN MSG10 ELSE (CASE WHEN MSG10 = '' THEN '' ELSE ',' + MSG10 END) END)
                + ' Not Found' AS __MSG
          FROM (
                SELECT DISTINCT 
                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                      ,A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET
                      ,(CASE WHEN C.IS_ELEC = 'Y' THEN A.EQUIPMENT_ID ELSE '-' END) AS EQUIPMENT_ID
                      ,CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.PLAN_QTY
                      ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                      ,CASE WHEN A.COMPANY_ID = '-' THEN 'Building' ELSE '' END AS MSG1
                      ,CASE WHEN E.OPERATION_ID IS NULL THEN 'Operation' ELSE '' END AS MSG2
                      ,CASE WHEN C.LINE_ID IS NULL THEN 'Line' ELSE '' END AS MSG3
                      ,CASE WHEN C.IS_ELEC = 'Y' THEN (CASE WHEN D.EQUIPMENT_ID IS NULL THEN 'Equipment - Elec.' ELSE '' END) ELSE '' END AS MSG4
                      ,CASE WHEN G.MARKET IS NULL THEN 'Market' ELSE '' END AS MSG5
                      ,CASE WHEN F.PROD_TYPE IS NULL THEN 'Production Type' ELSE '' END AS MSG6
                      ,CASE WHEN B.ITEM_ID IS NULL THEN 'Item' ELSE '' END AS MSG7
                      ,CASE WHEN C.MODEL_TYPE = 'EGL' AND A.OPERATION_ID = 'A9000' THEN '' 							-- [E20251020-000252] egl line a9000 add
                      		  WHEN C.MODEL_TYPE = 'EGL' AND A.OPERATION_ID LIKE 'A%' then 'EGL Line' 
                      		  ELSE '' END AS MSG8
                      ,CASE WHEN C.MODEL_TYPE = 'EGL' AND A.OPERATION_ID = 'A9000' THEN '' 							-- [E20251020-000252] egl line a9000 add
                      		  WHEN A.OPERATION_ID NOT IN ('F4000','F5300','F5500','F5400','F5600','F6000','F6200','F7000','F7100','F7200','F7300') 
                      						THEN 'Only (F4000,F5300,F5400,F5500,F5600,F6000,F6200,F7000,F7100,F7200,F7300) operation can be uploaded.' 
                      			ELSE '' END AS MSG9
                      --,CASE WHEN C.MODEL_TYPE = 'EGL' AND A.OPERATION_ID LIKE 'A%' THEN 'EGL Line' ELSE '' END AS MSG8
                      --,CASE WHEN A.OPERATION_ID NOT IN ('F4000','F5300','F5400','F5500','F5600','F6000','F6200','F7000','F7100','F7200','F7300') THEN 'Only (F4000,F5300,F5400,F5500,F5600,F6000,F6200,F7000,F7100,F7200,F7300) operation can be uploaded.' ELSE '' END AS MSG9
                      ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG10
              				,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.MARKET, (CASE WHEN C.IS_ELEC = 'Y' THEN A.EQUIPMENT_ID ELSE '-' END), A.ITEM_ID, A.PLAN_DATE, A.MARKET
              				                             ORDER BY     A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.MARKET, (CASE WHEN C.IS_ELEC = 'Y' THEN A.EQUIPMENT_ID ELSE '-' END), A.ITEM_ID, A.PLAN_DATE, A.MARKET)>1 THEN 'Data Overlap'
              				      ELSE '' END AS MSG99
                FROM (
                    SELECT A.PLAN_WEEK, A.PLAN_REVISION
                         , ISNULL(B.COMPANY_ID,'-') AS COMPANY_ID, ISNULL(B.DIVISION_ID,'-') AS DIVISION_ID, ISNULL(B.SITE_ID,'-') AS SITE_ID, ISNULL(B.PLANT_ID,'-') AS PLANT_ID, ISNULL(B.FACTORY_ID,'-') AS FACTORY_ID
                         , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.PRODUCTION_TYPE, A.ITEM_ID, A.PLAN_DATE, A.PLAN_QTY, A.MARKET
                         , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                    FROM   BUF_MPP_WPP_BASE_PLAN_M A WITH(NOLOCK)
                    LEFT OUTER JOIN  SCM_FACTORY_M B WITH(NOLOCK)
                    ON  A.FACTORY_ID    = B.FACTORY_ID
                    AND B.ACTIVE_FLAG   = 'Y'
                    WHERE A.JOB_USER_ID = @USER_ID
                ) A
                LEFT OUTER JOIN (
                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,  A.ITEM_ID
                    FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M IC WITH(NOLOCK)
                    WHERE  A.ITEM_CLASS  = IC.CLASS_ID
                    AND    IC.USE_FLAG   = 'Y'
                    AND    A.ACTIVE_FLAG = 'Y'
                ) B
                ON  A.COMPANY_ID  = B.COMPANY_ID
                AND A.DIVISION_ID = B.DIVISION_ID
                AND A.SITE_ID     = B.SITE_ID
                AND A.ITEM_ID     = B.ITEM_ID
                LEFT OUTER JOIN (
                    SELECT A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, MAX(CASE WHEN B.OPERATION_GROUP_ID = 'E' THEN 'Y' ELSE 'N' END) AS IS_ELEC, A.MODEL_TYPE
                    FROM   SCM_LINE_M A WITH(NOLOCK)
                    LEFT OUTER JOIN SCM_OPERATION_M B WITH(NOLOCK)
                    ON     A.COMPANY_ID   = B.COMPANY_ID
                    AND    A.DIVISION_ID  = B.DIVISION_ID
                    AND    A.SITE_ID      = B.SITE_ID
                    AND    A.OPERATION_ID = B.OPERATION_ID
                    AND    B.ACTIVE_FLAG  = 'Y'
                    WHERE  A.ACTIVE_FLAG  = 'Y'
                    GROUP BY A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.MODEL_TYPE
                ) C
                ON  A.FACTORY_ID    = C.FACTORY_ID
                AND A.OPERATION_ID  = C.OPERATION_ID
                AND A.LINE_ID       = C.LINE_ID
                LEFT OUTER JOIN (
                    SELECT DISTINCT A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, '-' AS EQUIPMENT_ID, A.IS_ELEC
                    FROM   _EQP A
                    WHERE  A.IS_ELEC = 'N'
                    UNION ALL
                    SELECT A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.IS_ELEC
                    FROM   _EQP A
                    WHERE  A.IS_ELEC = 'Y'
                    AND    A.EQUIPMENT_ID <> '-'
                ) D
                ON  A.FACTORY_ID   = D.FACTORY_ID
                AND A.OPERATION_ID = D.OPERATION_ID
                AND A.LINE_ID      = D.LINE_ID
                AND A.EQUIPMENT_ID = D.EQUIPMENT_ID
                LEFT OUTER JOIN (
                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                    FROM   SCM_OPERATION_M A WITH(NOLOCK)
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
                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                    WHERE  A.LOOKUP_TYPE_CODE = 'DEMAND_TYPE'
                    AND    A.ACTIVE_FLAG = 'Y'
                    */
                ) F
                ON  A.PRODUCTION_TYPE = F.PROD_TYPE
                AND A.DIVISION_ID     = F.DIVISION_ID
                LEFT OUTER JOIN (
                    SELECT SEGMENT1 AS MARKET
                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                    WHERE  LOOKUP_TYPE_CODE = 'DEMAND_MARKET_TYPE'
                ) G
                ON  A.MARKET = G.MARKET
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