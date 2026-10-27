




CREATE VIEW [dbo].[IF_FP_WEEK_RELEASE_PLAN_V_1105_dev_org]
-- ================================================================================================
-- Program ID          : IF_FP_WEEK_RELEASE_PLAN_V
--
-- Program Name        : IF_FP_WEEK_RELEASE_PLAN_V
-- Param               :
-- Batch Period        : 
-- Description         : SCP 제공용 확정 Plan. 당주 월요일 기준으로 계획 정보 조회
--
-- Source System       : FP SDB
-- Destination System  : SCP SDB
-- Source Table        : FP_DAILY_PRODUCTIOIN_PLAN_H, SCM_DAILY_PRODUCT_RESULT_H, SCM_AGING_STOCK_H
-- Destination Table   : 
--
-- Create(Update) Date : 2023.03.31
-- Author              : kim choon dong
-- Version             : 2023-03-10 kimcd  IF_FP_RELEASE_PLAN_V 기반으로 수정 개발
--                       2023-03-31 kimcd  실적 기준 월요일까지로 변경
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
-- ================================================================================================

AS
WITH TUESDAY AS (SELECT DATEADD(D, 1, DATEADD(WK, DATEDIFF(WK,0,GETDATE()),0)) AS TUESDAY )  -- 2023-03-31 kimcd  실적 기준 월요일까지로 변경
SELECT [COMPANY_ID]
      ,[DIVISION_ID]
      ,[SITE_ID]
      ,DPP.[PLANT_ID]
      ,[FACTORY_ID]
	  ,[OPERATION_ID]
      ,[LOCATION]
      ,[TOP_ITEM_ID]
      ,[ITEM_ID]
      ,DPP.[FP_PRODUCTION_TYPE]  -- 2019-12-19 kimcd E2000 공정 TEST는 S-TEST로 임시 전환 2020-01-29 kimcd 복원
      ,[MARKET]
      ,[LINE_ID]
      ,[ELECTRODE_TYPE]
      ,[PLAN_DATE]
      ,[PLAN_QTY]
      ,[PLAN_IN_QTY]
      ,[EQUIPMENT_ID]
 FROM FP_DAILY_PRODUCTIOIN_PLAN_H DPP WITH(NOLOCK)
WHERE ( ( DPP.PLAN_TYPE = 'RELEASE' AND DPP.OPERATION_ID NOT IN ( 'F5300', 'F5400', 'F5500', 'F5600', 'F6200' ) )
        OR (DPP.OPERATION_ID IN ( 'F5300', 'F5400', 'F5500', 'F5600'/*, 'F6200' 2020-07-22 제외 */) AND DPP.PLAN_TYPE = 'WPP')
		OR (DPP.OPERATION_ID = 'F6200' AND ( ( DPP.PLAN_TYPE = 'RELEASE' 
    AND DPP.PLANT_ID not in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='IF_FP_WEEK_RELEASE_PLAN_V' AND SEGMENT1  = '3' AND ACTIVE_FLAG='Y')) OR ( DPP.PLAN_TYPE = 'WPP' AND DPP.PLANT_ID not in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='IF_FP_WEEK_RELEASE_PLAN_V' AND SEGMENT1  = '3' AND ACTIVE_FLAG='Y')) ) ) ) -- 2019-06-03 kimcd 남경 특성 WPP 기준 전송. 2019-05-20 kimcd 소형 ETW(F6200)은 WPP 기반으로 계획 반영
  AND ( DPP.PLAN_DATE >=  (SELECT M.TUESDAY FROM TUESDAY M))  -- 2023-03-31 kimcd  실적 기준 월요일까지로 변경
UNION ALL
SELECT [COMPANY_ID]
      ,[DIVISION_ID]
      ,[SITE_ID]
      ,DPR.[PLANT_ID]
      ,[FACTORY_ID]
	  ,[OPERATION_ID]
      ,[LOCATION]
      ,[TOP_ITEM_ID]
      ,[ITEM_ID]
	  ,DPR.[FP_PRODUCTION_TYPE]  -- 2019-12-19 kimcd E2000 공정 TEST는 S-TEST로 임시 전환 2020-01-29 kimcd 복원
      ,[MARKET]
      ,[LINE_ID]
      ,[ELECTRODE_TYPE]
      ,[PLAN_DATE]
      ,[ACTUAL_GOOD_QTY]  -- OUT 수량
      ,[ACTUAL_QTY]  -- IN 수량
      ,[EQUIPMENT_ID]
 FROM SCM_DAILY_PRODUCT_RESULT_H DPR WITH(NOLOCK)
