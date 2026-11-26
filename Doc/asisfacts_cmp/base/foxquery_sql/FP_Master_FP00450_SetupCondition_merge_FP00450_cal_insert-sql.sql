begin
        begin tran
          MERGE INTO SCM_SETUP_MATRIX_M AS A
          USING (SELECT RTRIM(LTRIM(@COMPANY_ID)) AS COMPANY_ID, RTRIM(LTRIM(@DIVISION_ID)) AS DIVISION_ID, RTRIM(LTRIM(@SITE_ID)) AS SITE_ID, RTRIM(LTRIM(@PLANT_ID)) AS PLANT_ID
                       ,RTRIM(LTRIM(@LINE_SETUP_GROUP_ID)) AS LINE_SETUP_GROUP_ID, RTRIM(LTRIM(@SETUP_CATEGORY_ID)) AS SETUP_CATEGORY_ID
                       ,RTRIM(LTRIM(@SETUP_KEY_ID)) AS SETUP_KEY_ID, RTRIM(LTRIM(@OPERATION_ID)) AS OPERATION_ID
                       ,RTRIM(LTRIM(@FROM_ITEM_SETUP_GROUP_ID)) AS FROM_ITEM_SETUP_GROUP_ID, RTRIM(LTRIM(@TO_ITEM_SETUP_GROUP_ID)) AS TO_ITEM_SETUP_GROUP_ID
                       ,RTRIM(LTRIM(@SETUP_CONDITION_ID)) AS SETUP_CONDITION_ID) AS B
            ON (A.COMPANY_ID                = B.COMPANY_ID
            AND A.DIVISION_ID               = B.DIVISION_ID
            AND A.SITE_ID                   = B.SITE_ID
            AND A.PLANT_ID                  = B.PLANT_ID
            AND A.LINE_SETUP_GROUP_ID       = B.LINE_SETUP_GROUP_ID
            AND A.SETUP_CATEGORY_ID         = B.SETUP_CATEGORY_ID
            AND A.SETUP_KEY_ID              = B.SETUP_KEY_ID
            AND A.FROM_ITEM_SETUP_GROUP_ID  = B.FROM_ITEM_SETUP_GROUP_ID
            AND A.TO_ITEM_SETUP_GROUP_ID    = B.TO_ITEM_SETUP_GROUP_ID
            AND A.SETUP_CONDITION_ID        = B.SETUP_CONDITION_ID
			      AND A.OPERATION_ID              = B.OPERATION_ID)
          WHEN MATCHED THEN 
            UPDATE SET 
                UPDATE_ID       = @USER_ID
               ,UPDATE_TIME     = dbo.SYSDATE1()
               ,ADJUST_CELL_QTY = @ADJUST_CELL_QTY
          WHEN NOT MATCHED THEN 
            INSERT (
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
              ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
            ) VALUES (
               RTRIM(LTRIM(@COMPANY_ID))
              ,RTRIM(LTRIM(@DIVISION_ID))
              ,RTRIM(LTRIM(@SITE_ID))
              ,RTRIM(LTRIM(@PLANT_ID))
              ,RTRIM(LTRIM(@LINE_SETUP_GROUP_ID))
              ,RTRIM(LTRIM(@SETUP_CATEGORY_ID))
              ,RTRIM(LTRIM(@SETUP_KEY_ID))
              ,RTRIM(LTRIM(@FROM_ITEM_SETUP_GROUP_ID))
              ,RTRIM(LTRIM(@TO_ITEM_SETUP_GROUP_ID))
              ,RTRIM(LTRIM(@SETUP_CONDITION_ID))
              ,RTRIM(LTRIM(@OPERATION_ID))
              ,RTRIM(LTRIM(@SETUP_TIME))
              ,'MINUTE'
              ,RTRIM(LTRIM(@ADJUST_CELL_QTY))
              ,RTRIM(LTRIM(@DESCRIPTION))
              ,@USER_ID,dbo.SYSDATE1(),@USER_ID,dbo.SYSDATE1()
            )
          ;
        
        commit;
        
        begin tran
          INSERT INTO HIS_SETUP_MATRIX_M (
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
                ,'EXCEL' as JOB_TYPE
          FROM  SCM_SETUP_MATRIX_M A(NOLOCK)
          WHERE COMPANY_ID                = RTRIM(LTRIM(@COMPANY_ID))
          AND   DIVISION_ID               = RTRIM(LTRIM(@DIVISION_ID))
          AND   SITE_ID                   = RTRIM(LTRIM(@SITE_ID))
          AND   PLANT_ID                  = RTRIM(LTRIM(@PLANT_ID))
          AND   LINE_SETUP_GROUP_ID       = RTRIM(LTRIM(@LINE_SETUP_GROUP_ID))
          AND   SETUP_CATEGORY_ID         = RTRIM(LTRIM(@SETUP_CATEGORY_ID))
          AND   SETUP_KEY_ID              = RTRIM(LTRIM(@SETUP_KEY_ID))
          AND   FROM_ITEM_SETUP_GROUP_ID  = RTRIM(LTRIM(@FROM_ITEM_SETUP_GROUP_ID))
          AND   TO_ITEM_SETUP_GROUP_ID    = RTRIM(LTRIM(@TO_ITEM_SETUP_GROUP_ID))
          AND   SETUP_CONDITION_ID        = RTRIM(LTRIM(@SETUP_CONDITION_ID))
          ;
        
        commit;
      end;