MERGE INTO TH_UIS_ROLE_INSTANCE A
            USING (
              SELECT @ROLE_ID AS ROLE_ID
            ) B
            ON (
              A.ROLE_ID = B.ROLE_ID
            )
            WHEN MATCHED THEN
              UPDATE SET
                     ROLE_NAME   = @ROLE_NAME
                   , ROLE_DESCR  = @ROLE_DESCR
                   , APPROVAL_EXCEPTION_FLAG = ISNULL(@APPROVAL_EXCEPTION_FLAG, 'N')
                   , UPDATE_ID   = @USER_ID
                   , UPDATE_DTTM = dbo.SYSDATE1()
            WHEN NOT MATCHED THEN
              INSERT (
          			 ROLE_ID
          			,ROLE_NAME
          			,UPPER_ROLE_ID
          			,ROLE_DESCR
          			,ROLE_DETAIL_ORDER
          			,APPROVAL_EXCEPTION_FLAG
          			,INSERT_ID
          			,INSERT_DTTM
              )
              VALUES (
          			 (SELECT MAX(CONVERT(NUMERIC,ROLE_ID))+1 FROM TH_UIS_ROLE_INSTANCE A)
          			,@ROLE_NAME
          			,@UPPER_ROLE_ID
          			,@ROLE_DESCR
          			,(SELECT MAX(ROLE_DETAIL_ORDER)+1 FROM TH_UIS_ROLE_INSTANCE A WHERE A.UPPER_ROLE_ID = @UPPER_ROLE_ID)
          			,ISNULL(@APPROVAL_EXCEPTION_FLAG, 'N')
          			,@USER_ID
          			,dbo.SYSDATE1()
              )
              ;