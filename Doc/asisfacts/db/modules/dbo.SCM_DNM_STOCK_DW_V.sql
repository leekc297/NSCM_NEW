



CREATE VIEW [dbo].[SCM_DNM_STOCK_DW_V] AS
/*
 * Program ID   : SCM_DNM_STOCK_DW_V
 * Description  : 재고 : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023.04.03	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT V.SCM_SITE_ID
       , V.COMPANY_ID
       -- HM JV , CASE WHEN DIVISION_ID = '81_UC' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	   , D.ATTRIBUTE3	AS DIVISION_ID -- HM JV 가상 사업부 추가 대응
       , V.SITE_ID
       , V.PLANT_ID
       , V.FACTORY_ID
       , V.STORAGE_ID
       , V.CUTOFF_DATE
       , V.SEQ
       , V.STOCK_TYPE
       , V.ITEM_ID
       , V.ORIGIN_ITEM_ID
       , V.SCM_QTY
       , V.SSP_QTY
       , V.LANE
       , V.PRODUCTION_TYPE
       , V.AVAILABLE_DATE
       , V.REMAIN_LEAD_TIME
       , V.HOLDING_DATE
       , V.QTY
       , V.QTY_UOM
       , V.STOCK_STATUS
       , V.OPERATION_ID
       , V.LINE_ID
       , V.OUTSOURCING_FLAG
       , V.OUTSOURCING_FACTORY  
       , V.DESCRIPTION
       , V.FP_APPLY_OPERATION_ID
       , V.FP_APPLY_ITEM_ID
       , V.FP_APPLY_WIPQTY
       , V.WIPHOLD_YN
       , V.QMS_HOLD_YN
       , V.WIP_TYPE_CODE
       , V.QTY2
       , V.MODIFY_FP_APPLY_WIPQTY
       , V.MODIFY_DESCRIPTION
       , V.CAL_QTY
       , V.FORMATION_REWORK_TYPE
       , V.INSERT_ID
       , V.INSERT_TIME
       , V.UPDATE_ID
       , V.UPDATE_TIME
       , V.LOCATION     
       , V.MOVING_QTY
       , V.CAPA_GRD_CODE
       , V.VLTG_GRD_CODE
       , V.RSST_GRD_CODE
       , V.DEFECT_QTY
       , V.UNHOLD_EXP_DATE
       , V.MES_MAP_SLOC
       , V.MES_HOLD_YN
       , V.MES_UNHOLD_DATE
       , V.QMS_HOLD_DATE
       , V.QMS_UNHOLD_EXP_DATE
       , V.QMS_UNHOLD_DATE
       , V.OPERATION_ID_ORG
       , V.LOCATION_CODE
	   , V.DIVISION_ID AS SCM_DIVISION_ID
  FROM   SCM_DNM_STOCK_V V WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- HM JV 가상 사업부 추가 대응
				 ON D.DIVISION_ID = V.DIVISION_ID 
				AND D.VALID_YN	  = 'Y'
  ;

