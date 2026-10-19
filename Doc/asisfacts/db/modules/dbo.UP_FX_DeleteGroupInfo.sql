





/* =============================================================================
프로그램ID	: [UP_FX_DeleteGroupInfo]
업  무  명	: 그룹 관리
프로그램명	: 그룹 삭제
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
비	고	    : 해당 그룹ID와 관련된 테이블의 데이타를 모두 삭제 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteGroupInfo]
(
	@GroupID				NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN
		DELETE FROM dbo.TB_FX_GroupMenuAuthExtension
		WHERE GroupID = @GroupID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_GroupMenuAuth
		WHERE GroupID = @GroupID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_UserGroupInfo
		WHERE GroupID = @GroupID
	END

	BEGIN
		DELETE FROM dbo.TB_FX_GroupInfo
		WHERE GroupID = @GroupID
	END

END







