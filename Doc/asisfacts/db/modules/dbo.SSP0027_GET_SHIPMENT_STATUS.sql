

/*
 * Program ID   : SSP0027_GET_SHIPMENT_STATUS
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-03-23   KIMYONGHO      신규추가
 

 */

CREATE PROCEDURE [dbo].[SSP0027_GET_SHIPMENT_STATUS]
	 @p_division_id			NVARCHAR(MAX)
	,@p_confirm_id			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT CONFIRM_ID
	FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
	WHERE 1=1
	  and DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@p_division_id,'^') )
	  and CONFIRM_ID IN  ( SELECT token FROM dbo.String_Split(@p_confirm_id,'^') )
	  AND SHIPMENT_STATUS != 'C'

	SELECT CONFIRM_ID
	FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
	WHERE 1=1
	  and DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@p_division_id,'^') )
	  and CONFIRM_ID IN  ( SELECT token FROM dbo.String_Split(@p_confirm_id,'^') )
	  AND QTY = 0

	SELECT CONFIRM_ID
	FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
	WHERE 1=1
	  and DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@p_division_id,'^') )
	  and CONFIRM_ID IN  ( SELECT token FROM dbo.String_Split(@p_confirm_id,'^') )
	  AND ERP_STATUS = 'C'
END

