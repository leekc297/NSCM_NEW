
CREATE VIEW [dbo].[IF_SCM_KPI_SUMMARY_V] 
AS
/*
 * Program ID   : IF_SCM_KPI_SUMMARY_V
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
	, SALES_SITE_ID
	, ITEM_ID
	, BASIS_YYYYMMDD
	, BASIS_WEEK
	, PLAN_START_YYYYMMDD
	, PLAN_WEEK
	, YYYYMMDD
	, PLANNING_WEEK_OFFSET
	, KPI_TYPE
	, ACCUMULATED_YN
	, KPI_RATE
	, WEIGHT
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
	, ITEM_TYPE
	, DIVISION_ID AS SCM_DIVISION_ID
FROM SCM_KPI_SUMMARY

