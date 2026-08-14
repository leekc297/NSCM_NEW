	IF @Code = 'DMF0042_BP_Measure'

	BEGIN



		IF (@Param1 = '') BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0042' AND SHEET_NAME = 'Biz Plan'

			ORDER BY SORT_ORDER_NO

		END ELSE BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0042' AND SHEET_NAME = 'Biz Plan'

				--AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )

				AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )

			ORDER BY SORT_ORDER_NO

		END



	END



	/*===============================================

	용		 도:  MDF Simulator > Currency 조회

	사 용 화 면:  DMF0041

	변       수:  -

	최 초 작 성:  2019. 04. 24

	개  발  자 :  JYE

	최 종 작 성:

	수  정  자 :

	수 정 사 항:

	===============================================*/
