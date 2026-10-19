











/* =============================================================================
프로그램ID	: [UP_FX_SaveGroupMenuAuthExtension]
업  무  명	: 그룹별 확장메뉴권한 관리
프로그램명	: 그룹별 확장메뉴권한 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 'SYSTEMCODE','MenuID','GROUPID','20140001|Y,20140002|N,20140003|Y','USERID'
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveGroupMenuAuthExtension]
(
	  @MenuID				NVARCHAR(20) 
	, @GroupID				NVARCHAR(20)
	, @AuthIds				NVARCHAR(MAX)
	, @UserID				NVARCHAR(20) 
)
AS
BEGIN
	SET NOCOUNT ON;	
	MERGE dbo.TB_FX_GroupMenuAuthExtension	WITH(HOLDLOCK) G
	USING (
		SELECT
			@MenuID		AS	MenuID
		,	@GroupID	AS	GroupID
		,   LEFT(Element, CHARINDEX('|',Element)-1)AS	AuthID
		,	RIGHT(Element,1)AS	UseYN
		FROM UF_FX_Split(@AuthIds,',')
	) T ON	G.MenuID	=	T.MenuID
		AND	G.GroupID	=	T.GroupID
		AND	G.AuthID	=	T.AuthID
	WHEN MATCHED THEN
		UPDATE 
		SET	G.UseYN				=	T.UseYN,
			G.UpdateUserID		=	@UserID,
			G.UpdateDateTime	=	GETDATE()		
	
	WHEN NOT MATCHED THEN
		INSERT VALUES
		(
			T.MenuID,
			T.GroupID,
			T.AuthID,
			T.UseYN,
			@UserID,
			GETDATE(),
			@UserID,
			GETDATE()
		);

END













