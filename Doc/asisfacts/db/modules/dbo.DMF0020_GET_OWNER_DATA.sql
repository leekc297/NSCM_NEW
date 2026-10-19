/*--------------------------------------------------------------------------------------------------*/
/* Program ID  : [DMF0020_GET_OWNER_DATA]                                                           */
/* Description : 상단 owner 조회조건 'Owner By DivisionPopup'                                       */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/06/21  JYE       Initial Release - OWNER 조회
** 2019/01/23  JYE           42, 44 사업부 추가
** 20200423    KHSONG    C20200422-000403 WS Owner 정보추가요청건 반영
** 2022.04.06  rosia27	 [과제PJ20216891R]GM_JV
* 2024/08/14	KJJ			[PJ2024-50461] Team Mapping
*/
/*--------------------------------------------------------------------------------------------------*/
/*
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
*/
/*--------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[DMF0020_GET_OWNER_DATA]
	@p_division_id    NVARCHAR(50),  
	@p_dept_id        NVARCHAR(1000),
	@p_end_customer   NVARCHAR(1000),
	@p_project_code   NVARCHAR(1000),
	@p_scm_site_id    NVARCHAR(1000),
	@p_owner_id       NVARCHAR(1000)
AS
BEGIN
	
    SET NOCOUNT ON;



	/*
	DMF000_GET_OWNER_DATA(Multi Owner 조회창)과 동일하게 쿼리 수정(2024.10.17)
	
	아래 룩업 사용
	--GET_ADMIN_GROUP
	--DM_OWNER_DEPT 
	*/

	--쿼리 전체 수정

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	DECLARE @v_ADMIN_GROUP table (ADMIN_GROUP NVARCHAR(100));
	DECLARE @v_group_id nvarchar(50)='';

	DECLARE @T_LEVEL2_DEPT_ID TABLE ( DEPT_ID NVARCHAR(50));	-- 전지본부의 LEVEL2 아이디가 들어간다.
	DECLARE @T_LEVEL1_DEPT_ID TABLE ( DEPT_ID NVARCHAR(50));	-- 기타 추가하고자 하는 부서의 아이디가 들어간다.

	
	INSERT INTO @v_ADMIN_GROUP(ADMIN_GROUP) 
	SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
		where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
			AND VALID_YN = 'Y'
			AND SEGMENT2 = 'ALL'
			AND SEGMENT1 = 'ADMIN' --조건 빠지면 안됨
	


	--82번 기준
	--SEGMENT1 변수 주석처리시 그룹 (86건)
	/*
ADMIN
DM ADMIN
DM Planner
SCM PI Admin	
	*/


	--SEGMENT1 변수 주석처리 +  DM Planner + DM Planner (W/S) 추가 (91건)
	/*
ADMIN
DM ADMIN
DM Planner
SCM PI Admin	
DM Planner (W/S)
	*/

	
		--SEGMENT1 변수 'ADMIN' 하드코딩 (0건)
	/*
ADMIN
	*/

		--SEGMENT1 변수 'ADMIN' 하드코딩 + DM Planner + DM Planner (W/S) 추가 (83건) => 동일
	/*
ADMIN
DM Planner => 있음
DM Planner (W/S) => 잇음
	*/



	INSERT INTO @T_LEVEL2_DEPT_ID ( DEPT_ID )
	SELECT SEGMENT1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
		where LOOKUP_TYPE = 'DM_OWNER_DEPT' 
			AND VALID_YN = 'Y'
			AND SEGMENT2 = 'LEVEL_2'

	INSERT INTO @T_LEVEL1_DEPT_ID ( DEPT_ID )
	SELECT SEGMENT1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
		where LOOKUP_TYPE = 'DM_OWNER_DEPT' 
			AND VALID_YN = 'Y'
			AND SEGMENT2 = 'LEVEL_1'
