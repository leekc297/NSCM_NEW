
/*
 * Program ID   : SCM0001_GET_TO_SITE
 * Description  : To Site 정보 Combobox 생성
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/01   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_TO_SITE]
  
AS
BEGIN
	
	SET NOCOUNT ON;
  
	SELECT SCM_SITE_ID        AS CODE
		 , SITE_DESCRIPTION   AS NAME
	FROM [dbo].[SCM_MST_SITE] WITH(NOLOCK)	
	;

END


