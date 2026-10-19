create PROCEDURE [dbo].[s]
(
  @p_param1 NVARCHAR(300)=NULL,
  @p_param2 NVARCHAR(300)=NULL,
  @p_param3 NVARCHAR(300)=NULL,
  @p_param4 NVARCHAR(300)=NULL
 )
AS
/*
 * Program ID   : PR_SCM_SYS_RFC_CALL_NERP
 * Description  : .EXE 파일 실행을 위한 프로시져 NERP
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.12.29   VADABI5			Initial Release nerp) PR_SCM_SYS_RFC_CALL_NERP 참조
 */
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;


	
    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_SYS_RFC_CALL_NERP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
	DECLARE @v_ReturnCode  NVARCHAR(500);
	DECLARE @v_command	  NVARCHAR(1000);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30);
	DECLARE @v_count       INT;
	DECLARE @v_yesterday     NVARCHAR(30);
	DECLARE @n_history_seq	BIGINT;

    -- 파라미터 처리용 변수 설정
	DECLARE @v_param1     NVARCHAR(300);
	DECLARE @v_param2     NVARCHAR(300);
	DECLARE @v_param3     NVARCHAR(300);
	DECLARE @v_param4     NVARCHAR(300);
	
	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY

	-- 2018.09.27
	IF @p_param1 = 'XIF_ERP_INTRANSIT_CO_R' AND @p_param2 IS NULL
	  SET @p_param2 = CONVERT(CHAR(8),GETDATE(),112);

	IF @p_param1 IS NOT NULL
	SET @p_param1 = CASE @p_param1 WHEN 'ZSD_RFC_ESM_001_S' THEN 'XIF_ERP_SALES_RESULT_R' ELSE @p_param1 END

	
	IF @p_param1 IS NOT NULL AND @p_param2 IS NOT NULL AND @p_param3 IS NOT NULL AND @p_param4 IS NOT NULL
	BEGIN
		-- RFC 호출 예시 : C:\SAPRFC\SAPRFC_Batch.exe "XIF_ERP_ZMM_GSCM_END_STOCK_R" "C100" "A010" "202111"
		SET @v_command = 'C:\SAPRFC_NERP\SAPRFC_Batch.exe "' + @p_param1 +'" "'+@p_param2+'" "'+@p_param3+'" "'+@p_param4+'"' 
	END
	-- 날짜 파라미터가 들어왔을 때는 한번 호출
	ELSE IF @p_param1 IS NOT NULL AND @p_param2 IS NOT NULL AND @p_param3 IS NOT NULL
	BEGIN
		IF @p_param1 = N'XIF_ERP_ZMM_GSCM_END_STOCK_R'
		BEGIN
			SET @v_param4 = CONVERT(CHAR(6),DATEADD(MM,-1,GETDATE()),112); -- 전월 데이터
			SET @v_command = 'C:\SAPRFC_NERP\SAPRFC_Batch.exe "' + @p_param1 +'" "'+@p_param2+'" "'+@p_param3+'" "'+@v_param4+'"' 
		END
		ELSE
		BEGIN
			SET @v_command = 'C:\SAPRFC_NERP\SAPRFC_Batch.exe "' + @p_param1 +'" "'+@p_param2+'" "'+@p_param3+'"'
		END
	END
			
	ELSE IF @p_param1 IS NOT NULL AND @p_param2 IS NOT NULL
        BEGIN
			-- PJ20214907 (전기일 재고 I/F)		
			IF @p_param1 = N'XIF_ERP_BEGIN_END_STOCK_R'
				BEGIN
					/*
					@v_param1 = I/F 명
					@v_param2 = 날짜 (수행일 기준 2일 전)
					@v_param3 = 플랜트
					@v_param4 = 플랜트에 따른 국내/해외 접속구분자
					*/
                    SET @v_param1 = @p_param1
					SET @v_param3 = @p_param2
					
                    SELECT TOP 1 @v_param2 = CONVERT(CHAR(8),dateadd(day,-1 * attribute3,GETDATE()),112)
					     , @v_param4 = attribute1
                    FROM scm_adm_lookup_master_detail with (nolock)
                    WHERE 1 = 1 
                    AND lookup_type ='ERP_POSTING_STOCK_SETUP'
                    AND segment3 = @v_param3
					
                    -- PJ20216994
					/*
					RFC 호출 예시 : C:\SAPRFC\SAPRFC_Batch.exe "XIF_ERP_BEGIN_END_STOCK_R" "20210905" "" "A011" "" "" "" "A_"	 에서
					RFC 호출 예시 : C:\SAPRFC\SAPRFC_Batch.exe "XIF_ERP_BEGIN_END_STOCK_R" "20220802" "" "A010" "" "" "X" "X" "A_" 로 변경
					*/
					-- SET @v_command = 'C:\SAPRFC\SAPRFC_Batch.exe "' + @v_param1 + '" "' + @v_param2 + '" "' + '" "' + @v_param3 + '" "' + '" "' + '" "' + '" "' + @v_param4 + '"'
					SET @v_command = CONCAT('C:\SAPRFC_NERP\SAPRFC_Batch.exe "', @v_param1, '" "', @v_param2, '" "', '" "', @v_param3, '" "', '" "', '" "X', '"', ' "X" ', '"', @v_param4, '"')
				END
			ELSE
				BEGIN
					SET @v_command = 'C:\SAPRFC_NERP\SAPRFC_Batch.exe "' + @p_param1 +'" "'+@p_param2+'"'
				END		
		END
		
	ELSE -- 날짜 파라미터가 안들어왔을때는 전날 로그가 존재 하는지 조회 후에 로그가 없을 때는 전날 데이터 I/F 후에 오늘 데이터 I/F
		BEGIN
			SELECT @v_count = COUNT(*) 
			FROM scm_sys_log_batch WITH(NOLOCK)
			WHERE program_name = @p_param1 
			AND CONVERT(CHAR(8),creation_date,112) = CONVERT(CHAR(8),dateadd(day,-1,GETDATE()),112)
			IF @v_count = 0
				BEGIN
					SET @v_command = 'C:\SAPRFC_NERP\SAPRFC_Batch.exe "' + @p_param1 +'" "'+CONVERT(CHAR(8),dateadd(day,-1,GETDATE()),112)+'"'
					EXEC @v_ReturnCode = master.dbo.xp_cmdshell @v_command 
				END
		SET @v_command = 'C:\SAPRFC_NERP\SAPRFC_Batch.exe "' + @p_param1 +'"'
		END

	EXEC @v_ReturnCode = master.dbo.xp_cmdshell @v_command 

--	EXEC master..xp_cmdshell @v_command



      IF @@TRANCOUNT > 0 
        COMMIT WORK;

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'PARAM1 = '+ @p_param1 + ' , PARAM2 = ' + @p_param2 + 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_ReturnCode, @v_command, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_ReturnCode, @v_command, @d_event_date;

  END;