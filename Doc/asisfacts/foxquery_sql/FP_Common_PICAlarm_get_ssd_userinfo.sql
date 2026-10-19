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
				AND ISNULL(A.USER_ID'') = @USER_ID