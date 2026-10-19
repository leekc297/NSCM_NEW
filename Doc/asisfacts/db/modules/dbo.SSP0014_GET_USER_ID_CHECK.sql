
/*
 * Program ID   : SSP0014_SHIPMENT_MODEL_PIC
 * Description  : Shipment Model PIC UserID Check
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/22   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2024/05/08   jilee          DefaultGroupID 권한 추가
 * 2024/06/19   jilee          Group권한 포함만 되어도 조회될수 있게 수정
 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0014_GET_USER_ID_CHECK]
	 @p_user_id			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT DISTINCT A.UserID USER_ID
	FROM TB_FX_User A WITH(NOLOCK)
	JOIN TB_FX_UserGroupAuthExtention B WITH(NOLOCK) ON
	A.UserID = B.UserID
	WHERE A.UserID IN  ( SELECT token FROM dbo.String_Split(@p_user_id,'^') )
	--AND DefaultGroupID IN ('SSP Planner', 'ADMIN', 'SCM PI Admin')
	AND B.GroupID IN ('SSP Planner', 'ADMIN', 'SCM PI Admin')
END
