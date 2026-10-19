---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW [dbo].[IF_DM_ANL_KPI_RTF_SALES_V] 
AS
/*
 * Program ID   : IF_DM_ANL_KPI_RTF_SALES_V
 * Description  : KPI VIEW  : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.03   HWI1993 Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 
 */

SELECT
	CASE WHEN DIVISION_ID LIKE '81%' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	, ITEM_ID
	, FCST_TYPE
	, YYYYMM
	, MEASURE
	, QTY
	, ACC_QTY
	, DOE
	, BASIC_NICK_NAME
	, GROUP_TYPE
	, ITEM_CLASS_NAME
	, SCM_PIC
	, ACCUMULATED_CHILD_QTY
	, QTY_CELL
	, ACC_QTY_CELL
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
FROM   DM_ANL_KPI_RTF_SALES
