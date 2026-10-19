

/* =============================================================================
프로그램ID	: UP_FX_GetTermInfoList
업  무  명	: 시스템관리 - Word 관리
프로그램명	: 메세지정보 리스트
최초작성일	: 2017.10.24
최종작성일	: 2017.10.24
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_GetTermInfoList]
	@Search			NVARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		 TermID
		,Ko
		,En
		,Ch
		,UseYN
		,DESCRIPTION
		,RegtUserID
	FROM TB_FX_TermInfo WITH(NOLOCK)
	WHERE 
	(
		(@Search IS NULL OR TermID LIKE '%' + @Search + '%') OR
		(@Search IS NULL OR Ko LIKE '%' + @Search + '%') OR
		(@Search IS NULL OR En LIKE '%' + @Search + '%') OR
		(@Search IS NULL OR Ch LIKE '%' + @Search + '%') 
	)
	ORDER BY TermID

END







