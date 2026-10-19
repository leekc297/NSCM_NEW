
/* =============================================================================
프로그램ID	: UP_FX_GetSearchCondition
업  무  명	: 화면별 검색조건 조회
프로그램명	: 
최초작성일	: 2017.12.04
최종작성일	: 2017.12.04
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CReATE PROCEDURE [dbo].[UP_FX_GetSearchCondition]
	@GroupID		NVARCHAR(20)
	, @UserID		NVARCHAR(20)
	, @MenuID		NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	-- 즐겨찾기 메뉴(아이템) 목록
	SELECT 
		ControlName, ControlValue
	FROM 
		dbo.TB_FX_SearchCondition WITH(NOLOCK)	
	WHERE GroupID = @GroupID AND UserID = @UserID AND MenuID = @MenuID;

END
