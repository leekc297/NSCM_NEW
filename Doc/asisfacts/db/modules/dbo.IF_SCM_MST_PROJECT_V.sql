
CREATE VIEW [dbo].[IF_SCM_MST_PROJECT_V] 
AS
/*
 * Program ID   : IF_SCM_MST_PROJECT_V
 * Description  : DW 용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.03   HWI1993 Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 
 */


SELECT
	  
	 CASE WHEN DIVISION_ID LIKE '81%' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	, PROJECT_CODE
	, PROJECT_VER_SEQ
	, PROJECT_NAME
	, BIZ_TYPE
	, BIZ_TYPE_NAME
	, PROJECT_STATUS
	, PROJECT_OWNER
	, CURRENCY
	, DROP_YN
	, CAPACITY
	, GPLM_PROJECT_CODE
	, GPLM_SYSTEM_PROJECT_CODE
	, GPLM_DEV_PROJECT_CODE
	, GPLM_MAPPING_YN
	, SHIPMENT_DATE
	, PRODUCT_GROUP_CODE
	, PRODUCT_GROUP_NAME
	, INCOTERMS
	, CREATION_DATE
	, CREATED_BY
	, LAST_UPDATE_DATE
	, LAST_UPDATED_BY
	, ATTRIBUTE1
	, ATTRIBUTE2
	, ATTRIBUTE3
	, ATTRIBUTE4
	, ATTRIBUTE5
	, ATTRIBUTE6
	, ATTRIBUTE7
	, ATTRIBUTE8
	, ATTRIBUTE9
	, ATTRIBUTE10
	, DIVISION_ID AS SCM_DIVISION_ID
FROM SCM_MST_PROJECT

