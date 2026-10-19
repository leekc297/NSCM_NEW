WITH MAIN AS (
          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
               , A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID
               , SUM(ISNULL(CASE WHEN B.ITEM_UOM = 'M' THEN A.CARRY_OVER_QTY_M ELSE A.CARRY_OVER_QTY_CELL END,0))*(-1) AS QTY
          FROM   @AMEND_SALES_TABLE A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK)
          WHERE  A.COMPANY_ID  = B.COMPANY_ID
          AND    A.DIVISION_ID = B.DIVISION_ID
          AND    A.SITE_ID     = B.SITE_ID
          AND    A.ITEM_ID     = B.ITEM_ID
          AND    A.INSTANCE_ID = @MASTER_ID
          AND    A.FP_PLAN_ID  = @PLAN_ID
          @CTRL_PRODUCTION_TYPE
          @CTRL_PRODTYPE_LT
                    AND    EXISTS (
			              SELECT 1
			              FROM (
					                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
					                       , A.LOCATION, A.OPERATION_ID
					                       , A.LINE_ID, '' AS LINE_NAME, A.ELECTRODE_TYPE
					                       , A.EQUIPMENT_ID
					                       , A.PLAN_DATE
					                       , A.TOP_ITEM_ID, A.ITEM_ID, '' AS NICK_NAME
					                       , A.PRODUCTION_TYPE
					                       , A.MARKET
					                       , A.ADJUST_OUT_QTY_KG AS P_QTY
					                       , 0 AS S_QTY
					                  FROM   @AMEND_TABLE A WITH(NOLOCK)
					                  WHERE  INSTANCE_ID      = @MASTER_ID
					                  AND    FP_PLAN_ID       = @PLAN_ID
					                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >= @PLAN_DATE
					                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN @BUCKET_FROM AND @BUCKET_TO
					                  
					                  @CTRL_DIVISION_LT
					                  @CTRL_SITE_LT
					                  @CTRL_PLANT_LT
					                  @CTRL_FACTORY_LT
                             AND    A.OPERATION_ID = @OPERATION_ID
					                  @CTRL_LINE_LT
					                  @CTRL_ITEM_LK
					                  AND 	 A.ADJUST_IN_QTY_BATCH > 0
					                  UNION ALL
					                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
					                       , A.LOCATION, A.OPERATION_ID
					                       , A.LINE_ID, '' AS LINE_NAME, A.ELECTRODE_TYPE
					                       , A.EQUIPMENT_ID
					                       , A.PLAN_DATE
					                       , A.TOP_ITEM_ID, A.ITEM_ID, '' AS NICK_NAME
					                       , A.PRODUCTION_TYPE
					                       , A.MARKET
					                       , 0 AS P_QTY
					                       , A.SALES_QTY_KG AS S_QTY
					                  FROM   @AMEND_SALES_TABLE A WITH(NOLOCK)
					                  WHERE  INSTANCE_ID      = @MASTER_ID
					                  AND    FP_PLAN_ID       = @PLAN_ID
					                  AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN @BUCKET_FROM AND @BUCKET_TO
					                  @CTRL_DIVISION_LT
					                  @CTRL_SITE_LT
					                  @CTRL_PLANT_LT
					                  @CTRL_FACTORY_LT
                            AND    A.OPERATION_ID = @OPERATION_ID
					                  @CTRL_LINE_LT
					                  @CTRL_ITEM_LK
					                  
			              ) AA
			              WHERE A.COMPANY_ID    = AA.COMPANY_ID
			              AND   A.DIVISION_ID   = AA.DIVISION_ID
			              AND   A.SITE_ID       = AA.SITE_ID
			              AND   A.PLANT_ID      = AA.PLANT_ID
			              AND   A.OPERATION_ID  = AA.OPERATION_ID
			              AND   A.ITEM_ID       = AA.ITEM_ID
			              AND   A.TOP_ITEM_ID   = AA.TOP_ITEM_ID
			              AND   AA.PLAN_DATE BETWEEN @BUCKET_FROM AND @BUCKET_TO
          		)
          		@CTRL_NICKNAME_LT
          		@CTRL_ITEMNAME_LK
          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                 , A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID
      )
      -- SUB TOTAL
      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
           , A.OPERATION_ID, A.ITEM_ID, A.TOP_ITEM_ID
           , SUM(A.QTY) AS QTY
           , 'SUB_TOTAL' AS _TYPE
      FROM   MAIN A
      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID, A.TOP_ITEM_ID
      UNION ALL
      --- TOTAL
      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID
           , NULL AS OPERATION_ID, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID
           , SUM(A.QTY) AS QTY
           , 'TOTAL' AS _TYPE
      FROM   MAIN A