BEGIN
              BEGIN TRAN
                
                INSERT INTO JOB_SCHEDULE_DETAIL (
                    GROUP_ID, DIVISION_ID, JOB_ID, JOB_DESC, JOB_TYPE, NO, SEQ,
                    PARAMETER1, PARAMETER2, PARAMETER3, PARAMETER4, PARAMETER5,
                    CREATE_USER_ID, CREATE_DATE, MODIFY_USER_ID, MODIFY_DATE, VALID
                )
                VALUES (
                    @GROUP_ID, @DIVISION_ID, @JOB_ID, @JOB_DESC, @JOB_TYPE, @NO, @SEQ, 
                    @PARAMETER1, @PARAMETER2, @PARAMETER3, @PARAMETER4, @PARAMETER5, 
                    @USER_ID, dbo.SYSDATE1(), @USER_ID, dbo.SYSDATE1(), @VALID
                )
                ;
                
              COMMIT;
              
            END;