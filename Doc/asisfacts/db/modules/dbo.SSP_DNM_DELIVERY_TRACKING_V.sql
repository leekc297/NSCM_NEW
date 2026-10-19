
CREATE VIEW [dbo].[SSP_DNM_DELIVERY_TRACKING_V] AS
/********************************************************************************************************************************
* VIEW NAME     : [SSP_DNM_DELIVERY_TRACKING_V]
* DESCRIPTION   : SCM_DNM_DELIVERY_TRACKING 조회 
*          
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE      IN CHARGE           DESCRIPTION
*--------------------------------------------------------------
* 2022.07.01   SSP Pjt.     Create.
* 2023.11.02   vadabi3      INLAND_ATD.POL_ATA
********************************************************************************************************************************/
SELECT COMPANY_ID
	  ,SHIPMENT_NO 
      ,MAX(ROUTE)								AS ROUTE
	  ,MAX(INCOTERMS)							AS INCOTERMS
	  ,MAX(CARRIER)								AS CARRIER
	  ,MAX(POL)									AS POL
	  ,MAX(POD)									AS POD
	  ,MAX(ATTRIBUTE4)							AS FORWARDER
    --,MAX(ATTRIBUTE2)							AS INLAND_ATD 
    --,MAX(ATTRIBUTE3)							AS POL_ATA 
      ,MAX(ZLANDATD)							AS INLAND_ATD 
	  ,MAX(ZLANDATA)							AS POL_ATA 
	  ,MAX(POL_ATD_DATE)						AS POL_ATD
	  ,MAX(POD_ATA_DATE)						AS POD_ATA
	  ,MAX(POD_ATD_DATE)						AS POD_ATD
	  ,MAX(F_DEST_ATA_DATE)						AS F_DEST_ATA
	  ,ISNULL(MAX(REPLACE(IIF(ZFCY2ATA = '0000-00-00','',ZFCY2ATA), '-', '')), '')    AS VMI_ATA   
	  ,ISNULL(MAX(REPLACE(IIF(ZFCY2ATD = '0000-00-00','',ZFCY2ATD), '-', '')), '')    AS VMI_ATD
  FROM SCM_DNM_DELIVERY_TRACKING WITH(NOLOCK)
 WHERE VALID_YN = 'Y'
 --AND CONTAINER_NO != '-'
 GROUP BY COMPANY_ID, SHIPMENT_NO
--  UNION ALL
-- SELECT X.COMPANY_ID
--	   ,X.SHIPMENT_NO
--	   ,MAX(X.ROUTE)			AS ROUTE
--	   ,MAX(X.INCOTERMS)		AS INCOTERMS
--	   ,MAX(X.CARRIER)			AS CARRIER
--	   ,MAX(X.POL)				AS POL
--	   ,MAX(X.POD)				AS POD
--	   ,MAX(X.ATTRIBUTE4)		AS FORWARDER
--       ,MAX(X.ATTRIBUTE2)		AS INLAND_ATD
--	   ,MAX(X.ATTRIBUTE3)		AS POL_ATA
--	   ,MAX(X.POL_ATD_DATE)		AS POL_ATD
--	   ,MAX(X.POD_ATA_DATE)		AS POD_ATA
--	   ,MAX(X.POD_ATD_DATE)		AS POD_ATD
--	   ,MAX(X.F_DEST_ATA_DATE)	AS F_DEST_ATA
--	   ,MAX(ZFCY2ATA)           AS ZFCY2ATA
--	   ,MAX(ZFCY2ATD)           AS ZFCY2ATD
--   FROM SCM_DNM_DELIVERY_TRACKING AS X WITH(NOLOCK)
--		JOIN (
--		     SELECT COMPANY_ID, SHIPMENT_NO
--               FROM SCM_DNM_DELIVERY_TRACKING WITH(NOLOCK)
--              WHERE VALID_YN = 'Y'
--	            AND CONTAINER_NO = '-'
--			  GROUP BY COMPANY_ID, SHIPMENT_NO
--		    ) AS Y
--	ON X.COMPANY_ID = Y.COMPANY_ID
--   AND X.SHIPMENT_NO = Y.SHIPMENT_NO
--   AND X.VALID_YN = 'Y'
-- GROUP BY X.COMPANY_ID, X.SHIPMENT_NO
--HAVING COUNT(*) = 1

;
