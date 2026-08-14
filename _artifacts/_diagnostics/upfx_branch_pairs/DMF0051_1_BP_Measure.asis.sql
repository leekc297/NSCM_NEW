	ELSE IF @Code = 'DMF0051_1_BP_Measure'

	BEGIN



		IF (@Param1 = '')

		BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0051_1' AND SHEET_NAME = 'Biz Plan Waterfall'

			ORDER BY SORT_ORDER_NO

		END ELSE BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0051_1' AND SHEET_NAME = 'Biz Plan Waterfall'

				--AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )

				AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )

			ORDER BY SORT_ORDER_NO

		END



	END



	/*===============================================

	용		 도:  소형 CELL_PROD_SITE

	사 용 화 면:

	변       수:  -

	최 초 작 성:  2022. 06. 14

	개  발  자 :  ROSIA27

	최 종 작 성:

	수  정  자 :

	수 정 사 항:

	===============================================*/
