
/*
 * Program ID   : SCM0001_GET_PLANT_SITE_BY_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/11  byunghunjung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_PLANT_SITE_BY_DIVISION]
  @p_division_id NVARCHAR(18)
AS
BEGIN
	
  SELECT A.SCM_SITE_ID AS CODE
       , A.SITE_DESCRIPTION AS NAME
  FROM   [LGCE_SCMDEV].[dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
  WHERE  1 = 1
  AND    A.SITE_TYPE = 'PLANT'
  AND    A.DIVISION_ID  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                    FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                    CROSS APPLY x.nodes('/t') t(c)
	               )
	;

END


