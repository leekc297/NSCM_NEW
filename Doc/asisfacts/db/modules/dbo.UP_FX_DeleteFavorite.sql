
/* =============================================================================
프로그램ID	: UP_FX_DeleteTermInfo
업  무  명	: 시스템관리 - Word 관리
프로그램명	: Word 삭제
최초작성일	: 2017.11.30
최종작성일	: 2017.11.30
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteFavorite]
(
	@GroupID			NVARCHAR(20)
    , @UserID			NVARCHAR(20)
	, @MenuID			NVARCHAR(20)	 
)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM dbo.TB_FX_Favorite
	WHERE GroupID = @GroupID AND UserID	= @UserID AND MenuID = @MenuID
END



