MERGE INTO TH_UIS_USER_ROLE_RELATE A
          USING (SELECT @NEW_USER_ID AS NEW_USER_ID, (CASE WHEN @MENU_AUTHORITY_ID = 'PLANNER' THEN 'RA10101007'
                                                           WHEN @MENU_AUTHORITY_ID = 'VIEWER'  THEN 'RA10101016' ELSE 'RA10101016' END) AS ROLE_ID ) B
          ON ( A.USER_ID = B.NEW_USER_ID AND A.ROLE_ID = B.ROLE_ID )
          WHEN MATCHED THEN
            UPDATE SET USE_AT_FLAG = 'Y'
                 , UPDATE_ID = @USER_ID, UPDATE_DTTM = GETDATE()
          WHEN NOT MATCHED THEN
            INSERT (
                 USER_ID
               , ROLE_ID
               , APPLY_DTTM
               , USE_AT_FLAG
               , INSERT_ID, INSERT_DTTM
               , UPDATE_ID, UPDATE_DTTM
            )
            VALUES (
                 B.NEW_USER_ID
               , B.ROLE_ID
               , GETDATE()
               , 'Y'
               , @USER_ID, GETDATE()
               , NULL, NULL
            )
          ;
          
          
          MERGE INTO TB_FX_USERGROUPINFO_SN A
          USING ( SELECT 'Guest' AS GroupID, @NEW_USER_ID AS UserID ) B
          ON ( A.GroupID = B.GroupID AND A.UserID = B.UserID )
          WHEN NOT MATCHED THEN
            INSERT (
      				  GroupID
      				, UserID
      				, UseYN
      				, RegtUserID
      				, RegtDateTime
      				, UpdateUserID
      				, UpdateDateTime
            )
            VALUES (
      				  B.GroupID
      				, B.UserID
      				, 'Y'
      				, @USER_ID
      				, GETDATE()
      				, @USER_ID
      				, GETDATE()
            )
          ;