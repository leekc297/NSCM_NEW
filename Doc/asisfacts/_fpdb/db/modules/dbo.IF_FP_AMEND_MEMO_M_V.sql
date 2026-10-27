




CREATE VIEW [dbo].[IF_FP_AMEND_MEMO_M_V] AS
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
SELECT AMM.[INSTANCE_ID]
      ,AMM.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],AMM.[DIVISION_ID]) AS DIVISION_ID
      ,AMM.[SITE_ID]
      ,AMM.[PLANT_ID]
      ,AMM.[FACTORY_ID]
      ,AMM.[OPERATION_ID]
      ,AMM.[LINE_ID]
      ,AMM.[ELECTRODE_TYPE]
      ,AMM.[EQUIPMENT_ID]
      ,AMM.[PLAN_DATE]
      ,AMM.[MARKET]
      ,AMM.[PRODUCTION_TYPE]
      ,AMM.[TOP_ITEM_ID]
      ,AMM.[ITEM_ID]
      ,AMM.[MEMO]
      ,AMM.[INSERT_ID]
      ,AMM.[INSERT_TIME]
      ,AMM.[UPDATE_ID]
      ,AMM.[UPDATE_TIME]
      ,AMM.[MEMO_TYPE]
      ,AMM.[FP_TIME]
      ,AMM.[IF_TIME]
	  ,AMM.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[FP_AMEND_MEMO_M] AS AMM WITH(NOLOCK)
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON AMM.PLANT_ID = SPD.PLANT_ID
