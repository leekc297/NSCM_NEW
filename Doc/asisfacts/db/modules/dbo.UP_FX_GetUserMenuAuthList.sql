



/* =============================================================================
프로그램ID	: UP_FX_GetUserMenuAuthList
업  무  명	: 그룹별 메뉴 관리 - 그룹권한 리스트 
프로그램명	: 그룹권한 리스트 
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_GetUserMenuAuthList]
	@User			NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		 U.UserID
        ,U.UserName
		,M.MenuID
		,M.Title
		,P.ProgramID
		,P.ProgramName
		,G.BasicACLC
		,G.BasicACLR
		,G.BasicACLU
		,G.BasicACLD
		,G.ExtendedACL
		,G.UseYN
	FROM dbo.TB_FX_UserMenuAuth G WITH(NOLOCK)
	INNER JOIN dbo.TB_FX_MenuItemInfo M	WITH(NOLOCK)
		ON	G.MenuID	=	M.MenuID
	LEFT JOIN dbo.TB_FX_ProgramInfo	P WITH(NOLOCK)
		ON P.ProgramID	=	M.ProgramID
	LEFT JOIN dbo.TB_FX_User	U WITH(NOLOCK)
		ON U.UserID	=	G.UserID
	WHERE ((@User IS NULL OR U.UserID LIKE '%' + @User + '%')	
		OR (@User IS NULL OR U.UserName LIKE '%' + @User + '%'))

END









