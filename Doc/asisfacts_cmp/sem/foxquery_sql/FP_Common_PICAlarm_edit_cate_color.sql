BEGIN
BEGIN TRAN
MERGE INTO SCM_SYS_LOOKUP_VALUE A
USING 

(
SELECT 
 'CAPA_UI_LOSS_TYPE_COLOR' AS LOOKUP_TYPE_CODE
,@INSTANCE_ID AS SEGMENT1 -- INSTANCE_ID
,@SETUP_COLOR_ID AS SEGMENT2 -- COLOR
,'SCM_WORK_CALENDAR_M' AS SEGMENT4
) B
ON  A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
AND  A.SEGMENT1 = B.SEGMENT1
AND  A.SEGMENT2 = B.SEGMENT2
AND  A.SEGMENT4 = B.SEGMENT4
-- UPDATE
WHEN MATCHED THEN
UPDATE SET ATTRIBUTE4 = ISNULL(@COLOR,''),
MODIFY_USER_ID = @USER_ID,
MODIFY_DATE = GetDate()

-- INSERT
WHEN NOT MATCHED THEN
INSERT
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
;
COMMIT

END