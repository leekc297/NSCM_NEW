





CREATE VIEW [dbo].[IF_FP_FCS_HOLD_AGING_STOCK_V]
-- ================================================================================================
-- Program ID          : IF_FP_FCS_HOLD_AGING_STOCK_V
--
-- Program Name        : IF_FP_FCS_HOLD_AGING_STOCK_V
-- Param               :
-- Batch Period        : 
-- Description         : SCP 제공용 FCS Aging Stock Hold 정보
--
-- Source System       : FP SDB
-- Destination System  : SCP SDB
-- Source Table        : SCM_AGING_STOCK_H, SCM_MES_WIP_HISTORY_H
-- Destination Table   : 
--
-- Create(Update) Date : 2019.08.29
-- Author              : kim choon dong
-- Version             : 2018-11-29 kimcd 소형 활성화 재고 중 HOLD는 LOT 생산 일자 기준으로 가용 일자 형성한다.
--                       2018-12-03 kimcd 수율 조회에서 조립 라인으로 치환하도록 로직 수정
--                       2019-08-29 kimcd FORMATION_MMD_ROUTE_CONVERT SEGMENT4에 COMPANY_ID 추가에 따른 수정
-- ================================================================================================
AS
SELECT A.[COMPANY_ID]
      ,A.[DIVISION_ID]
      ,A.[SITE_ID]
      ,A.[PLANT_ID]
      ,A.[FACTORY_ID]
	  ,A.[OPERATION_ID]
      ,A.[LOCATION]
      ,A.[TOP_ITEM_ID]
      ,A.[ITEM_ID]
      ,A.[PRODUCTION_TYPE]
      ,A.[MARKET]
      ,A.[LINE_ID]
      ,A.[ELECTRODE_TYPE]
	  ,A.[PLAN_DATE] -- 2018-11-20 kimcd grading, 특성 lead time으로 2일 추가
      ,A.[ACTUAL_GOOD_QTY]  -- 2018-11-20 kimcd 특성 yield 곱하기
      ,A.[ACTUAL_QTY]
	  ,A.[EQUIPMENT_ID]
