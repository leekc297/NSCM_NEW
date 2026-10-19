
CREATE VIEW [dbo].[IF_SCM_MST_SITE_V] 
AS
/*
 * Program ID   : IF_SCM_MST_SITE_V
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
	, SCM_SITE_ID
	, PLANT_ID
	, OPERATION_GROUP
	, SITE_DESCRIPTION
	, SITE_TYPE
	, CITY
	, COUNTRY
	, DEPT_ID
	, VMI_YN
	, VALID_YN
	, NEW_YN
	, SITE_HRCY_ID
	, OSP_YN
	, SHIP_FROZEN
	, PROD_FROZEN
	, END_CUSTOMER
	, SOLDTO_CUSTOMER
	, FP_PLAN_PERIOD
	, BUILD_AHEAD
	, LOGISTIC_PLANT_ID
	, PACKER_ITEM_ID_SUFFIX
	, HQ_VENDOR_CODE
	, COMPANY_ID
	, SITE_ID
	, CREATED_BY
	, CREATION_DATE
	, LAST_UPDATED_BY
	, LAST_UPDATE_DATE
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
FROM SCM_MST_SITE

