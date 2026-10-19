UPDATE FP_MPP_WPP_BASE_PLAN_M
      SET    FP_MPP_WPP_BASE_PLAN_M.ROLL_QTY  = B.ROLL_OUT_QTY
           , FP_MPP_WPP_BASE_PLAN_M.JR_QTY    = B.JR_OUT_QTY
           , FP_MPP_WPP_BASE_PLAN_M.CELL_QTY  = B.CELL_OUT_QTY
           , FP_MPP_WPP_BASE_PLAN_M.BATCH_QTY = B.BATCH_IN_QTY
  	  FROM   FP_MPP_WPP_BASE_PLAN_M A WITH(NOLOCK)
  	  INNER JOIN (
      	  SELECT A.COMPANY_ID
      				 , A.DIVISION_ID
      				 , A.SITE_ID
      				 , A.PLANT_ID
      				 , A.FACTORY_ID
      				 , A.TOP_ITEM_ID
      				 , A.ITEM_ID
      				 , A.OPERATION_ID
      				 , A.PRODUCTION_TYPE
      				 , A.MARKET
      				 , A.LINE_ID
      				 , A.PLAN_DATE
      				 , A.PLAN_QTY
      				 , A.EQUIPMENT_ID
      				 , CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M ELSE A.PLAN_QTY END END AS ROLL_OUT_QTY
      				 , CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M / A.LANE ELSE A.PLAN_QTY /A.LANE END END AS JR_OUT_QTY
      				 , CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_BATCH ELSE A.PLAN_QTY / A.M_BATCH END / ISNULL(A.YIELD, 1) END AS BATCH_IN_QTY
      				 , CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY ELSE A.PLAN_QTY * A.CELL_M END
      					      WHEN A.OPERATION_ID LIKE 'A%' AND A.CELL_REQ_QTY > 0 THEN  A.PLAN_QTY / A.CELL_REQ_QTY END AS CELL_OUT_QTY
      		 FROM (
      					SELECT A.COMPANY_ID
      						   , A.DIVISION_ID
      						   , A.SITE_ID
      						   , A.PLANT_ID
      						   , A.FACTORY_ID
      						   , ISNULL(SI.APPLIED_MODEL, A.ITEM_ID) AS TOP_ITEM_ID
      						   , A.ITEM_ID
      						   , A.OPERATION_ID
      						   , A.PRODUCTION_TYPE
      						   , A.MARKET
      						   , A.LINE_ID
      						   , SI.ITEM_UOM
      						   , A.PLAN_DATE
      						   , A.PLAN_QTY
      						   , A.EQUIPMENT_ID
      					  ,CASE WHEN A.OPERATION_ID = 'E2000' THEN
      					   ISNULL(
          						 (
              							SELECT TOP 1 VALUE AS LANE
              							FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
              							WHERE  C.MAX_VER_FLAG = 'Y'
              							AND    ISNULL(C.VALUE, 0) > 0
              							AND    C.CATEGORY     = 'Lane Number'
              							AND    C.COMPANY_ID   = A.COMPANY_ID
              							AND    C.DIVISION_ID  = A.DIVISION_ID
              							AND    C.SITE_ID      = A.SITE_ID
              							AND    C.PLANT_ID     = A.PLANT_ID
              							AND    C.FACTORY_ID   = A.FACTORY_ID
              							AND    C.OPERATION    = A.OPERATION_ID
              							AND    C.ITEM_ID      = A.ITEM_ID
              							AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
              							ORDER BY CASE WHEN PRODUCTION_TYPE LIKE '%TEST' THEN 
              								CASE WHEN VERSION_TYPE = 'TEST' THEN 1 ELSE 2 END
              								ELSE
              								CASE WHEN VERSION_TYPE = 'TEST' THEN 2 ELSE 1 END
              								END
              								,(CASE WHEN C.MODEL_ID   = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
              								,C.MODEL_ID
              								,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
          						 )
          						 ,(
              						  SELECT TOP 1 VALUE AS LANE
              						  FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
              						  WHERE  C.MAX_VER_FLAG = 'Y'
              						  AND    ISNULL(C.VALUE, 0) > 0
              						  AND    C.CATEGORY     = 'Lane Number'
              						  AND    C.COMPANY_ID   = A.COMPANY_ID
              						  AND    C.DIVISION_ID  = A.DIVISION_ID
              						  AND    C.SITE_ID      = A.SITE_ID
              						  AND    C.PLANT_ID     = A.PLANT_ID
              						  AND    C.FACTORY_ID   = A.FACTORY_ID
              						  AND    C.OPERATION    = A.OPERATION_ID
              						  AND    C.ITEM_ID      = A.ITEM_ID
              						  AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
              						  ORDER BY VALUE
          						 )
      					   )
      					 END AS LANE
      				   ,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'M' THEN
      				   ISNULL(
          					   (
            					  SELECT TOP 1 VALUE AS M_BATCH
            					  FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
            					  WHERE  C.MAX_VER_FLAG = 'Y'
            					  AND    ISNULL(C.VALUE, 0) > 0
            					  AND    C.CATEGORY     = 'Pancake (m/batch)'
            					  AND    C.COMPANY_ID   = A.COMPANY_ID
            					  AND    C.DIVISION_ID  = A.DIVISION_ID
            					  AND    C.SITE_ID      = A.SITE_ID
            					  AND    C.PLANT_ID     = A.PLANT_ID
            					  AND    C.FACTORY_ID   = A.FACTORY_ID
            					  AND    C.OPERATION    = A.OPERATION_ID
            					  AND    C.ITEM_ID      = A.ITEM_ID
            					  AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
            					  ORDER BY CASE WHEN PRODUCTION_TYPE LIKE '%TEST' THEN 
            						  CASE WHEN VERSION_TYPE = 'TEST' THEN 1 ELSE 2 END
            						   ELSE
            						  CASE WHEN VERSION_TYPE = 'TEST' THEN 2 ELSE 1 END
            						   END
            						 ,(CASE WHEN C.MODEL_ID   = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
            						 ,C.MODEL_ID
            						 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
          					 )
          					 ,(
            					  SELECT TOP 1 VALUE AS M_BATCH
            					  FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
            					  WHERE  C.MAX_VER_FLAG = 'Y'
            					  AND    ISNULL(C.VALUE, 0) > 0
            					  AND    C.CATEGORY     = 'Pancake (m/batch)'
            					  AND    C.COMPANY_ID   = A.COMPANY_ID
            					  AND    C.DIVISION_ID  = A.DIVISION_ID
            					  AND    C.SITE_ID      = A.SITE_ID
            					  AND    C.PLANT_ID     = A.PLANT_ID
            					  AND    C.FACTORY_ID   = A.FACTORY_ID
            					  AND    C.OPERATION    = A.OPERATION_ID
            					  AND    C.ITEM_ID      = A.ITEM_ID
            					  AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
            					  ORDER BY VALUE
          					 )
      				   )
      				  END  AS M_BATCH
      				 ,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'EA' THEN
      					ISNULL(
          					 (
              					 SELECT TOP 1 VALUE AS CELL_BATCH
              					 FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
              					 WHERE  C.MAX_VER_FLAG = 'Y'
              					 AND    ISNULL(C.VALUE, 0) > 0
              					 AND    C.CATEGORY     = 'cell/batch'
              					 AND    C.COMPANY_ID   = A.COMPANY_ID
              					 AND    C.DIVISION_ID  = A.DIVISION_ID
              					 AND    C.SITE_ID      = A.SITE_ID
              					 AND    C.PLANT_ID     = A.PLANT_ID
              					 AND    C.FACTORY_ID   = A.FACTORY_ID
              					 AND    C.OPERATION    = A.OPERATION_ID
              					 AND    C.ITEM_ID      = A.ITEM_ID
              					 AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
              					 ORDER BY CASE WHEN PRODUCTION_TYPE LIKE '%TEST' THEN 
              						 CASE WHEN VERSION_TYPE = 'TEST' THEN 1 ELSE 2 END
              						  ELSE
              						 CASE WHEN VERSION_TYPE = 'TEST' THEN 2 ELSE 1 END
              						  END
              						,(CASE WHEN C.MODEL_ID   = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
              						,C.MODEL_ID
              						,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
          					),(
              					 SELECT TOP 1 VALUE AS CELL_BATCH
              					 FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
              					 WHERE  C.MAX_VER_FLAG = 'Y'
              					 AND    ISNULL(C.VALUE, 0) > 0
              					 AND    C.CATEGORY     = 'cell/batch'
              					 AND    C.COMPANY_ID   = A.COMPANY_ID
              					 AND    C.DIVISION_ID  = A.DIVISION_ID
              					 AND    C.SITE_ID      = A.SITE_ID
              					 AND    C.PLANT_ID     = A.PLANT_ID
              					 AND    C.FACTORY_ID   = A.FACTORY_ID
              					 AND    C.OPERATION    = A.OPERATION_ID
              					 AND    C.ITEM_ID      = A.ITEM_ID
              					 AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
              					 ORDER BY VALUE
          					)
      				   )
      				  END  AS CELL_BATCH
      				 ,CASE WHEN A.OPERATION_ID = 'E2000' THEN
      					 ISNULL(
          					(
            					 SELECT TOP 1 VALUE AS CELL_M
            					 FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
            					 WHERE  C.MAX_VER_FLAG = 'Y'
            					 AND    ISNULL(C.VALUE, 0) > 0
            					 AND    C.CATEGORY     = 'Pancake (cell/m)'
            					 AND    C.COMPANY_ID   = A.COMPANY_ID
            					 AND    C.DIVISION_ID  = A.DIVISION_ID
            					 AND    C.SITE_ID      = A.SITE_ID
            					 AND    C.PLANT_ID     = A.PLANT_ID
            					 AND    C.FACTORY_ID   = A.FACTORY_ID
            					 AND    C.OPERATION    = A.OPERATION_ID
            					 AND    C.ITEM_ID      = A.ITEM_ID
            					 AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
            					 ORDER BY CASE WHEN PRODUCTION_TYPE LIKE '%TEST' THEN 
            						 CASE WHEN VERSION_TYPE = 'TEST' THEN 1 ELSE 2 END
            						  ELSE
            						 CASE WHEN VERSION_TYPE = 'TEST' THEN 2 ELSE 1 END
            						  END
            						,(CASE WHEN C.MODEL_ID   = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
            						,C.MODEL_ID
            						,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
          					),(
            					 SELECT TOP 1 VALUE AS CELL_M
            					 FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
            					 WHERE  C.MAX_VER_FLAG = 'Y'
            					 AND    ISNULL(C.VALUE, 0) > 0
            					 AND    C.CATEGORY     = 'Pancake (cell/m)'
            					 AND    C.COMPANY_ID   = A.COMPANY_ID
            					 AND    C.DIVISION_ID  = A.DIVISION_ID
            					 AND    C.SITE_ID      = A.SITE_ID
            					 AND    C.PLANT_ID     = A.PLANT_ID
            					 AND    C.FACTORY_ID   = A.FACTORY_ID
            					 AND    C.OPERATION    = A.OPERATION_ID
            					 AND    C.ITEM_ID      = A.ITEM_ID 
            					 AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
            					 ORDER BY VALUE
          					)
      				  )
      				 END  AS CELL_M
      				 ,( SELECT TOP 1 SY.YIELD
        				  FROM   SCM_YIELD_M  SY WITH(NOLOCK)
        				  WHERE  SY.[COMPANY_ID]   = A.[COMPANY_ID]
        				  AND    SY.[DIVISION_ID]  = A.[DIVISION_ID]
        				  AND    SY.[SITE_ID]      = A.[SITE_ID]
        				  AND    SY.[PLANT_ID]     = A.[PLANT_ID]
        				  AND    SY.[FACTORY_ID]   = A.[FACTORY_ID]
        				  AND    SY.[OPERATION_ID] = A.[OPERATION_ID]
        				  AND    SY.[LINE_ID]      = A.[LINE_ID]
        				  AND    SY.[ITEM_ID]      = A.[ITEM_ID]
        				  AND    SY.[MONTH]        = CONVERT(NVARCHAR(6), [dbo].[FN_SITE_TIME] (A.SITE_ID), 112)
        				  AND    SY.[YIELD]        > 0
        				  AND    SY.[YIELD]       <= 1 )  AS YIELD
      				 ,CASE WHEN A.OPERATION_ID LIKE 'A%' THEN
      				  (SELECT TOP 1 SUM(MCT.ACCUMULATED_CHILD_QTY)
      				   FROM   SCM_MODEL_COMP_TEMP MCT WITH(NOLOCK)
      				   WHERE  MCT.[COMPANY_ID]    = A.[COMPANY_ID]
      				   AND    MCT.[DIVISION_ID]   = A.[DIVISION_ID]
      				   AND    MCT.[SITE_ID]       = A.[SITE_ID]
      				   AND    MCT.[PLANT_ID]      = A.[PLANT_ID]
      				   AND    MCT.[CHILD_ITEM_ID] = A.[ITEM_ID]
      				   AND    EXISTS (SELECT TOP 1 1
              								  FROM SCM_ITEM_M  M WITH(NOLOCK)
              								  WHERE  M.COMPANY_ID  = MCT.COMPANY_ID
              								  AND    M.DIVISION_ID = MCT.DIVISION_ID
              								  AND    M.SITE_ID     = MCT.SITE_ID
              								  AND    M.ITEM_ID     = MCT.MODEL_ID
              								  AND    M.FLOW_ID LIKE 'A%')
      					GROUP  BY [MODEL_ID]
      					ORDER  BY CASE WHEN MCT.MODEL_ID = SI.APPLIED_MODEL THEN 1 ELSE 2 END,
      					1 DESC )
      					END  AS CELL_REQ_QTY
      				FROM   [dbo].[FP_MPP_WPP_BASE_PLAN_M] A WITH(NOLOCK)
      				LEFT OUTER JOIN [dbo].[SCM_LINE_M] L WITH(NOLOCK)
      				ON    L.OPERATION_ID   = 'E2000'
      				AND    L.ACTIVE_FLAG   = 'Y'
      				AND    A.COMPANY_ID    = L.COMPANY_ID
      				AND    A.DIVISION_ID   = L.DIVISION_ID
      				AND    A.SITE_ID       = L.SITE_ID
      				AND    A.PLANT_ID      = L.PLANT_ID
      				AND    A.FACTORY_ID    = L.FACTORY_ID
      				AND    A.OPERATION_ID  = L.OPERATION_ID
      				AND    A.LINE_ID       = L.LINE_ID
      				,[dbo].[SCM_ITEM_M] SI  WITH(NOLOCK)
      				WHERE  SI.COMPANY_ID   = A.COMPANY_ID
      				AND    SI.SITE_ID      = A.SITE_ID
      				AND    SI.DIVISION_ID  = A.DIVISION_ID
      				AND    SI.ITEM_ID      = A.ITEM_ID
      				AND    A.PLAN_WEEK     = @PLAN_WEEK
      				AND    A.PLAN_REVISION = @NEW_PLAN_REVISION
      		) A
  	  ) B
  	  ON    A.COMPANY_ID      = B.COMPANY_ID
  	  AND   A.DIVISION_ID     = B.DIVISION_ID
  	  AND   A.SITE_ID         = B.SITE_ID
  	  AND   A.PLANT_ID        = B.PLANT_ID
  	  AND   A.FACTORY_ID      = B.FACTORY_ID
  	  AND   A.OPERATION_ID    = B.OPERATION_ID
  	  AND   A.LINE_ID         = B.LINE_ID
  	  AND   A.EQUIPMENT_ID    = B.EQUIPMENT_ID
  	  AND   A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
  	  AND   A.MARKET          = B.MARKET
  	  AND   A.PLAN_DATE       = B.PLAN_DATE
  	  AND   A.ITEM_ID         = B.ITEM_ID
      WHERE A.PLAN_WEEK       = @PLAN_WEEK
      AND   A.PLAN_REVISION   = @NEW_PLAN_REVISION