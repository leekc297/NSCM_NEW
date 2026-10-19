




CREATE VIEW [dbo].[SCM_MST_SITE_DEPT_V] AS
/*
 * Program ID   : SCM_MST_SITE_DEPT_V
 * Description  : Site 대표 부서
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.09.03   Kim Jihye      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.09.11   Kim Jihye      소형의 경우 여러 Owner 인 경우 첫번째 Owner 의 부서 정보 적용
 * 
 */

SELECT DISTINCT
       ms.division_id
      ,di.dept_id
      ,di.upper_dept_id
      ,ms.scm_site_id
      ,NULL item_id
	  ,NULL project_code
FROM   scm_mst_site ms WITH(NOLOCK)
JOIN   scm_mst_sso_dept_info di WITH(NOLOCK)
ON     ms.dept_id = di.dept_id
WHERE  ms.site_type = 'SALES'
AND    ms.division_id != '40'
UNION
SELECT DISTINCT
       si.division_id
      ,di.dept_id
      ,di.upper_dept_id
      ,si.scm_site_id
      ,si.item_id
	  ,si.project_code
FROM   scm_mst_site_item si WITH(NOLOCK)
JOIN   scm_mst_sso_user_info ui WITH(NOLOCK)
ON     CASE WHEN CHARINDEX(',', si.owner) > 0 THEN LEFT(si.owner, CHARINDEX(',', si.owner)-1)
            ELSE si.owner END
	   = ui.user_id
JOIN   scm_mst_sso_dept_info di WITH(NOLOCK)
ON     ui.dept_id = di.dept_id
WHERE  si.division_id = '40'
  and  si.item_id <> '' 
  and  si.item_id is not null
  and  si.PROJECT_CODE <> ''
  and  si.PROJECT_CODE is not null


