BEGIN
	        BEGIN TRAN
	          
	          UPDATE SCM_FCS_TRAY_M 
	          SET
	                 USE_YN 		= @ACTIVE_FLAG
	                ,TRAY_TYPE_GROUP= @GROUP_TRAY_ID
	                ,CELL_CNT 		= @CELL_CNT
	                ,BUFFER_DAY 	= @BUFFER_DAY
	                ,LOAD_YIELD 	= @LOAD_YIELD
	                ,TRAY_CNT 		= @INVENTORY_CNT
	                ,INTRANSIT_CNT 	= @INTRANSIT_CNT
	                ,DESCRIPTION 	= @DESCRIPTION
	                ,UPDATE_ID 		= @USER_ID
	                ,UPDATE_DATE	= dbo.FN_SITE_TIME(@SITE_ID)
	          WHERE  COMPANY_ID		= @COMPANY_ID
	          AND    DIVISION_ID 	= @DIVISION_ID
	          AND    SITE_ID 			= @SITE_ID
	          AND    PLANT_ID 		= @PLANT_ID
	          AND    FACTORY_ID 	= @FACTORY_ID
	          AND    TRAY_TYPE_CODE = @TRAY_ID
	          ;
	          
	          INSERT INTO HIS_FCS_TRAY_M
		          (	 COMPANY_ID
					,DIVISION_ID
					,SITE_ID
					,PLANT_ID
					,FACTORY_ID
					,TRAY_TYPE_CODE
					,TRAY_TYPE_NAME
					,DEGAS_BEFORE_TYPE
					,CELL_CNT
					,LOAD_YIELD
					,BUFFER_DAY
					,TRAY_CNT
					,INTRANSIT_CNT
					,DESCRIPTION
					,USE_YN
					,INSERT_ID
					,INSERT_DATE
					,UPDATE_ID
					,UPDATE_DATE
					,TRAY_TYPE_GROUP
					,JOB_USER_ID, JOB_TIME, JOB_TYPE
		    )  
		    SELECT   COMPANY_ID
					,DIVISION_ID
					,SITE_ID
					,PLANT_ID
					,FACTORY_ID
					,TRAY_TYPE_CODE
					,TRAY_TYPE_NAME
					,DEGAS_BEFORE_TYPE
					,CELL_CNT
					,LOAD_YIELD
					,BUFFER_DAY
					,TRAY_CNT
					,INTRANSIT_CNT
					,DESCRIPTION
					,USE_YN
					,INSERT_ID
					,INSERT_DATE
					,UPDATE_ID
					,UPDATE_DATE
					,TRAY_TYPE_GROUP,
		            @USER_ID, dbo.SYSDATE1(), 'UPDATE'
		    FROM  SCM_FCS_TRAY_M A WITH(NOLOCK)
		    WHERE COMPANY_ID      = RTRIM(LTRIM(@COMPANY_ID))
		    AND   DIVISION_ID     = RTRIM(LTRIM(@DIVISION_ID))
		    AND   SITE_ID         = RTRIM(LTRIM(@SITE_ID))
		    AND   PLANT_ID        = RTRIM(LTRIM(@PLANT_ID))
		    AND   FACTORY_ID      = RTRIM(LTRIM(@FACTORY_ID))
		    AND   TRAY_TYPE_CODE  = RTRIM(LTRIM(@TRAY_ID))
		    ;
	        
	        COMMIT;
        
      END;