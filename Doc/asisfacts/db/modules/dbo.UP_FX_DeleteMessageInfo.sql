






/* =============================================================================
프로그램ID	: [UP_FX_DeleteMessageInfo]
업  무  명	: 그룹 관리
프로그램명	: 그룹 삭제
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
비	고	    : 해당 그룹ID와 관련된 테이블의 데이타를 모두 삭제 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteMessageInfo]
(
	@MessageID		NVARCHAR(10)
)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM TB_FX_MessageInfo
	WHERE MessageID = @MessageID
END








