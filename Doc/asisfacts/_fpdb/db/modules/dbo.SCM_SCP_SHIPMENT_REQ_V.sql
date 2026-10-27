
CREATE VIEW [dbo].[SCM_SCP_SHIPMENT_REQ_V]
-- ================================================================================================
-- Program ID          : SCM_SCP_SHIPMENT_REQ_V
--
-- Program Name        : SCM_SCP_SHIPMENT_REQ_V
-- Param               :
-- Batch Period        : 
-- Description         : SCP, DM 출하 요청 기준 정보 조회용 View
--
-- Source System       : FP SDB, SCP SDB
-- Destination System  : SCP SDB
-- Source Table        : SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, DM_PLN_SHIPMENT_REQ, SCM_MST_SITE
--                       GRANT SELECT ON [LGCE_SCMPROD].[DBO].[SCM_MST_CUSTOMER] TO CN_FORM_A
--                       GRANT SELECT ON [LGCE_SCMPROD].[DBO].[SCM_MST_SITE_CUSTOMER] TO CN_FORM_A
--                       GRANT SELECT ON [LGCE_SCMPROD].[DBO].[DM_PLN_SHIPMENT_REQ] TO CN_FORM_A
--                       GRANT SELECT ON [LGCE_SCMPROD].[DBO].[SCM_MST_SITE] TO CN_FORM_A
--
-- Destination Table   : 
--
-- Create(Update) Date : 2019.10.02
-- Author              : kim choon dong
-- Version             : 2019-10-02 kimcd 최초 작성
-- ================================================================================================
AS
SELECT PSI.COMPANY_ID
      ,PSI.DIVISION_ID
	  ,PSI.SITE_ID
	  ,PSI.PLANT_ID
	  ,PSI.OPERATION_GROUP   AS SHOP_GROUP_ID
	  ,PSI.DIVISION_ID + '^' + PSR.ITEM_ID + '^' + PSR.PLANT_SITE_ID + '^' + PSR.SCM_SITE_ID + '^' + PSR.YYYYMMDD + '^' + PSR.TRANSPORT_MODE + '^' + PSR.FCST_TYPE + '^D' AS SCP_TARGET_ID
	  ,PSR.ITEM_ID
	  ,PSR.SCM_SITE_ID AS TO_SITE_ID
	  ,SSI.PLANT_ID AS TO_PLANT_ID
	  ,(SELECT TOP 1 C.SOLDTO_CODE
        FROM   [LGCE_SCMDEV].[DBO].[SCM_MST_CUSTOMER] C WITH(NOLOCK)
              ,[LGCE_SCMDEV].[DBO].[SCM_MST_SITE_CUSTOMER] SC WITH(NOLOCK)
        WHERE  1=1
	    AND SC.REP_YN        = 'Y'
	    AND SC.DIVISION_ID   = C.DIVISION_ID
	    AND SC.SOLDTO_CODE   = C.SOLDTO_CODE
	    AND SC.SHIPTO_CODE   = C.SHIPTO_CODE
	    AND SC.DIVISION_ID    = SSI.DIVISION_ID
	    AND SC.SCM_SITE_ID    = SSI.SCM_SITE_ID ) AS CUSTOMER_ID
	  ,CONVERT(DATE, PSR.YYYYMMDD, 112) AS SHIP_DATE
	  ,(SELECT TOP 1 WEEK
	    FROM   [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
		WHERE  DATE_ID = PSR.YYYYMMDD	) AS SHIP_WEEK
	  ,QTY AS SHIP_QTY
	  ,PSR.TRANSPORT_MODE
	  ,PSR.YYYYMMDD
FROM   [LGCE_SCMDEV].[DBO].[DM_PLN_SHIPMENT_REQ]   PSR WITH(NOLOCK)
      ,[LGCE_SCMDEV].[DBO].[SCM_MST_SITE]          PSI WITH(NOLOCK)
	  ,[LGCE_SCMDEV].[DBO].[SCM_MST_SITE]          SSI WITH(NOLOCK)
WHERE  1=1
AND    PSR.DIVISION_ID = PSI.DIVISION_ID
AND    PSR.PLANT_SITE_ID = PSI.SCM_SITE_ID
AND    PSR.DIVISION_ID = SSI.DIVISION_ID
AND    PSR.SCM_SITE_ID = SSI.SCM_SITE_ID
AND    PSR.QTY > 0



