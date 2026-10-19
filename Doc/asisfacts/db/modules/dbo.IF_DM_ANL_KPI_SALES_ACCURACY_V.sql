
CREATE VIEW [dbo].[IF_DM_ANL_KPI_SALES_ACCURACY_V] 
AS
/*
 * Program ID   : IF_DM_ANL_KPI_SALES_ACCURACY_V
 * Description  : KPI VIEW  : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.03   HWI1993 Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 
 */

SELECT
	WORK_YYYYMMDD
	, CASE WHEN DIVISION_ID LIKE '81%' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	, DEPT_ID
	, DOE
	, BASIC_NICK_NAME
	, GROUP_TYPE
	, ITEM_CLASS_NAME
	, SCM_PIC
	, ACCUMULATED_CHILD_QTY
	, RESULT_QTY_CELL
	, PLAN_QTY_CELL
	, CREATED_BY
	, KPI_RATE
	, ATTRIBUTE1
	, YYYYMM
	, ATTRIBUTE4
	, PROJECT_CODE
	, WEIGHT
	, SCM_SITE_ID
	, RESULT_QTY
	, ATTRIBUTE10
	, ITEM_ID
	, CREATION_DATE
	, ATTRIBUTE8
	, FCST_TYPE
	, MEASURE
	, ATTRIBUTE9
	, ATTRIBUTE3
	, LAST_UPDATED_BY
	, ATTRIBUTE6
	, LAST_UPDATE_DATE
	, ATTRIBUTE7
	, ATTRIBUTE5
	, END_CUSTOMER
	, ATTRIBUTE2
	, DIVISION_ID AS SCM_DIVISION_ID
FROM DM_ANL_KPI_SALES_ACCURACY
