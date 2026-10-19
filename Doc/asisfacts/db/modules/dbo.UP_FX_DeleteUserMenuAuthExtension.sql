







/* =============================================================================
프로그램ID	: [UP_FX_DeleteUserMenuAuthExtension]
업  무  명	: 사용자별 확장메뉴권한 관리
프로그램명	: 사용자별 확장메뉴권한 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteUserMenuAuthExtension]
(
	  @MenuID				NVARCHAR(20) 
	, @UserID				NVARCHAR(20)
	, @AuthIds				NVARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM dbo.TB_FX_UserMenuAuthExtension
		WHERE MenuID		=	@MenuID
		AND UserID		=	@UserID
		AND AuthID	IN (SELECT Element	FROM UF_FX_Split(@AuthIds,','))
END









