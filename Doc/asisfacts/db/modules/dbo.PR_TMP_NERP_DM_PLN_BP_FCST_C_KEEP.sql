



-- =============================================
-- Author:		 P.C.I
-- Create date:  2024-04-26
-- Description:	 DM_PLN_BP_FCST_C_KEEP Incoterms Conversion - Incoterms key 값 아님 
-- =============================================
CREATE PROCEDURE [dbo].[PR_TMP_NERP_DM_PLN_BP_FCST_C_KEEP]

AS

BEGIN 

	BEGIN TRY
	--------------------------------------------------------------------------------------------


	SET NOCOUNT ON;

	DECLARE @UPDATE_START_TIME   DATETIME = SYSDATETIME();
	DECLARE @UPDATE_END_TIME     DATETIME ;
	
	
	UPDATE  ZNERP_XLS_CHANGE_MASTER_CODE_DM  
	SET UPDATE_START_TIME = @UPDATE_START_TIME, 
	UPDATE_CNT = 0
	WHERE PROCESS_TYPE = 'DM_PLN_BP_FCST_C_KEEP'
	;
	
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_DM_PLN_BP_FCST_C_KEEP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		/*
	print 'PR_TMP_NERP_DM_PLN_BP_FCST_C_KEEP'
	
	
	IF OBJECT_ID (N'DBO.BACKUP_DM_PLN_BP_FCST_C_KEEP', N'U') IS NULL 	

		select * 
		into   DBO.BACKUP_DM_PLN_BP_FCST_C_KEEP 			
		from   DBO.DM_PLN_BP_FCST_C_KEEP 
		where  1=2;
			*/
	DECLARE @versionNo VARCHAR(100);
	--DECLARE @oldIncoterms VARCHAR(10), @dom_exp VARCHAR(10), @newIncoterms VARCHAR(10) ;
	--DECLARE @newCode VARCHAR(50);
	--DECLARE @count int, @checkCode varchar(50);
	
	DECLARE cursorVersion CURSOR FOR
	
		SELECT DISTINCT VERSION_NO
		FROM   DM_MST_VERSION WITH(NOLOCK)
		WHERE  VERSION_TYPE = 'BP_M'
		AND    YYYYMMDD < '20240101'
		ORDER BY VERSION_NO DESC
		
	OPEN cursorVersion;
	FETCH NEXT FROM cursorVersion INTO  @versionNo ;
	

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--------------------------------------------------------------------------------------------	
		BEGIN TRANSACTION;
		--------------------------------------------------------------------------------------------	
	/*
		-- Version 별 백업
		INSERT INTO DBO.BACKUP_DM_PLN_BP_FCST_C_KEEP
		SELECT *
		FROM   DM_PLN_BP_FCST_C_KEEP
		WHERE  VERSION_NO = @versionNo;
		*/
		-- STEP
		SET @v_log_type = 'STEP';
		SET @v_log_message = '';
		SET @n_log_count = 0;
		SET @v_description = 'VERSION_NO : ' + @versionNo + N'/PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM_BIG에서 Incoterms 처리';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- Version 별 Incoterms 외 Converion 수행
		EXEC PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM_BIG @p_table_name = N'DM_PLN_BP_FCST_C_KEEP', @p_version_no = @versionNo
		
		--------------------------------------------------------------------------------------------	
		COMMIT;
		--------------------------------------------------------------------------------------------	
		PRINT 'Transaction succeed!';

		FETCH NEXT FROM cursorVersion INTO  @versionNo ;
	END

	CLOSE cursorVersion;
	DEALLOCATE cursorVersion;
		
		/*
	-- BACKUP_FLAG 변경
	UPDATE  ZNERP_TARGET_INFO_DM  
	SET BACKUP_FLAG = 'N'
	  , MODIFY_USER_ID = 'PR_TMP_NERP_DM_PLN_BP_FCST_C_KEEP'
	  , MODIFY_DATE = getDate()
	WHERE TABLE_NAME = 'DM_PLN_BP_FCST_C_KEEP'
	AND BIG_CONVERSION_FLAG = 'N'
	;*/
	
	SET @UPDATE_END_TIME = SYSDATETIME();
		
	UPDATE  ZNERP_XLS_CHANGE_MASTER_CODE_DM  
	SET UPDATE_END_TIME = @UPDATE_END_TIME
	WHERE PROCESS_TYPE = 'DM_PLN_BP_FCST_C_KEEP'
	;
	

	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @n_log_count = 0;
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	
	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		ROLLBACK;
		PRINT 'Transaction is cancels cause of error';
		
		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @n_log_count = 0;
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	 

		
		DECLARE @fileCursorStatus INT;

		SET @fileCursorStatus = CURSOR_STATUS('GLOBAL', 'cursorVersion');
 
		IF (@fileCursorStatus >= 0)
		BEGIN
			PRINT 'Closing fileCursor cursorVersion';
			CLOSE cursorVersion;
			DEALLOCATE cursorVersion;
		END


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

END
