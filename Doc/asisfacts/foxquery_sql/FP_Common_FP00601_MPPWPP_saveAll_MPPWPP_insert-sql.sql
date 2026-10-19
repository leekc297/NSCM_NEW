BEGIN
					        BEGIN TRAN
					          MERGE INTO FP_AMEND_PLAN_PACK_H A
					          USING (SELECT UPPER(@INSTANCE_ID) AS INSTANCE_ID, UPPER(@FP_PLAN_ID) AS FP_PLAN_ID,
					                        UPPER(@DIVISION_ID) AS DIVISION_ID, 'PLAN' AS CATEGORY_ID, UPPER(@SITE_ID) AS SITE_ID,
					                        UPPER(@PLANT_ID) AS PLANT_ID, UPPER(@TOP_ITEM_ID) AS TOP_ITEM_ID, UPPER(@ITEM_ID) AS ITEM_ID, UPPER(@OPERATION_ID) AS OPERATION_ID,
					                        UPPER(@PRODUCTION_TYPE) AS PRODUCTION_TYPE, UPPER(@MARKET) AS MARKET,
					                        UPPER(@FACTORY_ID) AS FACTORY_ID, UPPER(@LINE_ID) AS LINE_ID, '-' AS ELECTRODE_TYPE,
					                        @PLAN_DATE AS PLAN_DATE, UPPER(@LOCATION) AS LOCATION) B
					          ON (    A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID
					              AND A.DIVISION_ID = B.DIVISION_ID AND A.CATEGORY_ID = B.CATEGORY_ID AND A.SITE_ID = B.SITE_ID
					              AND A.PLANT_ID = B.PLANT_ID AND A.TOP_ITEM_ID = B.TOP_ITEM_ID
					              AND A.ITEM_ID = B.ITEM_ID AND A.OPERATION_ID = B.OPERATION_ID
					              AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET
					              AND A.FACTORY_ID = B.FACTORY_ID AND A.LINE_ID = B.LINE_ID AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
					              AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE AND A.LOCATION = B.LOCATION)
					          WHEN MATCHED THEN
					            UPDATE SET WPP_OUT_QTY = @WPP_OUT_QTY
					                		 , WPP_IN_QTY  = CEILING(@WPP_OUT_QTY / (SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD
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
					                                                                  AND    CONVERT(DATE,@PLAN_DATE) BETWEEN A.START_TIME AND A.END_TIME
					                                                              ) B
					                                                              ON     1=1
					                                                              WHERE  A.DIVISION_ID  = @DIVISION_ID
					                                                              AND    A.SITE_ID      = @SITE_ID
					                                                              AND    A.PLANT_ID     = @PLANT_ID
					                                                              AND    A.FACTORY_ID   = @FACTORY_ID
					                                                              AND    A.OPERATION_ID = @OPERATION_ID
					                                                              AND    A.LINE_ID      = @LINE_ID
					                                                              AND    A.ITEM_ID      = @ITEM_ID
					                                                              AND    A.MONTH        = SUBSTRING(@PLAN_DATE,1,6)))
					                     , WPP_CELL_OUT_QTY = FLOOR(@WPP_OUT_QTY / (SELECT MAX(CASE WHEN A.ACCUMULATED_CHILD_QTY IS NULL OR A.ACCUMULATED_CHILD_QTY = 0 THEN 1 ELSE A.ACCUMULATED_CHILD_QTY END)
					                                    														 FROM   FP_ITEM_CELL_EXCHANGE_M A WITH(NOLOCK)
												                                                                 WHERE  A.DIVISION_ID  = @DIVISION_ID
												                                                                 AND    A.SITE_ID      = @SITE_ID
												                                                                 AND    A.PLANT_ID     = @PLANT_ID
					                                    														 AND    A.MODEL_ID     = @TOP_ITEM_ID
					                                    														 AND    A.ITEM_ID      = @ITEM_ID) )
					          					 , WPP_CELL_IN_QTY = CEILING(FLOOR(@WPP_OUT_QTY / ( SELECT MAX(CASE WHEN A.ACCUMULATED_CHILD_QTY IS NULL OR A.ACCUMULATED_CHILD_QTY = 0 THEN 1 ELSE A.ACCUMULATED_CHILD_QTY END)
					                                            														 FROM   FP_ITEM_CELL_EXCHANGE_M A WITH(NOLOCK)
												                                                                         WHERE  A.DIVISION_ID  = @DIVISION_ID
												                                                                         AND    A.SITE_ID      = @SITE_ID
												                                                                         AND    A.PLANT_ID     = @PLANT_ID
					                                            														 AND    A.MODEL_ID     = @TOP_ITEM_ID
					                                            														 AND    A.ITEM_ID      = @ITEM_ID) )
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
					                        														AND    CONVERT(DATE,@PLAN_DATE) BETWEEN A.START_TIME AND A.END_TIME
					                        													) B
					                        													ON     1=1
					                        													WHERE  A.DIVISION_ID  = @DIVISION_ID
					                        													AND    A.SITE_ID      = @SITE_ID
					                        													AND    A.PLANT_ID     = @PLANT_ID
					                        													AND    A.FACTORY_ID   = @FACTORY_ID
					                        													AND    A.OPERATION_ID = @OPERATION_ID
					                        													AND    A.LINE_ID      = @LINE_ID
					                        													AND    A.ITEM_ID      = @ITEM_ID
					                        													AND    A.MONTH        = SUBSTRING(@PLAN_DATE,1,6)) )
					                     	, MPP_OUT_QTY = @MPP_OUT_QTY
					                		 , MPP_IN_QTY  = CEILING(@MPP_OUT_QTY / (SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD
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
					                                                                  AND    CONVERT(DATE,@PLAN_DATE) BETWEEN A.START_TIME AND A.END_TIME
					                                                              ) B
					                                                              ON     1=1
					                                                              WHERE  A.DIVISION_ID  = @DIVISION_ID
					                                                              AND    A.SITE_ID      = @SITE_ID
					                                                              AND    A.PLANT_ID     = @PLANT_ID
					                                                              AND    A.FACTORY_ID   = @FACTORY_ID
                                                              AND    A.OPERATION_ID = @OPERATION_ID
                                                              AND    A.LINE_ID      = @LINE_ID
                                                              AND    A.ITEM_ID      = @ITEM_ID
                                                              AND    A.MONTH        = SUBSTRING(@PLAN_DATE,1,6)))
                     , MPP_CELL_OUT_QTY = FLOOR(@MPP_OUT_QTY / (SELECT MAX(CASE WHEN A.ACCUMULATED_CHILD_QTY IS NULL OR A.ACCUMULATED_CHILD_QTY = 0 THEN 1 ELSE A.ACCUMULATED_CHILD_QTY END)
                                    														 FROM   FP_ITEM_CELL_EXCHANGE_M A WITH(NOLOCK)
							                                                                 WHERE  A.DIVISION_ID  = @DIVISION_ID
							                                                                 AND    A.SITE_ID      = @SITE_ID
							                                                                 AND    A.PLANT_ID     = @PLANT_ID
                                    														 AND    A.MODEL_ID     = @TOP_ITEM_ID
                                    														 AND    A.ITEM_ID      = @ITEM_ID) )
          					 , MPP_CELL_IN_QTY = CEILING(FLOOR(@MPP_OUT_QTY / ( SELECT MAX(CASE WHEN A.ACCUMULATED_CHILD_QTY IS NULL OR A.ACCUMULATED_CHILD_QTY = 0 THEN 1 ELSE A.ACCUMULATED_CHILD_QTY END)
                                            														 FROM   FP_ITEM_CELL_EXCHANGE_M A WITH(NOLOCK)
							                                                                         WHERE  A.DIVISION_ID  = @DIVISION_ID
							                                                                         AND    A.SITE_ID      = @SITE_ID
							                                                                         AND    A.PLANT_ID     = @PLANT_ID
                                            														 AND    A.MODEL_ID     = @TOP_ITEM_ID
                                            														 AND    A.ITEM_ID      = @ITEM_ID) )
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
                        														AND    CONVERT(DATE,@PLAN_DATE) BETWEEN A.START_TIME AND A.END_TIME
                        													) B
                        													ON     1=1
                        													WHERE  A.DIVISION_ID  = @DIVISION_ID
                        													AND    A.SITE_ID      = @SITE_ID
                        													AND    A.PLANT_ID     = @PLANT_ID
                        													AND    A.FACTORY_ID   = @FACTORY_ID
                        													AND    A.OPERATION_ID = @OPERATION_ID
                        													AND    A.LINE_ID      = @LINE_ID
                        													AND    A.ITEM_ID      = @ITEM_ID
                        													AND    A.MONTH        = SUBSTRING(@PLAN_DATE,1,6)) )
                     , DATE_SEQ = CASE WHEN (CONVERT(NUMERIC(25,10),ISNULL(@WPP_OUT_QTY,0)) = 0 AND CONVERT(NUMERIC(25,10),ISNULL(@MPP_OUT_QTY,0)) = 0) THEN 0 ELSE 1 END
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
              ,WPP_IN_QTY
              ,WPP_OUT_QTY
              ,WPP_CELL_IN_QTY
              ,WPP_CELL_OUT_QTY
              ,MPP_IN_QTY
              ,MPP_OUT_QTY
              ,MPP_CELL_IN_QTY
              ,MPP_CELL_OUT_QTY
              ,DATE_SEQ
              ,INSERT_ID, INSERT_TIME
              ,UPDATE_ID, UPDATE_TIME
            )
            VALUES (
               UPPER(@INSTANCE_ID), UPPER(@FP_PLAN_ID)
              ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = UPPER(@DIVISION_ID) AND SITE_ID = UPPER(@SITE_ID) AND PLANT_ID = UPPER(@PLANT_ID) AND ACTIVE_FLAG = 'Y')
              ,UPPER(@DIVISION_ID)
              ,'PLAN'
              ,UPPER(@SITE_ID), UPPER(@PLANT_ID)
              ,UPPER(@ITEM_ID), UPPER(@OPERATION_ID), UPPER(@FACTORY_ID), UPPER(@LOCATION)
              ,UPPER(@PRODUCTION_TYPE), UPPER(@MARKET)
              ,UPPER(@LINE_ID), @ELECTRODE_TYPE
              ,CONVERT(DATE,@PLAN_DATE)
              ,UPPER(@TOP_ITEM_ID), UPPER(@ITEM_TYPE)
              ,CEILING(@WPP_OUT_QTY / (SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD
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
                                            AND    CONVERT(DATE,@PLAN_DATE) BETWEEN A.START_TIME AND A.END_TIME
                                        ) B
                                        ON     1=1
                                        WHERE  A.DIVISION_ID  = @DIVISION_ID
                                        AND    A.SITE_ID      = @SITE_ID
                                        AND    A.PLANT_ID     = @PLANT_ID
                                        AND    A.FACTORY_ID   = @FACTORY_ID
                                        AND    A.OPERATION_ID = @OPERATION_ID
                                        AND    A.LINE_ID      = @LINE_ID
                                        AND    A.ITEM_ID      = @ITEM_ID
                                        AND    A.MONTH        = SUBSTRING(@PLAN_DATE,1,6)))
              ,@WPP_OUT_QTY
              ,CEILING(FLOOR(@WPP_OUT_QTY / ( SELECT MAX(CASE WHEN A.ACCUMULATED_CHILD_QTY IS NULL OR A.ACCUMULATED_CHILD_QTY = 0 THEN 1 ELSE A.ACCUMULATED_CHILD_QTY END)
                  														 FROM   FP_ITEM_CELL_EXCHANGE_M A WITH(NOLOCK)
							                                               WHERE  A.DIVISION_ID  = @DIVISION_ID
							                                               AND    A.SITE_ID      = @SITE_ID
							                                               AND    A.PLANT_ID     = @PLANT_ID
                  														 AND    A.MODEL_ID     = @TOP_ITEM_ID
                  														 AND    A.ITEM_ID      = @ITEM_ID) )
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
														AND    CONVERT(DATE,@PLAN_DATE) BETWEEN A.START_TIME AND A.END_TIME
													) B
													ON     1=1
													WHERE  A.DIVISION_ID  = @DIVISION_ID
													AND    A.SITE_ID      = @SITE_ID
													AND    A.PLANT_ID     = @PLANT_ID
													AND    A.FACTORY_ID   = @FACTORY_ID
													AND    A.OPERATION_ID = @OPERATION_ID
													AND    A.LINE_ID      = @LINE_ID
													AND    A.ITEM_ID      = @ITEM_ID
													AND    A.MONTH        = SUBSTRING(@PLAN_DATE,1,6)) )
              ,FLOOR(@WPP_OUT_QTY / (SELECT MAX(CASE WHEN A.ACCUMULATED_CHILD_QTY IS NULL OR A.ACCUMULATED_CHILD_QTY = 0 THEN 1 ELSE A.ACCUMULATED_CHILD_QTY END)
        														  FROM   FP_ITEM_CELL_EXCHANGE_M A WITH(NOLOCK)
							                                      WHERE  A.DIVISION_ID  = @DIVISION_ID
							                                      AND    A.SITE_ID      = @SITE_ID
							                                      AND    A.PLANT_ID     = @PLANT_ID
        														  AND    A.MODEL_ID     = @TOP_ITEM_ID
        														  AND    A.ITEM_ID      = @ITEM_ID) )
              ,CEILING(@MPP_OUT_QTY / (SELECT ISNULL( ISNULL(MAX(B.YIELD),(CASE WHEN MAX(A.YIELD) = 0 THEN 1 ELSE MAX(A.YIELD) END)) ,1) AS YIELD
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
                                            AND    CONVERT(DATE,@PLAN_DATE) BETWEEN A.START_TIME AND A.END_TIME
                                        ) B
                                        ON     1=1
                                        WHERE  A.DIVISION_ID  = @DIVISION_ID
                                        AND    A.SITE_ID      = @SITE_ID
                                        AND    A.PLANT_ID     = @PLANT_ID
                                        AND    A.FACTORY_ID   = @FACTORY_ID
                                        AND    A.OPERATION_ID = @OPERATION_ID
                                        AND    A.LINE_ID      = @LINE_ID
                                        AND    A.ITEM_ID      = @ITEM_ID
                                        AND    A.MONTH        = SUBSTRING(@PLAN_DATE,1,6)))
              ,@MPP_OUT_QTY
              ,CEILING(FLOOR(@MPP_OUT_QTY / ( SELECT MAX(CASE WHEN A.ACCUMULATED_CHILD_QTY IS NULL OR A.ACCUMULATED_CHILD_QTY = 0 THEN 1 ELSE A.ACCUMULATED_CHILD_QTY END)
                                            														 FROM   FP_ITEM_CELL_EXCHANGE_M A WITH(NOLOCK)
							                                                                         WHERE  A.DIVISION_ID  = @DIVISION_ID
							                                                                         AND    A.SITE_ID      = @SITE_ID
							                                                                         AND    A.PLANT_ID     = @PLANT_ID
                                            														 AND    A.MODEL_ID     = @TOP_ITEM_ID
                                            														 AND    A.ITEM_ID      = @ITEM_ID) )
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
													AND    CONVERT(DATE,@PLAN_DATE) BETWEEN A.START_TIME AND A.END_TIME
												) B
												ON     1=1
												WHERE  A.DIVISION_ID  = @DIVISION_ID
												AND    A.SITE_ID      = @SITE_ID
												AND    A.PLANT_ID     = @PLANT_ID
												AND    A.FACTORY_ID   = @FACTORY_ID
												AND    A.OPERATION_ID = @OPERATION_ID
												AND    A.LINE_ID      = @LINE_ID
												AND    A.ITEM_ID      = @ITEM_ID
												AND    A.MONTH        = SUBSTRING(@PLAN_DATE,1,6)) )
              ,FLOOR(@MPP_OUT_QTY / (SELECT MAX(CASE WHEN A.ACCUMULATED_CHILD_QTY IS NULL OR A.ACCUMULATED_CHILD_QTY = 0 THEN 1 ELSE A.ACCUMULATED_CHILD_QTY END)
          														FROM   FP_ITEM_CELL_EXCHANGE_M A WITH(NOLOCK)
							                                      WHERE  A.DIVISION_ID  = @DIVISION_ID
							                                      AND    A.SITE_ID      = @SITE_ID
							                                      AND    A.PLANT_ID     = @PLANT_ID
          														AND    A.MODEL_ID     = @TOP_ITEM_ID
          														AND    A.ITEM_ID      = @ITEM_ID) )
              ,CASE WHEN (CONVERT(NUMERIC(25,10),ISNULL(@WPP_OUT_QTY,0)) = 0 AND CONVERT(NUMERIC(25,10),ISNULL(@MPP_OUT_QTY,0)) = 0) THEN 0 ELSE 1 END
              ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
              ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
            )
          ;
        
        COMMIT;
        
        BEGIN TRAN
            INSERT INTO HIS_AMEND_PLAN_PACK_R (
                   INSTANCE_ID, FP_PLAN_ID
                  ,COMPANY_ID, DIVISION_ID
                  ,CATEGORY_ID
                  ,SITE_ID, PLANT_ID,ITEM_ID, OPERATION_ID, FACTORY_ID
                  ,LOCATION, PRODUCTION_TYPE, MARKET
                  ,LINE_ID, ELECTRODE_TYPE
                  ,PLAN_DATE
                  ,TOP_ITEM_ID
                  ,ITEM_TYPE
                  ,WPP_OUT_QTY
                  ,MPP_OUT_QTY
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                  ,DATE_SEQ
                  ,JOB_USER_ID, JOB_TIME, JOB_TYPE
            )
            SELECT INSTANCE_ID, FP_PLAN_ID
                  ,COMPANY_ID, DIVISION_ID
                  ,CATEGORY_ID
                  ,SITE_ID, PLANT_ID,ITEM_ID, OPERATION_ID, FACTORY_ID
                  ,LOCATION, PRODUCTION_TYPE, MARKET
                  ,LINE_ID, ELECTRODE_TYPE
                  ,PLAN_DATE
                  ,TOP_ITEM_ID
                  ,ITEM_TYPE
                  ,WPP_OUT_QTY
                  ,MPP_OUT_QTY
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                  ,DATE_SEQ
                  ,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'MERGE' AS JOB_TYPE
            FROM   FP_AMEND_PLAN_PACK_H A WITH(NOLOCK)
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
            ;
          
        COMMIT;
        
      END;