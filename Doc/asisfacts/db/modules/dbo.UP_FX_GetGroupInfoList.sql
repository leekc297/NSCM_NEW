

/* =============================================================================
프로그램ID	: UP_FX_GetGroupInfoList
업  무  명	: 시스템관리 - 그룹관리목록
프로그램명	: 그룹정보 리스트
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_GetGroupInfoList]

AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		 GroupID
		, GrpName
		, UseYN
		, RegtUserID
	FROM TB_FX_GroupInfo WITH(NOLOCK)

END







