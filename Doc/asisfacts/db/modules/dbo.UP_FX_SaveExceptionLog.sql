

/* =============================================================================
프로그램ID	: [UP_FX_SaveExceptionLog]
업  무  명	: 시스템 관리
프로그램명	: 시스템 로그 저장
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
CREATE PROCEDURE [dbo].[UP_FX_SaveExceptionLog]
(
	 @UserID		NVARCHAR(20),
	 @MenuID		NVARCHAR(20),
	 @ExcpCode		INT,
	 @ExceptionType	NVARCHAR(100),
	 @Message		NVARCHAR(250),
	 @MessageDetail	NVARCHAR(1000),
	 @StackTrace	NVARCHAR(MAX)
)
AS
DECLARE @RegtDate NVARCHAR(12)
DECLARE @SeqNo NVARCHAR(4)
BEGIN
	SET NOCOUNT ON;
	SET @RegtDate = CONVERT(NVARCHAR(8), GETDATE(), 112)
	
	SET @SeqNo  = (SELECT 
					ISNULL(MAX(ExcpSeq),0)
					FROM TB_FX_ExceptionLog WITH (NOLOCK)
					WHERE ExcpDate	=	@RegtDate)
	
	SET @SeqNo  = @SeqNo + 1
	SET @SeqNo =  REPLICATE('0',4 - LEN(@SeqNo)) + @SeqNo
	
	
	INSERT INTO dbo.TB_FX_ExceptionLog
	(
		 ExcpDate
		,ExcpSeq
		,UserID
		,MenuID
		,ExceptionType
		,ExcpCode
		,Message
		,MessageDetail
		,StackTrace
		,LocalTimeStamp
	)
	 VALUES
	 (           
		 @RegtDate
		,@SeqNo
		,@UserID
		,@MenuID
		,@ExceptionType
		,@ExcpCode
		,@Message
		,@MessageDetail
		,@StackTrace
		,GETDATE()
	)
END

