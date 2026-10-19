
/* =============================================================================
프로그램ID	: UP_FX_GetGSCMUserAuthenctication
업  무  명	: 사용자 로그인
프로그램명	: 메인메뉴컨테이너 
최초작성일	: 2017.11.23
최종작성일	: 
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	:  
============================================================================= */
CREATE PROCEDURE [dbo].[UP_FX_GetGSCMUserAuthenctication]
(
	 @UserID		NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RowCount	INT;

	BEGIN
		-- 로그인 시간을 저장한다.
		BEGIN
			UPDATE dbo.TB_FX_User SET LastLoginDateTime = GETDATE() WHERE UserID = @UserID
		END

		SELECT U.UserID
			, U.UserName
			, U.UserName_E
			, U.Email
			, U.Dept_ID
			, Dept_Name =
				CASE U.Language
				WHEN 'KO' THEN (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = U.DEPT_ID)
				WHEN 'EN' THEN (SELECT DEPT_NAME_EN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = U.DEPT_ID)
				WHEN 'CN' THEN (SELECT DEPT_NAME_CN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = U.DEPT_ID)
				END	
			, U.OfficePhoneNum
			, U.CellPhoneNum
			, U.Language
			, DefaultGroupID
			= (SELECT G.GroupID FROM dbo.TB_FX_GroupInfo G WHERE G.GroupID = u.DefaultGroupID AND G.UseYN = 'Y')
			, U.TimeZone
		FROM dbo.TB_FX_User u
		WHERE U.UserID = @UserID AND U.UseYN = 'Y';
	END
END

