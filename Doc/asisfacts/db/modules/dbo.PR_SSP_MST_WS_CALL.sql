/*
 * Program ID   : PR_SSP_MST_WS_CALL
 * Description  : Request Drafting Data Load
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/24	MCTheJ        [PJ20189106] 전지.GSCM 고도화 이행- Request Drafting Data Load
 *
 */

CREATE PROCEDURE [dbo].[PR_SSP_MST_WS_CALL]
	
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TMP_DRAFTCACEL_LIST') IS NOT NULL	
		DROP TABLE #TMP_DRAFTCACEL_LIST;
	
    SELECT
		T0.BATCH_ID
		,T0.IFSEQNO
		,T1.SHIPMENT_STATUS
		,T0.CHANGE_REQ_NO
		,T1.LAST_CONFIRM_DATE
		,T1.CONFIRM_ID
		,T1.VERSION_TYPE          
		,T1.SALES_COMPANY_ID      
		,T1.DIVISION_ID           
		,T1.ITEM_ID               
		,T1.FROM_SITE             
		,T1.TO_SITE               
		,T1.YYYYMMDD              
		,T1.QTY                   
		,T1.OPERATION_GROUP       
		,T1.BIZ_TYPE              
		,T1.PROJECT_CODE          
		,T1.FCST_TYPE             
		,T1.FCST_ETD_DATE         
		,T1.FCST_ETA_DATE         
		,T1.ETD_DATE              
		,T1.ETA_DATE              
		,T1.INCOTERMS             
		,T1.INCOTERMS2            
		,T1.TRANSPORT_MODE        
		,T1.D_COUNTRY             
		,T1.D_PORT_CODE           
		,T1.A_COUNTRY             
		,T1.A_PORT_CODE           
		,T1.CUSTOMER_LT           
		,T1.TO_COUNTRY            
		,T1.TO_CITY               
		,T1.FROM_SITE_TYPE        
		,T1.FROM_SITE_PLANT_ID    
		,T1.FROM_SITE_VENDOR_ID   
		,T1.FROM_SITE_SOLDTO_CODE 
		,T1.FROM_SITE_SHIPTO_CODE 
		,T1.FROM_SITE_COMPANY_ID  
		,T1.TO_SITE_TYPE          
		,T1.TO_SITE_PLANT_ID      
		,T1.TO_SITE_VENDOR_ID     
		,T1.TO_SITE_SOLDTO_CODE   
		,T1.TO_SITE_SHIPTO_CODE   
		,T1.TO_SITE_COMPANY_ID  
		,T1.BUILDING
		,T1.REMARK
		,T1.CUSTOMER_REQ
		,T1.CHANGE_CODE
		,T1.CHANGE_CODE_NAME
		,T1.REQUESTOR
		/*----------------------------------------------------------------------------------------
		  2020.06.30 : KBK
		  I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
		------------------------------------------------------------------------------------------*/
		,T1.PACKAGE_TYPE
		,T1.FACTORY_ID
		,T1.PACKAGE_QTY
		,T1.DOM_EXP
		,T1.ERP_ATTR1
		,T1.ERP_ATTR2
		,T1.ERP_ATTR3
		,T1.ERP_ATTR4
		,T1.ERP_ATTR5
	INTO #TMP_DRAFTCACEL_LIST
	FROM SSP_MST_WS_CALL T0 WITH(NOLOCK)
	INNER JOIN XIF_ERP_SHIP_PLAN_CONFIRM_S_SN T1 WITH(NOLOCK)
		ON T0.IFSEQNO = T1.IFSEQNO
	WHERE WS_CALL_FLAG = 'N';

	-- 전송대상 PK목록
	SELECT
		BATCH_ID
		,IFSEQNO
		,SHIPMENT_STATUS
		,CHANGE_REQ_NO
		,MAX(LAST_CONFIRM_DATE) AS LAST_CONFIRM_DATE
	FROM #TMP_DRAFTCACEL_LIST
	GROUP BY BATCH_ID, IFSEQNO, SHIPMENT_STATUS, CHANGE_REQ_NO
	ORDER BY BATCH_ID, IFSEQNO, CHANGE_REQ_NO, SHIPMENT_STATUS;

	-- 전송대상
	SELECT
		BATCH_ID
		,IFSEQNO
		,SHIPMENT_STATUS
		,CHANGE_REQ_NO
		,CONFIRM_ID
		,VERSION_TYPE          
		,SALES_COMPANY_ID      
		,DIVISION_ID           
		,ITEM_ID               
		,FROM_SITE             
		,TO_SITE               
		,YYYYMMDD              
		,QTY                   
		,OPERATION_GROUP       
		,BIZ_TYPE              
		,PROJECT_CODE          
		,FCST_TYPE             
		,FCST_ETD_DATE         
		,FCST_ETA_DATE         
		,ETD_DATE              
		,ETA_DATE              
		,INCOTERMS             
		,INCOTERMS2            
		,TRANSPORT_MODE        
		,D_COUNTRY             
		,D_PORT_CODE           
		,A_COUNTRY             
		,A_PORT_CODE           
		,CUSTOMER_LT           
		,TO_COUNTRY            
		,TO_CITY               
		,FROM_SITE_TYPE        
		,FROM_SITE_PLANT_ID    
		,FROM_SITE_VENDOR_ID   
		,FROM_SITE_SOLDTO_CODE 
		,FROM_SITE_SHIPTO_CODE 
		,FROM_SITE_COMPANY_ID  
		,TO_SITE_TYPE          
		,TO_SITE_PLANT_ID      
		,TO_SITE_VENDOR_ID     
		,TO_SITE_SOLDTO_CODE   
		,TO_SITE_SHIPTO_CODE   
		,TO_SITE_COMPANY_ID  
		,BUILDING
		,REMARK
		,CUSTOMER_REQ
		,CHANGE_CODE
		,CHANGE_CODE_NAME
		,REQUESTOR
		/*----------------------------------------------------------------------------------------
		  2020.06.30 : KBK
		  I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
		------------------------------------------------------------------------------------------*/
		,PACKAGE_TYPE
		,FACTORY_ID
		,PACKAGE_QTY
		,DOM_EXP
		,ERP_ATTR1
		,ERP_ATTR2
		,ERP_ATTR3
		,ERP_ATTR4
		,ERP_ATTR5
	FROM #TMP_DRAFTCACEL_LIST
	ORDER BY BATCH_ID, IFSEQNO, CHANGE_REQ_NO, SHIPMENT_STATUS;

	IF OBJECT_ID('tempdb..#TMP_DRAFTCACEL_LIST') IS NOT NULL	
		DROP TABLE #TMP_DRAFTCACEL_LIST;
END
