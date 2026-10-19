
/*
 * Program ID   : SCP0084_GET_LONG_TERM_STOCK
 * Description  : SCP_ANL_LONG_TERM_STOCK 조회, 장기진부화 재고 
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2021/11/25   kmj                       Initial Release - [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 * 2022/04/21   lwy                       Initial Release - [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - Query 수정
 * 2022/06/07   vadabi3                   GPLM_CELL_CONVERSION_FACTOR => 기말재고 처럼 환산계수 적용 (SCP_ANL_MONTH_END_STOCK_R 에 ITEM_TYPE 컬럼 존재하지만 값은 없는 상태)
 * 2022/07/01   vadabi3                   [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - PIC_NM / NO_USAGE_IN_3M 적용
 * 2022/07/27   vadabi3                   [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - PIC_NM / NO_USAGE_IN_3M IF 처리 및 적용
 * 2023/01/25   vadabi3                   [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - ITEM TYPE > 기말재고 방식 적용
 * 2023/04/06   vadabi3                   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - division_id size / plant join
 * 2023/04/15   ksg                       PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - LONG_TERM_STOCK_AMOUNT 조회 수정
 * 2023/04/25   vadabi3                   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - [Ending Inventory] 단위 동기화
 * 2023/05/08   vadabi3                   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - 현지화 통화 정보 추가
 * 2023/06/09   vadabi3                   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - FP Table -> SN 으로 변경
 * 2024-01-08   chaan                     PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 */

