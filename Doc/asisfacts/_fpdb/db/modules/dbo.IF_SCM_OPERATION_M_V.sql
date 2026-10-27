




CREATE VIEW [dbo].[IF_SCM_OPERATION_M_V] AS
-- ================================================================================================
-- Program ID          : IF_SCM_OPERATION_M_V
--
-- Program Name        : DW제공 Operation Master
-- Param               :
-- Batch Period        : 
-- Description         : SCM 가상 Division 사용에 따른 DW IF용 View
--
-- Source System       : FP  SDB
-- Destination System  : DW
-- Source Table        : SCM_OPERATION_M, SCM_PSEUDO_DIVISION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2022.04.30
-- Author              : kim choon dong
-- Version             : 2022-04-30 kimcd 최초 형성
-- ================================================================================================
SELECT SOM.[COMPANY_ID]
      ,ISNULL(SPD.[ORIGINAL_DIVISION_ID],SOM.[DIVISION_ID]) AS DIVISION_ID
      ,SOM.[SITE_ID]
      ,SOM.[OPERATION_ID]
      ,SOM.[OPERATION_NAME]
      ,SOM.[ERP_OPERATION_ID]
      ,SOM.[OPERATION_GROUP_ID]
      ,SOM.[OPERATION_GROUP_NAME]
      ,SOM.[SHOP_GROUP_ID]
      ,SOM.[WO_FLAG]
      ,SOM.[MO_FLAG]
      ,SOM.[INSTANCE_TYPE]
      ,SOM.[CAPA_TYPE]
      ,SOM.[MES_ERP_INTERFACE_FLAG]
      ,SOM.[ACTIVE_FLAG]
      ,SOM.[AMEND_FLAG]
      ,SOM.[AMEND_MAIN_FLAG]
      ,SOM.[SYNC_FLAG]
      ,SOM.[DEMAND_LOT_FLAG]
      ,SOM.[DESCRIPTION]
      ,SOM.[INSERT_ID]
      ,SOM.[INSERT_TIME]
      ,SOM.[UPDATE_ID]
      ,SOM.[UPDATE_TIME]
	  ,SOM.[DIVISION_ID]   AS SCM_DIVISION_ID
  FROM [LGCE_FPDEV_TR].[dbo].[SCM_OPERATION_M] AS SOM WITH(NOLOCK)
	   LEFT OUTER JOIN ( SELECT SPD.COMPANY_ID, MAX(SPD.ORIGINAL_DIVISION_ID) AS ORIGINAL_DIVISION_ID
 						 FROM [LGCE_FPDEV_TR].[dbo].[SCM_PSEUDO_DIVISION_M] AS SPD WITH(NOLOCK)
						 GROUP BY SPD.COMPANY_ID ) AS SPD
	   ON SOM.COMPANY_ID = SPD.COMPANY_ID
