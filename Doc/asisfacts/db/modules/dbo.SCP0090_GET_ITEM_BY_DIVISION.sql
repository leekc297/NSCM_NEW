
/*
 * Program ID   : [SCP0090_GET_ITEM_BY_DIVISION]
 * Description  : ALLO_TARGET_REQUEST All Item
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/07/28   LWY   Initial Release PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2
 */

CREATE PROCEDURE [dbo].[SCP0090_GET_ITEM_BY_DIVISION]
	 @p_division_id   NVARCHAR(30)
    ,@p_project_code  NVARCHAR(100)
    ,@p_scm_site_id   NVARCHAR(50)
    ,@p_item_id       NVARCHAR(100)

AS
BEGIN
		
	SELECT distinct I.ITEM_ID
	  FROM [SCM_MST_SITE_ITEM]			I WITH(NOLOCK)	     
	  JOIN [SCM_MST_DIVISION]			D WITH(NOLOCK) ON I.DIVISION_ID  = D.DIVISION_ID
	  JOIN [SCM_MST_SITE]				S WITH(NOLOCK) ON I.DIVISION_ID  = S.DIVISION_ID AND I.SCM_SITE_ID  = S.SCM_SITE_ID	
	  JOIN [SCM_MST_ITEM_SN]			T WITH(NOLOCK) ON I.DIVISION_ID  = T.DIVISION_ID AND I.ITEM_ID      = T.ITEM_ID
	  WHERE 1=1
	  AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END IN (SELECT token FROM dbo.String_Split(@p_division_id  ,','))
	  AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE I.SCM_SITE_ID END IN (SELECT token FROM dbo.String_Split(@p_scm_site_id  ,','))
	  ;
		


END





