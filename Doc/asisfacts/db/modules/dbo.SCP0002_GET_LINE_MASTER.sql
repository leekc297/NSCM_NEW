
/*
 * Program ID   : SCP0002_GET_LINE_MASTER
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/05   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/04/26   byunghunjung   Location 컬럼 삭제
 * 2018/06/19	byunghunjung   Plant Site 화면에서 Valid YN = Y 로 전극변경시 표시되도록 수정
 */

CREATE PROCEDURE [dbo].[SCP0002_GET_LINE_MASTER]
  @p_division_id    NVARCHAR(MAX),  
  @p_scm_site_id    NVARCHAR(MAX),
  @p_location_code	NVARCHAR(MAX),      
  @p_factory_id		NVARCHAR(MAX),      
  @p_operation_id	NVARCHAR(MAX),      
  @p_line_id		NVARCHAR(MAX),
  @p_active_flag	NVARCHAR(MAX)
AS
BEGIN

	SELECT 
	DISTINCT
		  ls.division_id
		 ,dbo.fn_get_division_name ( ls.division_id ) AS  division_name
		 ,s.scm_site_id
		 ,dbo.fn_get_scm_site_description ( ls.division_id, s.scm_site_id )  AS site_description
		 ,fs.factory_id
		 ,fs.factory_name
		 ,os.operation_id
		 ,os.operation_name
		 ,ls.line_id
		 ,ls.line_name
		 ,ls.line_setup_group_id
		 ,ls.electrode_type
		 ,ls.active_flag
	FROM SCM_MST_LINE_SN LS(NOLOCK)
	JOIN SCM_MST_SITE S(NOLOCK) ON LS.COMPANY_ID = S.COMPANY_ID 
											AND LS.DIVISION_ID = S.DIVISION_ID 
											AND LS.PLANT_ID = S.PLANT_ID 
											AND LS.SITE_ID = S.SITE_ID
    JOIN SCM_MST_FACTORY_SN FS(NOLOCK) ON LS.COMPANY_ID = FS.COMPANY_ID 
											AND LS.DIVISION_ID = FS.DIVISION_ID 
											AND LS.PLANT_ID = FS.PLANT_ID 
											AND LS.SITE_ID = FS.SITE_ID 
											AND LS.FACTORY_ID = FS.FACTORY_ID
											AND S.OPERATION_GROUP = FS.SHOP_GROUP_ID
	JOIN SCM_MST_OPERATION_SN OS(NOLOCK) ON LS.COMPANY_ID = OS.COMPANY_ID 
											AND LS.DIVISION_ID = OS.DIVISION_ID 
											AND LS.SITE_ID = OS.SITE_ID 
											AND LS.OPERATION_ID = OS.OPERATION_ID
	 
	WHERE 1=1
	  AND S.valid_yn ='Y'
	  AND LS.division_id  = @p_division_id
	  AND ( ( @p_scm_site_id   IS NULL OR  @p_scm_site_id = ''   ) OR S.scm_site_id      IN (SELECT token FROM dbo.String_Split(@p_scm_site_id  ,',')) )
	  AND ( ( @p_factory_id    IS NULL OR  @p_factory_id = ''    ) OR ls.factory_id      IN (SELECT token FROM dbo.String_Split(@p_factory_id  ,',')) )
	  AND ( ( @p_operation_id  IS NULL OR  @p_operation_id = ''  ) OR ls.operation_id    IN (SELECT token FROM dbo.String_Split(@p_operation_id  ,',')) )
	  AND ( ( @p_line_id       IS NULL OR  @p_line_id = ''       ) OR ls.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )		
	  AND (@p_active_flag IS NULL OR ls.ACTIVE_FLAG = @p_active_flag) 								 					   
	ORDER BY ls.division_id , s.scm_site_id, fs.factory_id , os.operation_id, ls.line_id	

	;
END

