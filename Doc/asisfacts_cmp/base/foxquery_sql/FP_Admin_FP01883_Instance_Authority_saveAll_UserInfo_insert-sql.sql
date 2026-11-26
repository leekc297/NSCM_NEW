BEGIN TRAN
        			INSERT TH_UIS_USER_INSTANCE_RELATE (
        				USER_ID,
        				ROLE_ID,
        				USE_AT_FLAG,
        				SAVE_FLAG,
        				INSERT_ID,
        				INSERT_DTTM
        			)
        			VALUES (
        				@USER_ID_ALTER,
        				@ROLE_ID, 
        				(CASE @USE_AT_FLAG WHEN 'True' THEN 'Y' WHEN 'Y' THEN 'Y' ELSE 'N' END),
        				(CASE @SAVE_FLAG WHEN 'True' THEN 'Y' WHEN 'Y' THEN 'Y' ELSE 'N' END),
        				@USER_ID, 
        				dbo.SYSDATE1()
        			)
        			;
        		
        		COMMIT;
        		
        		
      		  BEGIN
      		    
        			DELETE FROM FP_AMEND_USER_RESOURCES
        			WHERE USER_ID = @USER_ID_ALTER
        			;
      			  
        			INSERT INTO FP_AMEND_USER_RESOURCES (
        			    USER_ID, RESOURCE_ID, LINE_ID, EDITABLE_FLAG
        			)
        			SELECT USER_ID, LINE_ID, ORG_LINE_ID, 'N' AS EDITABLE_FLAG
        			FROM (
                  SELECT DISTINCT @USER_ID_ALTER AS USER_ID
            					 , CASE WHEN A.ELECTRODE_TYPE='-' THEN A.LINE_ID+'_'+A.OPERATION_ID 
            					                                  ELSE A.LINE_ID+'_'+A.OPERATION_ID+'_'+A.ELECTRODE_TYPE END AS LINE_ID
            					 , A.LINE_ID AS ORG_LINE_ID
                  FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)
                  WHERE  A.USER_ID = @USER_ID_ALTER
        			) A
        			GROUP BY USER_ID, LINE_ID, ORG_LINE_ID
        			;
      		  END;