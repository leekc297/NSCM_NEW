 
/* =============================================================================
프로그램ID	: [UP_FX_GetAuthenticationMenuList]
업  무  명	: 사용자별 메뉴 리스트 
프로그램명	: 메뉴컨테이너
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
* 2018.04.26 ygkim	Read, Modify 둘다 권한이 없는 Menu 제외 조건 추가
* 2018.12.12 hwyoon	ProgramId 조회 추가
* 2025.01.13 JSSBAE	[E20241219-001227]_고객수요분석 MKT FCST(Auto) UI 권한 제어 건
* 2025.02.26	P.C.I			[PJ2025-50017] 소형사업부 매출계획 동기화 개선.사업부/부서별 메뉴 권한 관리

EXEC UP_FX_GetGSCMAuthenticationMenuList 'yokejacob', 'ADMIN'

============================================================================= */
CREATE PROCEDURE [dbo].[UP_FX_GetGSCMAuthenticationMenuList]
(
	@UserID			NVARCHAR(20),
	@GroupID		NVARCHAR(20),
	@ProgramId		NVARCHAR(20)=NULL
)
AS
BEGIN

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
			SELECT	UM.MenuID		
			FROM dbo.TB_FX_User	AS	U	WITH (NOLOCK)	
			INNER JOIN	dbo.TB_FX_UserGroupInfo	AS UI	WITH (NOLOCK)			
				ON UI.UserID	=	U.UserID
				AND UI.GroupID = @GroupID
				AND UI.UseYN =	'Y'
			INNER JOIN	dbo.TB_FX_GroupMenuAuth	AS	UM	WITH (NOLOCK)
				ON	UI.GroupID	=	UM.GroupID	
				AND UM.UseYN	=	'Y'
				AND (UM.BasicACLR != 0 OR UM.BasicACLU != 0) -- Read, Modify 둘 다 체크가 안될 경우에는 제외
			WHERE UI.UserID		=	@UserID
				AND UM.UseYN	=	'Y'
			--UNION 
			--SELECT	UM.MenuID
			--FROM dbo.TB_FX_User	AS	U	WITH (NOLOCK)	
			--INNER JOIN	dbo.TB_FX_UserGroupInfo	AS UI	WITH (NOLOCK)		
			--	ON UI.UserID	=	U.UserID
			--	AND UI.UseYN	=	'Y'
			--INNER JOIN	dbo.TB_FX_UserMenuAuth	AS	UM	WITH (NOLOCK)
			--	ON	UI.UserID	=	UM.UserID	
			--	AND UM.UseYN	=	'Y'
			--WHERE  UM.UserID	=	@UserID
			--	AND UM.UseYN	=	'Y'
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
			--,ISNULL(D.DisplayTitle, C.Title) Title
			,C.Title
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
	WHERE   1=1
	-- [PJ2025-50017] 소형사업부 매출계획 동기화 개선. 룩업 'MENU_AUTH_BY_DEPT, MENU_AUTH_BY_DIVISION' 에 등록된 메뉴 제외
	AND     C.ProgramID  NOT IN (SELECT DISTINCT SEGMENT1 
								 FROM  SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
								 WHERE LOOKUP_TYPE IN ( 'MENU_AUTH_BY_DEPT', 'MENU_AUTH_BY_DIVISION')
								 AND   VALID_YN = 'Y')
	UNION ALL
	
	-- [PJ2025-50017] 소형사업부 매출계획 동기화 개선. 룩업 'MENU_AUTH_BY_DEPT'에 등록된 부서만 해당 메뉴 조회, 룩업 'MENU_AUTH_BY_DIVISION'에 등록된 사업부만 해당 메뉴 조회 Start
	SELECT DISTINCT	C.MenuID
			,C.ProgramID
			,C.PrntMenuID
			--,ISNULL(D.DisplayTitle, C.Title) Title
			,C.Title
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
	WHERE   1=1
	AND   ( C.ProgramID IN (SELECT DISTINCT SEGMENT1 
							FROM  SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							WHERE LOOKUP_TYPE = 'MENU_AUTH_BY_DEPT'
							AND   VALID_YN = 'Y'
							AND   C.ProgramID = SEGMENT1
							AND   (SEGMENT2 IN ( SELECT DISTINCT DEPT_ID
												FROM TB_FX_USER A
												WHERE UserID =  @UserID )
							    OR SEGMENT4 = @GroupID)
							)
		 OR C.ProgramID IN (SELECT DISTINCT SEGMENT1 
							FROM  SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							WHERE LOOKUP_TYPE = 'MENU_AUTH_BY_DIVISION'
							AND   VALID_YN = 'Y'
							AND   C.ProgramID = SEGMENT1
							AND   (SEGMENT2 IN ( SELECT DISTINCT Code
												FROM TB_FX_UserGroupAuthExtention A
												WHERE UserID =  @UserID
												AND   GroupID = @GroupID )
							    OR SEGMENT4 = @GroupID)
							)
			)
	-- [PJ2025-50017] 소형사업부 매출계획 동기화 개선. 룩업 'MENU_AUTH_BY_DEPT'에 등록된 부서만 해당 메뉴 조회, 룩업 'MENU_AUTH_BY_DIVISION'에 등록된 사업부만 해당 메뉴 조회 End
		
	--[E20241219-001227]_고객수요분석 MKT FCST(Auto) UI 권한 제어 건 START
	--현재는 하나의 부서만 요청했지만, 화면을 사용하고자 하는 부서가 늘어날 수 있으므로 룩업구성
	/*IF (((SELECT COUNT(*)
		FROM TB_FX_USER A
		WHERE DEPT_ID IN ( SELECT SEGMENT2 
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							WHERE LOOKUP_TYPE = 'DMF0081_AUTH_DEPTID'
							GROUP BY SEGMENT2)
		AND USERID = @UserID) < 1) AND @GroupID != (SELECT SEGMENT4 
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
													WHERE LOOKUP_TYPE = 'DMF0081_AUTH_DEPTID'
													GROUP BY SEGMENT4))
	BEGIN 		
		DELETE FROM @AuthMenus WHERE PROGRAMID = (SELECT SEGMENT1 
												  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
												  WHERE LOOKUP_TYPE = 'DMF0081_AUTH_DEPTID'
												  GROUP BY SEGMENT1)
	END*/
	--[E20241219-001227]_고객수요분석 MKT FCST(Auto) UI 권한 제어 건 END

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
		,@UserID AS  UserID
	FROM 
	MenuCTE1 AS C
	LEFT JOIN dbo.TB_FX_ProgramInfo AS P
		ON C.ProgramID	=	P.ProgramID
	WHERE ( (@ProgramId is null or @ProgramId = '')  OR (C.ProgramID = @ProgramId))
	ORDER BY MenuID, SORT 
END








