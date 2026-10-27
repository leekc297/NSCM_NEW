




CREATE VIEW [dbo].[IF_SCM_YIELD_M_V] AS
-- ================================================================================================
-- Program ID          : IF_SCM_YIELD_M_V
--
-- Program Name        : DW제공 수율 Master
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : SCM_YIELD_M, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT SYM.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],SYM.[DIVISION_ID]) AS DIVISION_ID
      ,SYM.[SITE_ID]
      ,SYM.[PLANT_ID]
      ,SYM.[FACTORY_ID]
      ,SYM.[OPERATION_ID]
      ,SYM.[LINE_ID]
      ,SYM.[ITEM_ID]
      ,SYM.[MONTH]
      ,SYM.[WORK_CENTER_ID]
      ,SYM.[YIELD]
      ,SYM.[DESCRIPTION]
      ,SYM.[INSERT_ID]
      ,SYM.[INSERT_TIME]
      ,SYM.[UPDATE_ID]
      ,SYM.[UPDATE_TIME]
      ,SYM.[RESULT_YIELD]
	  ,SYM.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[SCM_YIELD_M] AS SYM WITH(NOLOCK)
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON SYM.PLANT_ID = SPD.PLANT_ID
