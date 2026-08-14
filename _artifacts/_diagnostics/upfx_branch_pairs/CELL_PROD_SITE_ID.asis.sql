	ELSE IF @Code = 'CELL_PROD_SITE_ID'

	BEGIN

	  	  --EXEC UP_FX_GETCOMMONDATALIST 'CELL_PROD_SITE_ID','40','MCMM9319V9A1-D15','','',''

		  --EXEC UP_FX_GETCOMMONDATALIST 'CELL_PROD_SITE_ID','','','','',''

		  -- @p_division_id -> @PARAM1  

		  -- @p_item_id     -> @PARAM2

		

		IF @PARAM1 IS NULL OR LEN(@PARAM1) = 0 OR @PARAM1 = '' 	-- 조회 했을 때 실행 (아래 IF문의 결과가 조회용 콤보박스가 된다.)

		BEGIN

				--SELECT '-' CODE,'Common' NAME

				--[PJ2025-50188] 고도화 - Common 도 Lookup 으로 가져오도록 수정

				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - START 

				SELECT SEGMENT1 AS CODE, ATTRIBUTE1 AS [NAME]

				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 

				WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND SEGMENT1 = '-' AND VALID_YN  = 'Y'

				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - END

				UNION ALL

				--현재 사용 중인 모든 셀생산지 리스트 가져오기 - START

				SELECT DISTINCT

					   S.SCM_SITE_ID  AS CODE

					 , M.ATTRIBUTE1    AS NAME

				FROM   SCM_MST_SITE S WITH(NOLOCK)

				INNER JOIN (

							SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP 

							--[C20200608-000328] SALESCOMPANY 콤보는 ITEM MASTER의 COMPANY ID, OPERATION GROUP 기준으로 조회

							FROM   SCM_MST_ITEM_SN I WITH(NOLOCK)

							WHERE  1=1

							AND    I.ACTIVE_FLAG = 'Y'

							AND    I.ITEM_TYPE IS NOT NULL 

							--AND    I.DIVISION_ID = @PARAM1

							--AND    I.ITEM_ID = CASE WHEN TRIM(@PARAM2) IN( '','ALL') THEN I.ITEM_ID ELSE @PARAM2 END

							AND    I.FORECAST_INFO_BIZ_TYPE = 'CELL'

							) SS

				ON  S.DIVISION_ID = SS.DIVISION_ID

				AND S.OPERATION_GROUP = SS.SCP_OPERATION_GROUP

				AND S.COMPANY_ID = SS.COMPANY_ID 

				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)

				ON  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'

				AND S.SCM_SITE_ID = M.SEGMENT1

				AND M.VALID_YN  = 'Y'

				WHERE  1 = 1

				AND    S.SITE_TYPE = 'PLANT'

				AND    S.OPERATION_GROUP = 'A'

				AND    S.OSP_YN = 'N' 

				--현재 사용 중인 모든 셀생산지 리스트 가져오기 - END

		END

		ELSE	--그 외 이벤트에서 실행 ( ex)대표적으로 ITEM_ID (@PARAM2) 를 변경 했을시 실행 된다.)

		BEGIN

			DECLARE @BIZ_TYPE NVARCHAR(100) = '';



			IF (SELECT COUNT(1) 

				FROM [SCM_ITEM_M_SN] T1 WITH (NOLOCK) 

				WHERE DIVISION_ID = @PARAM1 

				AND ACTIVE_FLAG = 'Y'	

				AND ITEM_ID = @PARAM2 

				AND FORECAST_INFO_BIZ_TYPE = 'CELL') > 0 -- CELL인 경우 @BIZ_TYPE을 CELL로 넣고 아닐 경우 빈칸이다.

			BEGIN

				SET @BIZ_TYPE = 'CELL'	

			END



			IF @BIZ_TYPE <> 'CELL'

			BEGIN

				--SELECT '-' CODE,'Common' NAME

				--[PJ2025-50188] 고도화 - Common 도 Lookup 으로 가져오도록 수정

				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - START 

				SELECT SEGMENT1 AS CODE, ATTRIBUTE1 AS [NAME]

				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 

				WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND SEGMENT1 = '-' AND VALID_YN  = 'Y'	--만약에 @BIZ_TYPE이 CELL이 아니라면 현재 기준 Comon으로 매핑 시킨다.

				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - END

			END

			ELSE

			BEGIN

				--SELECT '-' CODE,'Common' NAME WHERE @BIZ_TYPE <> 'CELL'

				--[PJ2025-50188] 고도화 - Common 도 Lookup 으로 가져오도록 수정

				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - START 

				SELECT SEGMENT1 AS CODE, ATTRIBUTE1 AS [NAME]

				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 

				WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND SEGMENT1 = '-' AND VALID_YN  = 'Y'	--만약에 @BIZ_TYPE이 CELL이 맞다면, Common은 사용하지 않는다.

				AND @BIZ_TYPE <> 'CELL'															--아예 빼도 상관은 없겠으나, 추가안한다는걸 확실히 알려주기 위해 넣었음.

				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - END								--혹시나 Common을 다시 넣어야 한다면 AND @BIZ_TYPE <> 'CELL' 주석하면 됨.

				UNION ALL

				SELECT DISTINCT																	

					   S.SCM_SITE_ID  AS CODE

					 , M.ATTRIBUTE1    AS NAME

				FROM   SCM_MST_SITE S WITH(NOLOCK)

				INNER JOIN (

							SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP 

							--[C20200608-000328] SALESCOMPANY 콤보는 ITEM MASTER의 COMPANY ID, OPERATION GROUP 기준으로 조회

							FROM   SCM_MST_ITEM_SN I WITH(NOLOCK)

							WHERE  1=1

							AND    I.ACTIVE_FLAG = 'Y'

							AND    I.ITEM_TYPE IS NOT NULL 

							AND    I.DIVISION_ID = @PARAM1

							AND    I.ITEM_ID = CASE WHEN TRIM(@PARAM2) IN( '','ALL') THEN I.ITEM_ID ELSE @PARAM2 END --ITEM_ID(@PARAM2)에 맞는 셀생산지만 가져온다.

							AND    I.FORECAST_INFO_BIZ_TYPE = 'CELL'

							) SS

				ON  S.DIVISION_ID = SS.DIVISION_ID

				AND S.OPERATION_GROUP = SS.SCP_OPERATION_GROUP

				AND S.COMPANY_ID = SS.COMPANY_ID 

				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)

				ON  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'

				AND S.SCM_SITE_ID = M.SEGMENT1

				AND M.VALID_YN  = 'Y'

				WHERE  1 = 1

				AND    S.SITE_TYPE = 'PLANT'

				AND    S.OPERATION_GROUP = 'A'

				AND    S.OSP_YN = 'N' 

			END

		END

	END



	/*==============================================================================================

	용		 도: [E20250821-001228]_Sales Site Project Model화면 Sales Plant Combo Box List 변경

	사 용 화 면: DMF0005

	변       수: @PARAM1 = DIVISION_ID, @PARAM2 = COMPANY_ID

	최 초 작 성: 2025.08.21

	개  발  자 : JSSBAE

	최 종 작 성:

	수  정  자 :

	수 정 사 항:

	==============================================================================================*/
