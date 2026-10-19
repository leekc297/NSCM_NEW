


CREATE VIEW [dbo].[IF_DM_PLN_SALES_PLAN_C_V] 
AS
/*
 * Program ID   : IF_DM_PLN_SALES_PLAN_C_V
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
	, VERSION_NO
	, CUTOFF_TYPE
	, CUTOFF_YYYYMMDD
	, PROJECT_CODE
	, SCM_SITE_ID
	, ITEM_ID
	, DOM_EXP
	, FCST_TYPE
	, INCOTERMS
	, MEASURE
	, PLANT_SITE_ID
	, YYYYMMDD
	, CURRENCY
	, QTY
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
FROM DM_PLN_SALES_PLAN_C
