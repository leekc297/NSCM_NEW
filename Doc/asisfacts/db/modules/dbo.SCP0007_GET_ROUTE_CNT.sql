

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
 
CREATE PROCEDURE [dbo].[SCP0007_GET_ROUTE_CNT]  
   @p_from_city    NVARCHAR(MAX)
  ,@p_to_city     NVARCHAR(MAX)    
  ,@debug_mode       NVARCHAR(1)='F'
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	SET NOCOUNT ON;

	SELECT COUNT(*) AS route_cnt 
	  FROM SCP_MST_DISTRIBUTION_ROUTE 
	 WHERE FROM_CITY = @p_from_city
	   AND TO_CITY   = @p_to_city
   
END





