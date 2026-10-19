Declare @AuthTypePara varchar(100) = 'D';
			IF(@GROUP_ID = 'JV Planner') SET @AuthTypePara = 'J';
				
			DEClARE @TeambyDivision_Lang NVARCHAR(200) = '';
			

			SELECT @TeambyDivision_Lang = ISNULL(Language, 'KO')
			FROM [LGCE_SCMDEV].[dbo].[TB_FX_User]
			WHERE UserID = @USER_ID;
				  

			-- 'MyDivision' 
			BEGIN
				SELECT   
					DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME 
				FROM [LGCE_SCMDEV].[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)  
				WHERE   
					A.ATTRIBUTE3 <> 'EE'
					AND DIVISION_ID IN 
					(SELECT CODE FROM [LGCE_SCMDEV].[dbo].[TB_FX_UserGroupAuthExtention] AS A WITH(NOLOCK) WHERE GroupID = @GROUP_ID AND UserID = @USER_ID AND AuthType = CASE WHEN GroupID = 'JV Planner' THEN 'J' ELSE 'D' END)  
					AND VALID_YN = 'Y'  
					GROUP BY 
						DIVISION_ID, ATTRIBUTE1
					ORDER BY ATTRIBUTE1;
			END
 
			-- 'TeambyDivision'
			BEGIN

				SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID,
					B.DEPT_ID       AS CODE
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
												WHEN 'CN' THEN B.DEPT_NAME_CN
												ELSE B.DEPT_NAME_KO
												END
					AS NAME
				FROM  [LGCE_SCMDEV].[dbo].[SCM_MST_SITE]          A WITH(NOLOCK) 
					, [LGCE_SCMDEV].[dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK) 
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID  
				AND    A.DIVISION_ID IN (SELECT CODE 
						FROM   [LGCE_SCMDEV].[dbo].[TB_FX_UserGroupAuthExtention] AS A WITH(NOLOCK) 
						WHERE  GroupID LIKE '%'+ @GROUP_ID + '%'
						AND    UserID  LIKE '%'+ @USER_ID + '%'
						AND    AuthType = 'D')

			UNION ALL
				
				select distinct a.division_id AS DIVISION_ID, c.dept_id AS CODE 
					, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
								WHEN 'CN' THEN C.DEPT_NAME_CN
								ELSE C.DEPT_NAME_KO
								END AS NAME
					from [LGCE_SCMDEV].[dbo].[scm_mst_site_item] a  WITH(NOLOCK)
						,[LGCE_SCMDEV].[dbo].[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
						,[LGCE_SCMDEV].[dbo].[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
					where 
					b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
					and b.dept_id = c.dept_id
					and a.division_id = '40'
					order by DIVISION_ID;
			END


			-- 'EndCustomerByDivision'
			BEGIN
			-- 'EndCustomerByDivision40'

 				SELECT DISTINCT A.DIVISION_ID, B.DEPT_ID, A.PROJECT_CODE AS CODE 
					, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
				FROM [LGCE_SCMDEV].[dbo].SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					INNER JOIN [LGCE_SCMDEV].[dbo].[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
					INNER JOIN [LGCE_SCMDEV].[dbo].[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN [LGCE_SCMDEV].[dbo].SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE 
				B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
				AND A.VALID_YN = 'Y'
				UNION
				SELECT SEGMENT1, '', SEGMENT2 AS CODE , SEGMENT3 AS NAME
				FROM  [LGCE_SCMDEV].[dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
				AND SEGMENT2 <> '-'
				AND VALID_YN = 'Y'	
				AND SEGMENT1 = '40' 

				UNION ALL

			-- 'EndCustomerByDivisionDept'
				SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, 
						A.END_CUSTOMER AS CODE 
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   [LGCE_SCMDEV].[dbo].SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN [LGCE_SCMDEV].[dbo].SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    A.DIVISION_ID IN (SELECT CODE 
									FROM   [LGCE_SCMDEV].[dbo].TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK) 
					    					WHERE  GROUPID LIKE '%'+ @GROUP_ID + '%'
											AND    USERID  LIKE '%'+ @USER_ID + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.DIVISION_ID

			END		


			--BizType
			BEGIN
			-- 'DM_BIZ_TYPE'			
				SELECT '40' AS DIVISION_ID
					, L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [LGCE_SCMDEV].[dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK) 
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
				--ORDER BY L.DISPLAY_SEQ
				
				UNION ALL

			-- 'BizTypebyDivision'			
				SELECT DISTINCT DIVISION_ID, 
					 BIZ_TYPE       AS CODE 
				   , BIZ_TYPE_NAME  AS NAME
				  FROM   [LGCE_SCMDEV].[DBO].[SCM_MST_PROJECT]  WITH(NOLOCK)
				  WHERE   BIZ_TYPE_NAME != ''
			END		

				
			-- 'SiteByEndCustomer'				
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, '' AS DEPT_ID, A.END_CUSTOMER,
						SCM_SITE_ID AS CODE 
						, SCM_SITE_ID AS NAME
				FROM   [LGCE_SCMDEV].[DBO].[SCM_MST_SITE] A WITH(NOLOCK) 
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'	
				AND    A.DIVISION_ID != '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   [LGCE_SCMDEV].[DBO].[TB_FX_UserGroupAuthExtention] AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GROUP_ID + '%'
							    			AND    UserID  LIKE '%'+ @USER_ID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'	

			UNION ALL

			--	'SiteByEndCustomer40'	
				SELECT DISTINCT A.DIVISION_ID, C.DEPT_ID, B.PROJECT_CODE,
						A.SCM_SITE_ID AS CODE 
						, A.SCM_SITE_ID AS NAME
				FROM   [LGCE_SCMDEV].[DBO].[SCM_MST_SITE] AS A WITH(NOLOCK) 
					LEFT JOIN [LGCE_SCMDEV].[DBO].[SCM_MST_SITE_ITEM] AS B WITH(NOLOCK) 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
					LEFT JOIN (
								SELECT DISTINCT A.USER_ID, A.DEPT_ID 
								FROM [LGCE_SCMDEV].[DBO].[SCM_MST_SSO_USER_INFO] A WITH(NOLOCK) , [LGCE_SCMDEV].[DBO].[SCM_MST_SSO_DEPT_INFO] B  WITH(NOLOCK) 
								WHERE A.DEPT_ID = B.DEPT_ID
							) C ON B.OWNER = C.USER_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND    A.DIVISION_ID = '40'
				AND    A.DIVISION_ID IN (SELECT CODE 
											FROM   [LGCE_SCMDEV].[DBO].[TB_FX_UserGroupAuthExtention] AS A WITH(NOLOCK) 
					    					WHERE  GroupID LIKE '%'+ @GROUP_ID + '%'
							    			AND    UserID  LIKE '%'+ @USER_ID + '%'
											AND    AuthType = @AuthTypePara)
				AND A.VALID_YN = 'Y'
				ORDER BY A.DIVISION_ID
			END

			
			--'FromSiteByDivision'
			BEGIN

				SELECT	A.DIVISION_ID
					,	SCM_SITE_ID        AS CODE
					,	SCM_SITE_ID		   AS NAME
				FROM [LGCE_SCMDEV].[dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
				WHERE SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID IN (SELECT CODE
				FROM   [LGCE_SCMDEV].[dbo].[TB_FX_UserGroupAuthExtention] AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GROUP_ID + '%'
							    		 AND    UserID  LIKE '%'+ @USER_ID + '%'
										 AND    AuthType = @AuthTypePara)

			END		


			--PlantSiteByEndCustomer			
			BEGIN
				SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER,
					   SCM_SITE_ID AS CODE 
					 , SCM_SITE_ID AS NAME
				FROM   [LGCE_SCMDEV].[dbo].[SCM_MST_SITE] A
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'PLANT'
				AND    A.DIVISION_ID IN (SELECT CODE 
										 FROM   [LGCE_SCMDEV].[dbo].[TB_FX_UserGroupAuthExtention] AS A WITH(NOLOCK) 
										 WHERE  GroupID LIKE @GROUP_ID + '%'
						    			 AND    UserID  LIKE @USER_ID + '%'
										 AND    AuthType = 'D')  
			END


			-- EdiSender
			BEGIN
				SELECT SEGMENT2 AS CODE, ATTRIBUTE1 AS NAME
				FROM [LGCE_SCMDEV].[dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] (NOLOCK)
				WHERE LOOKUP_TYPE = 'EDI_SENDER_CODE'
					AND VALID_YN = 'Y'
					AND SEGMENT1 = '81'
				ORDER BY DISPLAY_SEQ	
			END


			--ScmSitebyEndCustomer40
			BEGIN
				SELECT DISTINCT ST.DIVISION_ID, '' AS END_CUSTOMER,
					ST.SCM_SITE_ID AS CODE, SITE_DESCRIPTION AS NAME
				FROM [LGCE_SCMDEV].[dbo].[SCM_MST_SITE] AS ST WITH(NOLOCK)
				WHERE  1 = 1
				AND    ST.DIVISION_ID = '40'
				AND    ST.SITE_TYPE = 'SALES'		
				AND    ST.DIVISION_ID IN (SELECT CODE 
										 FROM   [LGCE_SCMDEV].[dbo].[TB_FX_UserGroupAuthExtention] AS A WITH(NOLOCK) 
					    				 WHERE  GroupID LIKE '%'+ @GROUP_ID + '%'
							    		 AND    UserID  LIKE '%'+ @USER_ID + '%'
										 AND    AuthType = 'D')
				ORDER BY DIVISION_ID
			END