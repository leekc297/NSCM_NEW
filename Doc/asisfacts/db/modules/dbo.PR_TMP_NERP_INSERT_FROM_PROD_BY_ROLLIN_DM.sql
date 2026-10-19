


-- ==========================================================================================
-- Program:      PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM
-- Author:       김준규
-- Create date:  2025-04-27
-- Description:  NERP) BIG Table  데이터 가져오기
-- How to Execute: EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM 'ALL', '20250101','20250131'
--                  @V_FR_YYYYMMDD 가져오는 시작일자 포함됨
--                  @V_TO_YYYYMMDD 가져오는 끝나는일자 포함됨 --> 마지막일자 보다 작은 것으로 변경(전체 통일)
/*

DECLARE @V_FR_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 FR_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='DM' AND ROLLIN='2ND' ORDER BY RTYPE_NUM DESC);
DECLARE @V_TO_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 TO_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='DM' AND ROLLIN='2ND' ORDER BY RTYPE_NUM DESC);
--EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM @P_TABLE='',@V_FR_YYYYMMDD=@V_FR_YYYYMMDD,@V_TO_YYYYMMDD=@V_TO_YYYYMMDD;
EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM @P_TABLE='DM_PLN_SALES_PLAN_REPORT_C',@V_FR_YYYYMMDD=@V_FR_YYYYMMDD,@V_TO_YYYYMMDD=@V_TO_YYYYMMDD;
EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM @P_TABLE='DM_PLN_SALES_PLAN_REPORT_C',@P_ROLLIN='3RD',@P_RTYPE_NUM = 99999,@P_DEL_TYPE='TRUNC';
EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM @P_TABLE = 'ALL',@P_ROLLIN='4TH',@P_RTYPE_NUM=99999,@P_GROUP_NUM=1,@P_GROUP_COUNT=4;
EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM @P_TABLE = 'ALL',@P_ROLLIN='4TH',@P_RTYPE_NUM=99999,@P_GROUP_NUM=3,@P_GROUP_COUNT=4;
EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM @P_TABLE = 'DM_PLN_SALES_ETC_PLAN_C',@P_ROLLIN='4TH',@P_RTYPE_NUM=99999,@P_GROUP_NUM=3,@P_GROUP_COUNT=4;


*/
-- ==========================================================================================
-- 2025-04-27       김준규       PR_SCP_NERP_COLUMN_CONVERTER_INSERT_FROM_PROD_DAILY_PERIOD 카피해서 DM 용 변경
-- 2025-06-08       김준규       NERP) 에러 발생시 DROP_NERP_CONV_INS_FR_PROD_PROG 테이블에도 기록
-- 2025-07-13       김준규       NERP) 프로그램 이름 변경 및 PARAMETER 일자를 ROLLIN으로 변경하고, DEL과 TRUNC 입력변수를 받음
-- 2025-08-11       김준규       NERP) OPENQUERY 형식으로 변경
-- 2025-09-09       김준규       NERP) ZNERP_TARGET_INFO_CURRENCY_DM TABLE 추가
-- 2025-09-11       김준규       NERP) ZNERP_TARGET_INFO_CURRENCY_DM TABLE 제외 --> 기존테이블에 MAPPING 추가로 처리
-- 2025-10-15       김준규       NERP) 작업분배 방식 사용, 사용기간 선택 추가.
-- 2025-10-15       김준규       NERP) DELETE INSERT 방식으로 변경.
-- 2025-10-15       김준규       NERP) 입력변수 추가 @P_DEL_TYPE nvarchar(30)='TRUNC' --TRUNC:TRUNCATE,DEL:DELETE
---------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM]
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
    DECLARE @V_FR_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 FR_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='DM' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);
    DECLARE @V_TO_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 TO_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='DM' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);
    DECLARE @LinkedServerName NVARCHAR(254) = '10.34.220.85,7433';
    DECLARE @DBPrefix NVARCHAR(254) = '[LGCE_SCMPROD].[DBO].';-- LINKED_SERVER 운영DB 사용

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_DM';
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
    SET @v_description = '@P_TABLE:'+@P_TABLE+'@P_ROLLIN:'+@P_ROLLIN+',@P_RTYPE_NUM='+CONVERT(CHAR(23),@P_RTYPE_NUM)+',@P_GROUP_NUM='+CONVERT(CHAR(23),@P_GROUP_NUM)+',@P_GROUP_COUNT='+CONVERT(CHAR(23),@P_GROUP_COUNT)+',@P_DEL_TYPE:'+@P_DEL_TYPE;
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
    DECLARE @C_COLUMNLIST NVARCHAR(MAX)
    DECLARE @CUTOFF_COLUMN1 VARCHAR(128)
    DECLARE @DUMMY1 VARCHAR(128)
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @RN NVARCHAR(10)
    DECLARE @WEEK_YN NVARCHAR(1)
    DECLARE @DATE_TYPE_YN NVARCHAR(1)    
    DECLARE @C_IS_IDENTITY_YN NVARCHAR(1)
    DECLARE @PLAN_TYPE_YN NVARCHAR(1)   
    DECLARE @C_IS_PERSISTED_YN NVARCHAR(1)
    
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
        SELECT 'Y' AS WEEK_YN,TRIM('DM_PLN_MKT_FCST_C              ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,TRIM('DM_PLN_MKT_FCST_C              ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,TRIM('DM_PLN_MKT_FCST_C              ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,TRIM('DM_PLN_MKT_FCST_C              ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,TRIM('DM_PLN_MKT_FCST_RESULT_C       ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,TRIM('DM_PLN_MKT_FCST_C              ') AS TABLE_NAME UNION
        SELECT 'Y' AS WEEK_YN,TRIM('DM_PLN_CFM_MKT_DEMAND_PLAN_C   ') AS TABLE_NAME 
    )
    , W_TBL AS (
        SELECT SCM.TABLE_NAME
              ,CUTOFF_COLUMN1
              ,CUTOFF_START
              ,MAPPING_USE
        FROM   NERP_CONV_DM_CUTOFF_MASTER AS SCM WITH (NOLOCK)
        JOIN   NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON SCM.TABLE_NAME = CTM.TABLE_NAME
        WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
        AND   CTM.RTYPE = 'DM'
        AND   CTM.GROUP_NUM = @P_GROUP_NUM
        AND   CTM.GROUP_COUNT = @P_GROUP_COUNT
        --UNION
        --SELECT ICD.TABLE_NAME
        --      ,'CUTOFF_YYYYMMDD' AS CUTOFF_COLUMN1
        --      ,NULL AS CUTOFF_START --'20250901'
        --      ,'Y'  AS MAPPING_USE
        --FROM   ZNERP_TARGET_INFO_CURRENCY_DM ICD WITH(NOLOCK)
        --WHERE  VALID_YN = 'Y'
        --AND    DATA_SIZE = 'BIG'
    )
    SELECT SCM.TABLE_NAME
         , CUTOFF_COLUMN1
         , CUTOFF_START
         , WEEK_YN = ISNULL(WWT.WEEK_YN,'N')
         -- 2025-04-26 데이터 추출해오는 컬럼이 DATATIME에서 시간이 존재하는 3개 테이블 누락파악, 보완
         , DATE_TYPE_YN = IIF(C.DATA_TYPE IS NULL,'N','Y')
         , IIF(IDE.TBL_NM IS NOT NULL, 'Y','N') IS_IDENTITY_YN 
         , IIF(PER.TBL_NM IS NOT NULL, 'Y','N') IS_PERSISTED_YN 
    --FROM NERP_CONV_DM_CUTOFF_MASTER AS SCM WITH (NOLOCK)
    FROM W_TBL AS SCM WITH (NOLOCK)
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS c WITH(NOLOCK)
    ON   SCM.TABLE_NAME = C.TABLE_NAME AND  C.DATA_TYPE LIKE 'DATE%' AND SCM.CUTOFF_COLUMN1 = C.COLUMN_NAME
    LEFT JOIN W_WEEK_TBL WWT
    ON   SCM.TABLE_NAME = WWT.TABLE_NAME
    LEFT JOIN ( SELECT t.name AS TBL_NM,max(c.name) AS colnumn_name
                FROM   sys.tables t WITH(NOLOCK)
                JOIN   sys.columns c WITH(NOLOCK) ON t.object_id = c.object_id
                WHERE  c.is_identity = 1
                GROUP BY t.name
              ) AS IDE
    ON SCM.TABLE_NAME = IDE.TBL_NM
    LEFT JOIN ( SELECT t.name AS TBL_NM,max(c.name) AS colnumn_name
                FROM   sys.tables t WITH(NOLOCK)
                JOIN   sys.computed_columns c WITH(NOLOCK) ON t.object_id = c.object_id
                WHERE  c.is_persisted = 1
                GROUP BY t.name
              ) AS PER
    ON SCM.TABLE_NAME = PER.TBL_NM
    WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
    AND  (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR SCM.TABLE_NAME = @P_TABLE) 
    ORDER BY 1

    OPEN mig_cursor

    -- MIG_TBL 커서에서 테이블 이름과 컬럼 이름 가져오기
    FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1,@WEEK_YN,@DATE_TYPE_YN,@C_IS_IDENTITY_YN,@C_IS_PERSISTED_YN

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
            SET @SQL = '
            DELETE FROM LGCE_SCMDEV.DBO.' + QUOTENAME(@SQL_TABLE_NAME) + '
            WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= ''' + ISNULL(@V_FR_YYYYMMDD,'20250326') + '''
            AND   ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < ''' + ISNULL(@V_TO_YYYYMMDD,'20250326') + '''; ';
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
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @TABLE_NAME, @v_description, @d_event_date;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END CATCH


        IF @C_IS_PERSISTED_YN = 'Y' BEGIN
            -- 테이블의 전체 컬럼 목록 가져오기
            SELECT @C_COLUMNLIST = STRING_AGG(QUOTENAME(c.name), ', ')
            FROM sys.columns c WITH(NOLOCK)
            WHERE c.object_id = OBJECT_ID(@TABLE_NAME)
            -- 가상필드 제외
            AND   c.is_computed = 0;

            -- 컬럼 정보 출력
            PRINT 'Processing table: ' + @TABLE_NAME
            PRINT 'Columns: ' + @C_COLUMNLIST

        END;

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

            INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
                TABLE_NAME
                ,START_YYYYMMDD
                ,END_YYYYMMDD
                ,CURR_DATE
            ) VALUES(
                 @TABLE_NAME
                ,@V_FR_YYYYMMDD
                ,@V_TO_YYYYMMDD
                ,@YYYYMMDD+'|'+@WEEK_YN+'|'+@C_IS_PERSISTED_YN
            );
            SELECT @V_SCOPE_ID = SCOPE_IDENTITY();
            
        IF @C_IS_PERSISTED_YN = 'Y' BEGIN               
            SET @SQL = N'
            INSERT INTO ' + QUOTENAME(@SQL_TABLE_NAME) + ' (' + @C_COLUMNLIST + ') ' ;
                SET @SQL += N'
            SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
            ''SELECT ' + @C_COLUMNLIST + '
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
                        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @TABLE_NAME, @v_description, @d_event_date;

                    CHECKPOINT
                    WAITFOR DELAY '00:00:00.1'

                END CATCH
            END;
        --@C_IS_PERSISTED_YN = 'N' 상태
        ELSE BEGIN            

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
            AND   ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < ''''' + ISNULL(FORMAT(DATEADD(day, 1, CONVERT(date, @YYYYMMDD)), 'yyyyMMdd'),'20250326') + ''''' '') ''; ';
            END;
            SET @SQL = @SQL+N'
            --주차로 변경하니 데일리보다 시간이 오래걸려서 다시 일자로 처리함
            --WHERE ' + QUOTENAME(@CUTOFF_COLUMN1) + ' >= ''''' + ISNULL(@START_YYYYMMDD,'20250326') + '''''
            --AND   ' + QUOTENAME(@CUTOFF_COLUMN1) + ' < ''''' + ISNULL(@Upper_Limit_Value,'20250326') + ''''' '')';
            SET @SQL = @SQL+N'
            SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
            '
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
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @TABLE_NAME, @v_description, @d_event_date;

                        CHECKPOINT
                        WAITFOR DELAY '00:00:00.1'

            END CATCH

            -- 다음 날짜 데이터 가져오기
            FETCH NEXT FROM date_cursor INTO @YYYYMMDD
        END

        -- 커서 닫기 및 해제
        CLOSE date_cursor
        DEALLOCATE date_cursor

        -- 다음 MIG_TBL 데이터 가져오기
        FETCH NEXT FROM mig_cursor INTO @TABLE_NAME, @CUTOFF_COLUMN1,@DUMMY1,@WEEK_YN,@DATE_TYPE_YN,@C_IS_IDENTITY_YN,@C_IS_PERSISTED_YN
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
