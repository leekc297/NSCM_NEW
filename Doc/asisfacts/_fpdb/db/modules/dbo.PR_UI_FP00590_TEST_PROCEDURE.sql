

/*
 * Program ID   : PR_UI_FP00590_TEST_PROCEDURE
 * Description  : Plan Control Group Release
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/17   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00590_TEST_PROCEDURE]


AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 



	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00590_TEST_PROCEDURE'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''

	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''

	BEGIN TRY
	    BEGIN

			SELECT @rtnCount = 0  -- -1

		END
	END TRY
	BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
		RETURN(-1) --ERROR
	
	END CATCH    

	RETURN(@@ERROR) --성공: 0
END --MAIN END
