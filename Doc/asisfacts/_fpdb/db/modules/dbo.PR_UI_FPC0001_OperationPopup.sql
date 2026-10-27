

/*
 * Program ID   : FPC0001_OperationPopup[공통팝업]
 * Description  : Operation Master
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/15   JYJ				Initial Release GSCM UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FPC0001_OperationPopup]
  @p_sys_type		    NVARCHAR(MAX),
  @p_sys_flag		    NVARCHAR(MAX),
  @p_sys_gubun		    NVARCHAR(MAX),
  @p_user_id			NVARCHAR(MAX), 
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_operation_id		NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;

      SELECT 	DISTINCT  A.COMPANY_ID AS COMPANY_ID,  A.DIVISION_ID AS DIVISION_ID,  A.SITE_ID AS SITE_ID
	    , A.OPERATION_ID AS OPERATION_ID, '('+A.OPERATION_ID+')'+ISNULL(A.OPERATION_NAME, OPERATION_ID) AS OPERATION_NAME
    	, A.OPERATION_GROUP_ID, A.OPERATION_GROUP_NAME
      FROM   SCM_OPERATION_M A WITH(NOLOCK)
      WHERE  	(	
      				(
              			EXISTS ( SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M B(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE='P' )
              			AND MES_ERP_INTERFACE_FLAG='Y'
              		) OR
              		(
              			NOT EXISTS ( SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M B(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE='P' )
              		)	
				)
    	AND EXISTS (
						SELECT 1 FROM SCM_LINE_M C WITH(NOLOCK)
						WHERE C.COMPANY_ID   = A.COMPANY_ID
						AND   C.DIVISION_ID  = A.DIVISION_ID
						AND   C.SITE_ID      = A.SITE_ID
						AND   C.OPERATION_ID = A.OPERATION_ID
						AND   C.ACTIVE_FLAG  = 'Y'
	                   -- AND ( C.PLANT_ID LIKE   CASE WHEN @p_plant_id  = '' Or '' IS NULL THEN '%'  ELSE @p_plant_id +'%' END
				                -- OR ( C.PLANT_ID IN  ( SELECT token FROM dbo.String_Split(@p_plant_id,',') ) ) )		
	                  	--AND ( C.FACTORY_ID LIKE   CASE WHEN @p_factory_id  = '' Or '' IS NULL THEN '%'  ELSE @p_factory_id +'%' END
				                -- OR ( C.FACTORY_ID IN  ( SELECT token FROM dbo.String_Split(@p_factory_id,',') ) ) )	
                  )
      AND   A.ACTIVE_FLAG = 'Y'
      --AND   A.COMPANY_ID  LIKE '%' + @p_company_id + '%'
	  AND ( A.DIVISION_ID LIKE   CASE WHEN @p_division_id = '' Or @p_division_id IS NULL THEN '%'  ELSE @p_division_id +'%' END --CheckListBox
				OR ( A.DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@p_division_id,',') ) ) )
      AND ( A.SITE_ID LIKE   CASE WHEN @p_site_id = '' Or @p_site_id IS NULL THEN '%'  ELSE @p_site_id +'%' END --CheckListBox
				OR ( A.SITE_ID IN  ( SELECT token FROM dbo.String_Split(@p_site_id,',') ) ) )
      AND ( A.OPERATION_ID LIKE   CASE WHEN @p_operation_id  = '' Or @p_operation_id IS NULL THEN '%'  ELSE @p_operation_id +'%' END
				OR ( A.OPERATION_ID IN  ( SELECT token FROM dbo.String_Split(@p_operation_id,',') ) ) )	
      AND    EXISTS (
			        	SELECT 1
			        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)
			        	WHERE  A.COMPANY_ID  = B.COMPANY_ID
			        	AND    A.DIVISION_ID = B.DIVISION_ID
			        	AND    A.SITE_ID     = B.SITE_ID
			        	AND    A.OPERATION_ID = B.OPERATION_ID
			        	AND    B.USER_ID      = @p_user_id
			        	AND	   B.SAVE_FLAG	  = 'Y'
			      	)
      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
	  ;
END

