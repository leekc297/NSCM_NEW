/****************************************************************************************************/
/* Program ID  : [DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA]                                      */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/03/23  P.C.I        Initial Release [prepare] Sales Report Exchange Rate Popup              */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA]
    @p_division_id					NVARCHAR(30),	
	@p_year						    NVARCHAR(4),
	@p_created_by					NVARCHAR(MAX),
	@p_version_no                   NVARCHAR(MAX)
AS  
BEGIN
	SET NOCOUNT ON;

	SELECT 
		DIVISION_ID  
		,[CURRENCY]
		,[UNIT_CURRENCY]
		,'D' + [YYYYMMDD] AS [YYYYMMDD]
		,[EXCHANGE_PRICE]      
	FROM [dbo].[DM_PLN_SALES_REPORT_EXCHANGE_C] WITH(NOLOCK)
	WHERE  YYYYMMDD like @p_year + '%'
	AND VERSION_NO = @p_version_no
	AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   			ELSE DIVISION_ID			
			END IN (
					SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_division_id,',') AS P WHERE 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.DATA
					)
	END

