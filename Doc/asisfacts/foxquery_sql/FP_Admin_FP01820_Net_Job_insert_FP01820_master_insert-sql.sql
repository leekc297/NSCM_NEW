BEGIN
              BEGIN TRAN
                
                INSERT INTO JOB_SCHEDULE_MASTER (
                    GROUP_ID, GROUP_NAME, DIVISION_ID, DESCRIPTION, PERIOD, TIME, 
                    CREATE_USER_ID, CREATE_DATE, MODIFY_USER_ID, MODIFY_DATE, START_DATE, END_DATE, VALID
                )
                VALUES (
                    @GROUP_ID, @GROUP_NAME, @DIVISION_ID, @DESCRIPTION, @PERIOD, @TIME,
                    @USER_ID, dbo.SYSDATE1(), @USER_ID, dbo.SYSDATE1(),
                    CONVERT(DATETIME, @START_DATE), CONVERT(DATETIME, @END_DATE), @VALID
                )
                ;
                
              COMMIT;
              
            END;