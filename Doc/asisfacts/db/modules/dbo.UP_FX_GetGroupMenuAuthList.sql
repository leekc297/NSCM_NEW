/*
 * Program ID   : UP_FX_GetGroupMenuAuthList
 * Description  : 그룹별 메뉴 관리 - 그룹권한 리스트 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/02/27   이정석			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/02   ygkim			메뉴 전체 리스트 가져오도록 쿼리 수정
 */

CREATE PROCEDURE [dbo].[UP_FX_GetGroupMenuAuthList]
	@GroupID		NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT @GroupID GroupID , Level1MenuID = (SELECT PrntMenuID From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID)	
		, Level1Title = (SELECT Title From TB_FX_MenuItemInfo WHERE MenuLevel = 1 AND MenuID = 
		(SELECT PrntMenuID From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID) GROUP BY Title)
		, M.PrntMenuID						
		, Level2Title = (SELECT Title From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY Title)	
		, M.MenuID
		, M.Title	
		, isnull(GM.BasicACLC,0) BasicACLC
		, isnull(GM.BasicACLR,0) BasicACLR
		, isnull(GM.BasicACLU,0) BasicACLU
		, isnull(GM.BasicACLD,0) BasicACLD
		, GM.ExtendedACL
		, 'Y' UseYN
		, GM.RegtUserID
		, Level1SortOrder =		
						(
						SELECT SortOrder From TB_FX_MenuItemInfo WHERE MenuLevel = 1 AND MenuID IN 
							(SELECT PrntMenuID From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID)
							GROUP BY MenuID, SortOrder
						)
		, Level2SortOrder = 
						(SELECT SortOrder From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID, SortOrder)
		, Level3SortOrder = M.SortOrder
	FROM dbo.TB_FX_MenuItemInfo AS M 
	LEFT OUTER JOIN dbo.TB_FX_ProgramInfo AS P ON M.ProgramID = P.ProgramID AND P.UseYN = 'Y'
	LEFT OUTER JOIN TB_FX_GroupMenuAuth GM ON M.MenuID = GM.MenuID AND GM.UseYN = 'Y' AND GM.GroupID = @GroupID
	WHERE MenuLevel = 3  
	ORDER BY Level1SortOrder, Level2SortOrder, Level3SortOrder;

	/*
	SELECT 
		 G.GroupID
		, Level1MenuID = (SELECT PrntMenuID From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID)
		, Level1Title = (SELECT Title From TB_FX_MenuItemInfo WHERE MenuLevel = 1 AND MenuID = 
						(SELECT PrntMenuID From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID) GROUP BY Title)
		, M.PrntMenuID
		, Level2Title = (SELECT Title From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY Title)
		, M.MenuID
		, M.Title
		, G.BasicACLC
		, G.BasicACLR
		, G.BasicACLU
		, G.BasicACLD
		, G.ExtendedACL
		, G.UseYN
		, G.RegtUserID
		, Level1SortOrder =		
						(
						SELECT SortOrder From TB_FX_MenuItemInfo WHERE MenuLevel = 1 AND MenuID IN 
							(SELECT PrntMenuID From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID)
							GROUP BY MenuID, SortOrder
						)
		, Level2SortOrder = 
						(SELECT SortOrder From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID, SortOrder)
		, Level3SortOrder = M.SortOrder
	FROM dbo.TB_FX_GroupMenuAuth G WITH(NOLOCK)
	INNER JOIN dbo.TB_FX_MenuItemInfo M	WITH(NOLOCK)
		ON	G.MenuID	=	M.MenuID
	WHERE G.GroupID	=	@GroupID
	ORDER BY Level1SortOrder, Level2SortOrder, Level3SortOrder
	*/
END










