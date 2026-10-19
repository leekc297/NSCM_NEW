/* =============================================================================
프로그램ID	: UP_FX_GetComboDataList
업  무  명	: 공통 코드성 Combo 조회
프로그램명	: 공통 코드성 Combo 조회
			- 최초 화면 로딩시에 필요한 데이터를 1회 DB 조회로 획득한다.
최초작성일	: 2023.10.17
최종작성일  : 2023.10.17
개  발  자	: dev125812
입  력  값	: 
출  력  값	: 

EXEC UP_FX_GetComboDataList @UICode='DMF0020', @GroupID='ADMIN', @UserID='dev125812', @Param4='', @Param5=''

================================================================================
Date			In Charge			Description  
================================================================================
2023/10/17		dev125812			MyDivision 추가
*********************************************************************************/

CREATE PROCEDURE [dbo].[UP_FX_GetComboDataList]
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

		IF @UICode = 'DMF0005'
		BEGIN
			

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				

			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

				SELECT DISTINCT A.DIVISION_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END
			
		END	/* @UICode = 'DMF0005'*/
		
		IF @UICode = 'DMF0003'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				

			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

				SELECT DISTINCT A.DIVISION_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END


			--BizType
			BEGIN
			-- 'DM_BIZ_TYPE'			
				SELECT '40' AS DIVISION_ID
					, L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK) 
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
				--ORDER BY L.DISPLAY_SEQ
				
				UNION ALL

			-- 'BizTypebyDivision'			
				SELECT DISTINCT DIVISION_ID, 
					 BIZ_TYPE       AS CODE 
				   , BIZ_TYPE_NAME  AS NAME
				  FROM   [DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
				  WHERE   BIZ_TYPE_NAME != ''
			END		


			-- EdiSender
			BEGIN
				SELECT SEGMENT2 AS CODE, ATTRIBUTE1 AS NAME
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK)
				WHERE LOOKUP_TYPE = 'EDI_SENDER_CODE'
					AND VALID_YN = 'Y'
					AND SEGMENT1 = '81'
				ORDER BY DISPLAY_SEQ	
			END


			--PlantSiteByEndCustomer			
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
					   SCM_SITE_ID AS CODE 
					 , SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'PLANT'
				AND    A.DIVISION_ID IN (SELECT CODE 
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
										 WHERE  GroupID LIKE @GroupID + '%'
						    			 AND    UserID  LIKE @UserID + '%'
										 AND    AuthType = 'D')  
			END
			
		END	/* @UICode = 'DMF0003'*/
		
		IF @UICode = 'DMF0020'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				

			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

				SELECT DISTINCT A.DIVISION_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END


			--BizType
			BEGIN
			-- 'DM_BIZ_TYPE'			
				SELECT '40' AS DIVISION_ID
					, L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK) 
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
				--ORDER BY L.DISPLAY_SEQ
				
				UNION ALL

			-- 'BizTypebyDivision'			
				SELECT DISTINCT DIVISION_ID, 
					 BIZ_TYPE       AS CODE 
				   , BIZ_TYPE_NAME  AS NAME
				  FROM   [DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
				  WHERE   BIZ_TYPE_NAME != ''
			END		


			-- EdiSender
			--BEGIN
			--	SELECT SEGMENT2 AS CODE, ATTRIBUTE1 AS NAME
			--	FROM SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK)
			--	WHERE LOOKUP_TYPE = 'EDI_SENDER_CODE'
			--		AND VALID_YN = 'Y'
			--		AND SEGMENT1 = '81'
			--	ORDER BY DISPLAY_SEQ	
			--END


			--PlantSiteByEndCustomer			
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
					   SCM_SITE_ID AS CODE 
					 , SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'PLANT'
				AND    A.DIVISION_ID IN (SELECT CODE 
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
										 WHERE  GroupID LIKE @GroupID + '%'
						    			 AND    UserID  LIKE @UserID + '%'
										 AND    AuthType = 'D')  
			END

			
			--'UpperDeptId'	
			--BEGIN
			--	  SELECT DISTINCT 
			--			 D.DEPT_ID       AS CODE
			--		   , D.DEPT_NAME_KO  AS NAME
			--	  FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
			--		   , [dbo].[SCM_MST_SSO_DEPT_INFO] D WITH(NOLOCK) 
			--		   , [dbo].[SCM_MST_SSO_DEPT_INFO] T WITH(NOLOCK) 
			--	  WHERE  A.DEPT_ID  = T.DEPT_ID
			--	  AND    D.DEPT_ID  = T.UPPER_DEPT_ID
			--	  AND    A.SITE_TYPE = 'SALES'
			--END	
			
		END	/* @UICode = 'DMF0020'*/
		
		IF @UICode = 'DMF0040'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				
				
			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, '' AS DEPT_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID != '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

			--	'SiteByEndCustomer40'	
				SELECT DISTINCT A.DIVISION_ID, C.DEPT_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
					LEFT JOIN (
								SELECT DISTINCT A.USER_ID, A.DEPT_ID 
								FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK) , SCM_MST_SSO_DEPT_INFO B  WITH(NOLOCK) 
								WHERE A.DEPT_ID = B.DEPT_ID
							) C ON B.OWNER = C.USER_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID = '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END
			

			--BizType
			BEGIN
			-- 'DM_BIZ_TYPE'			
				SELECT '40' AS DIVISION_ID
					, L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK) 
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
				--ORDER BY L.DISPLAY_SEQ
				
				UNION ALL

			-- 'BizTypebyDivision'			
				SELECT DISTINCT DIVISION_ID, 
					 BIZ_TYPE       AS CODE 
				   , BIZ_TYPE_NAME  AS NAME
				  FROM   [DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
				  WHERE   BIZ_TYPE_NAME != ''
			END		
			
			
			--'FromSiteByDivision'					
			BEGIN

				SELECT	A.DIVISION_ID
					,	SCM_SITE_ID        AS CODE
					,	SCM_SITE_ID		   AS NAME
					 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
				FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)	
				WHERE SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
				FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    		 AND    UserID  LIKE '%'+ @UserID + '%'
										 AND    AuthType = @AuthTypePara)				 
			END		
			
		END	/* @UICode = 'DMF0040'*/
		
		IF @UICode = 'DMF0053'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				
				
			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, '' AS DEPT_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID != '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

			--	'SiteByEndCustomer40'	
				SELECT DISTINCT A.DIVISION_ID, C.DEPT_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
					LEFT JOIN (
								SELECT DISTINCT A.USER_ID, A.DEPT_ID 
								FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK) , SCM_MST_SSO_DEPT_INFO B  WITH(NOLOCK) 
								WHERE A.DEPT_ID = B.DEPT_ID
							) C ON B.OWNER = C.USER_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID = '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END


			--BizType
			BEGIN
			-- 'DM_BIZ_TYPE'			
				SELECT '40' AS DIVISION_ID
					, L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK) 
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
				--ORDER BY L.DISPLAY_SEQ
				
				UNION ALL

			-- 'BizTypebyDivision'			
				SELECT DISTINCT DIVISION_ID, 
					 BIZ_TYPE       AS CODE 
				   , BIZ_TYPE_NAME  AS NAME
				  FROM   [DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
				  WHERE   BIZ_TYPE_NAME != ''
			END		
			
			
			--'FromSiteByDivision'					
			BEGIN

				SELECT	A.DIVISION_ID
					,	SCM_SITE_ID        AS CODE
					,	SCM_SITE_ID		   AS NAME
					 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
				FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)	
				WHERE SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
				FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    		 AND    UserID  LIKE '%'+ @UserID + '%'
										 AND    AuthType = @AuthTypePara)				 
			END		
			
		END	/* @UICode = 'DMF0053'*/
		
		IF @UICode = 'DMF0035'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				
				
			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, '' AS DEPT_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID != '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

			--	'SiteByEndCustomer40'	
				SELECT DISTINCT A.DIVISION_ID, C.DEPT_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
					LEFT JOIN (
								SELECT DISTINCT A.USER_ID, A.DEPT_ID 
								FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK) , SCM_MST_SSO_DEPT_INFO B  WITH(NOLOCK) 
								WHERE A.DEPT_ID = B.DEPT_ID
							) C ON B.OWNER = C.USER_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID = '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END
			

			--BizType
			BEGIN
			-- 'DM_BIZ_TYPE'			
				SELECT '40' AS DIVISION_ID
					, L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK) 
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
				--ORDER BY L.DISPLAY_SEQ
				
				UNION ALL

			-- 'BizTypebyDivision'			
				SELECT DISTINCT DIVISION_ID, 
					 BIZ_TYPE       AS CODE 
				   , BIZ_TYPE_NAME  AS NAME
				  FROM   [DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
				  WHERE   BIZ_TYPE_NAME != ''
			END		


			-- EdiSender
			BEGIN
				SELECT SEGMENT2 AS CODE, ATTRIBUTE1 AS NAME
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK)
				WHERE LOOKUP_TYPE = 'EDI_SENDER_CODE'
					AND VALID_YN = 'Y'
					AND SEGMENT1 = '81'
				ORDER BY DISPLAY_SEQ	
			END
						
			
			--'FromSiteByDivision'					
			BEGIN

				SELECT	A.DIVISION_ID
					,	SCM_SITE_ID        AS CODE
					,	SCM_SITE_ID		   AS NAME
					 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
				FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)	
				WHERE SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
				FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    		 AND    UserID  LIKE '%'+ @UserID + '%'
										 AND    AuthType = @AuthTypePara)				 
			END		
			
		END	/* @UICode = 'DMF0035'*/
		
		IF @UICode = 'DMF0022'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				

			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

				SELECT DISTINCT A.DIVISION_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END


			--BizType
			BEGIN
			-- 'DM_BIZ_TYPE'			
				SELECT '40' AS DIVISION_ID
					, L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK) 
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
				--ORDER BY L.DISPLAY_SEQ
				
				UNION ALL

			-- 'BizTypebyDivision'			
				SELECT DISTINCT DIVISION_ID, 
					 BIZ_TYPE       AS CODE 
				   , BIZ_TYPE_NAME  AS NAME
				  FROM   [DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
				  WHERE   BIZ_TYPE_NAME != ''
			END		
			

			--PlantSiteByEndCustomer			
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
					   SCM_SITE_ID AS CODE 
					 , SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'PLANT'
				AND    A.DIVISION_ID IN (SELECT CODE 
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
										 WHERE  GroupID LIKE @GroupID + '%'
						    			 AND    UserID  LIKE @UserID + '%'
										 AND    AuthType = 'D')  
			END
										
			
			--'FromSiteByDivision'					
			BEGIN

				SELECT	A.DIVISION_ID
					,	SCM_SITE_ID        AS CODE
					,	SCM_SITE_ID		   AS NAME
					 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
				FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)	
				WHERE SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
				FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    		 AND    UserID  LIKE '%'+ @UserID + '%'
										 AND    AuthType = @AuthTypePara)				 
			END		

		END	/* @UICode = 'DMF0022'*/
		
		IF @UICode = 'DMF0048'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				

			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, '' AS DEPT_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID != '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

			--	'SiteByEndCustomer40'	
				SELECT DISTINCT A.DIVISION_ID, C.DEPT_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
					LEFT JOIN (
								SELECT DISTINCT A.USER_ID, A.DEPT_ID 
								FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK) , SCM_MST_SSO_DEPT_INFO B  WITH(NOLOCK) 
								WHERE A.DEPT_ID = B.DEPT_ID
							) C ON B.OWNER = C.USER_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID = '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END
			

			--BizType
			BEGIN
			-- 'DM_BIZ_TYPE'			
				SELECT '40' AS DIVISION_ID
					, L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK) 
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
				--ORDER BY L.DISPLAY_SEQ
				
				UNION ALL

			-- 'BizTypebyDivision'			
				SELECT DISTINCT DIVISION_ID, 
					 BIZ_TYPE       AS CODE 
				   , BIZ_TYPE_NAME  AS NAME
				  FROM   [DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
				  WHERE   BIZ_TYPE_NAME != ''
			END		
						

			--PlantSiteByEndCustomer			
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
					   SCM_SITE_ID AS CODE 
					 , SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'PLANT'
				AND    A.DIVISION_ID IN (SELECT CODE 
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
										 WHERE  GroupID LIKE @GroupID + '%'
						    			 AND    UserID  LIKE @UserID + '%'
										 AND    AuthType = 'D')  
			END
										
			
			--'FromSiteByDivision'					
			BEGIN

				SELECT	A.DIVISION_ID
					,	SCM_SITE_ID        AS CODE
					,	SCM_SITE_ID		   AS NAME
					 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
				FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)	
				WHERE SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
				FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    		 AND    UserID  LIKE '%'+ @UserID + '%'
										 AND    AuthType = @AuthTypePara)				 
			END		

		END	/* @UICode = 'DMF0048'*/
		
		IF @UICode = 'DMF0008'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				

			-- 'SiteByEndCustomer'				
			BEGIN
			-- 'SiteByEndCustomer'		
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL
			--ScmSitebyEndCustomer40
				SELECT DISTINCT ST.DIVISION_ID, '' AS END_CUSTOMER,
					ST.SCM_SITE_ID AS CODE, SITE_DESCRIPTION AS NAME
				FROM SCM_MST_SITE AS ST WITH(NOLOCK)
				WHERE  1 = 1
				AND    ST.DIVISION_ID = '40'
				AND    ST.SITE_TYPE = 'SALES'		
				AND    ST.DIVISION_ID IN (SELECT CODE 
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    		 AND    UserID  LIKE '%'+ @UserID + '%'
										 AND    AuthType = 'D')
				ORDER BY A.DIVISION_ID

			END

		END	/* @UICode = 'DMF0008'*/
		
		IF @UICode = 'DMF0021'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				

			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, '' AS DEPT_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL
			
			--	'SiteByEndCustomer40'	
				SELECT DISTINCT A.DIVISION_ID, C.DEPT_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
					LEFT JOIN (
								SELECT DISTINCT A.USER_ID, A.DEPT_ID 
								FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK) , SCM_MST_SSO_DEPT_INFO B  WITH(NOLOCK) 
								WHERE A.DEPT_ID = B.DEPT_ID
							) C ON B.OWNER = C.USER_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID = '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID

			END


			--BizType
			BEGIN
			-- 'DM_BIZ_TYPE'			
				SELECT '40' AS DIVISION_ID
					, L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK) 
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
				--ORDER BY L.DISPLAY_SEQ
				
				UNION ALL

			-- 'BizTypebyDivision'			
				SELECT DISTINCT DIVISION_ID, 
					 BIZ_TYPE       AS CODE 
				   , BIZ_TYPE_NAME  AS NAME
				  FROM   [DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
				  WHERE   BIZ_TYPE_NAME != ''
			END		
						

			--PlantSiteByEndCustomer			
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
					   SCM_SITE_ID AS CODE 
					 , SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'PLANT'
				AND    A.DIVISION_ID IN (SELECT CODE 
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
										 WHERE  GroupID LIKE @GroupID + '%'
						    			 AND    UserID  LIKE @UserID + '%'
										 AND    AuthType = 'D')  
			END
										
			
			--'FromSiteByDivision'					
			BEGIN

				SELECT	A.DIVISION_ID
					,	SCM_SITE_ID        AS CODE
					,	SCM_SITE_ID		   AS NAME
					 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
				FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)	
				WHERE SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
				FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    		 AND    UserID  LIKE '%'+ @UserID + '%'
										 AND    AuthType = @AuthTypePara)				 
			END		

		END	/* @UICode = 'DMF0021'*/
		
		IF @UICode = 'DMF0004'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				

			-- 'SiteByEndCustomer'				
			BEGIN
			-- 'SiteByEndCustomer'		
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL
			--ScmSitebyEndCustomer40
				SELECT DISTINCT ST.DIVISION_ID, '' AS END_CUSTOMER,
					ST.SCM_SITE_ID AS CODE, SITE_DESCRIPTION AS NAME
				FROM SCM_MST_SITE AS ST WITH(NOLOCK)
				WHERE  1 = 1
				AND    ST.DIVISION_ID = '40'
				AND    ST.SITE_TYPE = 'SALES'		
				AND    ST.DIVISION_ID IN (SELECT CODE 
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    		 AND    UserID  LIKE '%'+ @UserID + '%'
										 AND    AuthType = 'D')
				ORDER BY A.DIVISION_ID

			END
			

			--SoldToCustomerData
			BEGIN
				SELECT '40' AS DIVISION_ID, STEAM.DEPT_ID,
					SITE.SOLDTO_CUSTOMER AS CODE
					, SITE.SOLDTO_CUSTOMER AS NAME
				FROM SCM_MST_SITE AS SITE
				INNER JOIN (
					SELECT SI.DIVISION_ID
						,SI.SCM_SITE_ID 
						,SI.ITEM_ID
						,SU.DEPT_ID
					FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] SU WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] TM
					WHERE SI.DIVISION_ID = '40'
					AND SI.OWNER = SU.USER_ID
					AND SU.DEPT_ID = TM.DEPT_ID
				) AS STEAM
				ON SITE.SCM_SITE_ID = STEAM.SCM_SITE_ID 
				WHERE SITE.DIVISION_ID = '40'
				GROUP BY STEAM.DEPT_ID, SITE.SOLDTO_CUSTOMER
				--ORDER BY SITE.SOLDTO_CUSTOMER
			
			UNION ALL

				SELECT DIVISION_ID, DEPT_INFO.DEPT_ID,
					SOLDTO_CUSTOMER AS CODE
					, SOLDTO_CUSTOMER AS NAME
					--, SITE.DEPT_ID
				FROM [SCM_MST_SITE] AS SITE --94
				INNER JOIN [SCM_MST_SSO_DEPT_INFO] AS DEPT_INFO
				ON SITE.DEPT_ID = DEPT_INFO.DEPT_ID
				WHERE DIVISION_ID != '40'
					AND SOLDTO_CUSTOMER IS NOT NULL
				GROUP BY DIVISION_ID, DEPT_INFO.DEPT_ID, SOLDTO_CUSTOMER
			END

		END	/* @UICode = 'DMF0004'*/
		
		IF @UICode = 'DMF0044'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			
		END	/* @UICode = 'DMF0044'*/
		
		IF @UICode = 'DMF0049'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END


			-- 'EndCustomerByDivision'
			BEGIN

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END	 

		END	/* @UICode = 'DMF0049'*/
		
		IF @UICode = 'DMF0014'
		BEGIN
			
			--Declare @AuthTypePara varchar(100) = 'D'		   
			--IF(@GroupID = 'JV Planner') SET @AuthTypePara = 'J';
				
			--DEClARE @TeambyDivision_Lang NVARCHAR(200)

			---- 'Division'
			--	SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) 
			--	GROUP BY DIVISION_ID 
			--	ORDER BY DIVISION_ID

			
			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
				FROM  
					[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN   
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthTypePara) 
					AND VALID_YN = 'Y'  
				GROUP BY 
					DIVISION_ID, ATTRIBUTE1
				ORDER BY ATTRIBUTE1
			END
			

			-- 'TeambyDivision'
			BEGIN

				SELECT @TeambyDivision_Lang = Language
				FROM dbo.TB_FX_User
				WHERE UserID = @UserID

				SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GroupID + '%'
						AND    UserID  LIKE '%'+ @UserID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from scm_mst_site_item a  WITH(NOLOCK)
						,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GroupID + '%'
											AND    USERID  LIKE '%'+ @UserID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		
				

			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, '' AS DEPT_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID != '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

			--	'SiteByEndCustomer40'	
				SELECT DISTINCT A.DIVISION_ID, C.DEPT_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
					LEFT JOIN (
								SELECT DISTINCT A.USER_ID, A.DEPT_ID 
								FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK) , SCM_MST_SSO_DEPT_INFO B  WITH(NOLOCK) 
								WHERE A.DEPT_ID = B.DEPT_ID
							) C ON B.OWNER = C.USER_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID = '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    			AND    UserID  LIKE '%'+ @UserID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END
							
			
			--'FromSiteByDivision'					
			BEGIN

				SELECT	A.DIVISION_ID
					,	SCM_SITE_ID        AS CODE
					,	SCM_SITE_ID		   AS NAME
					 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
				FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)	
				WHERE SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
				FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GroupID + '%'
							    		 AND    UserID  LIKE '%'+ @UserID + '%'
										 AND    AuthType = @AuthTypePara)				 
			END		

		END	/* @UICode = 'DMF0014'*/

END