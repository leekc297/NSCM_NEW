


CREATE VIEW [dbo].[IF_DM_MST_CUSTOMER_MODEL_V] 
AS
/*
 * Program ID   : IF_DM_MST_CUSTOMER_MODEL_V
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
	, CUSTOMER_PROJECT_CODE
	, CUSTOMER_MODEL
	, SCM_SITE_ID
	, PROJECT_CODE
	, ITEM_ID
	, VALID_YN
	, CUSTOMER_MODEL_TYPE
	, CONVERT_QTY_PACK
	, CONVERT_QTY_MODULE
	, CONVERT_QTY_CELL
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
FROM DM_MST_CUSTOMER_MODEL
