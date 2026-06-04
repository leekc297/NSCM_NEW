
/* =============================================================================
프로그램ID	: 
업  무  명	: 신규사용자 권한요청 - 1차 등록된 유저에 대한 기본정보 조회
프로그램명	: 권한 요청
최초작성일	: 2018.03
최종작성일	: 2018.03
개  발  자	: KYH
============================================================================= */

CREATE PROCEDURE [dbo].[UP_FX_GetReqAuthCurrentUser]
	@p_UserID		NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		A.USERID , A.USERNAME , A.USERNAME_E, A.EMAIL , 
		case when (A.DEPT_ID is null or A.DEPT_ID = '') then B.DEPT_ID else A.DEPT_ID end as DEPT_ID ,
		C.DEPT_NAME_KO ,
		C.DEPT_NAME_EN ,
		C.DEPT_NAME_CN ,
		A.CELLPHONENUM, 
		A.LANGUAGE, 
		A.DEFAULTGROUPID, 
		A.TIMEZONE
	FROM TB_FX_USER (NOLOCK) A
	left join SCM_MST_SSO_USER_INFO (nolock) B on a.userID = b.user_id
	left join SCM_MST_SSO_DEPT_INFO(nolock) C on B.dept_id=C.dept_id 
	WHERE A.USERID = @p_UserID

END


