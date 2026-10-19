--BEGIN
        --BEGIN TRAN
            INSERT INTO HIS_AMEND_MEMO_M (
                   INSTANCE_ID
                  ,COMPANY_ID
                  ,DIVISION_ID
                  ,SITE_ID
                  ,PLANT_ID
                  ,FACTORY_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,ELECTRODE_TYPE
                  ,EQUIPMENT_ID
                  ,PLAN_DATE
                  ,MARKET
                  ,PRODUCTION_TYPE
                  ,TOP_ITEM_ID
                  ,ITEM_ID
                  ,MEMO
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                  ,JOB_USER_ID, JOB_TIME, JOB_TYPE
            )
            SELECT INSTANCE_ID
                  ,COMPANY_ID
                  ,DIVISION_ID
                  ,SITE_ID
                  ,PLANT_ID
                  ,FACTORY_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,ELECTRODE_TYPE
                  ,EQUIPMENT_ID
                  ,PLAN_DATE
                  ,MARKET
                  ,PRODUCTION_TYPE
                  ,TOP_ITEM_ID
                  ,ITEM_ID
                  ,MEMO
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                  ,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'DELETE' AS JOB_TYPE
            FROM   FP_AMEND_MEMO_M A WITH(NOLOCK)
            WHERE  A.INSTANCE_ID      = @INSTANCE_ID
            AND    A.DIVISION_ID      = @DIVISION_ID
            AND    A.SITE_ID          = @SITE_ID
            AND    A.PLANT_ID         = @PLANT_ID
            AND    A.FACTORY_ID       = @FACTORY_ID
            AND    A.OPERATION_ID     = @OPERATION_ID
            AND    A.LINE_ID          = @LINE_ID
            AND    A.ELECTRODE_TYPE   = @ELECTRODE_TYPE
            AND    A.PLAN_DATE        = CONVERT(DATETIME,@PLAN_DATE)
            AND    A.MARKET           = @MARKET
            AND    A.PRODUCTION_TYPE  = @PRODUCTION_TYPE
            AND    A.TOP_ITEM_ID      = @TOP_ITEM_ID
            AND    A.ITEM_ID          = @ITEM_ID
            ;
          
        --COMMIT;
        
        --BEGIN TRAN
            --DELETE FROM FP_AMEND_MEMO_M
            UPDATE FP_AMEND_MEMO_M
            SET 	MEMO 			= null
                  , UPDATE_ID 		= @USER_ID
                  , UPDATE_TIME 	= dbo.FN_SITE_TIME(@SITE_ID)
                  , IF_TIME			= GETDATE()
            WHERE  INSTANCE_ID      = @INSTANCE_ID
            AND    DIVISION_ID      = @DIVISION_ID
            AND    SITE_ID          = @SITE_ID
            AND    PLANT_ID         = @PLANT_ID
            AND    FACTORY_ID       = @FACTORY_ID
            AND    OPERATION_ID     = @OPERATION_ID
            AND    LINE_ID          = @LINE_ID
            AND    ELECTRODE_TYPE   = @ELECTRODE_TYPE
            AND    PLAN_DATE        = CONVERT(DATETIME,@PLAN_DATE)
            AND    MARKET           = @MARKET
            AND    PRODUCTION_TYPE  = @PRODUCTION_TYPE
            AND    TOP_ITEM_ID      = @TOP_ITEM_ID
            AND    ITEM_ID          = @ITEM_ID
            ;
            
        --COMMIT;
        
      --END;