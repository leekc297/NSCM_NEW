

/*
 * Program ID   : FPC0001_BuildingPopup[공통팝업]
 * Description  : BuildingPopup[공통팝업]
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/15   JYJ				Initial Release GSCM UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FPC0001_BuildingPopup]
  @p_sys_type		    NVARCHAR(MAX),
  @p_sys_flag		    NVARCHAR(MAX),
  @p_sys_gubun		    NVARCHAR(MAX),
  @p_user_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;

	BEGIN
        SELECT A.COMPANY_ID AS COMPANY_ID,    A.DIVISION_ID AS DIVISION_ID,     A.SITE_ID AS SITE_ID          
	        ,A.PLANT_ID AS PLANT_ID,       A.FACTORY_ID AS FACTORY_ID,        A.FACTORY_NAME AS FACTORY_NAME 
        FROM   SCM_FACTORY_M A WITH(NOLOCK)                                                                   
        WHERE  EXISTS (                                                                                       
                SELECT 1                                                                                    
                FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                   
                WHERE  A.COMPANY_ID   = B.COMPANY_ID                                                        
                AND    A.DIVISION_ID  = B.DIVISION_ID                                                       
                AND    A.SITE_ID      = B.SITE_ID                                                           
                AND    A.PLANT_ID     = B.PLANT_ID                                                          
                AND    B.USER_ID      = @p_user_id                                                
                AND	   B.SAVE_FLAG	  = 'Y'                                                              
            )                                                                                               
        AND   A.ACTIVE_FLAG = 'Y'                                                                       
		AND ( A.SITE_ID LIKE   CASE WHEN @p_site_id = '' Or @p_site_id IS NULL THEN '%'  ELSE @p_site_id +'%' END --CheckListBox
				OR ( A.SITE_ID IN  ( SELECT token FROM dbo.String_Split(@p_site_id,',') ) ) )
		AND ( A.DIVISION_ID LIKE   CASE WHEN @p_division_id = '' Or @p_division_id IS NULL THEN '%'  ELSE @p_division_id +'%' END --CheckListBox
				OR ( A.DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@p_division_id,',') ) ) )
		AND ( A.PLANT_ID LIKE   CASE WHEN @p_plant_id  = '' Or @p_plant_id IS NULL THEN '%'  ELSE @p_plant_id +'%' END
				OR ( A.PLANT_ID IN  ( SELECT token FROM dbo.String_Split(@p_plant_id,',') ) ) )																				
        ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
	   
	END

END

