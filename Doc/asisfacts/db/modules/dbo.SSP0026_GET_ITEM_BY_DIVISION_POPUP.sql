/****************************************************************************************************/
/* Program ID  : SSP0026_GET_ITEM_BY_DIVISION_POPUP                                                 */
/* Description : Procedure 작성 가이드                                                               */
/* Usage       : Procedure 작성 시 참조하세요!                                                       */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2022/01/04  KIMYONGHO    신규추가																	*/
/****************************************************************************************************/

create PROCEDURE [dbo].[SSP0026_GET_ITEM_BY_DIVISION_POPUP]  
  @p_division_id   NVARCHAR(30),
  @p_project_code  NVARCHAR(50),
  @p_scm_site_id   NVARCHAR(30),
  @p_item_id       NVARCHAR(50)
AS
BEGIN
	
  SET NOCOUNT ON;
    
  SELECT distinct
       D.DIVISION_ID
     , D.DIVISION_NAME
     , ISNULL(P.PROJECT_CODE,'-') AS PROJECT_CODE
     , ISNULL(P.PROJECT_NAME,'-') AS PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     --, I.ITEM_ID
	 , CASE WHEN ISNULL(S.PACKER_ITEM_ID_SUFFIX,'') = '' THEN I.ITEM_ID ELSE ISNULL(STUFF(I.ITEM_ID,12,1, S.PACKER_ITEM_ID_SUFFIX), I.ITEM_ID)  END  AS ITEM_ID
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
  FROM [SCM_MST_SITE_ITEM]			I WITH(NOLOCK)	     
  JOIN [SCM_MST_DIVISION]			D WITH(NOLOCK) ON I.DIVISION_ID  = D.DIVISION_ID
  JOIN [SCM_MST_SITE]				S WITH(NOLOCK) ON I.DIVISION_ID  = S.DIVISION_ID AND I.SCM_SITE_ID  = S.SCM_SITE_ID	
  JOIN [SCM_MST_ITEM_SN]			T WITH(NOLOCK) ON I.DIVISION_ID  = T.DIVISION_ID AND I.ITEM_ID      = T.ITEM_ID  
  LEFT OUTER JOIN [SCM_MST_PROJECT] P WITH(NOLOCK) ON I.DIVISION_ID  = P.DIVISION_ID AND I.PROJECT_CODE = P.PROJECT_CODE
  WHERE 1=1
  AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END IN (SELECT token FROM dbo.String_Split(@p_division_id  ,','))
  AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE I.SCM_SITE_ID END IN (SELECT token FROM dbo.String_Split(@p_scm_site_id  ,','))
  AND I.PROJECT_CODE LIKE '%' + @p_project_code + '%' 
  AND (      CASE WHEN ISNULL(S.PACKER_ITEM_ID_SUFFIX,'') = '' THEN I.ITEM_ID ELSE ISNULL(STUFF(I.ITEM_ID,12,1, S.PACKER_ITEM_ID_SUFFIX), I.ITEM_ID) END  LIKE '%' + @p_item_id + '%' 
          OR T.ITEM_NAME LIKE '%' + @p_item_id + '%'
		  OR T.NICK_NAME LIKE '%' + @p_item_id + '%'
		   )
  ORDER BY D.DIVISION_ID, S.SCM_SITE_ID, S.SITE_DESCRIPTION, T.ITEM_NAME
		 
  ;

END
