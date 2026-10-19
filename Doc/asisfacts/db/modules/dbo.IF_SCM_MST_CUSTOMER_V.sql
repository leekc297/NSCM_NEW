
CREATE VIEW [dbo].[IF_SCM_MST_CUSTOMER_V] 
AS
/*
 * Program ID   : IF_SCM_MST_CUSTOMER_V
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
	, SOLDTO_CODE
	, SHIPTO_CODE
	, SOLDTO_DESCRIPTION
	, SOLDTO_ADDRESS
	, CITY
	, SOLDTO_COUNTRY
	, SOLDTO_REGION
	, SOLDTO_REGION_NAME
	, SOLDTO_CITY_NAME
	, SHIPTO_DESCRIPTION
	, SHIPTO_ADDRESS
	, SHIPTO_COUNTRY
	, SHIPTO_REGION
	, SHIPTO_REGION_NAME
	, SHIPTO_CITY_NAME
	, VALID_YN
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
FROM SCM_MST_CUSTOMER

