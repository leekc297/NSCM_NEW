BEGIN
        BEGIN TRAN
          MERGE INTO [dbo].[FP_FORMATION_SHORTER_LT_M] A
          USING ( SELECT COMPANY_ID
                        ,DIVISION_ID
                        ,SITE_ID
                        ,PLANT_ID
                        ,FACTORY_ID
                        ,ITEM_ID
                        ,LINE_ID
                        ,OPERATION_ID
                        ,SHORTER_LT
                  FROM   BUF_FORMATION_SHORTER_LT_M BB WITH(NOLOCK)
                  WHERE  BB.JOB_USER_ID = @USER_ID
                ) B
          ON (   A.[COMPANY_ID]  = B.[COMPANY_ID]
          AND    A.[DIVISION_ID] = B.[DIVISION_ID]
          AND    A.[SITE_ID]     = B.[SITE_ID]
          AND    A.[PLANT_ID]    = B.[PLANT_ID]
          AND    A.[FACTORY_ID]  = B.[FACTORY_ID]
          AND    A.[ITEM_ID]     = B.[ITEM_ID]
          AND    A.[LINE_ID]     = B.[LINE_ID]
          AND    A.[OPERATION_ID] = B.[OPERATION_ID]
          )
          WHEN MATCHED THEN
           UPDATE SET
               A.[SHORTER_LT]      = B.SHORTER_LT
              ,A.[UPDATE_ID]       = @USER_ID
              ,A.[UPDATE_TIME]     = dbo.FN_SITE_TIME(B.SITE_ID)
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
               B.COMPANY_ID
              ,B.DIVISION_ID
              ,B.SITE_ID
              ,B.PLANT_ID
              ,B.FACTORY_ID
              ,B.ITEM_ID
              ,B.LINE_ID
              ,B.OPERATION_ID
              ,B.SHORTER_LT
              ,@USER_ID
              ,dbo.FN_SITE_TIME(B.SITE_ID)
              ,@USER_ID
              ,dbo.FN_SITE_TIME(B.SITE_ID)
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
          SELECT A.COMPANY_ID
                ,A.DIVISION_ID
                ,A.SITE_ID
                ,A.PLANT_ID
                ,A.FACTORY_ID
                ,A.ITEM_ID
                ,A.LINE_ID
                ,A.OPERATION_ID
                ,A.SHORTER_LT
                ,A.INSERT_ID, A.INSERT_TIME, A.UPDATE_ID, A.UPDATE_TIME
                ,@USER_ID AS JOB_USER_ID
                ,dbo.SYSDATE1() AS JOB_TIME
                ,'EXCEL' AS JOB_TYPE
          FROM   FP_FORMATION_SHORTER_LT_M A WITH(NOLOCK)
          		,BUF_FORMATION_SHORTER_LT_M B WITH(NOLOCK)
          WHERE  B.JOB_USER_ID = @USER_ID
          AND	 A.[COMPANY_ID]  = B.[COMPANY_ID]
          AND    A.[DIVISION_ID] = B.[DIVISION_ID]
          AND    A.[SITE_ID]     = B.[SITE_ID]
          AND    A.[PLANT_ID]    = B.[PLANT_ID]
          AND    A.[FACTORY_ID]  = B.[FACTORY_ID]
          AND    A.[ITEM_ID]     = B.[ITEM_ID]
          AND    A.[LINE_ID]     = B.[LINE_ID]
          AND    A.[OPERATION_ID] = B.[OPERATION_ID]
          ;
          
        COMMIT;
      END;