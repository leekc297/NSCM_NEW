UPDATE SCM_FP_PLAN_H SET
               AMEND_FIX_DATE = NULL
        WHERE  INSTANCE_ID    = @INSTANCE_ID
        AND    PLAN_ID        = @PLAN_ID
        ;
          
        UPDATE JOB_SCHEDULE_DETAIL SET
               PARAMETER1 = @INSTANCE_ID
             , PARAMETER2 = @PLAN_ID
        WHERE  GROUP_ID   = 'ENGINE_RUN_UI-' + @INSTANCE_ID
        ;
          
        UPDATE JOB_SCHEDULE_MASTER SET
               IMMEDIATE_FLAG = 'Y'
        WHERE  GROUP_ID = 'ENGINE_RUN_UI-' + @INSTANCE_ID
        ;