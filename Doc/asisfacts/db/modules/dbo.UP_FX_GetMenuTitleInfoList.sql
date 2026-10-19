



/* =============================================================================
프로그램ID	: UP_FX_GetMenuTitleInfoList
업  무  명	: 시스템관리 - 메뉴관리 목록
프로그램명	: 메뉴 제목 다국어 정보 조회
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */

CREATE PROCEDURE [dbo].[UP_FX_GetMenuTitleInfoList]
	
	@MenuID		    NVARCHAR(20)
AS
BEGIN
		SET NOCOUNT ON;
		SELECT	M.MenuID
			,	M.CultureCode		
			,	M.DisplayTitle
		FROM dbo.TB_FX_MenuTitleInfo		AS M WITH(NOLOCK)
		WHERE  M.MenuID	=	@MenuID

END







