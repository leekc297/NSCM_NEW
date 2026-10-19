BEGIN
						
					        BEGIN TRAN
					          MERGE INTO FP_CELL_MOVE_PLAN_H A
					          USING ( SELECT @CATEGORY_TYPE AS CATEGORY, @COMPANY_ID AS COMPANY_ID, @DIVISION_ID AS DIVISION_ID, @SITE_ID AS SITE_ID, @PLANT_ID AS PLANT_ID
					                       , @CELL_ITEM_ID AS ITEM_ID, CONVERT(DATE, @PLAN_DATE) AS PLAN_DATE, @CELL_FACTORY_ID AS CELL_FACTORY_ID, @PACK_FACTORY_ID AS PACK_FACTORY_ID
					                       , @QTY AS QTY ) B
					          ON (    A.CATEGORY    = B.CATEGORY
					          	  AND A.COMPANY_ID  = B.COMPANY_ID
					              AND A.DIVISION_ID = B.DIVISION_ID
					              AND A.SITE_ID     = B.SITE_ID
					              AND A.PLANT_ID    = B.PLANT_ID
					              AND A.ITEM_ID     = B.ITEM_ID
					              AND A.PLAN_DATE   = B.PLAN_DATE
					              AND A.CELL_FACTORY_ID = B.CELL_FACTORY_ID
					              AND A.PACK_FACTORY_ID = B.PACK_FACTORY_ID )
					          WHEN MATCHED THEN
					            UPDATE SET QTY = B.QTY
					                     , UPDATE_ID = @USER_ID, UPDATE_DTTM = dbo.FN_SITE_TIME(B.SITE_ID)
					          WHEN NOT MATCHED THEN
					            INSERT (
					                CATEGORY
					              , COMPANY_ID
					              , DIVISION_ID
					              , SITE_ID
					              , PLANT_ID
					              , ITEM_ID
					              , PLAN_DATE
					              , CELL_FACTORY_ID
					              , PACK_FACTORY_ID
					              , QTY
					              , DESCRIPTION
					              , INSERT_ID, INSERT_DTTM
					              , UPDATE_ID, UPDATE_DTTM
					            )
					            VALUES (
					                B.CATEGORY
					              , B.COMPANY_ID
					              , B.DIVISION_ID
					              , B.SITE_ID
					              , B.PLANT_ID
					              , B.ITEM_ID
					              , B.PLAN_DATE
					              , B.CELL_FACTORY_ID
					              , B.PACK_FACTORY_ID
					              , B.QTY
					              , NULL
					              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
					              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
					            )
					          ;
					        
					        COMMIT;
					        
					        BEGIN TRAN
					            INSERT INTO HIS_CELL_MOVE_PLAN_H (
					                   CATEGORY
					                 , COMPANY_ID
					                 , DIVISION_ID
					                 , SITE_ID
					                 , PLANT_ID
					                 , ITEM_ID
					                 , PLAN_DATE
					                 , CELL_FACTORY_ID
					                 , PACK_FACTORY_ID
					                 , QTY
					                 , DESCRIPTION
					                 , INSERT_ID, INSERT_DTTM
					                 , UPDATE_ID, UPDATE_DTTM
					                 , JOB_USER_ID, JOB_TIME, JOB_TYPE
					            )
					            SELECT CATEGORY
					                 , COMPANY_ID
					                 , DIVISION_ID
					                 , SITE_ID
					                 , PLANT_ID
					                 , ITEM_ID
					                 , PLAN_DATE
					                 , CELL_FACTORY_ID
					                 , PACK_FACTORY_ID
					                 , QTY
					                 , DESCRIPTION
					                 , INSERT_ID, INSERT_DTTM
					                 , UPDATE_ID, UPDATE_DTTM
					                 , @USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'MERGE' AS JOB_TYPE
					            FROM   FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)
					            WHERE  A.CATEGORY    = @CATEGORY_TYPE
					        	AND    A.COMPANY_ID  = @COMPANY_ID
					            AND    A.DIVISION_ID = @DIVISION_ID
					            AND    A.SITE_ID     = @SITE_ID
					            AND    A.PLANT_ID    = @PLANT_ID
					            AND    A.ITEM_ID     = @CELL_ITEM_ID
					            AND    A.PLAN_DATE   = CONVERT(DATE, @PLAN_DATE)
					            AND    A.CELL_FACTORY_ID = @CELL_FACTORY_ID
					            AND    A.PACK_FACTORY_ID = @PACK_FACTORY_ID
					            ;
					          
					        COMMIT;
					        
					END;