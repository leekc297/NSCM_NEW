
/*********************************************************************************************
* Program ID  : [DMF000_GET_OWNER_DATA]                                                      
* Description : Procedure 작성 가이드                                                         
* Usage       : Procedure 작성 시 참조하세요!                                                 
* Parameter   :                                                                              
*                                                                                            
*--------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                       
*--------------------------------------------------------------------------------------------
* 2018/06/21  JYE       Initial Release - OWNER 조회                                         
* 20180903    JYE       DM ADMIN, DM Planner 만 조회 되도록                                   
* 20180904 son young suk @p_search(조회버튼)으로 조회시 @p_owner_id에 있는 건은 안나오게 처리    
* 20190123    JYE       42, 44 추가                                                          
* 20190131    ytchoi    job_name(직급정보)추가                                                
* 20200113    P.C.I     Admin,DM Admin 권한이면 선택 된 Division의 Team의 Owner만 조회하고, 그 외는 UserID Team의 Owner만 조회 
* 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
* 20200113    P.C.I     [C20200506-000277] Lookup PM_TEAM_MAPPING 의 PM Team도 Owner 대상에 포함   
* 20200709    HWI1993     [C20200708-000347] CMI _Marketing Team 권한 부여					
* 20220304    hwi1993   [C20220228-000147] DM Planner (WS) - Sales Site - Owner 컬럼 권한 확인 요청
* 20220331	  rosia27	[과제PJ20216891R]GM_JV
* 2024/10/15	KJJ			[PJ2024-50461] Team Mapping(82번 사업부 PM팀 제외 40 사업부와 동일)
****************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF000_GET_OWNER_DATA]
	@p_division_id   NVARCHAR(50),  
	@p_owner_id      NVARCHAR(50),
	@p_search        NVARCHAR(4000),  
	@p_user_id       NVARCHAR(50), --UserID Team의 Owner만 조회
	@p_now_group_id  NVARCHAR(50)  --현재 Setting 된 Group ID
AS
BEGIN
	
    SET NOCOUNT ON;

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
			AND SEGMENT1 = @p_now_group_id
			
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

	IF ISNULL((
				SELECT COUNT(1) FROM @v_ADMIN_GROUP
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	-- GroupID JOIN 조건에 사용
	INSERT INTO @v_ADMIN_GROUP(ADMIN_GROUP) SELECT 'DM Planner'
    INSERT INTO @v_ADMIN_GROUP(ADMIN_GROUP) SELECT 'DM Planner (W/S)' -- [C20220228-000147]
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	
	--Dept_ID Table 변수
    DECLARE @tmpDept table (DEPT_ID NVARCHAR(100));
     
    -- 소형사업부, 82 사업부
	--IF @v_group_id = 'ADMIN' AND @p_division_id = '40'
	IF @v_group_id = 'ADMIN' AND (@p_division_id = '40' OR @p_division_id = '82')
		INSERT INTO @tmpDept(DEPT_ID) 
	   (SELECT DISTINCT C.DEPT_ID
		FROM   SCM_MST_SITE_ITEM A  WITH(NOLOCK)
			 , SCM_MST_SSO_USER_INFO B  WITH(NOLOCK)
			 , SCM_MST_SSO_DEPT_INFO C  WITH(NOLOCK)
		WHERE  A.OWNER = B.USER_ID
		AND    B.DEPT_ID = C.DEPT_ID
		AND    A.DIVISION_ID = @p_division_id);-- Admin 이고 40 사업부의 경우에 해당 사업부의 Owner만 조회 / 82 사업부추가[PJ2024-50461] Team Mapping
    
	-- 자동차,ESS사업부
	--자동차 사업부만 적용
		--SCM_MST_SITE 사용안함
    --IF @v_group_id = 'ADMIN' AND (@p_division_id LIKE '81%' OR @p_division_id = '82')

	IF @v_group_id = 'ADMIN' AND @p_division_id LIKE '81%'
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
	   /*(SELECT DISTINCT B.DEPT_ID 
		FROM   SCM_MST_SITE          A WITH(NOLOCK) 
			 , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK) 
		WHERE  A.SITE_TYPE = 'SALES'
		AND    A.DEPT_ID  = B.DEPT_ID  
		AND    A.DIVISION_ID = @p_division_id 
		UNION ALL -- [C20200506-000277] Lookup PM_TEAM_MAPPING 의 PM Team도 Owner 대상에 포함
		SELECT DISTINCT SEGMENT1 AS DEPT_ID
		FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP WITH(NOLOCK) 
			WHERE 	LOOKUP.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
			AND LOOKUP.VALID_YN = 'Y'
			--AND LOOKUP.SEGMENT3 = u.DEPT_ID
			AND LOOKUP.SEGMENT3 in (SELECT DISTINCT B.DEPT_ID 
									FROM   SCM_MST_SITE          A WITH(NOLOCK) 
										 , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK) 
									WHERE  A.SITE_TYPE = 'SALES'
									AND    A.DEPT_ID  = B.DEPT_ID  
									AND    A.DIVISION_ID = @p_division_id ));-- Admin 이고 81, 82 사업부의 경우에 해상 사업부의 Owner만 조회
									*/
    IF @v_group_id <> 'ADMIN'
		INSERT INTO @tmpDept(DEPT_ID) 
	   (SELECT distinct Dept_ID
		FROM   TB_FX_User u WITH(NOLOCK) 
		WHERE  u.UseYN = 'Y'
		AND    u.UserID = @p_user_id);-- Admin, DM Admin이 아닌 경우에 User ID의 Owner만 조회


	-- 왼쪽 스프레드 데이터
	SELECT
		FxU.UserID,
		FxU.UserName + ' ' +  USER_INFO.JOB_NAME    UserName,  --20190131    ytchoi    job_name(직급정보)추가
		USER_INFO.USER_NAME_EN,
		FxU.Dept_ID,
		DEPT_INFO.DEPT_NAME_KO,
		ROW_NUMBER() OVER (ORDER BY FxU.UserID, FxU.UserName) * 100 AS SORT_ORDER_NO,
		'Y' AS USER_SELECTABLE_FLAG
	FROM (SELECT * FROM dbo.TB_FX_User WITH(NOLOCK) WHERE UseYN = 'Y') AS FxU 
