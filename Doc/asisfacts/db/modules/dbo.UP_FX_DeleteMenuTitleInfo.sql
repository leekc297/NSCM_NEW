





/* =============================================================================
프로그램ID	: [UP_FX_DeleteMenuTitleInfo]
업  무  명	: 메뉴 관리
프로그램명	: 다국어 메뉴제목 삭제
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteMenuTitleInfo]
(
	  @MenuID				NVARCHAR(20)
	, @CultureCode			NCHAR(7) 
)
AS
BEGIN
	DELETE FROM dbo.TB_FX_MenuTitleInfo
	WHERE MenuID		=	@MenuID
	AND CultureCode	=	@CultureCode

END







