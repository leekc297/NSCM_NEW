





CREATE VIEW [dbo].[SCM_PANCAKE_MODEL_V]
-- ================================================================================================
-- Program ID          : SCM_PANCAKE_MODEL_V
--
-- Program Name        : SCM_PANCAKE_MODEL_V
-- Param               :
-- Batch Period        : 
-- Description         : Pancake 최종 적용일 Model 조회
--
-- Source System       : FP SDB
-- Destination System  : SCP SDB
-- Source Table        : FP_PROD_VERSION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2019.04.01
-- Author              : 김춘동
-- Version             : 2019-04-01 kimcd 작업의뢰 최종 적용일 기준 Model 정보 View
-- ================================================================================================
AS
WITH MAX_VER AS (	SELECT [COMPANY_ID]
						 , [DIVISION_ID]
						 , [SITE_ID]
						 , [PLANT_ID]
						 , [FACTORY_ID]
						 , [MODEL_ID]
						 , [ITEM_ID]
						 , [PROD_VERSION]
						 , [PROD_SEQ]
						 , [APPLY_DATE]
						 , [PROD_VERSION_TYPE]
						 , [PROD_TYPE]
					FROM  ( SELECT [COMPANY_ID]
								 , [DIVISION_ID]
								 , [SITE_ID]
								 , [PLANT_ID]
								 , [FACTORY_ID]
								 , [MODEL_ID]
								 , [ITEM_ID]
								 , [PROD_VERSION]
								 , [PROD_SEQ]
								 , [APPLY_DATE]
								 , [PROD_VERSION_TYPE]
								 , CASE WHEN LEFT([PROD_VERSION], 1) = 'Z' THEN 'TEST' ELSE 'MASS' END AS PROD_TYPE
								 , ROW_NUMBER() OVER (PARTITION BY FACTORY_ID, MODEL_ID, ITEM_ID, PROD_VERSION_TYPE, CASE WHEN LEFT([PROD_VERSION], 1) = 'Z' THEN 'TEST' ELSE 'MASS' END
													  ORDER BY APPLY_DATE DESC, PROD_VERSION DESC, PROD_SEQ DESC)  RN
							FROM [FP_PROD_VERSION_M] WITH(NOLOCK)
							WHERE  PROD_VERSION_TYPE IS NOT NULL ) A
					WHERE  RN = 1 ) 
SELECT A.[COMPANY_ID]
	 , A.[DIVISION_ID]
	 , A.[SITE_ID]
	 , A.[PLANT_ID]
	 , A.[FACTORY_ID]
	 , A.[PAN_MODEL_ID]
	 , A.[PAN_ITEM_ID]
	 , A.[PAN_PROD_VERSION]
	 , A.[PAN_PROD_SEQ] 
	 , A.[PROD_VERSION_TYPE]
	 , A.[PROD_TYPE]
	 , A.[APPLY_DATE]
FROM  ( SELECT PAN.[COMPANY_ID]
				, PAN.[DIVISION_ID]
				, PAN.[SITE_ID]
				, PAN.[PLANT_ID]
				, PAN.[FACTORY_ID]
				, PAN.[MODEL_ID]          AS PAN_MODEL_ID
				, PAN.[ITEM_ID]           AS PAN_ITEM_ID
				, PAN.[PROD_VERSION]      AS PAN_PROD_VERSION
				, PAN.[PROD_SEQ]          AS PAN_PROD_SEQ  -- 2019-04-01 kimcd 차수 컬럼 추가
				, PAN.[PROD_VERSION_TYPE]
				, PAN.[PROD_TYPE]
				, PAN.[APPLY_DATE]
				, RANK() OVER (PARTITION BY PAN.FACTORY_ID, PAN.ITEM_ID, PAN.PROD_VERSION_TYPE, PAN.PROD_TYPE
									ORDER BY PAN.APPLY_DATE DESC, PAN.PROD_VERSION DESC, PAN.PROD_SEQ DESC, PAN.[MODEL_ID])  RN
		FROM    MAX_VER     PAN
		WHERE   EXISTS( SELECT 1
						FROM   MAX_VER     SLA
						WHERE   PAN.[COMPANY_ID]        = SLA.[COMPANY_ID]
						AND     PAN.[DIVISION_ID]       = SLA.[DIVISION_ID]
						AND     PAN.[SITE_ID]           = SLA.[SITE_ID]
						AND     PAN.[PLANT_ID]          = SLA.[PLANT_ID]
						AND     PAN.[FACTORY_ID]        = SLA.[FACTORY_ID]
						AND     PAN.[MODEL_ID]          = SLA.[MODEL_ID]
						AND     PAN.[PROD_VERSION_TYPE] = SLA.[PROD_VERSION_TYPE]
						AND     PAN.[PROD_VERSION]      = SLA.[PROD_VERSION]
						AND     PAN.[PROD_SEQ]          = SLA.[PROD_SEQ]  -- 2019-04-01 kimcd 차수 컬럼 추가
						AND     SUBSTRING(PAN.ITEM_ID,4,1) = SUBSTRING(SLA.ITEM_ID,4,1)
						AND     SLA.ITEM_ID          LIKE 'ASL%'
						AND     SLA.ITEM_ID      NOT LIKE 'ASLP%'
						AND     PAN.ITEM_ID          LIKE 'APC%')
		) A
WHERE  A.RN = 1 
