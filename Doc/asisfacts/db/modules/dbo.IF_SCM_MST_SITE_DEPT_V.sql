
CREATE VIEW [dbo].[IF_SCM_MST_SITE_DEPT_V] 
AS
/*
 * Program ID   : IF_SCM_MST_SITE_DEPT_V
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
	, dept_id
	, upper_dept_id
	, scm_site_id
	, item_id
	, project_code
	, DIVISION_ID AS SCM_DIVISION_ID
FROM SCM_MST_SITE_DEPT_V

