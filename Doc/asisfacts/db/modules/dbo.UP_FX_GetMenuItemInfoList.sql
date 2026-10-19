

/* =============================================================================
프로그램ID	: UP_FX_GetMenuItemInfoList
업  무  명	: 시스템관리 - 메뉴관리 목록
프로그램명	: 메뉴 정보 조회
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= 
  Date			In Charge		Description
=============================================================================
  2024/12/12	jahn1502		컬럼 추가로 인한 조회 로직 수정

============================================================================= */

CREATE PROCEDURE [dbo].[UP_FX_GetMenuItemInfoList]
	@MenuLevel		SMALLINT,	
	@PrntMenuID		NVARCHAR(20),
	@MenuID		    NVARCHAR(20),
	@ProgramID		NVARCHAR(20),
	@Title			NVARCHAR(250)
AS
BEGIN
		SET NOCOUNT ON;

		IF @MenuLevel = 1

			BEGIN

			SELECT	M.MenuID
				,	M.ProgramID			
				,	P.ProgramName
				,	M.PrntMenuID
				,	M.Title		
				,	M.Description
				,	M.Parameter
				,	M.SortOrder
				,	M.MenuLevel
				,	M.IconName
				,   M.Icon
				,	M.UseYN
				,	M.RegtUserID
				,   M.UpdateUserID
				,   M.UpdateDateTime

			FROM dbo.TB_FX_MenuItemInfo AS M 
			LEFT OUTER JOIN dbo.TB_FX_ProgramInfo AS P 
			ON M.ProgramID = P.ProgramID
			WHERE (MenuLevel = @MenuLevel AND PrntMenuID = '')
			--AND
			--(
			--	(@MenuID IS NULL OR M.MenuID LIKE '%' + @MenuID + '%')
			--	OR (@ProgramID IS NULL OR M.ProgramID LIKE '%' + @ProgramID+ '%')
			--	OR (@Title IS NULL OR M.Title LIKE '%' + @Title+ '%')
			--)
			ORDER BY SortOrder
			
			END

		ELSE
			
			IF @MenuLevel <> 100

				BEGIN

				SELECT	
					'' as Level1MenuID 
					, M.MenuID
					,	M.ProgramID		
					,	P.ProgramName	
					,	M.PrntMenuID
					,	M.Title		
					,	M.Description
					,	M.Parameter
					,	M.SortOrder
					,	M.MenuLevel
					,	M.IconName
					,   M.Icon
					,	M.UseYN
					,	M.RegtUserID

					,   M.Attribute1
					,   M.Attribute2
					,   M.Attribute3
					,   M.Attribute4
					,   M.Attribute5
					,   M.Attribute6
					,   M.Attribute7
					,   M.Attribute8
					,   M.UpdateUserID
					,   M.UpdateDateTime

				FROM dbo.TB_FX_MenuItemInfo AS M 
				LEFT OUTER JOIN dbo.TB_FX_ProgramInfo AS P 
				ON M.ProgramID = P.ProgramID
				WHERE (MenuLevel = @MenuLevel AND PrntMenuID = @PrntMenuID)
				--AND
				--(
				--	(@MenuID IS NULL OR M.MenuID LIKE '%' + @MenuID + '%')
				--	OR (@ProgramID IS NULL OR M.ProgramID LIKE '%' + @ProgramID+ '%')
				--	OR (@Title IS NULL OR M.Title LIKE '%' + @Title+ '%')
				--)
				ORDER BY SortOrder

				END

			ELSE
				BEGIN
					-- Level 이 100 인 경우 : Level3 인 메뉴만 가져온다.
					-- 시스템관리 > 그룹별 메뉴권한 관리의 메뉴등록 팝업의 조회용
					SELECT
						Level1MenuID = (SELECT PrntMenuID From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID)	
						, Level1Title = (SELECT Title From TB_FX_MenuItemInfo WHERE MenuLevel = 1 AND MenuID = 
						(SELECT PrntMenuID From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID) GROUP BY Title)
						, M.PrntMenuID						
						, Level2Title = (SELECT Title From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY Title)
						, M.MenuID
						, M.ProgramID		
						, P.ProgramName	
						, M.Title		
						, M.MenuLevel
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
					LEFT OUTER JOIN dbo.TB_FX_ProgramInfo AS P 
					ON M.ProgramID = P.ProgramID
					WHERE MenuLevel = 3
					AND
					(
						(@MenuID IS NULL OR M.MenuID LIKE '%' + @MenuID + '%')
						OR (@Title IS NULL OR M.Title LIKE '%' + @Title+ '%')
					)
					ORDER BY Level1SortOrder, Level2SortOrder, Level3SortOrder
				END
END









