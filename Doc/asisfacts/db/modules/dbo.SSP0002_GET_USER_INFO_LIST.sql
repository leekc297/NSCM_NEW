


/* =============================================================================
프로그램ID	: SSP0002_GET_USER_INFO_LIST
업  무  명	: SSP Planner 권한 사용자 조회용
프로그램명	: 사용자 정보 조회
최초작성일	: 2020.03.13
최종작성일	: 2020.03.13
개  발  자	: 김용호
입  력  값	: 
출  력  값	: 

============================================================================= */

CREATE PROCEDURE [dbo].[SSP0002_GET_USER_INFO_LIST]
	
	@Search		    NVARCHAR(12)
   ,@Language		NVARCHAR(2) = 'KO'
   ,@SSOUserYN      NVARCHAR(1) = 'N'		

AS
BEGIN
	
	SELECT  
			AA.UserID			      AS UserID
		,	MAX(AA.UserName)          AS UserName
		,	MAX(AA.UserName_E)        AS UserName_E
		,	MAX(AA.Email)			  AS Email
		,	MAX(AA.Dept_ID)           AS Dept_ID
		,	MAX(AA.Dept_Name)         AS Dept_Name
		,	MAX(AA.OfficePhoneNum)    AS OfficePhoneNum
		,	MAX(AA.CellPhoneNum)	  AS CellPhoneNum
		,	MAX(AA.Language)		  AS Language
		,	MAX(AA.DefaultGroupID)	  AS DefaultGroupID
		,	MAX(AA.GrpName)			  AS GrpName
		,	MAX(AA.TimeZone)		  AS TimeZone
		,	MAX(AA.LastLoginDateTime) AS LastLoginDateTime
		,	MAX(AA.UseYN)			  AS UseYN
		,	MAX(AA.RegtUserID)		  AS RegtUserID
		,	MAX(AA.Attribute1)		  AS Attribute1
		,	MAX(AA.Attribute2)		  AS Attribute2
		,	MAX(AA.Attribute3)		  AS Attribute3
		,	MAX(AA.Attribute4)		  AS Attribute4
		,	MAX(AA.Attribute5)		  AS Attribute5
		,	MAX(AA.Attribute6)		  AS Attribute6
		,	MAX(AA.Attribute7)		  AS Attribute7
		,	MAX(AA.Attribute8)		  AS Attribute8
		,	MAX(AA.Attribute9)		  AS Attribute9
		,	MAX(AA.Attribute10)		  AS Attribute10
		,   MAX(AA.GroupID)			  AS GroupID
	FROM
	(
		SELECT	A.UserID			
			,	A.UserName
			,	A.UserName_E
			,	A.Email			
			,	A.Dept_ID
			,	Dept_Name =
				CASE A.Language
				WHEN 'KO' THEN (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				WHEN 'EN' THEN (SELECT DEPT_NAME_EN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				WHEN 'CN' THEN (SELECT DEPT_NAME_CN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				END	
			,	A.OfficePhoneNum
			,	A.CellPhoneNum
			,	A.Language
			,	A.DefaultGroupID
			,	GrpName = (SELECT GrpName FROM TB_FX_GroupInfo G, TB_FX_UserGroupInfo U WHERE G.GroupID = U.GroupID AND U.UserID = A.UserID AND U.GroupID = A.DefaultGroupID)
			,	A.TimeZone
			,	A.LastLoginDateTime
			,	A.UseYN
			,	A.RegtUserID
			,	A.Attribute1
			,	A.Attribute2
			,	A.Attribute3
			,	A.Attribute4
			,	A.Attribute5
			,	A.Attribute6
			,	A.Attribute7
			,	A.Attribute8
			,	A.Attribute9
			,	A.Attribute10
			,   U.GroupID
		FROM dbo.TB_FX_User				AS A WITH(NOLOCK)
		LEFT JOIN dbo.TB_FX_UserGroupAuthExtention AS U WITH(NOLOCK)
		ON A.UserID = U.UserID
		WHERE(@Search IS NULL OR A.UserID LIKE '%' + @Search + '%')
		OR (@Search IS NULL OR A.UserName LIKE '%' + @Search + '%')
		OR (@Search IS NULL OR A.UserName_E LIKE '%' + @Search + '%')		
	) AA
	WHERE  1=1
	AND AA.GroupID IN ('SSP Planner', 'ADMIN', 'SCM PI Admin')
	AND AA.USEYN = 'Y'
	GROUP BY AA.UserID
END
