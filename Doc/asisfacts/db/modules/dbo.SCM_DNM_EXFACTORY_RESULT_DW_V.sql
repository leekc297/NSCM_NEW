


CREATE VIEW [dbo].[SCM_DNM_EXFACTORY_RESULT_DW_V] AS
/*
 * Program ID   : SCM_DNM_EXFACTORY_RESULT_DW_V
 * Description  : 출하실적 정보 : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023.04.03	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT R.COMPANY_ID
       -- 2023.04.01 HM JV, CASE WHEN DIVISION_ID = '81_UC' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	   , D.ATTRIBUTE3	AS DIVISION_ID -- HM JV 가상 사업부 추가 대응
       , R.SITE_ID
       , R.PLANT_ID
       , R.DOC_TYPE
       , R.DOC_SEQ
       , R.ORDER_NO
       , R.ORDER_ITEM_SEQ
       , R.DELIVERY_NO
       , R.DELIVERY_ITEM_SEQ
       , R.ITEM_ID
       , R.ITEM_NAME
       , R.EXFACTORY_STATUS
       , R.PROJECT_CODE
       , R.FROM_SCM_SITE_ID
       , R.TO_SCM_SITE_ID
       , R.PO_NO
       , R.ORDER_QTY
       , R.SOLDTO_CODE
       , R.SOLDTO_NAME
       , R.SHIPTO_NAME
       , R.SHIPTO_CODE
       , R.ORDER_TYPE_CODE
       , R.ORDER_TYPE_NAME
       , R.STORAGE_ID
       , R.ORDER_CREATE_DATE
       , R.DELIVERY_POSTING_DATE
       , R.UOM
       , R.EXFACTORY_QTY
       , R.ON_BOARD_DATE
       , R.ETD_DATE
       , R.ETA_DATE
       , R.ACTUAL_EXFACTORY_DATE
       , R.SYSTEM_EXFACTORY_DATE
       , R.PLANT_ISSUE_DATE
       , R.EXFACTORY_DATE
       , R.TRANSPORT_MODE
       , R.TRANSPORT_MODE_ERP
       , R.INCOTERMS
       , R.ORIGIN_INCOTERMS
       , R.VALID_YN
       , R.CREATED_BY
       , R.CREATION_DATE
       , R.LAST_UPDATED_BY
       , R.LAST_UPDATE_DATE
       , R.ATTRIBUTE1
       , R.ATTRIBUTE2
       , R.ATTRIBUTE3
       , R.ATTRIBUTE4
       , R.ATTRIBUTE5
       , R.ATTRIBUTE6
       , R.ATTRIBUTE7
       , R.ATTRIBUTE8
       , R.ATTRIBUTE9
       , R.ATTRIBUTE10
       , R.ORIGIN_ITEM_ID
       , R.SSP_TYPE
       , R.CONFIRM_ID
       , R.PLAN_EXFACTORY_DATE
       , R.ACTUAL_DELIVERY_DATE
       , R.INTRANSIT_DATE
       , R.FACTORY_OUT_DATE
       , R.CURRENCY_CODE
       , R.NET_PRICE
       , R.SALES_AMOUNT
       , R.KRW_XRATE
       , R.SALES_KRW_AMOUNT
	   , R.DIVISION_ID AS SCM_DIVISION_ID
  FROM   SCM_DNM_EXFACTORY_RESULT R WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- HM JV 가상 사업부 추가 대응
				 ON D.DIVISION_ID = R.DIVISION_ID
				AND D.VALID_YN	  = 'Y'
  ;

