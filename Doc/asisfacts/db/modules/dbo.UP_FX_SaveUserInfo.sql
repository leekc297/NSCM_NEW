

/* =============================================================================
프로그램ID	: [UP_FX_SaveUserInfo]
업  무  명	: 사용자 관리
프로그램명	: 사용자 등록/수정
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= 
  Date			In Charge		Description
=============================================================================
  2019/01/09	hwyoon			사용자 신규 입력 시 XLS PWD 설정
  2020/02/04    khh79           장기 미사용자 관리를 위한 PermanentYN 추가('Y' 면 미접속 상용자 등록 제외)
  2026/05/11	강주용			[E20260507-000899] 사용자 영문명 누락시 SSO USER 영문명으로 대체 입력
*/
	
CREATE PROCEDURE [dbo].[UP_FX_SaveUserInfo]
(
	  @UserID				NVARCHAR(20)
	, @UserName				NVARCHAR(20)
	, @UserName_E			NVARCHAR(150)
	, @Email				NVARCHAR(150) 
	, @Dept_ID				NVARCHAR(50)
	, @OfficePhoneNum		NVARCHAR(30)
	, @CellPhoneNum			NVARCHAR(30)
	, @Language				NVARCHAR(100)
	, @DefaultGroupID		NVARCHAR(20)
	, @TimeZone				NVARCHAR(100)
	, @PermanentYN          NCHAR(1)
	, @UseYN				NCHAR(1)
	, @RegtUserID			NVARCHAR(12)
	, @Attribute1			NVARCHAR(150)
	, @Attribute2			NVARCHAR(150)
	, @Attribute3			NVARCHAR(150)
	, @Attribute4			NVARCHAR(150)
	, @Attribute5			NVARCHAR(150)
	, @Attribute6			NVARCHAR(150)
	, @Attribute7			NVARCHAR(150)
	, @Attribute8			NVARCHAR(150)
	, @Attribute9			NVARCHAR(150)
	, @Attribute10			NVARCHAR(150)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN
		
		DECLARE @v_user_cnt		INT=0;
		DECLARE @v_xls_passwd	VARCHAR(100) = 'lgchem2019';

		SELECT @v_user_cnt = count(UserID)
		FROM dbo.TB_FX_User
		WHERE UserID=@UserID;


		--MERGE dbo.TB_FX_User	WITH(HOLDLOCK)	U
		--	USING (
		--		SELECT
		--			@UserID		AS	UserID
		--	) T ON	U.UserID	=	T.UserID
		--	WHEN MATCHED THEN
		--		UPDATE 
		--		SET	Email = @Email;

	
		MERGE dbo.TB_FX_User	WITH(HOLDLOCK)	U
			USING (
				SELECT
					@UserID		AS	UserID
			) T ON	U.UserID	=	T.UserID
			WHEN MATCHED THEN
				UPDATE 
				SET	
					U.Email			=	@Email,
					U.Dept_ID		=	@Dept_ID,
					U.OfficePhoneNum	=	@OfficePhoneNum,
					U.CellPhoneNum		=	@CellPhoneNum,
					U.Language			=	@Language,
					U.DefaultGroupID	=	@DefaultGroupID,
					U.TimeZone			=	@TimeZone,
					U.PermanentYN       =   @PermanentYN,
					U.UseYN				=	@UseYN,
					U.UpdateUserID		=	@RegtUserID,
					U.UpdateDateTime	=	GETDATE(),
					U.Attribute1		=	@Attribute1,
					U.Attribute2		=	@Attribute2,
					U.Attribute3		=	@Attribute3,
					U.Attribute4		=	@Attribute4,
					U.Attribute5		=	@Attribute5,
					U.Attribute6		=	@Attribute6,
					U.Attribute7		=	@Attribute7,
					U.Attribute8		=	@Attribute8,
					U.Attribute9		=	@Attribute9,
					U.Attribute10		=	@Attribute10

			WHEN NOT MATCHED THEN
				INSERT 
				(
					UserID,
					UserName,
					UserName_E,
					Email,
					Dept_ID,
					OfficePhoneNum,
					CellPhoneNum,					
					Language,
					DefaultGroupID,
					TimeZone,
					LastLoginDateTime,
					PermanentYN,
					UseYN,
					RegtUserID,
					RegtDateTime,
					UpdateUserID,
					UpdateDateTime,
					Attribute1,
					Attribute2,
					Attribute3,
					Attribute4,
					Attribute5,
					Attribute6,
					Attribute7,
					Attribute8,
					Attribute9,
					Attribute10
				)
				VALUES
				(
					@UserID,
					@UserName,
					-- START [E20260507-000899] 사용자 영문명 누락시 SSO USER 영문명으로 대체 입력
					--@UserName_E, --원본
					IIF(TRIM(ISNULL(@UserName_E, '')) = '', ISNULL((SELECT TOP 1 
					                                                 IIF(TRIM(ISNULL(USER_NAME_EN, '')) = '', USER_NAME, USER_NAME_EN) AS USER_NAME_EN
														        FROM SCM_MST_SSO_USER_INFO WITH(NOLOCK) 
														       WHERE USER_ID = @UserID)
															 , @UserName)
													, @UserName_E),
					-- END [E20260507-000899] 사용자 영문명 누락시 SSO USER 영문명으로 대체 입력
					@Email,
					@Dept_ID,
					@OfficePhoneNum,
					@CellPhoneNum,					
					@Language,
					@DefaultGroupID,
					@TimeZone,
					GETDATE(),
					@PermanentYN,
					@UseYN,
					@RegtUserID,
					GETDATE(),
					@RegtUserID,
					GETDATE(),
					@Attribute1,
					@Attribute2,
					@Attribute3,
					@Attribute4,
					@Attribute5,
					@Attribute6,
					@Attribute7,
					@Attribute8,
					@Attribute9,
					@Attribute10
				);

		/* Default Group 설정에 따른 Group-User 추가 변경 */
		EXEC	[dbo].[UP_FX_SaveUserGroupInfo]
				@GroupID = @DefaultGroupID,
				@UserID = @UserID,
				@UseYN = 'Y',
				@RegtUserID = @RegtUserID;

		/* XLS 시뮬레이션용 패스워드 신규설정 */
		IF(@v_user_cnt=0)
		BEGIN
			OPEN SYMMETRIC KEY XLS_SECKEY01
				DECRYPTION BY PASSWORD ='Pa$$w0rdPa$$w0rd'
			;

			UPDATE DBO.TB_FX_User
			SET XLS_PASSWD = ENCRYPTBYKEY(KEY_GUID('XLS_SECKEY01'),@v_xls_passwd),
				XLS_PASSWD_CHANGE_DATE = GETDATE()
			WHERE 1=1
				AND USERID = @UserID;

		END;


	END

	
END
