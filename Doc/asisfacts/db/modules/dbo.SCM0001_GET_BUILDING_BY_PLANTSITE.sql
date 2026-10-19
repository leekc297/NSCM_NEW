
/*
 * Program ID   : SCM0001_GET_BUILDING_BY_PLANTSITE
 * Description  : Plant site 별 Building 정보 Combobox 생성
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/01   byunghunjung  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE procedure [dbo].[SCM0001_GET_BUILDING_BY_PLANTSITE]
@p_plant_site_id			NVARCHAR(MAX),
@p_division_id		NVARCHAR(MAX)
AS
BEGIN
	
  SET NOCOUNT ON;

 SELECT 
  DISTINCT 
       A.FACTORY_ID    AS CODE
	  , A.FACTORY_NAME  AS NAME
 FROM  [dbo].[SCM_MST_FACTORY_SN] A  
 WHERE 1=1
AND (@p_plant_site_id IS NULL OR A.PLANT_ID IN 
			(SELECT t.c.value('.', 'NVARCHAR(4000)')
            FROM   (SELECT x = CAST('<t>' + REPLACE(SUBSTRING(@p_plant_site_id,1,4), ',', '</t><t>') + '</t>' AS xml)) b
            CROSS APPLY x.nodes('/t') t(c)
	        )   
	)
AND (@p_division_id IS NULL OR A.DIVISION_ID IN 
			(SELECT t.c.value('.', 'NVARCHAR(4000)')
            FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
            CROSS APPLY x.nodes('/t') t(c)
	        )   
	)
;

END


