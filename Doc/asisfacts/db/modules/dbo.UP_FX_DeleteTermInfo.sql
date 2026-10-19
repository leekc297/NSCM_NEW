
/* =============================================================================
프로그램ID	: UP_FX_DeleteTermInfo
업  무  명	: 시스템관리 - Word 관리
프로그램명	: Word 삭제
최초작성일	: 2017.10.24
최종작성일	: 2017.10.24
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteTermInfo]
(
	@TermID	NVARCHAR(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM TB_FX_TermInfo
	WHERE TermID = @TermID
END








