
/*
 * Program ID   : SCP0084_GET_LONG_TERM_STOCK_INCLUDE_EXHT_PLAN
 * Description  : SCP_ANL_LONG_TERM_STOCK 조회, 장기진부화 재고 
 * Program History
 *===================================================================================================
 * Date         In Charge			Description
 *===================================================================================================
 * 2024/07/22   Quoc Tan (Tanvq1)    Add new procedures to get Long-Term Stock include data in SCP_ANL_LGTM_INV_EXHT_PLAN Table
 */

--CREATE PROCEDURE [dbo].[SCP0084_GET_LONG_TERM_STOCK_INCLUDE_EXHT_PLAN]
CREATE PROCEDURE [dbo].[SCP0084_GET_LONG_TERM_STOCK_INCLUDE_EXHT_PLAN]
	@p_yyyymm				NVARCHAR(6),
	@p_division_id			NVARCHAR(100),
	@p_plant_id				NVARCHAR(500),
	@p_long_term_type_code	NVARCHAR(30),
	@debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	DECLARE @year INT = CAST(LEFT(@p_yyyymm, 4) AS INT);
    DECLARE @month INT = CAST(RIGHT(@p_yyyymm, 2) AS INT);

	IF(OBJECT_ID('tempdb.dbo.#tmp_group_code') IS NOT NULL)
			DROP TABLE #tmp_group_code

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
			)  CT
			GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID
	)
		
	
        SELECT    I.DIVISION_ID
                , I.ITEM_ID
                , MAX(CASE WHEN ISNULL(F1.GROUP_CODE1, '') != '' THEN F1.GROUP_CODE1
                            WHEN ISNULL(F3.GROUP_CODE1, '') != '' THEN F3.GROUP_CODE1
                            WHEN ISNULL(F2.GROUP_CODE1, '') != '' THEN F2.GROUP_CODE1
                            WHEN ISNULL(I.DOE, '') = '' THEN ISNULL(I3.NICK_NAME, I.NICK_NAME)
                            ELSE ISNULL(I2.NICK_NAME, I.NICK_NAME) END
                            ) AS GROUP_CODE
		INTO #tmp_group_code
        FROM    SCM_ITEM_M_SN I WITH(NOLOCK)
        LEFT OUTER JOIN SCM_ITEM_M_SN I2 WITH(NOLOCK)
        ON      I2.ITEM_ID      = CASE WHEN ISNULL(I.DOE, '') = '' THEN I.APPLIED_MODEL ELSE ISNULL(I.DOE, '') END
        AND     I2.DIVISION_ID  = I.DIVISION_ID
        LEFT OUTER JOIN SCM_ITEM_M_SN I3 WITH(NOLOCK)
        ON      I3.ITEM_ID      = I2.DOE
        AND     I3.DIVISION_ID  = I2.DIVISION_ID
        LEFT OUTER JOIN SCP_MST_FINAL_ITEM F1 WITH(NOLOCK)
        ON      F1.ITEM_ID      = I.ITEM_ID
        AND     F1.DIVISION_ID  = I.DIVISION_ID
        LEFT OUTER JOIN SCP_MST_FINAL_ITEM F2 WITH(NOLOCK)
        ON      F2.ITEM_ID      = CASE WHEN ISNULL(I.DOE, '') = '' THEN I.APPLIED_MODEL ELSE ISNULL(I.DOE, '') END
        AND     F2.DIVISION_ID  = I.DIVISION_ID
        LEFT OUTER JOIN SCP_MST_FINAL_ITEM F3 WITH(NOLOCK)
        ON      F3.ITEM_ID      = I2.DOE
        AND     F3.DIVISION_ID  = I2.DIVISION_ID
        WHERE   1=1
        GROUP BY I.DIVISION_ID
                , I.ITEM_ID  


	SELECT    YYYYMM																				
			, DIVISION_ID																			
			, PLANT_DESCRIPTION																		
			, PLANT_ID																				
			, ITEM_ID																				
			, ITEM_NAME																				
			, ITEM_UOM
			, GROUP_CODE
			, MARKETING_DEPARTMENT
			, END_CUSTOMER
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
			, OCCR_RSN_CD
			, OCCR_RSN_CTN
			, EXHT_TP_CD
			, EXHT_TP_CTN
			, QTY_1
			, QTY_2
			, QTY_3
			, QTY_4
			, QTY_5
			, QTY_6
			, QTY_7
			, QTY_8			
			, QTY_9
			, QTY_10
			, QTY_11
			, QTY_12
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
				, J.GROUP_CODE
				, I.MKT_DEPT AS MARKETING_DEPARTMENT
				, I.END_CUSTOMER
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
				, G.ATTRIBUTE1 AS OCCR_RSN_CD
				, F.OCCR_RSN_CTN
				, H.ATTRIBUTE1 AS EXHT_TP_CD
				, F.EXHT_TP_CTN
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 1) > 12 THEN  ((@year + 1) * 100 + (@month + 1 -12)) 
												ELSE (@year * 100 + @month + 1 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_1 
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 2) > 12 THEN  ((@year + 1) * 100 + (@month + 2 -12)) 
												ELSE (@year * 100 + @month + 2 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_2
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 3) > 12 THEN  ((@year + 1) * 100 + (@month + 3 -12)) 
												ELSE (@year * 100 + @month + 3 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_3
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 4) > 12 THEN  ((@year + 1) * 100 + (@month + 4 -12)) 
												ELSE (@year * 100 + @month + 4 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_4
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 5) > 12 THEN  ((@year + 1) * 100 + (@month + 5 -12)) 
												ELSE (@year * 100 + @month + 5 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_5
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 6) > 12 THEN  ((@year + 1) * 100 + (@month + 6 -12)) 
												ELSE (@year * 100 + @month + 6 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_6
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 7) > 12 THEN  ((@year + 1) * 100 + (@month + 7 -12)) 
												ELSE (@year * 100 + @month + 7 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_7
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 8) > 12 THEN  ((@year + 1) * 100 + (@month + 8 -12)) 
												ELSE (@year * 100 + @month + 8 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_8
			
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 9) > 12 THEN  ((@year + 1) * 100 + (@month + 9 -12)) 
												ELSE (@year * 100 + @month + 9 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_9
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 10) > 12 THEN  ((@year + 1) * 100 + (@month + 10 -12)) 
												ELSE (@year * 100 + @month + 10 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_10
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 11) > 12 THEN  ((@year + 1) * 100 + (@month + 11 -12)) 
												ELSE (@year * 100 + @month + 11 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_11
				, SUM(CASE 
						WHEN F.PLAN_YYYYMM = (CASE 
												WHEN (@month + 12) > 12 THEN  ((@year + 1) * 100 + (@month + 12 -12)) 
												ELSE (@year * 100 + @month + 12 ) 
												END) THEN F.QTY 
						ELSE NULL 
						END) AS QTY_12
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

			LEFT JOIN SCP_ANL_LGTM_INV_EXHT_PLAN F WITH(NOLOCK)
			ON F.YYYYMM = A.YYYYMM 
			AND F.PLANT_ID = A.PLANT_ID
			AND F.DIVISION_ID = A.DIVISION_ID
			AND F.ITEM_ID = A.ITEM_ID
			AND F.CHARG = A.CHARG
			AND F.DEVALUATION_AGE = A.DEVALUATION_AGE

			LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G WITH(NOLOCK)
			ON G.SEGMENT1 = F.OCCR_RSN_CD

			LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL H WITH(NOLOCK)
			ON H.SEGMENT1 = F.EXHT_TP_CD

			LEFT JOIN SCP_MST_FINAL_ITEM I WITH(NOLOCK)
			ON I.DIVISION_ID = A.DIVISION_ID
			AND I.ITEM_ID = A.ITEM_ID
			
			LEFT JOIN #tmp_group_code J WITH(NOLOCK)
			ON J.DIVISION_ID = A.DIVISION_ID
			AND J.ITEM_ID = A.ITEM_ID

	WHERE 1=1
	AND A.YYYYMM = @p_yyyymm
	AND ( ISNULL(@p_division_id, '')			= '' OR A.DIVISION_ID			IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
	AND ( ISNULL(@p_plant_id, '')				= '' OR A.PLANT_ID				IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
	AND ( ISNULL(@p_long_term_type_code, '')	= '' OR A.LONG_TERM_TYPE_CODE	IN (SELECT token FROM dbo.String_Split(@p_long_term_type_code,',')) )

	GROUP BY  	 A.DIVISION_ID																																		
				, B.PLANT_NAME 																												
				, A.PLANT_ID																																		
				, A.ITEM_ID																																			
				, A.ITEM_NAME																																		
				, A.ITEM_UOM
				, J.GROUP_CODE
				, I.MKT_DEPT
				, I.END_CUSTOMER
				--, A.STOCK_TYPE																																	
				, A.LONG_TERM_TYPE																																	
				, D.ITEM_TYPE						
				, D.PROCESS_GROUP																																	
				, D.PROCESS_DETAIL																																	
				, A.GPLM_CELL_MODEL																																	
				, A.MDM_NICK_NAME																																	
				, C.SCP_EXTRA_SPEC																																	
				, A.GPLM_CELL_CONVERSION_FACTOR		
				, D.LEVEL_1_NAME																																	
				, D.LEVEL_2_NAME																																	
				, D.LEVEL_3_NAME																																	
				, D.LEVEL_4_NAME																																	
				, A.VALUATION_CLASS																																	
				, A.DEVALUATION_AGE																																	
				, A.ENDING_STOCK_QTY																																
				, A.ENDING_STOCK_CONVERSION_QTY																													    
				, A.LONG_TERM_STOCK_QTY, UNIT_PRICE
				, A.MEMO																																			
				, A.YYYYMM 
				, A.CHARG, PIC.PIC_NO 
				, PIC.PIC_NM
				, WCF.CELL_CF
				, A.WAERS
				, A.AMOUNT
				, A.AMOUNT 
				, A.AMOUNT_KRW
				, A.AMOUNT_KRW 
				, A.UNIT_PRICE_ORG
				, A.LPEIN
				, A.EX_TO_BAMT
				, A.LONG_TERM_STOCK_AMOUNT
				, A.EX_TO_BAMT
				, A.LONG_TERM_STOCK_AMOUNT
				, A.CURRENCY
				, A.UNIT_PRICE_KRW
				, F.OCCR_RSN_CD
				, G.ATTRIBUTE1 
				, F.OCCR_RSN_CTN
				, F.EXHT_TP_CD 
				, H.ATTRIBUTE1 
				, F.EXHT_TP_CTN
				, NO_USE_3M.ITEM_ID
				, WCF.TARGET_CELL
	
	) LIST
	ORDER BY DIVISION_ID, PLANT_ID, ITEM_ID; 
	;

	Drop table #tmp_group_code;

END

