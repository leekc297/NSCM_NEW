BEGIN
        
        UPDATE SCM_FP_PLAN_H SET
               MRP_FLAG = 'N'
        WHERE  INSTANCE_ID = @MASTER_ID
        AND    PLAN_ID     = @PLAN_ID
      
      END;