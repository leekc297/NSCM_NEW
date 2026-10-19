


-- ==========================================================================================
-- Program:      PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_SCP
-- Author:       김준규
-- Create date:  2025-03-17
-- Description:  NERP) BIG Table  데이터 가져오기
-- How to Execute: EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_SCP 'ALL', '20250101','20250131'
-- EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_SCP @P_TABLE = 'SCP_ANL_MONTH_END_STOCK_R', @P_ROLLIN='3RD',@P_DEL_TYPE='DEL';
-- EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_SCP @P_TABLE = 'SCM_MST_MODEL_BOM_EFFECTIVE', @P_ROLLIN='3RD',@P_RTYPE_NUM=10;
--                  @P_START_YYYYMMDD 가져오는 시작일자 포함됨
--                  @P_END_YYYYMMDD 가져오는 끝나는일자 포함됨 --> 마지막일자 보다 작은 것으로 변경(전체 통일)
-- ==========================================================================================
-- 2025-03-13       김준규       NERP) BIG Table  데이터 가져오기
-- 2025-03-24       김준규       NERP) 일자기준을 1개 주차구간을 처리하도록 변경
-- 2025-04-01       김준규       NERP) 날짜별로 테이블의 데이터를 가져오는 것을 테이블한개당 날짜별로 가져오는 것으로 변경(갑자기 데이터 없는 시간이 최대 4시간이라서)
-- 2025-04-09       김준규       NERP) @P_END_YYYYMMDD 가져오는 끝나는일자 포함됨 --> 마지막일자 보다 작은 것으로 변경(전체 통일)
-- 2025-04-09       김준규       3TBL을 3개에서 5개 BIG 으로 재구성
-- 2025-04-17       김준규       운영에서 1ST 실행시 모든 것 실행하기 위하여 @P_TABLE = 'ALL' 추가
-- 2025-04-18       김준규       DROP_NERP_CONV_INS_FR_PROD_PROG Table 인서트 수량 및 LAST_UPDATE_DATE 추가 보완
-- 2025-04-26       김준규       데이터 추출해오는 컬럼이 DATATIME에서 시간이 존재하는 3개 테이블 누락파악, 보완
-- 2025-06-08       김준규       NERP) 에러 발생시 DROP_NERP_CONV_INS_FR_PROD_PROG 테이블에도 기록
-- 2025-07-13       김준규       NERP) 프로그램 이름 변경 및 PARAMETER 일자를 ROLLIN으로 변경하고, DEL과 TRUNC 입력변수를 받음
-- 2025-08-11       김준규       NERP) OPENQUERY 형식으로 변경
-- 2025-09-08       김준규       작업분배 방식 사용, 사용기간 선택 추가.
-- 2025-10-15       김준규       NERP_CONV_CUTOFF_TAKES_MIN 테이블에 RTYPE=SCP 추가.                            
-- 2025-10-15       김준규       NERP) 입력변수 추가 @P_DEL_TYPE nvarchar(30)='TRUNC' --TRUNC:TRUNCATE,DEL:DELETE
---------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_SCP]
   @P_TABLE nvarchar(128)
 , @P_ROLLIN nvarchar(30) --1ST 2ND 3RD 4TH
 , @P_DEL_TYPE nvarchar(30)='TRUNC' --TRUNC:TRUNCATE,DEL:DELETE
 , @P_RTYPE_NUM INT = 99999
 , @P_GROUP_NUM INT --그룹카운트 중 몇번째 것
 , @P_GROUP_COUNT INT 
AS
BEGIN

    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','4N5')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
        RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
    END

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
    DECLARE @YYYYMM nvarchar(10) = '';
    DECLARE @V_SCOPE_ID BIGINT;
    DECLARE @V_ROWS_INSERTED BIGINT;
    DECLARE @V_FR_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 FR_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='SCP' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);
    DECLARE @V_TO_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 TO_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='SCP' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);
    DECLARE @LinkedServerName NVARCHAR(254) = '10.34.220.85,7433';
    DECLARE @DBPrefix NVARCHAR(254) = '[LGCE_SCMPROD].[DBO].';-- LINKED_SERVER 운영DB 사용

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_SCP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno      NVARCHAR(30);
    DECLARE @n_history_seq  BIGINT;
    DECLARE @LOOP integer = 0;
    DECLARE @DUMMY          NVARCHAR(MAX);


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@P_TABLE:'+@P_TABLE+'@P_ROLLIN:'+@P_ROLLIN+',@P_DEL_TYPE:'+@P_DEL_TYPE+',@P_RTYPE_NUM='+CONVERT(CHAR(23),@P_RTYPE_NUM)+',@P_GROUP_NUM='+CONVERT(CHAR(23),@P_GROUP_NUM)+',@P_GROUP_COUNT='+CONVERT(CHAR(23),@P_GROUP_COUNT);
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;

