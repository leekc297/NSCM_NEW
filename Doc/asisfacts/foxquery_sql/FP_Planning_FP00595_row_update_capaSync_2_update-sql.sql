BEGIN
        BEGIN TRAN
          MERGE INTO FP_LINE_CAPA_SYNC_H A
          USING (SELECT @INSTANCE_ID AS INSTANCE_ID, @FP_PLAN_ID AS FP_PLAN_ID
                      , @FACTORY_ID AS FACTORY_ID
                      , @OPERATION_ID AS OPERATION_ID, @LINE_ID AS LINE_ID, @ELECTRODE_TYPE AS ELECTRODE_TYPE
                      , CONVERT(DATETIME, @START_DATE) AS START_DATE
                      , CONVERT(DATETIME, @END_DATE) AS END_DATE ) B
          ON (    A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID
              AND A.FACTORY_ID = B.FACTORY_ID
              AND A.LINE_ID = B.LINE_ID
              AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
              AND A.OPERATION_ID = B.OPERATION_ID )
          WHEN MATCHED THEN
            UPDATE SET START_DATE = B.START_DATE
                     , END_DATE = B.END_DATE
                     , ACTIVE_FLAG = 'Y'
                     , UPDATE_ID = @USER_ID, UPDATE_TIME = GETDATE()
          WHEN NOT MATCHED THEN
            INSERT (
                INSTANCE_ID, FP_PLAN_ID
              , FACTORY_ID, LINE_ID, ELECTRODE_TYPE, OPERATION_ID
              , START_DATE, END_DATE
              , ACTIVE_FLAG
              , INSERT_ID, INSERT_TIME
              , UPDATE_ID, UPDATE_TIME
            )
            VALUES (
                B.INSTANCE_ID, B.FP_PLAN_ID
              , B.FACTORY_ID, B.LINE_ID, B.ELECTRODE_TYPE, B.OPERATION_ID
              , B.START_DATE, B.END_DATE
              , 'Y'
              ,@USER_ID, GETDATE()
              ,@USER_ID, GETDATE()
            )
          ;
        
        COMMIT;
        
        BEGIN TRAN
            INSERT INTO HIS_LINE_CAPA_SYNC_H (
                    INSTANCE_ID, FP_PLAN_ID
                  , FACTORY_ID, LINE_ID, ELECTRODE_TYPE, OPERATION_ID
                  , START_DATE, END_DATE
                  , ACTIVE_FLAG
                  , INSERT_ID, INSERT_TIME
                  , UPDATE_ID, UPDATE_TIME
                  , JOB_USER_ID, JOB_TIME, JOB_TYPE
            )
            SELECT INSTANCE_ID, FP_PLAN_ID
                  , FACTORY_ID, LINE_ID, ELECTRODE_TYPE, OPERATION_ID
                  , START_DATE, END_DATE
                  , ACTIVE_FLAG
                  , INSERT_ID, INSERT_TIME
                  , UPDATE_ID, UPDATE_TIME
                  , @USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'MERGE' AS JOB_TYPE
            FROM   FP_LINE_CAPA_SYNC_H A WITH(NOLOCK)
            WHERE  A.INSTANCE_ID      = @INSTANCE_ID
            AND    A.FP_PLAN_ID       = @FP_PLAN_ID
            AND    A.FACTORY_ID       = @FACTORY_ID
            AND    A.OPERATION_ID     = @OPERATION_ID
            AND    A.LINE_ID          = @LINE_ID
            AND    A.ELECTRODE_TYPE   = @ELECTRODE_TYPE
            ;
          
        COMMIT;
        
      END;