WHERE ( DPR.PLAN_DATE < (SELECT M.TUESDAY FROM TUESDAY M))  -- 2023-03-31 kimcd  실적 기준 월요일까지로 변경
  AND PLAN_DATE >= DATEADD(D, -1,DATEADD(wk, -8, (SELECT M.TUESDAY FROM TUESDAY M)))  -- 2023-03-31 kimcd  실적 기준 월요일까지로 변경
UNION ALL
SELECT DPP.[COMPANY_ID]
      ,DPP.[DIVISION_ID]
      ,DPP.[SITE_ID]
      ,DPP.[PLANT_ID]
      ,DPP.[FACTORY_ID]
	  ,RIGHT(SI.FORMATION_FLOW_ID, 5) AS [OPERATION_ID]
      ,DPP.[LOCATION]
      ,DPP.[TOP_ITEM_ID]
      ,DPP.[ITEM_ID]
      ,DPP.[FP_PRODUCTION_TYPE]
      ,DPP.[MARKET]
      ,(SELECT TOP 1 FL.SEGMENT2
	    FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  FL WITH(NOLOCK)
		WHERE  FL.LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING' 
		AND    FL.ACTIVE_FLAG      = 'Y'
		AND    FL.SEGMENT1         = DPP.SITE_ID
		AND    FL.SEGMENT5         = DPP.LINE_ID) AS [LINE_ID]
      ,'-' AS [ELECTRODE_TYPE]
      ,DATEADD(DAY, ISNULL(( SELECT ST_SUM
	                         FROM   ( SELECT ISNULL(AIF.ROUTE_TOTAL_TIME/14400.0,0.0) + ISNULL(AIF.REMAIN_TIME/1440.0, 0.0)  AS ST_SUM
									       , ROW_NUMBER() OVER (ORDER BY AIF.OPERATION_SEQ, OPERATION_STEP) AS ROW_NUM
                                      FROM   SCM_AGING_ITEM_FLOW_M  AIF WITH(NOLOCK)
                                      WHERE  AIF.DEFAULT_ROUTE = 'Y'
									  AND   AIF.DEFAULT_FLAG = 'B' -- 기본 Route
                                      AND   AIF.COMPANY_ID   = DPP.COMPANY_ID
                                      AND   AIF.DIVISION_ID  = DPP.DIVISION_ID
                                      AND   AIF.SITE_ID      = DPP.SITE_ID
                                      AND   AIF.PLANT_ID     = DPP.PLANT_ID
                                      AND   AIF.FACTORY_ID   = DPP.FACTORY_ID
                                      AND   AIF.ITEM_ID      = DPP.ITEM_ID
                                      AND   AIF.LINE_ID      = (SELECT TOP 1 FL.SEGMENT2
																FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  FL WITH(NOLOCK)
																WHERE  FL.LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING' 
																AND    FL.ACTIVE_FLAG = 'Y'
																AND    FL.SEGMENT1 = DPP.SITE_ID
																AND    FL.SEGMENT5 = DPP.LINE_ID)) AIF 
							 WHERE ROW_NUM = 1), CONVERT(NUMERIC(20,10), FLO.ATTRIBUTE3) ) + 2 , DPP.[PLAN_DATE] ) AS PLAN_DATE -- 2018-11-20 kimcd grading, 특성 lead time으로 2일 추가
      ,FLOOR(DPP.PLAN_QTY * ISNULL(( SELECT CASE WHEN D.FORMATION_TOTAL_YIELD = 0 THEN 1 ELSE D.FORMATION_TOTAL_YIELD END * CASE WHEN D.CHARACTERIZATION_YIELD = 0 THEN 1 ELSE D.CHARACTERIZATION_YIELD END
	                                        -- 2018-11-20 kimcd 특성 yield 곱하기, 
									 FROM   SCM_FORMATION_YIELD_M D WITH(NOLOCK)
									 WHERE DPP.COMPANY_ID = D.COMPANY_ID
									 AND DPP.DIVISION_ID  = D.DIVISION_ID
									 AND DPP.SITE_ID      = D.SITE_ID
									 AND DPP.PLANT_ID     = D.PLANT_ID
									 AND DPP.FACTORY_ID   = D.FACTORY_ID
									 AND DPP.ITEM_ID      = D.ITEM_ID
									 AND DPP.LINE_ID      = D.LINE_ID
									 ),1)) AS [PLAN_QTY]
      ,DPP.PLAN_QTY AS [PLAN_IN_QTY]
      ,'-' AS [EQUIPMENT_ID]
 FROM FP_DAILY_PRODUCTIOIN_PLAN_H DPP WITH(NOLOCK)
	, [DBO].[SCM_ITEM_M]            SI WITH(NOLOCK)
	, [DBO].[SCM_SYS_LOOKUP_VALUE]  FLO WITH(NOLOCK)
