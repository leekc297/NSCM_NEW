		ELSE IF @Code = 'SalesCompany'

			BEGIN

				IF ( @Param4 = '')

				BEGIN

					SELECT DISTINCT

						   S.COMPANY_ID AS CODE

						 , S.COMPANY_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					WHERE SITE_TYPE = 'PLANT'

						AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)

						AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					UNION ALL

					SELECT DISTINCT

						   COMPANY_ID AS CODE

						 , COMPANY_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					WHERE  1 = 1

						AND    SITE_TYPE = 'CORP'

						AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)

						AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					ORDER BY 1,2



				END

				ELSE

				BEGIN

					SELECT DISTINCT

						   S.COMPANY_ID AS CODE

						 , S.COMPANY_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					INNER join (SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회

								from   scm_mst_project_item SI with(nolock)

								inner join SCM_MST_ITEM_SN I with(nolock)

								on     SI.ITEM_ID = I.ITEM_ID

								--AND    SCP_OPERATION_GROUP IS NOT NULL --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회

								WHERE  1=1 --si.valid_yn = 'Y' --[C20200818-000264] Project_Item Master Valid 조건 제외, Item Master Valid 조건 추가

								AND    i.active_flag = 'Y'

								AND    (i.division_id LIKE '81%' OR i.division_id = '82')

								AND    i.item_type is not null --[C20200626-000172] SalesCompany, SalesPlant Item Type is not null 조건 추가

								AND    (@Param2 IS NULL OR @Param2='' OR SI.DIVISION_ID=@Param2)

								AND    (@Param3 IS NULL OR @Param3='' OR SI.PROJECT_CODE=@Param3)

								AND    (@Param4 IS NULL OR @Param4='' OR SI.ITEM_ID=@Param4)



								UNION ALL

								SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회

								from   SCM_MST_ITEM_SN I with(nolock)

								WHERE  1=1

								AND    i.active_flag = 'Y' --[C20200818-000264] Project_Item Master Valid 조건 제외, Item Master Valid 조건 추가

								AND    i.division_id in ('40')

								AND    i.item_type is not null --[C20200626-000172] SalesCompany, SalesPlant 에 Item Type is not null 조건 추가

								AND    (@Param2 IS NULL OR @Param2='' OR I.DIVISION_ID=@Param2)

								AND    (@Param4 IS NULL OR @Param4='' OR I.ITEM_ID=@Param4)

								) SS

					ON  S.DIVISION_ID = SS.DIVISION_ID

					AND S.OPERATION_GROUP = ISNULL(SS.SCP_OPERATION_GROUP, S.OPERATION_GROUP)

					AND S.COMPANY_ID = SS.COMPANY_ID --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회

					WHERE  1 = 1

					AND    SITE_TYPE = 'PLANT'

					--AND    OSP_YN    <> 'Y'

					AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)

					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					UNION ALL

					SELECT DISTINCT

						   COMPANY_ID AS CODE

						 , COMPANY_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					WHERE  1 = 1

					AND    SITE_TYPE = 'CORP'

					AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)

					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					ORDER BY 1,2

				END



			END;

		/*===============================================

		용		 도:  [C20200513-000276] Sales Plant 조회

		사 용 화 면:  DMF0005

		변       수:

		최 초 작 성:  2020. 05. 14

		개  발  자 :  P.C.I

		최 종 작 성:  2020. 05. 14

		수  정  자 :

		수 정 사 항:  [C20200521-000207] SalesCompany, SalesPlant 에 Division, Project, Item 조건 추가

		1. Item Master의 SCP_OPERATION_GROUP 에 해당하는 Plant만 List에 조회 됨

		2. Item Master의 SCP_OPERATION_GROUP 이 없는 경우에 모든 Plant가 List에 조회 됨

		3. Site Type이 'CORP' 인 Plant는 항상 List에 조회 됨

		2020.05.29 HWI1993 OSP_YN 제거 --> CASE 문으로 CODE, NAME 에서 OSP_YN 처리

		[C20200608-000328]  SalesPlant 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회

		[C20200626-000172] SalesCompany, SalesPlant 에 Item Type is not null 조건 추가

		[C20200818-000264] Sales Company / Sales Plant - Project_Item Master Valid 조건 제외

		2021.08.13 hwi1993	속도개선 테스트

		===============================================*/
