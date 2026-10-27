
CREATE VIEW [dbo].[FP_ITEM_CELL_EXCHANGE_UI_V]
-- ================================================================================================
-- Program ID          : FP_ITEM_CELL_EXCHANGE_UI_V
--
-- Program Name        : FP_ITEM_CELL_EXCHANGE_UI_V
-- Param               :
-- Batch Period        : 
-- Description         : Cell 기준 하위 구성품 소요량 조회. 품목은 정확하나 날짜 없는 View이기 때문에 소료량을 부정확함
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_MODEL_COMP_EFFECTIVE_DATE
-- Destination Table   : 
--
-- Create(Update) Date : 2019.07.16
-- Author              : kim choon dong
-- Version             : 2019-07-16 kimcd 일자별 BOM 전개 정보에 소요량 정보 형성 후 처음 형성
-- ================================================================================================
AS
SELECT COMPANY_ID
     , DIVISION_ID
     , SITE_ID
     , PLANT_ID
     , MODEL_ID
     , CHILD_ITEM_ID              AS ITEM_ID
     , SUM(ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
FROM  (SELECT MCT.COMPANY_ID
			, MCT.DIVISION_ID
			, MCT.SITE_ID
			, MCT.PLANT_ID
			, MCT.MODEL_ID
			, MCT.CHILD_ITEM_ID
            , MCT.ACCUMULATED_CHILD_QTY
	   FROM  ( SELECT MCT.COMPANY_ID
					, MCT.DIVISION_ID
					, MCT.SITE_ID
					, MCT.PLANT_ID
					, MCT.MODEL_ID
					, MCT.CHILD_ITEM_ID
					, MCT.ACCUMULATED_CHILD_QTY
					, ROW_NUMBER() OVER (PARTITION BY	MCT.COMPANY_ID, MCT.DIVISION_ID, MCT.SITE_ID, MCT.PLANT_ID,	MCT.MODEL_ID, MCT.CONCATENATE_ITEM
					                     ORDER BY MCT.EFF_START_DATE ) AS ROW_NUM
			   FROM   SCM_MODEL_COMP_EFFECTIVE_DATE MCT WITH(NOLOCK)
		       WHERE  MCT.EFF_END_DATE > GETDATE() 
			   	AND   MCT.CHILD_PLANT_ID  = ( SELECT MAX(MCTI.CHILD_PLANT_ID)
											  FROM   SCM_MODEL_COMP_EFFECTIVE_DATE MCTI WITH(NOLOCK) 
											  WHERE  MCTI.PLANT_ID        = MCT.PLANT_ID
											  AND    MCTI.MODEL_ID        = MCT.MODEL_ID
											  AND    MCTI.CHILD_ITEM_ID   = MCT.CHILD_ITEM_ID 
											  AND    MCTI.EFF_END_DATE    > GETDATE() )
			   ) MCT
	   WHERE  MCT.ROW_NUM = 1 ) MCT
GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CHILD_ITEM_ID

