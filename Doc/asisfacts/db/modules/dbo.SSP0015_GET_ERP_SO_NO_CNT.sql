

/*
 * Program ID   : SSP0015_GET_ERP_SO_NO_CNT
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/12   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2024/06/04   jilee          UI 수량 표기 안되는 정보에 대한 제외 처리
 */

CREATE PROCEDURE [dbo].[SSP0015_GET_ERP_SO_NO_CNT]
	 @p_division_id			NVARCHAR(MAX)
	,@p_erp_so_no			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT COUNT(*) CNT
	FROM SSP_ANL_SHIP_CONFIRM  WITH(NOLOCK) 
	WHERE DIVISION_ID = @p_division_id
	  AND ERP_SO_NO = @p_erp_so_no
	  AND QTY <> 0
END

