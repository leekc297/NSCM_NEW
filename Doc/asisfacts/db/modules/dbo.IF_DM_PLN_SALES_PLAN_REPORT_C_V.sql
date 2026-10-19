
CREATE VIEW [dbo].[IF_DM_PLN_SALES_PLAN_REPORT_C_V] 
AS
----------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : IF_DM_PLN_SALES_PLAN_REPORT_C_V
 * Description  : DW 용
 * Program History
 *================================================================================================================================
 *	Date		In Charge		Description
 *================================================================================================================================
 * 2022/05/03   HWI1993			Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2024/05/09	JSSBAE			[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2024/08/29	JSSBAE			[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼메저 추가
 */
----------------------------------------------------------------------------------------------------------------------------------


SELECT
	  A.DATA_TYPE
	, CASE WHEN A.DIVISION_ID LIKE '81%' THEN '81' ELSE A.DIVISION_ID END AS DIVISION_ID
	, A.VERSION_NO
	, A.CUTOFF_TYPE
	, A.CUTOFF_YYYYMMDD
	, A.DEPARTMENT_ID
	, A.DEPARTMENT_NAME
	, A.DEPT_ID
	, A.DEPT_NAME
	, A.END_CUST_REPORT
	, A.CUST_REPORT
	, A.PRODUCT_GROUP
	, A.PROJECT_CODE
	, A.SCM_SITE_ID
	, A.ITEM_ID
	, A.DOM_EXP
	, A.FCST_TYPE
	, A.INCOTERMS
	, A.MEASURE
	, A.PLANT_SITE_ID
	, A.YYYYMMDD
	, A.CURRENCY
	, A.QTY
	, A.CREATED_BY
	, A.CREATION_DATE
	, A.LAST_UPDATED_BY
	, A.LAST_UPDATE_DATE
	, A.ATTRIBUTE1
	, A.ATTRIBUTE2
	, A.ATTRIBUTE3
	, A.ATTRIBUTE4
	, A.ATTRIBUTE5
	, A.ATTRIBUTE6
	, A.ATTRIBUTE7
	, A.ATTRIBUTE8
	, A.ATTRIBUTE9
	, A.ATTRIBUTE10
	, A.COMPANY_ID
	, A.SOLDTO_CUST_REPORT
	, A.OWNER_NAME
	, A.CUST_GROUP_DTL
	, A.PRODUCT_DETAILS
	, A.FORECAST_INFO_SPEC
	, A.NICK_NAME
	, A.FORECAST_INFO_CELL_MODEL
	, A.FORECAST_INFO_CELL_PACK_COUNT
	, A.FORECAST_INFO_BIZ_TYPE
	, A.COMPANY_NAME
	, A.APPLICATION
	, A.APPLICATION_GR
	, A.COUNTRY_KR_NAME
	, A.ROUTE
	, A.COMPO_40
	, A.DIVISION_ID AS SCM_DIVISION_ID	
	, ISNULL(LK1.ATTRIBUTE1, '') AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
	, SINGLE.ENERGE AS ENERGE_WH	--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼메저 추가
FROM DM_PLN_SALES_PLAN_REPORT_C A
LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON A.CELL_PROD_SITE = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'DM_CELL_PROD_SITE'
LEFT JOIN 
(
 SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, A.ITEM_CLASS, A.ITEM_NAME, A.ITEM_CLASS_NAME, A.NICK_NAME, A.FORECAST_INFO_BIZ_TYPE, A.ENERGE
  FROM 
  (
		SELECT	T1.DIVISION_ID,
			T1.ITEM_ID, 
			MAX(T1.ITEM_NAME)					AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
			MAX(T1.ITEM_CLASS)					AS ITEM_CLASS,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
			MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
			MAX(T1.NICK_NAME)						AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
			MAX(T2.FORECAST_INFO_BIZ_TYPE			)		AS FORECAST_INFO_BIZ_TYPE, 
			MAX(T1.ENERGE)		AS ENERGE									--[E20240731-000852]_ENERGY 추가
		FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)					
		INNER JOIN ( SELECT DIVISION_ID, LEFT(ITEM_ID,12) AS ITEM_ID
						, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
					FROM  SCM_MST_ITEM_SN T2  WITH(NOLOCK) 
					GROUP BY DIVISION_ID, LEFT(ITEM_ID,12)
				) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
			AND LEFT(T1.ITEM_ID,12) = T2.ITEM_ID
		where 1=1
		group by T1.DIVISION_ID, T1.ITEM_ID
   ) A
) SINGLE
ON A.DIVISION_ID = SINGLE.DIVISION_ID AND A.ITEM_ID = SINGLE.ITEM_ID
