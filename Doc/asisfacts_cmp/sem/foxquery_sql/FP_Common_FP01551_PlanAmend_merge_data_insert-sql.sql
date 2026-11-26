BEGIN
							BEGIN TRAN
						
								MERGE INTO FP_DEMAND_PACK_REQUIRE_CELL_H A
								USING (SELECT @INSTANCE_ID AS INSTANCE_ID, @PLAN_ID AS PLAN_ID, @DIVISION_ID AS DIVISION_ID, @SITE_ID AS SITE_ID, @PLANT_ID AS PLANT_ID, 
										@CELL_ITEM_ID AS CELL_ITEM_ID, @STORAGE_ID AS STORAGE_ID, @SOC_ID AS SOC_ID,
								        @MARKET AS MARKET, @REQUIRE_DATE AS REQUIRE_DATE) B
										ON (    A.INSTANCE_ID = B.INSTANCE_ID
											AND A.PLAN_ID = B.PLAN_ID 
											AND A.DIVISION_ID = B.DIVISION_ID 
											AND A.SITE_ID = B.SITE_ID
											AND A.PLANT_ID = B.PLANT_ID 
											AND A.CELL_ITEM_ID = B.CELL_ITEM_ID
											AND A.STORAGE_ID = B.STORAGE_ID 
											AND A.SOC_ID = B.SOC_ID
											AND A.MARKET = B.MARKET
											AND CONVERT(VARCHAR,A.REQUIRE_DATE,112) = B.REQUIRE_DATE
										)
								WHEN MATCHED THEN
									UPDATE SET REQUIRE_QTY = @REQUIRE_QTY
									     ,  UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(@SITE_ID)
								WHEN NOT MATCHED THEN
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
											@INSTANCE_ID
											,@PLAN_ID
											,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = @DIVISION_ID AND SITE_ID = @SITE_ID AND PLANT_ID = @PLANT_ID AND ACTIVE_FLAG = 'Y')
											,@DIVISION_ID
											,@SITE_ID
											,@PLANT_ID
											,@CELL_ITEM_ID
											,@STORAGE_ID
											,@SOC_ID
											,@MARKET
											,CONVERT(DATE,@REQUIRE_DATE)
											,@REQUIRE_QTY
											,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
											,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
										)
								;
								
							COMMIT;
						
							BEGIN TRAN
							
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
										)
								SELECT INSTANCE_ID
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
								FROM   FP_DEMAND_PACK_REQUIRE_CELL_H A WITH(NOLOCK)
								WHERE  A.INSTANCE_ID      = @INSTANCE_ID
								AND    A.PLAN_ID		  = @PLAN_ID
								AND    A.DIVISION_ID      = @DIVISION_ID
								AND    A.SITE_ID          = @SITE_ID
								AND    A.PLANT_ID         = @PLANT_ID
								AND    A.CELL_ITEM_ID     = @CELL_ITEM_ID
								AND    A.STORAGE_ID       = @STORAGE_ID
								AND    A.SOC_ID       	  = @SOC_ID
								AND    A.MARKET           = @MARKET
								AND    A.REQUIRE_DATE     = CONVERT(DATE,@REQUIRE_DATE)
								;
						
							COMMIT;
						
						END;