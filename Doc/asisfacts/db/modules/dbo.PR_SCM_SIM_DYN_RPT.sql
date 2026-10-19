
-- ==========================================================================================
-- Program:      PR_SCM_SIM_DYN_RPT
-- Author:       김준규
-- Create date:  2025-11-17
-- Description:  SCM_SIM_DYN_COLS 테이블의 데이터를 조회하여 RETURN한다.
-- How to Execute: EXEC PR_SCM_SIM_DYN_RPT @P_SNAP_YYYYMMDD='20251117',@P_REPORT_TITLE='PSI_DETAIL',@P_MAX_COLS_NUM='190';
--    EXEC PR_SCM_SIM_DYN_RPT @P_SNAP_YYYYMMDD='20251117',@P_REPORT_TITLE='PSI_RECENT_PLAN',@P_MAX_COLS_NUM='10';
-- ==========================================================================================
-- 2025-11-17       김준규       최초 릴리즈 후보
-- 2026-01-07       김준규       1개의 PLANT_ID에 두사람 사용으로 파라메터 추가
-- 2026-04-09       김준규       타사용자 동일 SORT_SEQ 타인 작업분 처리 발생(@BATCH_ID)추가
-- 2026-07-02       박원채       암호화 연결시 SORT_SEQ1값 통신오류 보완 ( NVARCHAR(MAX) -> NVARCHAR(128))
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_SCM_SIM_DYN_RPT]
    @P_BATCH_ID      nvarchar(30) = '0'
   ,@P_USER_ID       nvarchar(30) = ''
   ,@P_SNAP_YYYYMMDD nvarchar(8) = ''
   ,@P_REPORT_TITLE  nvarchar(254) = '' 
   ,@P_MAX_COLS_NUM  INT = 800
   ,@P_PLANT_ID      nvarchar(30) = ''
   ,@P_PLAN_GROUP    nvarchar(100) = ''
   ,@P_DIVISION_ID   nvarchar(30) = ''
AS
BEGIN
    SET NOCOUNT ON;

--################################################################################################################
--DECLARE
--################################################################################################################
    DECLARE @CNT BIGINT;
    DECLARE @WORK_SECOND BIGINT;
    DECLARE @MAPPING_RESULT NVARCHAR(2);
    DECLARE @BATCH_RUN_TIME BIGINT;
    DECLARE @BATCH_START_TIME DATETIME;
    DECLARE @BATCH_END_TIME DATETIME;
    DECLARE @RUN_TIME BIGINT;
    DECLARE @START_TIME DATETIME;
    DECLARE @END_TIME DATETIME;
    DECLARE @BATCH_ID BIGINT = CONVERT(BIGINT,@P_BATCH_ID);
    DECLARE @YYYYMM nvarchar(10) = '';
    DECLARE @DUMMY NVARCHAR(MAX);
    DECLARE @crlf  CHAR(2) = CHAR(13) + CHAR(10);
    DECLARE @pos   INT;

    SET @CNT = 0;
    SET @RUN_TIME = 0;

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_online_user NVARCHAR(150) = IIF(ISNULL(@P_USER_ID,'')='','simulator',@P_USER_ID);
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_SIM_DYN_RPT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD+',@P_REPORT_TITLE:'+@P_REPORT_TITLE+',@P_MAX_COLS_NUM:'+CONVERT(NVARCHAR(MAX),@P_MAX_COLS_NUM)+',@P_PLANT_ID:'+@P_PLANT_ID+',@P_PLAN_GROUP:'+@P_PLAN_GROUP+',@P_DIVISION_ID:'+@P_DIVISION_ID;
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;

BEGIN TRY

    --------------------------------------------------------
    -- 1. 고정 컬럼 정의 (@ColumnCount 값에 따라)
    --------------------------------------------------------
    DECLARE @SELECT_COLS INT = 800;
    SET @SELECT_COLS = (CASE WHEN (ISNULL(@P_MAX_COLS_NUM,'') = '' OR @P_MAX_COLS_NUM >= 800) THEN 800 ELSE @P_MAX_COLS_NUM END)

    DECLARE @CountOutput INT;
    DECLARE @SELCOL NVARCHAR(MAX) = '';
    DECLARE @SQL NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;
    
    -- C1 부터 C(@SELECT_COLS) 까지 컬럼명 동적 생성
    WHILE @i <= @SELECT_COLS
    BEGIN
        IF @i = 1
            SET @SELCOL = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @SELCOL = @SELCOL + ', C' + CAST(@i AS NVARCHAR(10));
        
        SET @i = @i + 1;
    END
    
    -- 동적 SQL 쿼리 생성
    SET @SQL  = N'SELECT CONVERT(NVARCHAR(128),BATCH_ID)+''-''+CONVERT(NVARCHAR(128),SORT_SEQ1) AS SORT_SEQ1, ' + @SELCOL + @crlf;
    SET @SQL += N'FROM   [SCM_SIM_DYN_COLS] AS SDC WITH(NOLOCK)'  + @crlf;
    SET @SQL += N'WHERE  SNAP_YYYYMMDD = '''+ (CASE WHEN ISNULL(@P_SNAP_YYYYMMDD,'')='' THEN CONVERT(NVARCHAR(8),GETDATE(),112) ELSE @P_SNAP_YYYYMMDD END) +''''+ @crlf ;
    SET @SQL += N'AND    REPORT_TITLE = '''+ @P_REPORT_TITLE +''''+ @crlf;
    IF ISNULL(@P_PLANT_ID,'')<>'' BEGIN
    SET @SQL += N'AND    PLANT_ID = '''+ @P_PLANT_ID +''''+ @crlf; END;
    IF ISNULL(@P_PLAN_GROUP,'')<>'' BEGIN
    SET @SQL += N'AND    PLAN_GROUP = '''+ @P_PLAN_GROUP +''''+ @crlf; END;
    IF ISNULL(@P_DIVISION_ID,'')<>'' BEGIN
    SET @SQL += N'AND    DIVISION_ID = '''+ @P_DIVISION_ID +''''+ @crlf; END;
    SET @SQL += N'AND    CREATED_BY = '''+ @v_online_user +''''+ @crlf;
    SET @SQL += N'AND    BATCH_ID = '''+ CONVERT(NVARCHAR(MAX),@BATCH_ID) +''''+ @crlf;
    SET @SQL += N'ORDER BY SDC.SORT_SEQ1, SORT_SEQ2, SORT_SEQ3, SORT_SEQ4, SORT_SEQ5, SORT_SEQ6, SORT_SEQ7, SORT_SEQ8, SORT_SEQ9, SORT_SEQ10;';
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;

    --종료 LOG (START)
    SET @v_log_type = 'END';
    SET @v_log_message = '##### END of procedure #####';
    SET @v_description = '@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD+',@P_REPORT_TITLE:'+@P_REPORT_TITLE+',@P_MAX_COLS_NUM:'+CONVERT(NVARCHAR(MAX),@P_MAX_COLS_NUM)+',@P_PLANT_ID:'+@P_PLANT_ID+',@P_PLAN_GROUP:'+@P_PLAN_GROUP+',@P_DIVISION_ID:'+@P_DIVISION_ID;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


END TRY
BEGIN CATCH
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @CNT, @WORK_SECOND, @v_description, @d_event_date;
        PRINT 'ERROR'
        PRINT ERROR_MESSAGE();

        -- 에러 정보 출력
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine, -- 에러 발생 라인
            ERROR_MESSAGE() AS ErrorMessage;


END CATCH

END

