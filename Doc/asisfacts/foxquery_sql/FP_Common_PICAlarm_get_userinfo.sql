SELECT	A.UserID			
				,	A.UserName
				,	A.UserName_E
				,	A.Email			
				,	A.Dept_ID
				, (SELECT DEPT_NAME_EN FROM LGCE_SCMDEV.dbo.SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID) AS DEPT_NAME
				--,	Dept_Name =
				--	CASE A.Language
				--	WHEN 'KO' THEN (SELECT DEPT_NAME_KO FROM LGCE_SCMDEV.dbo.SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				--	WHEN 'EN' THEN (SELECT DEPT_NAME_EN FROM LGCE_SCMDEV.dbo.SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				--	WHEN 'CN' THEN (SELECT DEPT_NAME_CN FROM LGCE_SCMDEV.dbo.SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				--	END	
				,	A.OfficePhoneNum
				,	A.CellPhoneNum
				,	A.Language
				,	A.DefaultGroupID
				,	GrpName = (SELECT GrpName FROM LGCE_SCMDEV.dbo.TB_FX_GroupInfo G, LGCE_SCMDEV.dbo.TB_FX_UserGroupInfo U WHERE G.GroupID = U.GroupID AND U.UserID = A.UserID AND U.GroupID = A.DefaultGroupID)
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
			FROM LGCE_SCMDEV.dbo.TB_FX_User				AS A WITH(NOLOCK)
			WHERE ISNULL(A.USERID,'') = @USER_ID