	IF @Code = 'SiteByEndCustomer'



		BEGIN

			Declare @AuthTypeParaSite varchar(100) = 'D'

			if(@Param3 = 'JV Planner') SET @AuthTypeParaSite = 'J';

			IF (@Param1 <> '40')

			BEGIN

				SELECT DISTINCT

					   SCM_SITE_ID AS CODE

					 , SCM_SITE_ID AS NAME

				FROM   SCM_MST_SITE A WITH(NOLOCK)

					-- added by ytchoi 190109 start

					INNER JOIN ( SELECT token FROM dbo.String_Split(@Param2,',') )AS C

					ON A.END_CUSTOMER = CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN A.END_CUSTOMER ELSE C.token END

					-- added by ytchoi 190109 end

				WHERE  1 = 1

				AND    A.SITE_TYPE = 'SALES'

				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1			--2018-02-08  진준희

						 ELSE A.DIVISION_ID

 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

                -- delete by ytchoi 190109 start

				--AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2			--2018-02-08  진준희

				--		 ELSE A.END_CUSTOMER

 			    --		END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

				--			/* SELECT t.c.value('.', 'NVARCHAR(4000)')

				--			 FROM   (SELECT x = CAST('<t>' + REPLACE( CASE @Param1 WHEN '' THEN 'ALL' ELSE @Param1 END , ',', '</t><t>') + '</t>' AS xml)) b

				--			 CROSS APPLY x.nodes('/t') t(c)		*/				--2018-02-08  진준희

				--			)

	            -- delete by ytchoi 190109 end

				AND    A.DIVISION_ID IN (SELECT CODE

										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		 AND    UserID  LIKE '%'+ @Param4 + '%'

										 AND    AuthType = @AuthTypeParaSite)

				AND A.VALID_YN = 'Y'	-- 20180612 추가

				ORDER BY SCM_SITE_ID ASC;

			END

			ELSE

			BEGIN

				-- 20180612 소형 추가

				SELECT DISTINCT

					   A.SCM_SITE_ID AS CODE

					 , A.SCM_SITE_ID AS NAME

				FROM   SCM_MST_SITE AS A WITH(NOLOCK)

					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK)

					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID

					-- added by ytchoi 190109 start

					INNER JOIN ( SELECT token FROM dbo.String_Split(@Param2,',') )AS C

					ON B.PROJECT_CODE = CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN B.PROJECT_CODE ELSE C.token END

					-- added by ytchoi 190109 end

				WHERE  1 = 1

				AND    A.SITE_TYPE = 'SALES'

				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

						 ELSE A.DIVISION_ID

 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

                -- delete by ytchoi 190109 start

				--AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2

				--	   ELSE B.PROJECT_CODE

 			    --	   END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

				--			)

				-- delete by ytchoi 190109 end

				AND    A.DIVISION_ID IN (SELECT CODE

										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		 AND    UserID  LIKE '%'+ @Param4 + '%'

										 AND    AuthType = @AuthTypeParaSite)

				AND A.VALID_YN = 'Y'

				ORDER BY A.SCM_SITE_ID ASC;

			END

		END





		/*===============================================

		용		 도:  END CUSTOEMR 변경시 SITE 조회

		사 용 화 면:  DM0015_SCM_MST_BOD		   -	MAIN SPREAD의 SITE 컬럼

					  DM0004_DM_MST_SITE_CUSTOMER  -	SUB SPREAD의 SITE 컬럼

		변       수:  @PARAM1 = ENDCUSTOMER, @PARAM2 =  ★누락되어 있음 화면 담당자 수정 필요, @PARAM3 = GROUP_ID, @PARAM4 = USER_ID

		최 초 작 성:

		개  발  자 :

		최 종 작 성:  2018. 07. 04

		수  정  자 :  이상훈

		수 정 사 항:  SoldtoCustomer 조회 조건 추가

		===============================================*/


