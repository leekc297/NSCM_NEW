


CREATE VIEW [dbo].[IF_FP_SCM_IN_TRANSIT_V] AS
-- ================================================================================================
-- Program ID          : IF_FP_SCM_IN_TRANSIT_V
--
-- Program Name        : IF_FP_SCM_IN_TRANSIT_V Pancake PSI 형성용 SCP의 In-Transit
-- Param               :
-- Batch Period        : 
-- Description         : SCM의 SCM_DNM_INTRANSIT_V 기반으로 TO SITE가 Plant인 정보만 조회
--
-- Source System       : SCM SDB
-- Destination System  : FP  SDB
-- Source Table        : SCM의 SCM_DNM_INTRANSIT_V
-- Destination Table   : 
--
-- Create(Update) Date : 2019.09.16
-- Author              : kim choon dong
-- Version             : 2019-06-21 kimcd SCP의 In-Transit 정보 중 Plant 향 정보만 조회
--                       2019-09-16 kimcd From Plan Id 추가
-- ================================================================================================
select DI.RESULT_DATE,
       P.COMPANY_ID,
       DI.DIVISION_ID,
	   P.SITE_ID,
	   P.PLANT_ID,
	   DI.ITEM_ID,
       DI.DELIVERY_QTY,
	   DI.ETA_DATE,
	   DI.PLANT_ISSUE_DATE,
	   DI.FROM_SCM_SITE_ID,
	   S.PLANT_ID AS FROM_PLANT_ID,
	   DI.UOM,
	   DI.TRANSPORT_MODE
from   LGCE_SCMDEV.DBO.SCM_DNM_INTRANSIT_V  DI
       LEFT OUTER JOIN SCM_PLANT_M          S WITH(NOLOCK)
	   ON S.PLANT_ID = SUBSTRING(DI.FROM_SCM_SITE_ID,1,4)
      ,SCM_PLANT_M          P WITH(NOLOCK)
where  P.PLANT_ID = SUBSTRING(DI.TO_SCM_SITE_ID,1,4)
AND    DI.SITE_TYPE = 'PLANT'

