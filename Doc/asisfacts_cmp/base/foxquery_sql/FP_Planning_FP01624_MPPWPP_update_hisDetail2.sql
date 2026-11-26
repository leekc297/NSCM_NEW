BEGIN
          MERGE INTO HIS_FP_PLAN_GROUP_DETAIL_H AS A
          USING (
            SELECT B.PLAN_DATE, B.INSTANCE_ID, B.PLAN_GROUP_ID
                  ,B.PLAN_ID
                  ,B.CONFIRM_ID, B.CONFIRM_TIME, B.CONFIRM_FLAG
                  ,B.RELEASE_TIME, B.RELEASE_FLAG, B.RELEASE_PLAN_ID
                  ,B.MES_TRANSFER_FLAG, B.MES_TRANSFER_TIME
                  ,B.DESCRIPTION
                  ,B.INSERT_ID, B.INSERT_TIME
                  ,B.UPDATE_ID, B.UPDATE_TIME
            FROM   SCM_FP_PLAN_GROUP_DETAIL_H B
            WHERE  B.PLAN_DATE = @PLAN_DATE
            AND    B.PLAN_ID IN (@PLAN_LT)

          ) AS B
            ON (A.PLAN_DATE     = B.PLAN_DATE
            AND A.INSTANCE_ID   = B.INSTANCE_ID
            AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
            AND A.PLAN_ID       = B.PLAN_ID)
          WHEN MATCHED THEN
            UPDATE SET
              PLAN_ID           = B.PLAN_ID
             ,CONFIRM_ID        = B.CONFIRM_ID
             ,CONFIRM_TIME      = B.CONFIRM_TIME
             ,CONFIRM_FLAG      = B.CONFIRM_FLAG
             ,RELEASE_TIME      = B.RELEASE_TIME
             ,RELEASE_FLAG      = B.RELEASE_FLAG
             ,RELEASE_PLAN_ID   = B.RELEASE_PLAN_ID
             ,MES_TRANSFER_FLAG = B.MES_TRANSFER_FLAG
             ,MES_TRANSFER_TIME = B.MES_TRANSFER_TIME
             ,UPDATE_ID         = B.UPDATE_ID
             ,UPDATE_TIME       = B.UPDATE_TIME
          WHEN NOT MATCHED THEN
            INSERT (
               PLAN_DATE
              ,INSTANCE_ID
              ,PLAN_GROUP_ID
              ,PLAN_ID
              ,CONFIRM_ID
              ,CONFIRM_TIME
              ,CONFIRM_FLAG
              ,RELEASE_TIME
              ,RELEASE_FLAG
              ,RELEASE_PLAN_ID
              ,MES_TRANSFER_FLAG
              ,MES_TRANSFER_TIME
              ,DESCRIPTION
              ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
              ,JOB_USER_ID, JOB_TIME, JOB_TYPE
            ) VALUES (
               B.PLAN_DATE
              ,B.INSTANCE_ID
              ,B.PLAN_GROUP_ID
              ,B.PLAN_ID
              ,B.CONFIRM_ID
              ,B.CONFIRM_TIME
              ,B.CONFIRM_FLAG
              ,B.RELEASE_TIME
              ,B.RELEASE_FLAG
              ,B.RELEASE_PLAN_ID
              ,B.MES_TRANSFER_FLAG
              ,B.MES_TRANSFER_TIME
              ,B.DESCRIPTION
              ,B.INSERT_ID, B.INSERT_TIME, B.UPDATE_ID, B.UPDATE_TIME
              ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID), 'CONFIRM'
            )
          ;
      END;