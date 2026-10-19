
CREATE VIEW [dbo].[IF_DM_HI_SALES_INPUT_V] 
AS
/*
 * Program ID   : IF_DM_HI_SALES_INPUT_V
 * Description  : HI 용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.03   HWI1993 Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 
 */


SELECT
	 VERSION_YYYYMMDD
	, CASE WHEN DIVISION_ID LIKE '81%' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	, END_CUSTOMER
	, SCM_SITE_ID
	, DEPT_ID
	, DEPT_NAME_KO
	, ITEM_ID
	, INPUT_QTY
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
	, PROJECT_CODE
	, DIVISION_ID AS SCM_DIVISION_ID
FROM DM_HI_SALES_INPUT
