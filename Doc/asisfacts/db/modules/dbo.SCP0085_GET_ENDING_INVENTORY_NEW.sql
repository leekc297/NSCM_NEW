
/*
 * Program ID   : SCP0085_GET_ENDING_INVENTORY
 * Description  : 기말재고 REPORT
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/03/07   khj79			Initial Release - Digital SCM 3 Level 가속화를 위한 개선
 * 2022/03/29   khj79			Valuation class가 3020, 3030, 3040 인 경우 Item Type, Process Group, Material Group 컬럼을 일괄로 "저장품" 으로 표시
 * 2022/08/17   vadabi3			항목추가 (=가용재고, 보류재고, In-Transit)
 * 2022/09/14   vadabi3			당월 매일 재고 조회 기능 요청 => Monthly / Daily 구분 처리 필요
                                별도 SP 생성 시 추후 관리 불편, 하나로 통합 사용
 * 2022/09/16   vadabi3			SCP0085_GET_ENDING_INVENTORY_DAILY : DQ 별도 생성, 수정 시 같이 관리 필요
 * 2022/10/04   vadabi3			CELL_TYPE_GR 추가
 * 2022/10/04   vadabi3			GPLM Cell Conversion Factor 적용 개선 (-K, -A)
 * 2022/10/12   vadabi3			CELL_CONVER_QUANTITY 적용 개선 (-K, -A)
 * 2022/10/21   vadabi3			INVENTORY_SITE 적용
 * 2022/10/24   vadabi3         [Cell Convert Factor / Cell Convert Quantity] UI = 소수점 2자리, Excel = 소수점 전채 표시
 * 2022/10/28   vadabi3         CELL_CONVER_FACTOR Default 값 = 1
 * 2022/12/08   vadabi3         CELL_CF 정책 변경 (BOM > CELL_CF 적용)
                                (BOM = LGCE_FPDEV_TR.dbo.SCM_MODEL_COMP_TEMP 참조)
 * 2022/12/15   vadabi3         CELL_CONVER_FACTOR Default 값 = 1 => Null 인 경우 Null 표시
 * 2023/02/01   vadabi3         재고월령별 추가 작업 (1-13 Month)
 * 2023/03/30   vadabi3         CELL GROUP / PACK GROUP 매칭 개선
 * 2023/04/26   vadabi3         [Long Term Stock] 단위 동기화
 * 2023/04/26   vadabi3         전극 반제품) CELL GROUP / PACK GROUP 매칭 개선
 * 2023/05/09   vadabi3         현지화 표시
 * 2023/06/09   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - FP Table -> SN 으로 변경
 * 2023/07/03   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - 활성화 코드) CA 모델은 CP 모델의 Process Detail 적용
 * 2023/07/12   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - 속도 개선
 * 2023/07/13   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - Model - 멀티 조히 적용
 * 2023/07/27   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - 활성화 코드) SCP_MST_CELL_PROD_ASSY_MAP Valid YN 개선
 * 2023/08/07   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - 활성화 코드) SCP_MST_CELL_PROD_ASSY_MAP 매핑 개선
 * 2023/11/08   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - ITEM_TYPE_CODE
 * 2023/11/23   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - GPLM CELL MODEL Match 개선
 -----------------------------------------------------------------------------------------------------
 EXEC SCP0085_GET_ENDING_INVENTORY
   @p_yyyymm='202310'
 , @p_division_id=''
 , @p_plant_id=''
 , @p_item_type=''
 , @p_item_id=''
 , @debug_mode='F'

--SELECT * FROM SCP_ANL_MONTH_END_STOCK_R WHERE YYYYMM = '202310' and division_id = '40' and plant_id = 'A010'
 */

