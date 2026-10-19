
/*
 * Program ID   : UP_FX_DeleteUserGroupInfo
 * Description  : 그룹별 사용자 관리 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/02/27   이정석			
 * 2018/04/09   ygkim	       권한 요청 테이블 삭제 로직 추가
 * 2018/04/11   ygkim		   Guest 그룹 권한만 남고 나머지 권한 삭제될 경우 User 테이블 DefaultGroupID 'Guest'로 넣어준다.
 */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteUserGroupInfo]
(
	  @GroupID				NVARCHAR(20)
	, @UserID				NVARCHAR(MAX)
)
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE @v_group_id NVARCHAR(20)
	DECLARE @v_cnt      INT

	DELETE FROM dbo.TB_FX_UserGroupInfo
	WHERE GroupID	=	@GroupID
	AND UserID = @UserID;

	DELETE FROM dbo.TB_FX_UserGroupAuthExtention
	WHERE GroupID = @GroupID AND UserID = @UserID

	--권한 요청 테이블의 정보도 삭제한다.
	DELETE FROM dbo.SCM_MST_AUTH_REQUEST
	WHERE GROUP_ID = @GroupID
	  AND USER_ID = @UserID

	SELECT @v_group_id = GROUPID, @v_cnt = COUNT(*) OVER()
	FROM TB_FX_USERGROUPINFO
	WHERE USERID = @UserID
	GROUP BY GROUPID

	--Guest 권한만 남기고 권한이 삭제될 경우
	--User 테이블 DefaultGroupID에 Guest로 변경해준다.
	IF @v_cnt = 1 
		BEGIN
			IF @v_group_id = 'Guest'
				BEGIN
					UPDATE TB_FX_User
					   SET DefaultGroupID = 'Guest'
					WHERE UserID = @UserID
				END
		END
END











