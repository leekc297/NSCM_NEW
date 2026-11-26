MERGE INTO FP_AMEND_PLAN_CELL_R A
        USING (
        	SELECT UPPER(@INSTANCE_ID) AS INSTANCE_ID, UPPER(@FP_PLAN_ID) AS FP_PLAN_ID
        	     , (SELECT MAX(COMPANY_ID) FROM SCM_FACTORY_M WHERE DIVISION_ID = @DIVISION_ID AND SITE_ID = @SITE_ID AND PLANT_ID = @PLANT_ID AND ACTIVE_FLAG = 'Y') AS COMPANY_ID, @DIVISION_ID AS DIVISION_ID
        	     , 'PLAN' AS CATEGORY_ID
        	     , UPPER(@SITE_ID) AS SITE_ID, UPPER(@PLANT_ID) AS PLANT_ID, UPPER(@ITEM_ID) AS ITEM_ID, UPPER(@OPERATION_ID) AS OPERATION_ID, UPPER(@FACTORY_ID) AS FACTORY_ID
        		 , UPPER(@LOCATION) AS LOCATION, UPPER(@PRODUCTION_TYPE) AS PRODUCTION_TYPE, UPPER(@MARKET) AS MARKET
        		 , UPPER(@LINE_ID) AS LINE_ID, @ELECTRODE_TYPE AS ELECTRODE_TYPE
        		 , CONVERT(DATE,@DATE) AS PLAN_DATE
        		 , UPPER(@TOP_ITEM_ID) AS TOP_ITEM_ID, UPPER(@ITEM_TYPE) AS ITEM_TYPE
        		 , UPPER(@PLM_EC_NO) AS PLM_EC_NO, UPPER(@VERSION) AS VERSION
        		 , CEILING(FLOOR(@QTY * ISNULL(dbo.FN_GET_REQ_QTY_MODEL(@PLANT_ID, @TOP_ITEM_ID, @ITEM_ID, @DATE),1))
                      				/ (SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD
                      					FROM   SCM_YIELD_M YYY WITH(NOLOCK)
                      					LEFT OUTER JOIN (
                      						SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
                      						FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
                      						WHERE  EE.DIVISION_ID  = @DIVISION_ID
                      						AND    EE.SITE_ID      = @SITE_ID
                      						AND    EE.PLANT_ID     = @PLANT_ID
                      						AND    EE.FACTORY_ID   = @FACTORY_ID
                      						AND    EE.OPERATION_ID = @OPERATION_ID
                      						AND    EE.LINE_ID      = @LINE_ID
                      						AND    EE.ITEM_ID      = @ITEM_ID
                      						AND    CONVERT(DATE,@DATE) BETWEEN EE.START_TIME AND EE.END_TIME
                      					) EEE
                      					ON     1=1
                      					WHERE  YYY.DIVISION_ID  = @DIVISION_ID
                      					AND    YYY.SITE_ID      = @SITE_ID
                      					AND    YYY.PLANT_ID     = @PLANT_ID
                      					AND    YYY.FACTORY_ID   = @FACTORY_ID
                      					AND    YYY.OPERATION_ID = @OPERATION_ID
                      					AND    YYY.LINE_ID      = @LINE_ID
                      					AND    YYY.ITEM_ID      = @ITEM_ID
                      					AND    YYY.MONTH        = SUBSTRING(@DATE,1,6))) AS IN_QTY
        		 , FLOOR(@QTY * ISNULL(dbo.FN_GET_REQ_QTY_MODEL(@PLANT_ID, @TOP_ITEM_ID, @ITEM_ID, @DATE),1)) AS OUT_QTY
        		 , CEILING(@QTY / (  SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD
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
                                    AND    A.MONTH        = SUBSTRING(@DATE,1,6))) AS CELL_IN_QTY
        		 , @QTY AS CELL_OUT_QTY
        		 , 1 AS DATE_SEQ
        		 , @USER_ID AS INSERT_ID, dbo.FN_SITE_TIME(@SITE_ID) AS INSERT_TIME
        		 , @USER_ID AS UPDATE_ID, dbo.FN_SITE_TIME(@SITE_ID) AS UPDATE_TIME
        ) AS B
        ON  A.INSTANCE_ID     = B.INSTANCE_ID
        AND A.FP_PLAN_ID      = B.FP_PLAN_ID
        AND A.COMPANY_ID      = B.COMPANY_ID
        AND A.DIVISION_ID     = B.DIVISION_ID
        AND A.CATEGORY_ID     = B.CATEGORY_ID
        AND A.SITE_ID         = B.SITE_ID
        AND A.PLANT_ID        = B.PLANT_ID
        AND A.ITEM_ID         = B.ITEM_ID
        AND A.OPERATION_ID    = B.OPERATION_ID
        AND A.FACTORY_ID      = B.FACTORY_ID
        AND A.LOCATION        = B.LOCATION
        AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
        AND A.MARKET          = B.MARKET
        AND A.LINE_ID         = B.LINE_ID
        AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE
        AND A.PLAN_DATE       = B.PLAN_DATE
        AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID
        AND A.PLM_EC_NO       = B.PLM_EC_NO
        AND A.VERSION         = B.VERSION
        WHEN MATCHED THEN
            UPDATE SET
        		  IN_QTY       = B.IN_QTY
        		, OUT_QTY      = B.OUT_QTY
        		, CELL_IN_QTY  = B.CELL_IN_QTY
        		, CELL_OUT_QTY = B.CELL_OUT_QTY
        		, DATE_SEQ = CASE WHEN CONVERT(NUMERIC(25,10),ISNULL(B.OUT_QTY,0)) = 0 THEN 0 ELSE B.DATE_SEQ END
        		, UPDATE_ID = B.UPDATE_ID, UPDATE_TIME = B.UPDATE_TIME
        		, PRODUCTION_TYPE = B.PRODUCTION_TYPE
        
        WHEN NOT MATCHED BY TARGET THEN
        	INSERT (
        		  INSTANCE_ID, FP_PLAN_ID
        		, COMPANY_ID, DIVISION_ID
        		, CATEGORY_ID
        		, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID
        		, LOCATION, PRODUCTION_TYPE, MARKET
        		, LINE_ID, ELECTRODE_TYPE
        		, PLAN_DATE
        		, TOP_ITEM_ID, ITEM_TYPE
        		, IN_QTY
        		, OUT_QTY
        		, CELL_IN_QTY
        		, CELL_OUT_QTY
        		, DATE_SEQ
        		, PLM_EC_NO
        		, VERSION
        		, INSERT_ID, INSERT_TIME
        		, UPDATE_ID, UPDATE_TIME
        	)
        	VALUES (
        		  B.INSTANCE_ID, B.FP_PLAN_ID
        		, B.COMPANY_ID, B.DIVISION_ID
        		, B.CATEGORY_ID
        		, B.SITE_ID, B.PLANT_ID, B.ITEM_ID, B.OPERATION_ID, B.FACTORY_ID
        		, B.LOCATION, B.PRODUCTION_TYPE, B.MARKET
        		, B.LINE_ID, B.ELECTRODE_TYPE
        		, B.PLAN_DATE
        		, B.TOP_ITEM_ID, B.ITEM_TYPE
        		, B.IN_QTY
        		, B.OUT_QTY
        		, B.CELL_IN_QTY
        		, B.CELL_OUT_QTY
        		, B.DATE_SEQ
        		, B.PLM_EC_NO
        		, B.VERSION
        		, B.INSERT_ID, B.INSERT_TIME
        		, B.UPDATE_ID, B.UPDATE_TIME
        	)
        ;