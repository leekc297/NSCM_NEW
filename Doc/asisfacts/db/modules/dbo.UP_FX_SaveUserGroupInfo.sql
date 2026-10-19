













/* =============================================================================
프로그램ID	: [UP_FX_SaveUserGroupInfo]
업  무  명	: 그룹별 사용자 관리
프로그램명	: 그룹별 사용자관리 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 'SYSTEMCODE','GROUPID',''20140001|Y,20140002|N,20140003|Y','USERID'
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveUserGroupInfo]
(
	 @GroupID				NVARCHAR(20)
	, @UserID				NVARCHAR(20)
	, @UseYN				NCHAR(1) 
	, @RegtUserID			NVARCHAR(30)  
)
AS
BEGIN	
	SET NOCOUNT ON;
	MERGE dbo.TB_FX_UserGroupInfo	WITH(HOLDLOCK) G
	USING (
		SELECT
			@GroupID AS GroupID,
			@UserID	 AS UserID
			
		) T ON	G.GroupID	=	T.GroupID
			AND G.UserID	=	T.UserID
	WHEN MATCHED THEN
		UPDATE 
		SET	G.UseYN			=	@UseYN,
			G.UpdateUserID	=	@RegtUserID,
			G.UpdateDateTime	=	GETDATE()			

		WHEN NOT MATCHED THEN
			INSERT
			(
				GroupID,
				UserID,
				UseYN,
				RegtUserID,
				RegtDateTime,
				UpdateUserID,
				UpdateDateTime
			)
			VALUES
			(
				T.GroupID,
				T.UserID,
				@UseYN,
				@UserID,
				GETDATE(),
				@UserID,
				GETDATE()
			);

END














