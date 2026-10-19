










/* =============================================================================
프로그램ID	: [UP_FX_SaveGroupInfo]
업  무  명	: 그룹 관리
프로그램명	: 그룹 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveGroupInfo]
(
	  @GroupID				NVARCHAR(20)
	, @GrpName				NVARCHAR(50)
	, @UseYN				NCHAR(1) 
	, @RegtUserID			NVARCHAR(30) 
)
AS
BEGIN
	SET NOCOUNT ON;
	MERGE dbo.TB_FX_GroupInfo	WITH(HOLDLOCK) G
	USING (
		SELECT
			@GroupID	AS	GroupID
	) T ON	G.GroupID	=	T.GroupID
	WHEN MATCHED THEN
		UPDATE 
		SET	G.GrpName		=	@GrpName,
			G.UseYN			=	@UseYN,
			G.UpdateUserID	=	@RegtUserID,
			G.UpdateDateTime	=	GETDATE()		

	WHEN NOT MATCHED THEN
		INSERT VALUES
		(
			@GroupID,
			@GrpName,
			@UseYN,
			@RegtUserID,
			GETDATE(),
			@RegtUserID,
			GETDATE()
		);
END