WHERE DPP.SITE_ID     = SI.SITE_ID
  AND DPP.COMPANY_ID  = SI.COMPANY_ID
  AND DPP.DIVISION_ID = SI.DIVISION_ID
  AND DPP.ITEM_ID     = SI.ITEM_ID
  AND DPP.SITE_ID     = FLO.SEGMENT1
  AND DPP.DIVISION_ID = FLO.SEGMENT2
  AND DPP.OPERATION_ID = FLO.SEGMENT3
  AND DPP.COMPANY_ID   = FLO.SEGMENT4 -- 2019-08-29 kimcd company id 추가
  AND FLO.LOOKUP_TYPE_CODE = 'FORMATION_MMD_ROUTE_CONVERT'
  AND FLO.ACTIVE_FLAG = 'Y'
  AND FLO.ATTRIBUTE2  = 'Y'
  AND DPP.PLAN_TYPE   = 'RELEASE'
  AND DPP.PLAN_DATE  >=  (SELECT M.TUESDAY FROM TUESDAY M)  -- 2023-03-31 kimcd  실적 기준 월요일까지로 변경
UNION ALL
-- 2018-11-29 kimcd 조립 실적 기반으로 특성 계획 형성 추가 시작
SELECT DPP.[COMPANY_ID]
      ,DPP.[DIVISION_ID]
      ,DPP.[SITE_ID]
      ,DPP.[PLANT_ID]
      ,DPP.[FACTORY_ID]
	  ,RIGHT(SI.FORMATION_FLOW_ID, 5) AS [OPERATION_ID]
      ,DPP.[LOCATION]
      ,DPP.[TOP_ITEM_ID]
      ,DPP.[ITEM_ID]
      ,DPP.[FP_PRODUCTION_TYPE]
      ,DPP.[MARKET]
      ,(SELECT TOP 1 FL.SEGMENT2
	    FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  FL WITH(NOLOCK)
		WHERE  FL.LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING' 
		AND    FL.ACTIVE_FLAG      = 'Y'
		AND    FL.SEGMENT1         = DPP.SITE_ID
		AND    FL.SEGMENT5         = DPP.LINE_ID) AS [LINE_ID]
      ,'-' AS [ELECTRODE_TYPE]
      ,DATEADD(DAY, ISNULL(( SELECT ST_SUM
	                         FROM   ( SELECT ISNULL(AIF.ROUTE_TOTAL_TIME/14400.0,0.0) + ISNULL(AIF.REMAIN_TIME/1440.0, 0.0)  AS ST_SUM
									       , ROW_NUMBER() OVER (ORDER BY AIF.OPERATION_SEQ, OPERATION_STEP) AS ROW_NUM
                                      FROM   SCM_AGING_ITEM_FLOW_M  AIF WITH(NOLOCK)
                                      WHERE  AIF.DEFAULT_ROUTE = 'Y'
									  AND   AIF.DEFAULT_FLAG = 'B' -- 기본 Route
                                      AND   AIF.COMPANY_ID   = DPP.COMPANY_ID
                                      AND   AIF.DIVISION_ID  = DPP.DIVISION_ID
                                      AND   AIF.SITE_ID      = DPP.SITE_ID
                                      AND   AIF.PLANT_ID     = DPP.PLANT_ID
                                      AND   AIF.FACTORY_ID   = DPP.FACTORY_ID
                                      AND   AIF.ITEM_ID      = DPP.ITEM_ID
                                      AND   AIF.LINE_ID      = (SELECT TOP 1 FL.SEGMENT2
																FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  FL WITH(NOLOCK)
																WHERE  FL.LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING' 
																AND    FL.ACTIVE_FLAG = 'Y'
																AND    FL.SEGMENT1 = DPP.SITE_ID
																AND    FL.SEGMENT5 = DPP.LINE_ID)) AIF 
							 WHERE ROW_NUM = 1), CONVERT(NUMERIC(20,10), FLO.ATTRIBUTE3) ) + 2 , DPP.[PLAN_DATE] ) AS PLAN_DATE -- 2018-11-20 kimcd grading, 특성 lead time으로 2일 추가
      ,FLOOR(DPP.ACTUAL_GOOD_QTY * ISNULL(( SELECT CASE WHEN D.FORMATION_TOTAL_YIELD = 0 THEN 1 ELSE D.FORMATION_TOTAL_YIELD END * CASE WHEN D.CHARACTERIZATION_YIELD = 0 THEN 1 ELSE D.CHARACTERIZATION_YIELD END
													-- 2018-11-20 kimcd 특성 yield 곱하기, 
											 FROM   SCM_FORMATION_YIELD_M D WITH(NOLOCK)
											 WHERE DPP.COMPANY_ID = D.COMPANY_ID
											 AND DPP.DIVISION_ID  = D.DIVISION_ID
											 AND DPP.SITE_ID      = D.SITE_ID
											 AND DPP.PLANT_ID     = D.PLANT_ID
											 AND DPP.FACTORY_ID   = D.FACTORY_ID
											 AND DPP.ITEM_ID      = D.ITEM_ID
											 AND DPP.LINE_ID      = D.LINE_ID ),1)) AS [PLAN_QTY]
      ,DPP.ACTUAL_GOOD_QTY AS [PLAN_IN_QTY]
      ,'-' AS [EQUIPMENT_ID]
 FROM SCM_DAILY_PRODUCT_RESULT_H    DPP WITH(NOLOCK)
	, [DBO].[SCM_ITEM_M]            SI  WITH(NOLOCK)
	, [DBO].[SCM_SYS_LOOKUP_VALUE]  FLO WITH(NOLOCK)
