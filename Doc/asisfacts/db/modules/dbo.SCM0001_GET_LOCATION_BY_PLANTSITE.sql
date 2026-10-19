/*
 * Program ID   : SCM0001_GET_LOCATION_BY_PLANTSITE
 * Description  : Division, SCM_SITE 별 Location Combobox 생성
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/20   byunghunjung  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[SCM0001_GET_LOCATION_BY_PLANTSITE]  
  @p_division_id    NVARCHAR(MAX),
  @p_scm_site_id    NVARCHAR(MAX)
AS
BEGIN
	
  SET NOCOUNT ON;
    
  SELECT 
	     L.LOCATION_CODE AS CODE
	   , L.LOCATION_DESCRIPTION AS NAME
  FROM   [dbo].[SCM_MST_LOCATION] L WITH(NOLOCK)	
  WHERE 1=1
  AND    L.LOCATION_CODE = L.LOCATION_CODE
  AND    L.STORAGE_ID IS NOT NULL
  AND    (@p_division_id IS NULL OR L.DIVISION_ID IN 
				(SELECT t.c.value('.', 'NVARCHAR(4000)')
				FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
				CROSS APPLY x.nodes('/t') t(c)
				)   
	     )
  AND    (@p_scm_site_id IS NULL OR L.SCM_SITE_ID IN 
				(SELECT t.c.value('.', 'NVARCHAR(4000)')
				FROM   (SELECT x = CAST('<t>' + REPLACE(@p_scm_site_id, ',', '</t><t>') + '</t>' AS xml)) b
				CROSS APPLY x.nodes('/t') t(c)
				)   
	     )
  ORDER BY L.LOCATION_CODE
  ;

END
