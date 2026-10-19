
CREATE FUNCTION [dbo].[FN_GET_SSP_PROJECT_OWNER]
(
  @p_division_id     NVARCHAR(30),
  @p_to_site         NVARCHAR(30),
  @p_item_id         NVARCHAR(50),
  @p_project_code    NVARCHAR(50)
)

RETURNS NVARCHAR(100)
AS
/*
 * Program ID   : FN_GET_SSP_PROJECT_OWNER
 * Description  : PROJECT OWNER  
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.07.24   juhlee     Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트

 */
BEGIN
  
  DECLARE @v_owner NVARCHAR(100)
  DECLARE @v_cnt   int 


	SELECT  @v_cnt = COUNT(*) 
	FROM  SCM_MST_SITE_ITEM WITH(NOLOCK) 
	WHERE 1=1 
	AND   DIVISION_ID   = @p_division_id
	AND   SCM_SITE_ID   = @p_to_site     
	AND   ITEM_ID       = @p_item_id     
	AND   PROJECT_CODE  = @p_project_code
    AND   VALID_YN      = 'Y'

	IF @v_cnt > 0 


	SELECT top 1 @v_owner = OWNER
	FROM  SCM_MST_SITE_ITEM WITH(NOLOCK) 
	WHERE 1=1 
	AND   DIVISION_ID   = @p_division_id
	AND   SCM_SITE_ID   = @p_to_site     
	AND   ITEM_ID       = @p_item_id     
	AND   PROJECT_CODE  = @p_project_code
    AND   VALID_YN      = 'Y'

	ELSE 
	 
   
	SELECT top 1 @v_owner = OWNER
	FROM  SCM_MST_SITE_ITEM WITH(NOLOCK) 
	WHERE 1=1 
	AND   DIVISION_ID   = @p_division_id
	AND   SCM_SITE_ID   = @p_to_site     
	AND   ITEM_ID       = @p_item_id     
	-- AND   PROJECT_CODE  = @p_project_code
    AND   VALID_YN      = 'Y'
	AND   OWNER IS NOT  NULL 



	
  RETURN @v_owner;

END
;

