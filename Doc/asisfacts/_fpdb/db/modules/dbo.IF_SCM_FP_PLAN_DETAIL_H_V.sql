




CREATE VIEW [dbo].[IF_SCM_FP_PLAN_DETAIL_H_V] AS
-- ================================================================================================
-- Program ID          : IF_SCM_FP_PLAN_DETAIL_H_V
--
-- Program Name        : DW제공 동별 계획 배포 이력
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : SCM_FP_PLAN_DETAIL_H, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT FPD.[PLAN_DATE]
      ,FPD.[INSTANCE_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],FPD.[DIVISION_ID]) AS DIVISION_ID
      ,FPD.[FACTORY_ID]
      ,FPD.[PLAN_ID]
      ,FPD.[CONFIRM_ID]
      ,FPD.[CONFIRM_TIME]
      ,FPD.[CONFIRM_FLAG]
      ,FPD.[RELEASE_TIME]
      ,FPD.[RELEASE_FLAG]
      ,FPD.[RELEASE_PLAN_ID]
      ,FPD.[MES_TRANSFER_FLAG]
      ,FPD.[MES_TRANSFER_TIME]
      ,FPD.[DESCRIPTION]
      ,FPD.[INSERT_ID]
      ,FPD.[INSERT_TIME]
      ,FPD.[UPDATE_ID]
      ,FPD.[UPDATE_TIME]
	  ,FPD.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[SCM_FP_PLAN_DETAIL_H] AS FPD WITH(NOLOCK)
       LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_FACTORY_M] AS SF WITH(NOLOCK)
	   ON FPD.FACTORY_ID = SF.FACTORY_ID
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON SF.PLANT_ID = SPD.PLANT_ID
