	IF @Code = 'MktFcstEditMeasure'

	    BEGIN

			DECLARE @MKT_FCST_MEASURE_VMI_YN NCHAR(1) = N'N'	-- VMI 를 위한 변수



			-- 2020.11.17 [C20201103-000114]

			-- @Param5 에 메저값을 받으면 해당 메저만 그대로 리턴한다.

			IF ( @PARAM1 = '82' AND ISNULL(@PARAM5,'') <> '')

			BEGIN

				SELECT SEGMENT2 AS CODE, SEGMENT3 AS NAME

				FROM [SCM_ADM_LOOKUP_MASTER_DETAIL]

				WHERE LOOKUP_TYPE = 'MKT_FCST_MEASURE'

					AND SEGMENT1 = @PARAM1

					AND SEGMENT2 = @PARAM5



			END

			ELSE

			BEGIN

				SELECT @MKT_FCST_MEASURE_VMI_YN = VMI_YN

				FROM scm_mst_site

				WHERE DIVISION_ID =@PARAM1

					AND SCM_SITE_ID = @PARAM2

					--AND DIVISION_ID = '40'	[C20200909-000212]



				-- TMM제외한 일반 MEASURE 추출

				SELECT

				  L.SEGMENT2  AS CODE  -- Measure코드

				, L.SEGMENT3  AS NAME  -- 사용자 입력 Measure명

				, L.DISPLAY_SEQ

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

					WHERE 1=1

					AND L.LOOKUP_TYPE	= 'MKT_FCST_MEASURE'

					AND L.VALID_YN		= 'Y'

					AND L.ATTRIBUTE2   <> 'Y'       -- TMM Measure여부

					AND L.SEGMENT1		= @Param1   -- Division_id

					AND SEGMENT4		= 'Y'       -- INSERT_YN 여부

					--[C20201015-000200]

					AND (( @MKT_FCST_MEASURE_VMI_YN = 'N' AND L.ATTRIBUTE1  <> 'Y' ) OR ( @MKT_FCST_MEASURE_VMI_YN = 'Y' ))

					----[C20200713-000189] [VMI-in Req] VMI Biz의 경우 VMI-in Req 입력을 통한 MKT FCST 자동산출 로직 추가

					--AND (	(@Param1 = '40' AND (( @MKT_FCST_MEASURE_VMI_YN = 'N' AND L.ATTRIBUTE1  <> 'Y' ) OR ( @MKT_FCST_MEASURE_VMI_YN = 'Y' AND L.ATTRIBUTE1  = 'Y')))

					--		OR (@Param1 <> '40' AND (( @MKT_FCST_MEASURE_VMI_YN = 'N' AND L.ATTRIBUTE1  <> 'Y' ) OR ( @MKT_FCST_MEASURE_VMI_YN = 'Y' )))

					--	)

					--AND ( L.ATTRIBUTE1  = 'ALL'     -- Vmi외의 Measure

					--	OR L.ATTRIBUTE1 = case when ( select count(1)  from scm_mst_site a WITH(NOLOCK) where a.VMI_YN = 'Y' and a.DIVISION_ID = @Param1 and a.SCM_SITE_ID = @Param2 ) > 0 THEN 'Y' ELSE 'N' END)  -- Vmi Measure선택조건

				----------

				UNION ALL

				----------



				--CUST_FCST MEASURE 추출

				SELECT T.CODE  -- Measure코드

					 , T.NAME  -- 사용자 입력 Measure명

					 , ROW_NUMBER() OVER (ORDER BY T.CODE) + 900 AS DISPLAY_SEQ

				FROM   (SELECT DISTINCT

							   CF.MEASURE              AS CODE

							 , CONCAT(N' └ ',MEASURE) AS NAME

						FROM   [dbo].[DM_MST_CUSTOMER_FCST] CF WITH(NOLOCK)

						WHERE  1 = 1

						AND    CF.VALID_YN      = 'Y'

						AND   CF.MEASURE_GROUP = 'CUST_FCST'

						AND    CF.DIVISION_ID   = @Param1

						AND    CF.SCM_SITE_ID   = @Param2

					   ) T

				----------

				UNION ALL

				----------



				--TMM Measure 추출

				SELECT

					  L.SEGMENT2  AS CODE  -- Measure코드

					, L.SEGMENT3  AS NAME  -- 사용자 입력 Measure명

					, L.DISPLAY_SEQ

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

					INNER JOIN (SELECT TOP 1 VALID_YN,SEGMENT1,SEGMENT2,SEGMENT4 FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) WHERE 1=1

									AND LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'

									AND VALID_YN	= 'Y'

									AND SEGMENT1	= @Param1	-- Division_id (@Param1)

									AND SEGMENT2	= @Param3	-- Project_Code (@Param3)

									AND SEGMENT4	= @Param4	-- UserId (@Param4)

									) T

						ON

						(

							L.SEGMENT1 = T.SEGMENT1  -- Division_id

						AND L.VALID_YN = T.VALID_YN

						AND L.LOOKUP_TYPE	= 'MKT_FCST_MEASURE'

						AND L.VALID_YN		= 'Y'

						AND L.SEGMENT1		= @Param1	-- Division_id (@Param1)

						AND L.ATTRIBUTE2    = 'Y'	-- TMM Measure여부

						AND L.SEGMENT4	  = 'Y'	-- INSERT_YN 여부

						)



				ORDER BY DISPLAY_SEQ

			END



		END;

	/*===============================================

	용		 도:  SALES PLAN, WATERFALL

	사 용 화 면:  DM0020,21

	변       수:  -

	최 초 작 성:  2018. 02. 28

	개  발  자 :  SeungJae.Hwang

	최 종 작 성:  -

	수  정  자 :  -

	수 정 사 항:

	===============================================*/