WHERE DPP.SITE_ID     = SI.SITE_ID
  AND DPP.COMPANY_ID  = SI.COMPANY_ID
  AND DPP.DIVISION_ID = SI.DIVISION_ID
  AND DPP.ITEM_ID     = SI.ITEM_ID
  AND DPP.SITE_ID     = FLO.SEGMENT1
  AND DPP.DIVISION_ID = FLO.SEGMENT2
  AND DPP.OPERATION_ID = FLO.SEGMENT3
  AND DPP.COMPANY_ID   = FLO.SEGMENT4 -- 2019-08-29 kimcd COMPANY_ID 추가
  AND FLO.LOOKUP_TYPE_CODE = 'FORMATION_MMD_ROUTE_CONVERT'
  AND FLO.ACTIVE_FLAG = 'Y'
  AND FLO.ATTRIBUTE2  = 'Y'
  AND DPP.PLAN_DATE  >=  DATEADD(DAY, - ISNULL(( SELECT ST_SUM
												 FROM   ( SELECT ISNULL(AIF.ROUTE_TOTAL_TIME/14400.0,0.0) + ISNULL(AIF.REMAIN_TIME/1440.0, 0.0)  AS ST_SUM
															   , ROW_NUMBER() OVER (ORDER BY AIF.OPERATION_SEQ, OPERATION_STEP) AS ROW_NUM
														  FROM   SCM_AGING_ITEM_FLOW_M  AIF WITH(NOLOCK)
														  WHERE  AIF.DEFAULT_ROUTE = 'Y'
														  AND   AIF.DEFAULT_FLAG = 'B' -- 기본 Route
														  AND   AIF.COMPANY_ID   = DPP.COMPANY_ID
														  AND   AIF.DIVISION_ID  = DPP.DIVISION_ID
														  AND   AIF.SITE_ID      = DPP.SITE_ID
														  AND   AIF.PLANT_ID     = DPP.PLANT_ID
														  AND   AIF.FACTORY_ID   = DPP.FACTORY_ID
														  AND   AIF.ITEM_ID      = DPP.ITEM_ID
														  AND   AIF.LINE_ID      = (SELECT TOP 1 FL.SEGMENT2
																					FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  FL WITH(NOLOCK)
																					WHERE  FL.LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING' 
																					AND    FL.ACTIVE_FLAG = 'Y'
																					AND    FL.SEGMENT1 = DPP.SITE_ID
																					AND    FL.SEGMENT5 = DPP.LINE_ID)) AIF 
												 WHERE ROW_NUM = 1), CONVERT(NUMERIC(20,10), FLO.ATTRIBUTE3) ) - 2 , (SELECT M.TUESDAY FROM TUESDAY M)) -- 2023-03-31 kimcd  실적 기준 월요일까지로 변경
-- 2018-11-29 kimcd 조립 실적 기반으로 특성 계획 형성 추가 종료  
