





CREATE VIEW [dbo].[FP_SIMULATION_ELEC_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_ELEC_V
--
-- Program Name        : FP_SIMULATION_ELEC_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_AMEND_DAILY_PLAN_R
-- Destination Table   : FP_AMEND_DAILY_PLAN_R
--
-- Create(Update) Date : 2019.08.07 1.0 PIYONG
--                       2019.08.12 2.0 KIMCD
--                       2019.08.15 2.1 KIMCD
--                       2019.10.07 2.3 kimcd
--                       2019.12.09 2.4 kimcd
--                       2021.04.22 2.5 kimcd
-- Author              : PIYONG 
-- Version             : 1.0 신규 생성
--                     : 2.0 2019-08-12 kimcd 일별 Capa, Total 영역(형교환,OFF 시간, Load), Setup Color 추가
--                     : 2.1 2019-08-15 kimcd MPP WPP 주석 처리
--                       2.2 2019-10-03 kimcd 정렬 값 partition 대상에 instance_id, fp_plan_id 추가
--                       2.3 2019-10-07 kimcd in에서 pancake, j/r, cell, out에서 pancake, batch, result에서 pancake 제거 
--                       2.4 2019-12-09 kimcd Foil 추출 로직 수정 - 양산, TEST 구분.
--                       2.5 2021-04-22 kimcd Demand Type lookup 제약 추가
-- ================================================================================================
AS 
	
	WITH DA AS (
				SELECT S.SITE_ID
					   , D.DATE_ID
					   , RANK() OVER (PARTITION BY S.SITE_ID ORDER BY D.DATE_ID) NUM
				  FROM [dbo].[SCM_SYS_CALENDAR_M] D WITH(NOLOCK)
					   , (
							SELECT S.SITE_ID
							  FROM SCM_SITE_M S WITH(NOLOCK)
							 GROUP BY S.SITE_ID
						 ) S
				   WHERE D.DATE_ID >= CONVERT( DATE, DATEADD( D, -DAY( DBO.FN_SITE_TIME ( S.SITE_ID) - 1), DBO.FN_SITE_TIME( S.SITE_ID)) )
					 AND D.DATE_ID <= DATEADD( D, 99, CONVERT( DATE, DATEADD(D, -DAY( DBO.FN_SITE_TIME(S.SITE_ID) - 1), DBO.FN_SITE_TIME ( S.SITE_ID)) ) )
		 ) 
	, MAIN AS (
		SELECT A.INSTANCE_ID
			   , A.FP_PLAN_ID
			   , A.COMPANY_ID
			   , A.DIVISION_ID
			   , A.SITE_ID
			   , A.PLANT_ID
			   , A.FACTORY_ID
			   , A.LOCATION
			   , A.OPERATION_ID
			   , A.LINE_ID
			   , A.LINE_NAME
			   , A.ELECTRODE_TYPE
		       , A.EQUIPMENT_ID
		       , A.ITEM_ID
			   , A.TOP_ITEM_ID
			   , A.NICK_NAME
		       , A.PRODUCTION_TYPE
			   , A.MARKET
			   , ISNULL(E.SLURRY_1,F.SLURRY_1) AS BATCH_ID
			   , ISNULL(E.SLURRY_2,F.SLURRY_2) AS BATCH_ID_2
			   , ISNULL(E.PRE_DISPERSION_ID,F.PRE_DISPERSION_ID) AS PRE_DISPERSION_ID
			   , ISNULL(E.PRE_DISPERSION_NAME,F.PRE_DISPERSION_NAME) AS PRE_DISPERSION_NAME
			   , ISNULL(E.ACTIVE_MATERIAL_1,F.ACTIVE_MATERIAL_1) AS ACTIVE_MATERIAL_1
			   , ISNULL(E.ACTIVE_MATERIAL_2,F.ACTIVE_MATERIAL_2) AS ACTIVE_MATERIAL_2
			   , ISNULL(E.ACTIVE_MATERIAL_3,F.ACTIVE_MATERIAL_3) AS ACTIVE_MATERIAL_3
			   , ISNULL(E.BINDER_1,F.BINDER_1) AS BINDER_1
			   , ISNULL(E.BINDER_2,F.BINDER_2) AS BINDER_2
			   , ISNULL(E.BINDER_3,F.BINDER_3) AS BINDER_3
			   , ISNULL(E.CMC,F.CMC) AS CMC
			   , ISNULL(E.PROD_VERSION,F.PROD_VERSION) AS [VERSION]
			   , ISNULL(E.MODEL_ID,F.MODEL_ID) AS PC_MODEL_ID
			   , ISNULL(G.FOIL_CODE,[DBO].[FN_GET_FOIL](A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, 'FOIL_CODE')) AS FOIL_CODE  -- 2019-12-09 kimcd Foil 조회 보완 PROD VERSION 유형 기준으로 없는 경우 다른 생산 유형 값 반환
			   , ISNULL(G.FOIL,[DBO].[FN_GET_FOIL](A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, 'FOIL'))      AS FOIL       -- 2019-12-09 kimcd Foil 조회 보완 PROD VERSION 유형 기준으로 없는 경우 다른 생산 유형 값 반환
			   , Z.DAILY_CAPA_PPM  AS DC_PPM
			   -- 2019-08-12 kimcd daily capa add start
	           , ISNULL(D.DAILY_CAPA_M, H.DAILY_CAPA_M) AS DC_M
	           , ISNULL(D.DAILY_CAPA_EA, H.DAILY_CAPA_EA) AS DC_CELL
	           , ISNULL(D.DAILY_CAPA_KG, H.DAILY_CAPA_KG) AS DC_KG
	           , ISNULL(D.DAILY_CAPA_JR, H.DAILY_CAPA_JR) AS DC_JR
	           , ISNULL(D.DAILY_CAPA_BATCH, H.DAILY_CAPA_BATCH) AS DC_BATCH
	           , CASE WHEN A.TOP_ITEM_ID='NONE' THEN 'N' ELSE ISNULL(D.DC_FLAG, H.DC_FLAG) END AS DC_FLAG
			   -- 2019-08-12 kimcd daily capa add end
			   , D1 
			   , D2
			   , D3
			   , D4
			   , D5
			   , D6
			   , D7
			   , D8
			   , D9
			   , D10
			   , D11
			   , D12
			   , D13
			   , D14
			   , D15
			   , D16 
			   , D17 
			   , D18 
			   , D19 
			   , D20 
			   , D21 
			   , D22 
			   , D23 
			   , D24 
			   , D25 
			   , D26 
			   , D27
			   , D28
			   , D29
			   , D30
			   , D31
			   , D32
			   , D33
			   , D34
			   , D35
			   , D36
			   , D37
			   , D38
			   , D39
			   , D40
			   , D41
			   , D42
			   , D43
			   , D44
			   , D45
			   , D46
			   , D47 
			   , D48 
			   , D49 
			   , D50 
			   , D51 
			   , D52 
			   , D53 
			   , D54 
			   , D55 
			   , D56 
			   , D57 
			   , D58
			   , D59
			   , D60
			   , D61
			   , D62
			   , D63
			   , D64
			   , D65
			   , D66
			   , D67
			   , D68
			   , D69
			   , D70
			   , D71
			   , D72
			   , D73
			   , D74
			   , D75
			   , D76
			   , D77
			   , D78 
			   , D79 
			   , D80 
			   , D81 
			   , D82 
			   , D83 
			   , D84 
			   , D85 
			   , D86 
			   , D87 
			   , D88 
			   , D89
			   , D90
			   , D91
			   , D92
			   , D93 
			   , D94 
			   , D95 
			   , D96 
			   , D97 
			   , D98 
			   , D99
			   , D100
			   -- 2019-08-12 kimcd setup_color add start
			   , S_C1 
			   , S_C2
			   , S_C3
			   , S_C4
			   , S_C5
			   , S_C6
			   , S_C7
			   , S_C8
			   , S_C9
			   , S_C10
			   , S_C11
			   , S_C12
			   , S_C13
			   , S_C14
			   , S_C15
			   , S_C16 
			   , S_C17 
			   , S_C18 
			   , S_C19 
			   , S_C20 
			   , S_C21 
			   , S_C22 
			   , S_C23 
			   , S_C24 
			   , S_C25 
			   , S_C26 
			   , S_C27
			   , S_C28
			   , S_C29
			   , S_C30
			   , S_C31
			   , S_C32
			   , S_C33
			   , S_C34
			   , S_C35
			   , S_C36
			   , S_C37
			   , S_C38
			   , S_C39
			   , S_C40
			   , S_C41
			   , S_C42
			   , S_C43
			   , S_C44
			   , S_C45
			   , S_C46
			   , S_C47 
			   , S_C48 
			   , S_C49 
			   , S_C50 
			   , S_C51 
			   , S_C52 
			   , S_C53 
			   , S_C54 
			   , S_C55 
			   , S_C56 
			   , S_C57 
			   , S_C58
			   , S_C59
			   , S_C60
			   , S_C61
			   , S_C62
			   , S_C63
			   , S_C64
			   , S_C65
			   , S_C66
			   , S_C67
			   , S_C68
			   , S_C69
			   , S_C70
			   , S_C71
			   , S_C72
			   , S_C73
			   , S_C74
			   , S_C75
			   , S_C76
			   , S_C77
			   , S_C78 
			   , S_C79 
			   , S_C80 
			   , S_C81 
			   , S_C82 
			   , S_C83 
			   , S_C84 
			   , S_C85 
			   , S_C86 
			   , S_C87 
			   , S_C88 
			   , S_C89
			   , S_C90
			   , S_C91
			   , S_C92
			   , S_C93 
			   , S_C94 
			   , S_C95 
			   , S_C96 
			   , S_C97 
			   , S_C98 
			   , S_C99
			   , S_C100
			   -- 2019-08-12 kimcd setup_color add start
			   , A.CATEGORY_NAME
			   , A.CATEGORY_ID
			   , A.CATEGORY_ORDER
			   , A.MEASURE_NAME
			   , A.DATA_TYPE
			   , ISNULL(B.LINE_SEQ, 9999) LINE_SEQ
      	  FROM (
				SELECT A.INSTANCE_ID
					   , A.FP_PLAN_ID
					   , A.COMPANY_ID
					   , A.DIVISION_ID
					   , A.SITE_ID
					   , A.PLANT_ID
					   , A.FACTORY_ID
		               , A.LOCATION
					   , A.OPERATION_ID
		               , A.LINE_ID
					   , A.LINE_NAME
					   , A.ELECTRODE_TYPE
		               , A.EQUIPMENT_ID
		               , A.ITEM_ID
					   , A.TOP_ITEM_ID
					   , A.NICK_NAME
		               , A.PRODUCTION_TYPE
					   , A.MARKET
					   , A.PROD_VERSION_TYPE
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 1 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												   WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																											   WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            												ELSE 0 END) ELSE 0 END) AS D1
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 2 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												   WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																											   WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            												ELSE 0 END) ELSE 0 END) AS D2
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 3 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												   WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																											   WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            												ELSE 0 END) ELSE 0 END) AS D3
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 4 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												   WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																											   WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            												ELSE 0 END) ELSE 0 END) AS D4
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 5 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												   WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D5
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 6 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												   WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D6
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 7 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												   WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D7
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 8 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												   WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D8
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 9 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												   --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												   WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												   WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												   --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											   --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											   --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																											   WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D9
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 10 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D10
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 11 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D11
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 12 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D12
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 13 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D13 
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 14 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D14
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 15 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D15
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 16 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D16 
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 17 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D17
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 18 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D18
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 19 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D19 
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 20 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D20
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 21 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D21 
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 22 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D22
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 23 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D23 
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 24 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D24 
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 25 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
																												ELSE 0 END) ELSE 0 END) AS D25 
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 26 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D26 
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 27 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D27
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 28 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D28
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 29 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D29
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 30 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D30
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 31 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D31
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 32 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D32
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 33 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D33
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 34 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D34
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 35 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D35
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 36 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D36
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 37 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D37
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 38 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D38
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 39 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D39
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 40 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D40
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 41 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D41
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 42 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D42
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 43 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D43
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 44 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D44
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 45 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D45
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 46 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D46
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 47 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D47
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 48 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D48
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 49 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D49
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 50 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D50
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 51 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D51
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 52 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D52
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 53 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D53
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 54 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D54
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 55 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D55
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 56 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D56
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 57 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D57
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 58 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D58
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 59 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D59
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 60 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D60
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 61 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D61
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 62 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D62
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 63 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D63
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 64 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D64
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 65 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D65
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 66 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D66
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 67 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D67
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 68 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D68
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 69 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D69
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 70 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D70
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 71 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D71
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 72 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D72
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 73 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D73
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 74 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D74
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 75 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D75
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 76 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D76
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 77 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D77
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 78 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D78
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 79 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D79
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 80 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D80
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 81 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D81
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 82 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D82
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 83 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D83
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 84 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D84
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 85 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D85
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 86 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D86
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 87 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D87
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 88 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D88
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 89 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D89
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 90 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D90
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 91 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D91
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 92 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D92
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 93 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D93
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 94 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D94
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 95 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D95
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 96 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D96
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 97 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D97
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 98 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D98
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 99 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D99
					   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 100 THEN (CASE --WHEN B.CATEGORY_ID='P_IN_M' THEN CEILING(A.ADJUST_IN_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_JR' THEN CEILING(A.ADJUST_IN_QTY_JR)  2019-10-07 kimcd 행 제거
                                                            												    --WHEN B.CATEGORY_ID='P_IN_CELL' THEN CEILING(A.ADJUST_IN_QTY_CELL)  2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_IN_BATCH' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2)
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_M' THEN CEILING(A.ADJUST_OUT_QTY_M) 2019-10-07 kimcd 행 제거
                                                            												    WHEN B.CATEGORY_ID='P_OUT_JR' THEN CEILING(A.ADJUST_OUT_QTY_JR) 
                                                            												    WHEN B.CATEGORY_ID='P_OUT_CELL' THEN CEILING(A.ADJUST_OUT_QTY_CELL) 
                                                            												    --WHEN B.CATEGORY_ID='P_OUT_BATCH' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) 2019-10-07 kimcd 행 제거
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_M' THEN CEILING(A.MPP_OUT_QTY_M)  2019-08-15 kimcd MPP WPP 주석 처리
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_JR' THEN CEILING(A.MPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_CELL' THEN CEILING(A.MPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_MPP_OUT_BATCH' THEN ROUND(A.MPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_M' THEN CEILING(A.WPP_OUT_QTY_M) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_JR' THEN CEILING(A.WPP_OUT_QTY_JR) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_CELL' THEN CEILING(A.WPP_OUT_QTY_CELL) 
																											    --WHEN B.CATEGORY_ID='P_WPP_OUT_BATCH' THEN ROUND(A.WPP_OUT_QTY_BATCH,2) 
																											    --WHEN B.CATEGORY_ID='P_RESULT_OUT_M' THEN CEILING(A.RESULT_OUT_QTY_M) 2019-10-07 kimcd 행 제거
																											    WHEN B.CATEGORY_ID='P_RESULT_OUT_JR' THEN CEILING(A.RESULT_OUT_QTY_JR) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_CELL' THEN CEILING(A.RESULT_OUT_QTY_CELL) 
																												WHEN B.CATEGORY_ID='P_RESULT_OUT_BATCH' THEN ROUND(A.RESULT_OUT_QTY_BATCH,2) 
																												WHEN B.CATEGORY_ID='P_SEQ' THEN A.SEQ
                                                            													ELSE 0 END) ELSE 0 END) AS D100
					   -- 2019-08-12 kimcd setup_color add start
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 1 THEN A.SETUP_COLOR ELSE NULL END) AS S_C1
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 2 THEN A.SETUP_COLOR ELSE NULL END) AS S_C2
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 3 THEN A.SETUP_COLOR ELSE NULL END) AS S_C3
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 4 THEN A.SETUP_COLOR ELSE NULL END) AS S_C4
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 5 THEN A.SETUP_COLOR ELSE NULL END) AS S_C5
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 6 THEN A.SETUP_COLOR ELSE NULL END) AS S_C6
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 7 THEN A.SETUP_COLOR ELSE NULL END) AS S_C7
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 8 THEN A.SETUP_COLOR ELSE NULL END) AS S_C8
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 9 THEN A.SETUP_COLOR ELSE NULL END) AS S_C9
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 10 THEN A.SETUP_COLOR ELSE NULL END) AS S_C10 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 11 THEN A.SETUP_COLOR ELSE NULL END) AS S_C11 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 12 THEN A.SETUP_COLOR ELSE NULL END) AS S_C12 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 13 THEN A.SETUP_COLOR ELSE NULL END) AS S_C13 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 14 THEN A.SETUP_COLOR ELSE NULL END) AS S_C14 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 15 THEN A.SETUP_COLOR ELSE NULL END) AS S_C15 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 16 THEN A.SETUP_COLOR ELSE NULL END) AS S_C16 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 17 THEN A.SETUP_COLOR ELSE NULL END) AS S_C17 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 18 THEN A.SETUP_COLOR ELSE NULL END) AS S_C18 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 19 THEN A.SETUP_COLOR ELSE NULL END) AS S_C19 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 20 THEN A.SETUP_COLOR ELSE NULL END) AS S_C20 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 21 THEN A.SETUP_COLOR ELSE NULL END) AS S_C21 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 22 THEN A.SETUP_COLOR ELSE NULL END) AS S_C22 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 23 THEN A.SETUP_COLOR ELSE NULL END) AS S_C23 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 24 THEN A.SETUP_COLOR ELSE NULL END) AS S_C24 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 25 THEN A.SETUP_COLOR ELSE NULL END) AS S_C25 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 26 THEN A.SETUP_COLOR ELSE NULL END) AS S_C26 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 27 THEN A.SETUP_COLOR ELSE NULL END) AS S_C27 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 28 THEN A.SETUP_COLOR ELSE NULL END) AS S_C28 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 29 THEN A.SETUP_COLOR ELSE NULL END) AS S_C29 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 30 THEN A.SETUP_COLOR ELSE NULL END) AS S_C30 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 31 THEN A.SETUP_COLOR ELSE NULL END) AS S_C31 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 32 THEN A.SETUP_COLOR ELSE NULL END) AS S_C32 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 33 THEN A.SETUP_COLOR ELSE NULL END) AS S_C33 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 34 THEN A.SETUP_COLOR ELSE NULL END) AS S_C34 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 35 THEN A.SETUP_COLOR ELSE NULL END) AS S_C35 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 36 THEN A.SETUP_COLOR ELSE NULL END) AS S_C36 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 37 THEN A.SETUP_COLOR ELSE NULL END) AS S_C37 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 38 THEN A.SETUP_COLOR ELSE NULL END) AS S_C38 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 39 THEN A.SETUP_COLOR ELSE NULL END) AS S_C39 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 40 THEN A.SETUP_COLOR ELSE NULL END) AS S_C40 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 41 THEN A.SETUP_COLOR ELSE NULL END) AS S_C41 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 42 THEN A.SETUP_COLOR ELSE NULL END) AS S_C42 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 43 THEN A.SETUP_COLOR ELSE NULL END) AS S_C43 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 44 THEN A.SETUP_COLOR ELSE NULL END) AS S_C44 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 45 THEN A.SETUP_COLOR ELSE NULL END) AS S_C45 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 46 THEN A.SETUP_COLOR ELSE NULL END) AS S_C46 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 47 THEN A.SETUP_COLOR ELSE NULL END) AS S_C47 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 48 THEN A.SETUP_COLOR ELSE NULL END) AS S_C48 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 49 THEN A.SETUP_COLOR ELSE NULL END) AS S_C49 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 50 THEN A.SETUP_COLOR ELSE NULL END) AS S_C50 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 51 THEN A.SETUP_COLOR ELSE NULL END) AS S_C51 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 52 THEN A.SETUP_COLOR ELSE NULL END) AS S_C52 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 53 THEN A.SETUP_COLOR ELSE NULL END) AS S_C53 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 54 THEN A.SETUP_COLOR ELSE NULL END) AS S_C54 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 55 THEN A.SETUP_COLOR ELSE NULL END) AS S_C55 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 56 THEN A.SETUP_COLOR ELSE NULL END) AS S_C56 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 57 THEN A.SETUP_COLOR ELSE NULL END) AS S_C57 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 58 THEN A.SETUP_COLOR ELSE NULL END) AS S_C58 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 59 THEN A.SETUP_COLOR ELSE NULL END) AS S_C59 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 60 THEN A.SETUP_COLOR ELSE NULL END) AS S_C60 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 61 THEN A.SETUP_COLOR ELSE NULL END) AS S_C61 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 62 THEN A.SETUP_COLOR ELSE NULL END) AS S_C62 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 63 THEN A.SETUP_COLOR ELSE NULL END) AS S_C63 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 64 THEN A.SETUP_COLOR ELSE NULL END) AS S_C64 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 65 THEN A.SETUP_COLOR ELSE NULL END) AS S_C65 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 66 THEN A.SETUP_COLOR ELSE NULL END) AS S_C66 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 67 THEN A.SETUP_COLOR ELSE NULL END) AS S_C67 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 68 THEN A.SETUP_COLOR ELSE NULL END) AS S_C68 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 69 THEN A.SETUP_COLOR ELSE NULL END) AS S_C69 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 70 THEN A.SETUP_COLOR ELSE NULL END) AS S_C70 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 71 THEN A.SETUP_COLOR ELSE NULL END) AS S_C71 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 72 THEN A.SETUP_COLOR ELSE NULL END) AS S_C72 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 73 THEN A.SETUP_COLOR ELSE NULL END) AS S_C73 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 74 THEN A.SETUP_COLOR ELSE NULL END) AS S_C74 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 75 THEN A.SETUP_COLOR ELSE NULL END) AS S_C75 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 76 THEN A.SETUP_COLOR ELSE NULL END) AS S_C76 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 77 THEN A.SETUP_COLOR ELSE NULL END) AS S_C77 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 78 THEN A.SETUP_COLOR ELSE NULL END) AS S_C78 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 79 THEN A.SETUP_COLOR ELSE NULL END) AS S_C79 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 80 THEN A.SETUP_COLOR ELSE NULL END) AS S_C80 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 81 THEN A.SETUP_COLOR ELSE NULL END) AS S_C81 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 82 THEN A.SETUP_COLOR ELSE NULL END) AS S_C82 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 83 THEN A.SETUP_COLOR ELSE NULL END) AS S_C83 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 84 THEN A.SETUP_COLOR ELSE NULL END) AS S_C84 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 85 THEN A.SETUP_COLOR ELSE NULL END) AS S_C85 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 86 THEN A.SETUP_COLOR ELSE NULL END) AS S_C86 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 87 THEN A.SETUP_COLOR ELSE NULL END) AS S_C87 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 88 THEN A.SETUP_COLOR ELSE NULL END) AS S_C88 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 89 THEN A.SETUP_COLOR ELSE NULL END) AS S_C89 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 90 THEN A.SETUP_COLOR ELSE NULL END) AS S_C90 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 91 THEN A.SETUP_COLOR ELSE NULL END) AS S_C91 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 92 THEN A.SETUP_COLOR ELSE NULL END) AS S_C92 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 93 THEN A.SETUP_COLOR ELSE NULL END) AS S_C93 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 94 THEN A.SETUP_COLOR ELSE NULL END) AS S_C94 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 95 THEN A.SETUP_COLOR ELSE NULL END) AS S_C95 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 96 THEN A.SETUP_COLOR ELSE NULL END) AS S_C96 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 97 THEN A.SETUP_COLOR ELSE NULL END) AS S_C97 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 98 THEN A.SETUP_COLOR ELSE NULL END) AS S_C98 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 99 THEN A.SETUP_COLOR ELSE NULL END) AS S_C99 
                       , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 100 THEN A.SETUP_COLOR ELSE NULL END) AS S_C100 
					   -- 2019-08-12 kimcd setup_color add end
		        	   , B.CATEGORY_NAME 
		               , B.CATEGORY_ID
		               , B.CATEGORY_ORDER
		               , B.MEASURE_NAME 
		               , 'DATA' AS DATA_TYPE
		          FROM (
						SELECT A.INSTANCE_ID
							   , A.FP_PLAN_ID
							   , A.COMPANY_ID
							   , A.DIVISION_ID
							   , A.SITE_ID
							   , A.PLANT_ID
							   , A.FACTORY_ID
							   , A.LOCATION
							   , A.OPERATION_ID
							   , A.LINE_ID
							   , ISNULL(C.LINE_NAME,'-') AS LINE_NAME
							   , A.ELECTRODE_TYPE
							   , A.EQUIPMENT_ID
							   , A.PLAN_DATE
							   , A.TOP_ITEM_ID
							   , A.ITEM_ID
							   , ISNULL(B.NICK_NAME,'-') AS NICK_NAME
							   , A.PRODUCTION_TYPE
							   , A.MARKET
							   , A.SEQ
							   , A.ADJUST_IN_QTY_BATCH
							   --, A.ADJUST_IN_QTY 2019-10-07 kimcd 행 제거 시작
							   --, A.ADJUST_IN_QTY_M
							   --, A.ADJUST_IN_QTY_CELL
							   --, A.ADJUST_IN_QTY_JR
							   --, A.ADJUST_OUT_QTY_BATCH
							   --, A.ADJUST_OUT_QTY
							   --, A.ADJUST_OUT_QTY_M 2019-10-07 kimcd 행 제거 종료
							   , A.ADJUST_OUT_QTY_CELL
							   , A.ADJUST_OUT_QTY_JR
							   --, A.MPP_IN_QTY_BATCH 2019-10-07 kimcd 행 제거 시작
							   --, A.MPP_IN_QTY
							   --, A.MPP_IN_QTY_M
							   --, A.MPP_IN_QTY_CELL
							   --, A.MPP_IN_QTY_JR
							   --, A.MPP_OUT_QTY_BATCH
							   --, A.MPP_OUT_QTY
							   --, A.MPP_OUT_QTY_M
							   --, A.MPP_OUT_QTY_CELL
							   --, A.MPP_OUT_QTY_JR
							   --, A.WPP_IN_QTY_BATCH
							   --, A.WPP_IN_QTY
							   --, A.WPP_IN_QTY_M
							   --, A.WPP_IN_QTY_CELL
							   --, A.WPP_IN_QTY_JR
							   --, A.WPP_OUT_QTY_BATCH
							   --, A.WPP_OUT_QTY
							   --, A.WPP_OUT_QTY_M
							   --, A.WPP_OUT_QTY_CELL
							   --, A.WPP_OUT_QTY_JR
							   --, A.RESULT_IN_QTY_BATCH
							   --, A.RESULT_IN_QTY
							   --, A.RESULT_IN_QTY_M
							   --, A.RESULT_IN_QTY_CELL
							   --, A.RESULT_IN_QTY_JR 2019-10-07 kimcd 행 제거 종료
							   , A.RESULT_OUT_QTY_BATCH
							   --, A.RESULT_OUT_QTY 2019-10-07 kimcd 행 제거
							   --, A.RESULT_OUT_QTY_M 2019-10-07 kimcd 행 제거
							   , A.RESULT_OUT_QTY_CELL
							   , A.RESULT_OUT_QTY_JR
							   --, A.TOTAL_BATCH 2019-10-07 kimcd 행 제거
							   , A.BGCOLOR
							   , C.PROD_VERSION_TYPE
							   , D.SETUP_COLOR -- 2019-08-12 kimcd setup_color add
						  FROM (
								SELECT A.INSTANCE_ID
									   , A.FP_PLAN_ID
									   , A.COMPANY_ID
									   , A.DIVISION_ID
									   , A.SITE_ID
									   , A.PLANT_ID
									   , A.FACTORY_ID
									   , A.LOCATION
									   , A.OPERATION_ID
									   , A.LINE_ID
									   , A.ELECTRODE_TYPE
									   , A.EQUIPMENT_ID
									   , A.PLAN_DATE
									   , A.TOP_ITEM_ID, A.ITEM_ID
									   , A.PRODUCTION_TYPE
									   , A.MARKET
									   , A.SEQ
									   , A.ADJUST_IN_QTY_BATCH
									   --, A.ADJUST_IN_QTY 2019-10-07 kimcd 행 제거 시작
									   --, A.ADJUST_IN_QTY_M
									   --, A.ADJUST_IN_QTY_CELL
									   --, A.ADJUST_IN_QTY_JR
									   --, A.ADJUST_OUT_QTY_BATCH
									   --, A.ADJUST_OUT_QTY
									   --, A.ADJUST_OUT_QTY_M 2019-10-07 kimcd 행 제거 끝
									   , A.ADJUST_OUT_QTY_CELL
									   , A.ADJUST_OUT_QTY_JR
									   --, A.MPP_IN_QTY_BATCH 2019-10-07 kimcd 행 제거 시작
									   --, A.MPP_IN_QTY
									   --, A.MPP_IN_QTY_M
									   --, A.MPP_IN_QTY_CELL
									   --, A.MPP_IN_QTY_JR
									   --, A.MPP_OUT_QTY_BATCH
									   --, A.MPP_OUT_QTY
									   --, A.MPP_OUT_QTY_M
									   --, A.MPP_OUT_QTY_CELL
									   --, A.MPP_OUT_QTY_JR
									   --, A.WPP_IN_QTY_BATCH
									   --, A.WPP_IN_QTY
									   --, A.WPP_IN_QTY_M
									   --, A.WPP_IN_QTY_CELL
									   --, A.WPP_IN_QTY_JR
									   --, A.WPP_OUT_QTY_BATCH
									   --, A.WPP_OUT_QTY
									   --, A.WPP_OUT_QTY_M
									   --, A.WPP_OUT_QTY_CELL
									   --, A.WPP_OUT_QTY_JR
									   --, A.RESULT_IN_QTY_BATCH
									   --, A.RESULT_IN_QTY
									   --, A.RESULT_IN_QTY_M
									   --, A.RESULT_IN_QTY_CELL
									   --, A.RESULT_IN_QTY_JR 2019-10-07 kimcd 행 제거 끝
									   , A.RESULT_OUT_QTY_BATCH
									   --, A.RESULT_OUT_QTY 2019-10-07 kimcd 행 제거
									   --, A.RESULT_OUT_QTY_M 2019-10-07 kimcd 행 제거
									   , A.RESULT_OUT_QTY_CELL
									   , A.RESULT_OUT_QTY_JR
									   --, A.TOTAL_BATCH  2019-10-07 kimcd 행 제거
									   , A.SETUP_COLOR_CODE  -- 2019-08-12 kimcd setup_color add
									   , NULL AS BGCOLOR
								  FROM FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)
									  ,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)  -- 2021-04-22 kimcd production type 조건 추가
								 WHERE A.OPERATION_ID   = 'E2000'
								 AND  A.DIVISION_ID = SLV.SEGMENT1
								 AND  A.PRODUCTION_TYPE = SLV.ATTRIBUTE2
								 AND  SLV.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
								 AND  SLV.ACTIVE_FLAG = 'Y'
							   ) A
							   INNER JOIN SCM_ITEM_M B WITH(NOLOCK)
									   ON A.COMPANY_ID     = B.COMPANY_ID
						              AND A.DIVISION_ID    = B.DIVISION_ID
						              AND A.SITE_ID        = B.SITE_ID
						              AND A.TOP_ITEM_ID    = B.ITEM_ID
							   INNER JOIN SCM_LINE_M C WITH(NOLOCK)
									   ON A.COMPANY_ID     = C.COMPANY_ID
						              AND A.DIVISION_ID    = C.DIVISION_ID
						              AND A.SITE_ID        = C.SITE_ID
						              AND A.PLANT_ID       = C.PLANT_ID
						              AND A.FACTORY_ID     = C.FACTORY_ID
						              AND A.OPERATION_ID   = C.OPERATION_ID
						              AND A.LINE_ID        = C.LINE_ID
						              AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
							   LEFT OUTER JOIN (
			              					SELECT D.SEGMENT1 AS INSTANCE_ID, D.SEGMENT2 AS SETUP_COLOR_CODE, D.SEGMENT3 AS SETUP_COLOR_NAME, D.SEGMENT4 AS SETUP_COLOR, D.SORT_ORDER
											FROM   SCM_SYS_LOOKUP_VALUE D WITH(NOLOCK)
											WHERE  D.LOOKUP_TYPE_CODE = 'UI_AMEND_COLOR'
											AND    D.ACTIVE_FLAG = 'Y'
							                   ) D   -- 2019-08-12 kimcd setup_color add
								  ON A.INSTANCE_ID = D.INSTANCE_ID
								  AND A.SETUP_COLOR_CODE = D.SETUP_COLOR_CODE

			           ) A
			           INNER JOIN DA DA
							   ON A.SITE_ID   = DA.SITE_ID
							  AND A.PLAN_DATE = DA.DATE_ID
					   INNER JOIN (
									SELECT * 
									  FROM (
											--SELECT 'P_MPP_OUT_M' AS CATEGORY_ID, 'M(P/C)' AS MEASURE_NAME, 'MPP(Out)' AS CATEGORY_NAME, 2.7 AS CATEGORY_ORDER  2019-08-15 kimcd MPP WPP 주석 처리
											--UNION ALL                                                                                              
											--SELECT 'P_MPP_OUT_JR' AS CATEGORY_ID, 'J/R' AS MEASURE_NAME, 'MPP(Out)' AS CATEGORY_NAME, 2.6 AS CATEGORY_ORDER
											--UNION ALL                                                                                              
											--SELECT 'P_MPP_OUT_CELL' AS CATEGORY_ID, 'Cell' AS MEASURE_NAME, 'MPP(Out)' AS CATEGORY_NAME, 2.8 AS CATEGORY_ORDER
											--UNION ALL                                                                                              
											--SELECT 'P_MPP_OUT_BATCH' AS CATEGORY_ID, 'Batch' AS MEASURE_NAME, 'MPP(Out)' AS CATEGORY_NAME, 2.5 AS CATEGORY_ORDER
											--UNION ALL                                                                                              
											--SELECT 'P_WPP_OUT_M' AS CATEGORY_ID, 'M(P/C)' AS MEASURE_NAME, 'WPP(Out)' AS CATEGORY_NAME, 3.7 AS CATEGORY_ORDER
											--UNION ALL                                                                                              
											--SELECT 'P_WPP_OUT_JR' AS CATEGORY_ID, 'J/R' AS MEASURE_NAME, 'WPP(Out)' AS CATEGORY_NAME, 3.6 AS CATEGORY_ORDER
											--UNION ALL                                                                                              
											--SELECT 'P_WPP_OUT_CELL' AS CATEGORY_ID, 'Cell' AS MEASURE_NAME, 'WPP(Out)' AS CATEGORY_NAME, 3.8 AS CATEGORY_ORDER
											--UNION ALL                                                                                              
											--SELECT 'P_WPP_OUT_BATCH' AS CATEGORY_ID, 'Batch' AS MEASURE_NAME, 'WPP(Out)' AS CATEGORY_NAME, 3.5 AS CATEGORY_ORDER
											--UNION ALL                                                                                              
											--2019-10-07 kimcd 행 제거 시작 
											--SELECT 'P_IN_M' AS CATEGORY_ID, 'M(P/C)' AS MEASURE_NAME, 'Plan(In)' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER
											--UNION ALL                                                                                              
											--SELECT 'P_IN_JR' AS CATEGORY_ID, 'J/R' AS MEASURE_NAME, 'Plan(In)' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER        
											--UNION ALL                                                                                              
											--SELECT 'P_IN_CELL' AS CATEGORY_ID, 'Cell' AS MEASURE_NAME, 'Plan(In)' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER     
											--UNION ALL                                                                                              
											--2019-10-07 kimcd 행 제거 끝 
											SELECT 'P_IN_BATCH' AS CATEGORY_ID, 'Batch' AS MEASURE_NAME, 'Plan(In)' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER   
											UNION ALL 
											SELECT 'P_SEQ' AS CATEGORY_ID, '' AS MEASURE_NAME, 'Seq' AS CATEGORY_NAME, 45 AS CATEGORY_ORDER		 
											--UNION ALL 2019-10-07 kimcd 행 제거                                                                                             
											--SELECT 'P_OUT_M' AS CATEGORY_ID, 'M(P/C)' AS MEASURE_NAME, 'Plan(Out)' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER    
											UNION ALL                                                                                              
											SELECT 'P_OUT_JR' AS CATEGORY_ID, 'J/R' AS MEASURE_NAME, 'Plan(Out)' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER      
											UNION ALL                                                                                              
											SELECT 'P_OUT_CELL' AS CATEGORY_ID, 'Cell' AS MEASURE_NAME, 'Plan(Out)' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER   
											--UNION ALL 2019-10-07 kimcd 행 제거                                                                                             
											--SELECT 'P_OUT_BATCH' AS CATEGORY_ID, 'Batch' AS MEASURE_NAME, 'Plan(Out)' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER 
											--UNION ALL 2019-10-07 kimcd 행 제거
											--SELECT 'P_RESULT_OUT_M' AS CATEGORY_ID, 'M(P/C)' AS MEASURE_NAME, 'Result(Out)' AS CATEGORY_NAME, 370 AS CATEGORY_ORDER		 
											UNION ALL 
											SELECT 'P_RESULT_OUT_JR' AS CATEGORY_ID, 'J/R' AS MEASURE_NAME, 'Result(Out)' AS CATEGORY_NAME, 360 AS CATEGORY_ORDER		 
											UNION ALL 
											SELECT 'P_RESULT_OUT_CELL' AS CATEGORY_ID, 'Cell' AS MEASURE_NAME, 'Result(Out)' AS CATEGORY_NAME, 380 AS CATEGORY_ORDER		 
											UNION ALL 
											SELECT 'P_RESULT_OUT_BATCH' AS CATEGORY_ID, 'Batch' AS MEASURE_NAME, 'Result(Out)' AS CATEGORY_NAME, 350 AS CATEGORY_ORDER
											UNION ALL 
											SELECT 'Yield' AS CATEGORY_ID, 'Yield' AS MEASURE_NAME, 'Yield' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER
										   ) A
									 WHERE CATEGORY_ID <> 'X'
								  ) B
							   ON 1=1
				 GROUP BY A.INSTANCE_ID
					   , A.FP_PLAN_ID
					   , A.COMPANY_ID
					   , A.DIVISION_ID
					   , A.SITE_ID
					   , A.PLANT_ID
					   , A.FACTORY_ID
					   , A.LOCATION
					   , A.OPERATION_ID
					   , A.LINE_ID
					   , A.LINE_NAME
					   , A.ELECTRODE_TYPE
					   , A.EQUIPMENT_ID
					   , A.ITEM_ID
					   , A.TOP_ITEM_ID
					   , A.NICK_NAME
					   , A.PRODUCTION_TYPE
					   , A.MARKET
					   , A.PROD_VERSION_TYPE
					   , B.CATEGORY_ID
					   , B.CATEGORY_NAME
					   , B.CATEGORY_ORDER
					   , B.MEASURE_NAME
		      ) A
	    	  LEFT OUTER JOIN (
									SELECT   DISTINCT
									         A.INSTANCE_ID
									       , A.FP_PLAN_ID
									       , A.COMPANY_ID
										   , A.DIVISION_ID
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
							               , A.LOCATION
										   , A.OPERATION_ID
										   , A.LINE_ID
										   , A.ELECTRODE_TYPE
										   , A.EQUIPMENT_ID
							               , A.TOP_ITEM_ID
										   , A.ITEM_ID
							               , ROUND(A.DAILY_CAPA_M,0) AS DAILY_CAPA_M
							               , ROUND(A.DAILY_CAPA_EA,0) AS DAILY_CAPA_EA
							               , ROUND(A.DAILY_CAPA_KG,0) AS DAILY_CAPA_KG
							               , ROUND(A.DAILY_CAPA_JR,0) AS DAILY_CAPA_JR
							               , ROUND(A.DAILY_CAPA_BATCH,2) AS DAILY_CAPA_BATCH
							               , CAPA_VALIDATION_FLAG AS DC_FLAG
							               , A.CALC_TYPE
						              FROM FP_AMEND_DAILY_CAPA_R A WITH(NOLOCK)
							         WHERE A.OPERATION_ID   = 'E2000'
							       ) D
							    ON A.INSTANCE_ID    = D.INSTANCE_ID
							   AND A.FP_PLAN_ID     = D.FP_PLAN_ID
							   AND A.COMPANY_ID		= D.COMPANY_ID
							   AND A.DIVISION_ID	= D.DIVISION_ID
							   AND A.SITE_ID		= D.SITE_ID
							   AND A.PLANT_ID		= D.PLANT_ID
							   AND A.FACTORY_ID		= D.FACTORY_ID
							   AND A.LOCATION		= D.LOCATION
							   AND A.OPERATION_ID	= D.OPERATION_ID
							   AND A.LINE_ID		= D.LINE_ID
							   AND A.ELECTRODE_TYPE	= D.ELECTRODE_TYPE
							   AND A.EQUIPMENT_ID	= D.EQUIPMENT_ID
					           AND A.ITEM_ID		= D.ITEM_ID
							   AND (CASE WHEN (A.PRODUCTION_TYPE LIKE '%TEST%') THEN 'TEST' ELSE 'MASS' END) = D.CALC_TYPE  -- kimcd 2019-12-09 테스트 조건 LIKE로 수정
			  LEFT OUTER /*HASH*/ JOIN (
									SELECT A.COMPANY_ID
										   , A.DIVISION_ID
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
										   , A.PROD_VERSION_TYPE
										   , A.PROD_TYPE
										   , MAX(A.PAN_PROD_VERSION)  AS PROD_VERSION
										   , A.PC_ITEM_ID
										   , A.MODEL_ID
										   , NULL AS BATCH_ID
										   , MAX(CASE WHEN A.UI_COLUMN = 'Slurry 1' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_1
										   , MAX(CASE WHEN A.UI_COLUMN = 'Slurry 2' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_2
										   , MAX(CASE WHEN A.UI_COLUMN = 'Active Material 1' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1
										   , MAX(CASE WHEN A.UI_COLUMN = 'Active Material 2' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2
										   , MAX(CASE WHEN A.UI_COLUMN = 'Active Material 3' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3
										   , MAX(CASE WHEN A.UI_COLUMN = 'Binder 1' THEN A.DESCRIPTION END) AS BINDER_1
										   , MAX(CASE WHEN A.UI_COLUMN = 'Binder 2' THEN A.DESCRIPTION END) AS BINDER_2
										   , MAX(CASE WHEN A.UI_COLUMN = 'Binder 3' THEN A.DESCRIPTION END) AS BINDER_3
										   , MAX(CASE WHEN A.CLASS_NAME = 'Pre Dispersion Slurry' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID
										   , MAX(CASE WHEN A.CLASS_NAME = 'Pre Dispersion Slurry' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME
										   , MAX(CASE WHEN A.CLASS_NAME = 'CMC' then A.DESCRIPTION END) AS CMC
										   , MAX(CASE WHEN A.UI_COLUMN = 'Conducting Material 1' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1
										   , MAX(CASE WHEN A.UI_COLUMN = 'Conducting Material 2' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2
									  FROM SCM_PANCAKE_MATERIAL_V A  WITH(NOLOCK)
									 GROUP BY A.COMPANY_ID
										   , A.DIVISION_ID
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
										   , A.PROD_VERSION_TYPE
										   , A.PROD_TYPE
										   , A.PC_ITEM_ID
										   , A.MODEL_ID
								   ) E
								ON A.COMPANY_ID			= E.COMPANY_ID
					           AND A.DIVISION_ID		= E.DIVISION_ID
							   AND A.SITE_ID			= E.SITE_ID
							   AND A.PLANT_ID			= E.PLANT_ID
							   AND A.FACTORY_ID			= E.FACTORY_ID
							   AND A.ITEM_ID			= E.PC_ITEM_ID
							   AND A.PROD_VERSION_TYPE	= E.PROD_VERSION_TYPE
					           AND (CASE WHEN (A.PRODUCTION_TYPE LIKE '%TEST%') THEN 'TEST' ELSE 'MASS' END) = E.PROD_TYPE  -- kimcd 2019-12-09 테스트 조건 LIKE로 수정
			  LEFT OUTER /*HASH*/ JOIN (
					          		SELECT A.COMPANY_ID
										   , A.DIVISION_ID
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
										   , A.PROD_VERSION_TYPE
										   , A.PROD_TYPE
										   , MAX(A.PAN_PROD_VERSION)  AS PROD_VERSION
										   , A.PC_ITEM_ID
										   , A.MODEL_ID
										   , NULL AS BATCH_ID
										   , MAX(CASE WHEN A.UI_COLUMN = 'Slurry 1' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_1
										   , MAX(CASE WHEN A.UI_COLUMN = 'Slurry 2' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_2
										   , MAX(CASE WHEN A.UI_COLUMN = 'Active Material 1' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1
										   , MAX(CASE WHEN A.UI_COLUMN = 'Active Material 2' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2
										   , MAX(CASE WHEN A.UI_COLUMN = 'Active Material 3' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3
										   , MAX(CASE WHEN A.UI_COLUMN = 'Binder 1' THEN A.DESCRIPTION END) AS BINDER_1
										   , MAX(CASE WHEN A.UI_COLUMN = 'Binder 2' THEN A.DESCRIPTION END) AS BINDER_2
										   , MAX(CASE WHEN A.UI_COLUMN = 'Binder 3' THEN A.DESCRIPTION END) AS BINDER_3
										   , MAX(CASE WHEN A.CLASS_NAME = 'Pre Dispersion Slurry' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID
										   , MAX(CASE WHEN A.CLASS_NAME = 'Pre Dispersion Slurry' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME
										   , MAX(CASE WHEN A.CLASS_NAME = 'CMC' then A.DESCRIPTION END) AS CMC
										   , MAX(CASE WHEN A.UI_COLUMN = 'Conducting Material 1' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1
										   , MAX(CASE WHEN A.UI_COLUMN = 'Conducting Material 2' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2
									  FROM SCM_PANCAKE_MATERIAL_V A WITH(NOLOCK)
									 GROUP BY A.COMPANY_ID
										   , A.DIVISION_ID
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
										   , A.PROD_VERSION_TYPE
										   , A.PROD_TYPE
										   , A.PC_ITEM_ID
										   , A.MODEL_ID
								   ) F
					            ON A.COMPANY_ID			= F.COMPANY_ID
							   AND A.DIVISION_ID		= F.DIVISION_ID
							   AND A.SITE_ID			= F.SITE_ID
							   AND A.PLANT_ID			= F.PLANT_ID
							   AND A.FACTORY_ID			= F.FACTORY_ID
							   AND A.ITEM_ID			= F.PC_ITEM_ID
							   AND A.PROD_VERSION_TYPE	= F.PROD_VERSION_TYPE
							   AND (CASE WHEN (A.PRODUCTION_TYPE LIKE '%TEST%') THEN 'TEST' ELSE 'MASS' END) <> F.PROD_TYPE -- kimcd 2019-12-09 테스트 조건 LIKE로 수정
			  LEFT OUTER JOIN (
								SELECT A.COMPANY_ID
									   , A.DIVISION_ID
									   , A.SITE_ID
									   , A.PLANT_ID
									   , A.FACTORY_ID
									   , A.OPERATION_ID
									   , A.LINE_ID
									   , A.ELECTRODE_TYPE
									   , A.ITEM_ID
									   , MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/A.TACT_TIME, 0) ELSE 0 END) DAILY_CAPA_PPM
					       			   , MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/(A.TACT_TIME*2), 0) ELSE 0 END) DAILY_CAPA_PPM2
								  FROM SCM_TACT_TIME_M A WITH(NOLOCK)
								 WHERE A.OPERATION_ID   = 'E2000'
								   AND A.MONTH = CONVERT(NVARCHAR(6), GETDATE(), 112)
								 GROUP BY A.COMPANY_ID
									   , A.DIVISION_ID
									   , A.SITE_ID
									   , A.PLANT_ID
									   , A.FACTORY_ID
									   , A.OPERATION_ID
									   , A.LINE_ID
									   , A.ELECTRODE_TYPE
									   , A.ITEM_ID
							  ) Z
						   ON A.COMPANY_ID		= Z.COMPANY_ID
						  AND A.DIVISION_ID		= Z.DIVISION_ID
						  AND A.SITE_ID			= Z.SITE_ID
						  AND A.PLANT_ID		= Z.PLANT_ID
						  AND A.FACTORY_ID		= Z.FACTORY_ID
						  AND A.OPERATION_ID	= Z.OPERATION_ID
						  AND A.LINE_ID			= Z.LINE_ID
						  AND A.ELECTRODE_TYPE	= Z.ELECTRODE_TYPE
						  AND A.ITEM_ID			= Z.ITEM_ID
			  LEFT OUTER /*HASH*/ JOIN (
									SELECT A.COMPANY_ID
										   , A.DIVISION_ID
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
										   , A.ITEM_ID
										   , A.FOIL_CODE
										   , B.ITEM_NAME AS FOIL
										   , A.PROD_VERSION_TYPE
										   , A.PROD_TYPE  -- PROD_TYPE kimcd 2019-12-09
									  FROM ( 
											SELECT A.COMPANY_ID
												   , A.DIVISION_ID
												   , A.SITE_ID
												   , A.PLANT_ID
												   , A.FACTORY_ID
												   , A.ITEM_ID
												   , A.FOIL_ID AS FOIL_CODE
												   , A.PROD_VERSION_TYPE
												   , CASE WHEN LEFT(V.[PROD_VERSION], 1) = 'Z' THEN 'TEST' ELSE 'MASS' END AS PROD_TYPE  -- kimcd 2019-12-09
												   ,ROW_NUMBER() OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE
												                                   , CASE WHEN LEFT(V.[PROD_VERSION], 1) = 'Z' THEN 'TEST' ELSE 'MASS' END -- kimcd 2019-12-09
																			ORDER BY V.APPLY_DATE DESC )	 AS NUM
											  FROM SCM_ITEM_FOIL_M			A WITH(NOLOCK)
												   , FP_PROD_VERSION_M		V WITH(NOLOCK)
											 WHERE A.FACTORY_ID		= V.FACTORY_ID
											   AND A.MODEL_ID		= V.MODEL_ID
											   AND A.ITEM_ID		= V.ITEM_ID
											   AND A.PROD_VERSION	= V.PROD_VERSION
											   AND A.PROD_SEQ		= V.PROD_SEQ
										   ) A
										   , SCM_ITEM_M				B WITH(NOLOCK)
										WHERE  A.NUM         = 1
									    AND    A.COMPANY_ID	 = B.COMPANY_ID
										AND    A.DIVISION_ID = B.DIVISION_ID
										AND    A.SITE_ID	 = B.SITE_ID
										AND    A.FOIL_CODE	 = B.ITEM_ID
								   ) G
					            ON A.COMPANY_ID      = G.COMPANY_ID
					  	       AND A.DIVISION_ID     = G.DIVISION_ID
					  	       AND A.SITE_ID         = G.SITE_ID
					  	       AND A.PLANT_ID        = G.PLANT_ID
					  	       AND A.FACTORY_ID      = G.FACTORY_ID
						   	   AND A.ITEM_ID         = G.ITEM_ID
							   AND A.PROD_VERSION_TYPE = G.PROD_VERSION_TYPE
							   AND (CASE WHEN (A.PRODUCTION_TYPE LIKE '%TEST%') THEN 'TEST' ELSE 'MASS' END) = G.PROD_TYPE  -- kimcd 2019-12-09
			  -- 2019-08-12 kimcd daily capa add end
			  LEFT OUTER /*HASH*/ JOIN (
		        					SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
					          			 , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
					          			 , A.ITEM_ID
							        	 , MAX(ROUND(A.DAILY_CAPA_M,0)) AS DAILY_CAPA_M
							        	 , MAX(ROUND(A.DAILY_CAPA_EA,0)) AS DAILY_CAPA_EA
							        	 , MAX(ROUND(A.DAILY_CAPA_KG,0)) AS DAILY_CAPA_KG
							        	 , MAX(ROUND(A.DAILY_CAPA_JR,0)) AS DAILY_CAPA_JR
							        	 , MAX(ROUND(A.DAILY_CAPA_BATCH,3)) AS DAILY_CAPA_BATCH
							        	 , MAX(CAPA_VALIDATION_FLAG) AS DC_FLAG
									FROM   FP_AMEND_DAILY_CAPA_R A WITH(NOLOCK)
									WHERE  A.OPERATION_ID   = 'E2000'
									GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
										   , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
									       , A.ITEM_ID
									) H
				ON  A.INSTANCE_ID     = H.INSTANCE_ID
				AND A.FP_PLAN_ID      = H.FP_PLAN_ID
				AND A.COMPANY_ID      = H.COMPANY_ID
				AND A.DIVISION_ID     = H.DIVISION_ID
				AND A.SITE_ID         = H.SITE_ID
				AND A.PLANT_ID        = H.PLANT_ID
				AND A.FACTORY_ID      = H.FACTORY_ID
				AND A.LOCATION        = H.LOCATION
				AND A.OPERATION_ID    = H.OPERATION_ID
				AND A.LINE_ID         = H.LINE_ID
				AND A.ELECTRODE_TYPE  = H.ELECTRODE_TYPE
				AND A.EQUIPMENT_ID    = H.EQUIPMENT_ID
				AND A.ITEM_ID         = H.ITEM_ID
              -- 2019-08-12 kimcd daily capa add end
		  	  LEFT OUTER JOIN (
								SELECT A.INSTANCE_ID
									   , A.FP_PLAN_ID
									   , A.COMPANY_ID
									   , A.DIVISION_ID
									   , A.SITE_ID
									   , A.PLANT_ID
									   , A.FACTORY_ID
									   , A.LOCATION
									   , A.OPERATION_ID
									   , A.LINE_ID
									   , A.TOP_ITEM_ID
									   , A.ITEM_ID
									   , A.PRODUCTION_TYPE
									   , A.MARKET
									   , MIN(LINE_SEQ) LINE_SEQ
								  FROM (
										SELECT A.INSTANCE_ID
											   , A.FP_PLAN_ID
											   , A.COMPANY_ID
											   , A.DIVISION_ID
											   , A.SITE_ID
											   , A.PLANT_ID
											   , A.FACTORY_ID
											   , A.LOCATION
											   , A.OPERATION_ID
											   , A.LINE_ID
											   , A.PLAN_DATE
											   , A.TOP_ITEM_ID
											   , A.ITEM_ID
											   , A.PRODUCTION_TYPE, A.MARKET
											   , A.SEQ
											   , RANK() OVER ( PARTITION BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID -- 2019-10-03 kimcd A.INSTANCE_ID, A.FP_PLAN_ID 추가
																   ORDER BY A.PLAN_DATE, A.SEQ ) LINE_SEQ
										  FROM FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)
											  ,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)  -- 2021-04-22 kimcd production type 조건 추가
										 WHERE A.OPERATION_ID   = 'E2000'
										   AND A.DIVISION_ID = SLV.SEGMENT1
										   AND A.PRODUCTION_TYPE = SLV.ATTRIBUTE2
										   AND SLV.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
										   AND SLV.ACTIVE_FLAG = 'Y'  -- 2021-04-22 kimcd production type 조건 추가
										   AND ISNULL(A.SEQ, 0) <> 0 
										   AND A.ADJUST_IN_QTY_BATCH > 0
										   AND A.PLAN_DATE >= ( SELECT TOP 1
																	   CONVERT( DATE, DBO.FN_SITE_TIME (DA.SITE_ID) ) AS FROM_DATE
																FROM   SCM_SITE_M DA WITH(NOLOCK)
																WHERE  DA.SITE_ID = A.SITE_ID )  -- 2019-10-03 kimcd 현재일 이후 구간에서만 순서 채번
									   ) A
								 GROUP BY A.INSTANCE_ID
									   , A.FP_PLAN_ID
									   , A.COMPANY_ID
									   , A.DIVISION_ID
									   , A.SITE_ID
									   , A.PLANT_ID
									   , A.FACTORY_ID
									   , A.LOCATION
									   , A.OPERATION_ID
									   , A.LINE_ID
									   , A.TOP_ITEM_ID
									   , A.ITEM_ID
									   , A.PRODUCTION_TYPE
									   , A.MARKET
							  ) B
             			   ON A.INSTANCE_ID		= B.INSTANCE_ID
						  AND A.FP_PLAN_ID		= B.FP_PLAN_ID
						  AND A.COMPANY_ID		= B.COMPANY_ID
						  AND A.DIVISION_ID		= B.DIVISION_ID
						  AND A.SITE_ID			= B.SITE_ID
						  AND A.PLANT_ID		= B.PLANT_ID
						  AND A.FACTORY_ID		= B.FACTORY_ID
						  AND A.LOCATION		= B.LOCATION
						  AND A.OPERATION_ID	= B.OPERATION_ID
						  AND A.LINE_ID			= B.LINE_ID
						  AND A.TOP_ITEM_ID		= B.TOP_ITEM_ID
						  AND A.ITEM_ID			= B.ITEM_ID
						  AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
						  AND A.MARKET			= B.MARKET
	)
	SELECT A.INSTANCE_ID
		   , A.FP_PLAN_ID
		   , A.COMPANY_ID
		   , A.DIVISION_ID
		   , A.SITE_ID
		   , A.PLANT_ID
		   , A.FACTORY_ID
		   , A.LOCATION
		   , A.OPERATION_ID
		   , A.LINE_ID
		   , A.LINE_NAME
		   , A.ELECTRODE_TYPE
		   , A.EQUIPMENT_ID
		   , A.ITEM_ID
		   , A.TOP_ITEM_ID
		   , A.NICK_NAME
		   , A.PRODUCTION_TYPE
		   , A.MARKET
		   , A.BATCH_ID    AS SLURRY
		   , A.BATCH_ID_2  AS SLURRY_2
		   , A.PRE_DISPERSION_ID
		   , A.PRE_DISPERSION_NAME
		   , A.ACTIVE_MATERIAL_1
		   , A.ACTIVE_MATERIAL_2
		   , A.ACTIVE_MATERIAL_3
		   , A.BINDER_1
		   , A.BINDER_2
		   , A.BINDER_3
		   , A.CMC
		   , A.PC_MODEL_ID
		   , A.FOIL_CODE
		   , A.FOIL
		   , A.DC_PPM
		   -- 2019-08-12 kimcd daily capa add start
	       , A.DC_M
	       , A.DC_CELL
	       , A.DC_KG
	       , A.DC_JR
	       , A.DC_BATCH
	       , A.DC_FLAG
		   -- 2019-08-12 kimcd daily capa add end
		   , A.[VERSION]
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), B.DATE_ID, 112))
								  ELSE D1 END 	AS D1
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,1,B.DATE_ID), 112))
								  ELSE D2 END 	AS D2
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,2,B.DATE_ID), 112))
								  ELSE D3 END 	AS D3 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,3,B.DATE_ID), 112))
								  ELSE D4 END 	AS D4 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,4,B.DATE_ID), 112))
								  ELSE D5 END 	AS D5 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,5,B.DATE_ID), 112))
								  ELSE D6 END 	AS D6 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,6,B.DATE_ID), 112))
								  ELSE D7 END 	AS D7 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,7,B.DATE_ID), 112))
								  ELSE D8 END 	AS D8 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,8,B.DATE_ID), 112))
								  ELSE D9 END 	AS D9 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,9,B.DATE_ID), 112))
								  ELSE D10 END 	AS D10 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,10,B.DATE_ID), 112))
								  ELSE D11 END 	AS D11 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,11,B.DATE_ID), 112))
								  ELSE D12 END 	AS D12 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,12,B.DATE_ID), 112))
								  ELSE D13 END 	AS D13
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,13,B.DATE_ID), 112))
								  ELSE D14 END 	AS D14 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,14,B.DATE_ID), 112))
								  ELSE D15 END 	AS D15 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,15,B.DATE_ID), 112))
								  ELSE D16 END 	AS D16 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM  SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,16,B.DATE_ID), 112))
								  ELSE D17 END 	AS D17 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,17,B.DATE_ID), 112))
								  ELSE D18 END 	AS D18 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,18,B.DATE_ID), 112))
								  ELSE D19 END 	AS D19 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,19,B.DATE_ID), 112))
								  ELSE D20 END 	AS D20 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,20,B.DATE_ID), 112))
								  ELSE D21 END 	AS D21 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,21,B.DATE_ID), 112))
								  ELSE D22 END 	AS D22 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,22,B.DATE_ID), 112))
								  ELSE D23 END 	AS D23 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,23,B.DATE_ID), 112))
								  ELSE D24 END 	AS D24 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,24,B.DATE_ID), 112))
								  ELSE D25 END 	AS D25 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,25,B.DATE_ID), 112))
								  ELSE D26 END 	AS D26 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,26,B.DATE_ID), 112))
								  ELSE D27 END 	AS D27 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,27,B.DATE_ID), 112))
								  ELSE D28 END 	AS D28 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,28,B.DATE_ID), 112))
								  ELSE D29 END 	AS D29 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,29,B.DATE_ID), 112))
								  ELSE D30 END 	AS D30 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,30,B.DATE_ID), 112))
								  ELSE D31 END 	AS D31 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,31,B.DATE_ID), 112))
								  ELSE D32 END 	AS D32 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,32,B.DATE_ID), 112))
								  ELSE D33 END 	AS D33 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,33,B.DATE_ID), 112))
								  ELSE D34 END 	AS D34 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,34,B.DATE_ID), 112))
								  ELSE D35 END 	AS D35 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,35,B.DATE_ID), 112))
								  ELSE D36 END 	AS D36 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,36,B.DATE_ID), 112))
								  ELSE D37 END 	AS D37 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,37,B.DATE_ID), 112))
								  ELSE D38 END 	AS D38 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,38,B.DATE_ID), 112))
								  ELSE D39 END 	AS D39 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,39,B.DATE_ID), 112))
								  ELSE D40 END 	AS D40 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,40,B.DATE_ID), 112))
								  ELSE D41 END 	AS D41 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,41,B.DATE_ID), 112))
								  ELSE D42 END 	AS D42 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,42,B.DATE_ID), 112))
								  ELSE D43 END 	AS D43 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,43,B.DATE_ID), 112))
								  ELSE D44 END 	AS D44 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,44,B.DATE_ID), 112))
								  ELSE D45 END 	AS D45 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,45,B.DATE_ID), 112))
								  ELSE D46 END 	AS D46 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,46,B.DATE_ID), 112))
								  ELSE D47 END 	AS D47 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,47,B.DATE_ID), 112))
								  ELSE D48 END 	AS D48 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,48,B.DATE_ID), 112))
								  ELSE D49 END 	AS D49 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,49,B.DATE_ID), 112))
								  ELSE D50 END 	AS D50 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,50,B.DATE_ID), 112))
								  ELSE D51 END 	AS D51 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,51,B.DATE_ID), 112))
								  ELSE D52 END 	AS D52 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,52,B.DATE_ID), 112))
								  ELSE D53 END 	AS D53 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,53,B.DATE_ID), 112))
								  ELSE D54 END 	AS D54 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,54,B.DATE_ID), 112))
								  ELSE D55 END 	AS D55 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,55,B.DATE_ID), 112))
								  ELSE D56 END 	AS D56 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,56,B.DATE_ID), 112))
								  ELSE D57 END 	AS D57 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,57,B.DATE_ID), 112))
								  ELSE D58 END 	AS D58 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,58,B.DATE_ID), 112))
								  ELSE D59 END 	AS D59 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,59,B.DATE_ID), 112))
								  ELSE D60 END 	AS D60 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,60,B.DATE_ID), 112))
								  ELSE D61 END 	AS D61 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,61,B.DATE_ID), 112))
								  ELSE D62 END 	AS D62 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,62,B.DATE_ID), 112))
								  ELSE D63 END 	AS D63 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,63,B.DATE_ID), 112))
								  ELSE D64 END 	AS D64 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,64,B.DATE_ID), 112))
								  ELSE D65 END 	AS D65 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,65,B.DATE_ID), 112))
								  ELSE D66 END 	AS D66 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,66,B.DATE_ID), 112))
								  ELSE D67 END 	AS D67 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,67,B.DATE_ID), 112))
								  ELSE D68 END 	AS D68 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,68,B.DATE_ID), 112))
								  ELSE D69 END 	AS D69 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,69,B.DATE_ID), 112))
								  ELSE D70 END 	AS D70 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,70,B.DATE_ID), 112))
								  ELSE D71 END 	AS D71 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,71,B.DATE_ID), 112))
								  ELSE D72 END 	AS D72 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,72,B.DATE_ID), 112))
								  ELSE D73 END 	AS D73 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,73,B.DATE_ID), 112))
								  ELSE D74 END 	AS D74 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,74,B.DATE_ID), 112))
								  ELSE D75 END 	AS D75 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,75,B.DATE_ID), 112))
								  ELSE D76 END 	AS D76 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,76,B.DATE_ID), 112))
								  ELSE D77 END 	AS D77 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,77,B.DATE_ID), 112))
								  ELSE D78 END 	AS D78 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,78,B.DATE_ID), 112))
								  ELSE D79 END 	AS D79 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,79,B.DATE_ID), 112))
								  ELSE D80 END 	AS D80 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,80,B.DATE_ID), 112))
								  ELSE D81 END 	AS D81 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,81,B.DATE_ID), 112))
								  ELSE D82 END 	AS D82 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,82,B.DATE_ID), 112))
								  ELSE D83 END 	AS D83 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,83,B.DATE_ID), 112))
								  ELSE D84 END 	AS D84 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,84,B.DATE_ID), 112))
								  ELSE D85 END 	AS D85 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,85,B.DATE_ID), 112))
								  ELSE D86 END 	AS D86 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,86,B.DATE_ID), 112))
								  ELSE D87 END 	AS D87 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,87,B.DATE_ID), 112))
								  ELSE D88 END 	AS D88 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,88,B.DATE_ID), 112))
								  ELSE D89 END 	AS D89 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,89,B.DATE_ID), 112))
								  ELSE D90 END 	AS D90 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,90,B.DATE_ID), 112))
								  ELSE D91 END 	AS D91 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,91,B.DATE_ID), 112))
								  ELSE D92 END 	AS D92 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,92,B.DATE_ID), 112))
								  ELSE D93 END 	AS D93 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,93,B.DATE_ID), 112))
								  ELSE D94 END 	AS D94 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,94,B.DATE_ID), 112))
								  ELSE D95 END 	AS D95 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,95,B.DATE_ID), 112))
								  ELSE D96 END 	AS D96 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,96,B.DATE_ID), 112))
								  ELSE D97 END 	AS D97 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,97,B.DATE_ID), 112))
								  ELSE D98 END 	AS D98 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,98,B.DATE_ID), 112))
								  ELSE D99 END 	AS D99 
						   , CASE WHEN A.CATEGORY_ID = 'Yield' THEN
						               ( SELECT TOP 1 M.YIELD
									     FROM   SCM_YIELD_M M WITH(NOLOCK, INDEX([IDX01_SCM_YIELD_M]))
										 WHERE  M.DIVISION_ID	= A.DIVISION_ID
										 AND    M.OPERATION_ID	= A.OPERATION_ID
										 AND    M.LINE_ID		= A.LINE_ID
										 AND    M.ITEM_ID		= A.ITEM_ID
										 AND    M.[MONTH]		= CONVERT(NVARCHAR(6), DATEADD(D,99,B.DATE_ID), 112))
								  ELSE D100 END 	AS D100
		   -- 2019-08-12 kimcd setup_color add start
		   , S_C1 
		   , S_C2
		   , S_C3
		   , S_C4
		   , S_C5
		   , S_C6
		   , S_C7
		   , S_C8
		   , S_C9
		   , S_C10
		   , S_C11
		   , S_C12
		   , S_C13
		   , S_C14
		   , S_C15
		   , S_C16 
		   , S_C17 
		   , S_C18 
		   , S_C19 
		   , S_C20 
		   , S_C21 
		   , S_C22 
		   , S_C23 
		   , S_C24 
		   , S_C25 
		   , S_C26 
		   , S_C27
		   , S_C28
		   , S_C29
		   , S_C30
		   , S_C31
		   , S_C32
		   , S_C33
		   , S_C34
		   , S_C35
		   , S_C36
		   , S_C37
		   , S_C38
		   , S_C39
		   , S_C40
		   , S_C41
		   , S_C42
		   , S_C43
		   , S_C44
		   , S_C45
		   , S_C46
		   , S_C47 
		   , S_C48 
		   , S_C49 
		   , S_C50 
		   , S_C51 
		   , S_C52 
		   , S_C53 
		   , S_C54 
		   , S_C55 
		   , S_C56 
		   , S_C57 
		   , S_C58
		   , S_C59
		   , S_C60
		   , S_C61
		   , S_C62
		   , S_C63
		   , S_C64
		   , S_C65
		   , S_C66
		   , S_C67
		   , S_C68
		   , S_C69
		   , S_C70
		   , S_C71
		   , S_C72
		   , S_C73
		   , S_C74
		   , S_C75
		   , S_C76
		   , S_C77
		   , S_C78 
		   , S_C79 
		   , S_C80 
		   , S_C81 
		   , S_C82 
		   , S_C83 
		   , S_C84 
		   , S_C85 
		   , S_C86 
		   , S_C87 
		   , S_C88 
		   , S_C89
		   , S_C90
		   , S_C91
		   , S_C92
		   , S_C93 
		   , S_C94 
		   , S_C95 
		   , S_C96 
		   , S_C97 
		   , S_C98 
		   , S_C99
		   , S_C100
		   -- 2019-08-12 kimcd setup_color add start
		   , A.CATEGORY_NAME
		   , A.CATEGORY_ID
		   , A.CATEGORY_ORDER
		   , A.MEASURE_NAME
		   , A.DATA_TYPE
	       , LINE_SEQ
		   , 'INSTANCE_ID
			   , FP_PLAN_ID
			   , COMPANY_ID
			   , DIVISION_ID
			   , SITE_ID
			   , PLANT_ID
			   , FACTORY_ID
			   , LOCATION
			   , OPERATION_ID
			   , LINE_ID
			   , (CASE WHEN DATA_TYPE=''DATA'' THEN 1 ELSE CATEGORY_ORDER END)
			   , (CASE WHEN TOP_ITEM_ID=''NONE'' THEN ''0'' ELSE LINE_SEQ END)
			   , EQUIPMENT_ID
			   , TOP_ITEM_ID
			   , ITEM_ID
			   , PRODUCTION_TYPE
			   , MARKET
			   , ELECTRODE_TYPE
			   , CATEGORY_ORDER' AS ORDER_BY
			   , B.DATE_ID       AS FIRST_DATE
	  FROM MAIN A
		 , (SELECT DA.SITE_ID,  MIN(DA.DATE_ID) AS DATE_ID
			FROM   DA DA
			GROUP  BY DA.SITE_ID) B
	  WHERE A.SITE_ID = B.SITE_ID
      UNION ALL
      SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID
            ,A.LINE_ID, MAX(C.LINE_NAME) AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID
            ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME
            ,NULL AS PRODUCTION_TYPE, NULL AS MARKET
            ,NULL AS BATCH_ID, NULL AS BATCH_ID_2
            ,NULL AS PRE_DISPERSION_ID
            ,NULL AS PRE_DISPERSION_NAME
            ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3
            ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3
            ,NULL AS CMC
            ,NULL AS PC_MODEL_ID
            ,NULL AS FOIL_CODE
            ,NULL AS FOIL   
            ,NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR, NULL AS DC_BATCH
            ,NULL AS DC_FLAG
            ,NULL AS VERSION
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 1 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS   D1  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 2 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS   D2  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 3 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS   D3  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 4 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS   D4  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 5 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS   D5  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 6 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS   D6  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 7 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS   D7  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 8 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS   D8  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 9 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS   D9  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 10 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D10  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 11 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D11  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 12 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D12  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 13 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D13  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 14 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D14  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 15 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D15  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 16 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D16  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 17 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D17  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 18 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D18  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 19 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D19  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 20 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D20  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 21 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D21  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 22 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D22  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 23 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D23  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 24 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D24  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 25 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D25  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 26 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D26  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 27 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D27  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 28 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D28  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 29 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D29  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 30 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D30  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 31 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D31  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 32 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D32  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 33 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D33  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 34 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D34  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 35 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D35  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 36 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D36  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 37 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D37  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 38 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D38  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 39 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D39  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 40 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D40  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 41 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D41  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 42 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D42  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 43 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D43  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 44 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D44  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 45 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D45  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 46 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D46  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 47 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D47  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 48 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D48  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 49 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D49  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 50 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D50  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 51 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D51  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 52 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D52  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 53 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D53  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 54 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D54  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 55 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D55  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 56 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D56  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 57 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D57  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 58 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D58  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 59 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D59  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 60 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D60  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 61 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D61  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 62 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D62  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 63 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D63  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 64 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D64  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 65 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D65  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 66 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D66  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 67 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D67  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 68 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D68  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 69 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D69  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 70 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D70  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 71 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D71  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 72 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D72  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 73 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D73  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 74 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D74  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 75 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D75  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 76 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D76  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 77 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D77  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 78 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D78  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 79 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D79  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 80 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D80  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 81 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D81  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 82 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D82  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 83 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D83  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 84 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D84  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 85 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D85  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 86 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D86  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 87 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D87  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 88 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D88  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 89 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D89  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 90 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D90  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 91 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D91  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 92 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D92  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 93 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D93  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 94 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D94  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 95 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D95  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 96 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D96  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 97 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D97  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 98 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D98  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 99 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS  D99  
            ,SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = DA.DATE_ID AND DA.NUM = 100 THEN (CASE WHEN B.CATEGORY_ID='OFF' THEN A.OFF_TIME WHEN B.CATEGORY_ID = 'SETUP' THEN A.SETUP_TIME ELSE CEILING(A.UTILIZATION*100)/100 END ) ELSE 0 END) AS D100  
			, NULL AS S_C1 
			, NULL AS S_C2
			, NULL AS S_C3
			, NULL AS S_C4
			, NULL AS S_C5
			, NULL AS S_C6
			, NULL AS S_C7
			, NULL AS S_C8
			, NULL AS S_C9
			, NULL AS S_C10
			, NULL AS S_C11
			, NULL AS S_C12
			, NULL AS S_C13
			, NULL AS S_C14
			, NULL AS S_C15
			, NULL AS S_C16 
			, NULL AS S_C17 
			, NULL AS S_C18 
			, NULL AS S_C19 
			, NULL AS S_C20 
			, NULL AS S_C21 
			, NULL AS S_C22 
			, NULL AS S_C23 
			, NULL AS S_C24 
			, NULL AS S_C25 
			, NULL AS S_C26 
			, NULL AS S_C27
			, NULL AS S_C28
			, NULL AS S_C29
			, NULL AS S_C30
			, NULL AS S_C31
			, NULL AS S_C32
			, NULL AS S_C33
			, NULL AS S_C34
			, NULL AS S_C35
			, NULL AS S_C36
			, NULL AS S_C37
			, NULL AS S_C38
			, NULL AS S_C39
			, NULL AS S_C40
			, NULL AS S_C41
			, NULL AS S_C42
			, NULL AS S_C43
			, NULL AS S_C44
			, NULL AS S_C45
			, NULL AS S_C46
			, NULL AS S_C47 
			, NULL AS S_C48 
			, NULL AS S_C49 
			, NULL AS S_C50 
			, NULL AS S_C51 
			, NULL AS S_C52 
			, NULL AS S_C53 
			, NULL AS S_C54 
			, NULL AS S_C55 
			, NULL AS S_C56 
			, NULL AS S_C57 
			, NULL AS S_C58
			, NULL AS S_C59
			, NULL AS S_C60
			, NULL AS S_C61
			, NULL AS S_C62
			, NULL AS S_C63
			, NULL AS S_C64
			, NULL AS S_C65
			, NULL AS S_C66
			, NULL AS S_C67
			, NULL AS S_C68
			, NULL AS S_C69
			, NULL AS S_C70
			, NULL AS S_C71
			, NULL AS S_C72
			, NULL AS S_C73
			, NULL AS S_C74
			, NULL AS S_C75
			, NULL AS S_C76
			, NULL AS S_C77
			, NULL AS S_C78 
			, NULL AS S_C79 
			, NULL AS S_C80 
			, NULL AS S_C81 
			, NULL AS S_C82 
			, NULL AS S_C83 
			, NULL AS S_C84 
			, NULL AS S_C85 
			, NULL AS S_C86 
			, NULL AS S_C87 
			, NULL AS S_C88 
			, NULL AS S_C89
			, NULL AS S_C90
			, NULL AS S_C91
			, NULL AS S_C92
			, NULL AS S_C93 
			, NULL AS S_C94 
			, NULL AS S_C95 
			, NULL AS S_C96 
			, NULL AS S_C97 
			, NULL AS S_C98 
			, NULL AS S_C99
			, NULL AS S_C100
      		, B.CATEGORY_NAME
            , B.CATEGORY_ID
            , B.CATEGORY_ORDER
            , B.MEASURE_NAME
            ,'TOTAL' AS DATA_TYPE
            , '' LINE_SEQ
		   , 'INSTANCE_ID
			   , FP_PLAN_ID
			   , COMPANY_ID
			   , DIVISION_ID
			   , SITE_ID
			   , PLANT_ID
			   , FACTORY_ID
			   , LOCATION
			   , OPERATION_ID
			   , LINE_ID
			   , (CASE WHEN DATA_TYPE=''DATA'' THEN 1 ELSE CATEGORY_ORDER END)
			   , (CASE WHEN TOP_ITEM_ID=''NONE'' THEN ''0'' ELSE LINE_SEQ END)
			   , EQUIPMENT_ID
			   , TOP_ITEM_ID
			   , ITEM_ID
			   , PRODUCTION_TYPE
			   , MARKET
			   , ELECTRODE_TYPE
			   , CATEGORY_ORDER' AS ORDER_BY
			   , (SELECT TOP 1 DATE_ID
					 FROM DA DA
					WHERE DA.SITE_ID = A.SITE_ID 
					ORDER BY DA.DATE_ID)  AS FIRST_DATE
      FROM   FP_AMEND_DAILY_UTIL_R A WITH(NOLOCK)
	  INNER JOIN SCM_LINE_M C WITH(NOLOCK)
		ON A.COMPANY_ID     = C.COMPANY_ID
		AND A.DIVISION_ID    = C.DIVISION_ID
		AND A.SITE_ID        = C.SITE_ID
		AND A.PLANT_ID       = C.PLANT_ID
		AND A.FACTORY_ID     = C.FACTORY_ID
		AND A.OPERATION_ID   = C.OPERATION_ID
		AND A.LINE_ID        = C.LINE_ID
		AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
      INNER JOIN (
          SELECT 'OFF' AS CATEGORY_ID, 'Off Cal.' AS CATEGORY_NAME, '' AS MEASURE_NAME, 100 AS CATEGORY_ORDER
          UNION ALL
          SELECT 'SETUP' AS CATEGORY_ID, 'M/C(min)' AS CATEGORY_NAME, '' AS MEASURE_NAME, 200 AS CATEGORY_ORDER
          UNION ALL
          SELECT 'CAPA' AS CATEGORY_ID, 'Load(%)' AS CATEGORY_NAME, '' AS MEASURE_NAME, 300 AS CATEGORY_ORDER
      ) B
      ON 1=1
	 INNER JOIN DA DA
			ON A.SITE_ID   = DA.SITE_ID
			AND A.PLAN_DATE = DA.DATE_ID
      GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
              ,B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER, B.MEASURE_NAME















