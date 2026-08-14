	IF @Code = 'PlanDateShip'

	BEGIN



	  IF @Param2 = 'P'

			BEGIN

				SELECT DISTINCT TOP 20 A.PLAN_START_YYYYMMDD AS CODE , convert(VARCHAR(10), convert(DATETIME, A.PLAN_START_YYYYMMDD),121) name

				FROM

				(

					SELECT CONVERT(CHAR(8), DATEADD(DD, 1, CONVERT(VARCHAR, ATTRIBUTE1, 121)), 112)   as PLAN_START_YYYYMMDD

					FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL]

					WHERE LOOKUP_TYPE = 'SSP_ANL_SHIP_PLAN_P'



					UNION ALL



					SELECT DISTINCT PLAN_START_YYYYMMDD

					FROM [DBO].[SSP_ANL_SHIP_PLAN_P] WITH(NOLOCK)

					WHERE DIVISION_ID = '40'

				) A

				ORDER BY 1 DESC

			END

		ELSE

			BEGIN

				 SELECT TOP 20 plan_start_yyyymmdd code

				,convert(VARCHAR(10), convert(DATETIME, plan_start_yyyymmdd),121) name

				FROM [dbo].[SSP_PLAN_VERSION_V] WITH(NOLOCK)

				WHERE CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

								ELSE division_id

 						   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',') )

				GROUP BY plan_start_yyyymmdd

				ORDER BY plan_start_yyyymmdd DESC;

			END



	  /*

		기존 코드 백업(21.10.07)

		SELECT TOP 20 plan_start_yyyymmdd code

			,convert(VARCHAR(10), convert(DATETIME, plan_start_yyyymmdd),121) name

		FROM SSP_PLAN_VERSION_V WITH(NOLOCK)

		WHERE CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

                        ELSE division_id

 	               END  IN ( SELECT token FROM dbo.String_Split(@Param1,',') )

		GROUP BY plan_start_yyyymmdd

		ORDER BY plan_start_yyyymmdd DESC;

	  */



	END



/*===============================================

		용		 도:  PlanTypeShip LOOKUP COMBO BOX

		사 용 화 면:  SSP	-	Plan TYPE

		변       수:  -

		최 초 작 성:  2018. 06. 14

		개  발  자 :  박 진 수

		최 종 작 성:  -

		수  정  자 :  -

		수 정 사 항:

		===============================================*/


