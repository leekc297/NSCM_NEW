	IF @CODE = 'TeambyDivision2'

	BEGIN



		IF @Param1 = ''

			SET @Param1 = 'ALL';



		IF (@Param1 = 'ALL') -- 20180615 수정. Division 분기

		BEGIN

			SELECT CODE, NAME FROM (

				SELECT DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME

				  FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)

					  ,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)

					  ,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)

				 WHERE A.OWNER = B.USER_ID

				   AND B.DEPT_ID = C.DEPT_ID

				   AND A.DIVISION_ID IN ('40', '42', '44')		-- 20190124

				UNION ALL

				SELECT DISTINCT

					B.DEPT_ID       AS CODE

					-- Modify by ytchoi 180310

					, B.DEPT_NAME_KO  AS NAME

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

			) MA

			ORDER BY NAME, CODE

		END

		ELSE IF (@Param1 = '40')

		BEGIN

			-- 20180615 수정. 소형 Division 추가

			SELECT DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME

			  FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)

			      ,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)

				  ,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)

			 WHERE A.OWNER = B.USER_ID

			   AND B.DEPT_ID = C.DEPT_ID

			   AND A.DIVISION_ID = '40'



		END

		ELSE

		BEGIN

			SELECT DISTINCT

				B.DEPT_ID       AS CODE

				-- Modify by ytchoi 180310

				, B.DEPT_NAME_KO  AS NAME

				--, SUBSTRING(B.DEPT_NAME_KO  ,CHARINDEX('.',B.DEPT_NAME_KO )+1, len(B.DEPT_NAME_KO ) ) AS NAME

			FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)

				, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

			WHERE  A.SITE_TYPE = 'SALES'

			AND    A.DEPT_ID  = B.DEPT_ID

			AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'

				ELSE A.DIVISION_ID

				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

				--SELECT t.c.value('.', 'NVARCHAR(4000)')

			--       FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b

			--                  CROSS APPLY x.nodes('/t') t(c)

					)

			AND    A.DIVISION_ID IN (SELECT CODE

					FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					WHERE  GroupID LIKE '%'+ @Param2 + '%'

					AND    UserID  LIKE '%'+ @Param3 + '%'

					AND    AuthType = 'D')

			ORDER BY CODE, NAME

		END

	END







	/*===============================================

	용		 도:

	사 용 화 면:

	변       수:  -

	최 초 작 성:

	개  발  자 :  KYH

	최 종 작 성:  -

	수  정  자 :  -

	수 정 사 항:

	===============================================*/
