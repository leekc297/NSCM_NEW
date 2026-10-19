
/*
 * Program ID   : SCM0001_GET_PLANT
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/30   SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_PLANT_BY_DIVISION]
  @p_division_id NVARCHAR(18)
AS
BEGIN
	
  SET NOCOUNT ON;
  
  SELECT A.PLANT_ID      AS CODE
       , A.PLANT_NAME    AS NAME
  FROM  [dbo].[SCM_MST_PLANT_SN] A
  WHERE  1 = 1
  AND    A.DIVISION_ID IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                    FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                    CROSS APPLY x.nodes('/t') t(c)
	               )
	;

END


