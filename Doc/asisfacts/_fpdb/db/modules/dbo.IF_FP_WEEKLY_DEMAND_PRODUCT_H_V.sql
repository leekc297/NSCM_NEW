




CREATE VIEW [dbo].[IF_FP_WEEKLY_DEMAND_PRODUCT_H_V] AS
-- ================================================================================================
-- Program ID          : IF_FP_WEEKLY_DEMAND_PRODUCT_H_V
--
-- Program Name        : DW제공 생산 Target 정보
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : FP_WEEKLY_DEMAND_PRODUCT_H, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT WDP.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],WDP.[DIVISION_ID]) AS DIVISION_ID
	  ,WDP.[SITE_ID]
      ,WDP.[PLANT_ID]
      ,WDP.[SHOP_GROUP_ID]
      ,WDP.[SCP_PLAN_ID]
      ,WDP.[SCP_TARGET_ID]
      ,WDP.[MARKET]
      ,WDP.[ITEM_ID]
      ,WDP.[MFG_WEEK]
      ,WDP.[MFG_QTY]
      ,WDP.[CHG_QTY]
      ,WDP.[PRODUCTION_TYPE]
      ,WDP.[SAMPLE_FROM_DATE]
      ,WDP.[SAMPLE_TO_DATE]
      ,WDP.[LINE_ID]
      ,WDP.[PRIORITY]
      ,WDP.[PERIOD_TYPE]
      ,WDP.[CONFIRM_TYPE]
      ,WDP.[DEMAND_TYPE]
      ,WDP.[INSERT_ID]
      ,WDP.[INSERT_TIME]
      ,WDP.[UPDATE_ID]
      ,WDP.[UPDATE_TIME]
      ,WDP.[OPERATION_ID]
      ,WDP.[MFG_DATE]
	  ,WDP.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] AS WDP WITH(NOLOCK)
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON WDP.PLANT_ID = SPD.PLANT_ID
