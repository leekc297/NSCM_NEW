BEGIN
		        BEGIN TRAN
		          
		          UPDATE SCM_FCS_TRAY_MODEL_M 
		          SET
		                 USE_YN 		= @ACTIVE_FLAG
		                ,UPDATE_ID 		= @USER_ID
		                ,UPDATE_DATE	= dbo.FN_SITE_TIME(@SITE_ID)
		          WHERE  COMPANY_ID		= @COMPANY_ID
		          AND    DIVISION_ID 	= @DIVISION_ID
		          AND    SITE_ID 		= @SITE_ID
		          AND    PLANT_ID 		= @PLANT_ID
		          AND    FACTORY_ID 		= @FACTORY_ID
		          AND    LINE_ID 		= @LINE_ID
		          AND    TRAY_TYPE_CODE = @TRAY_ID
		          AND    ITEM_ID 		= @ITEM_ID
		          ;
		        
		        COMMIT;
	        
	      END;