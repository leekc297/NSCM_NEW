


/* =============================================================================
프로그램ID	: UP_FX_GetUserInfoList
업  무  명	: 시스템관리 - 사용자관리 목록
프로그램명	: 사용자 정보 조회
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */

CREATE PROCEDURE [dbo].[UP_FX_GetUserInfoList]
	
	@Search		    NVARCHAR(12)
   ,@Language		NVARCHAR(2) = 'KO'
   ,@SSOUserYN      NVARCHAR(1) = 'N'		

AS
BEGIN
	
	IF @SSOUserYN = 'N'
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
			WHERE (@Search IS NULL OR A.UserID LIKE '%' + @Search + '%')
			OR (@Search IS NULL OR A.UserName LIKE '%' + @Search + '%')
			OR (@Search IS NULL OR A.UserName_E LIKE '%' + @Search + '%')
		END
	ELSE 
		BEGIN
			SELECT A.user_id UserID			
				,A.user_name UserName
				,A.user_name_en	UserName_E
				,A.dept_id 
				,CASE @Language WHEN 'KO' THEN B.dept_name_ko
								WHEN 'EN' THEN B.dept_name_en
								WHEN 'CN' THEN B.dept_name_cn
					END dept_name  
			FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)
			INNER JOIN SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK) ON A.DEPT_ID = B.DEPT_ID
			WHERE A.ACTIVE_FLAG != 'D'
				AND (@Search IS NULL OR A.user_id LIKE '%' + @Search + '%')
					OR (@Search IS NULL OR A.user_name LIKE '%' + @Search + '%')
					OR (@Search IS NULL OR A.user_name_en LIKE '%' + @Search + '%')
		END
END





