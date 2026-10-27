




CREATE VIEW [dbo].[IF_FP_MPP_WPP_BASE_PLAN_M_V] AS
-- ================================================================================================
-- Program ID          : IF_FP_MPP_WPP_BASE_PLAN_M_V
--
-- Program Name        : DW제공 MPP WPP 기준 계획 상세
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : FP_MPP_WPP_BASE_PLAN_M, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT MWM.[PLAN_WEEK]
      ,MWM.[PLAN_REVISION]
      ,MWM.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],MWM.[DIVISION_ID]) AS DIVISION_ID
	  ,MWM.[SITE_ID]
      ,MWM.[PLANT_ID]
      ,MWM.[FACTORY_ID]
      ,MWM.[LINE_ID]
      ,MWM.[OPERATION_ID]
      ,MWM.[EQUIPMENT_ID]
      ,MWM.[PRODUCTION_TYPE]
      ,MWM.[ITEM_ID]
      ,MWM.[PLAN_DATE]
      ,MWM.[PLAN_QTY]
      ,MWM.[ROLL_IN_QTY]
      ,MWM.[ROLL_QTY]
      ,MWM.[JR_IN_QTY]
      ,MWM.[JR_QTY]
      ,MWM.[CELL_IN_QTY]
      ,MWM.[CELL_QTY]
      ,MWM.[BATCH_IN_QTY]
      ,MWM.[BATCH_QTY]
      ,MWM.[INSERT_ID]
      ,MWM.[INSERT_TIME]
      ,MWM.[UPDATE_ID]
      ,MWM.[UPDATE_TIME]
      ,MWM.[MARKET]
	  ,MWM.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[FP_MPP_WPP_BASE_PLAN_M] AS MWM WITH(NOLOCK)
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON MWM.PLANT_ID = SPD.PLANT_ID
