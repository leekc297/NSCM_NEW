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
					VALUES (
						'AAATET', 
						0, 
						0,
						0, 
						@a, 
						'--', 
						getdate(), 
						getdate(), 
						'===========', 
						getdate())