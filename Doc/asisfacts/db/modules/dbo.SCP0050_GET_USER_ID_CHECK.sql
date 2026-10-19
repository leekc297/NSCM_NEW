
/*
 * Program ID   : SCP0050_MDMAuthManagement
 * Description  : UserID Check
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/30   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성

 ex) 
 */

CREATE PROCEDURE [dbo].[SCP0050_GET_USER_ID_CHECK]
	 @p_user_id			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT USER_ID
	FROM SCM_MST_SSO_USER_INFO
	WHERE USER_ID IN  ( SELECT token FROM dbo.String_Split(@p_user_id,'^') )
END
