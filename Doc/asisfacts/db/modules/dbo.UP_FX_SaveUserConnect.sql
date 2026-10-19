
/* =============================================================================
프로그램ID	: [UP_FX_SaveUserConnect]
업  무  명	: 사용자통계 관리
프로그램명	: 사용자접속 통계 등록
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveUserConnect]
(
	  @UserID		NVARCHAR(20)
	, @CnntCode		NCHAR(7)	
	, @SN			NVARCHAR(50)
	, @PushKey		NVARCHAR(255)
	, @CnntIP		NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @CnntDate	NVARCHAR(8);
	SET @CnntDate = CONVERT(NVARCHAR(8), GETDATE(),112);
	
	BEGIN		
		MERGE dbo.TB_FX_UserConnect	WITH(HOLDLOCK)	AS	U
		USING (	
			SELECT	
				@UserID		AS	UserID
		)  T ON U.UserID	=	T.UserID
		WHEN MATCHED THEN
			UPDATE	SET
				 LogInTIme		=	(CASE WHEN @CnntCode = '0103001' THEN GETDATE() ELSE U.LogInTime END)  
				,LogOutTime		=	(CASE WHEN @CnntCode = '0103001' THEN NULL ELSE GETDATE() END)  
				,CnntCode		=	@CnntCode
				,SN				=	@SN
				,PushKey		=	@PushKey
		WHEN NOT MATCHED THEN
			INSERT VALUES
			(
				@UserID
				,GETDATE()
				,NULL
				,@CnntCode			
				,@SN
				,@PushKey
			);
	END
	

	BEGIN
		-- HH:MM:SS:mmm 형식의 시간
		DECLARE	@CnntDateTime	NVARCHAR(20);
		SET @CnntDateTime	= CONVERT(NVARCHAR(30), GETDATE(),112) + REPLACE(CONVERT(NVARCHAR(30), GETDATE(),114),':','')
		INSERT INTO dbo.TB_FX_UserConnectLog
		(
			 UserID
			,CnntDateTime
			,CnntCode
			,CnntIP
		)
		VALUES
		(
			 @UserID
			,@CnntDateTime
			,@CnntCode
			,@CnntIP
		);
	END

END













