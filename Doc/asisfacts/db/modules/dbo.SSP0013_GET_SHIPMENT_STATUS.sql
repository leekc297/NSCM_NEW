
/*
 * Program ID   : SSP0013_GET_SHIPMENT_STATUS
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/12   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트

 ex) EXEC SSP0013_GET_SHIPMENT_STATUS @p_division_id='40^40^40^40', @p_confirm_id='C20181001068349^C20181005074232^C20181001068367^C20181008076327'
 */

CREATE PROCEDURE [dbo].[SSP0013_GET_SHIPMENT_STATUS]
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
END
