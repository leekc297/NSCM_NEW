BEGIN

							BEGIN TRAN
							  MERGE INTO FP_CELL_DELIVERY_PLAN_H A
							  USING (SELECT @INSTANCE_ID AS INSTANCE_ID, @PLAN_ID AS PLAN_ID, @DIVISION_ID AS DIVISION_ID, @SITE_ID AS SITE_ID, @PLANT_ID AS PLANT_ID, 
							  				@ITEM_ID AS ITEM_ID, @STORAGE_ID AS STORAGE_ID, @SOC_ID AS SOC_ID,
							                @MARKET AS MARKET, @DELIVERY_DATE AS DELIVERY_DATE) B
							  ON (    A.INSTANCE_ID = B.INSTANCE_ID 
							  	  AND A.PLAN_ID = B.PLAN_ID 
							      AND A.DIVISION_ID = B.DIVISION_ID 
							      AND A.SITE_ID = B.SITE_ID
							      AND A.PLANT_ID = B.PLANT_ID 
							      AND A.ITEM_ID = B.ITEM_ID
							      AND A.STORAGE_ID = B.STORAGE_ID 
							      AND A.SOC_ID = B.SOC_ID
							      AND CONVERT(VARCHAR,A.DELIVERY_DATE,112) = B.DELIVERY_DATE)
							  WHEN MATCHED THEN
							    UPDATE SET DELIVERY_QTY = @DELIVERY_QTY
							             ,  UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(@SITE_ID)
							  WHEN NOT MATCHED THEN
							    INSERT (
							       INSTANCE_ID
							      ,PLAN_ID
							      ,COMPANY_ID
							      ,DIVISION_ID
							      ,SITE_ID
							      ,PLANT_ID
							      ,ITEM_ID
							      ,STORAGE_ID
							      ,SOC_ID
							      ,MARKET
							      ,DELIVERY_DATE
							      ,DELIVERY_QTY
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
							      ,@ITEM_ID
							      ,@STORAGE_ID
							      ,@SOC_ID
							      ,@MARKET
							      ,CONVERT(DATE,@DELIVERY_DATE)
							      ,@DELIVERY_QTY
							      ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
							      ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
							    )
							  ;
							
							COMMIT;
						
							BEGIN TRAN
							    INSERT INTO HIS_CELL_DELIVERY_PLAN_H (
							           INSTANCE_ID
							          ,PLAN_ID 
							          ,COMPANY_ID
							          ,DIVISION_ID
							          ,SITE_ID
							          ,PLANT_ID
							          ,ITEM_ID
							          ,STORAGE_ID
							          ,SOC_ID
							          ,MARKET
							          ,DELIVERY_DATE
							          ,DELIVERY_QTY
							          ,INSERT_ID, INSERT_TIME
							          ,UPDATE_ID, UPDATE_TIME
							    )
							    SELECT INSTANCE_ID
							          ,PLAN_ID
							          ,COMPANY_ID
							          ,DIVISION_ID
							          ,SITE_ID
							          ,PLANT_ID
							          ,ITEM_ID
							          ,STORAGE_ID
							          ,SOC_ID
							          ,MARKET
							          ,DELIVERY_DATE
							          ,DELIVERY_QTY
							          ,INSERT_ID, INSERT_TIME
							          ,UPDATE_ID, UPDATE_TIME
							    FROM   FP_CELL_DELIVERY_PLAN_H A WITH(NOLOCK)
							    WHERE  A.INSTANCE_ID      = @INSTANCE_ID
							    AND	   A.PLAN_ID		  = @PLAN_ID
							    AND    A.DIVISION_ID      = @DIVISION_ID
							    AND    A.SITE_ID          = @SITE_ID
							    AND    A.PLANT_ID         = @PLANT_ID
							    AND    A.ITEM_ID     	  = @ITEM_ID
							    AND    A.STORAGE_ID       = @STORAGE_ID
							    AND    A.SOC_ID       	  = @SOC_ID
							    AND    A.MARKET           = @MARKET
							    AND    A.DELIVERY_DATE    = CONVERT(DATE,@DELIVERY_DATE)
							    ;
							  
							COMMIT;
						
						END;