--	LEFT JOIN SCM_MST_SSO_DEPT_INFO AS DEPT_INFO WITH(NOLOCK)
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

					/*
					-- 20200311 KHSONG 재료사업부 필요없는부분 주석처리
					AND    ( ( T.[2LEVEL_DEPT_ID] = '58174290' and @p_division_id not in ('42','44') )
					            OR 
							   ( T.[2LEVEL_DEPT_ID] = '58366794' and @p_division_id in ('42','44') ) )		-- 20190123
					*/

					AND    D.VALID_YN = 'Y'
					AND    T.VALID_YN = 'Y'
	          ) AS DEPT_INFO
		ON FxU.DEPT_ID = DEPT_INFO.DEPT_ID AND DEPT_INFO.VALID_YN = 'Y'
	INNER JOIN SCM_MST_SSO_USER_INFO AS USER_INFO WITH(NOLOCK)
		ON FxU.UserID = USER_INFO.USER_ID
	INNER JOIN TB_FX_UserGroupAuthExtention AS FxUGA WITH(NOLOCK)
		ON FxU.UserID = FxUGA.UserID
		--AND (GroupID = 'DM ADMIN' OR GroupID = 'DM Planner')  -- 20180903 --20200311 KHSONG 주석처리
		AND GroupID IN (SELECT DISTINCT ADMIN_GROUP FROM @v_ADMIN_GROUP)  --20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
	INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_search,',') ) b
		ON      CASE WHEN @p_search = '' THEN @p_search			
				ELSE USER_INFO.USER_ID  END like  b.tst 
		OR      CASE WHEN @p_search = '' THEN @p_search
				ELSE USER_INFO.USER_NAME  END like  b.tst
		OR      CASE WHEN @p_search = '' THEN @p_search
				ELSE DEPT_INFO.DEPT_NAME_KO  END like  b.tst
	WHERE 1 = 1
		AND FxUGA.Code = @p_division_id
		AND CASE WHEN @p_owner_id = 'ALL' THEN 'ALL'
		   		ELSE USER_INFO.USER_ID		
				END NOT IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_owner_id,',') as P Where 
						(CASE WHEN @p_owner_id = 'ALL' THEN 'ALL' ELSE USER_INFO.USER_ID END) = P.data
					)	
		AND @p_search NOT IN (
				Select * from dbo.UF_FX_String_SplitForIN (@p_owner_id,',') as P Where 
				(CASE WHEN @p_owner_id = 'ALL' THEN 'ALL' ELSE USER_INFO.USER_ID END) = P.data
			)	-- 20180904 son young suk 추가
		AND FxU.Dept_ID IN ( select DEPT_ID from @tmpDept ) --Dept_ID Table
	GROUP BY FxU.UserID, FxU.UserName, USER_INFO.USER_NAME_EN, FxU.Dept_ID, DEPT_INFO.DEPT_NAME_KO, USER_INFO.JOB_NAME
	ORDER BY DEPT_INFO.DEPT_NAME_KO,FxU.UserName, FxU.UserID--[PJ2024-50461] 팀명 정렬 추가


	-- 오른쪽 스프레드 데이터
	SELECT
		FxU.UserID,
		FxU.UserName + ' ' +  USER_INFO.JOB_NAME    UserName,
		USER_INFO.USER_NAME_EN,
		FxU.Dept_ID,
		DEPT_INFO.DEPT_NAME_KO,
		--ROW_NUMBER() OVER (ORDER BY FxU.UserID, FxU.UserName) AS SORT_ORDER_NO,
		(SELECT NR FROM dbo.String_Split(@p_owner_id,',') WHERE TOKEN = FxU.UserID) AS SORT_ORDER_NO,
		'Y' AS USER_SELECTABLE_FLAG
	FROM (SELECT * FROM dbo.TB_FX_User WITH(NOLOCK) WHERE UseYN = 'Y') AS FxU 
	LEFT JOIN SCM_MST_SSO_DEPT_INFO AS DEPT_INFO WITH(NOLOCK)
		ON FxU.DEPT_ID = DEPT_INFO.DEPT_ID AND DEPT_INFO.VALID_YN = 'Y'
	LEFT JOIN SCM_MST_SSO_USER_INFO AS USER_INFO WITH(NOLOCK)
		ON FxU.UserID = USER_INFO.USER_ID
	LEFT JOIN TB_FX_UserGroupAuthExtention AS FxUGA WITH(NOLOCK)
		ON FxU.UserID = FxUGA.UserID
		--AND (GroupID = 'DM ADMIN' OR GroupID = 'DM Planner')  -- 20180903 --20200311 KHSONG 주석처리
		AND GroupID IN (SELECT DISTINCT ADMIN_GROUP FROM @v_ADMIN_GROUP)  --20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
    -- 20180904 son young suk
	--INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_search,',') ) b
	--	ON      CASE WHEN @p_search = '' THEN @p_search			
	--			ELSE USER_INFO.USER_ID  END like  b.tst 
	--	OR      CASE WHEN @p_search = '' THEN @p_search
	--			ELSE USER_INFO.USER_NAME  END like  b.tst
	--	OR      CASE WHEN @p_search = '' THEN @p_search
	--			ELSE DEPT_INFO.DEPT_NAME_KO  END like  b.tst
	WHERE 1 = 1
		AND FxUGA.Code = @p_division_id
		AND CASE WHEN @p_owner_id = 'ALL' THEN 'ALL'
		   		ELSE USER_INFO.USER_ID		
				END IN (
						Select * from dbo.UF_FX_String_SplitForIN (@p_owner_id,',') as P Where 
						(CASE WHEN @p_owner_id = 'ALL' THEN 'ALL' ELSE USER_INFO.USER_ID END) = P.data
					)	
	GROUP BY FxU.UserID, FxU.UserName, USER_INFO.USER_NAME_EN, FxU.Dept_ID, DEPT_INFO.DEPT_NAME_KO, USER_INFO.JOB_NAME
	ORDER BY SORT_ORDER_NO
END
