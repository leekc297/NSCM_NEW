








/* =============================================================================
프로그램ID	: [UP_FX_GetAuthenticationMenuList]
업  무  명	: 사용자별 메뉴 리스트 
프로그램명	: 메뉴컨테이너
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
CREATE PROCEDURE [dbo].[UP_FX_GetAuthenticationMenuList]
(
	@UserID			NVARCHAR(20),
	@Culture		NCHAR(2) = 'ko'
)
AS
BEGIN

	DECLARE @CultureCode NVARCHAR(7);
	SET @CultureCode = (SELECT ISNULL(BaseCode,'0102001') FROM TB_FX_BaseCode
						WHERE PrntCode ='0102000' AND CodeName = @Culture)

	SET NOCOUNT ON;
	/*
		지정한 사용자에게 권한이 있는 메뉴정보를 저장하는 임시 테이블 변수
	*/
	DECLARE @AuthMenus TABLE
	(
		[MenuID] [nvarchar](20) NOT NULL,
		[ProgramID] [nvarchar](20) NULL,
		[PrntMenuID] [nvarchar](20) NULL,
		[Title] [nvarchar](250) NOT NULL,
		[Description] [nvarchar](250) NULL,
		[Parameter] [nvarchar](250) NULL,
		[SortOrder] [int] NOT NULL,
		[MenuLevel] [int] NOT NULL,
		--[RibbonYN] [nchar](1) NULL,
		[MenuAction] [int] NOT NULL,
		[CollapsedIconClass] [nvarchar](50) NULL,
		[ExpandedIconClass] [nvarchar](50) NULL,
		[Icon] [varbinary](max) NULL,
		[Expanded] [bit] NOT NULL,
		[MenuVisible] [bit] NOT NULL
	)
	/*
		지정한 사용자에게 권한이 있는 메뉴정보 리스트를 가져오며 정렬은 되지 않은 상태입니다.
	*/
	;WITH MenuCTE 
	(	
		MenuID
		,ProgramID
		,PrntMenuID
		,Title
		,Description
		,Parameter
		,SortOrder
		,MenuLevel
		--,RibbonYN
		,MenuAction
		,CollapsedIconClass
		,ExpandedIconClass
		,Icon
		,Expanded
		,MenuVisible
	) AS
	(  
		SELECT	
				 M.MenuID
				,M.ProgramID
				,M.PrntMenuID
				,M.Title
				,M.Description
				,M.Parameter
				,M.SortOrder
				,M.MenuLevel
				--,M.RibbonYN
				,M.MenuAction
				,M.CollapsedIconClass
				,M.ExpandedIconClass
				,M.Icon
				,M.Expanded
				,M.MenuVisible
		FROM dbo.TB_FX_MenuItemInfo	AS	M	WITH (NOLOCK)
		WHERE M.MenuID IN
		(
			/*
				권한정보와 맵핑되어진 오픈할 수 있는 메뉴리스트입니다.
				지정한 사용자가 여러그룹에 속해 있을 수 있으므로 메뉴ID를 중복제거합니다.
			*/
			SELECT	UM.MenuID		
			FROM dbo.TB_FX_User	AS	U	WITH (NOLOCK)	
			INNER JOIN	dbo.TB_FX_UserGroupInfo	AS UI	WITH (NOLOCK)			
				ON UI.UserID	=	U.UserID
				AND UI.UseYN =	'Y'
			INNER JOIN	dbo.TB_FX_GroupMenuAuth	AS	UM	WITH (NOLOCK)
				ON	UI.GroupID	=	UM.GroupID	
				AND UM.UseYN	=	'Y'
			WHERE UI.UserID		=	@UserID
				AND UM.UseYN	=	'Y'
			UNION 
			SELECT	UM.MenuID
			FROM dbo.TB_FX_User	AS	U	WITH (NOLOCK)	
			INNER JOIN	dbo.TB_FX_UserGroupInfo	AS UI	WITH (NOLOCK)		
				ON UI.UserID	=	U.UserID
				AND UI.UseYN	=	'Y'
			INNER JOIN	dbo.TB_FX_UserMenuAuth	AS	UM	WITH (NOLOCK)
				ON	UI.UserID	=	UM.UserID	
				AND UM.UseYN	=	'Y'
			WHERE  UM.UserID	=	@UserID
				AND UM.UseYN	=	'Y'
		)
		AND M.UseYN		=	'Y'
		UNION ALL
	    SELECT  M1.MenuID
			,M1.ProgramID
			,M1.PrntMenuID
			,M1.Title
			,M1.Description
			,M1.Parameter
			,M1.SortOrder
			,M1.MenuLevel
			--,M1.RibbonYN
			,M1.MenuAction
			,M1.CollapsedIconClass
			,M1.ExpandedIconClass
			,M1.Icon	
			,M1.Expanded
			,M1.MenuVisible
		FROM MenuCTE
		INNER JOIN  dbo.TB_FX_MenuItemInfo	AS	M1	WITH (NOLOCK)
			ON MenuCTE.PrntMenuID = M1.MenuID	
		WHERE M1.UseYN = 'Y'
	)
	
	INSERT INTO @AuthMenus
	SELECT DISTINCT	C.MenuID
			,C.ProgramID
			,C.PrntMenuID
			,ISNULL(D.DisplayTitle, C.Title) Title
			,C.Description
			,C.Parameter
			,C.SortOrder
			,C.MenuLevel
			--,C.RibbonYN
			,C.MenuAction
			,C.CollapsedIconClass
			,C.ExpandedIconClass
			,C.Icon
			,C.Expanded
			,C.MenuVisible
	FROM	MenuCTE C
	LEFT JOIN dbo.TB_FX_MenuTitleInfo  D
		ON C.MenuID		=	D.MenuID
		AND D.CultureCode	=	@CultureCode
	
	/*
		메뉴정보 테이블의 SortOrder를 기준으로 정렬을 하기 위한 재귀쿼리를 실행합니다.
		같은 단계에서 같은 SortOrder를 가지는 경우 알파벳순으로 정렬됩니다.
	*/
	;WITH MenuCTE1 
	(	
		 MenuID
		,ProgramID
		,PrntMenuID
		,NavigatePath
		,Title
		,Description
		,Parameter	
		,SortOrder
		,MenuLevel
		--,RibbonYN
		,MenuAction
		,CollapsedIconClass
		,ExpandedIconClass
		,Icon
		,Expanded
		,MenuVisible
		,Sort
	) AS
	(  
		SELECT 
			 M1.MenuID
			,M1.ProgramID
			,M1.PrntMenuID
			,CONVERT(NVARCHAR(1000), M1.Title) NavigatePath 
			,M1.Title
			,M1.Description
			,M1.Parameter
			,M1.SortOrder
			,M1.MenuLevel
			--,M1.RibbonYN
			,M1.MenuAction
			,M1.CollapsedIconClass
			,M1.ExpandedIconClass
			,M1.Icon
			,M1.Expanded
			,M1.MenuVisible
			,CAST( M1.SortOrder AS NVARCHAR(100)) + CAST( SUBSTRING( M1.MenuID, 1, 12) AS NVARCHAR(MAX))		
		FROM  @AuthMenus AS M1	
		WHERE M1.PrntMenuID = ''
		UNION ALL
		SELECT	
			 M.MenuID
			,M.ProgramID
			,M.PrntMenuID
			,CONVERT(NVARCHAR(1000), MenuCTE1.NavigatePath + ' > ' + M.Title) NavigatePath
			,M.Title
			,M.Description
			,M.Parameter
			,M.SortOrder
			,M.MenuLevel
			--,M.RibbonYN
			,M.MenuAction
			,M.CollapsedIconClass
			,M.ExpandedIconClass
			,M.Icon
			,M.Expanded
			,M.MenuVisible
			,MenuCTE1.SORT + CAST( M.SortOrder AS NVARCHAR(100)) + CAST( SUBSTRING( M.MenuID, 1, 12) AS NVARCHAR(MAX))		
		FROM MenuCTE1
		INNER JOIN  @AuthMenus	AS M
			ON MenuCTE1.MenuID = M.PrntMenuID
	)

	SELECT 
		 C.MenuID
		,C.ProgramID
		,C.PrntMenuID
		,C.NavigatePath
		,C.Title
		,C.Description
		,C.Parameter	
		,P.ProgramPath
		,P.ClassName
		,C.SortOrder
		,C.MenuLevel
		--,C.RibbonYN
		,C.MenuAction
		,C.CollapsedIconClass
		,C.ExpandedIconClass
		,C.Icon
		,C.Expanded
		,C.MenuVisible
	FROM 
	MenuCTE1 AS C
	LEFT JOIN dbo.TB_FX_ProgramInfo AS P
		ON C.ProgramID	=	P.ProgramID
		WHERE P.UseYN = 'Y'
	ORDER BY MenuID, SORT 
END









