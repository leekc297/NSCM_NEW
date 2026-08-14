	IF @CODE = 'TeambyDivision'

	BEGIN



		DEClARE @TeambyDivision_Lang NVARCHAR(200)

		SELECT @TeambyDivision_Lang = Language

		FROM dbo.TB_FX_User

		WHERE UserID = @Param3



		SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')



		IF @Param1 = ''

			SET @Param1 = 'ALL';



		IF (@Param1 <> '40') -- 20180615 수정. Division 분기

		BEGIN

			SELECT DISTINCT

				B.DEPT_ID       AS CODE

				-- Modify by ytchoi 180310

				, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN

				                            WHEN 'CN' THEN B.DEPT_NAME_CN

											ELSE B.DEPT_NAME_KO

											END

				AS NAME

				--, SUBSTRING(B.DEPT_NAME_KO  ,CHARINDEX('.',B.DEPT_NAME_KO )+1, len(B.DEPT_NAME_KO ) ) AS NAME

			FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)

				, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

			WHERE  A.SITE_TYPE = 'SALES'

			AND    A.DEPT_ID  = B.DEPT_ID

			AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'

				ELSE A.DIVISION_ID

				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

				--SELECT t.c.value('.', 'NVARCHAR(4000)')

			--                  FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b

			--                  CROSS APPLY x.nodes('/t') t(c)

					)

			AND    A.DIVISION_ID IN (SELECT CODE

					FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					WHERE  GroupID LIKE '%'+ @Param2 + '%'

					AND    UserID  LIKE '%'+ @Param3 + '%'

					AND    AuthType = 'D')

			ORDER BY  NAME,CODE		--20190609

		END

		ELSE

		BEGIN

			-- 20180615 수정. 소형 Division 추가

			select distinct c.dept_id AS CODE

				, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN

				            WHEN 'CN' THEN C.DEPT_NAME_CN

							ELSE C.DEPT_NAME_KO

							END AS NAME

			  from scm_mst_site_item a  WITH(NOLOCK)

			      ,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)

				  ,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)

			 where -- a.owner = b.user_id

			   b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )

			   and b.dept_id = c.dept_id

			   and a.division_id = '40'

			  order by NAME



            /*

			SELECT DISTINCT

				B.DEPT_ID       AS CODE

				, B.DEPT_NAME_KO  AS NAME

			FROM   [dbo].[SCM_MST_SITE] A WITH(NOLOCK)

			INNER JOIN [dbo].[SCM_MST_SITE_ITEM] ITEM WITH(NOLOCK)

			ON A.DIVISION_ID = ITEM.DIVISION_ID AND A.SCM_SITE_ID = ITEM.SCM_SITE_ID

			LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

			ON B.DEPT_ID  = CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID

											ELSE (

							SELECT su.DEPT_ID

						FROM [dbo].[SCM_MST_SSO_USER_INFO] su

					WHERE su.user_id = ITEM.OWNER

							)

					END

			WHERE  A.SITE_TYPE = 'SALES'

			AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'

				ELSE A.DIVISION_ID

				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

					)

			AND    A.DIVISION_ID IN (SELECT CODE

					FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					WHERE  GroupID LIKE '%'+ @Param2 + '%'

					AND    UserID  LIKE '%'+ @Param3 + '%'

					AND    AuthType = 'D')

			ORDER BY CODE, NAME

			*/



		END

	END