/*
	IF ISNULL((
				SELECT COUNT(1) FROM @v_ADMIN_GROUP
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
		*/
	-- GroupID JOIN 조건에 사용
	INSERT INTO @v_ADMIN_GROUP(ADMIN_GROUP) SELECT 'DM Planner'
    INSERT INTO @v_ADMIN_GROUP(ADMIN_GROUP) SELECT 'DM Planner (W/S)' -- [C20220228-000147]
	
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	DECLARE @tmpDept table (DEPT_ID NVARCHAR(100));

    -- 소형사업부, 82 사업부
	--IF @v_group_id = 'ADMIN' AND (@p_division_id = '40' OR @p_division_id = '82')
	IF @p_division_id = '40' OR @p_division_id = '82'
		INSERT INTO @tmpDept(DEPT_ID) 
	   (SELECT DISTINCT C.DEPT_ID
		FROM   SCM_MST_SITE_ITEM A  WITH(NOLOCK)
			 , SCM_MST_SSO_USER_INFO B  WITH(NOLOCK)
			 , SCM_MST_SSO_DEPT_INFO C  WITH(NOLOCK)
		WHERE  A.OWNER = B.USER_ID
		AND    B.DEPT_ID = C.DEPT_ID
		AND    A.DIVISION_ID = @p_division_id);-- Admin 이고 40 사업부의 경우에 해당 사업부의 Owner만 조회 / 82 사업부추가[PJ2024-50461] Team Mapping
    
	-- 자동차 사업부
	--IF @v_group_id = 'ADMIN' AND @p_division_id LIKE '81%'
	IF @p_division_id LIKE '81%'
		INSERT INTO @tmpDept(DEPT_ID) 
		(
			SELECT DISTINCT C.DEPT_ID
			FROM   SCM_MST_SITE_ITEM A  WITH(NOLOCK)
				 , SCM_MST_SSO_USER_INFO B  WITH(NOLOCK)
				 , SCM_MST_SSO_DEPT_INFO C  WITH(NOLOCK)
			WHERE  A.OWNER = B.USER_ID
			AND    B.DEPT_ID = C.DEPT_ID
			AND    A.DIVISION_ID = @p_division_id
			UNION ALL 
			SELECT DISTINCT SEGMENT1 AS DEPT_ID
			FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP WITH(NOLOCK) 
				WHERE 	LOOKUP.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
				AND LOOKUP.VALID_YN = 'Y'
				AND LOOKUP.SEGMENT3 in (
					SELECT DISTINCT C.DEPT_ID
						FROM   SCM_MST_SITE_ITEM A  WITH(NOLOCK)
						 , SCM_MST_SSO_USER_INFO B  WITH(NOLOCK)
						 , SCM_MST_SSO_DEPT_INFO C  WITH(NOLOCK)
					WHERE  A.OWNER = B.USER_ID
					AND    B.DEPT_ID = C.DEPT_ID
					AND    A.DIVISION_ID = @p_division_id
				)
			)

