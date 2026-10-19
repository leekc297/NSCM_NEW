BEGIN
              BEGIN TRAN
                
                UPDATE JOB_SCHEDULE_MASTER
                SET IMMEDIATE_FLAG = 'N'
                WHERE GROUP_ID = @GROUP_ID
                ;
                
              COMMIT;
              
            END;