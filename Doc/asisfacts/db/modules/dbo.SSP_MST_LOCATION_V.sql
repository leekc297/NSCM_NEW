

CREATE VIEW [dbo].[SSP_MST_LOCATION_V] AS
/********************************************************************************************************************************
* VIEW NAME     : SSP_MST_LOCATION_V
* DESCRIPTION   : 
*          
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE      IN CHARGE           DESCRIPTION
*--------------------------------------------------------------
* 20210720   SSP Pjt             Created
********************************************************************************************************************************/
SELECT [LOCATION_SEQ]
      ,[DIVISION_ID]
      ,[LOCATION_CODE]
      ,[LOCATION_DESCRIPTION]
      ,[SCM_SITE_ID]
      ,[PLANT_ID]
      ,[FACTORY_ID]
      ,[OPERATION_ID]
      ,TOKEN AS [STORAGE_ID]
      ,[ELECTRODE_TYPE]
      ,'Y' AS [VALID_YN]
      ,[CREATED_BY]
      ,[CREATION_DATE]
      ,[LAST_UPDATED_BY]
      ,[LAST_UPDATE_DATE]
      ,[ATTRIBUTE1]
      ,[ATTRIBUTE2] 
      ,[ATTRIBUTE3]
      ,[ATTRIBUTE4]
      ,[ATTRIBUTE5]
      ,[ATTRIBUTE6]
      ,[ATTRIBUTE7]
      ,[ATTRIBUTE8]
      ,[ATTRIBUTE9]
      ,[ATTRIBUTE10]
  FROM [dbo].[SCM_MST_LOCATION] WITH(NOLOCK)
CROSS APPLY STRING_SPLIT(ATTRIBUTE2, ',')



