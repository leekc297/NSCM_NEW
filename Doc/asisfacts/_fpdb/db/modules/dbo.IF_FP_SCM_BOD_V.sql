



CREATE VIEW [dbo].[IF_FP_SCM_BOD_V] AS
-- ================================================================================================
-- Program ID          : IF_FP_SCM_BOD_V
--
-- Program Name        : IF_FP_SCM_BOD_V Pancake PSI 형성용 SCP의 Site간 BOD
-- Param               :
-- Batch Period        : 
-- Description         : SCM의 SITE간 BOD에서 PLANT 정보만 추출
--
-- Source System       : SCM SDB
-- Destination System  : FP  SDB
-- Source Table        : SCM의 SCP_MST_BOD_V SCM_MST_SITE
-- Destination Table   : 
--
-- Create(Update) Date : 2019.07.05
-- Author              : kim choon dong
-- Version             : 2019-06-27 kimcd SCP의 BOD 정보 중 Plant 정보만 조회
--                       2019-07-05 kimcd FP Plant, Plant Name, Site ID 추가
-- ================================================================================================
SELECT A.[DIVISION_ID]
      ,A.[BOD_ID]
      ,A.[BOD_TYPE]
      ,A.[FROM_SITE]
	  ,FS.[PLANT_ID] AS FROM_PLANT_ID
      ,A.[D_COUNTRY]
      ,A.[D_PORT_CODE]
      ,A.[A_COUNTRY]
      ,A.[A_PORT_CODE]
      ,A.[TO_COUNTRY]
      ,A.[TO_CITY]
      ,A.[HUB_SLOC]
      ,A.[TO_SITE]
      ,S.[PLANT_ID]      AS TO_PLANT_ID
	  ,FP.[PLANT_NAME]   AS TO_PLANT_NAME   -- 2019-07-05 kimcd FP Plant, Plant Name, Site ID 추가
	  ,FP.[SITE_ID]      AS TO_SITE_ID      -- 2019-07-05 kimcd FP Plant, Plant Name, Site ID 추가
      ,A.[INCOTERMS]
      ,A.[TRANSPORT_MODE]
      ,A.[ROUTE_ID]
      ,A.[PRIORITY]
      ,A.[DAYS_MON]
      ,A.[DAYS_TUE]
      ,A.[DAYS_WED]
      ,A.[DAYS_THU]
      ,A.[DAYS_FRI]
      ,A.[DAYS_SAT]
      ,A.[DAYS_SUN]
      ,A.[SAFETY_STOCK]
      ,A.[LT_DEPARTURE_INLAND]
      ,A.[LT_WAIT_SHIPPING]
      ,A.[LT_VOYAGE]
      ,A.[LT_LAY_OFF_CLEARANCE]
      ,A.[LT_ARRIVAL_INLAND]
      ,A.[LT_TOTAL]
      ,A.[SHIP_LT_TOTAL]
      ,A.[BOD_VALID_YN]
      ,A.[ROUTE_VALID_YN]
      ,A.[LT_TYPE]
  FROM [LGCE_SCMDEV].[DBO].[SCP_MST_BOD_V] A
      ,[LGCE_SCMDEV].[DBO].[SCM_MST_SITE]  FS WITH(NOLOCK)
      ,[LGCE_SCMDEV].[DBO].[SCM_MST_SITE]  S WITH(NOLOCK)
	  ,[DBO].[SCM_PLANT_M]                  FP WITH(NOLOCK)  -- 2019-07-05 kimcd FP Plant, Plant Name, Site ID 추가
WHERE  A.[BOD_TYPE]  = 'PLANT'
AND    A.DIVISION_ID = FS.DIVISION_ID
AND    A.FROM_SITE   = FS.SCM_SITE_ID
AND    A.TO_SITE     = S.SCM_SITE_ID
AND    S.SITE_TYPE   = 'PLANT'
AND    A.BOD_VALID_YN = 'Y'
AND    S.[PLANT_ID]  = FP.[PLANT_ID]  -- 2019-07-05 kimcd FP Plant, Plant Name, Site ID 추가


