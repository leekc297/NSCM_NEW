

/* =============================================================================
프로그램ID	: [UP_FX_SaveUserInfo]
업  무  명	: 사용자 관리
프로그램명	: 사용자 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SavePersonalSetting]
(
	  @UserID				NVARCHAR(20)
	, @Language				NVARCHAR(100)
	, @DefaultGroupID		NVARCHAR(20)
	, @TimeZone				NVARCHAR(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN

		UPDATE dbo.TB_FX_User
		SET
			Language			=	@Language
			, DefaultGroupID	= @DefaultGroupID
			, TimeZone			=	@TimeZone
		WHERE
			UserID = @UserID;
	
	END

	
END












