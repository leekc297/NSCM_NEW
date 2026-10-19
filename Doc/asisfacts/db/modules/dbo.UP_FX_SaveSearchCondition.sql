
/* =============================================================================
프로그램ID	: UP_FX_SaveSearchCondition
업  무  명	: 화면별 검색조건 저장
프로그램명	: 
최초작성일	: 2017.12.04
최종작성일	: 2017.12.04
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 
* 2020-07-07   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 @ControlValue SIZE 변경(255=>4000)
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveSearchCondition]
(
	@GroupID			NVARCHAR(20)
   ,@UserID				NVARCHAR(20)
   ,@MenuID				NVARCHAR(20)
   ,@ControlName		NVARCHAR(255)
   ,@ControlValue		NVARCHAR(4000)
)
AS
BEGIN
	SET NOCOUNT ON;

	MERGE dbo.TB_FX_SearchCondition	WITH(HOLDLOCK)	S
	USING (
		SELECT
			@GroupID		AS	GroupID
			, @UserID		AS	UserID
			, @MenuID		AS	MenuID
			, @ControlName	AS  ControlName
	) T ON	S.GroupID		=	T.GroupID
		AND	S.UserID		=	T.UserID
		AND S.MenuID		=	T.MenuID
		AND S.ControlName	=	T.ControlName
	WHEN MATCHED THEN
		UPDATE 
		SET	S.ControlValue	=	@ControlValue
	WHEN NOT MATCHED THEN
		INSERT 
		(
			GroupID,
			UserID,
			MenuID,
			ControlName,
			ControlValue
		)
		VALUES
		(
			@GroupID,
			@UserID,
			@MenuID,
			@ControlName,
			@ControlValue
		);
END
