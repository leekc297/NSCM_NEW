BEGIN
              BEGIN TRAN
                
                UPDATE JOB_SCHEDULE_MASTER SET
                      GROUP_NAME      = @GROUP_NAME,
                      DESCRIPTION     = @DESCRIPTION,
                      PERIOD          = @PERIOD, 
                      TIME            = @TIME,
                      MODIFY_USER_ID  = @USER_ID,
                      MODIFY_DATE     = dbo.SYSDATE1(),
                      START_DATE      = CONVERT(DATETIME, @START_DATE),
                      END_DATE        = CONVERT(DATETIME, @END_DATE),
                      VALID           = @VALID
                WHERE GROUP_ID        = @GROUP_ID
                ;
                
              COMMIT;
              
            END;