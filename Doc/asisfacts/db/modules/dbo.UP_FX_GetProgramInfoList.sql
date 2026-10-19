
/* =============================================================================
프로그램ID	: UP_FX_GetProgramInfoList
업  무  명	: 시스템관리 - 프로그램관리 목록
프로그램명	: 사용자 정보 조회
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */

CREATE PROCEDURE [dbo].[UP_FX_GetProgramInfoList]
	@Search NVARCHAR(12)		
AS
BEGIN

		SELECT	ProgramID			
			,	ProgramPath
			,	ClassName
			,	ProgramName
			,	UseYN
			,	RegtUserID
		FROM TB_FX_ProgramInfo WITH(NOLOCK)
		WHERE	(@Search IS NULL OR ProgramID LIKE '%' + @Search + '%') OR (@Search IS NULL OR ProgramName LIKE '%' + @Search + '%')
		ORDER BY ProgramID
END
