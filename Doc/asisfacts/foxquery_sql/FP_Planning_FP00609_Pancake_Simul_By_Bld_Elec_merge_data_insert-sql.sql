BEGIN
            BEGIN TRAN
              MERGE INTO FP_AMEND_DAILY_PLAN_R A
              USING (
                          SELECT DISTINCT A.*
                               , B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID
                               , C.LOCATION
                          FROM (
                          	SELECT @INSTANCE_ID AS INSTANCE_ID, @FP_PLAN_ID AS FP_PLAN_ID
                          		   , @FACTORY_ID AS FACTORY_ID
                          		   , @OPERATION_ID AS OPERATION_ID, @LINE_ID AS LINE_ID, @ELECTRODE_TYPE AS ELECTRODE_TYPE
                          		   , @EQUIPMENT_ID AS EQUIPMENT_ID, @PLAN_DATE AS PLAN_DATE
                          		   , @ITEM_ID AS TOP_ITEM_ID, @ITEM_ID AS ITEM_ID
                          		   , UPPER(@PRODUCTION_TYPE) AS PRODUCTION_TYPE, @MARKET AS MARKET
                          ) A
                          INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)
                          ON  A.FACTORY_ID = B.FACTORY_ID
                          INNER JOIN SCM_LINE_M C WITH(NOLOCK)
                          ON  A.FACTORY_ID     = C.FACTORY_ID
                          AND A.OPERATION_ID   = C.OPERATION_ID
                          AND A.LINE_ID        = C.LINE_ID
                          AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
              ) B
              ON (    A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID
                  AND A.FACTORY_ID = B.FACTORY_ID AND A.LOCATION = B.LOCATION
                  AND A.OPERATION_ID = B.OPERATION_ID AND A.LINE_ID = B.LINE_ID AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
                  AND A.EQUIPMENT_ID = B.EQUIPMENT_ID AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE
                  AND A.TOP_ITEM_ID = B.TOP_ITEM_ID AND A.ITEM_ID = B.ITEM_ID
                  AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET )
              WHEN MATCHED THEN
                UPDATE SET ADJUST_IN_QTY_BATCH  = @ADJUST_IN_QTY_BATCH
                         , ADJUST_IN_QTY_M      = @ADJUST_IN_QTY_M
                         , ADJUST_IN_QTY_CELL   = @ADJUST_IN_QTY_CELL
                         , ADJUST_IN_QTY_JR     = @ADJUST_IN_QTY_JR
                         , ADJUST_OUT_QTY_BATCH = @ADJUST_OUT_QTY_BATCH
                         , ADJUST_OUT_QTY_M     = @ADJUST_OUT_QTY_M
                         , ADJUST_OUT_QTY_CELL  = @ADJUST_OUT_QTY_CELL
                         , ADJUST_OUT_QTY_JR    = @ADJUST_OUT_QTY_JR
                         , PRODUCTION_TYPE      = B.PRODUCTION_TYPE
                         , UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(@SITE_ID)
              WHEN NOT MATCHED THEN
                INSERT (
                   INSTANCE_ID, FP_PLAN_ID
                  ,COMPANY_ID
                  ,DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                  ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
                  ,EQUIPMENT_ID, PLAN_DATE
                  ,TOP_ITEM_ID, ITEM_ID
                  ,PRODUCTION_TYPE, MARKET
                  ,SEQ
                  ,PLAN_IN_QTY_BATCH, PLAN_IN_QTY
                  ,PLAN_IN_QTY_M, PLAN_IN_QTY_CELL
                  ,PLAN_OUT_QTY_BATCH, PLAN_OUT_QTY
                  ,PLAN_OUT_QTY_M, PLAN_OUT_QTY_CELL
                  ,ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY
                  ,ADJUST_IN_QTY_M, ADJUST_IN_QTY_CELL
                  ,ADJUST_IN_QTY_JR
                  ,ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY
                  ,ADJUST_OUT_QTY_M, ADJUST_OUT_QTY_CELL
                  ,ADJUST_OUT_QTY_JR
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                )
                VALUES (
                   B.INSTANCE_ID, B.FP_PLAN_ID
                  ,B.COMPANY_ID
                  ,B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID
                  ,B.LOCATION, B.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE
                  ,B.EQUIPMENT_ID ,CONVERT(DATETIME,B.PLAN_DATE)
                  ,B.ITEM_ID, B.ITEM_ID
                  ,UPPER(B.PRODUCTION_TYPE), B.MARKET
                  ,1
                  ,null, null
                  ,null, null
                  ,null, null
                  ,null, null
                  ,@ADJUST_IN_QTY_BATCH, @ADJUST_IN_QTY
                  ,@ADJUST_IN_QTY_M, @ADJUST_IN_QTY_CELL
                  ,@ADJUST_IN_QTY_JR
                  ,@ADJUST_OUT_QTY_BATCH, @ADJUST_OUT_QTY
                  ,@ADJUST_OUT_QTY_M, @ADJUST_OUT_QTY_CELL
                  ,@ADJUST_OUT_QTY_JR
                  ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
                  ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
                )
              ;
            
            COMMIT;
            
            BEGIN TRAN
                INSERT INTO HIS_AMEND_DAILY_PLAN_R (
                       INSTANCE_ID, FP_PLAN_ID
                      ,COMPANY_ID
                      ,DIVISION_ID
                      ,SITE_ID
                      ,PLANT_ID
                      ,FACTORY_ID
                      ,LOCATION
                      ,OPERATION_ID
                      ,LINE_ID
                      ,ELECTRODE_TYPE
                      ,EQUIPMENT_ID
                      ,PLAN_DATE
                      ,TOP_ITEM_ID
                      ,ITEM_ID
                      ,PRODUCTION_TYPE
                      ,MARKET
                      ,SEQ
                      ,PLAN_IN_QTY_BATCH
                      ,PLAN_IN_QTY
                      ,PLAN_IN_QTY_M
                      ,PLAN_IN_QTY_CELL
                      ,PLAN_OUT_QTY_BATCH
                      ,PLAN_OUT_QTY
                      ,PLAN_OUT_QTY_M
                      ,PLAN_OUT_QTY_CELL
                      ,ADJUST_IN_QTY_BATCH
                      ,ADJUST_IN_QTY
                      ,ADJUST_IN_QTY_M
                      ,ADJUST_IN_QTY_CELL
                      ,ADJUST_IN_QTY_JR
                      ,ADJUST_OUT_QTY_BATCH
                      ,ADJUST_OUT_QTY
                      ,ADJUST_OUT_QTY_M
                      ,ADJUST_OUT_QTY_CELL
                      ,ADJUST_OUT_QTY_JR
                      ,TOTAL_BATCH
                      ,INSERT_ID, INSERT_TIME
                      ,UPDATE_ID, UPDATE_TIME
                      ,JOB_USER_ID, JOB_TIME, JOB_TYPE
                )
                SELECT INSTANCE_ID, FP_PLAN_ID
                      ,COMPANY_ID
                      ,DIVISION_ID
                      ,SITE_ID
                      ,PLANT_ID
                      ,FACTORY_ID
                      ,LOCATION
                      ,OPERATION_ID
                      ,LINE_ID
                      ,ELECTRODE_TYPE
                      ,EQUIPMENT_ID
                      ,PLAN_DATE
                      ,TOP_ITEM_ID
                      ,ITEM_ID
                      ,UPPER(PRODUCTION_TYPE) AS PRODUCTION_TYPE
                      ,MARKET
                      ,SEQ
                      ,PLAN_IN_QTY_BATCH
                      ,PLAN_IN_QTY
                      ,PLAN_IN_QTY_M
                      ,PLAN_IN_QTY_CELL
                      ,PLAN_OUT_QTY_BATCH
                      ,PLAN_OUT_QTY
                      ,PLAN_OUT_QTY_M
                      ,PLAN_OUT_QTY_CELL
                      ,ADJUST_IN_QTY_BATCH
                      ,ADJUST_IN_QTY
                      ,ADJUST_IN_QTY_M
                      ,ADJUST_IN_QTY_CELL
                      ,ADJUST_IN_QTY_JR
                      ,ADJUST_OUT_QTY_BATCH
                      ,ADJUST_OUT_QTY
                      ,ADJUST_OUT_QTY_M
                      ,ADJUST_OUT_QTY_CELL
                      ,ADJUST_OUT_QTY_JR
                      ,TOTAL_BATCH
                      ,INSERT_ID, INSERT_TIME
                      ,UPDATE_ID, UPDATE_TIME
                      ,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'UPDATE_SIMUL_ELEC' AS JOB_TYPE
                FROM   FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)
                WHERE  A.INSTANCE_ID      = @INSTANCE_ID
                AND    A.FP_PLAN_ID       = @FP_PLAN_ID
                AND    A.FACTORY_ID       = @FACTORY_ID
                AND    A.OPERATION_ID     = @OPERATION_ID
                AND    A.LINE_ID          = @LINE_ID
                AND    A.ELECTRODE_TYPE   = @ELECTRODE_TYPE
                AND    A.EQUIPMENT_ID     = @EQUIPMENT_ID
                AND    A.PLAN_DATE        = CONVERT(DATETIME,@PLAN_DATE)
                AND    A.TOP_ITEM_ID      = @ITEM_ID
                AND    A.ITEM_ID          = @ITEM_ID
                AND    A.PRODUCTION_TYPE  = UPPER(@PRODUCTION_TYPE)
                AND    A.MARKET           = @MARKET
                ;
              
            COMMIT;
            
          END;