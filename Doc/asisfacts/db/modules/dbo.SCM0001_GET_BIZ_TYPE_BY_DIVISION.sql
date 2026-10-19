
/*
 * Program ID   : SCM0001_GET_BIZ_TYPE_BY_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/18  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE procedure [dbo].[SCM0001_GET_BIZ_TYPE_BY_DIVISION]
  @p_division_id NVARCHAR(MAX)
AS
BEGIN
	
    SELECT DISTINCT 
         BIZ_TYPE       AS CODE 
       , BIZ_TYPE_NAME  AS NAME
  FROM   [DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
  WHERE   BIZ_TYPE_NAME != ''
  AND     CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
              ELSE DIVISION_ID
	     END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                  FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                  CROSS APPLY x.nodes('/t') t(c)
	             )
  ;

END


