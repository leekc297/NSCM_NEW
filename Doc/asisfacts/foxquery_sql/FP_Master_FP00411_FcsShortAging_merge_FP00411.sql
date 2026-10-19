BEGIN
        BEGIN TRAN
          MERGE INTO [dbo].[FP_FORMATION_SHORTER_LT_M] A
          USING ( SELECT @COMPANY_ID AS COMPANY_ID
                        ,@DIVISION_ID AS DIVISION_ID
                        ,@SITE_ID AS SITE_ID
                        ,@PLANT_ID AS PLANT_ID
                        ,@FACTORY_ID AS FACTORY_ID
                        ,@ITEM_ID AS ITEM_ID
                        ,@LINE_ID AS LINE_ID
                        ,@OPERATION_ID AS OPERATION_ID
                        ,@SHORTER_LT AS SHORTER_LT
                ) B
          ON (   A.[COMPANY_ID]  = B.[COMPANY_ID]
          AND    A.[DIVISION_ID] = B.[DIVISION_ID]
          AND    A.[SITE_ID]     = B.[SITE_ID]
          AND    A.[PLANT_ID]    = B.[PLANT_ID]
          AND    A.[FACTORY_ID]  = B.[FACTORY_ID]
          AND    A.[ITEM_ID]     = B.[ITEM_ID]
          AND    A.[LINE_ID]     = B.[LINE_ID]
          AND	 A.[OPERATION_ID] = B.[OPERATION_ID]
          )
          WHEN MATCHED THEN
           UPDATE SET
               A.[SHORTER_LT]      = @SHORTER_LT
              ,A.[UPDATE_ID]       = @USER_ID
              ,A.[UPDATE_TIME]     = dbo.FN_SITE_TIME(@SITE_ID)
          WHEN NOT MATCHED THEN
           INSERT (
               [COMPANY_ID]
              ,[DIVISION_ID]
              ,[SITE_ID]
              ,[PLANT_ID]
              ,[FACTORY_ID]
              ,[ITEM_ID]
              ,[LINE_ID]
              ,[OPERATION_ID]
              ,[SHORTER_LT]
              ,[INSERT_ID]
              ,[INSERT_TIME]
              ,[UPDATE_ID]
              ,[UPDATE_TIME]
           )
           VALUES (
               @COMPANY_ID
              ,@DIVISION_ID
              ,@SITE_ID
              ,@PLANT_ID
              ,@FACTORY_ID
              ,@ITEM_ID
              ,@LINE_ID
              ,@OPERATION_ID
              ,@SHORTER_LT
              ,@USER_ID
              ,dbo.FN_SITE_TIME(@SITE_ID)
              ,@USER_ID
              ,dbo.FN_SITE_TIME(@SITE_ID)
           );
          
        COMMIT;
        
        BEGIN TRAN
          INSERT INTO HIS_FORMATION_SHORTER_LT_M (
                 COMPANY_ID
                ,DIVISION_ID
                ,SITE_ID
                ,PLANT_ID
                ,FACTORY_ID
                ,ITEM_ID
                ,LINE_ID
                ,OPERATION_ID
                ,SHORTER_LT
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
                ,FACTORY_ID
                ,ITEM_ID
                ,LINE_ID
                ,OPERATION_ID
                ,SHORTER_LT
                ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
                ,@USER_ID AS JOB_USER_ID
                ,dbo.SYSDATE1() AS JOB_TIME
                ,'MERGE' AS JOB_TYPE
          FROM   FP_FORMATION_SHORTER_LT_M A WITH(NOLOCK)
          WHERE  A.COMPANY_ID  = @COMPANY_ID
          AND    A.DIVISION_ID = @DIVISION_ID
          AND    A.SITE_ID     = @SITE_ID
          AND    A.PLANT_ID    = @PLANT_ID
          AND    A.FACTORY_ID  = @FACTORY_ID
          AND    A.ITEM_ID     = @ITEM_ID
          AND    A.LINE_ID     = @LINE_ID
          AND	 A.OPERATION_ID = @OPERATION_ID
          ;
          
        COMMIT;
      END;