BEGIN
              BEGIN TRAN
                
                DELETE
                FROM   JOB_SCHEDULE_EXCEPTION
                WHERE  GROUP_ID    = @GROUP_ID
                AND    DIVISION_ID = @DIVISION_ID
                AND    CONVERT(VARCHAR, START_DATE, 120) = @START_DATE
                AND    CONVERT(VARCHAR, END_DATE, 120)   = @END_DATE
                ;
                
              COMMIT;
              
            END;