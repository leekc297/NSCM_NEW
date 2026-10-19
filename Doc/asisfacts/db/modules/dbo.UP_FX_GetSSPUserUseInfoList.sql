



/* =============================================================================
프로그램ID	: UP_FX_GetSSPUserUseInfoList
업  무  명	: SSP 사용자 LIST
프로그램명	: 사용자 정보 조회
최초작성일	: 2019.07.10
최종작성일	: 2019.07.10
개  발  자	: mcTheJ
입  력  값	: 
출  력  값	: 

============================================================================= */

CREATE PROCEDURE [dbo].[UP_FX_GetSSPUserUseInfoList]
	
	@Search		    NVARCHAR(12)
   ,@Language		NVARCHAR(2) = 'KO'
   ,@UseYN			NVARCHAR(1) = 'Y'		

AS
BEGIN
	
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
		FROM dbo.TB_FX_User				AS A WITH(NOLOCK)
		WHERE 1 = 1
		AND UseYN = @UseYN
		AND ((@Search IS NULL OR A.UserID LIKE '%' + @Search + '%')
		OR (@Search IS NULL OR A.UserName LIKE '%' + @Search + '%')
		OR (@Search IS NULL OR A.UserName_E LIKE '%' + @Search + '%'))
END






