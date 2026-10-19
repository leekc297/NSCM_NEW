
/*
 * Program ID   : SSP0025_SHIPMENT_PLAN_MODEL_PIC
 * Description  : Shipment Plan Model PIC UserID Check
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/06/23   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성

 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0025_GET_USER_ID_CHECK]
	 @p_user_id			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT UserID USER_ID
	FROM TB_FX_User WITH(NOLOCK)
	WHERE UserID IN  ( SELECT token FROM dbo.String_Split(@p_user_id,'^') )
END
