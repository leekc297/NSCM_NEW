

/*
 * Program ID   : SSP0046_GET_TEAM_BY_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/19  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SSP0046_GET_TEAM_BY_DIVISION]
  @p_division_id NVARCHAR(18)
AS
BEGIN
	
  SELECT DISTINCT 
         B.DEPT_ID       AS CODE
       , B.DEPT_NAME_KO  AS NAME
  FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)
       , [dbo].[SCM_MST_SSO_DEPT_INFO] B  WITH(NOLOCK)
  WHERE  A.SITE_TYPE = 'SALES'
  AND    A.DEPT_ID  = B.DEPT_ID
  AND    CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
                ELSE A.DIVISION_ID
	       END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                    FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                    CROSS APPLY x.nodes('/t') t(c)
	               )
	;

END

