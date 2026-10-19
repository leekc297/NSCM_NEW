/* =============================================================================
프로그램ID	: UP_FX_GetComboDataList_SSP
업  무  명	: 공통 코드성 Combo 조회_SSP
프로그램명	: 공통 코드성 Combo 조회_SSP
			- 최초 화면 로딩시에 필요한 데이터를 1회 DB 조회로 획득한다.
최초작성일	: 2023.11.29
최종작성일  : 2023.11.29
개  발  자	: dev125812
입  력  값	: 
출  력  값	: 

EXEC UP_FX_GetComboDataList_SSP @UICode='SSP0022', @GroupID='ADMIN', @UserID='dev125812', @Param4='', @Param5=''

================================================================================
Date			In Charge			Description  
================================================================================
2023/11/29		dev125812			
*********************************************************************************/

CREATE PROCEDURE [dbo].[UP_FX_GetComboDataList_SSP]
	  @UICode	NVARCHAR(100)
	, @GroupID NVARCHAR(MAX)
	, @UserID NVARCHAR(MAX)
	, @Param4 NVARCHAR(MAX)
	, @Param5 NVARCHAR(MAX)
	, @TimeZone NVARCHAR(MAX) = 'AS054'
AS
BEGIN
		SET NOCOUNT ON;

    DECLARE @v_dept_id nvarchar(50)='';
	DECLARE @v_group_id nvarchar(50)='';
	
	-- 사용자의 팀정보 & 권한

	SET @v_dept_id = (SELECT TOP 1 isnull(DEPT_ID,'') 
								FROM 
									(
									SELECT DEPT_ID FROM   [dbo].[TB_FX_User] U WITH(NOLOCK) 
										WHERE  U.UserID = @UserID

									UNION ALL

									-- MAPPING 된 팀이 있는경우 후순위로 추출
									SELECT isnull( (	 
													select TOP 1 SEGMENT3
														from  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) 
														where LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
														and SEGMENT1         =   U.DEPT_ID AND VALID_YN = 'Y'
													) , U.DEPT_ID 
												)
									FROM   [dbo].[TB_FX_User] U WITH(NOLOCK) 
										WHERE  U.UserID = @UserID
									) A
						);

	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						--AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
						AND SEGMENT2 in ('ALL','DMF0003')  -- 'ALL'인경우 기본값 + DMF0003는 W/S 그룹 추가
						AND SEGMENT1 = @UserID
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END

		
			Declare @AuthTypePara varchar(100) = 'D'		   
			IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			DEClARE @TeambyDivision_Lang NVARCHAR(200)

			
			--테이블 변수 선언
			DEClARE @CommonResult Table (
				CODE NVARCHAR(MAX),
				NAME NVARCHAR(MAX)
			)


		IF @UICode = 'SSP0022'
		BEGIN
			
			-- 'Division'
			-- 프로시져 실행 결과를 테이블 변수에 Insert
			Insert @CommonResult EXEC UP_FX_GetCommonDataList @Code = 'Division', @PARAM1 = '', @PARAM2 = '', @PARAM3 = @GroupID, @PARAM4 = @UserID, @PARAM5 = ''

			-- 결과를 Select 
			Select * from @CommonResult



			
			---- 'MyDivision' 
			--BEGIN
			--	SELECT   
			--		DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
			--	FROM  
			--		[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
			--	WHERE   
			--		A.ATTRIBUTE3 <> 'EE'
			--		AND DIVISION_ID IN   
			--		(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
			--		AND VALID_YN = 'Y'  
			--	GROUP BY 
			--		DIVISION_ID, ATTRIBUTE1
			--	ORDER BY ATTRIBUTE1
			--END
			

			---- 'TeambyDivision'
			--BEGIN

			--	SELECT @TeambyDivision_Lang = Language
			--	FROM dbo.TB_FX_User
			--	WHERE UserID = @UserID

			--	SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

			--	SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
			--		B.DEPT_ID       AS CODE
			--		, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
			--									WHEN 'CN' THEN B.DEPT_NAME_CN
			--									ELSE B.DEPT_NAME_KO
			--									END
			--		AS NAME
			--	FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
			--		, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
			--	WHERE  A.SITE_TYPE = 'SALES'
			--	AND    A.DEPT_ID  = B.DEPT_ID  
			--	AND    A.DIVISION_ID IN (SELECT CODE 
			--			FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
			--			WHERE  GroupID LIKE '%'+ @GroupID + '%'
			--			AND    UserID  LIKE '%'+ @UserID + '%'
			--			AND    AuthType = 'D')

			--UNION ALL
				
			--	select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
			--		, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
			--					WHEN 'CN' THEN C.DEPT_NAME_CN
			--					ELSE C.DEPT_NAME_KO
			--					END AS NAME
			--		from scm_mst_site_item a  WITH(NOLOCK)
			--			,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
			--			,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
			--		where 
			--		b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
			--		and b.dept_id = c.dept_id
			--		and a.division_id = '40'
			--		order by DIVISION_ID
			--END


			---- 'EndCustomerByDivision'
			--BEGIN
			---- 'EndCustomerByDivision40'

 		--		SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
			--		, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
			--	FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
			--		INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
			--		INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
			--		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
			--			ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
			--	WHERE 
			--	B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
			--	AND B.DEPT_ID = C.DEPT_ID
			--	AND A.DIVISION_ID = '40'
			--	AND A.VALID_YN = 'Y'
			--	UNION
			--	SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
			--	FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
			--	WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
			--	AND SEGMENT2 <> '-'
			--	AND VALID_YN = 'Y'	
			--	AND SEGMENT1 = '40' 

			--	UNION ALL

			---- 'EndCustomerByDivisionDept'
			--	SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
			--			A.END_CUSTOMER AS CODE 
			--			, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
			--	FROM   SCM_MST_SITE A WITH(NOLOCK)
			--	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
			--		ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
			--	WHERE  1 = 1
			--	AND    A.DIVISION_ID IN (SELECT CODE 
			--						FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
			--		    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
			--								AND    USERID  LIKE '%'+ @UserID + '%'
			--								AND    AUTHTYPE = 'D')
			--	AND    END_CUSTOMER IS NOT NULL
			--	ORDER BY A.DIVISION_ID

			--END		
				

			---- 'SiteByEndCustomer'				
			--BEGIN
			--	SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
			--			SCM_SITE_ID AS CODE 
			--			, SCM_SITE_ID AS NAME
			--	FROM   SCM_MST_SITE A WITH(NOLOCK) 
			--	WHERE  1 = 1
			--	AND    A.SITE_TYPE = 'SALES'	
			--	AND    A.DIVISION_ID IN (SELECT CODE 
			--								FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
			--		    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
			--				    			AND    UserID  LIKE '%'+ @UserID + '%'
			--								AND    AuthType = @AuthTypePara)
			--	AND A.VALID_YN = 'Y'	

			--UNION ALL

			--	SELECT DISTINCT A.DIVISION_ID, B.PROJECT_CODE,
			--			A.SCM_SITE_ID AS CODE 
			--			, A.SCM_SITE_ID AS NAME
			--	FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
			--		LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
			--		ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
			--	WHERE  1 = 1
			--	AND    A.SITE_TYPE = 'SALES'
			--	AND    A.DIVISION_ID IN (SELECT CODE 
			--								FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
			--		    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
			--				    			AND    UserID  LIKE '%'+ @UserID + '%'
			--								AND    AuthType = @AuthTypePara)
			--	AND A.VALID_YN = 'Y'
			--	ORDER BY A.DIVISION_ID
			--END
			
		END	/* @UICode = 'SSP0022'*/

		
END