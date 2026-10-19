




/* =============================================================================
프로그램ID	: [UP_FX_DeleteExtensionAuthInfo]
업  무  명	: 확장권한 관리
프로그램명	: 확장권한 삭제
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteExtensionAuthInfo]
(
	  @AuthID				NVARCHAR(20)
)
AS
BEGIN
	
	BEGIN
		DELETE FROM dbo.TB_FX_UserMenuAuthExtension
		WHERE AuthID	= @AuthID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_GroupMenuAuthExtension
		WHERE AuthID	= @AuthID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_ExtensionAuthInfo
		WHERE AuthID = @AuthID
	END

END






