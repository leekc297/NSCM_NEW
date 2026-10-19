
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************
 * Program ID  : SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX                                               
 * Description : Sales Price화면에서 Project Code를 가져오는 경우에 사용한다.                                                           
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   : division_id, dept_id, end_customer, scm_site_id, project_code                                                                                    
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description                                                             
 *--------------------------------------------------------------------------------------------------
 * 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2020/05/04  P.C.I        [PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - ETC 추가    
 * 2024/12/13  jssbae       [PJ2024-50461] Team Mapping      
 * 2025/04/16  jssbae		[E20250416-001094]_SSPM Owner 기준 Team정보 Mapping 로직 개선   
 ****************************************************************************************************/

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


CREATE PROCEDURE [dbo].[SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX]  
  @p_division_id   NVARCHAR(MAX),
  @p_dept_id       NVARCHAR(MAX),	--Department
  @p_end_customer  NVARCHAR(MAX),	--Endcustomer
  @p_scm_site_id   NVARCHAR(MAX),
  @p_project_code  NVARCHAR(MAX),
  @p_etc		   NVARCHAR(MAX) = null -- [PJ20200138] ETC Flag 추가
AS
   -- EXEC SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX @p_division_id='ALL', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='ALL', @p_project_code=''

BEGIN
	
  SET NOCOUNT ON;
    
  --SELECT A.DIVISION_ID
  --     , MIN(D.DIVISION_NAME)   AS DIVISION_NAME
  --     , A.PROJECT_CODE
  --     , A.PROJECT_NAME
  --     , A.PROJECT_STATUS
	 --  , A.BIZ_TYPE
	 --  , A.CURRENCY
  --     , MAX(A.PROJECT_VER_SEQ)  AS PROJECT_VER_SEQ
	 --  , A.PROJECT_OWNER
	 --  , TEAM.DEPT_ID
	 --  , TEAM.DEPT_NAME_KO
	 --  , C.END_CUSTOMER
  --FROM   [dbo].[SCM_MST_PROJECT]  A WITH(NOLOCK)	
  --LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN = 'Y') D
  --ON A.DROP_YN = 'N' AND A.DIVISION_ID = D.DIVISION_ID
  --LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
  --ON A.DIVISION_ID = C.DIVISION_ID 
  --LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM			       
		--	       ON C.DEPT_ID = TEAM.DEPT_ID

 IF @p_etc = 'N' 
	BEGIN
	  SELECT A.DIVISION_ID
		   , A.DIVISION_ID  AS DIVISION_NAME
		   , A.PROJECT_CODE
		   , A.PROJECT_NAME
		   , A.PROJECT_STATUS
		   --, A.BIZ_TYPE
		   --, A.BIZ_TYPE 
		   , BIZ.CODE AS BIZ_TYPE
		   , BIZ.NAME AS BIZ_TYPE_NAME
		   , A.CURRENCY
		   , MAX(A.PROJECT_VER_SEQ)  AS PROJECT_VER_SEQ
		   , A.PROJECT_OWNER
		   , TEAM.DEPT_ID
		   , TEAM.DEPT_NAME_KO
		   , C.END_CUSTOMER
	  FROM  (SELECT * FROM [dbo].[SCM_MST_PROJECT] WITH(NOLOCK))   AS A 	
	  LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN = 'Y') D
	  ON A.DROP_YN = 'N' AND A.DIVISION_ID = D.DIVISION_ID
	  LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE_ITEM] WITH(NOLOCK) WHERE VALID_YN='Y') AS B 
		   ON A.DIVISION_ID  = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
	  LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
	  ON B.DIVISION_ID = C.DIVISION_ID AND B.SCM_SITE_ID= C.SCM_SITE_ID	  
	  --[PJ2024-50461] Team Mapping START 주석처리 하고 변경 내역을 적용한다.	        
	  /*
		LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM			       
						ON C.DEPT_ID = TEAM.DEPT_ID
	  */
	  LEFT JOIN [SCM_MST_SSO_USER_INFO] SU WITH(NOLOCK)
	  --[E20250416-001094]_SSPM Owner 기준 Team정보 Mapping 로직 개선  
	  --SCM_MST_SITE_ITEM 해당 테이블은 OWNER가 여러명을 가질수 있는 구조로, 해당조건으로 JOIN하면 데이터가 생성되지 않음
	  --SPLIT해서 TOP1만 가지고 오는 구조로 변경 
			 --ON SU.USER_ID = B.OWNER
			 ON SU.USER_ID = (SELECT TOP 1 token FROM [dbo].[String_Split](B.OWNER, ','))
	  LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM	
			 ON SU.DEPT_ID = TEAM.DEPT_ID
	  --[PJ2024-50461] Team Mapping	END	       
	  LEFT JOIN (
  			SELECT SEGMENT1 CODE,
					SEGMENT2 AS NAME
			FROM   SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
			WHERE  LOOKUP_TYPE = 'BIZ_TYPE_BPMS'
	  ) BIZ
	  ON BIZ.CODE = A.BIZ_TYPE

	  WHERE TEAM.DEPT_ID IS NOT NULL
			AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE A.DIVISION_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
						(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.data
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
		   			 ELSE C.SCM_SITE_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
						(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE C.SCM_SITE_ID END) = P.data
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

		 AND (
			 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_CODE LIKE P.token +'%')
			 OR
			 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
			 )
		 
			 --AND    (   A.PROJECT_CODE LIKE '%'+ @p_project_code + '%'
			 -- OR A.PROJECT_NAME LIKE '%'+ @p_project_code + '%'
			 --)

	  GROUP BY A.DIVISION_ID
			 , D.DIVISION_NAME
			 , A.PROJECT_CODE
			 , A.PROJECT_NAME
			 , A.PROJECT_STATUS
			 , A.BIZ_TYPE
			 , A.BIZ_TYPE_NAME
			 , BIZ.CODE
			 , BIZ.NAME
			 , A.CURRENCY
			 , A.PROJECT_OWNER
			 , TEAM.DEPT_ID
			 , TEAM.DEPT_NAME_KO
			 , C.END_CUSTOMER
	  ORDER BY A.PROJECT_NAME
			 , A.PROJECT_CODE
  
  END
 ELSE
  BEGIN  -- [PJ20200138] ETC Only인 경우에 Lookup 에서 Project List 조회
	SELECT A.SEGMENT1	AS DIVISION_ID
		, A.SEGMENT1	AS DIVISION_NAME
		, A.SEGMENT2	AS PROJECT_CODE
		, A.SEGMENT3	AS PROJECT_NAME
		, ''			AS PROJECT_STATUS
		, ''			AS BIZ_TYPE
		, ''			AS BIZ_TYPE_NAME
		, ''			AS CURRENCY
		, ''			AS PROJECT_VER_SEQ
		, ''			AS PROJECT_OWNER
		, ''			AS DEPT_ID
		, ''			AS DEPT_NAME_KO
		, ''			AS END_CUSTOMER
	FROM  SCM_ADM_LOOKUP_MASTER_DETAIL A with(nolock)
	WHERE  A.LOOKUP_TYPE = 'DM_ETC_Project'
	AND    A.VALID_YN = 'Y'
	AND    A.SEGMENT1 = @p_division_id
	AND    Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.SEGMENT2 LIKE P.token +'%')
  END
END

