BEGIN
		        BEGIN TRAN
INSERT INTO [dbo].[TH_UIS_SQL_LOG]
           ([PROG_ID]
           ,[QUERY_ID]
           ,[QUERY_SEQ]
           ,[INST_SEQ]
           ,[QUERY_VALUE]
           ,[JOB_TYPE]
           ,[START_TIME]
           ,[END_TIME]
           ,[INSERT_ID]
           ,[INSERT_TIME])
     VALUES
          ( 'try_batch',
           @COMPANY_ID,
           1,
           2,
           @ITEM_CLASS_LEVEL_3,
           @ITEM_CLASS_LEVEL_4,
           getdate(),
           getdate(),
           @USER_ID,
           getdate())
		          
		        COMMIT;
		        
		        BEGIN TRAN
		          
INSERT INTO [dbo].[TH_UIS_SQL_LOG]
           ([PROG_ID]
           ,[QUERY_ID]
           ,[QUERY_SEQ]
           ,[INST_SEQ]
           ,[QUERY_VALUE]
           ,[JOB_TYPE]
           ,[START_TIME]
           ,[END_TIME]
           ,[INSERT_ID]
           ,[INSERT_TIME])
     VALUES
          ( 'try_batch_step2',
           @COMPANY_ID,
           1,
           2,
           @ITEM_CLASS_LEVEL_3,
           @ITEM_CLASS_LEVEL_4,
           getdate(),
           getdate(),
           @USER_ID,
           getdate())
		          
		        COMMIT;
		        
		      END;