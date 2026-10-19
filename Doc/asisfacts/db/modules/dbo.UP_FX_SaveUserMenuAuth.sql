









/* =============================================================================
프로그램ID	: [UP_FX_SaveUserMenuAuth]
업  무  명	: 사용자별 메뉴권한 관리
프로그램명	: 사용자별 메뉴권한 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveUserMenuAuth]
(
	  @MenuID				NVARCHAR(20) 
	, @AllotUserID			NVARCHAR(12)
	, @BasicACLC			BIT
	, @BasicACLR			BIT 
	, @BasicACLU			BIT
	, @BasicACLD			BIT 
	, @ExtenedACL			INT 
	, @UseYN				NCHAR(1) 
	, @UserID				NVARCHAR(20) 
)
AS
BEGIN
	SET NOCOUNT ON;

	MERGE dbo.TB_FX_UserMenuAuth	WITH(HOLDLOCK)	G
		USING (
			SELECT
				@MenuID			AS	MenuID
			,	@AllotUserID	AS	AllotUserID
		) T ON	G.MenuID	=	T.MenuID
			AND	G.UserID	=	T.AllotUserID
		WHEN MATCHED THEN
			UPDATE 
			SET	G.BasicACLC		=	@BasicACLC,
				G.BasicACLR		=	@BasicACLR,
				G.BasicACLU		=	@BasicACLU,
				G.BasicACLD		=	@BasicACLD,
				G.ExtendedACL	=	@ExtenedACL,
				G.UseYN			=	@UseYN,
				G.UpdateUserID	=	@UserID,
				G.UpdateDateTime	=	GETDATE()		

		WHEN NOT MATCHED THEN
			INSERT VALUES
			(
				@AllotUserID,
				@MenuID,
				@BasicACLC,
				@BasicACLR,
				@BasicACLU,
				@BasicACLD,
				@ExtenedACL,
				@UseYN,
				@UserID,
				GETDATE(),
				@UserID,
				GETDATE()
			);
END











