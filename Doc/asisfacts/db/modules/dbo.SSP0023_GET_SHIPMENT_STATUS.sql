

/*
 * Program ID   : SSP0023_GET_SHIPMENT_STATUS
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/05/20   kh79           [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
  ex) EXEC SSP0023_GET_SHIPMENT_STATUS @p_division_id='40^40^40^40', @p_confirm_id='C20181001068349^C20181005074232^C20181001068367^C20181008076327'
 */

CREATE PROCEDURE [dbo].[SSP0023_GET_SHIPMENT_STATUS]
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

