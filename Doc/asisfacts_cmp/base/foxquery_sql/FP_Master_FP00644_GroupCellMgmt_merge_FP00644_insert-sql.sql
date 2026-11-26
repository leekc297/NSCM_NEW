BEGIN
        BEGIN TRAN
          MERGE INTO SCM_GROUP_CELL_M A
          USING ( SELECT @COMPANY_ID AS COMPANY_ID
                        ,@DIVISION_ID AS DIVISION_ID
                        ,@SITE_ID AS SITE_ID
                        ,@PLANT_ID AS PLANT_ID
                        ,@GROUP_CELL_ID AS GROUP_CELL_ID
                        ,@ITEM_ID AS ITEM_ID
                        ,@DESCRIPTION AS DESCRIPTION
                        ,@USE_FLAG AS USE_FLAG
                ) B
          ON (   A.COMPANY_ID  = B.COMPANY_ID
          AND    A.DIVISION_ID = B.DIVISION_ID
          AND    A.SITE_ID     = B.SITE_ID
          AND    A.PLANT_ID    = B.PLANT_ID
          AND    A.ITEM_ID     = B.ITEM_ID
          )
          WHEN MATCHED THEN
           UPDATE SET
               A.GROUP_CELL_ID    	= @GROUP_CELL_ID
              ,A.DESCRIPTION      	= @DESCRIPTION
              ,A.USE_FLAG      			= @USE_FLAG
              ,A.UPDATE_ID	       	= @USER_ID
              ,A.UPDATE_TIME     		= dbo.FN_SITE_TIME(@SITE_ID)
          WHEN NOT MATCHED THEN
           INSERT (
               COMPANY_ID
              ,DIVISION_ID
              ,SITE_ID
              ,PLANT_ID
              ,GROUP_CELL_ID
              ,ITEM_ID
              ,DESCRIPTION
              ,USE_FLAG
              ,INSERT_ID
              ,INSERT_TIME
              ,UPDATE_ID
              ,UPDATE_TIME
           )
           VALUES (
               @COMPANY_ID
              ,@DIVISION_ID
              ,@SITE_ID
              ,@PLANT_ID
              ,@GROUP_CELL_ID
              ,@ITEM_ID
              ,@DESCRIPTION
              ,@USE_FLAG
              ,@USER_ID
              ,dbo.FN_SITE_TIME(@SITE_ID)
              ,@USER_ID
              ,dbo.FN_SITE_TIME(@SITE_ID)
           );
          
        COMMIT;
        
        BEGIN TRAN
          INSERT INTO HIS_GROUP_CELL_M (
                 COMPANY_ID
                ,DIVISION_ID
                ,SITE_ID
                ,PLANT_ID
                ,GROUP_CELL_ID
                ,ITEM_ID
                ,DESCRIPTION
                ,USE_FLAG
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
                ,GROUP_CELL_ID
                ,ITEM_ID
                ,DESCRIPTION
                ,USE_FLAG
                ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
                ,@USER_ID AS JOB_USER_ID
                ,dbo.SYSDATE1() AS JOB_TIME
                ,'MERGE' AS JOB_TYPE
          FROM   SCM_GROUP_CELL_M A WITH(NOLOCK)
          WHERE  A.COMPANY_ID  = @COMPANY_ID
          AND    A.DIVISION_ID = @DIVISION_ID
          AND    A.SITE_ID     = @SITE_ID
          AND    A.PLANT_ID    = @PLANT_ID
          AND    A.ITEM_ID     = @ITEM_ID
          ;
          
        COMMIT;
      END;