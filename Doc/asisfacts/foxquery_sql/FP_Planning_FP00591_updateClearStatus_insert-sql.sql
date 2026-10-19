DELETE FROM FP_PLAN_STATUS_H
        WHERE  INSTANCE_ID = @INSTANCE_ID
        AND    PLAN_ID     = @PLAN_ID
        ;
          
        INSERT INTO FP_PLAN_STATUS_H (
        	  INSTANCE_ID,       PLAN_ID,          ACTIVE_FLAG
        	, INBOUND_FLAG,      INBOUND_START,    ENGINE_FLAG
        	, OUTBOUND_FLAG,     DB_TRANS_FLAG,    INSERT_ID
        	, INSERT_TIME,       UPDATE_ID,        UPDATE_TIME
        )
        SELECT @INSTANCE_ID, @PLAN_ID, 1 AS ACTIVE_FLAG
             , 'P' AS inbound_flag,    GETDATE() AS inbound_start, 'R' AS engine_flag
             , 'R' AS outbound_flag,   'R' AS db_trans_flag, @USER_ID AS insert_id
             , GETDATE() AS insert_date, @USER_ID AS update_id, GETDATE() AS update_date
        ;
        
        INSERT INTO HIS_PLAN_STATUS_H (
             INSTANCE_ID,           PLAN_ID,            ACTIVE_FLAG         
            ,INBOUND_FLAG,          INBOUND_STEP,       INBOUND_START       
            ,INBOUND_END,           ENGINE_FLAG,        ENGINE_STEP         
            ,ENGINE_START,          ENGINE_END,         OUTBOUND_FLAG       
            ,OUTBOUND_STEP,         OUTBOUND_START,     OUTBOUND_END        
            ,DB_TRANS_FLAG,         DB_TRANS_STEP,      DB_TRANS_START      
            ,DB_TRANS_END,          DESCRIPTION,        DB_CONNECTION_NAME  
            ,INSERT_ID,             INSERT_TIME,        UPDATE_ID           
            ,UPDATE_TIME,           JOB_USER_ID,        JOB_TIME            
            ,JOB_TYPE
        )   
        SELECT INSTANCE_ID,         PLAN_ID,            ACTIVE_FLAG         
            ,INBOUND_FLAG,          INBOUND_STEP,       INBOUND_START       
            ,INBOUND_END,           ENGINE_FLAG,        ENGINE_STEP         
            ,ENGINE_START,          ENGINE_END,         OUTBOUND_FLAG       
            ,OUTBOUND_STEP,         OUTBOUND_START,     OUTBOUND_END        
            ,DB_TRANS_FLAG,         DB_TRANS_STEP,      DB_TRANS_START      
            ,DB_TRANS_END,          DESCRIPTION,        DB_CONNECTION_NAME  
            ,INSERT_ID,             INSERT_TIME,        UPDATE_ID           
            ,UPDATE_TIME,        @USER_ID , dbo.SYSDATE1() AS JOB_TIME
            ,'INSERT' AS JOB_TYPE
        FROM   FP_PLAN_STATUS_H(NOLOCK)
        WHERE  INSTANCE_ID = @INSTANCE_ID
        AND    PLAN_ID     = @PLAN_ID
        ;