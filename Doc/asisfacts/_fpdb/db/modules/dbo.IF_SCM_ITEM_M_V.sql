




CREATE VIEW [dbo].[IF_SCM_ITEM_M_V] AS
-- ================================================================================================
-- Program ID          : IF_SCM_ITEM_M_V
--
-- Program Name        : DW제공 ITEM Master
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : SCM_ITEM_M, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT SIM.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],SIM.[DIVISION_ID]) AS DIVISION_ID
	  ,SIM.[SITE_ID]
      ,SIM.[ITEM_ID]
      ,SIM.[ITEM_NAME]
      ,SIM.[NICK_NAME]
      ,SIM.[ITEM_TYPE]
      ,SIM.[ITEM_CLASS_LEVEL_1]
      ,SIM.[ITEM_CLASS_LEVEL_2]
      ,SIM.[ITEM_CLASS_LEVEL_3]
      ,SIM.[ITEM_CLASS_LEVEL_4]
      ,SIM.[ITEM_CLASS]
      ,SIM.[ITEM_CLASS_NAME]
      ,SIM.[MATERIAL_CLASS]
      ,SIM.[MATERIAL_CLASS_NAME]
      ,SIM.[ELECTRODE_TYPE]
      ,SIM.[SIDE_TYPE]
      ,SIM.[ITEM_GROUP_ID]
      ,SIM.[SETUP_GROUP_ID_1]
      ,SIM.[SETUP_GROUP_ID_2]
      ,SIM.[SETUP_GROUP_ID_3]
      ,SIM.[FLOW_ID]
      ,SIM.[ERP_EOL]
      ,SIM.[SCP_EOL]
      ,SIM.[ITEM_UOM]
      ,SIM.[SPEC]
      ,SIM.[DEMAND_LOT_SIZE]
      ,SIM.[ITEM_ATTRIBUTE]
      ,SIM.[SETUP_ATTRIBUTE]
      ,SIM.[BATCH_RATIO_ID]
      ,SIM.[OUTSOURCING_FACTORY]
      ,SIM.[FINITE_TERM]
      ,SIM.[FINITE_TERM_UOM]
      ,SIM.[COATED_LENGTH]
      ,SIM.[UNCOATED_LENGTH]
      ,SIM.[LENGTH_UOM]
      ,SIM.[SLURRY_LOSS_RATE]
      ,SIM.[DESCRIPTION]
      ,SIM.[ACTIVE_FLAG]
      ,SIM.[INSERT_ID]
      ,SIM.[INSERT_TIME]
      ,SIM.[UPDATE_ID]
      ,SIM.[UPDATE_TIME]
      ,SIM.[APPLIED_MODEL]
      ,SIM.[CELL_TYPE]
      ,SIM.[MAKE_AND_BUY]
      ,SIM.[COLOR_ATTRIBUTE]
      ,SIM.[FORMATION_FLOW_ID]
      ,SIM.[STANDARD_COST]
      ,SIM.[CURRENCY]
      ,SIM.[FORM_ATTRIBUTE]
      ,SIM.[ENERGE]
      ,SIM.[SCP_FLOW_ID]
      ,SIM.[SCP_OPERATION_GROUP]
      ,SIM.[SCP_OPERATION_GROUP_ID]
      ,SIM.[MDM_PROJECT_NAME]
      ,SIM.[MIN_CAPACITY]
      ,SIM.[MOBILE_MODEL_ID]
      ,SIM.[FORECAST_INFO_BIZ_TYPE]
      ,SIM.[FORECAST_INFO_PRODUCT_GROUP]
      ,SIM.[FORECAST_INFO_CELL_MODEL]
      ,SIM.[FORECAST_INFO_CELL_PACK_COUNT]
      ,SIM.[EVAL_CLASS_INFO]
      ,SIM.[FORECAST_INFO_SPEC]
      ,SIM.[FORECAST_INFOR_VERSION]
      ,SIM.[DOE]
      ,SIM.[Insulation_Coating]
      ,SIM.[PACK_PRODUCT_GROUP_CODE]
      ,SIM.[CELL_QUANTITY]
      ,SIM.[SCP_EXTRA_SPEC]
      ,SIM.[SCM_PIC]
      ,SIM.[REP_CUSTOMER]
      ,SIM.[MAKER]
      ,SIM.[EVAL_CLASS]
	  ,SIM.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[SCM_ITEM_M] AS SIM WITH(NOLOCK)
	   LEFT OUTER JOIN ( SELECT SPD.COMPANY_ID, MAX(SPD.ORIGINAL_DIVISION_ID) AS ORIGINAL_DIVISION_ID
 						 FROM [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
						 GROUP BY SPD.COMPANY_ID ) AS SPD
	   ON SIM.COMPANY_ID = SPD.COMPANY_ID
