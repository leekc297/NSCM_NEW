

/* =============================================================================
프로그램ID	: [UP_FX_GetUserGroupInfoList]
업  무  명	: 그룹별 사용자 관리
프로그램명	: 그룹별 사용자관리 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 'SYSTEMCODE','GROUPID',''20140001|Y,20140002|N,20140003|Y','USERID'
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_GetUserGroupInfoList]
(
	 @GroupID				NVARCHAR(20)
)
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT
		 UG.GroupID,
		 UG.UserID,
		 U.UserName,
		 U.UserName_E,
		 U.Email,
		 U.Dept_ID,
	 	Dept_Name =
	  	CASE U.Language
		WHEN 'KO' THEN (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = U.DEPT_ID)
		WHEN 'EN' THEN (SELECT DEPT_NAME_EN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = U.DEPT_ID)
		WHEN 'CN' THEN (SELECT DEPT_NAME_CN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = U.DEPT_ID)
		END,	
		 UG.UseYN,
		 UG.RegtUserID
	FROM dbo.TB_FX_UserGroupInfo AS UG WITH(NOLOCK)
	LEFT JOIN dbo.TB_FX_User AS U
		ON UG.UserID	= U.UserID 
	WHERE UG.GroupID	= @GroupID

END
















