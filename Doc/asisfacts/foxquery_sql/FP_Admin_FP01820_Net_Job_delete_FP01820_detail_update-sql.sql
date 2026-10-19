BEGIN
              BEGIN TRAN
                
                DELETE
                FROM   JOB_SCHEDULE_DETAIL
                WHERE  GROUP_ID    = @GROUP_ID
                AND    DIVISION_ID = @DIVISION_ID
                AND    JOB_ID      = @ORG_JOB_ID
                AND    NO          = @ORG_NO
                ;
                
              COMMIT;
              
            END;