		IF @Code = 'MyDivision'



			BEGIN

				--SELECT

				--	DIVISION_ID AS CODE, MIN([DIVISION_NAME]) AS NAME

				--FROM

				--	[dbo].[SCM_MST_DIVISION] WITH(NOLOCK)

				--WHERE

				--	DIVISION_ID IN

				--	(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')

				--GROUP BY

				--	DIVISION_ID

				--ORDER BY DIVISION_ID



				Declare @AuthTypePara varchar(100) = 'D'

				if(@Param1 = 'JV Planner') SET @AuthTypePara = 'J';



	SELECT

		DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME

		--DIVISION_ID AS CODE, DIVISION_ID AS NAME

    FROM

		[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)

    WHERE

	    A.ATTRIBUTE3 <> 'EE'

		AND DIVISION_ID IN

		(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = @AuthTypePara)

		-- (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')

		--AND DIVISION_ID NOT IN ('EE','EE_UC')

		AND VALID_YN = 'Y'

				GROUP BY

					DIVISION_ID, ATTRIBUTE1

				--ORDER BY DIVISION_ID

				ORDER BY ATTRIBUTE1

			END



		-- 그룹-사용자-Division 별 Plant

		-- Param1 = GroupID, Param2 = UserID, Param3 = Division ID
