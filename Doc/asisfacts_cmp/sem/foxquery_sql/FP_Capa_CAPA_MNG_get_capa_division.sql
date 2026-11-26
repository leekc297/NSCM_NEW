Declare @AuthTypePara varchar(100) = 'D'		  
    if(@GROUP_ID = 'JV Planner') SET @AuthTypePara = 'J';  
  
    SELECT   
		DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
		--DIVISION_ID AS CODE, DIVISION_ID AS NAME   
    FROM  
    [LGCE_SCMPROD].[dbo].[SCM_MST_DIVISION] WITH(NOLOCK)  
    WHERE   
		DIVISION_ID IN   
		(SELECT CODE FROM [LGCE_SCMPROD].[dbo].TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GROUP_ID AND UserID = @USER_ID AND AuthType = @AuthTypePara)  
		-- (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @GROUP_ID AND UserID = @USER_ID AND AuthType = 'D')  
		--AND DIVISION_ID NOT IN ('EE','EE_UC') 
		AND DIVISION_ID NOT IN ('EE')  -- CAPA에선 EE_UC 조회 가능토록 변경
		AND VALID_YN = 'Y'  
    GROUP BY   
		DIVISION_ID, ATTRIBUTE1  
    --ORDER BY DIVISION_ID  
    ORDER BY ATTRIBUTE1