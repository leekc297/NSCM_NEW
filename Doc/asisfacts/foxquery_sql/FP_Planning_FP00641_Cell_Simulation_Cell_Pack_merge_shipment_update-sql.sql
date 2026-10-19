BEGIN
					        BEGIN TRAN
					          MERGE INTO FP_AMEND_PLAN_PACK_SALES_R A
					          USING (SELECT UPPER(@INSTANCE_ID) AS INSTANCE_ID, UPPER(@FP_PLAN_ID) AS FP_PLAN_ID,
					                        UPPER(@DIVISION_ID) AS DIVISION_ID, UPPER(@CATEGORY_ID) AS CATEGORY_ID, UPPER(@SITE_ID) AS SITE_ID,
					                        UPPER(@PLANT_ID) AS PLANT_ID, UPPER(@TOP_ITEM_ID) AS TOP_ITEM_ID, 
					                        @PLAN_DATE AS PLAN_DATE ) B
					          ON (    A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID
					              AND A.DIVISION_ID = B.DIVISION_ID AND A.CATEGORY_ID = B.CATEGORY_ID AND A.SITE_ID = B.SITE_ID
					              AND A.PLANT_ID = B.PLANT_ID AND A.TOP_ITEM_ID = B.TOP_ITEM_ID
					              AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE )
					          WHEN MATCHED THEN
					            UPDATE SET SALES_QTY = ISNULL(@SALES_QTY,0)
					                     , UPDATE_ID = @USER_ID
					                     , UPDATE_TIME = dbo.FN_SITE_TIME(@SITE_ID)
					          WHEN NOT MATCHED THEN
					            INSERT (
					    		         INSTANCE_ID
						               , FP_PLAN_ID
						               , COMPANY_ID
						               , DIVISION_ID
						               , CATEGORY_ID
						               , SITE_ID
						               , PLANT_ID
						               , ITEM_ID
						               , OPERATION_ID
						               , FACTORY_ID
						               , LOCATION
						               , PRODUCTION_TYPE
						               , MARKET
						               , LINE_ID
						               , ELECTRODE_TYPE
						               , PLAN_DATE
						               , TOP_ITEM_ID
						               , SALES_QTY
						               , INSERT_ID
						               , INSERT_TIME
						               , UPDATE_ID
						               , UPDATE_TIME
						            )
					            VALUES (
					    		         @INSTANCE_ID
						               , @FP_PLAN_ID
						               ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = @DIVISION_ID AND SITE_ID = @SITE_ID AND PLANT_ID = @PLANT_ID AND ACTIVE_FLAG = 'Y')
						               , @DIVISION_ID
						               , @CATEGORY_ID
						               , @SITE_ID
						               , @PLANT_ID
						               , @TOP_ITEM_ID
						               , '-'
						               , '-'
						               , '-'
						               , '-'
						               , '-'
						               , '-'
						               , '-'
						               , CONVERT(DATETIME, @PLAN_DATE)
						               , @TOP_ITEM_ID
						               , ISNULL(@SALES_QTY,0)
						               , @USER_ID
						               , dbo.FN_SITE_TIME(@SITE_ID)
						               , @USER_ID
						               , dbo.FN_SITE_TIME(@SITE_ID)
						            )
						          ;
					        
					        COMMIT;
					        
					        BEGIN TRAN
					            INSERT INTO HIS_AMEND_PLAN_PACK_R (
					                   INSTANCE_ID, FP_PLAN_ID
					                  ,COMPANY_ID, DIVISION_ID
					                  ,CATEGORY_ID
					                  ,SITE_ID, PLANT_ID,ITEM_ID, OPERATION_ID, FACTORY_ID
					                  ,LOCATION, PRODUCTION_TYPE, MARKET
					                  ,LINE_ID, ELECTRODE_TYPE
					                  ,PLAN_DATE
					                  ,TOP_ITEM_ID
					                  ,OUT_QTY
					                  ,INSERT_ID, INSERT_TIME
					                  ,UPDATE_ID, UPDATE_TIME
					                  ,DATE_SEQ
					                  ,JOB_USER_ID, JOB_TIME, JOB_TYPE
					            )
					            SELECT INSTANCE_ID, FP_PLAN_ID
					                  ,COMPANY_ID, DIVISION_ID
					                  ,CATEGORY_ID
					                  ,SITE_ID, PLANT_ID,ITEM_ID, OPERATION_ID, FACTORY_ID
					                  ,LOCATION, PRODUCTION_TYPE, MARKET
					                  ,LINE_ID, ELECTRODE_TYPE
					                  ,PLAN_DATE
					                  ,TOP_ITEM_ID
					                  ,@SALES_QTY AS OUT_QTY
					                  ,INSERT_ID, INSERT_TIME
					                  ,UPDATE_ID, UPDATE_TIME
					                  ,@SEQ
					                  ,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'MERGE_SHIP_SIMUL' AS JOB_TYPE
					            FROM   FP_AMEND_PLAN_PACK_SALES_R A WITH(NOLOCK)
					            WHERE  A.INSTANCE_ID      = @INSTANCE_ID
					            AND    A.FP_PLAN_ID       = @FP_PLAN_ID
					            AND    A.DIVISION_ID      = @DIVISION_ID
					            AND    A.CATEGORY_ID      = @CATEGORY_ID
					            AND    A.SITE_ID          = @SITE_ID
					            AND    A.PLANT_ID         = @PLANT_ID
					            AND    A.TOP_ITEM_ID      = @TOP_ITEM_ID
					            AND    A.PLAN_DATE        = CONVERT(DATE,@PLAN_DATE)
					            ;
					          
					        COMMIT;
					        
					END;