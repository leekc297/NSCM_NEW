BEGIN
              BEGIN TRAN
                
                UPDATE JOB_SCHEDULE_DETAIL
                SET    STATUS         = 'END'
                     , MODIFY_USER_ID = @USER_ID
                     , MODIFY_DATE    = GETDATE()
                WHERE GROUP_ID        = @GROUP_ID
                AND   DIVISION_ID     = @DIVISION_ID
                AND   JOB_ID          = @JOB_ID
                AND   NO              = @NO
                ;
                
              COMMIT;
              
            END;