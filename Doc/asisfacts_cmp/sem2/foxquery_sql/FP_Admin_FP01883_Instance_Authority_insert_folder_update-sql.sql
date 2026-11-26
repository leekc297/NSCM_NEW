INSERT INTO TH_UIS_ROLE_INSTANCE (
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
              ,'N'
              ,@USER_ID
              ,dbo.SYSDATE1()
            )