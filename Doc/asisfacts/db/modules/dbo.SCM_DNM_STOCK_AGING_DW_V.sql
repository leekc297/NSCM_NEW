



CREATE VIEW [dbo].[SCM_DNM_STOCK_AGING_DW_V] AS
/*
 * Program ID   : SCM_DNM_STOCK_AGING_DW_V
 * Description  : 활성화재고 : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023.04.03	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT V.COMPANY_ID       
       -- HM JV , CASE WHEN DIVISION_ID = '81_UC' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	   , D.ATTRIBUTE3	AS DIVISION_ID -- HM JV 가상 사업부 추가 대응
       , V.SCM_SITE_ID
       , V.SITE_ID
       , V.PLANT_ID
       , V.FACTORY_ID
       , V.ROUTE_ID
       , V.LINE_ID
       , V.CUTOFF_DATE
       , V.SEQ
       , V.ITEM_ID
       , V.ORIGIN_ITEM_ID
       , V.PRODUCTION_TYPE
       , V.FCS_INPUT_DATE
       , V.AVAILABLE_DATE
       , V.REMAIN_LEAD_TIME
       , V.HOLDING_DATE
       , V.INPUT_QTY
       , V.QTY
       , V.QTY_UOM
       , V.STOCK_STATUS
       , V.OPERATION_ID
       , V.OPERATION_SEQ
       , V.OP_START_TIME
       , V.TRAY_OP_STATUS
       , V.STOCK_TYPE
       , V.WIPHOLD_YN
       , V.UNHOLD_EXP_DATE
       , V.SPECIAL_YN
       , V.LOT_ID
       , V.OCV2_END_TIME
       , V.SHIP_AVAILABLE_DATE
       , V.BEFORE_DEGAS
       , V.DEGAS_END_DATE
       , V.INSERT_ID
       , V.INSERT_TIME
       , V.UPDATE_ID
       , V.UPDATE_TIME
       , V.OPERATION_GROUP
       , V.NICK_NAME
       , V.AGING_AVAILABLE_DATE  
	   , V.DIVISION_ID AS SCM_DIVISION_ID
  FROM   SCM_DNM_STOCK_AGING_V V WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- HM JV 가상 사업부 추가 대응
				 ON D.DIVISION_ID = V.DIVISION_ID 
				AND D.VALID_YN	  = 'Y'
  ;

