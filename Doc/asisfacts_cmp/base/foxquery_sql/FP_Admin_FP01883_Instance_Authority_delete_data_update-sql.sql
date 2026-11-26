BEGIN
          		DELETE FROM TH_UIS_ROLE_INSTANCE
          		WHERE  ROLE_ID = @ROLE_ID
          		;
          		
          		DELETE FROM TH_UIS_ROLE_INSTANCE_RELATE
          		WHERE  ROLE_ID = @ROLE_ID
          		;
          		
          		DELETE FROM TH_UIS_USER_INSTANCE_RELATE
          		WHERE	 ROLE_ID = @ROLE_ID
          		;
          		
          	END;