FROM  ( SELECT A.[COMPANY_ID]
			  ,A.[DIVISION_ID]
			  ,A.[SITE_ID]
			  ,A.[PLANT_ID]
			  ,A.[FACTORY_ID]
			  ,RIGHT(SI.FORMATION_FLOW_ID, 5) AS [OPERATION_ID]
			  ,'-'                            AS [LOCATION]
			  ,A.[ITEM_ID]                    AS [TOP_ITEM_ID]
			  ,A.[ITEM_ID]
			  ,A.[PRODUCTION_TYPE]
			  ,'-'                            AS [MARKET]
			  ,A.[LINE_ID]
			  ,'-'                            AS [ELECTRODE_TYPE]
			  ,DATEADD(DAY, ISNULL(( SELECT ST_SUM
									 FROM   ( SELECT ISNULL(AIF.ROUTE_TOTAL_TIME/14400.0,0.0) + ISNULL(AIF.REMAIN_TIME/1440.0, 0.0)  AS ST_SUM
												   , ROW_NUMBER() OVER (ORDER BY AIF.OPERATION_SEQ, OPERATION_STEP) AS ROW_NUM
											  FROM   SCM_AGING_ITEM_FLOW_M  AIF WITH(NOLOCK)
											  WHERE  AIF.DEFAULT_ROUTE = 'Y'
											  AND   AIF.DEFAULT_FLAG = 'B' -- 기본 Route
											  AND   AIF.COMPANY_ID   = A.COMPANY_ID
											  AND   AIF.DIVISION_ID  = A.DIVISION_ID
											  AND   AIF.SITE_ID      = A.SITE_ID
											  AND   AIF.PLANT_ID     = A.PLANT_ID
											  AND   AIF.FACTORY_ID   = A.FACTORY_ID
											  AND   AIF.ITEM_ID      = A.ITEM_ID
											  AND   AIF.LINE_ID      = A.LINE_ID) AIF 
									 WHERE ROW_NUM = 1), CONVERT(NUMERIC(20,10), FLO.ATTRIBUTE3) ) + 2 , (SELECT  TOP 1 CAST( CONVERT( VARCHAR,CAST(SMW.CALDATE AS DATETIME),112) AS DATETIME )
																										  FROM    SCM_MES_WIP_HISTORY_H SMW WITH(NOLOCK)
																										  WHERE   ATTRIBUTE7 = A.LOT_ID) )  AS [PLAN_DATE] -- 2018-11-20 kimcd grading, 특성 lead time으로 2일 추가
			  ,FLOOR(A.[QTY] * ISNULL(( SELECT CASE WHEN D.FORMATION_TOTAL_YIELD = 0 THEN 1 ELSE D.FORMATION_TOTAL_YIELD END
										FROM   SCM_FORMATION_YIELD_M D WITH(NOLOCK)
										WHERE A.COMPANY_ID = D.COMPANY_ID
										AND A.DIVISION_ID  = D.DIVISION_ID
										AND A.SITE_ID      = D.SITE_ID
										AND A.PLANT_ID     = D.PLANT_ID
										AND A.FACTORY_ID   = D.FACTORY_ID
										AND A.ITEM_ID      = D.ITEM_ID
										AND D.LINE_ID      = ( SELECT TOP 1 FL.SEGMENT5
															   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  FL WITH(NOLOCK)
															   WHERE  FL.LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING' 
															   AND    FL.ACTIVE_FLAG = 'Y'
															   AND    FL.SEGMENT1 = A.SITE_ID
															   AND    FL.SEGMENT2 = A.LINE_ID) -- 2018-12-03 kimcd 수율 조회에서 조립 라인으로 치환하도록 로직 수정
										),1)) AS [ACTUAL_GOOD_QTY]  -- 2018-11-20 kimcd 특성 yield 곱하기
			  ,A.[INPUT_QTY]                  AS [ACTUAL_QTY]
			  ,'-'                            AS [EQUIPMENT_ID]
		  FROM [DBO].[AGING_STOCK_V] A WITH(NOLOCK)
			  ,(SELECT  B.SITE_ID
						,MAX(B.CUTOFF_DATE) AS CUTOFF_DATE
				 FROM    [DBO].[SCM_AGING_STOCK_H] B WITH(NOLOCK)
				 GROUP BY B.SITE_ID ) B
			  , [DBO].[SCM_ITEM_M]            SI WITH(NOLOCK)
  			  , [DBO].[SCM_SYS_LOOKUP_VALUE]  FLO WITH(NOLOCK)
		WHERE  A.SITE_ID     = B.SITE_ID
		AND    A.CUTOFF_DATE = B.CUTOFF_DATE
		AND    A.SITE_ID     = SI.SITE_ID
		AND    A.COMPANY_ID  = SI.COMPANY_ID
		AND    A.DIVISION_ID = SI.DIVISION_ID
		AND    A.ITEM_ID     = SI.ITEM_ID
		AND    SI.SITE_ID     = FLO.SEGMENT1
		AND    SI.DIVISION_ID = FLO.SEGMENT2
		AND    SI.FLOW_ID     = FLO.SEGMENT3
		AND    SI.COMPANY_ID  = FLO.SEGMENT4 -- 2019-08-29 kimcd COMPANY_ID 추가
		AND    FLO.LOOKUP_TYPE_CODE = 'FORMATION_MMD_ROUTE_CONVERT'
		AND    FLO.ACTIVE_FLAG = 'Y'
		AND    FLO.ATTRIBUTE2  = 'Y'
		AND    A.[WIPHOLD_YN]  = 'Y' )  A
WHERE [PLAN_DATE] IS NOT NULL



