
/* =============================================================================
프로그램ID	: [UP_FX_DeleteBaseCode]
업  무  명	: 베이스코드 관리
프로그램명	: 베이스코드 삭제
최초작성일	: 2017.10.14
최종작성일	: 2017.10.14
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteBaseCode]
(
	@BaseCode		NCHAR(7)
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN
		DELETE FROM TB_FX_BaseCode WHERE PrntCode = @BaseCode
	END

	BEGIN
		DELETE FROM TB_FX_BaseCode WHERE BaseCode = @BaseCode
	END
END
