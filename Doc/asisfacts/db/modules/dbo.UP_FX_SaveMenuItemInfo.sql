

/* =============================================================================
프로그램ID	: [UP_FX_SaveMenuInfo]
업  무  명	: 그룹 관리
프로그램명	: 그룹 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= 
  Date			In Charge		Description
=============================================================================
  2024/12/12	jahn1502		컬럼 추가로 인한 저장 로직 수정

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveMenuItemInfo]
(
	@MenuID			NVARCHAR(20)
   ,@ProgramID		NVARCHAR(20)
   ,@PrntMenuID		NVARCHAR(20)
   ,@Title			NVARCHAR(250)
   ,@Description	NVARCHAR(250)
   ,@Parameter		NVARCHAR(250)
   ,@SortOrder		SMALLINT
   ,@MenuLevel		SMALLINT 
   ,@IconName		NVARCHAR(250)
   ,@Icon			VARBINARY(MAX)  
   ,@UseYN			NCHAR(1)
   ,@RegtUserID		NVARCHAR(30) 
   ,@Attribute1		NVARCHAR(MAX)	--Requestor
   ,@Attribute2		NVARCHAR(MAX)	--DeptName1
   ,@Attribute3		NVARCHAR(MAX)	--PlOwner
   ,@Attribute4		NVARCHAR(MAX)	--DeptName2
   ,@Attribute5		NVARCHAR(MAX)	--OpennedDate
   ,@Attribute6		NVARCHAR(MAX)	--Remarks1
   ,@Attribute7		NVARCHAR(MAX)	--ClosedDate
   ,@Attribute8		NVARCHAR(MAX)	--Remakrs2
           
)
AS
BEGIN
	SET NOCOUNT ON;

	IF @IconName != '' AND @icon IS NULL
		
		BEGIN
			SELECT @IconName = IconName, @Icon = Icon FROM dbo.TB_FX_MenuItemInfo WHERE MenuID = @MenuID;
		END

	BEGIN

		MERGE dbo.TB_FX_MenuItemInfo	WITH(HOLDLOCK) M
		USING (
			SELECT
				@MenuID		AS	MenuID
		) T ON	M.MenuID	=	T.MenuID
		WHEN MATCHED THEN
			UPDATE 
			SET	M.ProgramID		=	@ProgramID,
				M.PrntMenuID	=	@PrntMenuID,
				M.Title			=	@Title,
				M.Description	=	@Description,
				M.Parameter		=	@Parameter,
				M.SortOrder		=	@SortOrder,
				M.MenuLevel		=	@MenuLevel,
				M.IconName		=	@IconName,
				M.Icon			=	@Icon,
				M.UseYN			=	@UseYN,

				M.Attribute1	=   @Attribute1,
				M.Attribute2	=   @Attribute2,
				M.Attribute3	=   @Attribute3,
				M.Attribute4	=   @Attribute4,
				M.Attribute5	=   @Attribute5,
				M.Attribute6	=   @Attribute6,
				M.Attribute7	=   @Attribute7,
				M.Attribute8	=   @Attribute8,


				M.UpdateUserID	=	@RegtUserID,
				M.UpdateDateTime	=	GETDATE()	

		WHEN NOT MATCHED THEN
			INSERT 
			(
		        MenuID,
		        ProgramID,
		        PrntMenuID,
		        Title,
				Description,
		        Parameter,
		        SortOrder,
		        MenuLevel,
				MenuAction,
				IconName,
				Icon,
				Expanded,
				MenuVisible,
		        UseYN,

				Attribute1,
				Attribute2,
				Attribute3,
				Attribute4,
				Attribute5,
				Attribute6,
				Attribute7,
				Attribute8,

		       	RegtUserID,
				RegtDateTime,
				UpdateUserID,
				UpdateDateTime
			)
			VALUES
			(
		        @MenuID,
		        @ProgramID,
		        @PrntMenuID,
		        @Title,
				@Description,
		        @Parameter,
		        @SortOrder,
		        @MenuLevel,
				0,
				@IconName,
				@Icon,
				0,
				1,
		        @UseYN,

				@Attribute1,
				@Attribute2,
				@Attribute3,
				@Attribute4,
				@Attribute5,
				@Attribute6,
				@Attribute7,
				@Attribute8,

		       	@RegtUserID,
				GETDATE(),
				@RegtUserID,
				GETDATE()
			);  
	END
END


















