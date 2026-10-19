BEGIN
				        BEGIN TRAN
				          MERGE INTO FP_AMEND_SETUP_COLOR_M A
				          USING (	  	SELECT @INSTANCE_ID AS INSTANCE_ID,
		  				                       @DIVISION_ID AS DIVISION_ID, @SITE_ID AS SITE_ID,@PLANT_ID AS PLANT_ID, @FACTORY_ID AS FACTORY_ID, 
		  				                       @OPERATION_ID AS OPERATION_ID, @LINE_ID AS LINE_ID, @ELECTRODE_TYPE AS ELECTRODE_TYPE,
		  				                       (CASE WHEN @EQUIPMENT_ID IS NULL OR @EQUIPMENT_ID = '' THEN '-' ELSE @EQUIPMENT_ID END) AS EQUIPMENT_ID,
		  				                       @TOP_ITEM_ID AS TOP_ITEM_ID, @ITEM_ID AS ITEM_ID, @PLAN_DATE AS PLAN_DATE,
		  				                       @PRODUCTION_TYPE AS PRODUCTION_TYPE, @MARKET AS MARKET, ISNULL(@SEQ,0) AS SEQ, @SETUP_COLOR_CODE AS SETUP_COLOR_CODE
		   		                 ) B
				          ON (    A.INSTANCE_ID 	= B.INSTANCE_ID
				              AND A.FACTORY_ID 		= B.FACTORY_ID
				              AND A.OPERATION_ID 	= B.OPERATION_ID 
				              AND A.LINE_ID 		= B.LINE_ID 
				              AND A.ELECTRODE_TYPE 	= B.ELECTRODE_TYPE
				              AND ISNULL(A.EQUIPMENT_ID,'-') = B.EQUIPMENT_ID 
				              AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE
				              AND A.TOP_ITEM_ID 	= B.TOP_ITEM_ID 
				              AND A.ITEM_ID 		= B.ITEM_ID
				              AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE 
				              AND A.MARKET 			= B.MARKET 
				              AND A.SEQ 			= B.SEQ )
				          WHEN MATCHED THEN
				            UPDATE SET SETUP_COLOR_CODE = @SETUP_COLOR_CODE
				                 , UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(B.SITE_ID)
				          WHEN NOT MATCHED THEN
				            INSERT (
				               INSTANCE_ID
				              ,COMPANY_ID
				              ,DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
				              ,OPERATION_ID, LINE_ID, ELECTRODE_TYPE
				              ,EQUIPMENT_ID, PLAN_DATE
				              ,TOP_ITEM_ID, ITEM_ID
				              ,PRODUCTION_TYPE, MARKET
				              ,SEQ
				              ,SETUP_COLOR_CODE
				              ,INSERT_ID, INSERT_TIME
				              ,UPDATE_ID, UPDATE_TIME
				            )
				            VALUES (
				               B.INSTANCE_ID
				              ,(SELECT MAX(COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = B.FACTORY_ID AND ACTIVE_FLAG = 'Y')
				              ,B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID
				              ,B.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE
				              ,B.EQUIPMENT_ID ,CONVERT(DATETIME,B.PLAN_DATE)
				              ,B.TOP_ITEM_ID, B.ITEM_ID
				              ,B.PRODUCTION_TYPE, B.MARKET
				              ,B.SEQ
				              ,B.SETUP_COLOR_CODE
				              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
				              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
				            )
				          ;
				        
				        COMMIT;
					END;