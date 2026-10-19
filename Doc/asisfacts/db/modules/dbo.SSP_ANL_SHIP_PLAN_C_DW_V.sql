

CREATE VIEW [dbo].[SSP_ANL_SHIP_PLAN_C_DW_V]
AS
/*
 * Program ID   : SSP_ANL_SHIP_PLAN_C_DW_V
 * Description  : SSP_ANL_SHIP_PLAN_C 조회
                  소속 DIVISION_ID로 정보를 조회 하기 위해서
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.01   SSP Pjt.       Created
 */

	SELECT D.ATTRIBUTE3 AS DIVISION_ID
		  ,S.[COMPANY_ID]
		  ,S.[PLAN_START_YYYYMMDD]
		  ,S.[ITEM_ID]
		  ,S.[FROM_SITE]
		  ,S.[TO_SITE]
		  ,S.[MEASURE]
		  ,S.[YYYYMMDD]
		  ,S.[BOD_ID]
		  ,S.[QTY]
		  ,S.[ROUTE_ID]
		  ,S.[INCOTERMS]
		  ,S.[TRANSPORT_MODE]
		  ,S.[BIZ_TYPE]
		  ,S.[PROJECT_CODE]
		  ,S.[FCST_TYPE]
		  ,S.[FCST_ETD_DATE]
		  ,S.[FCST_ETA_DATE]
		  ,S.[ETD_DATE]
		  ,S.[ETA_DATE]
		  ,S.[CONFIRM_FLAG]
		  ,S.[CONFIRM_ID]
		  ,S.[REQUESTOR]
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
		  ,S.[ELECTRODE_YN]
		  ,S.[ELECTRODE_TYPE]
		  ,FD.ATTRIBUTE3				AS ORIGIN_FROM_DIVISION_ID
		  ,TD.ATTRIBUTE3				AS ORIGIN_TO_DIVISION_ID
		  ,S.DIVISION_ID				AS SCM_DIVISION_ID
		  ,S.ORIGIN_FROM_DIVISION_ID	AS ORIGIN_FROM_SCM_DIVISION_ID
		  ,S.ORIGIN_TO_DIVISION_ID		AS ORIGIN_TO_SCM_DIVISION_ID
	  FROM [dbo].[SSP_ANL_SHIP_PLAN_C] AS S WITH(NOLOCK)
	       JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
		ON S.DIVISION_ID = D.DIVISION_ID
	       JOIN SCM_MST_DIVISION AS FD WITH(NOLOCK)
		ON S.ORIGIN_FROM_DIVISION_ID = FD.DIVISION_ID	       
		   JOIN SCM_MST_DIVISION AS TD WITH(NOLOCK)
		ON S.ORIGIN_TO_DIVISION_ID = TD.DIVISION_ID
