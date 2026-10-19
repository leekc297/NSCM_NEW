INSERT INTO  SCM_SYS_LOOKUP_VALUE 
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
           ('CAPA_UI_LOSS_TYPE_COLOR'
           ,@INSTANCE_ID
           ,@SETUP_COLOR_ID
           ,@COLOR
           ,'SCM_WORK_CALENDAR_M'
           ,'Y'
           ,0
           ,'Y'
           ,'SCM_WORK_CALENDAR_M LossType Color'
           ,@USER_ID
           ,@USER_ID
           ,GetDate()
           ,GetDate()
           ,@ATTRIBUTE1
           ,@ATTRIBUTE2
          -- ,@PLANT_ID
           )