INSERT INTO FP_AMEND_PLAN_CELL_H (
			         INSTANCE_ID, FP_PLAN_ID
			        ,COMPANY_ID, DIVISION_ID
			        ,CATEGORY_ID
			        ,SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID
			        ,LOCATION, PRODUCTION_TYPE, MARKET
			        ,LINE_ID, ELECTRODE_TYPE
			        ,PLAN_DATE
			        ,TOP_ITEM_ID, ITEM_TYPE
			        ,@IN_QTY
			        ,@OUT_QTY
			        ,@CELL_IN_QTY
			        ,@CELL_OUT_QTY
			        ,DATE_SEQ
			        ,INSERT_ID, INSERT_TIME
			        ,UPDATE_ID, UPDATE_TIME
			      )
			      VALUES (
			         UPPER(@INSTANCE_ID), UPPER(@FP_PLAN_ID)
			        ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = @DIVISION_ID AND SITE_ID = @SITE_ID AND PLANT_ID = @PLANT_ID AND ACTIVE_FLAG = 'Y'), @DIVISION_ID
			        ,'PLAN'
			        ,UPPER(@SITE_ID), UPPER(@PLANT_ID), UPPER(@ITEM_ID), UPPER(@OPERATION_ID), UPPER(@FACTORY_ID)
			        ,UPPER(@LOCATION), UPPER(@PRODUCTION_TYPE), UPPER(@MARKET)
			        ,UPPER(@LINE_ID), @ELECTRODE_TYPE
			        ,CONVERT(DATE,@DATE)
			        ,UPPER(@TOP_ITEM_ID), UPPER(@ITEM_TYPE)
			        ,CEILING(FLOOR(@QTY * dbo.FN_GET_REQ_QTY_MODEL(@PLANT_ID, @TOP_ITEM_ID, @ITEM_ID, @DATE) )
			        				/ (SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD
			        					FROM   SCM_YIELD_M A WITH(NOLOCK)
			        					LEFT OUTER JOIN (
			        						SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
			        						FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)
			        						WHERE  A.DIVISION_ID  = @DIVISION_ID
			        						AND    A.SITE_ID      = @SITE_ID
			        						AND    A.PLANT_ID     = @PLANT_ID
			        						AND    A.FACTORY_ID   = @FACTORY_ID
			        						AND    A.OPERATION_ID = @OPERATION_ID
			        						AND    A.LINE_ID      = @LINE_ID
			        						AND    A.ITEM_ID      = @ITEM_ID
			        						AND    CONVERT(DATE,@DATE) BETWEEN A.START_TIME AND A.END_TIME
			        					) B
			        					ON     1=1
			        					WHERE  A.DIVISION_ID  = @DIVISION_ID
			        					AND    A.SITE_ID      = @SITE_ID
			        					AND    A.PLANT_ID     = @PLANT_ID
			        					AND    A.FACTORY_ID   = @FACTORY_ID
			        					AND    A.OPERATION_ID = @OPERATION_ID
			        					AND    A.LINE_ID      = @LINE_ID
			        					AND    A.ITEM_ID      = @ITEM_ID
			        					AND    A.MONTH        = SUBSTRING(@DATE,1,6)) )
			        ,FLOOR(@QTY * dbo.FN_GET_REQ_QTY_MODEL(@PLANT_ID, @TOP_ITEM_ID, @ITEM_ID, @DATE) )
			        ,CEILING(@QTY / (SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD
			                          FROM   SCM_YIELD_M A WITH(NOLOCK)
			                          LEFT OUTER JOIN (
			                              SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
			                              FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)
			                              WHERE  A.DIVISION_ID  = @DIVISION_ID
			                              AND    A.SITE_ID      = @SITE_ID
			                              AND    A.PLANT_ID     = @PLANT_ID
			                              AND    A.FACTORY_ID   = @FACTORY_ID
			                              AND    A.OPERATION_ID = @OPERATION_ID
			                              AND    A.LINE_ID      = @LINE_ID
			                              AND    A.ITEM_ID      = @ITEM_ID
			                              AND    CONVERT(DATE,@DATE) BETWEEN A.START_TIME AND A.END_TIME
			                          ) B
			                          ON     1=1
			                          WHERE  A.DIVISION_ID  = @DIVISION_ID
			                          AND    A.SITE_ID      = @SITE_ID
			                          AND    A.PLANT_ID     = @PLANT_ID
			                          AND    A.FACTORY_ID   = @FACTORY_ID
			                          AND    A.OPERATION_ID = @OPERATION_ID
			                          AND    A.LINE_ID      = @LINE_ID
			                          AND    A.ITEM_ID      = @ITEM_ID
			                          AND    A.MONTH        = SUBSTRING(@DATE,1,6)))
			        ,@QTY
			        ,1
			        ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
			        ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
			      )