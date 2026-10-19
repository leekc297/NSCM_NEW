/*
 * Program ID   : FN_GET_USER_ID
 * Description  : Session 정보로 연결된 Host 정보를 찾고 이를 통해 User Id를 찾아봄.
 * Program History
 *===================================================================================================
 *  Date            In Charge           Description
 *===================================================================================================
 *  2025.03.19      Philsu Park         Initial Release
 *                                                                                                  
*/

CREATE FUNCTION [dbo].[FN_GET_USER_ID]
()
RETURNS NVARCHAR(100)
AS    
BEGIN
    DECLARE @v_user_id         NVARCHAR(100);
		
	BEGIN
        SELECT  @v_user_id = ISNULL(MAX(USR.USERID), '')
        FROM    TB_FX_USERCONNECT UC
        INNER JOIN TB_FX_USER USR
            ON  UC.USERID   = USR.USERID
        INNER JOIN SYS.DM_EXEC_SESSIONS S
            ON  UC.SN       = S.HOST_NAME
        WHERE   S.SESSION_ID    = @@SPID
        ;
    END

    IF ISNULL(@v_user_id, '') = ''
        BEGIN
            SELECT  @v_user_id = s.host_name
            FROM    SYS.dm_exec_sessions S
            WHERE   s.session_id = @@SPID
        END
	
    ----------------------------------------------------------------------------
    RETURN (@v_user_id);
    ----------------------------------------------------------------------------   
	
END;
