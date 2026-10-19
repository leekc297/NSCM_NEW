

/* =============================================================================
프로그램ID	: UP_FX_GetMessageInfoList
업  무  명	: 시스템관리 - 메세지관리목록
프로그램명	: 메세지정보 리스트
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_GetMessageInfoList]
	@Search			NVARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		 MessageID
		,Ko
		,En
		,Ch
		,Type
		,Button
		,UseYN
		,RegtUserID
	FROM TB_FX_MessageInfo WITH(NOLOCK)
	WHERE 
	(
		(@Search IS NULL OR MessageID LIKE '%' + @Search + '%') OR
			(@Search IS NULL OR Ko LIKE '%' + @Search + '%') OR
			(@Search IS NULL OR En LIKE '%' + @Search + '%') OR
			(@Search IS NULL OR Ch LIKE '%' + @Search + '%') 
	)
	ORDER BY MessageID

END







