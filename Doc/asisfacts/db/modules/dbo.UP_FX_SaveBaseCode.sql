/* =============================================================================
프로그램ID	: [UP_FX_SaveBaseCode]
업  무  명	: 베이스코드 관리
프로그램명	: 베이스코드 등록/수정
최초작성일	: 2017.10.14
최종작성일	: 2017.10.14
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveBaseCode]
(
	  @BaseCode				NCHAR(7)
	, @ClsCode1				NCHAR(2)
	, @ClsCode2				NCHAR(2)
	, @ClsCode3				NCHAR(3)
	, @CodeName				NVARCHAR(50)
	, @PrntCode				NCHAR(7)
	, @SortOrder			INT	
	, @UseYN				NCHAR(1) 
	, @RegtUserID			NVARCHAR(30) 
)
AS
BEGIN
	SET NOCOUNT ON;
	MERGE dbo.TB_FX_BaseCode	WITH(HOLDLOCK) G
	USING (
		SELECT
			@BaseCode	AS	BaseCode
	) T ON	G.BaseCode	=	T.BaseCode
	WHEN MATCHED THEN
		UPDATE 
		SET	G.ClsCode1		=	@ClsCode1,
			G.ClsCode2		=	@ClsCode2,
			G.ClsCode3		=	@ClsCode3,
			G.CodeName		=	@CodeName,
			G.PrntCode		=	@PrntCode,
			G.SortOrder		=	@SortOrder,
			G.UseYN			=	@UseYN,
			G.UpdateUserID	=	@RegtUserID,
			G.UpdateDateTime	=	GETDATE()		

	WHEN NOT MATCHED THEN
		INSERT 
		(
			BaseCode,
			ClsCode1,
			ClsCode2,
			ClsCode3,
			CodeName,
			PrntCode,
			SortOrder,
			UseYN,
			RegtUserID,
			RegtDateTime,
			UpdateUserID,
			UpdateDateTime
		)
		VALUES
		(
			@BaseCode,
			@ClsCode1,
			@ClsCode2,
			@ClsCode3,
			@CodeName,
			@PrntCode,
			@SortOrder,
			@UseYN,
			@RegtUserID,
			GETDATE(),
			@RegtUserID,
			GETDATE()
		);
END
