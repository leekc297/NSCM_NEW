
CREATE VIEW [dbo].[IF_SCM_MST_SITE_ITEM_V] 
AS
/*
 * Program ID   : IF_SCM_MST_SITE_ITEM_V
 * Description  : DW 용
 * Program History
 *===================================================================================================
 *   Date       In Charge       Description
 *===================================================================================================
 * 2022.05.03   HWI1993         Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2024.12.02   Philsu Park     Report용 컬럼 2건 추가 반영(CRGE_ORG_NM, CUST_ENG_NM)
 * 
 */


SELECT
	  
	 CASE WHEN DIVISION_ID LIKE '81%' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	, PROJECT_CODE
	, SCM_SITE_ID
	, ITEM_ID
	, CURRENCY
	, CELL_PER_CAR
	, CELL_PER_MODULE
	, LIABILITY_PERIOD
	, SALES_PLAN_ADJUST_YN
	, ITEM_HRCY_ID
	, VALID_YN
	, BPMS_EXIST
	, CUST_GROUP
	, CUST_GROUP_DTL
	, OWNER
	, APPLICATION
	, ROUTE
	, SALES_COMPANY
	, SALES_PLANT
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
	, REPORT_GROUP1
	, REPORT_GROUP2
	, REPORT_GROUP3
	, REPORT_GROUP4
	, REPORT_GROUP5
	, REPORT_GROUP6
	, REPORT_GROUP7
	, REPORT_GROUP8
	, EDI_LT
	, SCP_VMI_LT
	, PARTIAL_PLAN_YN
	, DIVISION_ID AS SCM_DIVISION_ID
    , CRGE_ORG_NM
    , CUST_ENG_NM
FROM SCM_MST_SITE_ITEM