CREATE PROCEDURE [dbo].[SCP0085_GET_ENDING_INVENTORY_NEW]
	@p_yyyymm				NVARCHAR(6),
	@p_division_id			NVARCHAR(100),
	@p_plant_id				NVARCHAR(500),
	@p_item_type			NVARCHAR(500),
	@p_item_id				NVARCHAR(MAX),
	@debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	IF @p_division_id = '81,40,82,81_GM' OR @p_division_id = '81,40,82'
	BEGIN
		SET @p_division_id = '';
	END

	IF OBJECT_ID('tempdb..#TMP_ITEM_CLASS') IS NOT NULL
		DROP TABLE #TMP_ITEM_CLASS;

	IF OBJECT_ID('tempdb..#TMP_LAST') IS NOT NULL
		DROP TABLE #TMP_LAST;

	IF OBJECT_ID('tempdb..#TMP_SCP_MST_CELL_PROD_ASSY_MAP') IS NOT NULL
		DROP TABLE #TMP_SCP_MST_CELL_PROD_ASSY_MAP;

	IF OBJECT_ID('tempdb..#W_CELL_CF') IS NOT NULL
		DROP TABLE #W_CELL_CF;

	IF OBJECT_ID('tempdb..#W_CELL_CF_BOM') IS NOT NULL
		DROP TABLE #W_CELL_CF_BOM;

	IF OBJECT_ID('tempdb..#W_SITE_LIST') IS NOT NULL
		DROP TABLE #W_SITE_LIST;

	IF OBJECT_ID('tempdb..#W_ITEM_EE') IS NOT NULL
		DROP TABLE #W_ITEM_EE;

	IF OBJECT_ID('tempdb..#W_SI') IS NOT NULL
		DROP TABLE #W_SI;

	IF OBJECT_ID('tempdb..#W_CELL_ASSY_SI') IS NOT NULL
		DROP TABLE #W_CELL_ASSY_SI;


	--#####################################################################################
	-- #TMP_ITEM_CLASS
	--#####################################################################################
		select DISTINCT
				ITEM_ID
				, ITEM_CLASS
				, ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID ORDER BY A.ITEM_CLASS DESC) AS RankNo
		INTO #TMP_ITEM_CLASS
		from SCM_MST_ITEM_SN A


			--#####################################################################################
			-- #TMP_SCP_MST_CELL_PROD_ASSY_MAP
			--#####################################################################################
			IF OBJECT_ID('tempdb..#TMP_SCP_MST_CELL_PROD_ASSY_MAP') IS NOT NULL
				DROP TABLE #TMP_SCP_MST_CELL_PROD_ASSY_MAP;

			SELECT DIVISION_ID
				, PLANT_ID
				, ITEM_ID_ASSY
				, ITEM_ID_PROD
				, MAX(CELL_TYPE) AS CELL_TYPE
			INTO #TMP_SCP_MST_CELL_PROD_ASSY_MAP
			FROM SCP_MST_CELL_PROD_ASSY_MAP
			WHERE VALID_YN = 'Y'
			GROUP BY DIVISION_ID, PLANT_ID, ITEM_ID_ASSY, ITEM_ID_PROD


			--#####################################################################################
			-- W_CELL_CF 20220428 GPLM IF 환산계수
			--#####################################################################################
			IF OBJECT_ID('tempdb..#W_CELL_CF') IS NOT NULL
				DROP TABLE #W_CELL_CF;

			 SELECT TARGET_CELL
				, ITEM_ID
				, CELL_CF -- 20221208 Null 사용
			  --, ISNULL(CELL_CF, '1.000000') AS CELL_CF -- 20221028 Default 값은 1
				, ROW_NUMBER() OVER (PARTITION BY ITEM_ID ORDER BY BOM_MODIFY_DATE DESC, ATTRIBUTE5 DESC) AS RankNo
			 INTO #W_CELL_CF
			 FROM SCP_MST_ITEM_CELL_CF WITH(NOLOCK)



			--#####################################################################################
			-- W_CELL_CF_BOM
			--#####################################################################################
			IF OBJECT_ID('tempdb..#W_CELL_CF_BOM') IS NOT NULL
				DROP TABLE #W_CELL_CF_BOM;

			  SELECT CT.COMPANY_ID
					,MAX(CT.DIVISION_ID) AS DIVISION_ID
					,CT.SITE_ID
					,CT.MODEL_ID
					,CT.PLANT_ID
					,CT.CHILD_ITEM_ID
					,max(ITEM_TYPE) as ITEM_TYPE
					,SUM(CT.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
					,MAX(CT.CHILD_QTY)   AS CHILD_QTY
					,round(convert(float,1)/SUM(CT.ACCUMULATED_CHILD_QTY),6) AS CELL_CF_BOM
				INTO #W_CELL_CF_BOM
				FROM  (
				  SELECT CT.COMPANY_ID
						,CT.DIVISION_ID
						,CT.SITE_ID
						,CT.MODEL_ID
						,CT.PLANT_ID
						,CT.CHILD_ITEM_ID
						,SI.ITEM_TYPE
						,CT.ACCUMULATED_CHILD_QTY
						,CT.CHILD_QTY
					FROM SCM_MODEL_COMP_TEMP_SN CT WITH(NOLOCK)
						,SCM_ITEM_M_SN  SI WITH(NOLOCK)
						,SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
						,SCP_MST_ITEM_CELL_CF CELL_CF WITH(NOLOCK)
					WHERE  CT.CHILD_COMPANY_ID  = SI.COMPANY_ID
					AND    CT.CHILD_DIVISION_ID = SI.DIVISION_ID
					AND    CT.CHILD_SITE_ID     = SI.SITE_ID
					AND    CT.CHILD_ITEM_ID     = SI.ITEM_ID
					AND    SI.ITEM_CLASS        = IC.CLASS_ID
					AND    IC.USE_FLAG          = 'Y'
					AND    ISNULL(SI.ITEM_TYPE,'H') IN ('P','Q','H')
					AND    CT.ALT_PRIORITY = 'Y'
					--AND    CT.child_ITEM_ID = 'ANPCA1747B'
					--and    CT.model_id = 'ACEN4065I-A1R001'
					--and    CT.plant_id = 'G451'
					AND CELL_CF.CELL_CF is NULL
					AND CELL_CF.item_id  =  CT.child_ITEM_ID
					AND CELL_CF.TARGET_CELL  =  CT.model_id

				)  CT
				GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID



			--#####################################################################################
			-- W_SITE_LIST
			--#####################################################################################
			IF OBJECT_ID('tempdb..#W_SITE_LIST') IS NOT NULL
				DROP TABLE #W_SITE_LIST;

			SELECT PLANT_ID
				  ,PLANT_NAME
			INTO #W_SITE_LIST
			FROM (
					SELECT DISTINCT PLANT_ID, PLANT_NAME
					FROM SCM_PLANT_M_SN WITH(NOLOCK)
					UNION
					select SEGMENT1 as PLANT_ID, SEGMENT2 as PLANT_NAME
					from  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL]
					where LOOKUP_TYPE   = 'INVENTORY_SITE'
						AND VALID_YN = 'Y'
				) X1


			--#####################################################################################
			-- W_ITEM_EE
			--#####################################################################################
			IF OBJECT_ID('tempdb..#W_ITEM_EE') IS NOT NULL
				DROP TABLE #W_ITEM_EE;

			 select flow_id
				  , item_id
				  , company_Id
				  , division_id
				  , site_id
				  , spec
			 INTO #W_ITEM_EE
			 from SCM_MST_ITEM_SN
			 where DIVISION_ID = '81'
			 and  (
					flow_id LIKE '%A7000%'
				or  flow_id LIKE '%A8000%'
				or  flow_id LIKE '%A5000%'
				or  flow_id LIKE '%E2000%'
				)


			--#####################################################################################
			-- W_SI
			--#####################################################################################
			IF OBJECT_ID('tempdb..#W_SI') IS NOT NULL
				DROP TABLE #W_SI;


			SELECT  T.ITEM_ID
				, T.ITEM_TYPE
				, T.PROCESS_GROUP
				, T.PROCESS_DETAIL
				, T.LEVEL_1_NAME
				, T.LEVEL_2_NAME
				, T.LEVEL_3_NAME
				, T.LEVEL_4_NAME
			INTO #W_SI
			from
			(
				SELECT DISTINCT A.ITEM_ID
					, B.ITEM_TYPE
					, B.PROCESS_GROUP
					, B.PROCESS_DETAIL
					, B.LEVEL_1_NAME
					, B.LEVEL_2_NAME
					, B.LEVEL_3_NAME
					, B.LEVEL_4_NAME
					, ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID ORDER BY A.ITEM_CLASS DESC) AS RankNo
				FROM #TMP_ITEM_CLASS A WITH(NOLOCK)
