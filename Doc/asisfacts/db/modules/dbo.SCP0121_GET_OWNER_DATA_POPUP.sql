


/*
 * Program ID   : SCP0121_GET_OWNER_DATA_POPUP
 * Description  : OWNER 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/06/04   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 */

CREATE PROCEDURE [dbo].[SCP0121_GET_OWNER_DATA_POPUP]
  
  @p_division_id		NVARCHAR(MAX)
  , @p_search			NVARCHAR(MAX)
  , @p_owner_id			NVARCHAR(MAX)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--OWNER 정보
	SELECT FxU.UserID
		 , FxU.UserName + ' ' + UI.JOB_NAME AS UserName
		 , UI.USER_NAME_EN
		 , FxU.DEPT_ID
		 , DI.DEPT_NAME_KO
		 , ROW_NUMBER() OVER (ORDER BY FxU.UserID, FxU.UserName) * 100 AS SORT_ORDER_NO
		 , 'Y' AS USER_SELECTABLE_FLAG
	FROM (SELECT * FROM dbo.TB_FX_User WITH(NOLOCK) WHERE UseYN = 'Y') AS FxU 
	LEFT JOIN SCM_MST_SSO_DEPT_INFO AS DI WITH(NOLOCK)
		ON FxU.DEPT_ID = DI.DEPT_ID AND DI.VALID_YN = 'Y'
	LEFT JOIN SCM_MST_SSO_USER_INFO AS UI WITH(NOLOCK)
		ON FxU.UserID = UI.USER_ID
	LEFT JOIN TB_FX_UserGroupAuthExtention AS FxUGA WITH(NOLOCK)
		ON FxU.UserID = FxUGA.UserID
	INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_search,',') ) b
		ON      CASE WHEN @p_search = '' THEN @p_search			
				ELSE UI.USER_ID  END like  b.tst 
		OR      CASE WHEN @p_search = '' THEN @p_search
				ELSE UI.USER_NAME  END like  b.tst
		OR      CASE WHEN @p_search = '' THEN @p_search
				ELSE DI.DEPT_NAME_KO  END like  b.tst
	WHERE 1=1
	AND FxUGA.Code = @p_division_id
	AND CASE WHEN @p_owner_id = 'ALL' THEN 'ALL'
		   	ELSE UI.USER_ID		
			END NOT IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_owner_id,',') as P Where 
					(CASE WHEN @p_owner_id = 'ALL' THEN 'ALL' ELSE UI.USER_ID END) = P.data
				)	
	AND @p_search NOT IN (
			Select * from dbo.UF_FX_String_SplitForIN (@p_owner_id,',') as P Where 
			(CASE WHEN @p_owner_id = 'ALL' THEN 'ALL' ELSE UI.USER_ID END) = P.data
		)	
	GROUP BY FxU.UserID, FxU.UserName, UI.USER_NAME_EN, FxU.Dept_ID, DI.DEPT_NAME_KO, UI.JOB_NAME
	ORDER BY DI.DEPT_NAME_KO,FxU.UserName, FxU.UserID

	-- 오른쪽 스프레드 데이터
	SELECT FxU.UserID	
		 , FxU.UserName + ' ' + UI.JOB_NAME AS UserName
		 , UI.USER_NAME_EN
		 , FxU.DEPT_ID
		 , DI.DEPT_NAME_KO
		 , (SELECT NR FROM dbo.String_Split(@p_owner_id,',') WHERE TOKEN = FxU.UserID) AS SORT_ORDER_NO
		 , 'Y' AS USER_SELECTABLE_FLAG
	FROM (SELECT * FROM dbo.TB_FX_User WITH(NOLOCK) WHERE UseYN = 'Y') AS FxU 
	LEFT JOIN SCM_MST_SSO_DEPT_INFO AS DI WITH(NOLOCK)
		ON FxU.DEPT_ID = DI.DEPT_ID AND DI.VALID_YN = 'Y'
	LEFT JOIN SCM_MST_SSO_USER_INFO AS UI WITH(NOLOCK)
		ON FxU.UserID = UI.USER_ID
	LEFT JOIN TB_FX_UserGroupAuthExtention AS FxUGA WITH(NOLOCK)
		ON FxU.UserID = FxUGA.UserID
	WHERE 1 = 1
	AND FxUGA.Code = @p_division_id
	AND CASE WHEN @p_owner_id = 'ALL' THEN 'ALL'
		   	ELSE UI.USER_ID		
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_owner_id,',') as P Where 
					(CASE WHEN @p_owner_id = 'ALL' THEN 'ALL' ELSE UI.USER_ID END) = P.data
				)	
	GROUP BY FxU.UserID, FxU.UserName, UI.USER_NAME_EN, FxU.Dept_ID, DI.DEPT_NAME_KO, UI.JOB_NAME
	ORDER BY SORT_ORDER_NO
  
END

