













/* =============================================================================
프로그램ID	: [UP_FX_SaveUserMenuAuthExtension]
업  무  명	: 사용자별 확장메뉴권한 관리
프로그램명	: 사용자별 확장메뉴권한 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 'SYSTEMCODE','MenuID','GROUPID','20140001|Y,20140002|N,20140003|Y','USERID'
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveUserMenuAuthExtension]
(
	  @MenuID				NVARCHAR(20) 
	, @AllotUserID			NVARCHAR(12)
	, @AuthIds				NVARCHAR(MAX)
	, @UserID				NVARCHAR(20) 
)
AS
BEGIN
	SET NOCOUNT ON;
		
	MERGE dbo.TB_FX_UserMenuAuthExtension	WITH(HOLDLOCK) G
	USING (
		SELECT
			@MenuID			AS	MenuID
		,	@AllotUserID	AS	AllotUserID
		,   LEFT(Element, CHARINDEX('|',Element)-1)AS	AuthID
		,	RIGHT(Element,1)AS	UseYN
		FROM UF_FX_Split(@AuthIds,',')
	) T ON	G.MenuID	=	T.MenuID
		AND	G.UserID	=	T.AllotUserID
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
			T.AllotUserID,
			T.AuthID,
			T.UseYN,
			@UserID,
			GETDATE(),
			@UserID,
			GETDATE()
		);

END















