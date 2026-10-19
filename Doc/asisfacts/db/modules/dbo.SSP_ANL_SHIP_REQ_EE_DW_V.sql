


CREATE VIEW [dbo].[SSP_ANL_SHIP_REQ_EE_DW_V]
AS
/*
 * Program ID   : SSP_ANL_SHIP_REQ_EE_DW_V
 * Description  : SSP_ANL_SHIP_REQ_EE 조회
                  소속 DIVISION_ID로 정보를 조회 하기 위해서
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.01   SSP Pjt.       Created
 */

	SELECT S.[FROM_COMPANY_ID]
		  ,FD.ATTRIBUTE3 AS FROM_DIVISION_ID
		  ,S.[FROM_PLANT_ID]
		  ,S.[FROM_SITE]
		  ,S.[TO_COMPANY_ID]
		  ,TD.ATTRIBUTE3 AS TO_DIVISION_ID
		  ,S.[TO_PLANT_ID]
		  ,S.[TO_SITE]
		  ,S.[MODEL_ID]
		  ,S.[ITEM_ID]
		  ,S.[BOD_ID]
		  ,S.[ETD_DATE]
		  ,S.[ETA_DATE]
		  ,S.[QTY]
		  ,S.[QTY_TO_PCM]
		  ,S.[QTY_TO_CELL]
		  ,S.[SCP_PLAN_START_YYYYMMDD]
		  ,S.[SCP_PLAN_TYPE]
		  ,S.[SCP_PLAN_SEQ]
		  ,S.[REQUEST_ID]
		  ,S.[CONFIRM_ID]
		  ,S.[CONFIRM_FLAG]
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
		  ,S.FROM_DIVISION_ID	AS FROM_SCM_DIVISION_ID
		  ,S.TO_DIVISION_ID		AS TO_SCM_DIVISION_ID
	  FROM [dbo].[SSP_ANL_SHIP_REQ_EE] AS S WITH(NOLOCK)
	       JOIN SCM_MST_DIVISION AS FD WITH(NOLOCK)
		ON S.FROM_DIVISION_ID	= FD.DIVISION_ID
	       JOIN SCM_MST_DIVISION AS TD WITH(NOLOCK)
		ON S.TO_DIVISION_ID		= TD.DIVISION_ID
