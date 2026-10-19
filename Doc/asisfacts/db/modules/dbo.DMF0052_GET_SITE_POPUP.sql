---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : DMF0052_GET_SITE_POPUP
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2022.11.21	HWI1993	C20221103-000432 EDI 상시 점검

 */
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DMF0052_GET_SITE_POPUP]
	@p_SENDER_CODE		NVARCHAR(4000),	--
	@p_ITEM_ID			NVARCHAR(4000),	--
	@p_PROJECT_CODE		NVARCHAR(50),
	@p_FROM_YYYYMMDD	NVARCHAR(8),	--
	@p_TO_YYYYMMDD		NVARCHAR(8),	--
	@p_POPUP_TYPE		NVARCHAR(30)	-- CHECK_SALES_SITE,  CHECK_SALES_ACTIVE
AS

BEGIN
	
    SET NOCOUNT ON;

	IF ( @p_POPUP_TYPE = 'CHECK_SALES_SITE')
	BEGIN
		SELECT DISTINCT A.SENDER_CODE, A.SENDER_NAME, A.COMPANY_ID, A.SOLDTO_CODE, A.SHIPTO_CODE, N'Check the ''Sales Site'' for using this EDI data. ' AS MESSAGE
		FROM DM_DNM_EDI_CALLOFF_ITEM A
		WHERE CREATE_DATE BETWEEN @p_FROM_YYYYMMDD AND @p_TO_YYYYMMDD
			AND A.SENDER_CODE = @p_SENDER_CODE
			AND A.ITEM_ID = @p_ITEM_ID
			AND ISNULL(A.ATTRIBUTE7,'') = CASE WHEN @p_PROJECT_CODE = 'Unknown' THEN ''
												ELSE @p_PROJECT_CODE 
												END
			AND ISNULL(A.ATTRIBUTE8, '') = ''
			AND A.ATTRIBUTE1 = 'ING'
			AND A.ATTRIBUTE9 = 'ING_SS_NULL'
	END
	ELSE
	BEGIN 
		SELECT DISTINCT A.SENDER_CODE, A.SENDER_NAME, A.COMPANY_ID, A.SOLDTO_CODE, A.SHIPTO_CODE
				, A.ATTRIBUTE8 AS SCM_SITE_ID, B.VALID_YN AS VALID_YN
				, CONCAT(B.SOLDTO_CODE, '/', B.SHIPTO_CODE) AS GSCM_CODE
				, B.VALID_YN AS CODE_VALID_YN
				, N'Change the status of ''Active'' for using this EDI data.' AS MESSAGE
		FROM DM_DNM_EDI_CALLOFF_ITEM A
		JOIN SCM_MST_SITE_CUSTOMER B ON A.ATTRIBUTE8 = B.SCM_SITE_ID AND A.SHIPTO_CODE = B.SHIPTO_CODE AND A.SOLDTO_CODE = B.SOLDTO_CODE AND B.DIVISION_ID = '81'
		WHERE CREATE_DATE BETWEEN @p_FROM_YYYYMMDD AND @p_TO_YYYYMMDD
			AND A.SENDER_CODE = @p_SENDER_CODE
			AND A.ITEM_ID = @p_ITEM_ID
			AND ISNULL(A.ATTRIBUTE7,'') = CASE WHEN @p_PROJECT_CODE = 'Unknown' THEN ''
												ELSE @p_PROJECT_CODE 
												END
			AND ISNULL(A.ATTRIBUTE8, '') <> ''
			AND A.ATTRIBUTE1 = 'ING'
			AND A.ATTRIBUTE9 = 'ING_SS_ACTIVE'
	END
END
