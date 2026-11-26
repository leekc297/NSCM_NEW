BEGIN
              BEGIN TRAN
                
                MERGE INTO JOB_SCHEDULE_DETAIL A
                USING ( SELECT @GROUP_ID AS GROUP_ID, @DIVISION_ID AS DIVISION_ID, @ORG_JOB_ID AS JOB_ID, @ORG_NO AS NO ) B
                  ON  A.GROUP_ID    = B.GROUP_ID
                  AND A.DIVISION_ID = B.DIVISION_ID
                  AND A.JOB_ID      = B.JOB_ID
                  AND A.NO          = B.NO
                WHEN MATCHED THEN
                  UPDATE SET
                      JOB_ID      = @JOB_ID,
                      NO          = @NO,
                      JOB_DESC    = @JOB_DESC,
                      JOB_TYPE    = @JOB_TYPE,
                      SEQ         = @SEQ,
                      PARAMETER1  = @PARAMETER1,
                      PARAMETER2  = @PARAMETER2,
                      PARAMETER3  = @PARAMETER3,
                      PARAMETER4  = @PARAMETER4,
                      PARAMETER5  = @PARAMETER5,
                      MODIFY_USER_ID = @USER_ID,
                      MODIFY_DATE = dbo.SYSDATE1(),
                      VALID = @VALID
                WHEN NOT MATCHED THEN
                  INSERT (
                      GROUP_ID, DIVISION_ID, JOB_ID, JOB_DESC, NO, SEQ, 
                      PARAMETER1, PARAMETER2, PARAMETER3, PARAMETER4, PARAMETER5, 
                      CREATE_USER_ID, CREATE_DATE, MODIFY_USER_ID, MODIFY_DATE, VALID
                  )
                  VALUES (
                      @GROUP_ID, @DIVISION_ID, @JOB_ID, @JOB_DESC, @NO, @SEQ, 
                      @PARAMETER1, @PARAMETER2, @PARAMETER3, @PARAMETER4, @PARAMETER5, 
                      @USER_ID, dbo.SYSDATE1(), @USER_ID, dbo.SYSDATE1(), @VALID
                  )
                ;
                
              COMMIT;
              
            END;