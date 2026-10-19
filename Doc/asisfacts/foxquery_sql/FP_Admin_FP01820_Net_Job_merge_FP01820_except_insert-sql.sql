BEGIN
              BEGIN TRAN
                
                MERGE INTO JOB_SCHEDULE_EXCEPTION A
                USING ( SELECT @GROUP_ID AS GROUP_ID, @DIVISION_ID AS DIVISION_ID, @START_DATE AS START_DATE, @END_DATE AS END_DATE ) B
                  ON  A.GROUP_ID    = B.GROUP_ID
                  AND A.DIVISION_ID = B.DIVISION_ID
                  AND CONVERT(VARCHAR, A.START_DATE, 120) = B.START_DATE
                  AND CONVERT(VARCHAR, A.END_DATE, 120)   = B.END_DATE
                  AND A.START_DATE > dbo.SYSDATE1()
                WHEN MATCHED THEN
                  UPDATE SET
                        MODIFY_USER_ID = @USER_ID
                    	, MODIFY_DATE = dbo.SYSDATE1()
                    	, VALID = @VALID
                WHEN NOT MATCHED THEN
                  INSERT (
                        GROUP_ID, DIVISION_ID, VALID, START_DATE, END_DATE
                      , CREATE_USER_ID, CREATE_DATE, MODIFY_USER_ID, MODIFY_DATE
                  )
                  VALUES (
                        @GROUP_ID, @DIVISION_ID, @VALID, CONVERT(DATETIME, @START_DATE), CONVERT(DATETIME, @END_DATE)
                      , @USER_ID, dbo.SYSDATE1(), @USER_ID, dbo.SYSDATE1()
                  )
                ;
                
              COMMIT;
              
            END;