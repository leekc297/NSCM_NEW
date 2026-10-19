
/*
 * Program ID   : SCM0001_GET_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/15  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_DIVISION]
  
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT DIVISION_ID        AS CODE
		 , DIVISION_NAME      AS NAME
	FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)	
	;

END


