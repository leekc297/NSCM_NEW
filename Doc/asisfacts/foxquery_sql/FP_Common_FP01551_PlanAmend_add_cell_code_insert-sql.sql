BEGIN
						
					      	MERGE INTO FP_DEMAND_PACK_REQUIRE_CELL_H AS A
					      	USING (
					            SELECT @INSTANCE_ID AS INSTANCE_ID
					                  ,@PLAN_ID AS PLAN_ID
						              ,@COMPANY_ID AS COMPANY_ID
						              ,@DIVISION_ID AS DIVISION_ID
						              ,@SITE_ID AS SITE_ID
						              ,@PLANT_ID AS PLANT_ID
						              ,@CELL_ITEM_ID AS CELL_ITEM_ID
						              ,@STORAGE_ID AS STORAGE_ID
						              ,@SOC_ID AS SOC_ID
						              ,@MARKET AS MARKET
						              ,@DATE AS REQUIRE_DATE
						              ,@QTY AS REQUIRE_QTY
					      	) AS B
					      	ON  A.INSTANCE_ID     = B.INSTANCE_ID
					      	AND A.PLAN_ID		  = B.PLAN_ID
					        AND A.DIVISION_ID     = B.DIVISION_ID
					        AND A.SITE_ID      	  = B.SITE_ID
					        AND A.PLANT_ID        = B.PLANT_ID
					        AND A.CELL_ITEM_ID    = B.CELL_ITEM_ID
					        AND A.STORAGE_ID      = B.STORAGE_ID
					        AND A.SOC_ID  		  = B.SOC_ID
					        AND A.MARKET    	  = B.MARKET
					        AND A.REQUIRE_DATE    = B.REQUIRE_DATE
					        WHEN MATCHED THEN
					      		UPDATE SET 	REQUIRE_QTY 	= B.REQUIRE_QTY
					      				  , UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(B.SITE_ID)
					      	WHEN NOT MATCHED BY TARGET THEN
					      		INSERT (
					               		INSTANCE_ID
					               	  ,PLAN_ID
						              ,COMPANY_ID
						              ,DIVISION_ID
						              ,SITE_ID
						              ,PLANT_ID
						              ,CELL_ITEM_ID
						              ,STORAGE_ID
						              ,SOC_ID
						              ,MARKET
						              ,REQUIRE_DATE
						              ,REQUIRE_QTY
						              ,INSERT_ID, INSERT_TIME
						              ,UPDATE_ID, UPDATE_TIME
					      		)
					      		VALUES (
					               B.INSTANCE_ID
					              ,B.PLAN_ID
					              ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = B.DIVISION_ID AND SITE_ID = B.SITE_ID AND PLANT_ID = B.PLANT_ID AND ACTIVE_FLAG = 'Y')
					              ,B.DIVISION_ID
					              ,B.SITE_ID
					              ,B.PLANT_ID
					              ,B.CELL_ITEM_ID
					              ,B.STORAGE_ID
					              ,B.SOC_ID
					              ,B.MARKET
					              ,B.REQUIRE_DATE
					              ,B.REQUIRE_QTY
					              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
					              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
					      		)
					          ;
					      	  
					        INSERT INTO HIS_DEMAND_PACK_REQUIRE_CELL_H (
					               	INSTANCE_ID
					              ,PLAN_ID
					              ,COMPANY_ID
					              ,DIVISION_ID
					              ,SITE_ID
					              ,PLANT_ID
					              ,CELL_ITEM_ID
					              ,STORAGE_ID
					              ,SOC_ID
					              ,MARKET
					              ,REQUIRE_DATE
					              ,REQUIRE_QTY
					              ,INSERT_ID, INSERT_TIME
					              ,UPDATE_ID, UPDATE_TIME
					              ,JOB_USER_ID, JOB_TIME,JOB_TYPE
					        )
					        SELECT @INSTANCE_ID
					              ,@PLAN_ID
					              ,@COMPANY_ID
					              ,@DIVISION_ID
					              ,@SITE_ID
					              ,@PLANT_ID
					              ,@CELL_ITEM_ID
					              ,@STORAGE_ID
					              ,@SOC_ID
					              ,@MARKET
					              ,@DATE
					              ,@QTY
					              ,@USER_ID AS INSERT_ID, dbo.FN_SITE_TIME(@SITE_ID) AS INSERT_TIME
					              ,@USER_ID AS UPDATE_ID, dbo.FN_SITE_TIME(@SITE_ID) AS UPDATE_TIME
					              ,@USER_ID AS JOB_USER_ID, dbo.FN_SITE_TIME(@SITE_ID) AS JOB_TIME, 'ADD' AS JOB_TYPE
					       ;
					      	
				      END;