




CREATE VIEW [dbo].[IF_FP_MPP_WPP_BASE_PLAN_H_V] AS
-- ================================================================================================
-- Program ID          : IF_FP_MPP_WPP_BASE_PLAN_H_V
--
-- Program Name        : DW제공 MPP WPP 기준 계획 Header
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : FP_MPP_WPP_BASE_PLAN_H, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.05.04
-- Author              : kim choon dong
-- Version             : 2022-05-04 kimcd 최초 형성
-- ================================================================================================
SELECT MWH.[PLAN_WEEK]
      ,MWH.[PLAN_REVISION]
	  ,MWH.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],MWH.[DIVISION_ID]) AS DIVISION_ID
	  ,MWH.[SITE_ID]
      ,MWH.[PLANT_ID]
      ,MWH.[FACTORY_ID]
      ,MWH.[INSTANCE_ID]
      ,MWH.[PLAN_MONTH]
      ,MWH.[WPP]
      ,MWH.[MPP]
      ,MWH.[MRP]
      ,MWH.[WO]
      ,MWH.[PLAN_DESCRIPTION]
      ,MWH.[INSERT_ID]
      ,MWH.[INSERT_TIME]
      ,MWH.[UPDATE_ID]
      ,MWH.[UPDATE_TIME]
      ,MWH.[PLAN_GROUP_ID]
	  ,MWH.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[FP_MPP_WPP_BASE_PLAN_H] AS MWH WITH(NOLOCK)
	   LEFT OUTER JOIN [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
	   ON MWH.PLANT_ID = SPD.PLANT_ID
