







CREATE VIEW [dbo].[SCM_FCS_SHIP_V]
-- ================================================================================================
-- Program ID          : SCM_FCS_SHIP_V
--
-- Program Name        : SCM_FCS_SHIP_V
-- Param               :
-- Batch Period        : 
-- Description         : FCS 특성 계획용 출하 정보 View
--
-- Source System       : FP SDB
-- Destination System  : SCP SDB
-- Source Table        : SCM_FCS_MATERIAL_DOCUMENT_H, SCM_ITEM_M, SCM_ITEM_CLASS_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.12
-- Author              : kim choon dong
-- Version             : 2018-11-21 kimcd 모델만 조회되도록 exist 조건 추가
--                       2019-09-25 kimcd 폴란드 법인 자재 창고에서 공급된 수량 제외 임시조치
--                                        NOT (TX.PLANT_ID = 'G481' AND TX.IO_STORAGE_ID LIKE '1%')
--                       2019-10-11 kimcd 음수에 대해서 특정 IO 창고만 반영되도록 수정
--                                        ERP_MATERIAL_DOCUMENT_EXCEPTION lookup 추가 등록
--						 2020-01-30 PIYONG MES CELL 출하 정보 생성 추가
--						 2021-01-19 kimcd MES 출하 정보의 창고를 Pack 창고로 변경
--                       2022-05-12 kimcd PLANT별 시업 시간 조회 로직 보완
-- ================================================================================================
AS
SELECT P.[COMPANY_ID]
      ,P.[DIVISION_ID]
      ,P.[SITE_ID]
      ,P.[PLANT_ID]
      ,TX.[SHIP_YYYYMMDD]
	  ,TX.[BIZ_TYPE]
	  ,TX.[STORAGE_ID]
      ,TX.[ITEM_ID]
	  ,TX.[QTY]
