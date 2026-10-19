










/* =============================================================================
프로그램ID	: [UP_FX_SaveMenuTitleInfo]
업  무  명	: 메뉴관리 관리
프로그램명	: 메뉴제목 다국어 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveMenuTitleInfo]
(
	  @MenuID				NVARCHAR(20)
	, @CultureCode			NCHAR(7) 
	, @DisplayTitle			NVARCHAR(255)
	, @UserID				NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;

	MERGE dbo.TB_FX_MenuTitleInfo	WITH(HOLDLOCK)	M
		USING (
			SELECT
				@MenuID			AS	MenuID
			,	@CultureCode	AS	CultureCode
		) T ON	M.MenuID		=	T.MenuID
			AND	M.CultureCode	=	T.CultureCode
		WHEN MATCHED THEN
			UPDATE 
			SET	M.DisplayTitle		=	@DisplayTitle,
				M.UpdateUserID		=	@UserID,
				M.UpdateDateTime	=	GETDATE()		

		WHEN NOT MATCHED THEN
			INSERT VALUES
			(
				@MenuID,
				@CultureCode,
				@DisplayTitle,
				@UserID,
				GETDATE(),
				@UserID,
				GETDATE()
			);
END












