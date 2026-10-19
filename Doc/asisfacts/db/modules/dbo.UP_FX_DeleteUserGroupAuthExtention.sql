
/*
 * Program ID   : UP_FX_DeleteUserGroupAuthExtention
 * Description  : Division, Plant, Customer 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/22   SJSHIN			
 * 2018/04/09   ygkim	       권한 요청 테이블 삭제 로직 추가
 */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteUserGroupAuthExtention]
(
	@GroupID		NVARCHAR(20)
	, @UserID		NVARCHAR(20)
	, @AuthType		CHAR(1)	
	, @Code			NVARCHAR(20)
	, @PrntCode		NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN
		DELETE FROM dbo.TB_FX_UserGroupAuthExtention
		WHERE GroupID = @GroupID AND UserID = @UserID AND AuthType = @AuthType AND Code = @Code AND PrntCode = @PrntCode

		--권한 요청 테이블의 정보도 삭제한다.
		DELETE FROM SCM_MST_AUTH_REQUEST
		WHERE GROUP_ID = @GroupID AND USER_ID = @UserID AND DIVISION_ID = @PrntCode AND PLANT_ID = @Code

		IF @AuthType = 'D'
			BEGIN
				DELETE FROM dbo.TB_FX_UserGroupAuthExtention
				WHERE GroupID = @GroupID AND UserID = @UserID AND PrntCode = @Code;

				--권한 요청 테이블의 정보도 삭제한다.
				DELETE FROM SCM_MST_AUTH_REQUEST
				WHERE GROUP_ID = @GroupID
				  AND USER_ID = @UserID
				  AND DIVISION_ID = @Code;
			END

		
	END
END	
