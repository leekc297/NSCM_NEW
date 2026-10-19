


CREATE VIEW [dbo].[IF_DM_MOBILE_REPORT_PRODUCT_V] 
AS
/*
 * Program ID   : IF_DM_MOBILE_REPORT_PRODUCT_V
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
	, YYYY
	, SP_BP_TYPE
	, PRODUCT_NAME
	, PRODUCT_DETAIL
	, MEASURE
	, MM01
	, MM02
	, MM03
	, MM04
	, MM05
	, MM06
	, MM07
	, MM08
	, MM09
	, MM10
	, MM11
	, MM12
	, ORI_VERSION_NO
	, SORT_NO
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
FROM DM_MOBILE_REPORT_PRODUCT
