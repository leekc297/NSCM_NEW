






/* =============================================================================
프로그램ID	: [UP_FX_DeleteMenuItemInfo]
업  무  명	: 메뉴 관리
프로그램명	: 메뉴 삭제
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
비	고	    : 해당 메뉴ID와 관련된 테이블의 데이타를 모두 삭제 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteMenuItemInfo]
(
	  @MenuID				NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN
		DELETE FROM dbo.TB_FX_MenuTitleInfo
		WHERE MenuID = @MenuID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_MenuItemInfo
		WHERE MenuID = @MenuID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_UserMenuAuth
		WHERE MenuID = @MenuID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_UserMenuAuthExtension
		WHERE MenuID = @MenuID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_GroupMenuAuth
		WHERE MenuID = @MenuID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_GroupMenuAuthExtension
		WHERE MenuID = @MenuID
	END

END








