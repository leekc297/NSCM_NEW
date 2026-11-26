begin
        begin tran
          insert into his_setup_matrix_m (
                 COMPANY_ID
                ,DIVISION_ID
                ,SITE_ID
                ,PLANT_ID
                ,LINE_SETUP_GROUP_ID
                ,SETUP_CATEGORY_ID
                ,SETUP_KEY_ID
                ,FROM_ITEM_SETUP_GROUP_ID
                ,TO_ITEM_SETUP_GROUP_ID
                ,SETUP_CONDITION_ID
                ,OPERATION_ID
                ,SETUP_TIME
                ,SETUP_TIME_UOM
                ,ADJUST_CELL_QTY
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
                ,LINE_SETUP_GROUP_ID
                ,SETUP_CATEGORY_ID
                ,SETUP_KEY_ID
                ,FROM_ITEM_SETUP_GROUP_ID
                ,TO_ITEM_SETUP_GROUP_ID
                ,SETUP_CONDITION_ID
                ,OPERATION_ID
                ,SETUP_TIME
                ,SETUP_TIME_UOM
                ,ADJUST_CELL_QTY
                ,DESCRIPTION
                ,INSERT_ID
                ,INSERT_TIME
                ,UPDATE_ID
                ,UPDATE_TIME
                ,@USER_ID as JOB_USER_ID
                ,dbo.sysdate1() as JOB_TIME
                ,'DELETE' as JOB_TYPE
          from  scm_setup_matrix_m(NOLOCK)
          where company_id                = @COMPANY_ID
          and   division_id               = @DIVISION_ID
          and   site_id                   = @SITE_ID
          and   plant_id                  = @PLANT_ID
          and   LINE_SETUP_GROUP_ID       = @LINE_SETUP_GROUP_ID
          and   SETUP_CATEGORY_ID         = @SETUP_CATEGORY_ID
          and   SETUP_KEY_ID              = @SETUP_KEY_ID
          and   FROM_ITEM_SETUP_GROUP_ID  = @FROM_ITEM_SETUP_GROUP_ID
          and   TO_ITEM_SETUP_GROUP_ID    = @TO_ITEM_SETUP_GROUP_ID
          and   SETUP_CONDITION_ID        = @SETUP_CONDITION_ID
		      and   OPERATION_ID        = @OPERATION_ID
          ;
        
        commit;
        
        begin tran
          delete from scm_setup_matrix_m
          where company_id                = @COMPANY_ID
          and   division_id               = @DIVISION_ID
          and   site_id                   = @SITE_ID
          and   plant_id                  = @PLANT_ID
          and   LINE_SETUP_GROUP_ID       = @LINE_SETUP_GROUP_ID
          and   SETUP_CATEGORY_ID         = @SETUP_CATEGORY_ID
          and   SETUP_KEY_ID              = @SETUP_KEY_ID
          and   FROM_ITEM_SETUP_GROUP_ID  = @FROM_ITEM_SETUP_GROUP_ID
          and   TO_ITEM_SETUP_GROUP_ID    = @TO_ITEM_SETUP_GROUP_ID
          and   SETUP_CONDITION_ID        = @SETUP_CONDITION_ID
		      and   OPERATION_ID        = @OPERATION_ID
          ;
        
        commit;
      end;