CREATE PROCEDURE [dbo].[SCP0084_GET_LONG_TERM_STOCK_NEW]
--CREATE PROCEDURE [dbo].[SCP0084_GET_LONG_TERM_STOCK]
	@p_yyyymm				NVARCHAR(6),
	@p_division_id			NVARCHAR(100),
	@p_plant_id				NVARCHAR(500),
	@p_long_term_type_code	NVARCHAR(30),
	@debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- 20220607 GPLM IF 환산계수 = SCP0085_GET_ENDING_INVENTORY 참고
	;WITH W_CELL_CF AS
				  
	(
		SELECT TARGET_CELL
				, ITEM_ID
				, CELL_CF
				, ROW_NUMBER() OVER (PARTITION BY ITEM_ID ORDER BY BOM_MODIFY_DATE DESC, ATTRIBUTE5 DESC) AS RankNo
		FROM SCP_MST_ITEM_CELL_CF WITH(NOLOCK)
	)
	
	,W_CELL_CF_BOM AS
	(
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
/*
					,SCM_ITEM_M_SN  SI WITH(NOLOCK)
					,SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
					,SCP_MST_ITEM_CELL_CF CELL_CF WITH(NOLOCK)
			   WHERE CT.CHILD_COMPANY_ID  = SI.COMPANY_ID
				 AND CT.CHILD_DIVISION_ID = SI.DIVISION_ID
				 AND CT.CHILD_SITE_ID     = SI.SITE_ID
				 AND CT.CHILD_ITEM_ID     = SI.ITEM_ID
				 AND SI.ITEM_CLASS        = IC.CLASS_ID
				 AND IC.USE_FLAG          = 'Y'
				 AND ISNULL(SI.ITEM_TYPE,'H') IN ('P','Q','H')
				 AND CT.ALT_PRIORITY = 'Y'
				--AND CT.child_ITEM_ID = 'ANPCA1747B'
				--and CT.model_id = 'ACEN4065I-A1R001'
				--and CT.plant_id = 'G451'
				 AND CELL_CF.CELL_CF is NULL
				 AND CELL_CF.item_id  =  CT.child_ITEM_ID
				 AND CELL_CF.TARGET_CELL  =  CT.model_id
*/

				 JOIN SCM_ITEM_M_SN SI WITH(NOLOCK) 
				   ON CT.CHILD_COMPANY_ID  = SI.COMPANY_ID
				  AND CT.CHILD_DIVISION_ID = SI.DIVISION_ID
				  AND CT.CHILD_SITE_ID     = SI.SITE_ID
				  AND CT.CHILD_ITEM_ID     = SI.ITEM_ID
				  AND ISNULL(SI.ITEM_TYPE,'H') IN ('P','Q','H')
				  AND CT.ALT_PRIORITY 		= 'Y'

				 JOIN SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
				   ON SI.ITEM_CLASS        = IC.CLASS_ID
				  AND IC.USE_FLAG          = 'Y'

				 JOIN SCP_MST_ITEM_CELL_CF CELL_CF WITH(NOLOCK)
				   ON CELL_CF.CELL_CF is NULL
				  AND CELL_CF.item_id  		=  CT.child_ITEM_ID
				  AND CELL_CF.TARGET_CELL  =  CT.model_id

			)  CT
			GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID
	)

	SELECT    YYYYMM																				
			, DIVISION_ID																			
			, PLANT_DESCRIPTION																		
			, PLANT_ID																				
			, ITEM_ID																				
			, ITEM_NAME																				
			, ITEM_UOM																				
			--, STOCK_TYPE																			
			, LONG_TERM_TYPE																		
			, ITEM_TYPE																				
			, PROCESS_GROUP																			
			, PROCESS_DETAIL																		
			, GPLM_CELL_MODEL																		
			, MDM_NICK_NAME																			
			, SCP_EXTRA_SPEC																		
			, GPLM_CELL_CONVERSION_FACTOR_OLD														
		    ----------------------------------------------------------------------------------------------------------------------	
			, CASE WHEN CELL_CF_TYPE = 'BOM' THEN CELL_CF_BOM
			       ELSE CELL_CF
			       END AS GPLM_CELL_CONVERSION_FACTOR		-- UI > 소수점 2자리까지 표시																			
			, CASE WHEN CELL_CF_TYPE = 'BOM' THEN CELL_CF_BOM
			       ELSE CELL_CF
			       END AS CELL_CONVER_FACTOR		-- UI > 소수점 2자리까지 표시
			, CASE WHEN CELL_CF_TYPE = 'BOM' THEN CELL_CF_BOM
			       ELSE CELL_CF	
			       END AS CELL_CONVER_FACTOR_XLS	-- Excel > 소수점 5자리까지 표시
		    ----------------------------------------------------------------------------------------------------------------------
			, CASE 
				WHEN CELL_CF_TYPE = 'BOM'  AND CELL_CF_BOM IS NOT NULL THEN CELL_CF_BOM  * ISNULL(LONG_TERM_STOCK_QTY,0)
				WHEN CELL_CF_TYPE = 'WCF'  AND CELL_CF IS NOT NULL THEN  CONVERT(float, CELL_CF)  * ISNULL(LONG_TERM_STOCK_QTY,0)
				WHEN CELL_CF IS NOT NULL THEN  CONVERT(float, CELL_CF)  * ISNULL(LONG_TERM_STOCK_QTY,0)
				ELSE LONG_TERM_STOCK_QTY
				END AS CELL_CONVER_QUANTITY -- UI > 소수점 5자리까지 표시
			, CASE 
				WHEN CELL_CF_TYPE = 'BOM'  AND CELL_CF_BOM IS NOT NULL THEN CELL_CF_BOM  * ISNULL(LONG_TERM_STOCK_QTY,0)
				WHEN CELL_CF_TYPE = 'WCF'  AND CELL_CF IS NOT NULL THEN  CONVERT(float, CELL_CF)  * ISNULL(LONG_TERM_STOCK_QTY,0)
				WHEN CELL_CF IS NOT NULL THEN  CONVERT(float, CELL_CF)  * ISNULL(LONG_TERM_STOCK_QTY,0)
				ELSE LONG_TERM_STOCK_QTY
				END AS CELL_CONVER_QUANTITY_XLS -- Excel > 소수점 7자리까지 표시
		    ----------------------------------------------------------------------------------------------------------------------
			, CELL_CF_TYPE  -- 검증
			, CELL_CF		-- 검증
			, CELL_CF_BOM	-- 검증	
		    ----------------------------------------------------------------------------------------------------------------------
			, CELL_CF_TYPE
			, CELL_CF
			, CELL_CF_BOM
			
			, LEVEL_1_NAME																			
			, LEVEL_2_NAME																			
			, LEVEL_3_NAME																			
			, LEVEL_4_NAME																			
			, VALUATION_CLASS																		
			--, CLASSIFICATION																		
			, DEVALUATION_AGE																		
			, ENDING_STOCK_QTY																		
			, ENDING_STOCK_CONVERSION_QTY															
			, LONG_TERM_STOCK_QTY																	
			, LONG_TERM_STOCK_AMOUNT	
			-----------------------------
			, LONG_TERM_STOCK_QTY AS LONG_TERM_STOCK_QTY_XLS
            , LONG_TERM_STOCK_AMOUNT AS LONG_TERM_STOCK_AMOUNT_XLS
			----------------------------------------------------------------									
			, MEMO							
			, YYYYMM_VAL
			, CHARG
			, PIC_NO
			, PIC
			, NO_USAGE_IN_3M
			----------------------------------------------------------------	
			, CURRENCY
			, IIF(CURRENCY =N'KRW', 1, EX_TO_BAMT) AS EX_TO_BAMT
			, AMOUNT_KRW
			, AMOUNT_KRW AS AMOUNT_KRW_XLS
			, CASE 
			    WHEN CURRENCY = N'KRW' THEN LONG_TERM_STOCK_AMOUNT
				WHEN AMOUNT IS NOT NULL THEN AMOUNT
				ELSE UNIT_PRICE * LONG_TERM_STOCK_QTY
				END AS AMOUNT
			, CASE 
			    WHEN CURRENCY = N'KRW' THEN LONG_TERM_STOCK_AMOUNT
				WHEN AMOUNT IS NOT NULL THEN AMOUNT
				ELSE UNIT_PRICE * LONG_TERM_STOCK_QTY
				END AS AMOUNT_XLS
			, CASE 
			    WHEN CURRENCY = N'KRW' THEN ROUND(UNIT_PRICE,0)
				ELSE UNIT_PRICE
				END AS UNIT_PRICE
			, CASE WHEN LPEIN IS NOT NULL AND LPEIN <> 0 
					THEN UNIT_PRICE_ORG / LPEIN
					ELSE UNIT_PRICE
					END AS UNIT_PRICE_XLS

			, CASE 
			    WHEN CURRENCY = N'KRW' THEN ROUND(UNIT_PRICE_KRW,0)
				ELSE ROUND(UNIT_PRICE_KRW,2)
				END AS UNIT_PRICE_KRW
			, UNIT_PRICE_KRW AS UNIT_PRICE_KRW_XLS
			--, CASE 
			--	WHEN UNIT_PRICE_KRW IS NOT NULL THEN UNIT_PRICE_KRW
			--	ELSE IIF(CURRENCY =N'KRW' OR EX_TO_BAMT=0, UNIT_PRICE, ISNULL(EX_TO_BAMT, 1) * ROUND(UNIT_PRICE,2)) 
			--	END AS UNIT_PRICE_KRW
			--, IIF(CURRENCY=N'KRW' OR EX_TO_BAMT=0, ROUND(LONG_TERM_STOCK_AMOUNT / LONG_TERM_STOCK_QTY,2), ROUND(LONG_TERM_STOCK_AMOUNT / EX_TO_BAMT / LONG_TERM_STOCK_QTY,2) )  AS UNIT_PRICE_KRW
			--, IIF(CURRENCY=N'KRW' OR EX_TO_BAMT=0, LONG_TERM_STOCK_AMOUNT / LONG_TERM_STOCK_QTY, LONG_TERM_STOCK_AMOUNT / EX_TO_BAMT / LONG_TERM_STOCK_QTY )  AS UNIT_PRICE_KRW_XLS	

	FROM
	(
			SELECT 
				('‘' + SUBSTRING(A.YYYYMM, 3, 2) + '.' + RIGHT(A.YYYYMM, 2)) AS YYYYMM																				--보고시점
				, A.DIVISION_ID																																		--사업부(소형전지)
				, B.PLANT_NAME AS PLANT_DESCRIPTION																													--플랜트지역(오창)
				, A.PLANT_ID																																		--플랜트(A010)
				, A.ITEM_ID																																			--자재
				, A.ITEM_NAME																																		--자재내역
				, A.ITEM_UOM																																		--단위
				--, A.STOCK_TYPE																																	--장기진부화구분
				, A.LONG_TERM_TYPE																																	--부실재고구분
				, D.ITEM_TYPE AS ITEM_TYPE_ORG																																		--원반제구분
				, (
					CASE 
					WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품' 
					WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품' 
					ELSE D.ITEM_TYPE		
					END
				) AS ITEM_TYPE		-- 원반제구분 기말재고 방식					
				, D.PROCESS_GROUP																																	--공정그룹
				, D.PROCESS_DETAIL																																	--자재그룹
				, A.GPLM_CELL_MODEL																																	--GPLM대상셀
				, A.MDM_NICK_NAME																																	--MDM프로젝트닉네임
				, C.SCP_EXTRA_SPEC																																	--EXTRA SPEC
				, A.GPLM_CELL_CONVERSION_FACTOR AS GPLM_CELL_CONVERSION_FACTOR_OLD																											--GPLM셀환산계수
				, ( CASE 
						WHEN D.PROCESS_GROUP = 'Cell' THEN '1.000000'					  -- 20220607 CELL 인 경우 환산계수 = 1 
						WHEN D.ITEM_TYPE IN (N'반제품',N'제품') AND WCF.CELL_CF IS NOT NULL 
						THEN WCF.CELL_CF         -- 20220607 GPLM IF 환산계수
						ELSE null
						END
					) AS GPLM_CELL_CONVERSION_FACTOR
				, ( CASE 
						WHEN D.PROCESS_GROUP = 'Cell' THEN 'Cell'					
						WHEN D.ITEM_TYPE IN (N'반제품',N'제품') AND WCF.CELL_CF IS NOT NULL THEN 'WCF'
						WHEN D.ITEM_TYPE IN (N'반제품',N'제품') AND WCF.CELL_CF IS     NULL THEN 'BOM'
						ELSE NULL
						END
					) AS CELL_CF_TYPE
				, D.LEVEL_1_NAME																																	--MDM자재분류계층구조1
				, D.LEVEL_2_NAME																																	--MDM자재분류계층구조2
				, D.LEVEL_3_NAME																																	--MDM자재분류계층구조3
				, D.LEVEL_4_NAME																																	--MDM자재분류계층구조4
				, A.VALUATION_CLASS																																	--평가클래스
				--, A.CLASSIFICATION																																--품목
				, A.DEVALUATION_AGE																																	--기타재고월령
				, A.ENDING_STOCK_QTY																																--기말재고수량
				, A.ENDING_STOCK_CONVERSION_QTY																													    --기말재고환산수량
				, A.LONG_TERM_STOCK_QTY																																--기타재고수량
				, IIF(A.WAERS=N'KRW' OR A.EX_TO_BAMT=0, A.LONG_TERM_STOCK_AMOUNT, A.EX_TO_BAMT*A.LONG_TERM_STOCK_AMOUNT)             AS LONG_TERM_STOCK_AMOUNT		--기타재고금액(KRW)
				--, IIF(A.WAERS=N'KRW' OR A.EX_TO_BAMT=0, A.LONG_TERM_STOCK_AMOUNT, A.UNIT_PRICE*A.EX_TO_BAMT*A.LONG_TERM_STOCK_QTY) AS LONG_TERM_STOCK_AMOUNT		--기타재고금액(KRW)
				--, IIF(A.WAERS=N'KRW' OR A.EX_TO_BAMT=0, A.UNIT_PRICE, ROUND(A.UNIT_PRICE,2,1) * A.EX_TO_BAMT) AS UNIT_PRICE										--재고단가(KRW)
				--, CASE 
				--  WHEN CAST(LPEIN AS NUMERIC) <> 0 
				--  THEN ROUND(UNIT_PRICE_ORG / LPEIN,3)
				--  ELSE UNIT_PRICE_ORG
				--  END AS UNIT_PRICE --재고단가(KRW)
				, UNIT_PRICE
				, A.MEMO																																			--비고
				, A.YYYYMM AS YYYYMM_VAL
				, A.CHARG
				--, (SELECT MAX(segment4) AS PIC_NM2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE  lookup_type = 'PIC_MASTER' and segment1= A.PLANT_ID AND  segment2 = A.ITEM_ID ) AS PIC
				--, (SELECT MAX(display_seq) AS NO_USAGE_IN_3M2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE  lookup_type = 'PIC_MASTER' and segment1= A.PLANT_ID AND  segment2 = A.ITEM_ID ) AS NO_USAGE_IN_3M
				--, PIC.display_seq AS NO_USAGE_IN_3M
				, PIC.PIC_NO AS PIC_NO
				, PIC.PIC_NM AS PIC
				, CASE WHEN NO_USE_3M.ITEM_ID IS NOT NULL THEN 'O'
					   ELSE NULL
					   END NO_USAGE_IN_3M
				, WCF.CELL_CF
				, (SELECT CELL_CF_BOM FROM W_CELL_CF_BOM WITH(NOLOCK) WHERE CHILD_ITEM_ID = A.ITEM_ID and plant_id = A.PLANT_ID and MODEL_ID = WCF.TARGET_CELL) AS CELL_CF_BOM
				----------------------------------------------------------------
				, A.WAERS AS CURRENCY
				, IIF(A.CURRENCY = 'KRW', '1', A.EX_TO_BAMT) AS EX_TO_BAMT
				, A.AMOUNT AS AMOUNT
				, A.AMOUNT AS AMOUNT_XLS
				, A.AMOUNT_KRW AS AMOUNT_KRW
				, A.AMOUNT_KRW AS AMOUNT_KRW_XLS
				--, A.UNIT_PRICE AS UNIT_PRICE
				, A.UNIT_PRICE_ORG AS UNIT_PRICE_ORG
				, CASE WHEN LPEIN IS NOT NULL AND LPEIN <> 0 
						THEN IIF(A.CURRENCY = 'KRW', UNIT_PRICE_ORG / LPEIN, UNIT_PRICE_ORG * A.EX_TO_BAMT / LPEIN) 
						ELSE A.UNIT_PRICE_KRW
						END AS UNIT_PRICE_KRW
				, A.LPEIN
			FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK) 
	
			LEFT JOIN (
				SELECT DISTINCT PLANT_ID, PLANT_NAME
				FROM SCM_PLANT_M_SN WITH(NOLOCK)
					
--				UNION
				UNION ALL
					
				select SEGMENT1 as PLANT_ID, SEGMENT2 as PLANT_NAME
				  from [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				 where LOOKUP_TYPE   = 'INVENTORY_SITE'
				   AND VALID_YN = 'Y'
			) B
			ON A.PLANT_ID = B.PLANT_ID
	
			LEFT JOIN (SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
						FROM SCM_MST_ITEM_SN WITH(NOLOCK)
						GROUP BY ITEM_ID
			) C
			ON  A.ITEM_ID = C.ITEM_ID

			LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
			ON C.ITEM_CLASS = D.CLASS_ID

			LEFT JOIN W_CELL_CF WCF WITH(NOLOCK)
				ON A.ITEM_ID = WCF.ITEM_ID
				AND WCF.RankNo = 1
			/*  
			LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL PIC WITH(NOLOCK)
			  ON segment1= A.PLANT_ID 
			  AND  segment2 = A.ITEM_ID
			  AND lookup_type = 'PIC_MASTER'
			*/
			LEFT JOIN SCP_MST_PIC_INFO PIC WITH(NOLOCK)
				ON PIC.PLANT_ID= A.PLANT_ID 
				AND PIC.ITEM_ID = A.ITEM_ID

			LEFT JOIN SCP_MST_NO_USE_3M NO_USE_3M WITH(NOLOCK)
				ON NO_USE_3M.PLANT_ID= A.PLANT_ID 
				AND NO_USE_3M.ITEM_ID = A.ITEM_ID
				 -- AND NO_USE_3M.COMPANY_ID = C.COMPANY_ID

	
				--JOIN SCM_PLANT_M_SN B WITH(NOLOCK)
				--ON A.DIVISION_ID = B.DIVISION_ID
				--AND A.PLANT_ID = B.PLANT_ID
	
				--LEFT JOIN SCM_MST_ITEM_SN C WITH(NOLOCK)
				--ON B.COMPANY_ID = C.COMPANY_ID
				--AND B.DIVISION_ID = C.DIVISION_ID
				--AND B.SITE_ID = C.SITE_ID
				--AND A.ITEM_ID = C.ITEM_ID

				--JOIN (
				--	-- DIVISION별 MAX IFSEQNO
				--	SELECT 
				--		MAX(IFSEQNO) AS IFSEQNO
				--		, DIVISION_ID
				--	FROM SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK)
				--	GROUP BY DIVISION_ID

				--) E
				--ON A.IFSEQNO = E.IFSEQNO
				--AND A.DIVISION_ID = E.DIVISION_ID
	
	WHERE 1=1
	AND A.YYYYMM = @p_yyyymm
	AND ( ISNULL(@p_division_id, '')			= '' OR A.DIVISION_ID			IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
	AND ( ISNULL(@p_plant_id, '')				= '' OR A.PLANT_ID				IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
	AND ( ISNULL(@p_long_term_type_code, '')	= '' OR A.LONG_TERM_TYPE_CODE	IN (SELECT token FROM dbo.String_Split(@p_long_term_type_code,',')) )
	
	) LIST
	ORDER BY DIVISION_ID, PLANT_ID, ITEM_ID; 
	;

END

