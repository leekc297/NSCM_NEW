

/* =============================================================================
프로그램ID	: UP_FX_SaveUserGroupAuthExtention
업  무  명	: 시스템관리 - 그룹-사용자 목록
프로그램명	: Division, Plant, Customer 저장
최초작성일	: 2017.11.22
최종작성일	: 2017.11.22
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_SaveUserGroupAuthExtention]
(
	@GroupID		NVARCHAR(20)
	, @UserID		NVARCHAR(20)
	, @AuthType		CHAR(1)
	, @Code			NVARCHAR(20)
	, @PrntCode		NVARCHAR(20)
	, @RegtUserID			NVARCHAR(30) 
    , @JV_PLANT_ID			NVARCHAR(1000) = ''
)
AS
BEGIN
	SET NOCOUNT ON;

    IF @AuthType = 'J'  -- 21.06.21  JV 프로시저 추가
        MERGE dbo.TB_FX_UserGroupAuthExtention	WITH(HOLDLOCK) G
        USING 
        (
            SELECT
                @GroupID	AS	GroupID
                , @UserID	AS	UserID
                , @AuthType	AS	AuthType
                , @Code		AS	Code
                , @PrntCode	AS	PrntCode
        ) T ON	G.GroupID =	T.GroupID
                AND G.UserID = T.UserID
                AND G.AuthType = T.AuthType
                AND G.Code = T.Code
                AND G.PrntCode = T.PrntCode
        WHEN MATCHED THEN
            UPDATE 
            SET
                G.UpdateUserID = @RegtUserID,
                G.UpdateDateTime = GETDATE(),
                G.JV_PLANT_ID = @JV_PLANT_ID

        WHEN NOT MATCHED THEN
            INSERT 
            (
                GroupID,
                UserID,
                AuthType,
                Code,
                PrntCode,
                RegtUserID,
                RegtDateTime,
                UpdateUserID,
                UpdateDateTime,
                JV_PLANT_ID
            )
            VALUES
            (
                @GroupID,
                @UserID,
                @AuthType,
                @Code,
                @PrntCode,
                @RegtUserID,
                GETDATE(),
                @RegtUserID,
                GETDATE(),
                @JV_PLANT_ID
            );

    ELSE
        MERGE dbo.TB_FX_UserGroupAuthExtention	WITH(HOLDLOCK) G
        USING 
        (
            SELECT
                @GroupID	AS	GroupID
                , @UserID	AS	UserID
                , @AuthType	AS	AuthType
                , @Code		AS	Code
                , @PrntCode	AS	PrntCode
        ) T ON	G.GroupID =	T.GroupID
                AND G.UserID = T.UserID
                AND G.AuthType = T.AuthType
                AND G.Code = T.Code
                AND G.PrntCode = T.PrntCode

        WHEN MATCHED THEN
            UPDATE 
            SET
                G.UpdateUserID = @RegtUserID,
                G.UpdateDateTime = GETDATE(),
				 G.JV_PLANT_ID = @JV_PLANT_ID

        WHEN NOT MATCHED THEN
            INSERT 
            (
                GroupID,
                UserID,
                AuthType,
                Code,
                PrntCode,
                RegtUserID,
                RegtDateTime,
                UpdateUserID,
                UpdateDateTime,
				JV_PLANT_ID
            )
            VALUES
            (
                @GroupID,
                @UserID,
                @AuthType,
                @Code,
                @PrntCode,
                @RegtUserID,
                GETDATE(),
                @RegtUserID,
                GETDATE(),
				@JV_PLANT_ID
            );



END
