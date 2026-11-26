SELECT A.*
            ,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END)
                  ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)
                  END AS _MSG
            ,CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID
      FROM (
          SELECT TT.*
                ,MSG1
                + ' Not Found' AS __MSG
          FROM (
              SELECT DISTINCT 
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                    ,A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.PRODUCTION_TYPE
                    ,A.EQUIPMENT_ID, A.PLAN_DATE
                    ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                    ,CASE WHEN B.LINE_ID IS NULL THEN 'Line Assign Priority' ELSE '' END AS MSG1
                    ,'' AS MSG99
              FROM (
                  SELECT ISNULL(B.COMPANY_ID,'-') AS COMPANY_ID, ISNULL(B.DIVISION_ID,'-') AS DIVISION_ID, ISNULL(B.SITE_ID,'-') AS SITE_ID, ISNULL(B.PLANT_ID,'-') AS PLANT_ID, A.FACTORY_ID
                       , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.PRODUCTION_TYPE, A.ITEM_ID, A.PLAN_DATE, SUBSTRING(A.PLAN_DATE, 1, 6) AS PLAN_MONTH
                       , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                  FROM   BUF_MPP_WPP_BASE_PLAN_LINEASSIGN_M A
                  LEFT OUTER JOIN SCM_FACTORY_M B
                  ON  A.FACTORY_ID    = B.FACTORY_ID
                  AND B.ACTIVE_FLAG   = 'Y'
                  WHERE A.JOB_USER_ID = @USER_ID
              ) A
              LEFT OUTER JOIN (
                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.MONTH
                  FROM   SCM_ITEM_LINE_ASSIGN_M A
                  WHERE  A.ACTIVE_FLAG = 'Y'
                  AND    A.PRIORITY < 9
              ) B
              ON  A.COMPANY_ID   = B.COMPANY_ID
              AND A.DIVISION_ID  = B.DIVISION_ID
              AND A.SITE_ID      = B.SITE_ID
              AND A.PLANT_ID     = B.PLANT_ID
              AND A.FACTORY_ID   = B.FACTORY_ID
              AND A.ITEM_ID      = B.ITEM_ID
              AND A.OPERATION_ID = B.OPERATION_ID
              AND A.LINE_ID      = B.LINE_ID
              and A.PLAN_MONTH   = B.MONTH
          ) TT
      ) A
      ORDER BY A.JOB_ORDER