






/* =============================================================================
프로그램ID	: [UP_FX_DeleteProgramInfo]
업  무  명	: 프로그램 관리
프로그램명	: 그룹 삭제
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
비	고	    : 메뉴정보의 프로그램정보는 NULL로 수정됩니다. 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteProgramInfo]
(
	  @ProgramID			NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN
		DELETE FROM dbo.TB_FX_ProgramInfo
		WHERE ProgramID	= @ProgramID
	END

	BEGIN
		UPDATE  dbo.TB_FX_ProgramInfo
		SET ProgramID = NULL
		WHERE ProgramID	= @ProgramID 
	END
END








