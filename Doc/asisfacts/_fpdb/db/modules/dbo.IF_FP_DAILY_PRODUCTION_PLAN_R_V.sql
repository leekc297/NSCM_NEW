




CREATE VIEW [dbo].[IF_FP_DAILY_PRODUCTION_PLAN_R_V] AS
-- ================================================================================================
-- Program ID          : IF_FP_DAILY_PRODUCTION_PLAN_R_V
--
-- Program Name        : DW제공 일자별 계획 결과 이력
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_R, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT DPP.[INSTANCE_ID]
      ,DPP.[FP_PLAN_ID]
      ,DPP.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],DPP.[DIVISION_ID]) AS DIVISION_ID
	  ,DPP.[SITE_ID]
      ,DPP.[PLANT_ID]
      ,DPP.[FACTORY_ID]
      ,DPP.[WORK_ORDER_SPL_ID]
      ,DPP.[WORK_ORDER_ID]
      ,DPP.[ORG_DEMAND_ID]
      ,DPP.[DEMAND_ID]
      ,DPP.[ITEM_ID]
      ,DPP.[TOP_ITEM_ID]
      ,DPP.[OPERATION_ID]
      ,DPP.[LINE_ID]
      ,DPP.[ELECTRODE_TYPE]
      ,DPP.[EQUIPMENT_ID]
      ,DPP.[PLAN_DATE]
      ,DPP.[START_TIME]
      ,DPP.[END_TIME]
      ,DPP.[PLAN_QTY]
      ,DPP.[PLAN_IN_QTY]
      ,DPP.[PLAN_LATE_QTY]
      ,DPP.[ITEM_UOM]
      ,DPP.[ROLL_IN_QTY]
      ,DPP.[ROLL_OUT_QTY]
      ,DPP.[ROLL_LATE_QTY]
      ,DPP.[JR_IN_QTY]
      ,DPP.[JR_OUT_QTY]
      ,DPP.[JR_LATE_QTY]
      ,DPP.[CELL_IN_QTY]
      ,DPP.[CELL_OUT_QTY]
      ,DPP.[BATCH_IN_QTY]
      ,DPP.[BATCH_OUT_QTY]
      ,DPP.[BATCH_LATE_QTY]
      ,DPP.[FIX_TYPE]
      ,DPP.[PRODUCTION_TYPE]
      ,DPP.[TOTAL_WORKING_TIME]
      ,DPP.[LINE_ITEM_SEQ]
      ,DPP.[OPERATION_ITEM_SEQ]
      ,DPP.[LANE_QTY]
      ,DPP.[LANE_TACT_QTY]
      ,DPP.[BATCH_ORDER_ID]
      ,DPP.[BIN_ORDER_ID]
      ,DPP.[MFG_WEEK]
      ,DPP.[DEMAND_DIVISION_ID]
      ,DPP.[MARKET]
      ,DPP.[FP_PRODUCTION_TYPE]
      ,DPP.[INSERT_ID]
      ,DPP.[INSERT_DTTM]
      ,DPP.[FULL_CLEANING_FLAG]
      ,DPP.[MODEL_TYPE_CHANGE_FLAG]
      ,DPP.[SEQ]
      ,DPP.[CELL_MATERIAL_ID]
      ,DPP.[CALC_TYPE]
      ,DPP.[CALC_VERSION]
      ,DPP.[TOTAL_BATCH]
      ,DPP.[PIG_CLEANING_FLAG]
      ,DPP.[SETUP_COLOR_CODE]
	  ,DPP.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[FP_DAILY_PRODUCTION_PLAN_R] AS DPP WITH(NOLOCK)
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON DPP.PLANT_ID = SPD.PLANT_ID
