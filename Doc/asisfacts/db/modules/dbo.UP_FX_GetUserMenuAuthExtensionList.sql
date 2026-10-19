



/* =============================================================================
프로그램ID	: UP_FX_GetUserMenuAuthExtensionList
업  무  명	: 그룹별 메뉴 관리 - 그룹 추가 권한 리스트 
프로그램명	: 그룹 추가 권한 리스트
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_GetUserMenuAuthExtensionList]
	@MenuID			NVARCHAR(20)
  , @UserID			NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		 E.AuthID
		,E.Description
		,G.UseYN
	FROM dbo.TB_FX_UserMenuAuthExtension G WITH(NOLOCK)
	INNER JOIN dbo.TB_FX_ExtensionAuthInfo E	WITH(NOLOCK)
		ON	E.AuthID	=	G.AuthID
	WHERE G.MenuID	=	@MenuID
		AND	G.UserID	=	@UserID

END









