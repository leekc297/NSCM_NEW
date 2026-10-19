BEGIN
        BEGIN TRAN
          MERGE INTO FP_AMEND_PLAN_CELL_R A
          USING (SELECT UPPER(@INSTANCE_ID) AS INSTANCE_ID, UPPER(@FP_PLAN_ID) AS FP_PLAN_ID,
                        UPPER(@DIVISION_ID) AS DIVISION_ID, 'PLAN' AS CATEGORY_ID, UPPER(@SITE_ID) AS SITE_ID,
                        UPPER(@PLANT_ID) AS PLANT_ID, UPPER(@TOP_ITEM_ID) AS TOP_ITEM_ID, UPPER(@ITEM_ID) AS ITEM_ID, UPPER(@OPERATION_ID) AS OPERATION_ID,
                        UPPER(@PRODUCTION_TYPE) AS PRODUCTION_TYPE, UPPER(@MARKET) AS MARKET,
                        UPPER(@FACTORY_ID) AS FACTORY_ID, UPPER(@LINE_ID) AS LINE_ID, @ELECTRODE_TYPE AS ELECTRODE_TYPE,
                        @PLAN_DATE AS PLAN_DATE, UPPER(@LOCATION) AS LOCATION, (case when UPPER(@PLM_EC_NO) is null or UPPER(@PLM_EC_NO) = '' then '-' else UPPER(@PLM_EC_NO) end) AS PLM_EC_NO, UPPER(@VERSION) AS VERSION ) B
          ON (    A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID
              AND A.DIVISION_ID = B.DIVISION_ID AND A.CATEGORY_ID = B.CATEGORY_ID AND A.SITE_ID = B.SITE_ID
              AND A.PLANT_ID = B.PLANT_ID AND A.TOP_ITEM_ID = B.TOP_ITEM_ID
              AND A.ITEM_ID = B.ITEM_ID AND A.OPERATION_ID = B.OPERATION_ID
              AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET
              AND A.FACTORY_ID = B.FACTORY_ID AND A.LINE_ID = B.LINE_ID AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
              AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE AND A.LOCATION = B.LOCATION AND A.PLM_EC_NO = B.PLM_EC_NO AND A.VERSION = B.VERSION )
          WHEN MATCHED THEN
            UPDATE SET IN_QTY  = CEILING(FLOOR(@OUT_QTY * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))
                                      				/(SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD
                                      					FROM   SCM_YIELD_M YYY WITH(NOLOCK)
                                      					LEFT OUTER JOIN (
                                      						SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
                                      						FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
                                      						WHERE  EE.DIVISION_ID  = B.DIVISION_ID
                                      						AND    EE.SITE_ID      = B.SITE_ID
                                      						AND    EE.PLANT_ID     = B.PLANT_ID
                                      						AND    EE.FACTORY_ID   = B.FACTORY_ID
                                      						AND    EE.OPERATION_ID = B.OPERATION_ID
                                      						AND    EE.LINE_ID      = B.LINE_ID
                                      						AND    EE.ITEM_ID      = B.ITEM_ID
                                      						AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME
                                      					) EEE
                                      					ON     1=1
                                      					WHERE  YYY.DIVISION_ID  = B.DIVISION_ID
                                      					AND    YYY.SITE_ID      = B.SITE_ID
                                      					AND    YYY.PLANT_ID     = B.PLANT_ID
                                      					AND    YYY.FACTORY_ID   = B.FACTORY_ID
                                      					AND    YYY.OPERATION_ID = B.OPERATION_ID
                                      					AND    YYY.LINE_ID      = B.LINE_ID
                                      					AND    YYY.ITEM_ID      = B.ITEM_ID
                                      					AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))
                     , OUT_QTY = FLOOR(@OUT_QTY * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))
                     , CELL_IN_QTY  = CEILING(@OUT_QTY / ( SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD
                                                            FROM   SCM_YIELD_M YYY WITH(NOLOCK)
                                                            LEFT OUTER JOIN (
                                                                SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
                                                                FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
                                                                WHERE  EE.DIVISION_ID  = B.DIVISION_ID
                                                                AND    EE.SITE_ID      = B.SITE_ID
                                                                AND    EE.PLANT_ID     = B.PLANT_ID
                                                                AND    EE.FACTORY_ID   = B.FACTORY_ID
                                                                AND    EE.OPERATION_ID = B.OPERATION_ID
                                                                AND    EE.LINE_ID      = B.LINE_ID
                                                                AND    EE.ITEM_ID      = B.ITEM_ID
                                                                AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME
                                                            ) EEE
                                                            ON     1=1
                                                            WHERE  YYY.DIVISION_ID  = B.DIVISION_ID
                                                            AND    YYY.SITE_ID      = B.SITE_ID
                                                            AND    YYY.PLANT_ID     = B.PLANT_ID
                                                            AND    YYY.FACTORY_ID   = B.FACTORY_ID
                                                            AND    YYY.OPERATION_ID = B.OPERATION_ID
                                                            AND    YYY.LINE_ID      = B.LINE_ID
                                                            AND    YYY.ITEM_ID      = B.ITEM_ID
                                                            AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))
                		 , CELL_OUT_QTY = @OUT_QTY
                     , UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(@SITE_ID)
                     , PRODUCTION_TYPE = B.PRODUCTION_TYPE
          WHEN NOT MATCHED THEN
            INSERT (
               INSTANCE_ID, FP_PLAN_ID
              ,COMPANY_ID
              ,DIVISION_ID
              ,CATEGORY_ID
              ,SITE_ID, PLANT_ID
              ,ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION
              ,PRODUCTION_TYPE, MARKET
              ,LINE_ID, ELECTRODE_TYPE
              ,PLAN_DATE
              ,TOP_ITEM_ID, ITEM_TYPE
              ,IN_QTY
              ,OUT_QTY
              ,CELL_IN_QTY
              ,CELL_OUT_QTY
              ,DATE_SEQ
              ,INSERT_ID, INSERT_TIME
              ,UPDATE_ID, UPDATE_TIME
              ,PLM_EC_NO
              ,VERSION
            )
            VALUES (
               UPPER(@INSTANCE_ID), UPPER(@FP_PLAN_ID)
              ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = @DIVISION_ID AND SITE_ID = @SITE_ID AND PLANT_ID = @PLANT_ID AND ACTIVE_FLAG = 'Y')
              ,UPPER(@DIVISION_ID)
              ,'PLAN'
              ,UPPER(@SITE_ID), UPPER(@PLANT_ID)
              ,UPPER(@ITEM_ID), UPPER(@OPERATION_ID), UPPER(@FACTORY_ID), UPPER(@LOCATION)
              ,UPPER(@PRODUCTION_TYPE), UPPER(@MARKET)
              ,UPPER(@LINE_ID), @ELECTRODE_TYPE
              ,CONVERT(DATE,@PLAN_DATE)
              ,UPPER(@TOP_ITEM_ID), UPPER(@ITEM_TYPE)
              ,CEILING(FLOOR(@OUT_QTY * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))
                    				/ (SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD
                    					FROM   SCM_YIELD_M YYY WITH(NOLOCK)
                    					LEFT OUTER JOIN (
                    						SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
                    						FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
                    						WHERE  EE.DIVISION_ID  = B.DIVISION_ID
                    						AND    EE.SITE_ID      = B.SITE_ID
                    						AND    EE.PLANT_ID     = B.PLANT_ID
                    						AND    EE.FACTORY_ID   = B.FACTORY_ID
                    						AND    EE.OPERATION_ID = B.OPERATION_ID
                    						AND    EE.LINE_ID      = B.LINE_ID
                    						AND    EE.ITEM_ID      = B.ITEM_ID
                    						AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME
                    					) EEE
                    					ON     1=1
                    					WHERE  YYY.DIVISION_ID  = B.DIVISION_ID
                    					AND    YYY.SITE_ID      = B.SITE_ID
                    					AND    YYY.PLANT_ID     = B.PLANT_ID
                    					AND    YYY.FACTORY_ID   = B.FACTORY_ID
                    					AND    YYY.OPERATION_ID = B.OPERATION_ID
                    					AND    YYY.LINE_ID      = B.LINE_ID
                    					AND    YYY.ITEM_ID      = B.ITEM_ID
                    					AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)) )
              ,FLOOR(@OUT_QTY * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))
              ,CEILING(@OUT_QTY / (  SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD
                                      FROM   SCM_YIELD_M YYY WITH(NOLOCK)
                                      LEFT OUTER JOIN (
                                          SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
                                          FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
                                          WHERE  EE.DIVISION_ID  = B.DIVISION_ID
                                          AND    EE.SITE_ID      = B.SITE_ID
                                          AND    EE.PLANT_ID     = B.PLANT_ID
                                          AND    EE.FACTORY_ID   = B.FACTORY_ID
                                          AND    EE.OPERATION_ID = B.OPERATION_ID
                                          AND    EE.LINE_ID      = B.LINE_ID
                                          AND    EE.ITEM_ID      = B.ITEM_ID
                                          AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME
                                      ) EEE
                                      ON     1=1
                                      WHERE  YYY.DIVISION_ID  = B.DIVISION_ID
                                      AND    YYY.SITE_ID      = B.SITE_ID
                                      AND    YYY.PLANT_ID     = B.PLANT_ID
                                      AND    YYY.FACTORY_ID   = B.FACTORY_ID
                                      AND    YYY.OPERATION_ID = B.OPERATION_ID
                                      AND    YYY.LINE_ID      = B.LINE_ID
                                      AND    YYY.ITEM_ID      = B.ITEM_ID
                                      AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))
              ,@OUT_QTY
              ,1
              ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
              ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
              ,B.PLM_EC_NO
              ,B.VERSION
            )
          ;
        
        COMMIT;
        
        BEGIN TRAN
            INSERT INTO HIS_AMEND_PLAN_CELL_R (
                   INSTANCE_ID, FP_PLAN_ID
                  ,COMPANY_ID, DIVISION_ID
                  ,CATEGORY_ID
                  ,SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, ITEM_TYPE
                  ,LOCATION, PRODUCTION_TYPE, MARKET
                  ,LINE_ID, ELECTRODE_TYPE
                  ,PLAN_DATE
                  ,IN_QTY, OUT_QTY
                  ,CELL_IN_QTY, CELL_OUT_QTY
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                  ,PLM_EC_NO
                  ,VERSION
            )
            SELECT INSTANCE_ID, FP_PLAN_ID
                  ,COMPANY_ID, DIVISION_ID
                  ,CATEGORY_ID
                  ,SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, ISNULL(ITEM_TYPE,'-') AS ITEM_TYPE
                  ,LOCATION, PRODUCTION_TYPE, MARKET
                  ,LINE_ID, ELECTRODE_TYPE
                  ,PLAN_DATE
                  ,IN_QTY, OUT_QTY
                  ,CELL_IN_QTY, CELL_OUT_QTY
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                  ,PLM_EC_NO
                  ,VERSION
            FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)
            WHERE  A.INSTANCE_ID      = @INSTANCE_ID
            AND    A.FP_PLAN_ID       = @FP_PLAN_ID
            AND    A.DIVISION_ID      = @DIVISION_ID
            AND    A.CATEGORY_ID      = 'PLAN'
            AND    A.SITE_ID          = @SITE_ID
            AND    A.PLANT_ID         = @PLANT_ID
            AND    A.TOP_ITEM_ID      = @TOP_ITEM_ID
            AND    A.ITEM_ID          = @ITEM_ID
            AND    A.OPERATION_ID     = @OPERATION_ID
            AND    A.FACTORY_ID       = @FACTORY_ID
            AND    A.LOCATION         = @LOCATION
            AND    A.PRODUCTION_TYPE  = @PRODUCTION_TYPE
            AND    A.MARKET           = @MARKET
            AND    A.LINE_ID          = @LINE_ID
            AND    A.ELECTRODE_TYPE   = @ELECTRODE_TYPE
            AND    A.PLAN_DATE        = CONVERT(DATE,@PLAN_DATE)
            AND    A.PLM_EC_NO        = (case when UPPER(@PLM_EC_NO) is null or UPPER(@PLM_EC_NO) = '' then '-' else UPPER(@PLM_EC_NO) end)
            AND    A.VERSION          = @VERSION
            ;
          
        COMMIT;
        
      END;