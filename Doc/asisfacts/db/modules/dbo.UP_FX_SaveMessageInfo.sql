
/* =============================================================================
프로그램ID	: [UP_FX_SaveMessageInfo]
업  무  명	: 메세지 관리
프로그램명	: 메세지 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveMessageInfo]
(
	@MessageID	NVARCHAR(10)
   ,@Ko			NVARCHAR(250)
   ,@En			NVARCHAR(250)
   ,@Ch			NVARCHAR(250)
   ,@Type			NCHAR(7)
   ,@Button			NCHAR(7)
   ,@UseYN			NCHAR(1)
   ,@RegtUserID		NVARCHAR(30)
)
AS
BEGIN
	SET NOCOUNT ON;

	MERGE dbo.TB_FX_MessageInfo	WITH(HOLDLOCK)	M
	USING (
		SELECT
			@MessageID		AS	MessageID
	) T ON	M.MessageID		=	T.MessageID
	WHEN MATCHED THEN
		UPDATE 
		SET	M.Ko			=	@ko,
			M.En			=	@En,
			M.Ch			=	@Ch,
			M.Type			=	@Type,
			M.Button		=	@Button,
			M.UseYN			=	@UseYN,
			M.UpdateUserID	=	@RegtUserID,
			M.UpdateDateTime	=	GETDATE()		

	WHEN NOT MATCHED THEN
		INSERT 
		(
			MessageID,
			Ko,
			En,
			Ch,
			Type,
			Button,
			UseYN,
			RegtUserID,
			RegtDateTime,
			UpdateUserID,
			UpdateDateTime
		)
		VALUES
		(
			@MessageID,
			@Ko,
			@En,
			@Ch,
			@Type,
			@Button,
			@UseYN,
			@RegtUserID,
			GETDATE(),
			@RegtUserID,
			GETDATE()
		);
END











