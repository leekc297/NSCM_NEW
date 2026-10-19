


/* =============================================================================
프로그램ID	: [UP_FX_SaveProgramInfo]
업  무  명	: 프로그램 관리
프로그램명	: 프로그램 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveProgramInfo]
(
	  @ProgramID		NVARCHAR(20)
    , @ProgramPath		NVARCHAR(250)
	, @ClassName		NVARCHAR(250)
    , @ProgramName		NVARCHAR(50)
    , @UseYN			NCHAR(1)
	, @RegtUserID		NVARCHAR(30) 
)
AS
BEGIN
	SET NOCOUNT ON;

	MERGE dbo.TB_FX_ProgramInfo	WITH(HOLDLOCK)	P
	USING (
		SELECT
			@ProgramID	AS	ProgramID
	) T ON	P.ProgramID	=	T.ProgramID
	WHEN MATCHED THEN
		UPDATE 
		SET	P.ProgramPath	=	@ProgramPath,
			P.ClassName		=	@ClassName,
			P.ProgramName	=	@ProgramName,
			P.UseYN			=	@UseYN,
			P.UpdateUserID	=	@RegtUserID,
			P.UpdateDateTime	=	GETDATE()		

	WHEN NOT MATCHED THEN
		INSERT 
		(	
			ProgramID,
			ProgramName,
			ProgramPath,
			ClassName,
			UseYN,
			RegtUserID,
			RegtDateTime,
			UpdateUserID,
			UpdateDateTime
		)
		VALUES
		(
			@ProgramID,
			@ProgramName,
			@ProgramPath,
			@ClassName,
			@UseYN,
			@RegtUserID,
			GETDATE(),
			@RegtUserID,
			GETDATE()
		);
END













