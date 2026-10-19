
/*
*===================================================================================================
* Program ID   : UP_FX_ResetSearchCondition
* Description  : 화면별 모든 검색조건 삭제
* Program History
*===================================================================================================
* Date          In Charge       Description
*===================================================================================================
* 2022.05.20	chaan           V1.0    Inititialize
*===================================================================================================
*/
	
CREATE PROCEDURE [dbo].[UP_FX_ResetSearchCondition]
(
      @GroupID			NVARCHAR(20)
    , @UserID			NVARCHAR(20)
    , @MenuID			NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;

    DELETE dbo.TB_FX_SearchCondition WHERE
            GroupID		=	@GroupID
		AND	UserID		=	@UserID
		AND MenuID		=	@MenuID;
END