BEGIN TRY

    DECLARE @YYYYMMDD VARCHAR(8)
    DECLARE @START_YYYYMMDD VARCHAR(8)
    DECLARE @Upper_Limit_Value VARCHAR(8)
    DECLARE @ISO_YYYYWW VARCHAR(8)
    DECLARE @YYYY_WEEK_NM VARCHAR(8)
    DECLARE @ISO_YYYYMM VARCHAR(8)
    DECLARE @TABLE_NAME VARCHAR(128)
    DECLARE @PreFix NVARCHAR(128)='';--'DROP_'
    DECLARE @SAVED_TABLE_NAME VARCHAR(128)='';
    DECLARE @SQL_TABLE_NAME VARCHAR(128)='';
    DECLARE @CUTOFF_COLUMN1 VARCHAR(128)
    DECLARE @DUMMY1 VARCHAR(128)
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @RN NVARCHAR(10)
    DECLARE @WEEK_YN NVARCHAR(1)
    DECLARE @DATE_TYPE_YN NVARCHAR(1)   
    DECLARE @PLAN_TYPE_YN NVARCHAR(1)   

    --#####################
    --월별용
    --#####################
    -- 기존 mig_cursor가 있다면 제거
    IF CURSOR_STATUS('global', 'mig_cursor') >= 0
    BEGIN
        CLOSE mig_cursor
        DEALLOCATE mig_cursor
    END

    DECLARE mig_cursor CURSOR FOR
    SELECT SCM.TABLE_NAME
         , CUTOFF_COLUMN1
         , CUTOFF_START
    FROM NERP_CONV_SCP_CUTOFF_MASTER AS SCM WITH (NOLOCK)
    JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON SCM.TABLE_NAME = CTM.TABLE_NAME
    WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
    AND   CTM.RTYPE = 'SCP'
    AND   CTM.GROUP_NUM = @P_GROUP_NUM
    AND   CTM.GROUP_COUNT = @P_GROUP_COUNT
    AND  SCM.TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R'  --202412    202504
    AND  (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR SCM.TABLE_NAME = @P_TABLE) 
    ORDER BY 1

    OPEN mig_cursor

    -- MIG_TBL 커서에서 테이블 이름과 컬럼 이름 가져오기
    FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1

    WHILE @@FETCH_STATUS = 0
    BEGIN

        SET @SQL_TABLE_NAME = @PreFix+@TABLE_NAME;

        INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
            TABLE_NAME
            ,START_YYYYMMDD
            ,END_YYYYMMDD
            ,CURR_DATE
        ) VALUES(
             @TABLE_NAME
            ,@V_FR_YYYYMMDD
            ,@V_TO_YYYYMMDD
            ,'ALL'
        );            
        SELECT @V_SCOPE_ID = SCOPE_IDENTITY();

        IF @P_DEL_TYPE = 'TRUNC' BEGIN
            SET @SQL = '
            TRUNCATE TABLE LGCE_SCMDEV.DBO.' + QUOTENAME(@SQL_TABLE_NAME) + ';';             
            PRINT @SQL  -- 디버깅용 출력
            END;
        ELSE IF @P_DEL_TYPE = 'DEL' BEGIN
            --#####################
            --월별용
            --#####################
            SET @SQL = '
            DELETE FROM LGCE_SCMDEV.DBO.' + QUOTENAME(@SQL_TABLE_NAME) + '
            WHERE  ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= FORMAT(DATEADD(MONTH,-6,ISNULL(CONVERT(DATE,'''+@V_FR_YYYYMMDD+'''),''20250326'')),''yyyyMM'')
            AND    ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < FORMAT(ISNULL(CONVERT(DATE,'''+@V_TO_YYYYMMDD+'''),''20250326''),''yyyyMM'');';             
            PRINT @SQL  -- 디버깅용 출력
            END;
        ELSE BEGIN
            PRINT CONVERT(NVARCHAR(MAX), N'@P_DEL_TYPE: '''+ISNULL(@P_DEL_TYPE,'Value is null ')+''' Please, Input Defined P_DEL_TYPE, Stop Procedure!!.');
            RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
        END;
        BEGIN TRY
            BEGIN TRANSACTION;
                EXEC sp_executesql @SQL;

                UPDATE FPP
                SET    SQL_STMT = @SQL
                      ,LAST_UPDATE_DATE = GETDATE()
                FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                WHERE  ID = @V_SCOPE_ID;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            COMMIT TRANSACTION;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                    SET @DUMMY = @SQL + ',' + ERROR_MESSAGE();
                    PRINT @DUMMY;
                    UPDATE FPP
                    SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                          ,SQL_STMT = @DUMMY
                          ,LAST_UPDATE_DATE = GETDATE()
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @SQL_TABLE_NAME, @v_description, @d_event_date;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END CATCH

        IF CURSOR_STATUS('global', 'date_cursor') >= 0
        BEGIN
            CLOSE date_cursor
            DEALLOCATE date_cursor
        END
    
        DECLARE date_cursor CURSOR FOR
        SELECT DISTINCT ISO_YYYYMM
        FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
        WHERE  BASIS_YYYYMMDD >= FORMAT(DATEADD(MONTH,-6,CONVERT(DATE,@V_FR_YYYYMMDD)),'yyyyMMdd')
        AND    BASIS_YYYYMMDD < @V_TO_YYYYMMDD
        ORDER BY CM.ISO_YYYYMM DESC
    
        -- 커서 열기
        OPEN date_cursor
    
        -- 날짜 커서에서 데이터를 가져와서 처리
        FETCH NEXT FROM date_cursor INTO @ISO_YYYYMM
    
        WHILE @@FETCH_STATUS = 0
        BEGIN

            INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
                TABLE_NAME
                ,START_YYYYMMDD
                ,END_YYYYMMDD
                ,CURR_DATE
            ) VALUES(
                 @TABLE_NAME
                ,@V_FR_YYYYMMDD
                ,@V_TO_YYYYMMDD
                ,@ISO_YYYYMM
            );
            SELECT @V_SCOPE_ID = SCOPE_IDENTITY();

            -- 동적 SQL 생성 및 실행
            SET @SQL = N'
            INSERT INTO ' + QUOTENAME(@SQL_TABLE_NAME) + N'';
            SET @SQL += N'
            SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
            ''SELECT *
            FROM '+ @DBPrefix + QUOTENAME(@TABLE_NAME) + ' WITH(NOLOCK)
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' = ''''' + @ISO_YYYYMM + ''''' '')
            SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
            '
            PRINT @SQL  -- 디버깅용 출력
    
            BEGIN TRY
                BEGIN TRANSACTION;
                    EXEC sp_executesql @SQL, 
                         N'@V_ROWS_AFFECTED_OUT BIGINT OUTPUT',
                         @V_ROWS_AFFECTED_OUT = @V_ROWS_INSERTED OUTPUT;
    
                         UPDATE FPP
                         SET    INSERTED_ROWCNT = @V_ROWS_INSERTED
                               ,LAST_UPDATE_DATE = GETDATE()
                               ,SQL_STMT = @SQL
                         FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                         WHERE  ID = @V_SCOPE_ID;
    
                COMMIT TRANSACTION;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;
                    SET @DUMMY = @SQL + ',' + ERROR_MESSAGE();
                    UPDATE FPP
                    SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                          ,SQL_STMT = @DUMMY
                          ,LAST_UPDATE_DATE = GETDATE()
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
                    PRINT @DUMMY;
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @SQL_TABLE_NAME, @v_description, @d_event_date;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            END CATCH
    
            -- 다음 MIG_TBL 데이터 가져오기
            FETCH NEXT FROM date_cursor INTO @ISO_YYYYMM
        END

        -- 커서 닫기 및 해제
        CLOSE date_cursor
        DEALLOCATE date_cursor

        -- 다음 날짜 데이터 가져오기
        FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1
    END

    -- MIG_TBL 커서 닫기 및 해제
    CLOSE mig_cursor
    DEALLOCATE mig_cursor

    --#####################
    --주차용
    --#####################

    -- 기존 mig_cursor가 있다면 제거
    IF CURSOR_STATUS('global', 'mig_cursor') >= 0
    BEGIN
        CLOSE mig_cursor
        DEALLOCATE mig_cursor
    END

    -- 두 번째 커서: MIG_TBL에서 테이블 이름과 컬럼 이름 조회
    DECLARE mig_cursor CURSOR FOR
    SELECT SCM.TABLE_NAME
         , CUTOFF_COLUMN1
         , CUTOFF_START
    FROM NERP_CONV_SCP_CUTOFF_MASTER AS SCM WITH (NOLOCK)
    JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON SCM.TABLE_NAME = CTM.TABLE_NAME
    WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
    AND   CTM.RTYPE = 'SCP'
    AND   CTM.GROUP_NUM = @P_GROUP_NUM
    AND   CTM.GROUP_COUNT = @P_GROUP_COUNT
    AND  (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR SCM.TABLE_NAME = @P_TABLE) 
    AND ( SCM.TABLE_NAME = 'SCM_DNM_MPP_SNAPSHOT'  --2025-W01   2025-W05
      OR  SCM.TABLE_NAME = 'SCP_BI_FP_RESULT'  --202501 202505
        )
    ORDER BY 1

    OPEN mig_cursor

    -- MIG_TBL 커서에서 테이블 이름과 컬럼 이름 가져오기
    FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1

    WHILE @@FETCH_STATUS = 0
    BEGIN

        SET @SQL_TABLE_NAME = @PreFix+@TABLE_NAME;

        INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
            TABLE_NAME
            ,START_YYYYMMDD
            ,END_YYYYMMDD
            ,CURR_DATE
        ) VALUES(
            @TABLE_NAME
            ,@V_FR_YYYYMMDD
            ,@V_TO_YYYYMMDD
            ,'ALL'
        );
        SELECT @V_SCOPE_ID = SCOPE_IDENTITY();

        -- 동적 SQL 생성 및 실행
        IF @P_DEL_TYPE = 'TRUNC' BEGIN
            SET @SQL = '
            TRUNCATE TABLE LGCE_SCMDEV.DBO.' + QUOTENAME(@SQL_TABLE_NAME) + ';';
            PRINT @SQL  -- 디버깅용 출력
            END;                    
        ELSE IF @P_DEL_TYPE = 'DEL' BEGIN
            IF @TABLE_NAME IN ( 'SCM_DNM_MPP_SNAPSHOT' ) BEGIN
                SET @SQL = '
                WITH W_RAW AS (
                    SELECT MIN(LEFT(CM.ISO_YYYYMM,4)+''-''+CM.WEEK_NAME) AS MIN_YYYY_WEEK_NM
                            ,MAX(LEFT(CM.ISO_YYYYMM,4)+''-''+CM.WEEK_NAME) AS MAX_YYYY_WEEK_NM
                    FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
                    WHERE  BASIS_YYYYMMDD >= '''+@V_FR_YYYYMMDD+'''
                    AND    BASIS_YYYYMMDD < '''+@V_TO_YYYYMMDD+'''
                )
                DELETE DMS
                FROM   ' + QUOTENAME(@SQL_TABLE_NAME) + ' AS DMS
                JOIN   W_RAW AS WR ON 1=1
                WHERE  DMS.SNAPSHOT_WEEK >= WR.MIN_YYYY_WEEK_NM
                AND    DMS.SNAPSHOT_WEEK <= WR.MAX_YYYY_WEEK_NM;';
                PRINT @SQL  -- 디버깅용 출력
            END;
            ELSE IF @TABLE_NAME IN ( 'SCP_BI_FP_RESULT' ) BEGIN
                SET @SQL = '
                WITH W_RAW AS (
                    SELECT MIN(CM.ISO_YYYYWW) AS MIN_ISO_YYYYWW
                          ,MAX(CM.ISO_YYYYWW) AS MAX_ISO_YYYYWW
                    FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
                    WHERE  BASIS_YYYYMMDD >= '''+@V_FR_YYYYMMDD+'''
                    AND    BASIS_YYYYMMDD <= '''+@V_TO_YYYYMMDD+'''
                )
                DELETE BFR
                FROM   ' + QUOTENAME(@SQL_TABLE_NAME) + ' AS BFR
                JOIN   W_RAW AS WR ON 1=1
                WHERE  BFR.PLAN_WEEK >= WR.MIN_ISO_YYYYWW
                AND    BFR.PLAN_WEEK < WR.MAX_ISO_YYYYWW;'; 
                PRINT @SQL  -- 디버깅용 출력
            END;
        END;
        ELSE BEGIN
            PRINT CONVERT(NVARCHAR(MAX), N'@P_DEL_TYPE: '''+ISNULL(@P_DEL_TYPE,'Value is null ')+''' Please, Input Defined P_DEL_TYPE, Stop Procedure!!.');
            RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
        END;
        BEGIN TRY
            BEGIN TRANSACTION;
                EXEC sp_executesql @SQL;

                UPDATE FPP
                SET    SQL_STMT = @SQL
                      ,LAST_UPDATE_DATE = GETDATE()
                FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                WHERE  ID = @V_SCOPE_ID;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            COMMIT TRANSACTION;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                    SET @DUMMY = @SQL + ',' + ERROR_MESSAGE();
                    UPDATE FPP
                    SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                          ,SQL_STMT = @DUMMY
                          ,LAST_UPDATE_DATE = GETDATE()
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
                    PRINT @DUMMY;
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @SQL_TABLE_NAME, @v_description, @d_event_date;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END CATCH

        -- 기존 mig_cursor가 있다면 제거
        IF CURSOR_STATUS('global', 'date_cursor') >= 0
        BEGIN
            CLOSE date_cursor
            DEALLOCATE date_cursor
        END
        
        -- 첫 번째 커서: 날짜 조회
        DECLARE date_cursor CURSOR FOR
        SELECT DISTINCT CM.ISO_YYYYWW,LEFT(CM.ISO_YYYYMM,4)+'-'+CM.WEEK_NAME AS YYYY_WEEK_NM
        FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
        WHERE  BASIS_YYYYMMDD >= @V_FR_YYYYMMDD
        AND    BASIS_YYYYMMDD < @V_TO_YYYYMMDD
        ORDER BY CM.ISO_YYYYWW ASC
        
        -- 커서 열기
        OPEN date_cursor
        
        -- 날짜 커서에서 데이터를 가져와서 처리
        FETCH NEXT FROM date_cursor INTO @ISO_YYYYWW,@YYYY_WEEK_NM
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
        
            INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
                TABLE_NAME
                ,START_YYYYMMDD
                ,END_YYYYMMDD
                ,CURR_DATE
            ) VALUES(
                @TABLE_NAME
                ,@V_FR_YYYYMMDD
                ,@V_TO_YYYYMMDD
                ,@YYYY_WEEK_NM+'|'+@ISO_YYYYWW
            );
            SELECT @V_SCOPE_ID = SCOPE_IDENTITY();

            IF @TABLE_NAME IN ( 'SCM_DNM_MPP_SNAPSHOT' ) BEGIN
                SET @SQL = '
            INSERT INTO ' + QUOTENAME(@SQL_TABLE_NAME) + N'';
                SET @SQL += N'
            SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
            ''SELECT *
            FROM '+ @DBPrefix + QUOTENAME(@TABLE_NAME) + ' WITH(NOLOCK)
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' = ''''' + @YYYY_WEEK_NM + ''''' '')
            SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
            ';
            PRINT @SQL  -- 디버깅용 출력
            END;
            ELSE IF @TABLE_NAME IN ( 'SCP_BI_FP_RESULT' ) BEGIN        
                SET @SQL = '
            INSERT INTO ' + QUOTENAME(@SQL_TABLE_NAME) + N'';
                SET @SQL += N'
            SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
            ''SELECT *
            FROM '+ @DBPrefix + QUOTENAME(@TABLE_NAME) + ' WITH(NOLOCK)
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' = ''''' + @ISO_YYYYWW + ''''' '')
            SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
            ';
                PRINT @SQL  -- 디버깅용 출력
            END;
            BEGIN TRY
                BEGIN TRANSACTION;
                    EXEC sp_executesql @SQL, 
                         N'@V_ROWS_AFFECTED_OUT BIGINT OUTPUT',
                         @V_ROWS_AFFECTED_OUT = @V_ROWS_INSERTED OUTPUT;
            
                    UPDATE FPP
                    SET    INSERTED_ROWCNT = @V_ROWS_INSERTED
                          ,LAST_UPDATE_DATE = GETDATE()
                          ,SQL_STMT = @SQL
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
            
                COMMIT TRANSACTION;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;
                    SET @DUMMY = @SQL + ',' + ERROR_MESSAGE();
                    UPDATE FPP
                    SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                          ,SQL_STMT = @DUMMY
                          ,LAST_UPDATE_DATE = GETDATE()
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
                    PRINT @DUMMY;
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @SQL_TABLE_NAME, @v_description, @d_event_date;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            END CATCH
            
            -- 다음 날짜 데이터 가져오기
            FETCH NEXT FROM date_cursor INTO @ISO_YYYYWW,@YYYY_WEEK_NM
        END;
        
        -- 커서 닫기 및 해제
        CLOSE date_cursor
        DEALLOCATE date_cursor
    
        -- 다음 MIG_TBL 데이터 가져오기
        FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1
    END

    -- MIG_TBL 커서 닫기 및 해제
    CLOSE mig_cursor
    DEALLOCATE mig_cursor

    --#####################
    --BOM TABLE 만 (SCM_MST_MODEL_BOM_EFFECTIVE)
    --#####################
    -- 기존 mig_cursor가 있다면 제거
    IF CURSOR_STATUS('global', 'mig_cursor') >= 0
    BEGIN
        CLOSE mig_cursor
        DEALLOCATE mig_cursor
    END

    -- 두 번째 커서: MIG_TBL에서 테이블 이름과 컬럼 이름 조회
    DECLARE mig_cursor CURSOR FOR
    SELECT SCM.TABLE_NAME
         , CUTOFF_COLUMN1
         , CUTOFF_START
    FROM NERP_CONV_SCP_CUTOFF_MASTER SCM WITH (NOLOCK)
    JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON SCM.TABLE_NAME = CTM.TABLE_NAME
    WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
    AND   CTM.RTYPE = 'SCP'
    AND   CTM.GROUP_NUM = @P_GROUP_NUM
    AND   CTM.GROUP_COUNT = @P_GROUP_COUNT
    AND  SCM.TABLE_NAME <> 'SCM_DNM_MPP_SNAPSHOT'  --2025-W01   2025-W05
    AND  SCM.TABLE_NAME <> 'SCP_ANL_MONTH_END_STOCK_R'  --202412    202504
    AND  SCM.TABLE_NAME <> 'SCP_BI_FP_RESULT'  --202501 202505
    AND  SCM.TABLE_NAME = 'SCM_MST_MODEL_BOM_EFFECTIVE'
    and (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR SCM.TABLE_NAME = @P_TABLE)
    ORDER BY 1

    OPEN mig_cursor

    -- MIG_TBL 커서에서 테이블 이름과 컬럼 이름 가져오기
    FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1

    WHILE @@FETCH_STATUS = 0
    BEGIN

        SET @SQL_TABLE_NAME = @PreFix+@TABLE_NAME;

        INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
            TABLE_NAME
            ,START_YYYYMMDD
            ,END_YYYYMMDD
            ,CURR_DATE
        ) VALUES(
            @TABLE_NAME
            ,@V_FR_YYYYMMDD
            ,'99991231'--@V_TO_YYYYMMDD
            ,'ALL'
        );
        SELECT @V_SCOPE_ID = SCOPE_IDENTITY();

        IF @P_DEL_TYPE = 'TRUNC' BEGIN
            SET @SQL = '
            TRUNCATE TABLE LGCE_SCMDEV.DBO.' + QUOTENAME(@SQL_TABLE_NAME) + ';';             
            PRINT @SQL  -- 디버깅용 출력
            END;
        ELSE IF @P_DEL_TYPE = 'DEL' BEGIN
            --#####################
            --월별용
            --#####################
            SET @SQL = '
            DELETE FROM LGCE_SCMDEV.DBO.' + QUOTENAME(@SQL_TABLE_NAME) + '
            WHERE  ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= FORMAT(DATEADD(MONTH,-6,ISNULL(CONVERT(DATE,'''+@V_FR_YYYYMMDD+'''),''20250326'')),''yyyyMMdd'')
            AND    ' + QUOTENAME(@CUTOFF_COLUMN1) + ' <= ''99991231'';';             
            PRINT @SQL  -- 디버깅용 출력
            END;
        ELSE BEGIN
            PRINT CONVERT(NVARCHAR(MAX), N'@P_DEL_TYPE: '''+ISNULL(@P_DEL_TYPE,'Value is null ')+''' Please, Input Defined P_DEL_TYPE, Stop Procedure!!.');
            RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
        END;
        BEGIN TRY
            BEGIN TRANSACTION;
                EXEC sp_executesql @SQL;

                UPDATE FPP
                SET    SQL_STMT = @SQL
                      ,LAST_UPDATE_DATE = GETDATE()
                FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                WHERE  ID = @V_SCOPE_ID;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            COMMIT TRANSACTION;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                    SET @DUMMY = @SQL + ',' + ERROR_MESSAGE();
                    UPDATE FPP
                    SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                          ,SQL_STMT = @DUMMY
                          ,LAST_UPDATE_DATE = GETDATE()
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
                    PRINT @DUMMY;
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @SQL_TABLE_NAME, @v_description, @d_event_date;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END CATCH


        IF CURSOR_STATUS('global', 'date_cursor') >= 0
        BEGIN
            CLOSE date_cursor
            DEALLOCATE date_cursor
        END

        DECLARE date_cursor CURSOR FOR
        SELECT YYYYMMDD = @V_FR_YYYYMMDD,'1' AS RN
        UNION
        SELECT YYYYMMDD = '99991231'       ,'2' AS RN
        ORDER BY YYYYMMDD ASC
        
        -- 커서 열기
        OPEN date_cursor
        
        -- 날짜 커서에서 데이터를 가져와서 처리
        FETCH NEXT FROM date_cursor INTO @YYYYMMDD,@RN
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
                -- 동적 SQL 생성 및 실행

            INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
                TABLE_NAME
                ,START_YYYYMMDD
                ,END_YYYYMMDD
                ,CURR_DATE
            ) VALUES(
                 @TABLE_NAME
                ,@V_FR_YYYYMMDD
                ,@RN
                ,@YYYYMMDD
            );
            SELECT @V_SCOPE_ID = SCOPE_IDENTITY();
            IF @RN = '1' BEGIN
                SET @SQL = '
            INSERT INTO ' + QUOTENAME(@SQL_TABLE_NAME) + N'';
            SET @SQL += N'
            SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
            ''SELECT *
            FROM '+ @DBPrefix + QUOTENAME(@TABLE_NAME) + ' WITH(NOLOCK)
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= ''''' + ISNULL(@YYYYMMDD,'20250326') + '''''
            AND   ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < ''''' + '99991231' + ''''' '')
            SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
            ';
            END
            ELSE IF @RN = '2' BEGIN
                SET @SQL = '
            INSERT INTO ' + QUOTENAME(@SQL_TABLE_NAME) + N'';
                SET @SQL += N'
            SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
            ''SELECT *
            FROM '+ @DBPrefix + QUOTENAME(@TABLE_NAME) + ' WITH(NOLOCK)
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' = ''''' + @YYYYMMDD + ''''' '')
            SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
            ';
            END;

            PRINT @SQL  -- 디버깅용 출력

            BEGIN TRY
                BEGIN TRANSACTION;
                    EXEC sp_executesql @SQL, 
                         N'@V_ROWS_AFFECTED_OUT BIGINT OUTPUT',
                         @V_ROWS_AFFECTED_OUT = @V_ROWS_INSERTED OUTPUT;

                    UPDATE FPP
                    SET    INSERTED_ROWCNT = @V_ROWS_INSERTED
                          ,LAST_UPDATE_DATE = GETDATE()
                          ,SQL_STMT = ISNULL(@SQL,'NULL')
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;

                COMMIT TRANSACTION;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            END TRY
            BEGIN CATCH
                IF @@TRANCOUNT > 0
                    ROLLBACK TRANSACTION;
                    SET @DUMMY = @SQL + ',' + ERROR_MESSAGE();
                    UPDATE FPP
                    SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                          ,SQL_STMT = @DUMMY
                          ,LAST_UPDATE_DATE = GETDATE()
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
                    PRINT @DUMMY;
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @SQL_TABLE_NAME, @v_description, @d_event_date;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            END CATCH

            -- 다음 날짜 데이터 가져오기
            FETCH NEXT FROM date_cursor INTO @YYYYMMDD,@RN
        END

        -- 커서 닫기 및 해제
        CLOSE date_cursor
        DEALLOCATE date_cursor

        -- 다음 MIG_TBL 데이터 가져오기
        FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1
    END

    -- MIG_TBL 커서 닫기 및 해제
    CLOSE mig_cursor
    DEALLOCATE mig_cursor


    --#####################
    --날짜용
    --#####################
    --TRUNCATE TABLE HIST_SCP_ANL_PRODUCTION_PLAN    ;
    --TRUNCATE TABLE HIST_SCP_ANL_SHIPMENT_PLAN_FG   ;
    --TRUNCATE TABLE HIST_SCP_ANL_SHIPMENT_PLAN_SEMI ;
    --TRUNCATE TABLE SCM_DNM_INTRANSIT_C             ;
    --TRUNCATE TABLE SCM_DNM_STOCK                   ;
    --TRUNCATE TABLE SCM_KPI_DETAIL                  ;
    --TRUNCATE TABLE SCM_KPI_SUMMARY                 ;
    --TRUNCATE TABLE SCM_MST_MODEL_BOM_EFFECTIVE     ;
    --TRUNCATE TABLE SCP_ANL_BOD_N_V_PLAN_H          ;
    --TRUNCATE TABLE SCP_ANL_MAT_SUPPLY              ;
    --TRUNCATE TABLE SCP_ANL_MONTH_END_STOCK_R_D     ;
    --TRUNCATE TABLE SCP_ANL_PROBLEM_REPORT_DEMAND   ;
    --TRUNCATE TABLE SCP_ANL_PROBLEM_REPORT_PEGGING  ;
    --TRUNCATE TABLE SCP_ANL_PRODUCTION_PLAN         ;
    --TRUNCATE TABLE SCP_ANL_PRODUCTION_PLAN_C       ;
    --TRUNCATE TABLE SCP_ANL_PRODUCTION_PLAN_H       ;
    --TRUNCATE TABLE SCP_ANL_PSI_ELECTRODE           ;
    --TRUNCATE TABLE SCP_ANL_PSI_GLOBAL              ;
    --TRUNCATE TABLE SCP_ANL_PSI_GLOBAL_ESS          ;
    --TRUNCATE TABLE SCP_ANL_PSI_GLOBAL_SMALL        ;
    --TRUNCATE TABLE SCP_ANL_PSI_PRODUCTION          ;
    --TRUNCATE TABLE SCP_ANL_SHIPMENT_PLAN_FG        ;
    --TRUNCATE TABLE SCP_ANL_SHIPMENT_PLAN_FG_C      ;
    --TRUNCATE TABLE SCP_ANL_SHIPMENT_PLAN_SEMI      ;
    --TRUNCATE TABLE SCP_ANL_SHIPMENT_PLAN_SEMI_C    ;
    --TRUNCATE TABLE SCP_ANL_TACT_TIME               ;
    --TRUNCATE TABLE SCP_PLN_PLANT_ONHAND            ;
    --TRUNCATE TABLE SCP_PLN_PRODUCTION_PLAN         ;
    --TRUNCATE TABLE SCP_PLN_SALES_ONHAND            ;
    --TRUNCATE TABLE SCP_PLN_SHIPMENT_PLAN           ;
    --TRUNCATE TABLE SCP_RPT_ELEC_PSI                ;
    --TRUNCATE TABLE SCP_RPT_GLOBAL_PSI_MD_MM        ;
    --TRUNCATE TABLE SCP_RPT_GLOBAL_PSI_MD_WW        ;

    -- 기존 mig_cursor가 있다면 제거
    IF CURSOR_STATUS('global', 'mig_cursor') >= 0
    BEGIN
        CLOSE mig_cursor
        DEALLOCATE mig_cursor
    END

    -- 첫 번째 커서: MIG_TBL에서 테이블 이름과 컬럼 이름 조회
    DECLARE mig_cursor CURSOR FOR
    WITH W_WEEK_TBL AS (
       -- 일자가 주차별로 존재하는 테이블
        SELECT 'Y' AS WEEK_YN,'Y' AS PLAN_TYPE_YN,TRIM('HIST_SCP_ANL_PRODUCTION_PLAN   ') AS TABLE_NAME UNION
        --자꾸 중복에러가 나서 PLAN_TYPE_YN 처리하지 않음--HIST_SCP_ANL_SHIPMENT_PLAN_FG
        SELECT 'Y' AS WEEK_YN,'Y' AS PLAN_TYPE_YN,TRIM('HIST_SCP_ANL_SHIPMENT_PLAN_FG  ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('HIST_SCP_ANL_SHIPMENT_PLAN_SEMI') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_BOD_N_V_PLAN_H         ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_MAT_SUPPLY             ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_PROBLEM_REPORT_DEMAND  ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_PROBLEM_REPORT_PEGGING ') AS TABLE_NAME UNION
        --자꾸 중복에러가 나서 PLAN_TYPE_YN 처리하지 않음--SCP_ANL_PSI_PRODUCTION
        SELECT 'Y' AS WEEK_YN,'Y' AS PLAN_TYPE_YN,TRIM('SCP_ANL_PRODUCTION_PLAN        ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_PRODUCTION_PLAN_H      ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_PSI_ELECTRODE          ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_PSI_GLOBAL             ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_PSI_GLOBAL_ESS         ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_PSI_GLOBAL_SMALL       ') AS TABLE_NAME UNION
        --자꾸 중복에러가 나서 PLAN_TYPE_YN 처리하지 않음--SCP_ANL_PSI_PRODUCTION
        SELECT 'Y' AS WEEK_YN,'Y' AS PLAN_TYPE_YN,TRIM('SCP_ANL_PSI_PRODUCTION         ') AS TABLE_NAME UNION
        --자꾸 중복에러가 나서 PLAN_TYPE_YN 처리하지 않음--SCP_ANL_SHIPMENT_PLAN_FG
        SELECT 'Y' AS WEEK_YN,'Y' AS PLAN_TYPE_YN,TRIM('SCP_ANL_SHIPMENT_PLAN_FG       ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_ANL_SHIPMENT_PLAN_SEMI     ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_PLN_PLANT_ONHAND           ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_PLN_PRODUCTION_PLAN        ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_PLN_SALES_ONHAND           ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_PLN_SHIPMENT_PLAN          ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_RPT_ELEC_PSI               ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_RPT_GLOBAL_PSI_MD_MM       ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,'N' AS PLAN_TYPE_YN,TRIM('SCP_RPT_GLOBAL_PSI_MD_WW       ') AS TABLE_NAME
    )
    SELECT SCM.TABLE_NAME
         , CUTOFF_COLUMN1
         , CUTOFF_START
         , WEEK_YN = ISNULL(WWT.WEEK_YN,'N')
         -- 2025-04-26 데이터 추출해오는 컬럼이 DATATIME에서 시간이 존재하는 3개 테이블 누락파악, 보완
         , DATE_TYPE_YN = IIF(C.DATA_TYPE IS NULL,'N','Y')
         , PLAN_TYPE_YN = ISNULL(WWT.PLAN_TYPE_YN,'N')
    FROM NERP_CONV_SCP_CUTOFF_MASTER AS SCM WITH (NOLOCK)
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS c WITH(NOLOCK)
    ON   SCM.TABLE_NAME = C.TABLE_NAME AND  C.DATA_TYPE LIKE 'DATE%' AND SCM.CUTOFF_COLUMN1 = C.COLUMN_NAME
    LEFT JOIN W_WEEK_TBL WWT
    ON   SCM.TABLE_NAME = WWT.TABLE_NAME
    JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON SCM.TABLE_NAME = CTM.TABLE_NAME
    WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
    AND   CTM.RTYPE = 'SCP'
    AND   CTM.GROUP_NUM = @P_GROUP_NUM
    AND   CTM.GROUP_COUNT = @P_GROUP_COUNT
    AND  SCM.TABLE_NAME <> 'SCM_DNM_MPP_SNAPSHOT'  --2025-W01   2025-W05
    AND  SCM.TABLE_NAME <> 'SCP_ANL_MONTH_END_STOCK_R'  --202412    202504
    AND  SCM.TABLE_NAME <> 'SCP_BI_FP_RESULT'  --202501 202505
    AND  SCM.TABLE_NAME <> 'SCM_MST_MODEL_BOM_EFFECTIVE' --BOM TABLE
    AND  (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR SCM.TABLE_NAME = @P_TABLE) 
    AND NOT EXISTS ( SELECT 1
                     FROM  (SELECT 'SCP_ANL_SHIPMENT_PLAN_FG'      AS TBL_NM UNION
                            SELECT 'SCP_ANL_SHIPMENT_PLAN_SEMI'    AS TBL_NM UNION
                            --SELECT 'HIST_SCP_ANL_SHIPMENT_PLAN_FG' AS TBL_NM UNION
                            --SELECT 'SCP_PLN_PLANT_ONHAND'          AS TBL_NM UNION
                            SELECT 'SCP_ANL_PRODUCTION_PLAN'       AS TBL_NM  ) X
                     WHERE  1=1
                     AND    X.TBL_NM =  SCM.TABLE_NAME
                     --AND    (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' ) 
                     --2025-04-18 김준규 ALL일때 제외가 동작하지 않게 모두 다 나오게 해야 해서 ALL을 제거함
                     AND    (@P_TABLE IS NULL OR @P_TABLE ='' ) 
                     )                                    
    AND  ISNULL(@P_TABLE,'') <> '3TBL'
    UNION
    SELECT SCM.TABLE_NAME
         , CUTOFF_COLUMN1
         , CUTOFF_START
         , WEEK_YN = ISNULL(WWT.WEEK_YN,'N')
         -- 2025-04-26 데이터 추출해오는 컬럼이 DATATIME에서 시간이 존재하는 3개 테이블 누락파악, 보완
         , DATE_TYPE_YN = IIF(C.DATA_TYPE IS NULL,'N','Y')
         , PLAN_TYPE_YN = ISNULL(WWT.PLAN_TYPE_YN,'N')
    FROM NERP_CONV_SCP_CUTOFF_MASTER AS SCM WITH (NOLOCK)
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS c WITH(NOLOCK)
    ON   SCM.TABLE_NAME = C.TABLE_NAME AND  C.DATA_TYPE LIKE 'DATE%' AND SCM.CUTOFF_COLUMN1 = C.COLUMN_NAME
    LEFT JOIN W_WEEK_TBL WWT
    ON   SCM.TABLE_NAME = WWT.TABLE_NAME
    JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON SCM.TABLE_NAME = CTM.TABLE_NAME
    WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
    AND   CTM.RTYPE = 'SCP'
    AND   CTM.GROUP_NUM = @P_GROUP_NUM
    AND   CTM.GROUP_COUNT = @P_GROUP_COUNT
    AND  SCM.TABLE_NAME <> 'SCM_DNM_MPP_SNAPSHOT'  --2025-W01   2025-W05
    AND  SCM.TABLE_NAME <> 'SCP_ANL_MONTH_END_STOCK_R'  --202412    202504
    AND  SCM.TABLE_NAME <> 'SCP_BI_FP_RESULT'  --202501 202505
    AND  SCM.TABLE_NAME <> 'SCM_MST_MODEL_BOM_EFFECTIVE' --BOM TABLE
    --AND  (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR SCM.TABLE_NAME = @P_TABLE) 
    AND  ISNULL(@P_TABLE,'') = '3TBL'
    AND  SCM.TABLE_NAME IN (SELECT 'SCP_ANL_SHIPMENT_PLAN_FG'      AS TBL_NM UNION
                            SELECT 'SCP_ANL_SHIPMENT_PLAN_SEMI'    AS TBL_NM UNION
                            --SELECT 'HIST_SCP_ANL_SHIPMENT_PLAN_FG' AS TBL_NM UNION
                            --SELECT 'SCP_PLN_PLANT_ONHAND'          AS TBL_NM UNION
                            SELECT 'SCP_ANL_PRODUCTION_PLAN'       AS TBL_NM  )
    ORDER BY 1

    OPEN mig_cursor

    -- MIG_TBL 커서에서 테이블 이름과 컬럼 이름 가져오기
    FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1,@WEEK_YN,@DATE_TYPE_YN,@PLAN_TYPE_YN

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- 동적 SQL 생성 및 실행

        SET @SQL_TABLE_NAME = @PreFix+@TABLE_NAME;
        INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
            TABLE_NAME
            ,START_YYYYMMDD
            ,END_YYYYMMDD
            ,CURR_DATE
        ) VALUES(
            @TABLE_NAME
            ,@V_FR_YYYYMMDD
            ,@V_TO_YYYYMMDD
            ,'ALL'
        );
        SELECT @V_SCOPE_ID = SCOPE_IDENTITY();
        --TRUNCATE 하고.
        --날짜별로 처리

        IF @P_DEL_TYPE = 'TRUNC' BEGIN
        SET @SQL = '
        TRUNCATE TABLE LGCE_SCMDEV.DBO.' + QUOTENAME(@SQL_TABLE_NAME) + ';';
            END;
        ELSE IF @P_DEL_TYPE = 'DEL' BEGIN
            SET @SQL = N'
            DELETE FROM LGCE_SCMDEV.DBO.' + QUOTENAME(@SQL_TABLE_NAME) + '
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= ''' + ISNULL(@V_FR_YYYYMMDD,'20250326') + '''
            AND   ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < ''' + ISNULL(@V_TO_YYYYMMDD,'20250326') + '''
            ; ';
            END;
        ELSE BEGIN
            PRINT CONVERT(NVARCHAR(MAX), N'@P_DEL_TYPE: '''+ISNULL(@P_DEL_TYPE,'Value is null ')+''' Please, Input Defined P_DEL_TYPE, Stop Procedure!!.');
            RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
        END;
        
        PRINT @SQL  -- 디버깅용 출력

        BEGIN TRY
            BEGIN TRANSACTION;
                EXEC sp_executesql @SQL;

                UPDATE FPP
                SET    SQL_STMT = @SQL
                      ,LAST_UPDATE_DATE = GETDATE()
                FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                WHERE  ID = @V_SCOPE_ID;

                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                    SET @DUMMY = @SQL + ',' + ERROR_MESSAGE();
                    UPDATE FPP
                    SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                          ,SQL_STMT = @DUMMY
                          ,LAST_UPDATE_DATE = GETDATE()
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
                    PRINT @DUMMY;
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END CATCH

        -- 첫 번째 커서: 날짜 조회
        -- 주차기준 날짜 FROM ~ TO 기간 사이의 월요일 주차기준으로
        -- 시작주차는 월요일이고 종료주차는 월요일에 7일을 더해서 그것 보다 작은 것으로 처리한다.
        -- END일자가 @V_TO_YYYYMMDD+1일이 Upper_Limit_Value보다 작으면 V_TO_YYYYMMDD 사용한다.
        -- 일자별 가져오는 것을 WEEKLY 구간으로 하니 데이터가져오는 시간이 더 길어져서 변경. 2025-03-26 그래서 다시 DAILY로 변경.
        DECLARE date_cursor CURSOR FOR
        --일자별 쿼리
        SELECT YYYYMMDD = BASIS_YYYYMMDD
        FROM   dbo.SCM_SYS_CALENDAR_M AS SCM WITH(NOLOCK)
        WHERE  BASIS_YYYYMMDD >= @V_FR_YYYYMMDD
        AND    BASIS_YYYYMMDD < @V_TO_YYYYMMDD
        AND    'N' = @WEEK_YN
        UNION
        --주차별 쿼리
        SELECT YYYYMMDD = BASIS_YYYYMMDD
        FROM   dbo.SCM_SYS_CALENDAR_M AS SCM WITH(NOLOCK)
        WHERE  BASIS_YYYYMMDD >= @V_FR_YYYYMMDD
        AND    BASIS_YYYYMMDD < @V_TO_YYYYMMDD
        AND    SCM.DAYOFWEEK = 'MON'
        AND    'Y' = @WEEK_YN
        ORDER BY YYYYMMDD ASC
        -- 커서 열기
        OPEN date_cursor

        -- 날짜 커서에서 데이터를 가져와서 처리
        FETCH NEXT FROM date_cursor INTO @YYYYMMDD

        WHILE @@FETCH_STATUS = 0
        BEGIN

            IF @PLAN_TYPE_YN = 'N'
            BEGIN
                INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
                    TABLE_NAME
                    ,START_YYYYMMDD
                    ,END_YYYYMMDD
                    ,CURR_DATE
                ) VALUES(
                     @TABLE_NAME
                    ,@V_FR_YYYYMMDD
                    ,@V_TO_YYYYMMDD
                    ,@YYYYMMDD+'|'+@WEEK_YN+'|'+@PLAN_TYPE_YN
                );
                SELECT @V_SCOPE_ID = SCOPE_IDENTITY();
                SET @SQL = N'
            INSERT INTO ' + QUOTENAME(@SQL_TABLE_NAME) + N'';
                SET @SQL += N'
            SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
            ''SELECT *
            FROM '+ @DBPrefix + QUOTENAME(@TABLE_NAME) + ' WITH(NOLOCK)';
                IF @DATE_TYPE_YN = 'N' --날짜가 DATETIME 형태아닌 VARCHAR 타입
                BEGIN
                    SET @SQL = @SQL+N'
            --데일리로 다시 변경함 -- 2023-03-26 주차로 변경
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' = ''''' + @YYYYMMDD + ''''' '')';
                END; 
                ELSE --날짜가 DATETIME --> DATE,DATETIME,DATETIME2 타입
                BEGIN 
                    SET @SQL = @SQL+N'
            --날짜가 DATE 타입이라서 구간처리 필요
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= ''''' + ISNULL(@YYYYMMDD,'20250326') + '''''
            AND   ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < ''''' + ISNULL(FORMAT(DATEADD(day, 1, CONVERT(date, @YYYYMMDD)), 'yyyyMMdd'),'20250326') + ''''' '')';
                END;
                SET @SQL = @SQL+N'
            --주차로 변경하니 데일리보다 시간이 오래걸려서 다시 일자로 처리함
            --WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= ''''' + ISNULL(@START_YYYYMMDD,'20250326') + '''''
            --AND   ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < ''''' + ISNULL(@Upper_Limit_Value,'20250326') + ''''' '')';
                SET @SQL = @SQL+N'
            SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
            ';

                PRINT @SQL  -- 디버깅용 출력

                BEGIN TRY
                    BEGIN TRANSACTION;
                        EXEC sp_executesql @SQL, 
                             N'@V_ROWS_AFFECTED_OUT BIGINT OUTPUT',
                             @V_ROWS_AFFECTED_OUT = @V_ROWS_INSERTED OUTPUT;
    
                        UPDATE FPP
                        SET    INSERTED_ROWCNT = @V_ROWS_INSERTED
                              ,LAST_UPDATE_DATE = GETDATE()
                              ,SQL_STMT = @SQL
                        FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                        WHERE  ID = @V_SCOPE_ID;

                        CHECKPOINT
                        WAITFOR DELAY '00:00:00.1'

                    COMMIT TRANSACTION;
                END TRY
                BEGIN CATCH
                    IF @@TRANCOUNT > 0
                        ROLLBACK TRANSACTION;
                        SET @DUMMY = @SQL + ',' + ERROR_MESSAGE();
                        UPDATE FPP
                        SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                              ,SQL_STMT = @DUMMY
                              ,LAST_UPDATE_DATE = GETDATE()
                        FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                        WHERE  ID = @V_SCOPE_ID;
                        PRINT @DUMMY;
                        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @SQL_TABLE_NAME, @v_description, @d_event_date;

                    CHECKPOINT
                    WAITFOR DELAY '00:00:00.1'

                END CATCH
            END;
            ELSE IF @PLAN_TYPE_YN = 'Y'
            BEGIN
                
                DECLARE @PLAN_TYPE NVARCHAR(10);

                DECLARE cur_PLAN_TYPE CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
                	SELECT token AS PLAN_TYPE
                	FROM STRING_SPLIT('FN,MA,PR,SE',',')
                
                OPEN cur_PLAN_TYPE
                
                FETCH NEXT FROM cur_PLAN_TYPE INTO @PLAN_TYPE
                
                WHILE @@FETCH_STATUS = 0 BEGIN
                
                    INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
                        TABLE_NAME
                        ,START_YYYYMMDD
                        ,END_YYYYMMDD
                        ,CURR_DATE
                    ) VALUES(
                         @TABLE_NAME
                        ,@V_FR_YYYYMMDD
                        ,@V_TO_YYYYMMDD
                        ,@YYYYMMDD+'|'+@WEEK_YN+'|'+@PLAN_TYPE
                    );
                    SELECT @V_SCOPE_ID = SCOPE_IDENTITY();
                    SET @SQL = N'
            INSERT INTO ' + QUOTENAME(@SQL_TABLE_NAME) + N'';
                    SET @SQL += N'
            SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
            ''SELECT *
            FROM '+ @DBPrefix + QUOTENAME(@TABLE_NAME) + ' WITH(NOLOCK)';
                    IF @DATE_TYPE_YN = 'N' --날짜가 DATETIME 형태아닌 VARCHAR 타입
                    BEGIN
                        SET @SQL = @SQL+N'
            --데일리로 다시 변경함 -- 2023-03-26 주차로 변경
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' = ''''' + @YYYYMMDD + '''''
            AND   ' + QUOTENAME('PLAN_TYPE') + ' = ''''' + @PLAN_TYPE + ''''' '')';
                    END; 
                    ELSE --날짜가 DATETIME --> DATE,DATETIME,DATETIME2 타입
                    BEGIN 
                        SET @SQL = @SQL+N'
            --날짜가 DATE 타입이라서 구간처리 필요
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= ''''' + ISNULL(@YYYYMMDD,'20250326') + '''''
            AND   ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < ''''' + ISNULL(FORMAT(DATEADD(day, 1, CONVERT(date, @YYYYMMDD)), 'yyyyMMdd'),'20250326') + ''''' '')
            AND   ' + QUOTENAME('PLAN_TYPE') + ' = ''''' + @PLAN_TYPE + '''''; ';
                    END;
                    SET @SQL = @SQL+N'
            --주차로 변경하니 데일리보다 시간이 오래걸려서 다시 일자로 처리함
            --WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= ''''' + ISNULL(@START_YYYYMMDD,'20250326') + '''''
            --AND   ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < ''''' + ISNULL(@Upper_Limit_Value,'20250326') + ''''' '')';
                    SET @SQL = @SQL+N'
            SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
            ';


                    PRINT @SQL  -- 디버깅용 출력
    
                    BEGIN TRY
                        BEGIN TRANSACTION;
                            EXEC sp_executesql @SQL, 
                                 N'@V_ROWS_AFFECTED_OUT BIGINT OUTPUT',
                                 @V_ROWS_AFFECTED_OUT = @V_ROWS_INSERTED OUTPUT;
        
                            UPDATE FPP
                            SET    INSERTED_ROWCNT = @V_ROWS_INSERTED
                                  ,LAST_UPDATE_DATE = GETDATE()
                                  ,SQL_STMT = @SQL
                            FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                            WHERE  ID = @V_SCOPE_ID;
    
                            CHECKPOINT
                            WAITFOR DELAY '00:00:00.1'
    
                        COMMIT TRANSACTION;
                    END TRY
                    BEGIN CATCH
                        IF @@TRANCOUNT > 0
                            ROLLBACK TRANSACTION;
                            SET @DUMMY = @SQL + ',' + ERROR_MESSAGE();
                            UPDATE FPP
                            SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                                  ,SQL_STMT = @DUMMY
                                  ,LAST_UPDATE_DATE = GETDATE()
                            FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                            WHERE  ID = @V_SCOPE_ID;
                            PRINT @DUMMY;
                            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @SQL_TABLE_NAME, @v_description, @d_event_date;

                        CHECKPOINT
                        WAITFOR DELAY '00:00:00.1'

                    END CATCH                	
                
                	FETCH NEXT FROM cur_PLAN_TYPE INTO @PLAN_TYPE
                
                END
                
                CLOSE cur_PLAN_TYPE
                DEALLOCATE cur_PLAN_TYPE

            END;
            -- 다음 날짜 데이터 가져오기
            FETCH NEXT FROM date_cursor INTO @YYYYMMDD
        END

        -- 커서 닫기 및 해제
        CLOSE date_cursor
        DEALLOCATE date_cursor

        -- 다음 MIG_TBL 데이터 가져오기
        FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1,@WEEK_YN,@DATE_TYPE_YN,@PLAN_TYPE_YN
    END

    -- MIG_TBL 커서 닫기 및 해제
    CLOSE mig_cursor
    DEALLOCATE mig_cursor

    SET @BATCH_END_TIME = SYSDATETIME();
    SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
    PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, 'RUN_TIME',  'END, RUN_TIME ', @BATCH_END_TIME;


END TRY
BEGIN CATCH
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
        PRINT 'ERROR'
        PRINT ERROR_MESSAGE();


END CATCH

END
