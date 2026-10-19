


CREATE VIEW [dbo].[SSP_DNM_SHIP_RESULT_OWMS_DW_V]
AS
/*
 * Program ID   : SSP_DNM_SHIP_RESULT_OWMS_DW_V
 * Description  : SSP_DNM_SHIP_RESULT_OWMS 조회
                  소속 DIVISION_ID로 정보를 조회 하기 위해서
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.01   SSP Pjt.       Created
 */

	SELECT D.ATTRIBUTE3 AS DIVISION_ID
		  ,S.[FROM_SITE]
		  ,S.[ITEM_ID]
		  ,S.[TO_SITE]
		  ,S.[CUSTOMER_CODE]
		  ,S.[PLANT_ISSUE_DATE]
		  ,S.[DELIVERY_NO]
		  ,S.[PALLET_ID]
		  ,S.[LOT_ID]
		  ,S.[GRADE]
		  ,S.[STORAGE_ID]
		  ,S.[LOT_QTY]
		  ,S.[SHIP_TYPE]
		  ,S.[SHIP_STATUS]
		  ,S.[CAPACITY_GRADE]
		  ,S.[CREATION_DATE]
		  ,S.[CREATED_BY]
		  ,S.[LAST_UPDATE_DATE]
		  ,S.[LAST_UPDATED_BY]
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
		  ,S.DIVISION_ID		AS SCM_DIVISION_ID
	  FROM [dbo].[SSP_DNM_SHIP_RESULT_OWMS] AS S WITH(NOLOCK)
	       JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
		ON S.DIVISION_ID	= D.DIVISION_ID

