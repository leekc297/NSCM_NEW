BEGIN
  BEGIN TRAN
    MERGE INTO FP_AMEND_MEMO_M A
    USING 
      (
      SELECT @INSTANCE_ID AS INSTANCE_ID
      ,( SELECT MAX(KK.COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M KK WITH(NOLOCK)  WHERE KK.FACTORY_ID = @FACTORY_ID) AS COMPANY_ID
      ,@DIVISION_ID AS DIVISION_ID
      ,@SITE_ID AS SITE_ID
      ,@PLANT_ID AS PLANT_ID
      ,@FACTORY_ID AS FACTORY_ID
      ,@OPERATION_ID AS OPERATION_ID
      ,@LINE_ID AS LINE_ID
      ,@ELECTRODE_TYPE AS ELECTRODE_TYPE
      ,@EQUIPMENT_ID AS EQUIPMENT_ID
      ,UPPER(@PRODUCTION_TYPE) AS PRODUCTION_TYPE
      ,@MARKET AS MARKET
      ,CONVERT(DATETIME, @PLAN_DATE) AS PLAN_DATE
      ,@TOP_ITEM_ID AS TOP_ITEM_ID
      ,@ITEM_ID AS ITEM_ID
      ,LEFT(@MEMO,700) AS MEMO
      ,@ATTR1 AS ATTR1
      ,@ATTR2 AS ATTR2
      ,@MEMO_TYPE AS MEMO_TYPE
      ,@USER_ID AS USER_ID
      ,dbo.FN_SITE_TIME(@SITE_ID) AS USER_TIME) B
      ON (
          A.INSTANCE_ID    = B.INSTANCE_ID      AND A.COMPANY_ID = B.COMPANY_ID     
          AND A.DIVISION_ID    = B.DIVISION_ID      AND A.SITE_ID = B.SITE_ID  
          AND A.PLANT_ID       = B.PLANT_ID         AND A.FACTORY_ID = B.FACTORY_ID  
          AND A.OPERATION_ID   = B.OPERATION_ID     AND A.LINE_ID = B.LINE_ID
          AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE   AND A.PLAN_DATE = B.PLAN_DATE  
          AND A.MARKET         = B.MARKET           AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE  
          AND A.TOP_ITEM_ID    = B.TOP_ITEM_ID      AND A.ITEM_ID = B.ITEM_ID
          AND A.MEMO_TYPE      = B.MEMO_TYPE 
      )
          
      WHEN MATCHED THEN
            UPDATE SET MEMO = B.MEMO,ATTR1=B.ATTR1,ATTR2=B.ATTR2 
              , UPDATE_ID = B.USER_ID, UPDATE_TIME = B.USER_TIME   
        WHEN NOT MATCHED THEN  
            INSERT (                                                                 
            INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID                         
            , PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID                          
            , ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, MARKET                      
            , PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, MEMO,ATTR1,ATTR2              
            , MEMO_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID                         
            , UPDATE_TIME                                                          
            )                                                                        
            VALUES (                                                                 
            B.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID                 
            , B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID                  
            , B.ELECTRODE_TYPE, B.EQUIPMENT_ID, B.PLAN_DATE, B.MARKET              
            , B.PRODUCTION_TYPE, B.TOP_ITEM_ID, B.ITEM_ID, B.MEMO ,B.ATTR1,B.ATTR2 
            , B.MEMO_TYPE, B.USER_ID, B.USER_TIME, B.USER_ID                       
            , B.USER_TIME                                                          
            ) ;                           
                        
      COMMIT;
      BEGIN TRAN                        
        INSERT INTO HIS_AMEND_MEMO_M (                                            
        INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID                      
        , PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID                       
        , ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, MARKET                   
        , PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, MEMO,ATTR1,ATTR2                        
        , MEMO_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID                      
        , UPDATE_TIME, JOB_USER_ID, JOB_TIME, JOB_TYPE                      
        )                                                                         
        SELECT INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID                      
        , PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID                       
        , ELECTRODE_TYPE, EQUIPMENT_ID, PLAN_DATE, MARKET                   
        , PRODUCTION_TYPE, TOP_ITEM_ID, ITEM_ID, MEMO,ATTR1,ATTR2                        
        , MEMO_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID                      
        , UPDATE_TIME, @USER_ID, GETDATE(), 'UPDATE'          
        FROM   FP_AMEND_MEMO_M A WITH(NOLOCK)                                     
        WHERE  A.INSTANCE_ID      = @INSTANCE_ID          
        AND    A.DIVISION_ID      = @DIVISION_ID              
        AND    A.SITE_ID          = @SITE_ID                      
        AND    A.PLANT_ID         = @PLANT_ID                        
        AND    A.FACTORY_ID       = @FACTORY_ID                        
        AND    A.OPERATION_ID     = @OPERATION_ID                      
        AND    A.LINE_ID          = @LINE_ID                           
        AND    A.ELECTRODE_TYPE   = @ELECTRODE_TYPE                    
        AND    A.PLAN_DATE        = CONVERT(DATETIME,@PLAN_DATE )      
        AND    A.MARKET           = @MARKET
        AND    A.PRODUCTION_TYPE  = @PRODUCTION_TYPE                   
        AND    A.TOP_ITEM_ID      = @TOP_ITEM_ID                       
        AND    A.ITEM_ID          = @ITEM_ID                           
        AND    A.MEMO_TYPE        = @MEMO_TYPE
      COMMIT;          
      END;