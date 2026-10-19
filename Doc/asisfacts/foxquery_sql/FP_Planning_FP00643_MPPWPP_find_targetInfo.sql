SELECT A.*
      		, '' AS MSG1
          	, '' AS MSG2
        	, ( CASE WHEN C.CATEGORY IS NULL THEN 'cell/batch' ELSE '' END ) AS MSG3
          	, ( CASE WHEN D.CATEGORY IS NULL THEN 'Pancake (m/batch)' ELSE '' END ) AS MSG4
          	, ( CASE WHEN E.CATEGORY IS NULL THEN 'Jumbo Roll (m/batch)' ELSE '' END ) AS MSG5
      FROM (
          SELECT @INSTANCE_ID AS INSTANCE_ID
              , (SELECT COMPANY_ID FROM SCM_FACTORY_M FF WITH(NOLOCK) WHERE FF.FACTORY_ID = @FACTORY_ID AND FF.ACTIVE_FLAG = 'Y') AS COMPANY_ID
              , @DIVISION_ID AS DIVISION_ID, @SITE_ID AS SITE_ID, @PLANT_ID AS PLANT_ID
              , @ITEM_ID AS ITEM_ID, @OPERATION_ID AS OPERATION_ID, @FACTORY_ID AS FACTORY_ID, @LOCATION AS LOCATION
              , @PRODUCTION_TYPE AS PRODUCTION_TYPE, @MARKET AS MARKET
              , @LINE_ID AS LINE_ID, @ELECTRODE_TYPE AS ELECTRODE_TYPE
              , @TOP_ITEM_ID AS TOP_ITEM_ID
      ) A
      INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)
      ON  A.COMPANY_ID  = B.COMPANY_ID
      AND A.DIVISION_ID = B.DIVISION_ID
      AND A.SITE_ID     = B.SITE_ID
      AND A.ITEM_ID     = B.ITEM_ID
      AND B.ACTIVE_FLAG = 'Y'
      LEFT OUTER HASH JOIN (
          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
               --, A.MODEL_ID
               , A.OPERATION
               , A.ITEM_ID
               , A.CATEGORY
          FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
          INNER JOIN (
              SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY
              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
              WHERE  A.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
              AND    A.ATTRIBUTE2 = 'Y'
          ) D
          ON     A.CATEGORY = D.E_CATEGORY
          INNER JOIN (
              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID
              FROM (
                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, VERSION_TYPE
                  FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
                  WHERE  A.MAX_VER_FLAG = 'Y'
                  AND    A.VALUE > 0
                  AND    A.CATEGORY IN (  'Jumbo Roll (cell/m)'
                                        , 'Lane Number'
                                        , 'Pancake (m/batch)'
                                        , 'cell/batch'
                                        , 'Jumbo Roll (m/batch)'
                                        , 'Pancake (cell/m)' )
                  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, VERSION_TYPE
                  HAVING COUNT(1) = 6
              ) A
          ) E
          ON     A.COMPANY_ID         = E.COMPANY_ID
          AND    A.DIVISION_ID        = E.DIVISION_ID
          AND    A.SITE_ID            = E.SITE_ID
          AND    A.PLANT_ID           = E.PLANT_ID
          AND    A.FACTORY_ID         = E.FACTORY_ID
          AND    A.OPERATION          = E.OPERATION
          AND    A.ITEM_ID            = E.ITEM_ID
          --AND    A.PROD_VERSION_TYPE  = E.PROD_VERSION_TYPE
          --AND    A.MODEL_ID           = E.MODEL_ID
          WHERE  A.MAX_VER_FLAG = 'Y'
          AND    A.CATEGORY     = 'cell/batch'
          AND    A.DIVISION_ID  = @DIVISION_ID
          AND    A.SITE_ID      = @SITE_ID
          AND    A.PLANT_ID     = @PLANT_ID
          AND    A.FACTORY_ID   = @FACTORY_ID
      ) C
      ON  A.COMPANY_ID    = C.COMPANY_ID
      AND A.DIVISION_ID   = C.DIVISION_ID
      AND A.SITE_ID       = C.SITE_ID
      AND A.PLANT_ID      = C.PLANT_ID
      AND A.FACTORY_ID    = C.FACTORY_ID
      --AND B.APPLIED_MODEL = C.MODEL_ID
      AND A.OPERATION_ID  = C.OPERATION
      AND A.ITEM_ID       = C.ITEM_ID
      LEFT OUTER HASH JOIN (
          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
               --, A.MODEL_ID
               , A.OPERATION
               , A.ITEM_ID
               , A.CATEGORY
          FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
          INNER JOIN (
              SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY
              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
              WHERE  A.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
              AND    A.ATTRIBUTE2 = 'Y'
          ) D
          ON     A.CATEGORY = D.E_CATEGORY
          INNER JOIN (
              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID
              FROM (
                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, VERSION_TYPE
                  FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
                  WHERE  A.MAX_VER_FLAG = 'Y'
                  AND    A.VALUE > 0
                  AND    A.CATEGORY IN (  'Jumbo Roll (cell/m)'
                                        , 'Lane Number'
                                        , 'Pancake (m/batch)'
                                        , 'cell/batch'
                                        , 'Jumbo Roll (m/batch)'
                                        , 'Pancake (cell/m)' )
                  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, VERSION_TYPE
                  HAVING COUNT(1) = 6
              ) A
          ) E
          ON     A.COMPANY_ID         = E.COMPANY_ID
          AND    A.DIVISION_ID        = E.DIVISION_ID
          AND    A.SITE_ID            = E.SITE_ID
          AND    A.PLANT_ID           = E.PLANT_ID
          AND    A.FACTORY_ID         = E.FACTORY_ID
          AND    A.OPERATION          = E.OPERATION
          AND    A.ITEM_ID            = E.ITEM_ID
          --AND    A.PROD_VERSION_TYPE  = E.PROD_VERSION_TYPE
          --AND    A.MODEL_ID           = E.MODEL_ID
          WHERE  A.MAX_VER_FLAG = 'Y'
          AND    A.CATEGORY     = 'Pancake (m/batch)'
          AND    A.DIVISION_ID  = @DIVISION_ID
          AND    A.SITE_ID      = @SITE_ID
          AND    A.PLANT_ID     = @PLANT_ID
          AND    A.FACTORY_ID   = @FACTORY_ID
      ) D
      ON  A.COMPANY_ID    = D.COMPANY_ID
      AND A.DIVISION_ID   = D.DIVISION_ID
      AND A.SITE_ID       = D.SITE_ID
      AND A.PLANT_ID      = D.PLANT_ID
      AND A.FACTORY_ID    = D.FACTORY_ID
      --AND B.APPLIED_MODEL = D.MODEL_ID
      AND A.OPERATION_ID  = D.OPERATION
      AND A.ITEM_ID       = D.ITEM_ID
      LEFT OUTER HASH JOIN (
          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
               --, A.MODEL_ID
               , A.OPERATION
               , A.ITEM_ID
               , A.CATEGORY
          FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
          INNER JOIN (
              SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY
              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
              WHERE  A.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
              AND    A.ATTRIBUTE2 = 'Y'
          ) D
          ON     A.CATEGORY = D.E_CATEGORY
          INNER JOIN (
              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID
              FROM (
                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, VERSION_TYPE
                  FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
                  WHERE  A.MAX_VER_FLAG = 'Y'
                  AND    A.VALUE > 0
                  AND    A.CATEGORY IN (  'Jumbo Roll (cell/m)'
                                        , 'Lane Number'
                                        , 'Pancake (m/batch)'
                                        , 'cell/batch'
                                        , 'Jumbo Roll (m/batch)'
                                        , 'Pancake (cell/m)' )
                  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, VERSION_TYPE
                  HAVING COUNT(1) = 6
              ) A
          ) E
          ON     A.COMPANY_ID         = E.COMPANY_ID
          AND    A.DIVISION_ID        = E.DIVISION_ID
          AND    A.SITE_ID            = E.SITE_ID
          AND    A.PLANT_ID           = E.PLANT_ID
          AND    A.FACTORY_ID         = E.FACTORY_ID
          AND    A.OPERATION          = E.OPERATION
          AND    A.ITEM_ID            = E.ITEM_ID
          --AND    A.PROD_VERSION_TYPE  = E.PROD_VERSION_TYPE
          --AND    A.MODEL_ID           = E.MODEL_ID
          WHERE  A.MAX_VER_FLAG = 'Y'
          AND    A.CATEGORY     = 'Jumbo Roll (m/batch)'
          AND    A.DIVISION_ID  = @DIVISION_ID
          AND    A.SITE_ID      = @SITE_ID
          AND    A.PLANT_ID     = @PLANT_ID
          AND    A.FACTORY_ID   = @FACTORY_ID
      ) E
      ON  A.COMPANY_ID    = E.COMPANY_ID
      AND A.DIVISION_ID   = E.DIVISION_ID
      AND A.SITE_ID       = E.SITE_ID
      AND A.PLANT_ID      = E.PLANT_ID
      AND A.FACTORY_ID    = E.FACTORY_ID
      --AND B.APPLIED_MODEL = E.MODEL_ID
      AND A.OPERATION_ID  = E.OPERATION
      AND A.ITEM_ID       = E.ITEM_ID