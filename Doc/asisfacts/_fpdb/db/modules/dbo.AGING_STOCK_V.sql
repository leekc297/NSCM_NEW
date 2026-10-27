


CREATE VIEW [dbo].[AGING_STOCK_V]
-- ================================================================================================
-- Program ID          : AGING_STOCK_V
--
-- Program Name        : AGING_STOCK_V
-- Param               :
-- Batch Period        : 
-- Description         : SCP에 활성화 Aging 재고 조회 제공View
--
-- Source System       : FP SDB
-- Destination System  : GSCM SDB
-- Source Table        : SCM_AGING_STOCK_H, FP_FORMATION_SHORTER_LT_M
-- Destination Table   : 
--
-- Create(Update) Date : 2020.06.22
-- Author              : PIYONG
-- Version             :             PIYONG 신규 생성
--                       2020-06-22  KIMCD  short l/t 정보가 공정별로 관리됨. 공정 값 합산하도록 로직 수정
-- ================================================================================================
AS
	SELECT A.[COMPANY_ID]
		  ,A.[DIVISION_ID]
		  ,A.[SITE_ID]
		  ,A.[PLANT_ID]
		  ,A.[FACTORY_ID]
		  ,A.[ROUTE_ID]
		  ,A.[LINE_ID]
		  ,A.[CUTOFF_DATE]
		  ,A.[SEQ]
		  ,A.[ITEM_ID]
		  ,A.[PRODUCTION_TYPE]
		  ,A.[FCS_INPUT_DATE]
		  ,CASE WHEN BEFORE_DEGAS = 'Y' THEN
					DATEADD(DAY , ISNULL(case when D.SHORTER_LT < 0 then floor(D.SHORTER_LT) else  ceiling(D.SHORTER_LT) end  , 0 ) ,A.AVAILABLE_DATE)
				ELSE
					A.AVAILABLE_DATE
				END   AS AGING_AVAILABLE_DATE
		  ,A.[REMAIN_LEAD_TIME]
		  ,A.[HOLDING_DATE]
		  ,A.[INPUT_QTY]
		  ,A.[QTY]
		  ,A.[QTY_UOM]
		  ,A.[STOCK_STATUS]
		  ,A.[OPERATION_ID]
		  ,A.[OPERATION_SEQ]
		  ,A.[OP_START_TIME]
		  ,A.[TRAY_OP_STATUS]
		  ,A.[STOCK_TYPE]
		  ,A.[WIPHOLD_YN]
		  ,A.[UNHOLD_EXP_DATE]
		  ,A.[SPECIAL_YN]
		  ,A.[LOT_ID]
		  ,A.[OCV2_END_TIME]
		  ,A.[SHIP_AVAILABLE_DATE]
		  ,A.[BEFORE_DEGAS]
		  ,A.[DEGAS_END_DATE]
		  ,A.[INSERT_ID]
		  ,A.[INSERT_TIME]
		  ,A.[UPDATE_ID]
		  ,A.[UPDATE_TIME]
	  FROM [LGCE_FPDEV_TR].[dbo].[SCM_AGING_STOCK_H] A WITH(NOLOCK)
		LEFT OUTER JOIN ( SELECT   D.COMPANY_ID,
								   D.DIVISION_ID,
								   D.SITE_ID,
								   D.PLANT_ID,
								   D.FACTORY_ID,
								   D.LINE_ID,
								   D.ITEM_ID,
								   SUM(D.SHORTER_LT) AS SHORTER_LT
		                  FROM     LGCE_FPDEV_TR.DBO.FP_FORMATION_SHORTER_LT_M D WITH(NOLOCK)
						  GROUP BY D.COMPANY_ID,
								   D.DIVISION_ID,
								   D.SITE_ID,
								   D.PLANT_ID,
								   D.FACTORY_ID,
								   D.LINE_ID,
								   D.ITEM_ID ) D   -- 2020-06-22  KIMCD  short l/t 정보가 공정별로 관리됨. 공정 값 합산하도록 로직 수정
						ON     A.COMPANY_ID = D.COMPANY_ID
						AND   A.DIVISION_ID = D.DIVISION_ID
						AND   A.SITE_ID = D.SITE_ID
						AND   A.PLANT_ID = D.PLANT_ID
						AND   A.FACTORY_ID = D.FACTORY_ID
						AND   A.LINE_ID = D.LINE_ID
						AND   A.ITEM_ID = D.ITEM_ID



