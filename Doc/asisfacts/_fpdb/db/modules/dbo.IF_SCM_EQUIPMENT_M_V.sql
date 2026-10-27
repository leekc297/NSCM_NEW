




CREATE VIEW [dbo].[IF_SCM_EQUIPMENT_M_V] AS
-- ================================================================================================
-- Program ID          : IF_SCM_EQUIPMENT_M_V
--
-- Program Name        : DW제공 설비 Master
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : SCM_EQUIPMENT_M, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT EM.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],EM.[DIVISION_ID]) AS DIVISION_ID
      ,EM.[SITE_ID]
      ,EM.[PLANT_ID]
      ,EM.[FACTORY_ID]
      ,EM.[EQUIPMENT_ID]
      ,EM.[EQUIPMENT_NAME]
      ,EM.[OPERATION_ID]
      ,EM.[LINE_ID]
      ,EM.[MES_LINE_ID]
      ,EM.[WORK_CENTER_ID]
      ,EM.[EQUIPMENT_TYPE]
      ,EM.[ELECTRODE_TYPE]
      ,EM.[LINE_TYPE]
      ,EM.[ACTIVE_FLAG]
      ,EM.[DESCRIPTION]
      ,EM.[INSERT_ID]
      ,EM.[INSERT_TIME]
      ,EM.[UPDATE_ID]
      ,EM.[UPDATE_TIME]
      ,EM.[COATER_EQPT_TYPE_CODE]
      ,EM.[LOCATION]
	  ,EM.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[SCM_EQUIPMENT_M] AS EM WITH(NOLOCK)
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON EM.PLANT_ID = SPD.PLANT_ID