/*
					, SCM_MST_ITEM_CLASS_M B WITH(NOLOCK)
				WHERE A.ITEM_CLASS = B.CLASS_ID
*/
					INNER JOIN SCM_MST_ITEM_CLASS_M B WITH(NOLOCK)
					on A.ITEM_CLASS = B.CLASS_ID
			) T
			where RankNo = 1



			--#####################################################################################
			-- W_CELL_ASSY_SI
			--#####################################################################################
			IF OBJECT_ID('tempdb..#W_CELL_ASSY_SI') IS NOT NULL
				DROP TABLE #W_CELL_ASSY_SI;

			SELECT  MAP.DIVISION_ID AS DIVISION
			      , MAP.PLANT_ID AS PLANT
			      , MAP.ITEM_ID_PROD
			      , MAP.ITEM_ID_ASSY
				  , MAP.CELL_TYPE
				  , SI.PROCESS_GROUP
				  , SI.PROCESS_DETAIL
				  , RANK() OVER(PARTITION BY DIVISION_ID, PLANT_ID, ITEM_ID_ASSY ORDER BY ITEM_ID_PROD desc) AS RN
				INTO #W_CELL_ASSY_SI
				FROM SCP_MST_CELL_PROD_ASSY_MAP MAP
					LEFT JOIN #W_SI SI ON SI.ITEM_ID = ITEM_ID_PROD
			   WHERE DIVISION_ID IN ('40', '82')
			   --and VALID_YN = 'Y'



		--#####################################################################################
		-- #TMP_LAST
		--#####################################################################################

		SELECT *
		INTO #TMP_LAST
		FROM
		(
		SELECT
		           YYYYMM
				 , LIST.DIVISION_ID
				 , LIST.COMPANY_ID
				 , PLANT_ID
				 , PLANT_NAME
				 , LIST.ITEM_ID
				 , ITEM_DESCRIPTION
				 , ITEM_UOM
				 , STORAGE_LOCATION
				 , STORAGE_DESC
				 , UNRESTRICTED_QTY
				 , BLOCKED_STOCK
				 , IN_TRANSIT
				 , QUANTITY
				 , AMOUNT
				 , CURRENCY
				 , AMOUNT_KRW
				 , UNIT_PRICE
				 , UNIT_PRICE_KRW
				 ------------------------------------------------------------------------------------------------------------------------------------------------
				 , QUANTITY   		AS QUANTITY_XLS
				 , AMOUNT			AS AMOUNT_XLS
				 , CURRENCY			AS CURRENCY_XLS
				 , AMOUNT_KRW		AS AMOUNT_KRW_XLS
				 , UNIT_PRICE		AS UNIT_PRICE_XLS
				 , UNIT_PRICE_KRW	AS UNIT_PRICE_KRW_XLS

				 , VALUATION_CLASS
				 , PURCHASE_PO
				 , SUPPLIER_CODE
				 , SUPPLIER_NAME
				 , ITEM_TYPE
				 , CASE WHEN ITEM_TYPE = N'기타'	THEN 'E'
						WHEN ITEM_TYPE = N'반제품'	THEN 'H'
						WHEN ITEM_TYPE = N'상품'	THEN 'P'
						WHEN ITEM_TYPE = N'원부자재'THEN 'Q'
						WHEN ITEM_TYPE = N'저장품'	THEN 'A'
						WHEN ITEM_TYPE = N'제품'	THEN 'R'
						ELSE '-'
				        END AS ITEM_TYPE_CODE	-- 원반제구분
				 ------------------------------------------------------------------------------------------------------------------------------------------------
				 , CASE
				   WHEN CA.CELL_TYPE LIKE 'CA%'
				   THEN (CASE WHEN CA.ITEM_ID_PROD IS NOT NULL AND VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품' ELSE CA.PROCESS_GROUP  END)
				   ELSE LIST.PROCESS_GROUP
				   END AS PROCESS_GROUP

				 , CASE
				   WHEN CA.CELL_TYPE LIKE 'CA%'
				   THEN (CASE WHEN CA.ITEM_ID_PROD IS NOT NULL AND VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품' ELSE CA.PROCESS_DETAIL END)
				   ELSE LIST.MATERIAL_GROUP
				   END AS MATERIAL_GROUP
			     , LIST.PROCESS_GROUP AS PROCESS_GROUP_ORG	-- 자재구분
			     , LIST.MATERIAL_GROUP AS MATERIAL_GROUP_ORG	-- 자재구분상세
				 ------------------------------------------------------------------------------------------------------------------------------------------------
				, CA.CELL_TYPE
				, CA.ITEM_ID_PROD AS CP_MODEL
				, (CASE WHEN CA.ITEM_ID_PROD IS NOT NULL AND VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품' ELSE CA.PROCESS_GROUP  END) AS CP_PROCESS_GROUP	-- 자재구분
			    , (CASE WHEN CA.ITEM_ID_PROD IS NOT NULL AND VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품' ELSE CA.PROCESS_DETAIL END) AS CP_MATERIAL_GROUP	-- 자재구분상세
				 ------------------------------------------------------------------------------------------------------------------------------------------------
				 --, GPLM_CELL_MODEL
                 , FORECAST_INFO_CELL_MODEL
				 , ITEM_ID_BASE
				 , ITEM_ID_EX
				 , MDM_PROJECT_NICK_NAME
				 , EXTRA_SPEC
				 , ITEM_TYPE_DETAIL
				 , ITEM_TYPE_GR
				 , LEVEL_1_NAME
				 , LEVEL_2_NAME
				 , LEVEL_3_NAME
				 , LEVEL_4_NAME
				 ------------------------------------------------------------------------------------------------------------------------------------------------
				 , CELL_GROUP AS CELL_GROUP_ASIS
				 , PACK_GROUP AS PACK_GROUP_ASIS
				 , EE.FLOW_ID
				 , CASE
				   WHEN ITEM_TYPE = N'제품' and LIST.process_group = N'모듈/팩' and MATERIAL_GROUP = 'Module Assembly' then FIT.GROUP_CODE1
				   WHEN CELL_GROUP IS NULL AND ITEM_TYPE = N'반제품' and EE.FLOW_ID is not null then FIT.GROUP_CODE1
				   else CELL_GROUP
				   end AS CELL_GROUP
				 , CASE
				   WHEN ITEM_TYPE = N'제품' and LIST.process_group = N'모듈/팩' and MATERIAL_GROUP = 'Module Assembly' then FIT.GROUP_CODE2
				   WHEN CELL_GROUP IS NULL AND ITEM_TYPE = N'반제품' and EE.FLOW_ID is not null then  FIT.GROUP_CODE2
				   else PACK_GROUP
				   end AS PACK_GROUP
				 , ( CASE
					 WHEN ITEM_TYPE_DETAIL = 'TYPE_CELL'	THEN '1.000000'	  -- 20220503 CELL 인 경우 환산계수 = 1
					 WHEN ITEM_TYPE_DETAIL = 'TYPE_A'		THEN (SELECT ISNULL(MAX(CELL_CF), '1.000000')  FROM #W_CELL_CF WHERE left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 2)	= ITEM_ID AND RankNo = 1)
					 WHEN ITEM_TYPE_DETAIL = 'TYPE_G'		THEN (SELECT ISNULL(MAX(CELL_CF), '1.000000')  FROM #W_CELL_CF WHERE left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 3)	= ITEM_ID AND RankNo = 1)
					 WHEN ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' THEN ISNULL(CELL_CF, CELL_CF_BOM)  -- 20221208 환산계수 BOM
					 ELSE CELL_CF -- 20221208 Default 1 -> CELL_CF (null 이면 그대로 표시)
					 END
				   ) AS CELL_CONVER_FACTOR
				 ------------------------------------------------------------------------------------------------------------------------------------------------
				 , ( CASE
					 WHEN ITEM_TYPE_DETAIL = 'TYPE_CELL'	THEN '1.000000'	  -- 20220503 CELL 인 경우 환산계수 = 1
					 WHEN ITEM_TYPE_DETAIL = 'TYPE_A'		THEN (SELECT ISNULL(MAX(CELL_CF), '1.000000')  FROM #W_CELL_CF WHERE left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 2)	= ITEM_ID AND RankNo = 1)
					 WHEN ITEM_TYPE_DETAIL = 'TYPE_G'		THEN (SELECT ISNULL(MAX(CELL_CF), '1.000000')  FROM #W_CELL_CF WHERE left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 3)	= ITEM_ID AND RankNo = 1)
					 WHEN ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' THEN ISNULL(CELL_CF, CELL_CF_BOM)   -- 20221208 환산계수 BOM
					 ELSE CELL_CF -- 20221208 Default 1 -> CELL_CF (null 이면 그대로 표시)
					 END
				   ) AS CELL_CONVER_FACTOR_XLS
				 ------------------------------------------------------------------------------------------------------------------------------------------------
				 , (
					CASE
					WHEN ITEM_TYPE_DETAIL = 'TYPE_CELL'		THEN ISNULL(QUANTITY,0)		-- 20220503 CELL 인 경우 환산계수 = 1
					WHEN ITEM_TYPE_DETAIL = 'TYPE_A'		THEN (SELECT  ISNULL(MAX(CELL_CF) ,1) * ISNULL(QUANTITY,0) FROM #W_CELL_CF WHERE left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 2)	= ITEM_ID AND RankNo = 1) --20221012
					WHEN ITEM_TYPE_DETAIL = 'TYPE_G'		THEN (SELECT  ISNULL(MAX(CELL_CF) ,1) * ISNULL(QUANTITY,0) FROM #W_CELL_CF WHERE left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 3)	= ITEM_ID AND RankNo = 1) --20221012
					WHEN ITEM_TYPE_DETAIL = 'TYPE_PRODUCT'	AND CELL_CF IS NOT NULL		THEN CONVERT(float, CELL_CF)  * ISNULL(QUANTITY,0)		-- 20220428 GPLM IF 환산계수 (CELL_CF 자동으로 반올림해서 계산하고 있어 변환)
					WHEN ITEM_TYPE_DETAIL = 'TYPE_PRODUCT'	AND CELL_CF_BOM IS NOT NULL THEN CELL_CF_BOM  * ISNULL(QUANTITY,0)  -- 20220428 GPLM IF 환산계수
					WHEN ITEM_TYPE_DETAIL = 'TYPE_PRODUCT'	THEN ISNULL(QUANTITY,0)												-- 20220428 GPLM IF 환산계수
					ELSE ISNULL(QUANTITY,0)
					END
				   ) AS CELL_CONVER_QUANTITY	-- 셀 환산수량(GPLM 셀 환산계수 * 재고수량)
				 ------------------------------------------------------------------------------------------------------------------------------------------------
				 , (
					CASE
					WHEN ITEM_TYPE_DETAIL = 'TYPE_CELL'		THEN ISNULL(QUANTITY,0)		-- 20220503 CELL 인 경우 환산계수 = 1
					WHEN ITEM_TYPE_DETAIL = 'TYPE_A'		THEN (SELECT ISNULL(MAX(CELL_CF) ,1) * ISNULL(QUANTITY,0) FROM #W_CELL_CF WHERE left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 2)	= ITEM_ID AND RankNo = 1) --20221012
					WHEN ITEM_TYPE_DETAIL = 'TYPE_G'		THEN (SELECT ISNULL(MAX(CELL_CF) ,1) * ISNULL(QUANTITY,0) FROM #W_CELL_CF WHERE left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 3)	= ITEM_ID AND RankNo = 1) --20221012
					WHEN ITEM_TYPE_DETAIL = 'TYPE_PRODUCT'	AND CELL_CF IS NOT NULL		THEN CONVERT(float, CELL_CF)  * ISNULL(QUANTITY,0)		-- 20220428 GPLM IF 환산계수 (CELL_CF 자동으로 반올림해서 계산하고 있어 변환)
					WHEN ITEM_TYPE_DETAIL = 'TYPE_PRODUCT'	AND CELL_CF_BOM IS NOT NULL THEN CELL_CF_BOM  * ISNULL(QUANTITY,0)  -- 20220428 GPLM IF 환산계수
					WHEN ITEM_TYPE_DETAIL = 'TYPE_PRODUCT'	THEN ISNULL(QUANTITY,0)												-- 20220428 GPLM IF 환산계수
					ELSE ISNULL(QUANTITY,0)
					END
				   ) AS CELL_CONVER_QUANTITY_XLS	-- 셀 환산수량(GPLM 셀 환산계수 * 재고수량)
				   ------------------------------------------------------------------------------------------------------------------------------------------------
				 , ( CASE
					 WHEN ITEM_TYPE_GR = 'TYPE_GR_A'		THEN (select MAX(GROUP_CODE3) from SCP_MST_FINAL_ITEM  where OPERATION_GROUP IN ('A', 'P') and DIVISION_ID = '40' and item_id = left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 2))
					 WHEN ITEM_TYPE_GR = 'TYPE_GR_G'		THEN (select MAX(GROUP_CODE3) from SCP_MST_FINAL_ITEM  where OPERATION_GROUP IN ('A', 'P') and DIVISION_ID = '40' and item_id = left(LIST.ITEM_ID,len(LIST.ITEM_ID) - 3))
					 WHEN ITEM_TYPE_GR = 'TYPE_GR_PRODUCT'	THEN (select MAX(GROUP_CODE3) from SCP_MST_FINAL_ITEM  where OPERATION_GROUP IN ('A', 'P') and DIVISION_ID = '40' and item_id = LIST.ITEM_ID) -- 20220428 Gro
					 ELSE NULL
					 END
				   ) AS CELL_TYPE_GR -- 20221004 추가
				  ------------------------------------------------------------------------------------------------------------------------------------------------
				, CASE
				  WHEN CELL_CF is null AND CELL_CF_BOM > 0 THEN 'Y'
				  ELSE NULL
				   END AS USE_CELL_CF_BOM
				, CELL_CF
				, CELL_CF_BOM
				,ISNULL(CELL_CF, ISNULL(CELL_CF_BOM,1)) AS T1
				,ISNULL(QUANTITY,0) AS T2
				,ISNULL(CELL_CF, ISNULL(CELL_CF_BOM,1)) * ISNULL(QUANTITY,0) AS T3
				,ISNULL(CELL_CF_BOM,1) * ISNULL(QUANTITY,0) AS T4
				 --------------------------------------------------------
				, M1_QUANTITY
				, M1_AMOUNT
				, M1_AMOUNT_KRW
				, M2_QUANTITY
				, M3_QUANTITY
				, M4_QUANTITY
				, M5_QUANTITY
				, M6_QUANTITY
				, M7_QUANTITY
				, M8_QUANTITY
				, M9_QUANTITY
				, M10_QUANTITY
				, M11_QUANTITY
				, M12_QUANTITY
				, M13_QUANTITY
				, M2_AMOUNT
				, M3_AMOUNT
				, M4_AMOUNT
				, M5_AMOUNT
				, M6_AMOUNT
				, M7_AMOUNT
				, M8_AMOUNT
				, M9_AMOUNT
				, M10_AMOUNT
				, M11_AMOUNT
				, M12_AMOUNT
				, M13_AMOUNT
				, M2_AMOUNT_KRW
				, M3_AMOUNT_KRW
				, M4_AMOUNT_KRW
				, M5_AMOUNT_KRW
				, M6_AMOUNT_KRW
				, M7_AMOUNT_KRW
				, M8_AMOUNT_KRW
				, M9_AMOUNT_KRW
				, M10_AMOUNT_KRW
				, M11_AMOUNT_KRW
				, M12_AMOUNT_KRW
				, M13_AMOUNT_KRW
				, CURRENCY_KRW
				, TARGET_CELL
				, EX_TO_BAMT
		FROM
		(
			SELECT
				   YYYYMM		--보고시점
				 , DIVISION_ID
				 , COMPANY_ID
				 , PLANT_ID
				 , PLANT_NAME
				 , DATA.ITEM_ID
				 , ITEM_DESCRIPTION
				 , ITEM_UOM
				 , STORAGE_LOCATION
				 , STORAGE_DESC
				 , UNRESTRICTED_QTY  -- 20220811 추가 : 가용재고
				 , BLOCKED_STOCK	 -- 20220811 추가 : 보류재고
				 , IN_TRANSIT		 -- 20220811 추가 : iN-tRANSIT
				 , QUANTITY
				 , AMOUNT
				 , CURRENCY
				 , AMOUNT_KRW
				 , UNIT_PRICE
				 , UNIT_PRICE_KRW
				 , VALUATION_CLASS
				 , PURCHASE_PO
				 , SUPPLIER_CODE
				 , SUPPLIER_NAME
				 , ITEM_TYPE		-- 원반제구분
				 , PROCESS_GROUP	-- 자재구분
				 , MATERIAL_GROUP	-- 자재구분상세
				 --, (
					--CASE
					--WHEN PROCESS_GROUP = 'CELL' THEN DATA.ITEM_ID
					--ELSE GPLM_CELL_MODEL
					--END
				 --  ) AS GPLM_CELL_MODEL	-- 20220613 요청사항
				 , MDM_PROJECT_NICK_NAME
				 , EXTRA_SPEC
				 , ( CASE
					 WHEN PROCESS_GROUP = 'CELL' THEN 'TYPE_CELL'
					 WHEN ITEM_TYPE IN (N'반제품',N'제품')  AND Right(DATA.ITEM_ID,2) IN ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')  AND WCF.CELL_CF IS NULL THEN 'TYPE_A'
					 WHEN ITEM_TYPE IN (N'반제품',N'제품')  AND Right(DATA.ITEM_ID,3) IN ('-GG','-GK')  AND WCF.CELL_CF IS NULL THEN 'TYPE_G'
					 WHEN ITEM_TYPE IN (N'반제품',N'제품') THEN 'TYPE_PRODUCT'
					 ELSE 'TYPE'
					 END
				   ) AS ITEM_TYPE_DETAIL
				 , ( CASE
					 WHEN DIVISION_ID = '40'AND ITEM_TYPE IN (N'제품') AND Right(DATA.ITEM_ID,2) IN  ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')  AND WCF.CELL_CF IS NULL THEN 'TYPE_GR_A'
					 WHEN DIVISION_ID = '40'AND ITEM_TYPE IN (N'제품') AND Right(DATA.ITEM_ID,3) IN  ('-GG','-GK')  AND WCF.CELL_CF IS NULL THEN 'TYPE_GR_G'
				     WHEN DIVISION_ID = '40'AND ITEM_TYPE IN (N'제품') THEN 'TYPE_GR_PRODUCT'
					 ELSE 'TYPE_GR'
					 END
				   ) AS ITEM_TYPE_GR

				 , CASE WHEN Right(DATA.ITEM_ID,2) IN ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')
				        THEN  left(DATA.ITEM_ID , len(DATA.ITEM_ID) - 3)
						WHEN Right(DATA.ITEM_ID,3) IN ('-GG','-GK')
						THEN left(DATA.ITEM_ID , len(DATA.ITEM_ID) - 4)
						END AS ITEM_ID_BASE
				 , CASE WHEN Right(DATA.ITEM_ID,2) IN ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')
				        THEN Right(DATA.ITEM_ID,2)
						WHEN Right(DATA.ITEM_ID,3) IN ('-GG','-GK')
						THEN Right(DATA.ITEM_ID,3)
						END AS ITEM_ID_EX

				 , LEVEL_1_NAME
				 , LEVEL_2_NAME
				 , LEVEL_3_NAME
				 , LEVEL_4_NAME
				 , CELL_GROUP
				 , PACK_GROUP
				 , WCF.TARGET_CELL
				 , WCF.CELL_CF
				 , (SELECT CELL_CF_BOM FROM #W_CELL_CF_BOM WHERE CHILD_ITEM_ID = DATA.ITEM_ID and plant_id = DATA.PLANT_ID and MODEL_ID = WCF.TARGET_CELL) AS CELL_CF_BOM
				 --------------------------------------------------------
				, M1_QUANTITY
				, M1_AMOUNT
				, M1_AMOUNT_KRW
				, M2_QUANTITY
				, M3_QUANTITY
				, M4_QUANTITY
				, M5_QUANTITY
				, M6_QUANTITY
				, M7_QUANTITY
				, M8_QUANTITY
				, M9_QUANTITY
				, M10_QUANTITY
				, M11_QUANTITY
				, M12_QUANTITY
				, M13_QUANTITY
				, M2_AMOUNT
				, M3_AMOUNT
				, M4_AMOUNT
				, M5_AMOUNT
				, M6_AMOUNT
				, M7_AMOUNT
				, M8_AMOUNT
				, M9_AMOUNT
				, M10_AMOUNT
				, M11_AMOUNT
				, M12_AMOUNT
				, M13_AMOUNT
				, M2_AMOUNT_KRW
				, M3_AMOUNT_KRW
				, M4_AMOUNT_KRW
				, M5_AMOUNT_KRW
				, M6_AMOUNT_KRW
				, M7_AMOUNT_KRW
				, M8_AMOUNT_KRW
				, M9_AMOUNT_KRW
				, M10_AMOUNT_KRW
				, M11_AMOUNT_KRW
				, M12_AMOUNT_KRW
				, M13_AMOUNT_KRW
				, CURRENCY_KRW
				, EX_TO_BAMT
				,FORECAST_INFO_CELL_MODEL
			FROM
			(
				SELECT ('‘' + SUBSTRING(A.YYYYMM, 3, 2) + '.' + RIGHT(A.YYYYMM, 2)) AS YYYYMM		--보고시점
					 , A.YYYYMM AS YYYYMM_DATA
					 , A.DIVISION_ID
					 , A.COMPANY_ID
					 , A.PLANT_ID
					 --, P.PLANT_NAME--
					 , ( SELECT MAX(PLANT_NAME)
						  FROM #W_SITE_LIST
						 WHERE PLANT_ID	= A.PLANT_ID
						 ) AS PLANT_NAME
					 , A.ITEM_ID AS ITEM_ID
					 , A.ITEM_DESCRIPTION
					 , A.ITEM_UOM
					 , A.STORAGE_LOCATION
					 , A.STORAGE_DESC
					 , A.QUANTITY
					 , A.AMOUNT
					 , A.CURRENCY
					 , A.AMOUNT_KRW
					 , A.UNIT_PRICE
					 , A.UNIT_PRICE_KRW
					 , A.VALUATION_CLASS
					 , A.PURCHASE_PO
					 , A.SUPPLIER_CODE
					 , A.SUPPLIER_NAME
					 , (
						CASE
						WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
						WHEN A.VALUATION_CLASS IN ('3100','3109') AND S1.ITEM_TYPE = N'원부자재'  THEN N'상품'
						ELSE S1.ITEM_TYPE
						END
					   ) AS ITEM_TYPE		-- 원반제구분
					 , (CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품' ELSE S1.PROCESS_GROUP	END) AS PROCESS_GROUP	-- 자재구분
					 , (CASE WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품' ELSE S1.PROCESS_DETAIL	END) AS MATERIAL_GROUP	-- 자재구분상세
					 --, (CASE WHEN S1.ITEM_TYPE = N'반제품' AND MI.FORECAST_INFO_CELL_MODEL IS NULL THEN
						--																				(SELECT TOP 1 X2.APPLIED_MODEL
						--																				   FROM SCM_MST_ITEM_SN X2 WITH(NOLOCK)
						--																				  WHERE X2.ITEM_ID = A.ITEM_ID
						--																					AND X2.APPLIED_MODEL IS NOT NULL
						--																				   )
						--	 ELSE MI.FORECAST_INFO_CELL_MODEL
						--END)							AS GPLM_CELL_MODEL


					 , MI.FORECAST_INFO_CELL_MODEL
					 , MI.NICK_NAME						AS MDM_PROJECT_NICK_NAME
					 , MI.SCP_EXTRA_SPEC				AS EXTRA_SPEC


					 --, MI.FORECAST_INFO_CELL_PACK_COUNT	AS CELL_CONVER_FACTOR	--GPLM셀환산계수
					 --, (ISNULL(MI.FORECAST_INFO_CELL_PACK_COUNT,0) * ISNULL(A.QUANTITY,0) )		AS CELL_CONVER_QUANTITY	-- 셀 환산수량(GPLM 셀 환산계수 * 재고수량)
					 , S1.LEVEL_1_NAME
					 , S1.LEVEL_2_NAME
					 , S1.LEVEL_3_NAME
					 , S1.LEVEL_4_NAME
					 , FI.GROUP_CODE1			AS CELL_GROUP
					 , FI.GROUP_CODE2			AS PACK_GROUP

					 , A.UNRESTRICTED_QTY  -- 20220811 추가 : 가용재고
					 , A.BLOCKED_STOCK	 -- 20220811 추가 : 보류재고
					 , A.IN_TRANSIT		 -- 20220811 추가 : iN-tRANSIT
					 --------------------------------------------------------
					, A.M1_QUANTITY
					, A.M1_AMOUNT
					, A.M1_AMOUNT_KRW
					, A.M2_QUANTITY
					, A.M3_QUANTITY
					, A.M4_QUANTITY
					, A.M5_QUANTITY
					, A.M6_QUANTITY
					, A.M7_QUANTITY
					, A.M8_QUANTITY
					, A.M9_QUANTITY
					, A.M10_QUANTITY
					, A.M11_QUANTITY
					, A.M12_QUANTITY
					, A.M13_QUANTITY
					, A.M2_AMOUNT
					, A.M3_AMOUNT
					, A.M4_AMOUNT
					, A.M5_AMOUNT
					, A.M6_AMOUNT
					, A.M7_AMOUNT
					, A.M8_AMOUNT
					, A.M9_AMOUNT
					, A.M10_AMOUNT
					, A.M11_AMOUNT
					, A.M12_AMOUNT
					, A.M13_AMOUNT
					, A.M2_AMOUNT_KRW
					, A.M3_AMOUNT_KRW
					, A.M4_AMOUNT_KRW
					, A.M5_AMOUNT_KRW
					, A.M6_AMOUNT_KRW
					, A.M7_AMOUNT_KRW
					, A.M8_AMOUNT_KRW
					, A.M9_AMOUNT_KRW
					, A.M10_AMOUNT_KRW
					, A.M11_AMOUNT_KRW
					, A.M12_AMOUNT_KRW
					, A.M13_AMOUNT_KRW
					, A.CURRENCY_KRW
					, IIF(A.CURRENCY = 'KRW', '1', A.ATTRIBUTE9) AS EX_TO_BAMT
				  FROM SCP_ANL_MONTH_END_STOCK_R A WITH(NOLOCK)
				----------------------------------------------------------
				  LEFT JOIN #W_SI S1
					   ON A.ITEM_ID = S1.ITEM_ID
				----------------------------------------------------------
				  LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					ON A.DIVISION_ID	= FI.DIVISION_ID
				   AND A.ITEM_ID		= FI.ITEM_ID
				-----------------------------------------------------------------
				 -- LEFT JOIN SCM_PLANT_M_SN P WITH(NOLOCK)
					--ON A.DIVISION_ID	= P.DIVISION_ID
				 --  AND A.PLANT_ID		= P.PLANT_ID
				-----------------------------------------------------------------
				 LEFT JOIN SCM_MST_ITEM_SN MI WITH(NOLOCK)
			  		  ON A.COMPANY_ID		= MI.COMPANY_ID
					 AND A.DIVISION_ID	= MI.DIVISION_ID
				   --AND P.SITE_ID		= MI.SITE_ID
					 AND A.ITEM_ID		= MI.ITEM_ID
				-----------------------------------------------------------------
				 -- LEFT JOIN SCM_MST_ITEM_CLASS_M IC WITH(NOLOCK)
					--ON MI.ITEM_CLASS = IC.CLASS_ID
				WHERE 1=1
				AND A.YYYYMM = @p_yyyymm
				AND ( ISNULL(@p_division_id, '')	= '' OR A.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
				AND ( ISNULL(@p_plant_id, '')		= '' OR A.PLANT_ID		IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
				AND ( ISNULL(@p_item_id, '')		= '' OR A.ITEM_ID		IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )

			) AS DATA
			----------------------------------------------------------
			LEFT JOIN #W_CELL_CF WCF WITH(NOLOCK)
			  ON DATA.ITEM_ID		= WCF.ITEM_ID
			 AND WCF.RankNo = 1

		) LIST
		 LEFT JOIN (
		           SELECT DIVISION_ID, ITEM_ID, group_code1, group_code2
				     from SCP_MST_FINAL_ITEM WITH(NOLOCK)
				    WHERE group_code1 IS NOT NULL
				  ) FIT
				ON LIST.DIVISION_ID	= FIT.DIVISION_ID
			   AND LIST.TARGET_CELL	= FIT.ITEM_ID
		 LEFT JOIN #W_ITEM_EE EE
				ON LIST.DIVISION_ID	= EE.DIVISION_ID
			   AND LIST.COMPANY_ID	= EE.COMPANY_ID
			   AND LIST.ITEM_ID	= EE.ITEM_ID
		 LEFT JOIN #W_CELL_ASSY_SI CA
				ON LIST.DIVISION_ID	= CA.DIVISION
			   AND LIST.PLANT_ID	= CA.PLANT
			   AND LIST.ITEM_ID	    = CA.ITEM_ID_ASSY
			   AND CA.RN = 1
		) LIST
		WHERE 1 = 1
		AND ( ISNULL(@p_item_type, '')		= '' OR ITEM_TYPE_CODE		IN (SELECT token FROM dbo.String_Split(@p_item_type,',')) )
		;

-- 2023.12.05 천승호 삭제
--CREATE INDEX CDX_TMP_LAST ON #TMP_LAST (DIVISION_ID, PLANT_ID, ITEM_ID)

		SELECT *
				, (
				-- 20231123 요청사항
				CASE
						WHEN PROCESS_GROUP = 'Cell' AND ITEM_TYPE  = N'제품' THEN ITEM_ID
						WHEN PROCESS_GROUP = 'Cell' AND ITEM_TYPE != N'제품' AND ( ITEM_TYPE_DETAIL = 'TYPE_A' OR ITEM_TYPE_DETAIL = 'TYPE_G')  THEN (
																					SELECT ISNULL( CONCAT(MAX(ITEM_ID_PROD) , ITEM_ID_EX), substring(ITEM_DESCRIPTION, 1, charindex(' ', ITEM_DESCRIPTION) -1) )
																						FROM #TMP_SCP_MST_CELL_PROD_ASSY_MAP
																					WHERE ITEM_ID_ASSY   = LIST.ITEM_ID_BASE
																						AND PLANT_iD     = LIST.PLANT_ID
																						AND DIVISION_ID  = LIST.DIVISION_ID
						                                                        )

						WHEN PROCESS_GROUP = 'Cell' AND ITEM_TYPE != N'제품' THEN (
																					SELECT ISNULL(MAX(ITEM_ID_PROD), substring(ITEM_DESCRIPTION, 1, charindex(' ', ITEM_DESCRIPTION) -1) )
																					  FROM #TMP_SCP_MST_CELL_PROD_ASSY_MAP
																					WHERE ITEM_ID_ASSY   = LIST.ITEM_ID
																						AND PLANT_iD     = LIST.PLANT_ID
																						AND DIVISION_ID  = LIST.DIVISION_ID
						                                                        )
					    WHEN ITEM_TYPE = N'반제품' AND FORECAST_INFO_CELL_MODEL IS NULL
						THEN (  SELECT TOP 1 X2.APPLIED_MODEL
								  FROM SCM_MST_ITEM_SN X2 WITH(NOLOCK)
								 WHERE X2.ITEM_ID = LIST.ITEM_ID
								   AND X2.APPLIED_MODEL IS NOT NULL
									)
						ELSE FORECAST_INFO_CELL_MODEL
						END
				) AS GPLM_CELL_MODEL
		FROM #TMP_LAST AS LIST
		ORDER BY  DIVISION_ID
				, PLANT_ID
				, ITEM_ID

	-------------------------------------------------------------------------------------------
	-- DROP #TMP_PROCESS_DETAIL
	-------------------------------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#TMP_ITEM_CLASS') IS NOT NULL
				DROP TABLE #TMP_ITEM_CLASS;

			IF OBJECT_ID('tempdb..#TMP_LAST') IS NOT NULL
				DROP TABLE #TMP_LAST;

			IF OBJECT_ID('tempdb..#TMP_SCP_MST_CELL_PROD_ASSY_MAP') IS NOT NULL
				DROP TABLE #TMP_SCP_MST_CELL_PROD_ASSY_MAP;

			IF OBJECT_ID('tempdb..#W_CELL_CF') IS NOT NULL
				DROP TABLE #W_CELL_CF;

			IF OBJECT_ID('tempdb..#W_CELL_CF_BOM') IS NOT NULL
				DROP TABLE #W_CELL_CF_BOM;

			IF OBJECT_ID('tempdb..#W_SITE_LIST') IS NOT NULL
				DROP TABLE #W_SITE_LIST;

			IF OBJECT_ID('tempdb..#W_ITEM_EE') IS NOT NULL
				DROP TABLE #W_ITEM_EE;

			IF OBJECT_ID('tempdb..#W_SI') IS NOT NULL
				DROP TABLE #W_SI;

			IF OBJECT_ID('tempdb..#W_CELL_ASSY_SI') IS NOT NULL
				DROP TABLE #W_CELL_ASSY_SI;

END

