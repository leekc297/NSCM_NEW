begin
        begin tran
          UPDATE SCM_SETUP_CONDITION_M SET
                 SETUP_TIME = @SETUP_TIME
                ,UPDATE_ID = @USER_ID
                ,UPDATE_TIME = dbo.SYSDATE1()
          WHERE  COMPANY_ID = @COMPANY_ID
          AND    DIVISION_ID = @DIVISION_ID
          AND    SITE_ID = @SITE_ID
          AND    PLANT_ID = @PLANT_ID
          AND    OPERATION_ID = @OPERATION_ID
          AND    LINE_SETUP_GROUP_ID = @LINE_SETUP_GROUP_ID
          AND    SETUP_CATEGORY_ID = @SETUP_CATEGORY_ID
          AND    SETUP_KEY_ID = @SETUP_KEY_ID
          AND    SETUP_CONDITION_ID = @SETUP_CONDITION_ID
          ;
        
        commit;
        
        begin tran
          insert into his_setup_condition_m (
                 COMPANY_ID
                ,DIVISION_ID
                ,SITE_ID
                ,PLANT_ID
                ,OPERATION_ID
                ,LINE_SETUP_GROUP_ID
                ,SETUP_CATEGORY_ID
                ,SETUP_KEY_ID
                ,SETUP_CONDITION_ID
                ,SHOP_GROUP_ID
                ,SETUP_TIME
                ,SETUP_TIME_UOM
                ,DESCRIPTION
                ,INSERT_ID
                ,INSERT_TIME
                ,UPDATE_ID
                ,UPDATE_TIME
                ,JOB_USER_ID
                ,JOB_TIME
                ,JOB_TYPE
          )
          select COMPANY_ID
                ,DIVISION_ID
                ,SITE_ID
                ,PLANT_ID
                ,OPERATION_ID
                ,LINE_SETUP_GROUP_ID
                ,SETUP_CATEGORY_ID
                ,SETUP_KEY_ID
                ,SETUP_CONDITION_ID
                ,SHOP_GROUP_ID
                ,SETUP_TIME
                ,SETUP_TIME_UOM
                ,DESCRIPTION
                ,INSERT_ID
                ,INSERT_TIME
                ,UPDATE_ID
                ,UPDATE_TIME
                ,@USER_ID as JOB_USER_ID
                ,dbo.sysdate1() as JOB_TIME
                ,'UPDATE' as JOB_TYPE
          from   scm_setup_condition_m(NOLOCK)
          WHERE  COMPANY_ID = @COMPANY_ID
          AND    DIVISION_ID = @DIVISION_ID
          AND    SITE_ID = @SITE_ID
          AND    PLANT_ID = @PLANT_ID
          AND    OPERATION_ID = @OPERATION_ID
          and    LINE_SETUP_GROUP_ID = @LINE_SETUP_GROUP_ID
          and    SETUP_CATEGORY_ID = @SETUP_CATEGORY_ID
          and    SETUP_KEY_ID = @SETUP_KEY_ID
          and    SETUP_CONDITION_ID = @SETUP_CONDITION_ID
          ;
        
        commit;
        
        begin tran
          UPDATE SCM_SETUP_MATRIX_M SET
                 SETUP_TIME = @SETUP_TIME
                ,UPDATE_ID = @USER_ID
                ,UPDATE_TIME = dbo.SYSDATE1()
          WHERE  COMPANY_ID = @COMPANY_ID
          AND    DIVISION_ID = @DIVISION_ID
          AND    SITE_ID = @SITE_ID
          AND    PLANT_ID = @PLANT_ID
          AND    OPERATION_ID = @OPERATION_ID
          AND    LINE_SETUP_GROUP_ID = @LINE_SETUP_GROUP_ID
          AND    SETUP_CATEGORY_ID = @SETUP_CATEGORY_ID
          AND    SETUP_KEY_ID = @SETUP_KEY_ID
          AND    SETUP_CONDITION_ID = @SETUP_CONDITION_ID
          ;
        
        commit;
      end;