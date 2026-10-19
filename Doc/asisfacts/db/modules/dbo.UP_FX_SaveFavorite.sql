

/* =============================================================================
프로그램ID	: UP_FX_SaveFavorite
업  무  명	: 즐겨찾기 관리
프로그램명	: 즐겨찾기 저장
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
============================================================================= */
CREATE PROCEDURE [dbo].[UP_FX_SaveFavorite]
(
	@GroupID			NVARCHAR(20)
    , @UserID			NVARCHAR(20) 
	, @MenuID			NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	MERGE dbo.TB_FX_Favorite	WITH(HOLDLOCK) F
	USING (
		SELECT
			@GroupID	AS	GroupID
		,	@UserID		AS	UserID
		,	@MenuID		AS	MenuID
	) T ON	F.GroupID	= T.GroupID
		AND	F.UserID	= T.UserID	
		AND	F.MenuID	= T.MenuID
	WHEN NOT MATCHED THEN
		INSERT
		(
			GroupID
			, UserID
			, MenuID
		) VALUES
			 (
			  @GroupID
			  , @UserID
			  , @MenuID
			 );
END











