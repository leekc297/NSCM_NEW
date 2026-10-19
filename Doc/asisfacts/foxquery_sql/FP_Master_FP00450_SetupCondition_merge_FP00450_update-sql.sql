begin
        begin tran
          merge into scm_setup_condition_m AS A
          using (select RTRIM(LTRIM(@COMPANY_ID)) as COMPANY_ID, RTRIM(LTRIM(@DIVISION_ID)) as DIVISION_ID, RTRIM(LTRIM(@SITE_ID)) as SITE_ID, RTRIM(LTRIM(@PLANT_ID)) as PLANT_ID
                       ,RTRIM(LTRIM(@OPERATION_ID)) as OPERATION_ID
                       ,RTRIM(LTRIM(@LINE_SETUP_GROUP_ID)) as LINE_SETUP_GROUP_ID
                       ,RTRIM(LTRIM(@SETUP_CATEGORY_ID)) as SETUP_CATEGORY_ID
                       ,RTRIM(LTRIM(@SETUP_KEY_ID)) as SETUP_KEY_ID
                       ,RTRIM(LTRIM(@SETUP_CONDITION_ID)) as SETUP_CONDITION_ID) AS B
            ON (A.COMPANY_ID          = B.COMPANY_ID
            AND A.DIVISION_ID         = B.DIVISION_ID
            AND A.SITE_ID             = B.SITE_ID
            AND A.PLANT_ID            = B.PLANT_ID
            AND A.OPERATION_ID        = B.OPERATION_ID
            AND A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
            AND A.SETUP_CATEGORY_ID   = B.SETUP_CATEGORY_ID
            AND A.SETUP_KEY_ID        = B.SETUP_KEY_ID
            AND A.SETUP_CONDITION_ID  = B.SETUP_CONDITION_ID)
          WHEN MATCHED THEN 
            UPDATE SET 
              update_id   = @USER_ID
             ,UPDATE_TIME = dbo.SYSDATE1()
             ,SETUP_TIME  = @SETUP_TIME
          WHEN NOT MATCHED THEN 
            INSERT(
               COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID
              ,OPERATION_ID
              ,LINE_SETUP_GROUP_ID
              ,SETUP_CATEGORY_ID
              ,SETUP_KEY_ID
              ,SETUP_CONDITION_ID
              ,SHOP_GROUP_ID
              ,SETUP_TIME
              ,SETUP_TIME_UOM
              ,DESCRIPTION
              ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
            ) values (
               RTRIM(LTRIM(@COMPANY_ID)),RTRIM(LTRIM(@DIVISION_ID)),RTRIM(LTRIM(@SITE_ID)),RTRIM(LTRIM(@PLANT_ID))
              ,RTRIM(LTRIM(@OPERATION_ID))
              ,RTRIM(LTRIM(@LINE_SETUP_GROUP_ID))
              ,RTRIM(LTRIM(@SETUP_CATEGORY_ID))
              ,RTRIM(LTRIM(@SETUP_KEY_ID))
              ,RTRIM(LTRIM(@SETUP_CONDITION_ID))
              ,RTRIM(LTRIM(@SHOP_GROUP_ID))
              ,RTRIM(LTRIM(@SETUP_TIME))
              ,'MINUTE'
              ,RTRIM(LTRIM(@DESCRIPTION))
              ,@USER_ID,dbo.SYSDATE1(),@USER_ID,dbo.SYSDATE1()
            )
          ;
        
        commit;
        
        begin tran
          INSERT INTO HIS_SETUP_CONDITION_M (
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
          SELECT COMPANY_ID
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
                ,'DELETE' as JOB_TYPE
          FROM   SCM_SETUP_CONDITION_M A(NOLOCK)
          WHERE  COMPANY_ID           = RTRIM(LTRIM(@COMPANY_ID))
          AND    DIVISION_ID          = RTRIM(LTRIM(@DIVISION_ID))
          AND    SITE_ID              = RTRIM(LTRIM(@SITE_ID))
          AND    PLANT_ID             = RTRIM(LTRIM(@PLANT_ID))
          AND    OPERATION_ID         = RTRIM(LTRIM(@OPERATION_ID))
          and    LINE_SETUP_GROUP_ID  = RTRIM(LTRIM(@LINE_SETUP_GROUP_ID))
          and    SETUP_CATEGORY_ID    = RTRIM(LTRIM(@SETUP_CATEGORY_ID))
          and    SETUP_KEY_ID         = RTRIM(LTRIM(@SETUP_KEY_ID))
          and    SETUP_CONDITION_ID   = RTRIM(LTRIM(@SETUP_CONDITION_ID))
          ;
        
        commit;
        
        begin tran
          UPDATE SCM_SETUP_MATRIX_M SET
                 SETUP_TIME   = RTRIM(LTRIM(@SETUP_TIME))
                ,UPDATE_ID    = @USER_ID
                ,UPDATE_TIME  = dbo.SYSDATE1()
          WHERE  COMPANY_ID           = RTRIM(LTRIM(@COMPANY_ID))
          AND    DIVISION_ID          = RTRIM(LTRIM(@DIVISION_ID))
          AND    SITE_ID              = RTRIM(LTRIM(@SITE_ID))
          AND    PLANT_ID             = RTRIM(LTRIM(@PLANT_ID))
          AND    OPERATION_ID         = RTRIM(LTRIM(@OPERATION_ID))
          AND    LINE_SETUP_GROUP_ID  = RTRIM(LTRIM(@LINE_SETUP_GROUP_ID))
          AND    SETUP_CATEGORY_ID    = RTRIM(LTRIM(@SETUP_CATEGORY_ID))
          AND    SETUP_KEY_ID         = RTRIM(LTRIM(@SETUP_KEY_ID))
          AND    SETUP_CONDITION_ID   = RTRIM(LTRIM(@SETUP_CONDITION_ID))
          ;
        
        commit;
        
      end;