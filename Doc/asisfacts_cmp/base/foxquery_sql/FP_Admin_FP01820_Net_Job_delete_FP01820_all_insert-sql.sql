BEGIN
              BEGIN TRAN
                
                DELETE FROM JOB_SCHEDULE_MASTER
                WHERE  GROUP_ID    = @GROUP_ID
                AND    DIVISION_ID = @DIVISION_ID
                ;
                
              COMMIT;
              
              BEGIN TRAN
                
                DELETE FROM JOB_SCHEDULE_DETAIL
                WHERE  GROUP_ID    = @GROUP_ID
                AND    DIVISION_ID = @DIVISION_ID
                ;
                
              COMMIT;
              
            END;