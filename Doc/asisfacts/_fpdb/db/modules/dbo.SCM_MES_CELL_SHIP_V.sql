





CREATE VIEW [dbo].[SCM_MES_CELL_SHIP_V]
-- ================================================================================================
-- Program ID          :
--
-- Program Name        : SCM_MES_CELL_SHIP_V
-- Param               :
-- Batch Period        : 
-- Description         : MES 특성 계획용 출하 정보 View
--
-- Source System       : 
-- Destination System  : FP SDB
-- Source Table        : FP_MES_CELL_SHIPMENT_H
-- Destination Table   : 
--
-- Create Date		   : 2020.01.16
-- Update Date		   :

-- Author              : PIYONG
-- Version             : 1.0
-- ================================================================================================
AS
SELECT [COMPANY_ID]
		,[DIVISION_ID]
		,[SITE_ID]
		,[PLANT_ID]
		,[SHIPMENT_DATE] AS [SHIP_YYYYMMDD]
		,[BIZ_TYPE]
		,[STORAGE_ID]
		,[ITEM_ID]
		,SUM( QTY ) AS QTY
 FROM (
		SELECT [COMPANY_ID]
			  ,[DIVISION_ID]
			  ,[SITE_ID]
			  ,[PLANT_ID]
			  ,CONVERT( NVARCHAR(8), [SHIPMENT_DATE], 112 ) AS [SHIPMENT_DATE]
			  , 'P' AS [BIZ_TYPE]
			  ,[SHIP_SLOC] AS [STORAGE_ID]
			  ,[ITEM_ID]
			  ,SUM([QTY]) AS QTY
		 FROM FP_MES_CELL_SHIPMENT_H
		 WHERE RIGHT([RECEIVE_SLOC], 1) = 'P'
		  AND SHIPPING_STATUS NOT IN ( 'CANCEL_SHIP', 'CANCEL_SHIPPED', 'SPLITMERGE')	-- 출하 취소
		GROUP BY [COMPANY_ID]
			  ,[DIVISION_ID]
			  ,[SITE_ID]
			  ,[PLANT_ID]
			  ,CONVERT( NVARCHAR(8), [SHIPMENT_DATE], 112 )
			  ,[SHIP_SLOC]
			  ,[ITEM_ID]
		UNION ALL
		SELECT [COMPANY_ID]
			  ,[DIVISION_ID]
			  ,[SITE_ID]
			  ,[PLANT_ID]
			  ,CONVERT( NVARCHAR(8), [SHIPMENT_DATE], 112 ) AS [SHIPMENT_DATE]
			  , 'P' AS [BIZ_TYPE]
			  ,[RECEIVE_SLOC] AS [STORAGE_ID]
			  ,[ITEM_ID]
			  ,-SUM([QTY])AS QTY
		 FROM FP_MES_CELL_SHIPMENT_H
	    WHERE RIGHT([RECEIVE_SLOC], 1) = 'T'
		  AND SHIPPING_STATUS NOT IN ( 'CANCEL_SHIP', 'CANCEL_SHIPPED', 'SPLITMERGE')	-- 출하 취소
		GROUP BY [COMPANY_ID]
			  ,[DIVISION_ID]
			  ,[SITE_ID]
			  ,[PLANT_ID]
			  ,CONVERT( NVARCHAR(8), [SHIPMENT_DATE], 112 )
			  ,[RECEIVE_SLOC]
			  ,[ITEM_ID]
		) A
--WHERE ITEM_ID ='ACLF1020U-A2'
GROUP BY [COMPANY_ID]
		,[DIVISION_ID]
		,[SITE_ID]
		,[PLANT_ID]
		,[SHIPMENT_DATE]
		,[BIZ_TYPE]
		,[STORAGE_ID]
		,[ITEM_ID]


