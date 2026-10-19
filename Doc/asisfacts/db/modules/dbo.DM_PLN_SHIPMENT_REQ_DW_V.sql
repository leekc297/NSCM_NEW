




CREATE VIEW [dbo].[DM_PLN_SHIPMENT_REQ_DW_V]
AS
/*
 * Program ID   : DM_PLN_SHIPMENT_REQ_DW_V
 * Description  : DM_PLN_SHIPMENT_REQ 조회
                  소속 DIVISION_ID로 정보를 조회 하기 위해서
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.01   SSP Pjt.       Created
 */

	SELECT D.ATTRIBUTE3		AS DIVISION_ID
		  ,S.[PROJECT_CODE]
		  ,S.[SCM_SITE_ID]
		  ,S.[ITEM_ID]
		  ,S.[FCST_TYPE]
		  ,S.[INCOTERMS]
		  ,S.[TRANSPORT_MODE]
		  ,S.[BOD_ID]
		  ,S.[MEASURE]
		  ,S.[PLANT_SITE_ID]
		  ,S.[SITE_TYPE]
		  ,S.[YYYYMMDD]
		  ,S.[QTY]
		  ,S.[CREATED_BY]
		  ,S.[CREATION_DATE]
		  ,S.[LAST_UPDATED_BY]
		  ,S.[LAST_UPDATE_DATE]
		  ,S.[ATTRIBUTE1]
		  ,S.[ATTRIBUTE2]
		  ,S.[ATTRIBUTE3]
		  ,S.[ATTRIBUTE4]
		  ,S.[ATTRIBUTE5]
		  ,S.[ATTRIBUTE6]
		  ,S.[ATTRIBUTE7]
		  ,S.[ATTRIBUTE8]
		  ,S.[ATTRIBUTE9]
		  ,S.[ATTRIBUTE10]
		  ,S.DIVISION_ID	AS SCM_DIVISION_ID
	  FROM [dbo].[DM_PLN_SHIPMENT_REQ] AS S WITH(NOLOCK)
	       JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
		ON S.DIVISION_ID = D.DIVISION_ID

