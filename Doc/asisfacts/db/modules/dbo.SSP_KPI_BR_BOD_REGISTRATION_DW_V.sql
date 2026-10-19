




CREATE VIEW [dbo].[SSP_KPI_BR_BOD_REGISTRATION_DW_V]
AS
/*
 * Program ID   : SSP_KPI_BR_BOD_REGISTRATION_DW_V
 * Description  : SSP_KPI_BR_BOD_REGISTRATION 조회
                  소속 DIVISION_ID로 정보를 조회 하기 위해서
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.01   SSP Pjt.       Created
 */

	SELECT S.[YYYYMMDD]
		  ,S.[YYYYMM]
		  ,S.[WEEK_NAME]
		  ,D.[ATTRIBUTE3]			AS DIVISION_ID
		  ,S.[FROM_SITE]
		  ,S.[FROM_CITY]
		  ,S.[TO_SITE]
		  ,S.[TO_CITY]
		  ,S.[VMI_YN]
		  ,S.[INCOTERMS]
		  ,S.[TRANSPORT_MODE]
		  ,S.[ROUTE_CNT]
		  ,S.[CUSTOMER]
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
		  ,S.DIVISION_ID			AS SCM_DIVISION_ID
	  FROM [dbo].[SSP_KPI_BR_BOD_REGISTRATION] AS S WITH(NOLOCK)
	       JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
		ON S.DIVISION_ID = D.DIVISION_ID

