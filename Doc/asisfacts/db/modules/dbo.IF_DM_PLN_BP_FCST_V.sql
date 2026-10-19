CREATE  VIEW [dbo].[IF_DM_PLN_BP_FCST_V] 
AS
/*
 * Program ID   : IF_DM_PLN_BP_FCST_V
 * Description  : DW 용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.03   HWI1993 Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2022.06.21	rosia27	[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 
 */


SELECT
	 CASE WHEN DIVISION_ID LIKE '81%' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	, PROJECT_CODE
	, PROJECT_NAME
	, SCM_SITE_ID
	, ITEM_ID
	, DOM_EXP
	, FCST_TYPE
	, MEASURE
	, PLANT_SITE_ID
	, DEPT_ID
	, END_CUSTOMER
	, BIZ_TYPE
	, YYYYMM
	, CURRENCY
	, ITEM_USE
	, UNIT_ENERGY
	, QTY
	, CELL_PER_PACK
	, CELL_PER_MODULE
	, MODULE_PER_PACK
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
	, INCOTERMS
	, CELL_PROD_SITE
	, DIVISION_ID AS SCM_DIVISION_ID
FROM DM_PLN_BP_FCST