FROM  ( SELECT TX.SHIP_YYYYMMDD
			  ,TX.ITEM_ID
			  ,TX.PLANT_ID
			  ,TX.BIZ_TYPE
			  ,TX.STORAGE_ID
			  ,SUM(QTY) AS QTY
		FROM  ( SELECT TX.DOC_POSTING_DATE AS SHIP_YYYYMMDD
					  ,TX.ITEM_ID
					  ,TX.PLANT_ID
					  ,LV.ATTRIBUTE3   AS BIZ_TYPE
					  ,TX.STORAGE_ID
					  ,CASE WHEN TX.INDICATOR = LV.ATTRIBUTE1 THEN TX.MAT_QTY ELSE CASE WHEN LV.ATTRIBUTE2 = 'N' OR LV.ATTRIBUTE4 = 'Y' THEN 0 ELSE -1 * TX.MAT_QTY END END AS QTY
					  -- 2019-10-11 kimcd OR LV.ATTRIBUTE4 = 'Y' 조건 추가 특정 창고로 반품만 정보 추출은 다음 조회문에서 추출
				FROM   [DBO].[SCM_FCS_MATERIAL_DOCUMENT_H] TX WITH(NOLOCK),
					   [DBO].[SCM_SYS_LOOKUP_VALUE]        LV WITH(NOLOCK)
				WHERE  TX.PLANT_ID = LV.SEGMENT1
				AND    TX.STORAGE_ID = LV.SEGMENT2
				AND    TX.MOVEMENT_TYPE = LV.SEGMENT3
				AND    LV.LOOKUP_TYPE_CODE = 'ERP_MATERIAL_DOCUMENT_MAPPING'
				AND    LV.ACTIVE_FLAG = 'Y'
				AND    NOT (TX.PLANT_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='SCM_FCS_SHIP_V' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
				AND TX.IO_STORAGE_ID LIKE (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='SCM_FCS_SHIP_V' AND SEGMENT1  = '1' AND ACTIVE_FLAG = 'Y')) -- 2019-09-25 kimcd 폴란드 법인 자재 창고에서 공급된 수량 제외 임시조치
				UNION ALL -- 2019-10-11 kimcd 특정 창고로 반품되는 경우만 음수 취합 조회문 추가
				SELECT TX.DOC_POSTING_DATE AS SHIP_YYYYMMDD
					  ,TX.ITEM_ID
					  ,TX.PLANT_ID
					  ,LV.ATTRIBUTE3   AS BIZ_TYPE
					  ,TX.STORAGE_ID
					  ,CASE WHEN TX.INDICATOR = LV.ATTRIBUTE1 THEN 0 ELSE -1 * TX.MAT_QTY END AS QTY
				FROM   [DBO].[SCM_FCS_MATERIAL_DOCUMENT_H] TX WITH(NOLOCK),
					   [DBO].[SCM_SYS_LOOKUP_VALUE]        LV WITH(NOLOCK),
					   [DBO].[SCM_SYS_LOOKUP_VALUE]        LVE WITH(NOLOCK)
				WHERE  TX.PLANT_ID = LV.SEGMENT1
				AND    TX.STORAGE_ID = LV.SEGMENT2
				AND    TX.MOVEMENT_TYPE = LV.SEGMENT3
				AND    TX.PLANT_ID = LVE.SEGMENT1
				AND    TX.STORAGE_ID = LVE.SEGMENT2
				AND    TX.MOVEMENT_TYPE = LVE.SEGMENT3
				AND    TX.IO_STORAGE_ID = LVE.SEGMENT4
				AND    LV.LOOKUP_TYPE_CODE = 'ERP_MATERIAL_DOCUMENT_MAPPING'
				AND    LV.ACTIVE_FLAG = 'Y'
				AND    LV.ATTRIBUTE2 = 'Y'  -- 음수도 포함
				AND    LV.ATTRIBUTE4 = 'Y'  -- 특정 창고로 반품된 경우만 음수 포함
				AND    LVE.LOOKUP_TYPE_CODE = 'ERP_MATERIAL_DOCUMENT_EXCEPTION'
				AND    LVE.ACTIVE_FLAG = 'Y'
				AND    NOT (TX.PLANT_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='SCM_FCS_SHIP_V' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
				AND TX.IO_STORAGE_ID LIKE (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='SCM_FCS_SHIP_V' AND SEGMENT1  = '1' AND ACTIVE_FLAG = 'Y')) -- 2019-09-25 kimcd 폴란드 법인 자재 창고에서 공급된 수량 제외 임시조치
				) TX  -- 2019-10-11 kimcd UNION ALL 사용으로 GROUP BY 문장을 한단계 올림
		GROUP BY TX.SHIP_YYYYMMDD
				,TX.ITEM_ID
				,TX.PLANT_ID
				,TX.BIZ_TYPE
			   ,TX.STORAGE_ID
		-------------------------------------------------------------------------------------------------------
		-- 2020-01-30 PIYONG ADD
		UNION
		SELECT [SHIPMENT_DATE] AS [SHIP_YYYYMMDD]
				,[ITEM_ID]
				,[PLANT_ID]
				,[BIZ_TYPE]
				,[STORAGE_ID]
				,SUM( QTY ) AS QTY
			FROM (
				SELECT [COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,CONVERT( NVARCHAR(8), [SHIPMENT_DATE], 112 ) AS [SHIPMENT_DATE]
						, 'P' AS [BIZ_TYPE]
						,[STORAGE_ID]
						,[ITEM_ID]
						,SUM([QTY]) AS QTY
					FROM (
							SELECT [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,CASE WHEN SUBSTRING(REPLACE(  CONVERT(NVARCHAR(21), [SHIPMENT_DATE], 120 ), ':',''), 12,4) <=  (
																																		SELECT TOP 1 SUBSTRING(V.SEGMENT2, 1, 4)
																																		FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
																																		WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			AND V.ACTIVE_FLAG = 'Y'
																																			AND V.SEGMENT1    = S.PLANT_ID
																																			-- 2022-05-12 kimcd PLANT별 시업 시간 조회 로직 보완
																																		)  THEN
											CONVERT( NVARCHAR(8), DATEADD(DAY, -1, [SHIPMENT_DATE] ), 112 )
										 ELSE													
											CONVERT( NVARCHAR(8), [SHIPMENT_DATE], 112 )
										 END AS [SHIPMENT_DATE]
									,[RECEIVE_SLOC] AS [STORAGE_ID]  -- 2021-01-19 kimcd MES 출하 정보의 창고를 Pack 창고로 변경
									,[ITEM_ID]
									,QTY
							  FROM FP_MES_CELL_SHIPMENT_H S
		  					 WHERE RIGHT([RECEIVE_SLOC], 1) = 'P'
							   AND SHIPPING_STATUS NOT IN ( 'CANCEL_SHIP', 'CANCEL_SHIPPED', 'SPLITMERGE')	-- 출하 취소
						 ) A
				GROUP BY [COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,CONVERT( NVARCHAR(8), [SHIPMENT_DATE], 112 )
						,[STORAGE_ID]
						,[ITEM_ID]
				UNION ALL
				SELECT [COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[SHIPMENT_DATE]
						, 'P' AS [BIZ_TYPE]
						,[STORAGE_ID]
						,[ITEM_ID]
						,-SUM([QTY])AS QTY
					FROM (
							 SELECT [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,CASE WHEN SUBSTRING(REPLACE(  CONVERT(NVARCHAR(21), [SHIPMENT_DATE], 120 ), ':',''), 12,4) <=  (
																																		SELECT TOP 1 SUBSTRING(V.SEGMENT2, 1, 4)
																																		FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
																																		WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			AND V.ACTIVE_FLAG = 'Y'
																																			AND V.SEGMENT1    = S.PLANT_ID
																																			-- 2022-05-12 kimcd PLANT별 시업 시간 조회 로직 보완
																																		)  THEN
											CONVERT( NVARCHAR(8), DATEADD(DAY, -1, [SHIPMENT_DATE] ), 112 )
										 ELSE													
											CONVERT( NVARCHAR(8), [SHIPMENT_DATE], 112 )
										 END AS [SHIPMENT_DATE]
									,[SHIP_SLOC] AS [STORAGE_ID]  -- 2021-01-19 kimcd MES 출하 정보의 창고를 Pack 창고로 변경
									,[ITEM_ID]
									,QTY 
							   FROM FP_MES_CELL_SHIPMENT_H S
				 			  WHERE RIGHT([RECEIVE_SLOC], 1) = 'T'
								AND SHIPPING_STATUS NOT IN ( 'CANCEL_SHIP', 'CANCEL_SHIPPED', 'SPLITMERGE')	-- 출하 취소
					    ) A
				GROUP BY [COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[SHIPMENT_DATE]
						,[STORAGE_ID]
						,[ITEM_ID]
				) A
		--WHERE ITEM_ID ='ACLF1020U-A2'
		GROUP BY [PLANT_ID]
				,[SHIPMENT_DATE]
				,[BIZ_TYPE]
				,[STORAGE_ID]
				,[ITEM_ID]

		-- 2020-01-30 PIYONG ADD END
		-------------------------------------------------------------------------------------------------------
		) TX,
		SCM_PLANT_M P WITH(NOLOCK)
WHERE TX.PLANT_ID = P.PLANT_ID
AND   EXISTS (  SELECT 1
			    FROM   [dbo].[SCM_ITEM_M]        SIM WITH(NOLOCK)
					 , [dbo].[SCM_ITEM_CLASS_M]  ICM WITH(NOLOCK)
				WHERE  SIM.[COMPANY_ID]   = P.[COMPANY_ID]
				AND    SIM.[DIVISION_ID]  = P.[DIVISION_ID] 
				AND    SIM.[SITE_ID]      = P.[SITE_ID]
				AND    SIM.[ITEM_ID]      = TX.[ITEM_ID]
				AND    ICM.[CLASS_ID]     = SIM.[ITEM_CLASS]
				AND    ICM.[LEVEL_1_NAME] = 'Model'  
					) -- 모델만 조회되도록 구분자 2018-11-21 kimcd











