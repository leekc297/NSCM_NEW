

/*
 * Program ID   : [SCP0007_GET_COUNTRY_CITY]
 * Description  : DIVISION, SITE별 국가코드, 도시코드 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/08   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
   ex)
    exec dbo.[SCP0007_GET_COUNTRY_CITY] @p_division_id ='81',@p_scm_site_id='',@debug_mode ='T'
 */
 
CREATE PROCEDURE [dbo].[SCP0007_GET_COUNTRY_CITY]  
   @p_division_id    NVARCHAR(MAX)
  ,@p_scm_site_id    NVARCHAR(MAX)    
  ,@debug_mode       NVARCHAR(1)='F'
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	SET NOCOUNT ON;
	
	SELECT division_id
		, scm_site_id
		, country
		, city 
		, VMI_YN
		, SITE_TYPE		
	 FROM scm_mst_site A 
	WHERE 1=1
	  AND ( (@p_division_id IS NULL OR @p_division_id = '') OR A.division_id IN (SELECT token FROM dbo.String_Split(@p_division_id	,',')) )
	  AND ( (@p_scm_site_id IS NULL OR @p_scm_site_id = '') OR A.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_scm_site_id	,',')) )
	  
   
END





