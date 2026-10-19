
/*
 * Program ID   : UP_FX_GetGSCMGuestUserAuthenctication
 * Description  : 신규 사용자 로그인
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/26   ygkim          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/04/05   ygkim          [SCM_MST_SSO_DEPT_INFO] LEFT OUTER JOIN으로 수정(부서가 없어도 사용자 정보를 가져오기 위해서)
 * 2018/04/09   ygkim          장기 미접속자 정보를 가져오기 위해서 TB_FX_UserLockList 조인 추가
 */

CREATE PROCEDURE [dbo].[UP_FX_GetGSCMGuestUserAuthenctication]
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
		WHERE U.UserID = 'Guest' AND U.UseYN = 'Y';

		SELECT USER_ID NewUserID
		      ,USER_NAME NewUserName
			  ,USER_NAME_EN NewUserNameE
			  ,A.DEPT_ID NewDeptID
			  ,B.DEPT_NAME_KO NewDeptNameK
			  ,B.DEPT_NAME_EN NewDeptNameE
			  ,B.DEPT_NAME_CN NewDeptNameC
			  ,C.VALID_YN LongTermNotConnectYn
		FROM [dbo].[SCM_MST_SSO_USER_INFO] A WITH(NOLOCK)
		LEFT OUTER JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B  WITH(NOLOCK) ON A.DEPT_ID = B.DEPT_ID AND B.VALID_YN = 'Y'
		LEFT OUTER JOIN TB_FX_UserLockList C  WITH(NOLOCK) ON A.USER_ID = C.UserID
		WHERE A.USER_ID = @UserID;
	END
END

