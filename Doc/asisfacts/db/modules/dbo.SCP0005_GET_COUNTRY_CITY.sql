

/*
 * Program ID   : [SCP0007_GET_COUNTRY_CITY]
 * Description  : DIVISION, SITE별 국가코드, 도시코드 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/05   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
   ex)
    exec dbo.[SCP0005_GET_COUNTRY_CITY] @p_country ='KR',@p_city='',@p_city_name='',@debug_mode ='T'
 */
 
CREATE PROCEDURE [dbo].[SCP0005_GET_COUNTRY_CITY]  
   @p_country		NVARCHAR(3)
  ,@p_city			NVARCHAR(5)    
  ,@p_city_name		NVARCHAR(100)    
  ,@debug_mode      NVARCHAR(1)='F'
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	SET NOCOUNT ON;
	
	SELECT COUNTRY, CITY, CITY_NAME 
	 FROM [dbo].[SCM_MST_CITY] A
	 WHERE VALID_YN ='Y'
	  AND ( (@p_country   IS NULL OR @p_country   = '') OR A.COUNTRY   LIKE UPPER(@p_country) +'%')
	  AND ( (@p_city	  IS NULL OR @p_city      = '') OR A.CITY	   LIKE UPPER(@p_city) +'%')
	  AND ( (@p_city_name IS NULL OR @p_city_name = '') OR A.CITY_NAME LIKE '%'+UPPER(@p_city_name)+'%')
	ORDER BY COUNTRY, CITY, CITY_NAME   
   
END





