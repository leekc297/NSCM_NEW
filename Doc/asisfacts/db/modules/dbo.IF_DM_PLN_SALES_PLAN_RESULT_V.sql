


CREATE VIEW [dbo].[IF_DM_PLN_SALES_PLAN_RESULT_V] 
AS
/*
 * Program ID   : IF_DM_PLN_SALES_PLAN_RESULT_V
 * Description  : DW 용 [GDW 사용 GDW 담당자: 정구범책임]
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.03   HWI1993		Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2025.07.21	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 
 */


SELECT
	  
	  CASE WHEN DIVISION_ID LIKE '81%' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
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
	, COMPANY_ID
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
	, CELL_PROD_SITE_ID						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
FROM DM_PLN_SALES_PLAN_RESULT
