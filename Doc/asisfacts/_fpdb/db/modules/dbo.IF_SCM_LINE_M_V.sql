





CREATE VIEW [dbo].[IF_SCM_LINE_M_V] AS
-- ================================================================================================
-- Program ID          : IF_SCM_LINE_M_V
--
-- Program Name        : DW제공 라인 Master
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : SCM_LINE_M, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT SLM.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],SLM.[DIVISION_ID]) AS DIVISION_ID
      ,SLM.[SITE_ID]
      ,SLM.[PLANT_ID]
      ,SLM.[FACTORY_ID]
      ,SLM.[OPERATION_ID]
      ,SLM.[LINE_ID]
      ,SLM.[LINE_NAME]
      ,SLM.[ELECTRODE_TYPE]
      ,SLM.[LINE_TYPE]
      ,SLM.[LINE_TYPE_NAME]
      ,SLM.[LINE_SETUP_GROUP_ID]
      ,SLM.[ACTIVE_FLAG]
      ,SLM.[TOP_LINE_ID]
      ,SLM.[DESCRIPTION]
      ,SLM.[SCP_LINE_ID]
      ,SLM.[MODEL_TYPE]
      ,SLM.[INSERT_ID]
      ,SLM.[INSERT_TIME]
      ,SLM.[UPDATE_ID]
      ,SLM.[UPDATE_TIME]
      ,SLM.[LINE_ATTR_1]
      ,SLM.[LOCATION]
      ,SLM.[MES_LINE_NAME]
      ,SLM.[PROD_VERSION_TYPE]
      ,SLM.[DOMESTIC_SLOC_ID]
      ,SLM.[EXPORT_SLOC_ID]
      ,SLM.[COMP_DOMESTIC_SLOC_ID]
      ,SLM.[COMP_EXPORT_SLOC_ID]
	  ,SLM.[DIVISION_ID]   AS SCM_DIVISION_ID
	  ,SLM.MES_LINE_ID
  FROM [LGCE_FPDEV_TR].[dbo].[SCM_LINE_M] AS SLM WITH(NOLOCK)
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON SLM.PLANT_ID = SPD.PLANT_ID
