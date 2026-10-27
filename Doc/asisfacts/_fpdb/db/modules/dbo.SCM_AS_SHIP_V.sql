
CREATE VIEW [dbo].[SCM_AS_SHIP_V]
-- ================================================================================================
-- Program ID          : SCM_AS_SHIP_V
--
-- Program Name        : SCM_AS_SHIP_V
-- Param               :
-- Batch Period        : 
-- Description         : AS 재고 이동 정보 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_AS_MATERIAL_DOCUMENT_H, SCM_ITEM_M, SCM_ITEM_CLASS_M
-- Destination Table   : 
--
-- Create(Update) Date : 2024.08.29
-- Author              : kim choon dong
-- Version             : 2024.08.29 kimcd 최초 형성
-- ================================================================================================
AS
SELECT P.[COMPANY_ID]
      ,P.[DIVISION_ID]
      ,P.[SITE_ID]
      ,P.[PLANT_ID]
      ,TX.[SHIP_YYYYMMDD]
	  ,TX.[STORAGE_ID]
      ,TX.[ITEM_ID]
	  ,TX.[QTY]
FROM  ( SELECT TX.SHIP_YYYYMMDD
			  ,TX.ITEM_ID
			  ,TX.PLANT_ID
			  ,TX.STORAGE_ID
			  ,SUM(QTY) AS QTY
		FROM  ( SELECT TX.DOC_POSTING_DATE AS SHIP_YYYYMMDD
					  ,TX.ITEM_ID
					  ,TX.PLANT_ID
					  ,TX.STORAGE_ID
					  ,CASE WHEN TX.INDICATOR = LV.ATTRIBUTE1 THEN TX.MAT_QTY ELSE CASE WHEN LV.ATTRIBUTE2 = 'N' THEN 0 ELSE -1 * TX.MAT_QTY END END AS QTY
				FROM   [DBO].[SCM_AS_MATERIAL_DOCUMENT_H] TX WITH(NOLOCK),
					   [DBO].[SCM_SYS_LOOKUP_VALUE]        LV WITH(NOLOCK)
				WHERE  TX.PLANT_ID = LV.SEGMENT1
				AND    TX.STORAGE_ID = LV.SEGMENT2
				AND    TX.MOVEMENT_TYPE = LV.SEGMENT3
				AND    LV.LOOKUP_TYPE_CODE = 'ERP_AS_DOCUMENT_MAPPING'
				AND    LV.ACTIVE_FLAG = 'Y'
				AND    TX.IO_STORAGE_ID LIKE (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='SCM_AS_SHIP_V' AND SEGMENT1  = '1' AND ACTIVE_FLAG = 'Y')
				) TX
		GROUP BY TX.SHIP_YYYYMMDD
				,TX.ITEM_ID
				,TX.PLANT_ID
			    ,TX.STORAGE_ID
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
