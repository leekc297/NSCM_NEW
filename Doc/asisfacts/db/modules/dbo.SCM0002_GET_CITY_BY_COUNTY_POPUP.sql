/****************************************************************************************************/
/* Program ID  : SCM0002_GET_CITY_BY_COUNTY_POPUP                                                   */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/06  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule 
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/


CREATE PROCEDURE [dbo].[SCM0002_GET_CITY_BY_COUNTY_POPUP]  
  @p_country       NVARCHAR(1000),
  @p_city          NVARCHAR(1000) 
AS
BEGIN
	
  SET NOCOUNT ON;
    
  SELECT A.COUNTRY
       , A.COUNTRY_NAME
       , B.CITY
       , B.CITY_NAME
	   , B.STATE_NM
  FROM   [dbo].[SCM_MST_COUNTRY] A WITH(NOLOCK)
       , [dbo].[SCM_MST_CITY]    B WITH(NOLOCK)
  WHERE  A.COUNTRY  = B.COUNTRY
  AND    A.VALID_YN = 'Y'
  AND    B.VALID_YN = 'Y'
  AND    (   A.COUNTRY      LIKE '%'+ @p_country + '%'
		  OR A.COUNTRY_NAME LIKE '%'+ @p_country + '%'
		 ) 
  AND    (   B.CITY      LIKE '%'+ @p_city + '%'
		  OR B.CITY_NAME LIKE '%'+ @p_city + '%'
		 ) 
  ;

END
