









/* =============================================================================
프로그램ID	: [UP_FX_SaveGroupMenuAuth]
업  무  명	: 그룹별 메뉴권한 관리
프로그램명	: 그룹별 메뉴권한 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveGroupMenuAuth]
(
	  @MenuID				NVARCHAR(20) 
	, @GroupID				NVARCHAR(20)
	, @BasicACLC			BIT
	, @BasicACLR			BIT 
	, @BasicACLU			BIT
	, @BasicACLD			BIT 
	, @ExtendedACL			INT 
	, @UseYN				NCHAR(1) 
	, @RegtUserID				NVARCHAR(30) 
)
AS
BEGIN
	SET NOCOUNT ON;
	MERGE dbo.TB_FX_GroupMenuAuth	WITH(HOLDLOCK) G
		USING (
			SELECT
				@MenuID		AS	MenuID
			,	@GroupID	AS	GroupID
		) T ON	G.MenuID	=	T.MenuID
			AND	G.GroupID	=	T.GroupID
		WHEN MATCHED THEN
			UPDATE 
			SET	G.BasicACLC		=	@BasicACLC,
				G.BasicACLR		=	@BasicACLR,
				G.BasicACLU		=	@BasicACLU,
				G.BasicACLD		=	@BasicACLD,
				G.ExtendedACL	=	@ExtendedACL,
				G.UseYN			=	@UseYN,
				G.UpdateUserID	=	@RegtUserID,
				G.UpdateDateTime	=	GETDATE()		

		WHEN NOT MATCHED THEN
			INSERT 
			(
				MenuID,
				GroupID,
				BasicACLC,
				BasicACLR,
				BasicACLU,
				BasicACLD,
				ExtendedACL,
				UseYN,
				RegtUserID,
				RegtDateTime,
				UpdateUserID,
				UpdateDateTime
			)			
			VALUES
			(
				@MenuID,
				@GroupID,
				@BasicACLC,
				@BasicACLR,
				@BasicACLU,
				@BasicACLD,
				@ExtendedACL,
				@UseYN,
				@RegtUserID,
				GETDATE(),
				@RegtUserID,
				GETDATE()
			);
END











