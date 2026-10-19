
/* =============================================================================
프로그램ID	: UP_FX_SaveTermInfo
업  무  명	: 시스템관리 - Word 관리
프로그램명	: 
최초작성일	: 2017.10.24
최종작성일	: 2017.10.24
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveTermInfo]
(
	@TermID	NVARCHAR(100)
   ,@Ko			NVARCHAR(250)
   ,@En			NVARCHAR(250)
   ,@Ch			NVARCHAR(250)
   ,@Description NVARCHAR(max)
   ,@UseYN			NCHAR(1)
   ,@RegtUserID		NVARCHAR(30)
)
AS
BEGIN
	SET NOCOUNT ON;

	MERGE dbo.TB_FX_TermInfo	WITH(HOLDLOCK)	M
	USING (
		SELECT
			@TermID		AS	TermID
	) T ON	M.TermID		=	T.TermID
	WHEN MATCHED THEN
		UPDATE 
		SET	M.Ko			=	@ko,
			M.En			=	@En,
			M.Ch			=	@Ch,
			M.description	=	@Description,
			M.UseYN			=	@UseYN,
			M.UpdateUserID	=	@RegtUserID,
			M.UpdateDateTime	=	GETDATE()		

	WHEN NOT MATCHED THEN
		INSERT 
		(
			TermID,
			Ko,
			En,
			Ch,
			Description,
			UseYN,
			RegtUserID,
			RegtDateTime,
			UpdateUserID,
			UpdateDateTime
		)
		VALUES
		(
			@TermID,
			@Ko,
			@En,			
			@Ch,
			@Description,
			@UseYN,
			@RegtUserID,
			GETDATE(),
			@RegtUserID,
			GETDATE()
		);
END











