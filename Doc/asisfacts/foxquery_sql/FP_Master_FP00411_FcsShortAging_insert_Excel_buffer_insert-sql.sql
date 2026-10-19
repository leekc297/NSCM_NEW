INSERT INTO BUF_FORMATION_SHORTER_LT_M (
         COMPANY_ID
        ,DIVISION_ID
        ,SITE_ID
        ,PLANT_ID
        ,FACTORY_ID
        ,LINE_ID
        ,ITEM_ID
        ,OPERATION_ID
        ,SHORTER_LT
        ,JOB_USER_ID
        ,JOB_TIME
        ,JOB_TYPE
        ,JOB_ORDER
      )
      VALUES (
          (SELECT MAX(KK.COMPANY_ID) FROM SCM_FACTORY_M KK WHERE KK.FACTORY_ID = @FACTORY_ID AND KK.ACTIVE_FLAG = 'Y')
        , @DIVISION_ID, @SITE_ID, @PLANT_ID, @FACTORY_ID
        , @LINE_ID
        , @ITEM_ID
        , @OPERATION_ID
        , @SHORTER_LT
        , @USER_ID, dbo.SYSDATE1(), 'EXCEL', @JOB_ORDER
      )