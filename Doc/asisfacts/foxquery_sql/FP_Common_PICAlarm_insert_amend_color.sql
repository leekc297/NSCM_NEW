INSERT INTO [dbo].[SCM_SYS_LOOKUP_VALUE]
           ([LOOKUP_TYPE_CODE]
           ,[SEGMENT1]
           ,[SEGMENT2]
           ,[SEGMENT3]
           ,[SEGMENT4]
           ,[SEGMENT5]
           ,[SORT_ORDER]
           ,[ACTIVE_FLAG]
           ,[VALUE_DESCRIPTION]
           ,[CREATE_USER_ID]
           ,[MODIFY_USER_ID]
           ,[CREATE_DATE]
           ,[MODIFY_DATE]           
           ,[ATTRIBUTE1]
           ,[ATTRIBUTE2]
--           ,[PLANT_ID]
           )
     VALUES
           ('UI_AMEND_COLOR'
           ,@INSTANCE_ID
           ,@SETUP_COLOR_ID
           ,@SETUP_COLOR_NAME
           ,@COLOR
           ,'Y'
           ,10
           ,'Y'
           ,'SETUP_COLOR_ID Max 10 Char'
           ,@USER_ID
           ,@USER_ID
           ,GetDate()
           ,GetDate()
           ,@ATTRIBUTE1
           ,@ATTRIBUTE2
          -- ,@PLANT_ID
           )