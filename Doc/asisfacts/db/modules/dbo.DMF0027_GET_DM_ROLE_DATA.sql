
/*
 * Program ID   : SCM0001_GET_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/12  SeungJae.Hwnag         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[DMF0027_GET_DM_ROLE_DATA]
  
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT 
	   [GroupID]		AS CODE
      ,[GrpName]		AS NAME
      	
    FROM [dbo].[TB_FX_GroupInfo] WITH(NOLOCK)	
	WHERE
	[UseYN] = 'Y'
	

END

