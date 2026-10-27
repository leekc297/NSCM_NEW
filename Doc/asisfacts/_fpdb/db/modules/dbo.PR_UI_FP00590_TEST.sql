

/*
 * Program ID   : PR_UI_FP00590_TEST
 * Description  : Plan Control Group Release
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/17   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00590_TEST]
  @p_sys_flag             NVARCHAR(MAX)


AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00590_TEST'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''

	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''

	SET @v_sys_flag          = ''



    /************************************************************************************************/
	/* EXECUTE_RETRUN_TEST                        */
	/************************************************************************************************/
    IF(@p_sys_flag ='EXECUTE_RETRUN_TEST')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
			--Log
			SELECT @v_dSql = 'EXEC [dbo].[PR_UI_FP00590_TEST_PROCEDURE] '

			BEGIN TRY
		        BEGIN

					--실제수행
			        EXEC @rtnCount = [dbo].[PR_UI_FP00590_TEST_PROCEDURE]

		    	    SELECT 'Result' = @rtnCount 
		    	END
		    END TRY
		    BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                          
		    	SET @v_log_message = ERROR_MESSAGE()
		    	SELECT 'Result' = @@ERROR 
		    
		    END CATCH    
		END

END --MAIN END

