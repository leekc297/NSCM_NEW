	IF @Code = 'SiteByEndCustomer_InnerCode'



	BEGIN



		IF (@Param1 <> '40')

		BEGIN

			SELECT DISTINCT

					SCM_SITE_ID AS CODE

					, SCM_SITE_ID AS NAME

			FROM   SCM_MST_SITE A WITH(NOLOCK)

			WHERE  1 = 1

			AND    A.SITE_TYPE = 'SALES'

			AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1			--2018-02-08  진준희

						ELSE A.DIVISION_ID

 				END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2			--2018-02-08  진준희

						ELSE A.END_CUSTOMER

 				END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

						/* SELECT t.c.value('.', 'NVARCHAR(4000)')

							FROM   (SELECT x = CAST('<t>' + REPLACE( CASE @Param1 WHEN '' THEN 'ALL' ELSE @Param1 END , ',', '</t><t>') + '</t>' AS xml)) b

							CROSS APPLY x.nodes('/t') t(c)		*/				--2018-02-08  진준희

						)

			AND    A.DIVISION_ID IN (SELECT CODE

										FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		AND    UserID  LIKE '%'+ @Param4 + '%'

										AND    AuthType = 'D')

			AND A.VALID_YN = 'Y'	-- 20180612 추가



			UNION ALL	-- 20180822



			--SELECT DISTINCT CUSTOMER_CODE AS CODE

			--	, CUSTOMER_CODE AS NAME

			--FROM [LGCE_INFDEV].[DBO].[XIF_ERP_SALES_RESULT_R]

			--WHERE LEN(CUSTOMER_CODE) < 6 AND CUSTOMER_CODE <> ''



			-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)



										--SELECT SEGMENT1  AS CODE

										--	 , SEGMENT1  AS NAME

										--FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

										--WHERE LOOKUP_TYPE = 'INTERNAL_TXN'



			SELECT COMPANY_ID AS CODE,COMPANY_ID AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)



			-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)



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

			WHERE  1 = 1

			AND    A.SITE_TYPE = 'SALES'

			AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

						ELSE A.DIVISION_ID

 				END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2

						ELSE B.PROJECT_CODE

 				END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

						)

			AND    A.DIVISION_ID IN (SELECT CODE

										FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		AND    UserID  LIKE '%'+ @Param4 + '%'

										AND    AuthType = 'D')

			AND A.VALID_YN = 'Y'



			UNION ALL	-- 20180822



			--SELECT DISTINCT CUSTOMER_CODE AS CODE

			--	, CUSTOMER_CODE AS NAME

			--FROM [LGCE_INFDEV].[DBO].[XIF_ERP_SALES_RESULT_R]

			--WHERE LEN(CUSTOMER_CODE) < 6 AND CUSTOMER_CODE <> ''



			-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)

											--SELECT SEGMENT1  AS CODE

											--	 , SEGMENT1  AS NAME

											--FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

											--WHERE LOOKUP_TYPE = 'INTERNAL_TXN'



			SELECT COMPANY_ID AS CODE,COMPANY_ID AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)



			-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)





			ORDER BY A.SCM_SITE_ID ASC;

		END

	END



	/*===============================================

	용		 도:  Sales Site 에 InsertRow COMPANY_ID 콤보 조회

	사 용 화 면:  DMF0004_SalesSite

	변       수:  -

	최 초 작 성:  2018. 09. 07

	개  발  자 :  son young suk

	최 종 작 성:  2018. 09. 07

	수  정  자 :

	수 정 사 항:

	===============================================*/
