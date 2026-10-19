/* =============================================================================
프로그램ID	: UP_FX_GetUserInfoSearchList
업  무  명	: 시스템관리 - 사용자관리 목록
프로그램명	: 사용자 정보 조회
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: KYH


============================================================================= 
  Date			In Charge		Description
=============================================================================
  2019/01/09	hwyoon			사용자 신규 입력 시 XLS PWD 설정
  2020/02/04    khh79           장기 미사용자 관리를 위한 PermanentYN 추가('Y' 면 미접속 상용자 등록 제외)

============================================================================= */

CREATE PROCEDURE [dbo].[UP_FX_GetUserInfoSearchList]
	@Search		    NVARCHAR(20)		
	, @DeptName		NVARCHAR(200)
	, @GroupID		NVARCHAR(20)
	, @UseYN		CHAR(1)
AS
BEGIN
		SELECT * FROM
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
				,	A.TimeZone
				,	A.LastLoginDateTime
				,   A.PermanentYN
				,	A.UseYN
				,	A.RegtUserID
				--,	CONVERT(CHAR(10), A.RegtDateTime, 23) RegtDateTime
				, A.RegtDateTime
				,	A.UpdateUserID
				--,	CONVERT(CHAR(10), A.UpdateDateTime, 23) UpdateDateTime
				,	A.UpdateDateTime
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
			FROM dbo.TB_FX_User AS A WITH(NOLOCK)
			LEFT OUTER JOIN dbo.TB_FX_UserGroupInfo G WITH(NOLOCK)
			ON A.UserID = G.UserID
			WHERE (@GroupID IS NULL OR G.GroupID = @GroupID)
			GROUP BY
				A.UserID			
				,	A.UserName
				,	A.UserName_E
				,	A.Email			
				,	A.Dept_ID
				,	A.OfficePhoneNum
				,	A.CellPhoneNum
				,	A.Language
				,	A.DefaultGroupID
				,	A.TimeZone
				,	A.LastLoginDateTime
				,   A.PermanentYN
				,	A.UseYN
				,	A.RegtUserID
				,	A.RegtDateTime
				,	A.UpdateUserID
				,	A.UpdateDateTime
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
		) B
		WHERE 
		(
			(
				(@Search IS NULL OR B.UserID LIKE '%' + @Search + '%')
				OR (@Search IS NULL OR B.UserName LIKE '%' + @Search + '%')
				OR (@Search IS NULL OR B.UserName_E LIKE '%' + @Search + '%')
			)
			AND
			(
				(@DeptName IS NULL OR B.Dept_ID LIKE '%' + @DeptName + '%')
				OR (@DeptName IS NULL OR B.Dept_Name LIKE '%' + @DeptName + '%')
			)
		)
		AND 
		(@UseYN IS NULL OR B.UseYN = @UseYN)
END
