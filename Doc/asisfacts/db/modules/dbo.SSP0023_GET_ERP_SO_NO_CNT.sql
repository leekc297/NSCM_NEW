

/*
 * Program ID   : SSP0023_GET_ERP_SO_NO_CNT
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/05/20   kh79           [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
 * 2024/06/04   jilee          UI 수량 표기 안되는 정보에 대한 제외 처리
 */

CREATE PROCEDURE [dbo].[SSP0023_GET_ERP_SO_NO_CNT]
	 @p_division_id			NVARCHAR(MAX)
	,@p_erp_so_no			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT COUNT(*) CNT
	FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
	WHERE DIVISION_ID = @p_division_id
	  AND ERP_SO_NO = @p_erp_so_no
	  AND QTY <> 0 
END

