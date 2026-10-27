




CREATE VIEW [dbo].[IF_FP_DAILY_PRODUCTIOIN_PLAN_H_V] AS
-- ================================================================================================
-- Program ID          : IF_FP_AMEND_MEMO_M_V
--
-- Program Name        : DW제공 계획 메모 이력
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : FP_AMEND_MEMO_M, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT PPH.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],PPH.[DIVISION_ID]) AS DIVISION_ID
      ,PPH.[SITE_ID]
      ,PPH.[PLANT_ID]
      ,PPH.[FACTORY_ID]
      ,PPH.[PLAN_GROUP_ID]
      ,PPH.[INSTANCE_TYPE]
      ,PPH.[TOP_ITEM_ID]
      ,PPH.[ITEM_ID]
      ,PPH.[OPERATION_ID]
      ,PPH.[LOCATION]
      ,PPH.[PRODUCTION_TYPE]
      ,PPH.[MARKET]
      ,PPH.[LINE_ID]
      ,PPH.[ELECTRODE_TYPE]
      ,PPH.[PLAN_DATE]
      ,PPH.[PLAN_QTY]
      ,PPH.[PLAN_IN_QTY]
      ,PPH.[INSERT_ID]
      ,PPH.[INSERT_TIME]
      ,PPH.[UPDATE_ID]
      ,PPH.[UPDATE_TIME]
      ,PPH.[PLAN_TYPE]
      ,PPH.[EQUIPMENT_ID]
      ,PPH.[FP_PRODUCTION_TYPE]
      ,PPH.[ROLL_IN_QTY]
      ,PPH.[ROLL_OUT_QTY]
      ,PPH.[JR_IN_QTY]
      ,PPH.[JR_OUT_QTY]
      ,PPH.[BATCH_IN_QTY]
      ,PPH.[BATCH_OUT_QTY]
      ,PPH.[CELL_IN_QTY]
      ,PPH.[CELL_OUT_QTY]
      ,PPH.[FULL_CLEANING_FLAG]
      ,PPH.[MODEL_TYPE_CHANGE_FLAG]
      ,PPH.[SEQ]
      ,PPH.[CELL_MATERIAL_ID]
      ,PPH.[TOTAL_BATCH]
      ,PPH.[PIG_CLEANING_FLAG]
      ,PPH.[SETUP_COLOR_CODE]
      ,PPH.[SHIFT]
	  ,PPH.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[FP_DAILY_PRODUCTIOIN_PLAN_H] AS PPH WITH(NOLOCK)
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON PPH.PLANT_ID = SPD.PLANT_ID
