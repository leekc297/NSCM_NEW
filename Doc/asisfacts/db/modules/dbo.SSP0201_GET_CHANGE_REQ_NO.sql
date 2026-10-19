

/*
 * Program ID   : SSP0200_GET_CHANGE_REQ_NO
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/25	KIMYONGHO      최초작성
 */

CREATE PROCEDURE [dbo].[SSP0201_GET_CHANGE_REQ_NO]
	 @p_user_id			NVARCHAR(MAX)
	--,@p_erp_so_no			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 'S', 'R'+CONVERT(VARCHAR(8), SYSDATETIME(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CHG_REQ_NO),6)
END

