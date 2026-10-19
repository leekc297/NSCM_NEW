

/****************************************************************************************************/
/* Program ID  : SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP                                               */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/11/08  hwyoon		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
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


CREATE PROCEDURE [dbo].[SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP]  
  @p_division_id   NVARCHAR(30),
  @p_scm_site_id   NVARCHAR(30),
  @p_item_id       NVARCHAR(50),
  @p_assign_yn     NVARCHAR(1)
AS
BEGIN
	
  SET NOCOUNT ON;
    
  SELECT I.DIVISION_ID
     , MIN(D.DIVISION_NAME)   AS DIVISION_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , I.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
  FROM   [dbo].[SCM_MST_SITE_ITEM]   I WITH(NOLOCK)	     
       , [dbo].[SCM_MST_DIVISION]    D WITH(NOLOCK)	
       
       , [dbo].[SCM_MST_SITE]        S WITH(NOLOCK)	
	   , [dbo].[SCM_MST_ITEM_SN]     T WITH(NOLOCK)
  WHERE  I.DIVISION_ID  = D.DIVISION_ID
 
  AND    I.SCM_SITE_ID  = S.SCM_SITE_ID
  AND    I.DIVISION_ID  = T.DIVISION_ID
  AND    I.ITEM_ID      = T.ITEM_ID
  AND    CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
              ELSE I.DIVISION_ID
	     END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                  FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                  CROSS APPLY x.nodes('/t') t(c)
	             )
  AND    CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
              ELSE I.SCM_SITE_ID
	     END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                  FROM   (SELECT x = CAST('<t>' + REPLACE(@p_scm_site_id, ',', '</t><t>') + '</t>' AS xml)) b
                  CROSS APPLY x.nodes('/t') t(c)
	             )
  AND    (   I.ITEM_ID   LIKE '%' + @p_item_id + '%' 
          OR T.ITEM_NAME LIKE '%' + @p_item_id + '%' )
  AND ( ( @p_assign_yn IS NULL OR  @p_assign_yn ='' OR @p_assign_yn='N') OR 
		(EXISTS ( SELECT TOP 1 'X' FROM scm_mst_site_item_priority P
					WHERE P.DIVISION_ID = I.DIVISION_ID
					AND P.PLANT_SITE_ID = S.SCM_SITE_ID
					AND P.ITEM_ID = I.ITEM_ID
					AND P.VALID_YN = 'Y'
			)) 	 )
  GROUP BY I.DIVISION_ID
      
         , S.SCM_SITE_ID
         , S.SITE_DESCRIPTION
         , I.ITEM_ID
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
	     , T.NICK_NAME
	     , T.ITEM_CLASS_NAME
  ORDER BY I.DIVISION_ID
         
         , S.SCM_SITE_ID
         , S.SITE_DESCRIPTION
         , I.ITEM_ID
	     , T.ITEM_NAME
		 
  ;

END

