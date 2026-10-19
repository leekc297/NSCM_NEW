





/* =============================================================================
프로그램ID	: [UP_FX_DeleteUserMenuAuth]
업  무  명	: 그룹별 메뉴권한 관리
프로그램명	: 그룹별 메뉴권한 삭제
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteUserMenuAuth]
(
	  @UserID				NVARCHAR(20)
	, @MenuID				NVARCHAR(20) 
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN
		DELETE FROM dbo.TB_FX_UserMenuAuthExtension
		WHERE UserID = @UserID
		AND	MenuID = @MenuID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_UserMenuAuth
		WHERE UserID = @UserID
		AND	MenuID = @MenuID
	END

END







