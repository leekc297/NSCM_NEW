
/* =============================================================================
프로그램ID	: UP_FX_GetFavoriteList
업  무  명	: 즐겨찾기 관리
프로그램명	: 즐겨찾기 저장
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_GetFavoriteList]
	@GroupID		NVARCHAR(20)
	, @UserID			NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	-- 즐겨찾기 메뉴(아이템) 목록
	SELECT 
		F.MenuID, M.Title
	FROM 
		dbo.TB_FX_Favorite as F WITH(NOLOCK)	
		, dbo.TB_FX_MenuItemInfo M WITH(NOLOCK)
	WHERE F.MenuID = M.MenuID 
		AND F.GroupID = @GroupID 
		AND F.UserID = @UserID

END






