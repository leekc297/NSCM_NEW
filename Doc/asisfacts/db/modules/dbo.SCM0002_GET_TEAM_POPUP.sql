
/*
 * Program ID   : [SCM0002_GET_TEAM_POPUP]
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/15  Songdh    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/30  JYE		 복수 팀 권한 관련  수정  
 * 20180628    ytchoi    일반적인 팀 정보 조회 조건 수정 (@v_team_cnt <= 1  ☞ @v_team_cnt < 1)
 * 20200313    KHSONG    C20200103-000586 권한그룹을 LOOKUP관리
 * 20200507    P.C.I     C20200507-000080 W/S 권한으로 등록된 팀 추가
 * 20210107    P.C.I     [C20210104-000823] 자동차 사업부 신규 팀 선택의 건
 */
CREATE PROCEDURE [dbo].[SCM0002_GET_TEAM_POPUP]
  @p_team_id    NVARCHAR(1000),
  @p_team_name  NVARCHAR(1000),
  @p_created_by NVARCHAR(50),
  @p_userinfo   NVARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @v_dept_id nvarchar(50)='';
	DECLARE @v_group_id nvarchar(50)='';
	DECLARE @v_team_cnt int=0; -- 다수 팀 권한
	DECLARE @v_org_dept_id nvarchar(50)=''; --[C20210104-000823] User Dept ID
	DECLARE @v_org_upper_dept_id nvarchar(50)=''; --[C20210104-000823] User Upper Dept ID(사업부)

	--[C20210104-000823] User Dept ID
	SELECT @v_org_dept_id = DEPT_ID
	FROM [DBO].[TB_FX_USER] WITH(NOLOCK) WHERE UserID = @p_created_by

	SELECT  @v_team_cnt = count(SEGMENT3)
	FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
	WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
	AND VALID_YN = 'Y'
	AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK) WHERE UserID = @p_created_by)

		--IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
		--	SET @v_group_id = 'ADMIN'	

	---------------------------------------------------------------------------------
	--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
						AND SEGMENT1 = @p_userinfo
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------


	IF (@v_team_cnt < 1
	 OR 	
	(ISNULL((SELECT COUNT(1)
			FROM  SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
			WHERE LOOKUP_TYPE = 'SALES_MGMT_TEAM' 
			AND   VALID_YN    = 'Y'
			AND   SEGMENT5    = 'Y'
			AND   SEGMENT1    = @v_org_dept_id), 0) > 0 AND @v_group_id = 'ADMIN') --[C20210104-000823] 영업관리팀인지 확인
	) -- 일반적인 팀 정보 조회 -- modified by ytchoi 20180628
		---------------------------------------------------------------------------------
		BEGIN
		---------------------------------------------------------------------------------
				SELECT @v_dept_id = isnull( (	 select TOP 1 SEGMENT3
						  from  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
						 where LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
							AND VALID_YN = 'Y'
							and SEGMENT1         =   U.DEPT_ID ) , U.DEPT_ID )
			FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
			WHERE  U.UserID = @p_created_by

			
			--[C20210104-000823] 상위 DEPT
			SELECT @v_org_upper_dept_id = SEGMENT3
			FROM  SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
			WHERE LOOKUP_TYPE = 'SALES_MGMT_TEAM' 
			AND   VALID_YN    = 'Y'
			AND   SEGMENT5    = 'Y'
			AND   SEGMENT1    = @v_org_dept_id

			SELECT D.DEPT_ID
				 , D.DEPT_NAME_KO
				 , T.DEPT_ID      AS TEAM_ID
				 , T.DEPT_NAME_KO AS TEAM_NAME_KO
			FROM   SCM_MST_SSO_DEPT_INFO D  WITH(NOLOCK)
				 , SCM_MST_SSO_DEPT_INFO T  WITH(NOLOCK)
			WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
			AND  ( T.[2LEVEL_DEPT_ID] IN ( '58174290' )  -- 전지사업부코드
			--Start C20200507-000080 W/S 권한으로 등록된 팀 추가
			OR     T.DEPT_ID IN ( SELECT  DISTINCT B.DEPT_ID
								  FROM TB_FX_UserGroupAuthExtention A WITH(NOLOCK)
								  INNER JOIN SCM_MST_SSO_USER_INFO AS B WITH(NOLOCK)
								  ON A.UserID = B.USER_ID
								  WHERE 1=1
								  AND A.GroupID	= 'DM Planner (W/S)')
			AND    T.[2LEVEL_DEPT_ID] IS NOT NULL)
			--End C20200507-000080 W/S 권한으로 등록된 팀 추가
			AND    D.VALID_YN = 'Y'
			AND    T.VALID_YN = 'Y'
			AND    D.DEPT_NAME_KO <> '_'
			--AND    D.DEPT_ID <> T.DEPT_ID
			AND    T.DEPT_ID LIKE '%'+ @p_team_id + '%'
			AND   (   T.DEPT_NAME_KO LIKE N'%' + @p_team_name + '%'
				   OR T.DEPT_NAME_EN LIKE N'%' + @p_team_name + '%'
				   OR T.DEPT_NAME_CN LIKE N'%' + @p_team_name + '%'
				  )		
		-- 팀, 권한에 대한 것
			AND    T.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN T.DEPT_ID ELSE @v_dept_id END 
			AND    T.ATTRIBUTE2  LIKE N'%' + @v_org_upper_dept_id + '%' --[C20210104-000823] 상위 DEPT 조건 추가
			/*
			AND    CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN'
					ELSE T.DEPT_ID END = CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN' ELSE @v_dept_id END		
			*/	     
			ORDER BY D.DEPT_NAME_KO, D.DEPT_ID
			;
		---------------------------------------------------------------------------------
		END 
		---------------------------------------------------------------------------------
	ELSE
		---------------------------------------------------------------------------------
		BEGIN -- 복수 팀 권한 조회
		---------------------------------------------------------------------------------
			SELECT D.DEPT_ID
			 , D.DEPT_NAME_KO
			 , T.DEPT_ID      AS TEAM_ID
			 , T.DEPT_NAME_KO AS TEAM_NAME_KO
			FROM   SCM_MST_SSO_DEPT_INFO D  WITH(NOLOCK)
				 , SCM_MST_SSO_DEPT_INFO T  WITH(NOLOCK)
			WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
			AND  ( T.[2LEVEL_DEPT_ID] IN ( '58174290' )  -- 전지사업부코드
			--Start C20200507-000080 W/S 권한으로 등록된 팀 추가
			OR     T.DEPT_ID IN ( SELECT  DISTINCT B.DEPT_ID
								  FROM TB_FX_UserGroupAuthExtention A WITH(NOLOCK)
								  INNER JOIN SCM_MST_SSO_USER_INFO AS B WITH(NOLOCK)
								  ON A.UserID = B.USER_ID
								  WHERE 1=1
								  AND A.GroupID	= 'DM Planner (W/S)')
			AND    T.[2LEVEL_DEPT_ID] IS NOT NULL)
			--End C20200507-000080 W/S 권한으로 등록된 팀 추가
			AND    D.VALID_YN = 'Y'
			AND    T.VALID_YN = 'Y'
			AND    D.DEPT_NAME_KO <> '_'
			AND T.DEPT_ID IN (
								SELECT  SEGMENT3
									FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
										WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
										AND VALID_YN = 'Y'
										AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK) WHERE UserID = @p_created_by)
								--2018/05/30  JYE			복수 팀 권한 관련  수정  
								UNION
								SELECT U.DEPT_ID 
									FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
										WHERE  U.UserID = @p_created_by 
								--2018/05/30  JYE			복수 팀 권한 관련  수정  
								)  
			ORDER BY D.DEPT_NAME_KO, D.DEPT_ID;
		---------------------------------------------------------------------------------
		END
		---------------------------------------------------------------------------------
END