/*
	IF @v_group_id <> 'ADMIN'
		INSERT INTO @tmpDept(DEPT_ID) 
	   (SELECT distinct Dept_ID
		FROM   TB_FX_User u WITH(NOLOCK) 
		WHERE  u.UseYN = 'Y'
		AND    u.UserID = @p_owner_id);-- Admin, DM Admin이 아닌 경우에 User ID의 Owner만 조회
		*/

	SELECT
	FxUGA.Code DIVISION_ID,
	--FxU.UserName OWNER_NAME,
	FxU.Dept_ID,
	DEPT_INFO.DEPT_NAME_KO,
	FxU.UserName,
	FxU.UserID OWNER_NAME,
	/*
		FxU.UserID,
		FxU.UserName + ' ' +  USER_INFO.JOB_NAME    UserName,  --20190131    ytchoi    job_name(직급정보)추가
		USER_INFO.USER_NAME_EN,
		*/

		ROW_NUMBER() OVER (ORDER BY FxU.UserID, FxU.UserName) * 100 AS SORT_ORDER_NO
	FROM (SELECT * FROM dbo.TB_FX_User WITH(NOLOCK) WHERE UseYN = 'Y') AS FxU 
    INNER JOIN (
					SELECT T.DEPT_ID      AS DEPT_ID
						 , T.DEPT_NAME_KO AS DEPT_NAME_KO
						 , T.VALID_YN 
					FROM   SCM_MST_SSO_DEPT_INFO D  WITH(NOLOCK)
						 , SCM_MST_SSO_DEPT_INFO T  WITH(NOLOCK)
					WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
					AND T.[2LEVEL_DEPT_ID] IN ( SELECT DEPT_ID FROM @T_LEVEL2_DEPT_ID ) -- '58174290'  -- 전지사업부

					UNION ALL
					SELECT T.DEPT_ID      AS DEPT_ID
						 , T.DEPT_NAME_KO AS DEPT_NAME_KO
						 , T.VALID_YN 
					FROM   SCM_MST_SSO_DEPT_INFO D  WITH(NOLOCK)
						 , SCM_MST_SSO_DEPT_INFO T  WITH(NOLOCK)
					WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
					AND T.DEPT_ID IN ( SELECT DEPT_ID FROM @T_LEVEL1_DEPT_ID ) -- '58174290'  -- 전지사업부
					AND    D.VALID_YN = 'Y'
					AND    T.VALID_YN = 'Y'
	          ) AS DEPT_INFO
		ON FxU.DEPT_ID = DEPT_INFO.DEPT_ID AND DEPT_INFO.VALID_YN = 'Y'
	INNER JOIN SCM_MST_SSO_USER_INFO AS USER_INFO WITH(NOLOCK)
		ON FxU.UserID = USER_INFO.USER_ID
	INNER JOIN TB_FX_UserGroupAuthExtention AS FxUGA WITH(NOLOCK)
		ON FxU.UserID = FxUGA.UserID
		AND GroupID IN (SELECT DISTINCT ADMIN_GROUP FROM @v_ADMIN_GROUP)  --20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리

	WHERE 1 = 1
		AND FxUGA.Code = @p_division_id
			AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   			ELSE FxU.DEPT_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
						(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE FxU.DEPT_ID END) = P.data
					)

				AND    (
						CASE WHEN @p_owner_id = '' THEN @p_owner_id   
					ELSE FxU.UserID
					END  IN ( SELECT token FROM dbo.String_Split(@p_owner_id,',') )
					OR
						CASE WHEN @p_owner_id = '' THEN @p_owner_id   
					ELSE FxU.UserName
					END  IN ( SELECT token FROM dbo.String_Split(N'' + @p_owner_id,',') )
					OR
						CASE WHEN @p_owner_id = '' THEN @p_owner_id   
					ELSE USER_INFO.USER_NAME_EN
					END  IN ( SELECT token FROM dbo.String_Split(N'' + @p_owner_id,',') )
					)
		AND FxU.Dept_ID IN ( select DEPT_ID from @tmpDept ) --Dept_ID Table
	GROUP BY FxUGA.Code,FxU.UserID, FxU.UserName, USER_INFO.USER_NAME_EN, FxU.Dept_ID, DEPT_INFO.DEPT_NAME_KO, USER_INFO.JOB_NAME
	ORDER BY DEPT_INFO.DEPT_NAME_KO, FxU.UserName, FxU.UserID



	
	/*
	-------------------------------------------------------------------------------------------------------
	-- DIVISION_ID = '40'  (BEGIN)
	-------------------------------------------------------------------------------------------------------
	BEGIN
		SELECT
			SITE_ITEM.DIVISION_ID
			--, SITE_ITEM.SCM_SITE_ID
			, SITE_ITEM.OWNER AS OWNER_NAME
			, TEAM.DEPT_ID
			, TEAM.DEPT_NAME_KO
			--, SITE_ITEM.PROJECT_CODE AS END_CUSTOMER40
			, USER_INFO.USER_NAME
			, ROW_NUMBER() OVER(ORDER BY USER_INFO.USER_NAME) AS SORT_ORDER_NO
		FROM SCM_MST_SITE_ITEM AS SITE_ITEM WITH(NOLOCK) 
			INNER JOIN SCM_MST_SITE AS SITE WITH(NOLOCK)
				ON SITE_ITEM.SCM_SITE_ID  = SITE.SCM_SITE_ID 
				AND SITE_ITEM.DIVISION_ID = SITE.DIVISION_ID
			INNER JOIN [SCM_MST_SSO_USER_INFO] USER_INFO WITH(NOLOCK)
				ON SITE_ITEM.OWNER = USER_INFO.USER_ID
			INNER JOIN [SCM_MST_SSO_DEPT_INFO] TEAM WITH(NOLOCK)
				ON USER_INFO.DEPT_ID = TEAM.DEPT_ID
				AND TEAM.DEPT_ID IN ( select DEPT_ID from @tmpDept )
		WHERE 1 = 1
			AND SITE_ITEM.DIVISION_ID = @p_division_id
			AND SITE.SITE_TYPE = 'SALES'
			AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   			ELSE TEAM.DEPT_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
						(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					)
			AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE isnull(
						CASE WHEN @p_division_id <> '40' THEN SITE.END_CUSTOMER ELSE SITE_ITEM.PROJECT_CODE END
					 ,'')			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
						(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(
							CASE WHEN @p_division_id <> '40' THEN SITE.END_CUSTOMER ELSE SITE_ITEM.PROJECT_CODE END
						,'') END) = P.data
					   )
			AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE SITE_ITEM.SCM_SITE_ID			
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
						(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE SITE_ITEM.SCM_SITE_ID END) = P.data
					  )
			-- 20180628
			 AND    (
				 CASE WHEN @p_owner_id = '' THEN @p_owner_id   
			  ELSE USER_INFO.USER_ID
				END  IN ( SELECT token FROM dbo.String_Split(@p_owner_id,',') )
			   OR
				 CASE WHEN @p_owner_id = '' THEN @p_owner_id   
			  ELSE USER_INFO.USER_NAME
				END  IN ( SELECT token FROM dbo.String_Split(N'' + @p_owner_id,',') )
			   OR
				 CASE WHEN @p_owner_id = '' THEN @p_owner_id   
			  ELSE USER_INFO.USER_NAME_EN
				END  IN ( SELECT token FROM dbo.String_Split(N'' + @p_owner_id,',') )
			   )
			   --AND Exists (Select * from dbo.UF_FX_String_Split (@p_owner_id,',') as P Where SITE_ITEM.OWNER LIKE N'%' + P.token +'%')
		GROUP BY 
			SITE_ITEM.DIVISION_ID
			--, SITE_ITEM.SCM_SITE_ID
			, SITE_ITEM.OWNER
			, TEAM.DEPT_ID
			, TEAM.DEPT_NAME_KO
			, USER_INFO.USER_NAME
			--, SITE_ITEM.PROJECT_CODE
		--ORDER BY TEAM.DEPT_ID, SITE_ITEM.OWNER
	END
	-------------------------------------------------------------------------------------------------------
	-- DIVISION_ID = '40'  (END)
	-------------------------------------------------------------------------------------------------------

	ELSE

	-------------------------------------------------------------------------------------------------------
	-- DIVISION_ID IN ('81','82')  (BEGIN) 20200423 KHSONG C20200422-000403 WS Owner 정보추가요청건
	-------------------------------------------------------------------------------------------------------

	BEGIN
		SELECT
		DIVISION_ID,OWNER_NAME,DEPT_ID,DEPT_NAME_KO,USER_NAME, ROW_NUMBER() OVER(ORDER BY DEPT_ID,USER_NAME) AS SORT_ORDER_NO
		 FROM 
		--		

		(
				SELECT
					SITE_ITEM.DIVISION_ID 
					--, SITE_ITEM.SCM_SITE_ID

					--[PJ2024-50461]=============================================
					--, PRJ.PROJECT_OWNER AS OWNER_NAME
					, SITE_ITEM.OWNER AS OWNER_NAME
					--======================================================

					, TEAM.DEPT_ID
					, TEAM.DEPT_NAME_KO
					--, SITE_ITEM.PROJECT_CODE AS PROJECT_CODE
					--, PRJ.PROJECT_NAME AS PROJECT_NAME
					--, SITE.END_CUSTOMER
					, USER_INFO.USER_NAME
					, USER_INFO.USER_NAME_EN
				FROM SCM_MST_SITE_ITEM AS SITE_ITEM WITH(NOLOCK)

					INNER JOIN SCM_MST_SITE AS SITE WITH(NOLOCK)
						ON SITE_ITEM.SCM_SITE_ID	= SITE.SCM_SITE_ID
						AND SITE_ITEM.DIVISION_ID = SITE.DIVISION_ID

						--[PJ2024-50461]------------------------
						--불필요한 조인 제거
						/*
					INNER JOIN SCM_MST_PROJECT AS PRJ WITH(NOLOCK)
						ON SITE_ITEM.PROJECT_CODE	= PRJ.PROJECT_CODE

					INNER JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] AS TEAM WITH(NOLOCK) 
						ON TEAM.DEPT_ID				= SITE.DEPT_ID

					INNER JOIN [SCM_MST_SSO_USER_INFO] USER_INFO WITH(NOLOCK)
						ON PRJ.PROJECT_OWNER		= USER_INFO.USER_ID
					*/
					INNER JOIN [SCM_MST_SSO_USER_INFO] USER_INFO WITH(NOLOCK)
						ON SITE_ITEM.OWNER = USER_INFO.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] TEAM WITH(NOLOCK)
						ON USER_INFO.DEPT_ID = TEAM.DEPT_ID
						---------------------------------------------

				WHERE 
				/*[PJ2024-50461]
				--불필요한 조건 제거
				SITE_ITEM.PROJECT_CODE = PRJ.PROJECT_CODE 
					AND*/  
					SITE_ITEM.DIVISION_ID		= @p_division_id
					AND SITE.SITE_TYPE				= 'SALES'
					AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   					ELSE TEAM.DEPT_ID			
						END IN (
								Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
								(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
							)
					AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   					 ELSE isnull(
								CASE WHEN @p_division_id <> '40' THEN SITE.END_CUSTOMER ELSE SITE_ITEM.PROJECT_CODE END
							 ,'')			
						END IN (
								Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
								(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(
									CASE WHEN @p_division_id <> '40' THEN SITE.END_CUSTOMER ELSE SITE_ITEM.PROJECT_CODE END
								,'') END) = P.data
							   )
					AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   					 ELSE SITE_ITEM.SCM_SITE_ID			
						END IN (
								Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
								(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE SITE_ITEM.SCM_SITE_ID END) = P.data
							   )
					-- 20180628
					--AND Exists (Select * from dbo.UF_FX_String_Split (@p_owner_id,',') as P Where PRJ.PROJECT_OWNER LIKE N'%' + P.token +'%')
					AND USER_NAME IS NOT NULL

				--GROUP BY 
				--	SITE_ITEM.DIVISION_ID
				--	--, SITE_ITEM.SCM_SITE_ID
				--	, PRJ.PROJECT_OWNER
				--	, TEAM.DEPT_ID
				--	, TEAM.DEPT_NAME_KO
				--	, USER_INFO.USER_NAME
				--	--, SITE_ITEM.PROJECT_CODE
				--	--, PRJ.PROJECT_NAME
				--	--, SITE.END_CUSTOMER

				---------
				UNION ALL
				---------

				SELECT   A.Code AS DIVISION_ID
						,UPPER(A.UserID) AS OWNER_NAME
						,B.DEPT_ID
						,C.DEPT_NAME_KO 
						,B.USER_NAME
						,B.USER_NAME_EN
				  FROM TB_FX_UserGroupAuthExtention A WITH(NOLOCK)

						INNER JOIN SCM_MST_SSO_USER_INFO AS B WITH(NOLOCK)
							ON A.UserID = B.USER_ID

						INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
							ON B.DEPT_ID = C.DEPT_ID

				  WHERE 1=1
					AND A.GroupID	= 'DM Planner (W/S)'  -- W/S팀으로 등록된 Id
					AND A.Code		= @p_division_id      -- 사용자별 권한있는 사업부만
					AND EXISTS (Select Data AS DEPT_ID from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') WHERE Data = '58570422')  -- 58570422 전지.품질.Warranty Service팀 조회조건인 경우만
		) A
		WHERE 1=1
					AND    (
						 CASE WHEN @p_owner_id = '' THEN @p_owner_id   
					  ELSE OWNER_NAME
						END  IN ( SELECT token FROM dbo.String_Split(@p_owner_id,',') )
					   OR
						 CASE WHEN @p_owner_id = '' THEN @p_owner_id   
					  ELSE USER_NAME
						END  IN ( SELECT token FROM dbo.String_Split(N'' + @p_owner_id,',') )
					   OR
						 CASE WHEN @p_owner_id = '' THEN @p_owner_id   
					  ELSE USER_NAME_EN
						END  IN ( SELECT token FROM dbo.String_Split(N'' + @p_owner_id,',') )
					   )

		GROUP BY DIVISION_ID,OWNER_NAME,DEPT_ID,DEPT_NAME_KO,USER_NAME

	END
	*/
	-------------------------------------------------------------------------------------------------------
	-- DIVISION_ID IN ('81','82')  (END) 20200423 KHSONG C20200422-000403 WS Owner 정보추가요청건
	-------------------------------------------------------------------------------------------------------
END
