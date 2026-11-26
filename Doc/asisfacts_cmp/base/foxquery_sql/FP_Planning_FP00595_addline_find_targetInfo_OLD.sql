SELECT A.*
      		--, ( CASE WHEN A.OPERATION_ID='A9000' THEN ( CASE WHEN G.ITEM_ID IS NULL THEN 'RCCP or Test Target' ELSE '' END ) ELSE '' END ) AS MSG1
      		, '' AS MSG1
          --, ( CASE WHEN H.MARKET IS NULL THEN 'SCP or Test Target-Market' ELSE '' END ) AS MSG2
      		, '' AS MSG2
          , ( CASE WHEN C.CATEGORY IS NULL THEN 'cell/batch' ELSE '' END ) AS MSG3
          , ( CASE WHEN D.CATEGORY IS NULL THEN 'Pancake (m/batch)' ELSE '' END ) AS MSG4
          , ( CASE WHEN E.CATEGORY IS NULL THEN 'Jumbo Roll (m/batch)' ELSE '' END ) AS MSG5
          ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG6
      FROM (
	          SELECT @INSTANCE_ID AS INSTANCE_ID
		              , (SELECT COMPANY_ID FROM SCM_FACTORY_M FF WITH(NOLOCK) WHERE FF.FACTORY_ID = @FACTORY_ID AND FF.ACTIVE_FLAG = 'Y') AS COMPANY_ID
		              , @DIVISION_ID AS DIVISION_ID, @SITE_ID AS SITE_ID, @PLANT_ID AS PLANT_ID
		              , @ITEM_ID AS ITEM_ID, @OPERATION_ID AS OPERATION_ID, @FACTORY_ID AS FACTORY_ID, @LOCATION AS LOCATION
		              , @PRODUCTION_TYPE AS PRODUCTION_TYPE, @MARKET AS MARKET
		              , @LINE_ID AS LINE_ID, @ELECTRODE_TYPE AS ELECTRODE_TYPE
		              , @TOP_ITEM_ID AS TOP_ITEM_ID
		              , (CASE WHEN @PROD_VERSION_TYPE IS NULL OR @PROD_VERSION_TYPE = '' THEN 'GENERAL' ELSE @PROD_VERSION_TYPE END) AS PROD_VERSION_TYPE
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
			               , A.PROD_VERSION_TYPE
			          FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
			          INNER JOIN (
			              SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY
			              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
			              WHERE  A.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
			              AND    A.ATTRIBUTE2 = 'Y'
			          ) D
			          ON     A.CATEGORY = D.E_CATEGORY
			          INNER JOIN (
			              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE
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
			          AND    A.PROD_VERSION_TYPE  = E.PROD_VERSION_TYPE
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
		      AND A.PROD_VERSION_TYPE = C.PROD_VERSION_TYPE
		      LEFT OUTER HASH JOIN (
		          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
		               --, A.MODEL_ID
		               , A.OPERATION
		               , A.ITEM_ID
		               , A.CATEGORY
		               , A.PROD_VERSION_TYPE
		          FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
		          INNER JOIN (
		              SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY
		              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
		              WHERE  A.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
		              AND    A.ATTRIBUTE2 = 'Y'
		          ) D
		          ON     A.CATEGORY = D.E_CATEGORY
		          INNER JOIN (
		              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE
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
		          AND    A.PROD_VERSION_TYPE  = E.PROD_VERSION_TYPE
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
		      AND A.PROD_VERSION_TYPE = D.PROD_VERSION_TYPE
		      LEFT OUTER HASH JOIN (
		          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
		               --, A.MODEL_ID
		               , A.OPERATION
		               , A.ITEM_ID
		               , A.CATEGORY
		               , A.PROD_VERSION_TYPE
		          FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
		          INNER JOIN (
		              SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY
		              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
		              WHERE  A.LOOKUP_TYPE_CODE = 'ITEM_CONV_CALC'
		              AND    A.ATTRIBUTE2 = 'Y'
		          ) D
		          ON     A.CATEGORY = D.E_CATEGORY
		          INNER JOIN (
		              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE
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
		          AND    A.PROD_VERSION_TYPE  = E.PROD_VERSION_TYPE
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
		      AND A.PROD_VERSION_TYPE = E.PROD_VERSION_TYPE
		      LEFT OUTER HASH JOIN (
		          SELECT DISTINCT INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
		          FROM   FP_INSTANCE_ITEM_V
		      ) G
		      ON  A.INSTANCE_ID = G.INSTANCE_ID
		      AND A.COMPANY_ID  = G.COMPANY_ID
		      AND A.DIVISION_ID = G.DIVISION_ID
		      AND A.SITE_ID     = G.SITE_ID
		      AND A.PLANT_ID    = G.PLANT_ID
		      AND A.ITEM_ID     = G.ITEM_ID
		      LEFT OUTER HASH JOIN (
		          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MARKET, A.ITEM_ID
		          FROM (
		              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,'D') AS MARKET, A.ITEM_ID
		    					FROM   FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK)
		    					WHERE  (A.DIVISION_ID+A.SHOP_GROUP_ID+A.SCP_PLAN_ID) IN (SELECT A.DIVISION_ID+A.SHOP_GROUP_ID+MAX(A.SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK) GROUP BY A.DIVISION_ID, A.SHOP_GROUP_ID)
		    					UNION ALL
		    					SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,'D') AS MARKET, A.ITEM_ID
		    					FROM   FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK)
		    					WHERE  A.SCP_PLAN_ID = (SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK))
		    					UNION ALL
		    					SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,'D') AS MARKET, A.ITEM_ID
		    					FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK)
		    					WHERE  A.DUE_DATE >= (SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112))
		    					                      FROM   SCM_FP_PLAN_H
		    					                      WHERE  PLAN_ID = @FP_PLAN_ID )
		    					UNION ALL
		    					SELECT  DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,'D') AS MARKET, A.ITEM_ID
		    					FROM   FP_DAILY_INSTANCE_DEMAND_H A WITH(NOLOCK)
		    					WHERE  1=1
		    					AND   INSTANCE_ID = CASE WHEN @INSTANCE_ID = 'KR_E_PRE_A' OR @INSTANCE_ID = 'KR_E_PRE_M' THEN 'KR_E_PRE'
		    					                    ELSE @INSTANCE_ID END
		    					AND   INSTANCE_DATE = SUBSTRING(@FP_PLAN_ID,CHARINDEX('-',@FP_PLAN_ID,1)+1,8)
		    					AND   CONVERT(VARCHAR, INSTANCE_DATE,102) = ( SELECT CONVERT(VARCHAR, PLAN_START_TIME,102)
		    				                                                FROM   SCM_FP_PLAN_H KK WITH(NOLOCK)
		    				                                                WHERE  PLAN_ID = @FP_PLAN_ID
		    				                                            	)
		          ) A
		      ) H
		      ON  A.COMPANY_ID  = H.COMPANY_ID
		      AND A.DIVISION_ID = H.DIVISION_ID
		      AND A.SITE_ID     = H.SITE_ID
		      AND A.PLANT_ID    = H.PLANT_ID
		      AND A.MARKET      = H.MARKET
		      AND A.TOP_ITEM_ID = H.ITEM_ID
		      	LEFT OUTER JOIN (
						SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID
						FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)
						WHERE	1=1
						AND		R.USER_ID	= @USER_ID
						AND		R.SAVE_FLAG	= 'Y'
						AND		R.INSTANCE_ID = @INSTANCE_ID
				) R
				ON		1=1
				AND		A.COMPANY_ID		= R.COMPANY_ID
				AND		A.DIVISION_ID		= R.DIVISION_ID
				AND		A.SITE_ID			= R.SITE_ID
				AND		A.PLANT_ID			= R.PLANT_ID
				AND		A.FACTORY_ID		= R.FACTORY_ID
				AND		A.OPERATION_ID		= R.OPERATION_ID
				AND		A.LINE_ID			= R.LINE_ID