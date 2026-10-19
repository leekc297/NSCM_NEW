






/* =============================================================================
프로그램ID	: [UP_FX_DeleteUserInfo]
업  무  명	: 사용자 관리
프로그램명	: 사용자 삭제
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
비	고	    : 
============================================================================= */
	
CREATE procedure [dbo].[UP_FX_DeleteUserInfo]
(
	@UserID				NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN
		DELETE FROM dbo.TB_FX_User
		WHERE UserID = @UserID
	END

	--BEGIN
	--	DELETE FROM dbo.TB_FX_UserAuthInfo
	--	WHERE UserID = @UserID
	--END

	BEGIN
		DELETE FROM dbo.TB_FX_UserGroupInfo
		WHERE UserID = @UserID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_UserMenuAuth
		WHERE UserID = @UserID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_UserMenuAuthExtension
		WHERE UserID = @UserID
	END

	BEGIN
		DELETE FROM TB_FX_UserGroupAuthExtention
		WHERE UserID = @UserID
	END

END









