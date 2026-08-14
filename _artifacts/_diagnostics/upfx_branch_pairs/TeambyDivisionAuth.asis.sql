IF @Code = 'TeambyDivisionAuth'

		BEGIN

			-- 복수 팀 권한 작업. 20180529

			DECLARE @v_team_cnt int=0; -- 다수 팀 권한



			----------------------------------------------------------------------------------------------

			-- 20200428 KHSONG PM TEAM MAPPING 인경우 본인 팀이 선택이 안되는 오류로 쿼리 수정 (BEGIN)

			----------------------------------------------------------------------------------------------



												--SELECT  @v_team_cnt = count(SEGMENT3)

												--FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

												--WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

												--AND VALID_YN = 'Y'

												--AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK)  WHERE UserID = @Param4)

			SELECT  @v_team_cnt = COUNT(DEPT_ID)

				FROM

					(

					SELECT SEGMENT3 AS DEPT_ID

						FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

							WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

								AND VALID_YN = 'Y'

								AND SEGMENT1 = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK)  WHERE UserID = @Param4)

					UNION



					SELECT DEPT_ID FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

						WHERE  U.UserID = @Param4

					) A

			----------------------------------------------------------------------------------------------

			-- 20200428 KHSONG PM TEAM MAPPING 인경우 본인 팀이 선택이 안되는 오류로 쿼리 수정 (BEGIN)

			----------------------------------------------------------------------------------------------





			IF (@v_team_cnt <= 1) -- 일반적인 팀 정보 조회

			BEGIN



				IF (@Param1 <> '40')

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

					--                  FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b

					--                  CROSS APPLY x.nodes('/t') t(c)

							)

					AND    A.DIVISION_ID IN (SELECT CODE

							FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

							WHERE  GroupID LIKE '%'+ @Param3 + '%'

							AND    UserID  LIKE '%'+ @Param4 + '%'

							AND    AuthType = 'D')

					and B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	-- 20190107

					ORDER BY CODE, NAME





					-- 속도 개선. 20190109

					--SELECT DISTINCT

					--   B.DEPT_ID       AS CODE

					--  , B.DEPT_NAME_KO  AS NAME

					--FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)

					--INNER JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

					--ON A.DEPT_ID  = B.DEPT_ID

					--WHERE  A.SITE_TYPE = 'SALES'

					--AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1

					--			ELSE A.DIVISION_ID

					--	   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

					--			   )

				 --  -- 팀, 권한에 대한 것

					----AND    CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN'

					----	   ELSE B.DEPT_ID END = CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN' ELSE @v_dept_id END



					--and B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	-- 20190107

				END

				ELSE

				BEGIN



					SELECT DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME

					  FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)

						  ,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)

						  ,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)

					 WHERE A.OWNER = B.USER_ID

					 AND B.DEPT_ID = C.DEPT_ID

					   AND A.DIVISION_ID = '40'

					   AND B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	-- 20190107

					  ORDER BY NAME

					-- 속도 개선. 20190109

					--SELECT DISTINCT

					--   B.DEPT_ID       AS CODE

					--  , B.DEPT_NAME_KO  AS NAME

					--FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)

					---- 20180615 수정 start

					--LEFT JOIN [dbo].[SCM_MST_SITE_ITEM] ITEM WITH(NOLOCK)

					--	ON A.DIVISION_ID = ITEM.DIVISION_ID AND A.SCM_SITE_ID = ITEM.SCM_SITE_ID

					--LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

					--	ON B.DEPT_ID  = CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID

					--							ELSE (

					--			SELECT SU.DEPT_ID

					--		FROM [dbo].[SCM_MST_SSO_USER_INFO] su

					--	WHERE SU.USER_ID = ITEM.OWNER

					--			)

					--	END

					---- 20180615 수정 end

					--WHERE  A.SITE_TYPE = 'SALES'

					----AND    A.DEPT_ID  = B.DEPT_ID   --20180615

					--AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1

					--			ELSE A.DIVISION_ID

					--	   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

					--			   )

				 --  -- 팀, 권한에 대한 것

					----AND    CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN'

					----	   ELSE B.DEPT_ID END = CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN' ELSE @v_dept_id END



					--and B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	-- 20190107

				END

			END

			ELSE

			BEGIN

				IF (@Param1 <> '40')

				BEGIN

					-- 복수 팀 정보 조회

					SELECT DISTINCT

					   B.DEPT_ID       AS CODE

					  , B.DEPT_NAME_KO  AS NAME

					FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)

						 , [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

					WHERE  A.SITE_TYPE = 'SALES'

					AND    A.DEPT_ID  = B.DEPT_ID

					AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1

								ELSE A.DIVISION_ID

						   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

								   )

					AND B.DEPT_ID IN (

						SELECT  SEGMENT3

						FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

						WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

						AND VALID_YN = 'Y'

						AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK) WHERE UserID = @Param4)

						-- 2018/05/29   jye (start)

						UNION

						SELECT U.DEPT_ID

						FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

						WHERE  U.UserID = @Param4

						-- 2018/05/29   jye (end)

					)

				END

				ELSE

				BEGIN

					-- 복수 팀 정보 조회

					SELECT DISTINCT

					   B.DEPT_ID       AS CODE

					  , B.DEPT_NAME_KO  AS NAME

					FROM   [dbo].[SCM_MST_SITE]       A  WITH(NOLOCK)

					-- 20180615 수정 start

					LEFT JOIN [dbo].[SCM_MST_SITE_ITEM] ITEM WITH(NOLOCK)

						ON A.DIVISION_ID = ITEM.DIVISION_ID AND A.SCM_SITE_ID = ITEM.SCM_SITE_ID

					LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

						ON B.DEPT_ID  = CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID

												ELSE (

								SELECT SU.DEPT_ID

							FROM [dbo].[SCM_MST_SSO_USER_INFO] su

						WHERE SU.USER_ID = ITEM.OWNER

								)

						END

					-- 20180615 수정 end

					WHERE  A.SITE_TYPE = 'SALES'

					-- AND    A.DEPT_ID  = B.DEPT_ID  --20180615

					AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1

								ELSE A.DIVISION_ID

						   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

								  )

					AND B.DEPT_ID IN (

						SELECT  SEGMENT3

						FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

						WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

						AND VALID_YN = 'Y'

						AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK) WHERE UserID = @Param4)

						-- 2018/05/29   jye (start)

						UNION

						SELECT U.DEPT_ID

						FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

						WHERE  U.UserID = @Param4

						-- 2018/05/29   jye (end)

					)

				END

			END

		END


