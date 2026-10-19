/****************************************************************************************************/
/* Program ID  : DM0003_GET_ITEM_BY_DIVISION_POP                                                 */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 20181205 nick name 조회요청으로 수정                                                             */
/* 2024/08/29	KJJ			[PJ2024-50461] Team Mapping*/
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
CREATE PROCEDURE [dbo].[DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx]  
  @p_division_id   NVARCHAR(MAX),
  @p_dept_id        NVARCHAR(MAX),	--Department
  @p_end_customer   NVARCHAR(MAX),	--Endcustomer
  @p_project_code  NVARCHAR(MAX),
  @p_scm_site_id   NVARCHAR(MAX),
  @p_item_id       NVARCHAR(MAX),
  @p_item_type     NVARCHAR(MAX)
AS
BEGIN
	
  SET NOCOUNT ON;
  
  /*  
  SELECT I.DIVISION_ID
     , I.DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , C.END_CUSTOMER
	 , D.CURRENCY

  FROM   (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN='Y') AS  I 
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE_ITEM] WITH(NOLOCK) WHERE VALID_YN='Y') AS D 
	   ON I.DIVISION_ID  = D.DIVISION_ID
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_PROJECT] WITH(NOLOCK)) AS A 
	   ON D.PROJECT_CODE = A.PROJECT_CODE
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE] WITH(NOLOCK) WHERE VALID_YN='Y') S 
	   ON D.SCM_SITE_ID  = S.SCM_SITE_ID
	   --LEFT JOIN [dbo].[SCM_MST_ITEM_SN]     T WITH(NOLOCK)
	   LEFT JOIN [dbo].DM_MST_ITEM_SINGLE_V     T WITH(NOLOCK)
	   ON I.DIVISION_ID  = T.DIVISION_ID AND    D.ITEM_ID      = T.ITEM_ID
	   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
	   ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
	   LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM			       
	   ON C.DEPT_ID = TEAM.DEPT_ID
	   LEFT JOIN (
					SELECT  LOOKUP_CODE AS CODE, [DESCRIPTION] AS NAME
					FROM [dbo].[SCM_ADM_LOOKUP_VALUES] WITH(NOLOCK) 
					WHERE
					VALID_YN ='Y' 
					AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
	   )  AS ITEM_TYPE_CODE			       
	   ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	   

WHERE 
        CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE I.DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
	               )
		AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   		 ELSE TEAM.DEPT_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
					(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
	               )
		AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE isnull(C.END_CUSTOMER,'')			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
					(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(C.END_CUSTOMER,'') END) = P.data
	               )				   
		 
		AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   		 ELSE S.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
	               )
		--AND CASE WHEN @p_project_code = '' THEN ''
		--   		 ELSE A.PROJECT_CODE			
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@p_project_code,',') as P Where 
		--			(CASE WHEN @p_project_code = '' THEN '' ELSE A.PROJECT_CODE END) = P.data
	 --              )
		--AND CASE WHEN @p_project_code = '' THEN ''
		--   		 ELSE A.PROJECT_NAME			
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@p_project_code,',') as P Where 
		--			(CASE WHEN @p_project_code = '' THEN '' ELSE A.PROJECT_NAME END) = P.data
	 --              ) 

		--AND CASE WHEN @p_item_id = '' THEN ''
		--   		 ELSE D.ITEM_ID			
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@p_item_id,',') as P Where 
		--			(CASE WHEN @p_item_id = '' THEN '' ELSE D.ITEM_ID END) = P.data
	 --              )
		--AND CASE WHEN @p_item_id = '' THEN ''
		--   		 ELSE T.ITEM_NAME			
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@p_item_id,',') as P Where 
		--			(CASE WHEN @p_item_id = '' THEN '' ELSE T.ITEM_NAME END) = P.data
	 --              )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_CODE LIKE P.token +'%')
	     OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
		 )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where D.ITEM_ID LIKE P.token +'%')
	     OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
		 )	 
	 --AND    (   A.PROJECT_CODE LIKE '%'+ @p_project_code + '%'
		--  OR A.PROJECT_NAME LIKE '%'+ @p_project_code + '%'
		-- )
  
  --   AND    (   D.ITEM_ID   LIKE '%' + @p_item_id + '%' 
  --        OR T.ITEM_NAME LIKE '%' + @p_item_id + '%' )


  GROUP BY 
		I.DIVISION_ID
     , I.DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , C.END_CUSTOMER
	 , D.CURRENCY

  ORDER BY I.DIVISION_ID
         , D.PROJECT_CODE
         , A.PROJECT_NAME
         , S.SCM_SITE_ID
         , S.SITE_DESCRIPTION
         , D.ITEM_ID
	     , T.ITEM_NAME
*/		 
  
  if @p_division_id <> '40'
  BEGIN
	  SELECT DISTINCT I.DIVISION_ID
		 , I.DIVISION_ID  AS DIVISION_NAME
		 , D.PROJECT_CODE
		 , A.PROJECT_NAME
		 , S.SCM_SITE_ID
		 , S.SITE_DESCRIPTION
		 , D.ITEM_ID	 
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME
		 , TEAM.DEPT_ID
		 , TEAM.DEPT_NAME_KO
		 , C.END_CUSTOMER
		 , D.CURRENCY

	  FROM   (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN='Y') AS  I 
		   LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE_ITEM] WITH(NOLOCK) WHERE VALID_YN='Y') AS D 
		   ON I.DIVISION_ID  = D.DIVISION_ID
		   LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_PROJECT] WITH(NOLOCK)) AS A 
		   ON D.PROJECT_CODE = A.PROJECT_CODE
		   LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE] WITH(NOLOCK) WHERE VALID_YN='Y') S 
		   ON D.SCM_SITE_ID  = S.SCM_SITE_ID   
		   --LEFT JOIN [dbo].[SCM_MST_ITEM_SN]     T WITH(NOLOCK)
		   LEFT JOIN [dbo].DM_MST_ITEM_SINGLE_V     T WITH(NOLOCK)
		   ON I.DIVISION_ID  = T.DIVISION_ID AND    D.ITEM_ID      = T.ITEM_ID
		   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
		   ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID

		   --[PJ2024-50461] Team Mapping------------------------------------
		   --LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM			       
		   --ON C.DEPT_ID = TEAM.DEPT_ID
			LEFT JOIN (
				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
				FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
				INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
			ON              TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](D.owner, ','))
		   --[PJ2024-50461] Team Mapping------------------------------------
		   LEFT JOIN (
						 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
						 FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
						WHERE
						VALID_YN ='Y' 
						AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		   )  AS ITEM_TYPE_CODE			       
		   ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	   
	WHERE   I.DIVISION_ID = '81'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회 
	  AND   SITE_TYPE = 'SALES'
	  AND   CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE I.DIVISION_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
						(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
					   )
			AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   			 ELSE TEAM.DEPT_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
						(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					   )
			AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE isnull(C.END_CUSTOMER,'')			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
						(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(C.END_CUSTOMER,'') END) = P.data
					   )				   
		 
			AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE S.SCM_SITE_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
						(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
					   )
		 AND (
			 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where D.PROJECT_CODE LIKE P.token +'%')
			 OR
			 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
			 )
		 AND (
			 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where D.ITEM_ID LIKE P.token +'%')
			 --OR
			 --Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
			 OR
			 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.NICK_NAME LIKE P.token +'%')
			 )	 --20181205 nick name 조회요청으로 수정

	UNION 

	  SELECT DISTINCT I.DIVISION_ID
		 , I.DIVISION_ID  AS DIVISION_NAME
		 , D.PROJECT_CODE
		 , A.PROJECT_NAME
		 , S.SCM_SITE_ID
		 , S.SITE_DESCRIPTION
		 , T.ITEM_ID	 
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME
		 , TEAM.DEPT_ID
		 , TEAM.DEPT_NAME_KO
		 , C.END_CUSTOMER
		 , A.CURRENCY

	  FROM   (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN='Y') AS  I 
	  --[PJ2024-50461] Team Mapping------------------------------------
		   --LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE FROM [dbo].[SCM_MST_SITE_ITEM] WITH(NOLOCK) WHERE VALID_YN='Y') AS D 
		   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE,owner FROM [dbo].[SCM_MST_SITE_ITEM] WITH(NOLOCK) WHERE VALID_YN='Y') AS D 
		--[PJ2024-50461] Team Mapping------------------------------------
		ON I.DIVISION_ID  = D.DIVISION_ID
		   LEFT OUTER JOIN (SELECT * FROM [dbo].[SCM_MST_PROJECT] WITH(NOLOCK)) AS A 
		ON D.PROJECT_CODE = A.PROJECT_CODE
		   LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE] WITH(NOLOCK) WHERE VALID_YN='Y') S 
		ON D.SCM_SITE_ID  = S.SCM_SITE_ID

		LEFT OUTER JOIN [dbo].DM_MST_ITEM_SINGLE_V     T WITH(NOLOCK)

		ON I.DIVISION_ID  = T.DIVISION_ID AND T.ITEM_TYPE not in ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
		LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
		ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID

		--[PJ2024-50461] Team Mapping------------------------------------
		--LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM          
		--ON C.DEPT_ID = TEAM.DEPT_ID
		LEFT JOIN (
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
			FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
			ON B.DEPT_ID = C.DEPT_ID
		) AS TEAM
		ON              TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](D.owner, ','))
		--[PJ2024-50461] Team Mapping------------------------------------


		LEFT JOIN (
		 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
		 FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
		 WHERE
		 VALID_YN ='Y' 
		 AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		)  AS ITEM_TYPE_CODE          
		ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	   
	WHERE   I.DIVISION_ID = '82'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회 
	  AND   SITE_TYPE = 'SALES'
	--  AND   D.PROJECT_CODE = 'DC-17-001'


	  AND   CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE I.DIVISION_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
						(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
					   )
			AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   			 ELSE TEAM.DEPT_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
						(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					   )
			AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE isnull(C.END_CUSTOMER,'')			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
						(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(C.END_CUSTOMER,'') END) = P.data
					   )				   
		 
			AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE S.SCM_SITE_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
						(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
					   )
		 AND (
			 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where D.PROJECT_CODE LIKE P.token +'%')
			 OR
			 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
			 )
		 AND (
			 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_ID LIKE P.token +'%')
			 --OR
			 --Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
			 OR
			 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.NICK_NAME LIKE P.token +'%')
			 )	 --20181205 nick name 조회요청으로 수정
		ORDER BY I.DIVISION_ID
		, D.PROJECT_CODE
		, A.PROJECT_NAME
		, S.SCM_SITE_ID
		, S.SITE_DESCRIPTION
		, D.ITEM_ID
		, T.ITEM_NAME
	END
	ELSE	--40
	BEGIN
		--DIVISION_ID, DIVISION_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_TYPE_NAME, NICK_NAME, ITEM_CLASS_NAME
 	  SELECT  T.DIVISION_ID
		 , T.DIVISION_ID  AS DIVISION_NAME
		 , '' AS PROJECT_CODE
		 , '' AS PROJECT_NAME
		 , '' AS SCM_SITE_ID
		 , '' AS SITE_DESCRIPTION
		 , T.ITEM_ID	 
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME	--model type
		 , '' AS DEPT_ID
		 , '' AS DEPT_NAME_KO
		 , '' AS END_CUSTOMER
		 , '' AS CURRENCY
	  FROM DM_MST_ITEM_SINGLE_V	T
		LEFT JOIN (
		 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
		 FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
		 WHERE
		 VALID_YN ='Y' 
		 AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		)  AS ITEM_TYPE_CODE          
		ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	WHERE  T.division_id = '40'
		 AND (
			 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_ID LIKE P.token +'%')
			 --OR
			 --Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
			 OR
			 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.NICK_NAME LIKE P.token +'%')
			 )	 --20181205 nick name 조회요청으로 수정
		AND T.ITEM_TYPE  IN (
						 Select * from dbo.UF_FX_String_SplitForIN (@p_item_type,',') as P Where (CASE WHEN @p_item_type = '' THEN '' ELSE T.ITEM_TYPE END) = P.data
						)
	  ORDER BY T.ITEM_ID	   
		 
	  /*	      
	  SELECT DISTINCT top 1000 I.DIVISION_ID
		 , I.DIVISION_ID  AS DIVISION_NAME
		 , '' AS PROJECT_CODE
		 , '' AS PROJECT_NAME
		 , '' AS SCM_SITE_ID
		 , '' AS SITE_DESCRIPTION
		 , T.ITEM_ID	 
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME	--model type
		 , '' AS DEPT_ID
		 , '' AS DEPT_NAME_KO
		 , '' AS END_CUSTOMER
		 , '' AS CURRENCY

	  FROM   (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN='Y') AS  I 
		   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE FROM [dbo].[SCM_MST_SITE_ITEM] WITH(NOLOCK) WHERE VALID_YN='Y') AS D 
		ON I.DIVISION_ID  = D.DIVISION_ID
		   LEFT OUTER JOIN (SELECT * FROM [dbo].[SCM_MST_PROJECT] WITH(NOLOCK)) AS A 
		ON D.PROJECT_CODE = A.PROJECT_CODE
		   LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE] WITH(NOLOCK) WHERE VALID_YN='Y') S 
		ON D.SCM_SITE_ID  = S.SCM_SITE_ID

		LEFT OUTER JOIN [dbo].DM_MST_ITEM_SINGLE_V     T WITH(NOLOCK)

		ON I.DIVISION_ID  = T.DIVISION_ID ------AND T.ITEM_TYPE not in ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
		LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
		ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
		LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM          
		ON C.DEPT_ID = TEAM.DEPT_ID
		LEFT JOIN (
		 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
		 FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
		 WHERE
		 VALID_YN ='Y' 
		 AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		)  AS ITEM_TYPE_CODE          
		ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE

	WHERE I.DIVISION_ID = '40'  -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회 
	 AND   SITE_TYPE = 'SALES'
	  AND   CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE I.DIVISION_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
						(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
					   )
			AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   			 ELSE TEAM.DEPT_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
						(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					   )
			--AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
			--   		 ELSE isnull(C.END_CUSTOMER,'')			
			--	END IN (
			--			Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
			--			(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(C.END_CUSTOMER,'') END) = P.data
		 --              )				   
			  AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE isnull(
						CASE WHEN @p_division_id <> '40' THEN C.END_CUSTOMER ELSE D.PROJECT_CODE END
					 ,'')			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
						(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(
							CASE WHEN @p_division_id <> '40' THEN C.END_CUSTOMER ELSE D.PROJECT_CODE END
						,'') END) = P.data
			)
			AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE S.SCM_SITE_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
						(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
					   )
	--***
		 ----AND (
			---- Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where D.PROJECT_CODE LIKE P.token +'%')
		 ----    OR
			---- Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
			---- )
	--***
		 ------AND (
			------ Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_ID LIKE P.token +'%')
		 ------    OR
			------ Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
			------ )	 

				AND CASE WHEN @p_item_id = '' THEN ''
		   			 ELSE T.ITEM_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_item_id,',') as P Where 
						(CASE WHEN @p_item_id = '' THEN '' ELSE T.ITEM_ID END) = P.data
					   )
				AND CASE WHEN @p_item_type = '' THEN ''
		   			 ELSE T.ITEM_TYPE			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_item_type,',') as P Where 
						(CASE WHEN @p_item_type = '' THEN '' ELSE T.ITEM_TYPE END) = P.data
					   )

		----AND (T.ITEM_TYPE  = 'H' OR T.ITEM_TYPE  = 'P' OR T.ITEM_TYPE  = 'R' OR T.ITEM_TYPE  = 'Q')	--*****
	  ORDER BY I.DIVISION_ID
			 --, D.PROJECT_CODE
			 --, A.PROJECT_NAME
			 --, S.SCM_SITE_ID
			 --, S.SITE_DESCRIPTION
			 , T.ITEM_ID
			 , T.ITEM_NAME
	 --DIVISION_ID, DIVISION_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_TYPE_NAME, NICK_NAME, ITEM_CLASS_NAME
	 */
	END

END
