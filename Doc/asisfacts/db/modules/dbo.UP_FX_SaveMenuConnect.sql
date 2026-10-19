
/* =============================================================================
프로그램ID	: [UP_FX_SaveMenuConnect]
업  무  명	: 메뉴통계 관리
프로그램명	: 메뉴접속 통계 등록
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveMenuConnect]
(
	  @MenuID		NVARCHAR(255)
	, @CnntCode		NCHAR(7)	
	, @UserID		NVARCHAR(20) 
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @CnntDate	NVARCHAR(8);
	SET @CnntDate = CONVERT(NVARCHAR(8), GETDATE(),112);
	
	IF @CnntCode = '0104001'	
		BEGIN
			-- 오픈인경우에만
			MERGE dbo.TB_FX_MenuConnect	WITH(HOLDLOCK)	AS	S
			USING (	
				SELECT	
					@MenuID		AS	MenuID, 
					@UserID		AS	UserID, 
					@CnntDate	AS	CnntDate
			)  T ON S.MenuID	=	T.MenuID
				AND S.UserID	=	T.UserID
				AND S.CnntDate	=	T.CnntDate	
			WHEN MATCHED THEN
				UPDATE	SET
					 ViewCnt			=	S.ViewCnt + 1	
					,LocalTimeStamp		=	GETDATE()
			WHEN NOT MATCHED THEN
				INSERT VALUES
				(
					@MenuID
					,@UserID
					,@CnntDate
					,1			
					,GETDATE()
				);
		END
	

	BEGIN
		-- HH:MM:SS:mmm 형식의 시간
		DECLARE	@CnntTime	NVARCHAR(12);
		SET @CnntTime	= Replace(Convert(NVARCHAR(12),Getdate(),114),':','')
		INSERT INTO dbo.TB_FX_MenuConnectLog
		(
			 MenuID
			,UserID
			,CnntDate
			,CnntTime
			,CnntCode
			,LocalTimeStamp
		)
		VALUES
		(
			 @MenuID
			,@UserID
			,@CnntDate
			,@CnntTime
			,@CnntCode
			,GETDATE()
		);
	END

END











