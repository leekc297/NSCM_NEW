





CREATE VIEW [dbo].[SCM_STOCK_H_V] AS
-- ================================================================================================
-- Program ID          : [dbo].[SCM_STOCK_H_V]
--
-- Program Name        : 재고조회
-- Param               :
-- Batch Period        : 
-- Description         : 
--                       
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2023.04.06
-- Author              : FP Pjt.
-- Version             : 
--                       2024.01.01 특별재고 제외(O : 공급업체가 보유한 재고, W 판매 재고)        
--                       
--                       
-- ================================================================================================

SELECT   *
FROM   SCM_STOCK_H WITH(NOLOCK)
WHERE 1 = 1
AND SPECIAL_STOCK_INDICATOR IS NULL
--AND ISNULL(SPECIAL_STOCK_INDICATOR, 'X') NOT IN ('W', 'E', 'O')


