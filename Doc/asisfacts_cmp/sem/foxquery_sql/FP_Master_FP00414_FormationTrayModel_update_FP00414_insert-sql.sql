BEGIN
			        BEGIN TRAN
			          
			          INSERT INTO SCM_FCS_TRAY_MODEL_M (
		                COMPANY_ID
		              , DIVISION_ID
		              , SITE_ID
		              , PLANT_ID
		              , PSEUDO_FACTORY_ID
		              , FACTORY_ID
		              , LINE_ID
		              , TRAY_TYPE_CODE
		              , ITEM_ID
		              , USE_YN
		              , INSERT_ID
		              , INSERT_DATE
		              , UPDATE_ID
		              , UPDATE_DATE
			          )
			          VALUES (
			              (SELECT MAX(COMPANY_ID) FROM SCM_PLANT_M A WITH(NOLOCK) WHERE 1=1 AND PLANT_ID = @PLANT_ID)
			            , @DIVISION_ID
			            , @SITE_ID
			            , @PLANT_ID
			            , @PSEUDO_FACTORY_ID
			            , @FACTORY_ID
			            , @LINE_ID
			            , @TRAY_ID
			            , @ITEM_ID
			            , @ACTIVE_FLAG
			            , @USER_ID
			            , GETDATE()
			            , @USER_ID
			            , GETDATE()
			          )
			          ;
			          
			        COMMIT;
		        
		      END;