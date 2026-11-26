BEGIN
            BEGIN TRAN
              
              UPDATE JOB_SCHEDULE_MASTER SET
                     IMMEDIATE_FLAG = 'Y'
       			       , MODIFY_USER_ID = @USER_ID
       			       , MODIFY_DATE = GETDATE()
              WHERE  GROUP_ID = @GROUP_ID
              ;
              
            COMMIT;
            
          END;