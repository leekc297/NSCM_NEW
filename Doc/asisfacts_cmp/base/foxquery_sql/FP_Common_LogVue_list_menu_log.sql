WITH TT AS (
	  SELECT Level1Title = (SELECT Title From TB_FX_MenuItemInfo WHERE MenuLevel = 1 AND MenuID = 
	  (SELECT PrntMenuID From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY PrntMenuID) GROUP BY Title)
	  , M.PrntMenuID      
	  , Level2Title = (SELECT Title From TB_FX_MenuItemInfo WHERE MenuLevel = 2 AND MenuID = M.PrntMenuID GROUP BY Title) 
	  , M.MenuID
	  , M.Title
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
	 --LEFT OUTER JOIN TB_FX_GroupMenuAuth GM ON M.MenuID = GM.MenuID AND GM.UseYN = 'Y' AND GM.GroupID = @GroupID
	 WHERE MenuLevel = 3
),
MM AS (
SELECT Level1Title, PrntMenuID, Level2Title, MenuID, Title, Level1SortOrder, Level2SortOrder, Level3SortOrder
FROM TT
GROUP BY Level1Title, PrntMenuID, Level2Title, MenuID, Title, Level1SortOrder, Level2SortOrder, Level3SortOrder
),
MENU AS (
SELECT Level1Title, PrntMenuID, Level2Title, MenuID, Title, Level1SortOrder, Level2SortOrder, Level3SortOrder
 ,(Level1Title + ' > ' + Level2Title + ' > ' + Title) AS navigation
FROM MM
) 
SELECT T.MenuID
     , P.ProgramID
     , T.PrntMenuID
     , MENU.navigation
     , T.Title
     , SUM(M.ViewCnt) AS CNT
     , Level1SortOrder, Level2SortOrder, Level3SortOrder
FROM TB_FX_MenuConnect M WITH(NOLOCK)
JOIN TB_FX_MenuItemInfo T WITH(NOLOCK) ON M.MenuID = T.TITLE
JOIN TB_FX_ProgramInfo P WITH(NOLOCK) ON T.ProgramID = P.ProgramID
JOIN MENU WITH(NOLOCK) ON MENU.MenuID = T.MenuID
WHERE (M.CnntDate >= @FROM_DATE AND M.CnntDate <= @TO_DATE)
  AND T.MenuID LIKE 'SCP%'
  --AND T.MenuID NOT LIKE 'DM%'
  --AND T.MenuID NOT LIKE 'SY%'
  --AND T.MenuID NOT LIKE 'SY%'
GROUP BY T.MenuID, P.ProgramID, T.PrntMenuID, MENU.navigation, T.Title, Level1SortOrder, Level2SortOrder, Level3SortOrder
ORDER BY Level1SortOrder, Level2SortOrder, Level3SortOrder
--ORDER BY SUM(M.ViewCnt) DESC
;