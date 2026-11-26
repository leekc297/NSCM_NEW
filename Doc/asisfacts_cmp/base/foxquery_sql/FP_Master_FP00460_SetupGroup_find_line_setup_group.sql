SELECT a.LINE_SETUP_GROUP_ID as CODE,a.LINE_SETUP_GROUP_ID as NAME--, a.*
                FROM   FP_LINE_SETUP_GROUP_M a(NOLOCK) 
                WHERE  a.active_flag = @ACTIVE_FLAG
                AND a.INSTANCE_ID = @INSTANCE_ID
                AND A.OPERATION_ID = @OPERATION_ID
                ORDER BY CODE