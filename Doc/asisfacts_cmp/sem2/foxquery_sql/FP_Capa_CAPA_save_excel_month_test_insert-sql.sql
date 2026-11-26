BEGIN
		        BEGIN TRAN

		          INSERT INTO SY_SCM_ADM_EXCEL_UPLOAD
               (
		        [UPLOAD_ID]
           ,[PROGRAM_ID]
           ,[SHEET_NAME]
           ,[UPLOAD_STATUS_CODE]
           ,[MESSAGE_TEXT]
           ,[CREATED_BY]
           ,[CREATION_DATE]
           ,[LAST_UPDATED_BY]
           ,[LAST_UPDATE_DATE]
           ,[ATTRIBUTE1]
           ,[ATTRIBUTE2]
           ,[ATTRIBUTE3]
       
		            )
		            VALUES (
 NEXT VALUE FOR [LGCE_SCMDEV].[dbo].[SEQ1_SCM_ADM_EXCEL_UPLOAD]
           ,@PROGRAM_ID
           ,@SHEET_NAME
           ,'UPLOAD'
           ,@MESSAGE_TEXT
           ,@USER_ID
           ,GetDate()
           ,@USER_ID
           ,GetDate()
           ,@ATTRIBUTE1
           ,@ATTRIBUTE2
           ,@ATTRIBUTE3
          
		            )
		          ;
		        
		        COMMIT;
		        
		      END;