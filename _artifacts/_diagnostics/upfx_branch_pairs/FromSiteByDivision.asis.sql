		IF @Code = 'FromSiteByDivision'



		BEGIN

			Declare @AuthTypeParaDivision varchar(100) = 'D'

			if(@Param2 = 'JV Planner') SET @AuthTypeParaDivision = 'J';



			SELECT	SCM_SITE_ID        AS CODE

				,	SCM_SITE_ID		   AS NAME

				 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정

			FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)

			WHERE SITE_TYPE = 'PLANT'

			AND    A.VALID_YN  = 'Y'

			AND CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1

					 ELSE A.DIVISION_ID

				END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')



				         /*    SELECT t.c.value('.', 'NVARCHAR(4000)')

							 FROM   (SELECT x = CAST('<t>' + REPLACE( CASE @Param1 WHEN '' THEN 'ALL'ELSE @Param1 END             , ',', '</t><t>') + '</t>' AS xml)) b

							 CROSS APPLY x.nodes('/t') t(c) */				--2018-02-08 진준희 수정

						)



			AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정

		    FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    			 WHERE  GroupID LIKE '%'+ @Param2 + '%'

							    	 AND    UserID  LIKE '%'+ @Param3 + '%'

								     AND    AuthType = @AuthTypeParaDivision)

		END



		/*===============================================

		용		 도:  DIVISION 변경시 SITE 조회

		사 용 화 면:  DM0004_SCM_MST_SITE			-	MAIN SPREAD의 SITE 컬럼

					  DM0015_SCM_MST_BOD			-	MAIN SPREAD의 SITE 컬럼

		변       수:  @PARAM1 = DIVISION, @PARAM2 = GROUPID, @PARAM3 = USERID

		최 초 작 성:

		개  발  자 :

		최 종 작 성:  2018. 02. 14

		수  정  자 :  진 준 희

		수 정 사 항:  권한 그룹 추가.

		===============================================*/
