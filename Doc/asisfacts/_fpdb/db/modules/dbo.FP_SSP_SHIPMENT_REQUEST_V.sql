





CREATE VIEW [dbo].[FP_SSP_SHIPMENT_REQUEST_V]
-- ================================================================================================
-- Program ID          : FP_SSP_SHIPMENT_REQUEST_V
--
-- Program Name        : FP_SSP_SHIPMENT_REQUEST_V
-- Param               :
-- Batch Period        : 
-- Description         : SSP shipment reqeust 조회용 View
--
-- Source System       : SCP SDB
-- Destination System  : FP SDB
-- Source Table        : SSP_ANL_SHIP_PLAN, SSP_PLAN_VERSION_V, SCM_PLANT_M
-- Destination Table   : 
--
-- Create(Update) Date : 2019.04.30
-- Author              : kim choon dong
-- Version             : 2019-04-30 kimcd 최초 작성
-- ================================================================================================
AS
SELECT MAX(P.COMPANY_ID)   AS COMPANY_ID
      ,MAX(P.DIVISION_ID)  AS DIVISION_ID
	  ,MAX(P.SITE_ID)      AS SITE_ID
	  ,P.PLANT_ID
	  ,A.PLAN_TYPE
	  ,A.SEQ
	  ,A.ITEM_ID
	  ,CONVERT(DATE, A.YYYYMMDD, 112) AS SHIP_DATE
	  ,SUM(A.QTY) QTY
FROM LGCE_SCMDEV.DBO.SSP_ANL_SHIP_PLAN A WITH(NOLOCK) , 
	(SELECT B.DIVISION_ID, B.plan_start_yyyymmdd 
	 FROM   (   SELECT P.DIVISION_ID, P.plan_start_yyyymmdd , ROW_NUMBER() OVER (PARTITION BY P.DIVISION_ID ORDER BY P.plan_start_yyyymmdd DESC) AS R_N
				FROM LGCE_SCMDEV.DBO.SSP_PLAN_VERSION_V P
				WHERE P.plan_start_yyyymmdd     >= CONVERT(NVARCHAR(8),DATEADD(D,-30,GETDATE()),112)
				AND P.PLAN_TYPE     ='SP' ) B
	 WHERE B.R_N = 1 ) B,
	 SCM_PLANT_M P WITH(NOLOCK)
WHERE A.PLAN_START_YYYYMMDD  = B.plan_start_yyyymmdd
AND   A.PLAN_TYPE  = 'SP'
AND   A.DIVISION_ID = B.DIVISION_ID
AND   A.MEASURE  = 'SHIP_REQ'
AND   A.BIZ_TYPE = 'A'
AND   P.PLANT_ID = SUBSTRING(A.FROM_SITE, 1,4)
AND   A.QTY > 0
GROUP BY P.PLANT_ID
	  ,A.PLAN_TYPE
	  ,A.SEQ
	  ,A.ITEM_ID
	  ,A.YYYYMMDD

