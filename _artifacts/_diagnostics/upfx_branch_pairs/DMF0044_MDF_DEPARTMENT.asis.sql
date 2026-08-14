	IF @Code = 'DMF0044_MDF_DEPARTMENT'

	BEGIN



		IF @Param1 <> ''

		BEGIN

			IF @Param1  = '40'

			BEGIN

				SELECT L.SEGMENT1  AS CODE

					, L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'MDF_DEPARTMENT'

				AND    L.VALID_YN    = 'Y'

				ORDER BY DISPLAY_SEQ

			END

			ELSE

			BEGIN

				SELECT L.SEGMENT1  AS CODE

					, L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'MDF_DEPARTMENT_' + RTRIM(@Param1)

				AND    L.VALID_YN    = 'Y'

				ORDER BY DISPLAY_SEQ

			END

		END

		ELSE	-- 파라미터 추가하기 전까지는 소형만 사용

		BEGIN

				SELECT L.SEGMENT1  AS CODE

					, L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'MDF_DEPARTMENT'

				AND    L.VALID_YN    = 'Y'

				ORDER BY DISPLAY_SEQ

		END



	END



	/*===============================================

	용		 도:  DMF0005 > OS_CORP 칼럼

	사 용 화 면:  DMF0005

	변       수:  -

	최 초 작 성:  2019. 06. 13

	개  발  자 :  JYE

	최 종 작 성:

	수  정  자 :

	수 정 사 항:

	===============================================*/
