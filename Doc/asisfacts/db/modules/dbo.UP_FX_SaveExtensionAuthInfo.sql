








/* =============================================================================
프로그램ID	: [UP_FX_SaveExtensionAuthInfo]
업  무  명	: 확장권한 관리
프로그램명	: 확장권한 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveExtensionAuthInfo]
(
	  @AuthID				NVARCHAR(20)
	, @Description			NVARCHAR(50) 
	, @UseYN				NCHAR(1) 
	, @UserID				NVARCHAR(20) 
)
AS
BEGIN
	MERGE dbo.TB_FX_ExtenstionAuthInfo	WITH(HOLDLOCK) E
		USING (
			SELECT
				@AuthID		AS	AuthID
		) T ON	E.AuthID	=	T.AuthID
		WHEN MATCHED THEN
			UPDATE 
			SET	E.AuthID		=	@AuthID,
				E.Description	=	@Description,
				G.UseYN			=	@UseYN,
				G.UpdateUserID	=	@UserID,
				G.UpdateDateTime	=	GETDATE()		

		WHEN NOT MATCHED THEN
			INSERT VALUES
			(
				@AuthID,
				@Description,
				@UseYN,			
				@UseYN,
				@UserID,
				GETDATE(),
				@UserID,
				GETDATE()
			);
END










